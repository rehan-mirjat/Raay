import { quorumReached } from "../utils/ballotRules";
import { parseContests, tallyContests } from "../utils/multiContest";
import { assertIndependentApproval, resultApprovalContent } from "../governance/approvalPolicy";
import { Firestore, FieldValue, Timestamp } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";

export interface TallyRow {
  choiceId: string;
  choiceType: string;
  name: string;
  votes: number;
  percent: number;
}

export interface EventResultsPayload {
  organizationId: string;
  votingEventId: string;
  published: boolean;
  publishedAt: FirebaseFirestore.Timestamp | null;
  publishedBy: string | null;
  calculatedAt: FirebaseFirestore.Timestamp | FirebaseFirestore.FieldValue;
  calculatedBy: string;
  totalVotes: number;
  validVotes: number;
  abstentionCount: number;
  quorumPercent: number | null;
  quorumMet: boolean | null;
  eligibleCount: number;
  participationCount: number;
  turnoutPercent: number;
  tallies: TallyRow[];
  contests?: ReturnType<typeof tallyContests>;
}

export interface EligibleMember {
  userId: string;
  departmentId: string | null;
  active?: boolean;
}

export type EligibilitySource =
  | { kind: "frozen"; userIds: string[] }
  | { kind: "selected_members"; userIds: string[] }
  | { kind: "selected_departments"; departmentIds: string[] }
  | { kind: "all_members" };

/**
 * Decides where to read the eligible-voter selection from. Pure (no
 * Firestore access) so the decision itself - the part that was actually
 * wrong - can be unit tested directly.
 *
 * The eligibility SELECTION (which members/departments were picked) does
 * not live on the votingEvents document itself once an event has gone
 * through the normal builder flow: updateVotingEvent.ts writes edits to
 * votingEventEligibility/{eventId} only, never back to the event document,
 * so eventData.eligibilityUserIds/eligibilityDepartmentIds go stale (usually
 * empty) the moment eligibility is set or changed post-creation. And once
 * the event is activated, publishVotingEvent.ts freezes the resolved voter
 * roll into votingEventEligibility/{eventId}.eligibleUserIds (see
 * writeActivationDocs in voting_events/votingCommon.ts) - that frozen list,
 * not a live re-resolution, is the authoritative "who could vote in this
 * specific election" answer, and it's exactly what castVote.ts checks
 * against. Reading eventData's fields directly (as this used to) therefore
 * under-counts eligibility - often to zero - for any event edited or
 * activated through the normal flow, while turnout/participation counts
 * stay correct, producing exactly the "0 eligible, N voted" symptom this
 * was fixed for.
 */
export function resolveEligibilitySource(
  eligData: FirebaseFirestore.DocumentData | null,
  eventData: FirebaseFirestore.DocumentData
): EligibilitySource {
  if (eligData && Array.isArray(eligData.eligibleUserIds)) {
    return {
      kind: "frozen",
      userIds: [...new Set<string>(eligData.eligibleUserIds.filter((x: unknown): x is string => typeof x === "string" && x.length > 0))],
    };
  }

  // No frozen roster yet (event still in DRAFT) - fall back to the current
  // configuration: the draft doc if it exists, else the event document's
  // own (create-time-only) fields as a last resort.
  const eligibilityType =
    (eligData?.eligibilityType as string | undefined) || eventData.eligibilityType || "ALL_MEMBERS";

  if (eligibilityType === "SELECTED_MEMBERS") {
    const ids: string[] = Array.isArray(eligData?.eligibilityUserIds)
      ? (eligData!.eligibilityUserIds as string[])
      : Array.isArray(eventData.eligibilityUserIds)
        ? eventData.eligibilityUserIds
        : [];
    return { kind: "selected_members", userIds: ids };
  }

  if (eligibilityType === "SELECTED_DEPARTMENTS") {
    const deptIds: string[] = Array.isArray(eligData?.eligibilityDepartmentIds)
      ? (eligData!.eligibilityDepartmentIds as string[])
      : Array.isArray(eventData.eligibilityDepartmentIds)
        ? eventData.eligibilityDepartmentIds
        : [];
    return { kind: "selected_departments", departmentIds: deptIds };
  }

  return { kind: "all_members" };
}

