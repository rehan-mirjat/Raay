import { createHash } from 'crypto';
import { DocumentData, Firestore, Transaction } from 'firebase-admin/firestore';
import { HttpsError } from 'firebase-functions/v2/https';
import { requireActiveMembership } from '../utils/authorization';
import { readEligibilityConfig, resolveEligibleUserIds } from '../voting_events/votingCommon';

export type ApprovalStage = 'LAUNCH' | 'RESULTS';
function canonical(value: any): any {
  if (value === undefined) return null;
  if (value === null || typeof value !== 'object') return value;
  if (typeof value.toMillis === 'function') return { seconds: value.seconds, nanoseconds: value.nanoseconds };
  if (Array.isArray(value)) return value.map(canonical);
  return Object.fromEntries(Object.keys(value).sort().map(k => [k, canonical(value[k])]));
}
export function approvalFingerprint(ev: DocumentData, stage: ApprovalStage, content: unknown): string {
  const configuration = { organizationId: ev.organizationId, title: ev.title, description: ev.description,
    votingType: ev.votingType, ballotMode: ev.ballotMode ?? 'SINGLE', contests: ev.contests ?? [],
    privacyMode: ev.privacyMode, eligibilityType: ev.eligibilityType, startAt: ev.startAt, endAt: ev.endAt,
    quorumPercent: ev.quorumPercent ?? null, allowAbstain: ev.allowAbstain === true,
    updatedAt: ev.updatedAt, independentApprovalRequired: ev.independentApprovalRequired === true };
  return createHash('sha256').update(JSON.stringify(canonical({ stage, configuration, content }))).digest('hex');
}
export function resultApprovalContent(results: DocumentData) {
  return { totalVotes: results.totalVotes, validVotes: results.validVotes, abstentionCount: results.abstentionCount, quorumPercent: results.quorumPercent, quorumMet: results.quorumMet, eligibleCount: results.eligibleCount, turnoutPercent: results.turnoutPercent,
    tallies: results.tallies, contests: results.contests ?? [] };
}
export async function launchApprovalContent(tx: Transaction, db: Firestore, eventId: string, ev: DocumentData, eligibleIds?: string[]) {
  const eligibility = await tx.get(db.collection('votingEventEligibility').doc(eventId));
  const config = readEligibilityConfig(eligibility, ev);
  const eligible = eligibleIds ?? await resolveEligibleUserIds(tx, db, ev.organizationId, ev.eligibilityType, config);
  const candidates = await tx.get(db.collection('candidates').where('organizationId', '==', ev.organizationId).where('votingEventId', '==', eventId));
  const options = await tx.get(db.collection('pollOptions').where('organizationId', '==', ev.organizationId).where('votingEventId', '==', eventId));
  const project = (docs: FirebaseFirestore.QueryDocumentSnapshot[]) => docs.map(doc => {
    const d = doc.data();
    return { id: doc.id, name: d.name ?? null, label: d.label ?? null, bio: d.bio ?? null, description: d.description ?? null,
      photoPath: d.photoPath ?? null, position: d.position ?? null, party: d.party ?? null, displayOrder: d.displayOrder ?? null, sortOrder: d.sortOrder ?? null };
  }).sort((a,b) => a.id.localeCompare(b.id));
  return { eligibilityType: ev.eligibilityType, departmentIds: [...config.departmentIds].sort(), selectedUserIds: [...config.userIds].sort(), eligibleIds: [...eligible].sort(), candidates: project(candidates.docs), options: project(options.docs) };
}

export async function assertIndependentApproval(tx: Transaction, db: Firestore, eventId: string, ev: DocumentData, stage: ApprovalStage, publisherUid: string, content: unknown) {
  if (ev.independentApprovalRequired !== true) return;
  const approval = (await tx.get(db.collection('electionApprovals').doc(`${eventId}_${stage}`))).data();
  if (!approval || approval.status !== 'APPROVED' || approval.organizationId !== ev.organizationId || approval.votingEventId !== eventId || approval.stage !== stage || approval.requestedBy !== publisherUid || approval.reviewedBy === publisherUid || approval.fingerprint !== approvalFingerprint(ev, stage, content)) {
    throw new HttpsError('failed-precondition', 'A different manager must approve the current version. Only its requester may publish it. Open Election approvals.');
  }
  await requireActiveMembership(db, ev.organizationId, approval.reviewedBy, ['owner','admin'], { tx });
  const reviewer = await tx.get(db.collection('users').doc(approval.reviewedBy));
  if (reviewer.data()?.status !== 'active') throw new HttpsError('failed-precondition', 'The approving manager is no longer active. Request a new approval.');
}
