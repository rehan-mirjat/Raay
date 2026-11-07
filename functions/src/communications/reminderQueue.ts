import { createHash, randomUUID } from 'crypto';
import { FieldValue, Firestore, getFirestore, Timestamp } from 'firebase-admin/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { logger } from 'firebase-functions';
import { requireActiveMembership, requireNotRevoked, requireOperationalOrganization } from '../utils/authorization';
import { getEligibleMembers } from '../results/tally';
import { CALLABLE_OPTIONS, enforceRateLimit, parseMillis, rejectUnknownKeys, requireAuth, requireId, writeAudit } from '../voting_events/votingCommon';

const LEASE_MS = 5 * 60 * 1000;
const MAX_ATTEMPTS = 5;
const CHUNK = 50;
const hash = (value: unknown) => createHash('sha256').update(JSON.stringify(value)).digest('hex');

/** External channels remain unavailable until a real provider is configured. */
export const manageReminderJob = onCall(CALLABLE_OPTIONS, async request => {
  const uid = requireAuth(request);
  await requireNotRevoked(request);
  const d = request.data || {};
  if (!['schedule', 'cancel'].includes(d.action)) throw new HttpsError('invalid-argument', 'Choose schedule or cancel.');
  rejectUnknownKeys(d, d.action === 'schedule' ? ['action', 'eventId', 'scheduledAt', 'channel', 'requestId'] : ['action', 'jobId'], 'manageReminderJob');
  if (d.action === 'schedule' && d.channel !== 'IN_APP') throw new HttpsError('failed-precondition', 'External email/SMS delivery is not configured. Only in-app reminders are available.');
  const db = getFirestore();
  await enforceRateLimit(db, uid, 'manageReminderJob', 30, 3600000);
  const jobId = d.action === 'cancel' ? requireId(d.jobId, 'jobId') : hash([uid, requireId(d.requestId, 'requestId')]);
  const jobRef = db.collection('communicationJobs').doc(jobId);
  return db.runTransaction(async tx => {
    const existing = await tx.get(jobRef);
    if (d.action === 'cancel' && !existing.exists) throw new HttpsError('not-found', 'Reminder job not found.');
    const eventId = d.action === 'cancel' ? existing.data()!.votingEventId : requireId(d.eventId, 'eventId');
    const event = await tx.get(db.collection('votingEvents').doc(eventId));
    const ev = event.data();
    if (!ev) throw new HttpsError('not-found', 'Election not found.');
    const organizationId = ev.organizationId as string;
    await requireActiveMembership(db, organizationId, uid, ['owner', 'admin'], { tx });
    await requireOperationalOrganization(db, organizationId, tx);
    if (d.action === 'cancel') {
      if (existing.data()?.status !== 'QUEUED') throw new HttpsError('failed-precondition', 'Only queued jobs can be cancelled. Processing jobs may already have created notifications.');
      tx.update(jobRef, { status: 'CANCELLED', updatedAt: FieldValue.serverTimestamp(), cancelledBy: uid });
    } else {
      const time = parseMillis(d.scheduledAt, 'scheduledAt');
      if (existing.exists) {
        const old = existing.data()!;
        if (old.createdBy !== uid || old.votingEventId !== eventId || (old.requestedAt ?? old.scheduledAt).toMillis() !== time) throw new HttpsError('already-exists', 'Request ID was used for another reminder.');
        return { status: 'success', jobId };
      }
      if (!['ACTIVE', 'SCHEDULED'].includes(ev.status) || time < Date.now() - 1000 || time < ev.startAt.toMillis() || time >= ev.endAt.toMillis()) throw new HttpsError('failed-precondition', 'Schedule reminders within a published election’s voting window.');
      const pending = await tx.get(db.collection('communicationJobs').where('organizationId', '==', organizationId).where('status', 'in', ['QUEUED', 'PROCESSING']).limit(20));
      if (pending.size >= 20) throw new HttpsError('resource-exhausted', 'This organization already has 20 pending reminder jobs.');
      tx.create(jobRef, { organizationId, votingEventId: eventId, eventTitle: ev.title, channel: 'IN_APP',
        audience: 'ELIGIBLE_NON_VOTERS', status: 'QUEUED', scheduledAt: Timestamp.fromMillis(time), requestedAt: Timestamp.fromMillis(time),
        createdBy: uid, createdAt: FieldValue.serverTimestamp(), updatedAt: FieldValue.serverTimestamp(), attempts: 0, notificationCount: 0 });
    }
    writeAudit(tx, db, { organizationId, actorUid: uid, action: d.action === 'cancel' ? 'CANCEL_REMINDER_JOB' : 'SCHEDULE_REMINDER_JOB', resourceType: 'communicationJob', resourceId: jobId, metadata: { eventId, channel: 'IN_APP' } });
    return { status: 'success', jobId };
  });
});

/** Lease ownership and notification existence are checked transactionally on every chunk.
 * A retry never resets an existing notification's read state or exposes recipient UIDs to managers.
 */