/**
 * Resolves the actual list of eligible members (not just a count), so
 * callers can group/aggregate by attributes like department. Mirrors
 * countEligibleVoters' eligibility branches exactly - countEligibleVoters
 * is defined in terms of this function precisely to keep both in sync.
 */
export async function getEligibleMembers(
  db: Firestore,
  organizationId: string,
  eventId: string,
  eventData: FirebaseFirestore.DocumentData
): Promise<EligibleMember[]> {
  const toEligibleMember = (doc: FirebaseFirestore.DocumentSnapshot): EligibleMember => ({
    userId: doc.data()?.userId,
    departmentId: doc.data()?.departmentId ?? null,
  });

  const eligSnap = await db.collection("votingEventEligibility").doc(eventId).get();
  const eligData = eligSnap?.exists ? eligSnap.data() ?? null : null;

  const source = resolveEligibilitySource(eligData, eventData);

  if (source.kind === "frozen") {
    if (source.userIds.length === 0) return [];
    const snaps = await db.getAll(
      ...source.userIds.map((userId) => db.collection("organizationMembers").doc(`${organizationId}_${userId}`))
    );
    // Preserve the original denominator even if a member is removed later.
    return source.userIds.map((userId, index) => ({
      userId,
      departmentId: snaps[index].data()?.departmentId ?? null,
      active: snaps[index].exists && snaps[index].data()?.status === "active",
    }));
  }

  if (["ACTIVE", "CLOSED", "ARCHIVED"].includes(eventData.status)) {
    throw new HttpsError("failed-precondition", "The election voter roll is missing. Contact the organizer.");
  }

  if (source.kind === "selected_members") {
    if (source.userIds.length === 0) return [];
    const snap = await db
      .collection("organizationMembers")
      .where("organizationId", "==", organizationId)
      .where("status", "==", "active")
      .get();
    const eligibleIds = new Set(source.userIds);
    return snap.docs.filter((doc) => eligibleIds.has(doc.data()?.userId)).map(toEligibleMember);
  }

  if (source.kind === "selected_departments") {
    if (source.departmentIds.length === 0) return [];
    const snap = await db
      .collection("organizationMembers")
      .where("organizationId", "==", organizationId)
      .where("status", "==", "active")
      .get();
    return snap.docs.filter((doc) => source.departmentIds.includes(doc.data()?.departmentId)).map(toEligibleMember);
  }

  const snap = await db
    .collection("organizationMembers")
    .where("organizationId", "==", organizationId)
    .where("status", "==", "active")
    .get();
  return snap.docs.map(toEligibleMember);
}

export async function countEligibleVoters(
  db: Firestore,
  organizationId: string,
  eventId: string,
  eventData: FirebaseFirestore.DocumentData
): Promise<number> {
  return (await getEligibleMembers(db, organizationId, eventId, eventData)).length;
}

