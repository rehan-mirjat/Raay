import { parseBallotRules } from '../utils/ballotRules';
import { randomUUID } from 'crypto';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { HttpsError, onCall } from 'firebase-functions/v2/https';
import { requireActiveMembership, requireMfaVerified, requireNotRevoked, requireRecentAuthentication } from '../utils/authorization';
import { CALLABLE_OPTIONS, enforceRateLimit, loadEventAsAdmin, rejectUnknownKeys, requireAuth, requireId, requiredString, writeAudit } from '../voting_events/votingCommon';
import { approvalFingerprint, ApprovalStage, launchApprovalContent, resultApprovalContent } from './approvalPolicy';

export const manageElectionApproval = onCall(CALLABLE_OPTIONS, async request => {
  const uid = requireAuth(request); await requireNotRevoked(request); requireRecentAuthentication(request.auth); await requireMfaVerified(request.auth);
  const d = request.data || {};
  if (!['configure','configureRules','request','approve','reject'].includes(d.action)) throw new HttpsError('invalid-argument', 'Unsupported approval action.');
  rejectUnknownKeys(d, d.action === 'configureRules' ? ['action','eventId','quorumPercent','allowAbstain'] : d.action === 'configure' ? ['action','eventId','enabled'] : ['action','eventId','stage','requestId','reason'], 'manageElectionApproval');
  const eventId = requireId(d.eventId, 'eventId');
  const stage = d.stage as ApprovalStage;
  if (!['configure','configureRules'].includes(d.action) && !['LAUNCH','RESULTS'].includes(stage)) throw new HttpsError('invalid-argument', 'Choose launch or results approval.');
  const db = getFirestore(); await enforceRateLimit(db, uid, 'manageElectionApproval');
  return db.runTransaction(async tx => {
    const { ref, data: ev, organizationId } = await loadEventAsAdmin(tx, db, eventId, uid, 'manage election approvals');
    const actor = await tx.get(db.collection('users').doc(uid));
    if (actor.data()?.status !== 'active') throw new HttpsError('permission-denied', 'An active account is required.');
    if (d.action === 'configureRules') {
      if (ev.status !== 'DRAFT') throw new HttpsError('failed-precondition', 'Voting rules can only change in a draft.');
      const rules = parseBallotRules(d);
      tx.update(ref, { ...rules, updatedAt: FieldValue.serverTimestamp() });
      writeAudit(tx, db, { organizationId, actorUid: uid, action: 'CONFIGURE_BALLOT_RULES', resourceType: 'votingEvent', resourceId: eventId, metadata: rules });
      return { status: 'success' };
    }
    if (d.action === 'configure') {
      await requireActiveMembership(db, organizationId, uid, ['owner'], { tx });
      if (ev.status !== 'DRAFT' || typeof d.enabled !== 'boolean') throw new HttpsError('failed-precondition', 'Only the owner can configure approval policy while the event is a draft.');
      if (d.enabled) {
        const managers = await tx.get(db.collection('organizationMembers').where('organizationId','==',organizationId).where('status','==','active').where('role','in',['owner','admin']).limit(2));
        if (managers.size < 2) throw new HttpsError('failed-precondition', 'Add a second active manager before enabling independent approvals.');
      }
      tx.update(ref, { independentApprovalRequired: d.enabled, updatedAt: FieldValue.serverTimestamp() });
      writeAudit(tx, db, { organizationId, actorUid: uid, action: 'CONFIGURE_ELECTION_APPROVAL', resourceType: 'votingEvent', resourceId: eventId, metadata: { enabled: d.enabled } });
      return { status: 'success' };
    }
    if (ev.independentApprovalRequired !== true) throw new HttpsError('failed-precondition', 'Independent approval policy is not enabled.');
    if ((stage === 'LAUNCH' && ev.status !== 'DRAFT') || (stage === 'RESULTS' && !['CLOSED','ARCHIVED'].includes(ev.status))) throw new HttpsError('failed-precondition', 'This approval stage is not available for the election status.');
    let content;
    if (stage === 'LAUNCH') content = await launchApprovalContent(tx, db, eventId, ev);
    else {
      const results = (await tx.get(db.collection('eventResults').doc(eventId))).data();
      if (!results || results.organizationId !== organizationId || results.published === true) throw new HttpsError('failed-precondition', 'Calculate unpublished results before requesting approval.');
      content = resultApprovalContent(results);
    }
    const fingerprint = approvalFingerprint(ev, stage, content);
    const approvalRef = db.collection('electionApprovals').doc(`${eventId}_${stage}`);
    const previous = (await tx.get(approvalRef)).data();
    if (d.action === 'request') {
      // An identical pending/approved request by this requester is safe to retry.
      if (previous?.requestedBy === uid && previous.fingerprint === fingerprint && ['PENDING','APPROVED'].includes(previous.status)) return { status: 'success', requestId: previous.requestId };
      const requestId = randomUUID();
      tx.set(approvalRef, { organizationId, votingEventId: eventId, stage, requestId, fingerprint, status: 'PENDING', requestedBy: uid, requestedAt: FieldValue.serverTimestamp() });
      writeAudit(tx, db, { organizationId, actorUid: uid, action: 'REQUEST_ELECTION_APPROVAL', resourceType: 'votingEvent', resourceId: eventId, metadata: { stage, requestId, fingerprint } });
      return { status: 'success', requestId };
    }
    if (!previous || previous.status !== 'PENDING' || previous.requestId !== requireId(d.requestId,'requestId') || previous.fingerprint !== fingerprint) throw new HttpsError('failed-precondition', 'The pending approval version changed. Request a fresh review.');
    if (previous.requestedBy === uid) throw new HttpsError('permission-denied', 'You cannot review your own approval request.');
    await requireActiveMembership(db, organizationId, previous.requestedBy, ['owner','admin'], { tx });
    const reason = d.action === 'reject' ? requiredString(d.reason, 'Rejection reason', 1, 500) : '';
    tx.update(approvalRef, { status: d.action === 'approve' ? 'APPROVED' : 'REJECTED', reviewedBy: uid, reviewedAt: FieldValue.serverTimestamp(), reason });
    writeAudit(tx, db, { organizationId, actorUid: uid, action: d.action === 'approve' ? 'APPROVE_ELECTION_VERSION' : 'REJECT_ELECTION_VERSION', resourceType: 'votingEvent', resourceId: eventId, metadata: { stage, requestId: previous.requestId, fingerprint } });
    return { status: 'success', requestId: previous.requestId };
  });
});
