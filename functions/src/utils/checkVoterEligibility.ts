import { HttpsError } from "firebase-functions/v2/https";
import { Transaction, Firestore, DocumentSnapshot } from "firebase-admin/firestore";

export interface EligibilityCheckRequest {
  organizationId: string;
  eventId: string;
  userId: string;
}

/**
 * Server-authoritative voter eligibility resolution engine.
 * Evaluates live membership status, then matches against the voter roll frozen
 * in `votingEventEligibility.eligibleUserIds` at event activation (see
 * `writeActivationDocs` in votingCommon.ts). The roster is never read off the
 * `votingEvents` document itself - that document is member-readable and holds
 * no roster - and eligibility is intentionally NOT re-derived live from
 * department/member config, so a member who changes department (or is added
 * to/removed from a SELECTED_MEMBERS list) after the event activates keeps the
 * eligibility it had when voting opened.
 * Accepts optional pre-fetched DocumentSnapshots to enable 1-request transaction batching.
 */
export async function checkVoterEligibility(
  transaction: Transaction,
  db: Firestore,
  req: EligibilityCheckRequest,
  preFetched?: {
    memberSnap?: DocumentSnapshot;
    eventSnap?: DocumentSnapshot;
    eligibilitySnap?: DocumentSnapshot;
  }
): Promise<boolean> {
  const { organizationId, eventId, userId } = req;

  if (!organizationId || !eventId || !userId) {
    throw new HttpsError("invalid-argument", "organizationId, eventId, and userId are required for eligibility check.");
  }

  // 1. Fetch organization membership record if not pre-fetched
  const memberRef = db.collection("organizationMembers").doc(`${organizationId}_${userId}`);
  const memberSnap = preFetched?.memberSnap || (await transaction.get(memberRef));

  if (!memberSnap.exists || memberSnap.data()?.status !== "active" ||
      memberSnap.data()?.organizationId !== organizationId || memberSnap.data()?.userId !== userId) {
    throw new HttpsError("permission-denied", "You do not have an active membership in this organization.");
  }

  // 2. Fetch target voting event if not pre-fetched
  const eventRef = db.collection("votingEvents").doc(eventId);
  const eventSnap = preFetched?.eventSnap || (await transaction.get(eventRef));

  if (!eventSnap.exists) {
    throw new HttpsError("not-found", "Target voting event not found.");
  }

  const eventData = eventSnap.data()!;
  if (eventData.organizationId !== organizationId) {
    throw new HttpsError("permission-denied", "Voting event belongs to a different organization.");
  }

  const eligibilityType = eventData.eligibilityType;

  // 3. ALL_MEMBERS: any currently active member of the organization is eligible.
  if (eligibilityType === "ALL_MEMBERS") {
    return true;
  }

  if (eligibilityType !== "SELECTED_DEPARTMENTS" && eligibilityType !== "SELECTED_MEMBERS") {
    throw new HttpsError("invalid-argument", `Unsupported eligibilityType '${eligibilityType}'.`);
  }

  // 4. SELECTED_DEPARTMENTS / SELECTED_MEMBERS: match against the frozen voter roll.
  const eligibilityRef = db.collection("votingEventEligibility").doc(eventId);
  const eligibilitySnap = preFetched?.eligibilitySnap || (await transaction.get(eligibilityRef));

  const eligibleUserIds: string[] = eligibilitySnap.exists && Array.isArray(eligibilitySnap.data()?.eligibleUserIds)
    ? eligibilitySnap.data()!.eligibleUserIds
    : [];

  if (!eligibleUserIds.includes(userId)) {
    throw new HttpsError("permission-denied", "You are not on the eligible voters list for this event.");
  }

  return true;
}