export async function calculateEventResults(
  db: Firestore,
  eventId: string,
  actorUid: string,
  options?: { publish?: boolean }
): Promise<EventResultsPayload> {
  const eventSnap = await db.collection("votingEvents").doc(eventId).get();
  if (!eventSnap.exists) {
    throw new Error("NOT_FOUND");
  }
  const eventData = eventSnap.data()!;
  const organizationId = eventData.organizationId as string;
  const status = eventData.status as string;

  if (status !== "CLOSED" && status !== "ARCHIVED") {
    throw new Error("NOT_CLOSED");
  }

  const [votesSnap, participationSnap, candidatesSnap, optionsSnap, existingResults] = await Promise.all([
    db.collection("votes").where("votingEventId", "==", eventId).where("organizationId", "==", organizationId).get(),
    db.collection("participation").where("votingEventId", "==", eventId).where("organizationId", "==", organizationId).get(),
    db.collection("candidates").where("votingEventId", "==", eventId).where("organizationId", "==", organizationId).get(),
    db.collection("pollOptions").where("votingEventId", "==", eventId).where("organizationId", "==", organizationId).get(),
    db.collection("eventResults").doc(eventId).get(),
  ]);

  const existingData = existingResults.data();
  // Published tallies are a public record. Recalculation must never silently
  // change results that members have already seen.
  if (existingData?.published === true) return existingData as EventResultsPayload;

  const counts = new Map<string, number>();
  for (const doc of votesSnap.docs) {
    if (doc.data()?.choiceType === "ABSTAIN") continue;
    const choiceId = (doc.data()?.choiceId as string) || "";
    if (!choiceId) continue;
    counts.set(choiceId, (counts.get(choiceId) || 0) + 1);
  }

  const roster: Array<{ choiceId: string; choiceType: string; name: string }> = [];
  for (const doc of candidatesSnap.docs) {
    const data = doc.data();
    roster.push({
      choiceId: doc.id,
      choiceType: "CANDIDATE",
      name: (data.name as string) || "Candidate",
    });
  }
  for (const doc of optionsSnap.docs) {
    const data = doc.data();
    roster.push({
      choiceId: doc.id,
      choiceType: "POLL_OPTION",
      name: (data.label as string) || (data.name as string) || "Option",
    });
  }

  const multi = eventData.ballotMode === "MULTI_CONTEST";
  const contests = multi ? tallyContests(parseContests(eventData.contests), votesSnap.docs.map((doc) => doc.data())) : undefined;
  const abstentionCount = multi ? contests![0].abstentionCount : votesSnap.docs.filter(doc => doc.data().choiceType === "ABSTAIN").length;
  if (abstentionCount > 0 && eventData.allowAbstain !== true) throw new HttpsError("failed-precondition", "Unexpected abstentions; investigate before publishing.");
  const validVotes = multi ? contests![0].validVotes : Array.from(counts.values()).reduce((sum, count) => sum + count, 0);
  const totalVotes = validVotes + abstentionCount;
  const tallies: TallyRow[] = roster.map((row) => {
    const votes = counts.get(row.choiceId) || 0;
    return {
      ...row,
      votes,
      percent: validVotes === 0 ? 0 : Math.round((votes / validVotes) * 10000) / 100,
    };
  });

  tallies.sort((a, b) => b.votes - a.votes || a.name.localeCompare(b.name));

  const eligibleCount = await countEligibleVoters(db, organizationId, eventId, eventData);
  const participationCount = participationSnap.size;
  if (participationCount > totalVotes) throw new HttpsError("failed-precondition", "Accepted ballots are missing; investigate before publishing.");
  const turnoutPercent =
    eligibleCount === 0 ? 0 : Math.round((totalVotes / eligibleCount) * 10000) / 100;

  const alreadyPublished = existingResults.exists && existingResults.data()?.published === true;
  const published = options?.publish === true || alreadyPublished;

  const payload: EventResultsPayload = {
    organizationId,
    votingEventId: eventId,
    published,
    publishedAt: alreadyPublished
      ? (existingResults.data()?.publishedAt as Timestamp) || null
      : options?.publish
        ? (Timestamp.now() as Timestamp)
        : null,
    publishedBy: alreadyPublished
      ? (existingResults.data()?.publishedBy as string) || null
      : options?.publish
        ? actorUid
        : null,
    calculatedAt: FieldValue.serverTimestamp(),
    calculatedBy: actorUid,
    totalVotes,
    validVotes,
    abstentionCount,
    quorumPercent: eventData.quorumPercent ?? null,
    quorumMet: quorumReached(totalVotes, eligibleCount, eventData.quorumPercent ?? null),
    eligibleCount,
    participationCount,
    turnoutPercent,
    tallies: multi ? [] : tallies,
    ...(contests ? { contests } : {}),
  };

  // Recheck the public record atomically: a concurrent recalculation must never
  // overwrite a result publication that committed after our initial read.
  return db.runTransaction(async tx => {
    const currentEvent = (await tx.get(db.collection("votingEvents").doc(eventId))).data();
    if (!currentEvent || currentEvent.organizationId !== organizationId || !["CLOSED", "ARCHIVED"].includes(currentEvent.status)) throw new Error("NOT_CLOSED");
    const resultRef = db.collection("eventResults").doc(eventId);
    const currentResult = (await tx.get(resultRef)).data();
    if (currentResult?.published === true) return currentResult as EventResultsPayload;
    if (options?.publish === true) await assertIndependentApproval(tx, db, eventId, currentEvent, "RESULTS", actorUid, resultApprovalContent(payload));
    tx.set(resultRef, payload, { merge: true });
    return payload;
  });
}
