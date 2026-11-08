import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS,
  EVENT_STATUS,
  enforceRateLimit,
  failWith,
  rejectUnknownKeys,
  requireAuth,
  requireId,
  writeAudit,
} from "./votingCommon";
import {
  requireActiveMembership,
  requireNotRevoked,
  requireOperationalOrganization,
  requireRecentAuthentication,
} from "../utils/authorization";

export const archiveVotingEvent = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);

  // Guards: authenticate -> requireNotRevoked -> requireRecentAuthentication
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);

  const data = request.data || {};
  rejectUnknownKeys(data, ["eventId", "organizationId", "orgId"], "archiveVotingEvent");
  const eventId = requireId(data.eventId, "eventId");

  const db = getFirestore();
  await enforceRateLimit(db, uid, "archiveVotingEvent");

  // Resolve organizationId: either provided in request, or retrieved from event
  let orgId = typeof (data.organizationId ?? data.orgId) === "string" && (data.organizationId ?? data.orgId)
    ? requireId(data.organizationId ?? data.orgId, "organizationId")
    : "";

  if (!orgId) {
    const eventDoc = await db.collection("votingEvents").doc(eventId).get();
    if (!eventDoc.exists) {
      throw new HttpsError("not-found", "Voting event not found.");
    }
    const eventData = eventDoc.data();
    orgId = eventData?.organizationId as string;
    if (!orgId) {
      throw new HttpsError("failed-precondition", "Voting event has no organization.");
    }
  }

  // Guards: requireActiveMembership -> requireOperationalOrganization
  await requireActiveMembership(db, orgId, uid, ["owner", "admin"]);
  await requireOperationalOrganization(db, orgId);

  try {
    await db.runTransaction(async (tx) => {
      const eventRef = db.collection("votingEvents").doc(eventId);
      const snap = await tx.get(eventRef);
      if (!snap.exists) {
        throw new HttpsError("not-found", "Voting event not found.");
      }

      const ev = snap.data();
      if (!ev || ev.organizationId !== orgId) {
        throw new HttpsError("failed-precondition", "Event organization does not match.");
      }

      // Strict transition: CLOSED -> ARCHIVED only
      if (ev.status !== EVENT_STATUS.CLOSED) {
        throw new HttpsError("failed-precondition", "Only closed events can be archived.");
      }

      tx.update(eventRef, {
        status: EVENT_STATUS.ARCHIVED,
        archivedAt: FieldValue.serverTimestamp(),
        archivedBy: uid,
        updatedAt: FieldValue.serverTimestamp(),
      });

      writeAudit(tx, db, {
        organizationId: orgId,
        actorUid: uid,
        action: "ARCHIVE_VOTING_EVENT",
        resourceType: "votingEvent",
        resourceId: eventId,
        metadata: {
          previousStatus: EVENT_STATUS.CLOSED,
          newStatus: EVENT_STATUS.ARCHIVED,
        },
      });
    });

    return { status: "success" };
  } catch (error) {
    failWith("archiveVotingEvent", error, "Failed to archive voting event.");
  }
});
