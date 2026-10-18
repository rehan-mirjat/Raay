import { onCall } from "firebase-functions/v2/https";
import { getFirestore, FieldValue, Timestamp } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS, ELIGIBILITY_TYPES, EVENT_STATUS, VOTING_TYPES,
  assertActiveMembers, assertDepartmentsInOrg, assertEligibilityShape, assertEndInFuture,
  assertStartAcceptable, assertWindow, enforceRateLimit, failWith, oneOf, optionalString,
  parseMillis, parsePrivacyMode, rejectUnknownKeys, requireAdminMember, requireAuth, requireId,
  requireOperationalOrg, requiredString, validateIdArray, writeAudit,
} from "./votingCommon";

export const createVotingEvent = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};

  rejectUnknownKeys(data, [
    "organizationId", "title", "description", "votingType",
    "eligibilityType", "eligibilityDepartmentIds", "eligibilityUserIds",
    "startAt", "endAt", "privacyMode",
  ], "createVotingEvent");

  // ---- Input validation (no database access yet) ----
  const organizationId = requireId(data.organizationId, "organizationId");
  const title = requiredString(data.title, "Title", 3, 100);
  const description = optionalString(data.description, "Description", 1000, { multiline: true });
  const votingType = oneOf(data.votingType, VOTING_TYPES, "votingType");
  const eligibilityType = oneOf(data.eligibilityType, ELIGIBILITY_TYPES, "eligibilityType");
  const privacyMode = data.privacyMode === undefined || data.privacyMode === null
    ? "ANONYMOUS"
    : parsePrivacyMode(data.privacyMode);

  const startMillis = parseMillis(data.startAt, "startAt");
  const endMillis = parseMillis(data.endAt, "endAt");
  const trustedNow = Timestamp.now().toMillis();
  assertStartAcceptable(startMillis, trustedNow);
  assertEndInFuture(endMillis, trustedNow);
  assertWindow(startMillis, endMillis);

  // DRAFT creation: empty rosters are allowed; they are enforced again at publish.
  const departmentIds = data.eligibilityDepartmentIds === undefined ? [] : validateIdArray(data.eligibilityDepartmentIds, "eligibilityDepartmentIds");
  const userIds = data.eligibilityUserIds === undefined ? [] : validateIdArray(data.eligibilityUserIds, "eligibilityUserIds");
  assertEligibilityShape(eligibilityType, departmentIds, userIds);

  const db = getFirestore();
  await enforceRateLimit(db, uid, "createVotingEvent");

  const eventRef = db.collection("votingEvents").doc();
  const eventId = eventRef.id;

  try {
    await db.runTransaction(async (tx) => {
      // Authorization first, then everything else (all reads happen before any write).
      await requireAdminMember(tx, db, organizationId, uid, "create voting events");
      await requireOperationalOrg(tx, db, organizationId);

      if (eligibilityType === "SELECTED_DEPARTMENTS") {
        await assertDepartmentsInOrg(tx, db, organizationId, departmentIds, "invalid-argument");
      } else if (eligibilityType === "SELECTED_MEMBERS") {
        await assertActiveMembers(tx, db, organizationId, userIds, "invalid-argument");
      }

      // The event document is readable by members, so it holds NO roster.
      tx.set(eventRef, {
        id: eventId,
        organizationId,
        title,
        description,
        votingType,
        privacyMode,
        maxSelections: 1, // V1: single selection contract
        eligibilityType,
        status: EVENT_STATUS.DRAFT,
        startAt: Timestamp.fromMillis(startMillis),
        endAt: Timestamp.fromMillis(endMillis),
        createdBy: uid,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
        activatedAt: null,
        closedAt: null,
        closedBy: null,
        cancelledAt: null,
        cancelledBy: null,
        archivedAt: null,
        archivedBy: null,
      });

      // Roster configuration is stored in an admin-only document.
      tx.set(db.collection("votingEventEligibility").doc(eventId), {
        organizationId,
        votingEventId: eventId,
        eligibilityDepartmentIds: eligibilityType === "SELECTED_DEPARTMENTS" ? departmentIds : [],
        eligibilityUserIds: eligibilityType === "SELECTED_MEMBERS" ? userIds : [],
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });

      if (votingType === "YES_NO_POLL") {
        for (const [suffix, label, order] of [["YES", "Yes", 1], ["NO", "No", 2]] as const) {
          const id = `${eventId}_${suffix}`;
          tx.set(db.collection("pollOptions").doc(id), {
            id,
            organizationId,
            votingEventId: eventId,
            label,
            description: "",
            sortOrder: order,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp(),
          });
        }
      }

      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "CREATE_VOTING_EVENT",
        resourceType: "votingEvent",
        resourceId: eventId,
        metadata: {
          title,
          votingType,
          privacyMode,
          eligibilityType,
          eligibilityDepartmentCount: departmentIds.length,
          eligibilityUserCount: userIds.length,
        },
      });
    });

    return { status: "success", eventId };
  } catch (error) {
    failWith("createVotingEvent", error, "Failed to create voting event.");
  }
});