export async function processReminderJob(db: Firestore, jobId: string): Promise<void> {
  const jobRef = db.collection('communicationJobs').doc(jobId);
  const leaseId = randomUUID();
  const claim = await db.runTransaction(async tx => {
    const snap = await tx.get(jobRef);
    const job = snap.data();
    if (!job || !['QUEUED', 'PROCESSING'].includes(job.status) || job.scheduledAt.toMillis() > Date.now()) return null;
    if (job.status === 'PROCESSING' && job.leaseUntil?.toMillis() > Date.now()) return null;
    if (job.attempts >= MAX_ATTEMPTS) { tx.update(jobRef, { status: 'FAILED', updatedAt: FieldValue.serverTimestamp() }); return null; }
    tx.update(jobRef, { status: 'PROCESSING', leaseId, leaseUntil: Timestamp.fromMillis(Date.now() + LEASE_MS), attempts: FieldValue.increment(1), updatedAt: FieldValue.serverTimestamp() });
    return job;
  });
  if (!claim) return;
  try {
    const eventRef = db.collection('votingEvents').doc(claim.votingEventId);
    const ev = (await eventRef.get()).data();
    if (!ev || ev.organizationId !== claim.organizationId || ev.status !== 'ACTIVE' || ev.endAt.toMillis() <= Date.now()) throw new Error('ELECTION_UNAVAILABLE');
    const members = (await getEligibleMembers(db, claim.organizationId, claim.votingEventId, ev)).filter(m => m.active !== false);
    for (let offset = 0; offset < members.length; offset += CHUNK) {
      const slice = members.slice(offset, offset + CHUNK);
      await db.runTransaction(async tx => {
        const job = (await tx.get(jobRef)).data();
        if (job?.leaseId !== leaseId || job.status !== 'PROCESSING') throw new Error('LEASE_LOST');
        const currentEvent = (await tx.get(eventRef)).data();
        if (!currentEvent || currentEvent.status !== 'ACTIVE' || currentEvent.endAt.toMillis() <= Date.now()) throw new Error('ELECTION_UNAVAILABLE');
        await requireActiveMembership(db, claim.organizationId, claim.createdBy, ['owner', 'admin'], { tx });
        await requireOperationalOrganization(db, claim.organizationId, tx);
        const actor = await tx.get(db.collection('users').doc(claim.createdBy));
        if (actor.data()?.status !== 'active') throw new Error('CREATOR_INACTIVE');
        const refs = slice.flatMap(m => [
          db.collection('notifications').doc(hash([jobId, m.userId])),
          db.collection('users').doc(m.userId),
          db.collection('organizationMembers').doc(`${claim.organizationId}_${m.userId}`),
          db.collection('participation').doc(`${claim.organizationId}_${claim.votingEventId}_${m.userId}`),
        ]);
        const records = await tx.getAll(...refs);
        let created = 0;
        slice.forEach((m, index) => {
          const [notification, profile, member, participation] = records.slice(index * 4, index * 4 + 4);
          const membership = member.data();
          if (notification.exists || participation.exists || profile.data()?.status !== 'active' || profile.data()?.notificationPreferences?.voteReminders === false || membership?.status !== 'active' || membership.organizationId !== claim.organizationId || membership.userId !== m.userId) return;
          tx.create(notification.ref, { userId: m.userId, organizationId: claim.organizationId, type: 'VOTE_REMINDER', title: "Don't forget to vote", message: `"${String(currentEvent.title)}" is still open. Cast your ballot before it closes.`, votingEventId: claim.votingEventId, createdAt: FieldValue.serverTimestamp(), read: false });
          created++;
        });
        tx.update(jobRef, { notificationCount: FieldValue.increment(created), leaseUntil: Timestamp.fromMillis(Date.now() + LEASE_MS), updatedAt: FieldValue.serverTimestamp() });
      });
    }
    await db.runTransaction(async tx => {
      const current = (await tx.get(jobRef)).data();
      if (current?.leaseId === leaseId && current.status === 'PROCESSING') {
        tx.update(jobRef, { status: 'COMPLETED', completedAt: FieldValue.serverTimestamp(), leaseId: FieldValue.delete(), leaseUntil: FieldValue.delete(), updatedAt: FieldValue.serverTimestamp() });
        writeAudit(tx, db, { organizationId: claim.organizationId, actorUid: 'SYSTEM_REMINDER_QUEUE', action: 'COMPLETE_REMINDER_JOB', resourceType: 'communicationJob', resourceId: jobId, metadata: { notificationCount: current.notificationCount } });
      }
    });
  } catch (error) {
    logger.error('Reminder job did not complete', { jobId, error });
    await db.runTransaction(async tx => {
      const current = (await tx.get(jobRef)).data();
      if (current?.leaseId !== leaseId || current.status !== 'PROCESSING') return;
      const terminal = error instanceof HttpsError || (error instanceof Error && ['ELECTION_UNAVAILABLE', 'CREATOR_INACTIVE'].includes(error.message)) || current.attempts >= MAX_ATTEMPTS;
      tx.update(jobRef, { status: terminal ? 'FAILED' : 'QUEUED', scheduledAt: Timestamp.fromMillis(Date.now() + 60000 * current.attempts), lastError: terminal ? 'ELECTION_OR_ACCESS_UNAVAILABLE' : 'RETRY_PENDING', leaseId: FieldValue.delete(), leaseUntil: FieldValue.delete(), updatedAt: FieldValue.serverTimestamp() });
    });
  }
}

export const dispatchReminderJobs = onSchedule({ schedule: 'every 1 minutes', timeoutSeconds: 300, maxInstances: 1 }, async () => {
  const db = getFirestore();
  const [queued, expired] = await Promise.all([
    db.collection('communicationJobs').where('status', '==', 'QUEUED').where('scheduledAt', '<=', Timestamp.now()).limit(5).get(),
    db.collection('communicationJobs').where('status', '==', 'PROCESSING').where('leaseUntil', '<=', Timestamp.now()).limit(5).get(),
  ]);
  for (const job of [...queued.docs, ...expired.docs]) await processReminderJob(db, job.id);
});
