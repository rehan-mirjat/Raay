import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { requireNotRevoked } from "../utils/authorization";

const MAX_EVENTS = 50;

export type EligibilityReason =
  | "ELIGIBLE"
  | "NOT_ON_LIST"
  | "NOT_OPEN_TO_YOU"
  | "ROSTER_NOT_READY";

export interface EligibilityDecision {
  eligible: boolean;
  reason: EligibilityReason;
}

/**
 * Pure decision for ONE caller and ONE event. Mirrors checkVoterEligibility
 * (frozen voter roll for restricted events) but never returns roster contents.
 * `member` / `event` / `eligibilityDoc` are plain document data (or undefined).
 */
export function decideEligibility(
  uid: string,
  member: Record<string, unknown> | undefined,
  event: Record<string, unknown> | undefined,
  eligibilityDoc: Record<string, unknown> | undefined,
): EligibilityDecision {
  // Same answer for "no such event", "other organization" and "draft" so the
  // response cannot be used to probe events the caller may not see.
  if (!event || !member || member.status !== "active" ||
      member.organizationId !== event.organizationId || member.userId !== uid ||
      String(event.status || "").toUpperCase() === "DRAFT") {
    return { eligible: false, reason: "NOT_OPEN_TO_YOU" };
  }
  if (event.eligibilityType === "ALL_MEMBERS") return { eligible: true, reason: "ELIGIBLE" };
  if (event.eligibilityType !== "SELECTED_DEPARTMENTS" && event.eligibilityType !== "SELECTED_MEMBERS") {
    return { eligible: false, reason: "NOT_OPEN_TO_YOU" };
  }
  const ids = eligibilityDoc && Array.isArray(eligibilityDoc.eligibleUserIds)
    ? (eligibilityDoc.eligibleUserIds as unknown[]) : undefined;
  if (!ids) return { eligible: false, reason: "ROSTER_NOT_READY" };
  return ids.includes(uid) ?
    { eligible: true, reason: "ELIGIBLE" } :
    { eligible: false, reason: "NOT_ON_LIST" };
}

/**
 * Returns only the CALLER's own eligibility decision (and a safe reason) per
 * event. The private frozen voter roll never leaves the server.
 */
export const getMyEligibility = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");
  await requireNotRevoked(request);

  const raw = request.data?.eventIds;
  if (!Array.isArray(raw) || raw.length === 0 || raw.length > MAX_EVENTS ||
      !raw.every((x) => typeof x === "string" && x.length > 0 && x.length <= 128)) {
    throw new HttpsError("invalid-argument", `eventIds must be 1-${MAX_EVENTS} event ids.`);
  }
  const eventIds = [...new Set(raw as string[])];

  const db = getFirestore();
  const eventSnaps = await db.getAll(...eventIds.map((id) => db.collection("votingEvents").doc(id)));

  const decisions: Record<string, EligibilityDecision> = {};
  await Promise.all(eventSnaps.map(async (snap, i) => {
    const event = snap.exists ? snap.data() : undefined;
    const orgId = event?.organizationId as string | undefined;
    const [memberSnap, eligSnap] = orgId ?
      await db.getAll(
        db.collection("organizationMembers").doc(`${orgId}_${uid}`),
        db.collection("votingEventEligibility").doc(eventIds[i])) :
      [undefined, undefined];
    decisions[eventIds[i]] = decideEligibility(uid, memberSnap?.data(), event, eligSnap?.data());
  }));
  return { decisions };
});
