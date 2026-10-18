import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue, Timestamp } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS, ELIGIBILITY_TYPES, EVENT_STATUS,
  assertActiveMembers, assertDepartmentsInOrg, assertEligibilityShape, assertEndInFuture,
  assertStartAcceptable, assertWindow, enforceRateLimit, failWith, loadEventAsAdmin, oneOf,
  optionalString, parseMillis, parsePrivacyMode, readEligibilityConfig, rejectUnknownKeys,
  requireAuth, requireId, requiredString, validateIdArray, writeAudit,
} from "./votingCommon";

export const updateVotingEvent = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};

  rejectUnknownKeys(data, [
    "eventId", "title", "description", "votingType", "privacyMode",
    "eligibilityType", "eligibilityDepartmentIds", "eligibilityUserIds",
    "startAt", "endAt",
  ], "updateVotingEvent");

  const eventId = requireId(data.eventId, "eventId");

  // ---- Validate only what the client actually sent ----
  const newTitle = data.title !== undefined ? requiredString(data.title, "Title", 3, 100) : undefined;
  const newDescription = data.description !== undefined ? optionalString(data.description, "Description", 1000, { multiline: true }) : undefined;
  const newPrivacy = data.privacyMode !== undefined ? parsePrivacyMode(data.privacyMode) : undefined;
  const newType = data.eligibilityType !== undefined ? oneOf(data.eligibilityType, ELIGIBILITY_TYPES, "eligibilityType") : undefined;
  const newDepts = data.eligibilityDepartmentIds !== undefined ? validateIdArray(data.eligibilityDepartmentIds, "eligibilityDepartmentIds") : undefined;
  const newUsers = data.eligibilityUserIds !== undefined ? validateIdArray(data.eligibilityUserIds, "eligibilityUserIds") : undefined;
  const newStart = data.startAt !== undefined ? parseMillis(data.startAt, "startAt") : undefined;
  const newEnd = data.endAt !== undefined ? parseMillis(data.endAt, "endAt") : undefined;
  if (data.votingType !== undefined && typeof data.votingType !== "string") {
    throw new HttpsError("invalid-argument", "Invalid votingType.");
  }

  const db = getFirestore();
  await enforceRateLimit(db, uid, "updateVotingEvent");

  try {
    await db.runTransaction(async (tx) => {
      // Authorization -> organization state -> event state (never the other way round).
      const { ref: eventRef, data: ev, organizationId } =
        await loadEventAsAdmin(tx, db, eventId, uid, "update voting events");

      if (ev.status !== EVENT_STATUS.DRAFT) {
        throw new HttpsError("failed-precondition",
          `Voting event in status '${ev.status}' is strictly immutable and cannot be updated.`);
      }

      // votingType is immutable: children (candidates / YES-NO options) depend on it.
      if (data.votingType !== undefined && data.votingType !== ev.votingType) {
        throw new HttpsError("failed-precondition",
          "votingType cannot be changed after creation. Create a new event instead.");
      }

      const updates: Record<string, unknown> = {};
      const auditExtra: Record<string, unknown> = {};

      if (newTitle !== undefined && newTitle !== ev.title) updates.title = newTitle;
      if (newDescription !== undefined && newDescription !== ev.description) updates.description = newDescription;
      if (newPrivacy !== undefined && newPrivacy !== ev.privacyMode) {
        updates.privacyMode = newPrivacy;
        auditExtra.previousPrivacyMode = ev.privacyMode;
        auditExtra.newPrivacyMode = newPrivacy;
      }

      // ---- Time window ----
      if (newStart !== undefined || newEnd !== undefined) {
        const trustedNow = Timestamp.now().toMillis();
        const effStart = newStart ?? (ev.startAt ? ev.startAt.toMillis() : trustedNow);
        const effEnd = newEnd ?? (ev.endAt ? ev.endAt.toMillis() : trustedNow + 5 * 60 * 1000);
        if (newStart !== undefined) assertStartAcceptable(newStart, trustedNow);
        if (newEnd !== undefined) assertEndInFuture(newEnd, trustedNow);
        assertWindow(effStart, effEnd);
        if (newStart !== undefined) updates.startAt = Timestamp.fromMillis(newStart);
        if (newEnd !== undefined) updates.endAt = Timestamp.fromMillis(newEnd);
      }

      // ---- Eligibility: always evaluated against the EFFECTIVE type ----
      const eligRef = db.collection("votingEventEligibility").doc(eventId);
      const eligSnap = await tx.get(eligRef);
      let eligWrite: Record<string, unknown> | null = null;

      if (newType !== undefined || newDepts !== undefined || newUsers !== undefined) {
        const existing = readEligibilityConfig(eligSnap, ev);
        const effType = newType ?? ev.eligibilityType;
        const typeChanged = newType !== undefined && newType !== ev.eligibilityType;
        const depts = newDepts ?? (typeChanged ? [] : existing.departmentIds);
        const users = newUsers ?? (typeChanged ? [] : existing.userIds);

        assertEligibilityShape(effType, depts, users);
        if (effType === "SELECTED_DEPARTMENTS") await assertDepartmentsInOrg(tx, db, organizationId, depts, "invalid-argument");
        if (effType === "SELECTED_MEMBERS") await assertActiveMembers(tx, db, organizationId, users, "invalid-argument");

        if (typeChanged) updates.eligibilityType = effType;
        eligWrite = {
          organizationId,
          votingEventId: eventId,
          eligibilityDepartmentIds: effType === "SELECTED_DEPARTMENTS" ? depts : [],
          eligibilityUserIds: effType === "SELECTED_MEMBERS" ? users : [],
          updatedAt: FieldValue.serverTimestamp(),
        };
        auditExtra.eligibilityType = effType;
      }

      if (Object.keys(updates).length === 0 && !eligWrite) {
        throw new HttpsError("invalid-argument", "No changes provided.");
      }

      // ---- Writes (all reads are finished) ----
      const changedFields = [...Object.keys(updates), ...(eligWrite ? ["eligibility"] : [])];
      tx.update(eventRef, { ...updates, updatedAt: FieldValue.serverTimestamp() });
      if (eligWrite) tx.set(eligRef, eligWrite, { merge: true });

      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "UPDATE_VOTING_EVENT",
        resourceType: "votingEvent",
        resourceId: eventId,
        metadata: {
          title: (updates.title as string) || ev.title,
          previousStatus: ev.status,
          changedFields,
          ...auditExtra,
        },
      });
    });

    return { status: "success" };
  } catch (error) {
    failWith("updateVotingEvent", error, "Failed to update voting event.");
  }
});
