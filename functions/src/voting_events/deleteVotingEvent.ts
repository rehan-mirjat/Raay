import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import * as logger from "firebase-functions/logger";
import {
  CALLABLE_OPTIONS, EVENT_STATUS, LIMITS,
  enforceRateLimit, failWith, loadEventAsAdmin, requireAuth, requireId, writeAudit,
} from "./votingCommon";

export const deleteVotingEvent = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const eventId = requireId((request.data || {}).eventId, "eventId");

  const db = getFirestore();
  await enforceRateLimit(db, uid, "deleteVotingEvent");

  let organizationId: string;
  try {
    organizationId = await db.runTransaction(async (tx) => {
      const { ref, data: ev, organizationId: orgId } =
        await loadEventAsAdmin(tx, db, eventId, uid, "delete voting events");

      // Hard-delete guard: DRAFT only
      if (ev.status !== EVENT_STATUS.DRAFT) {
        throw new HttpsError("failed-precondition",
          `Only DRAFT voting events can be deleted. Event in status '${ev.status}' cannot be deleted.`);
      }

      // Defence in depth (a DRAFT event cannot normally have votes). Uses the real field names.
      const votes = await tx.get(db.collection("votes").where("votingEventId", "==", eventId).limit(1));
      const participation = await tx.get(db.collection("participation").where("votingEventId", "==", eventId).limit(1));
      if (!votes.empty || !participation.empty) {
        throw new HttpsError("failed-precondition", "Cannot delete voting event that contains cast votes.");
      }

      const candidates = await tx.get(db.collection("candidates").where("votingEventId", "==", eventId));
      const options = await tx.get(db.collection("pollOptions").where("votingEventId", "==", eventId));
      if (candidates.size + options.size > LIMITS.MAX_CANDIDATES + LIMITS.MAX_OPTIONS + 10) {
        throw new HttpsError("failed-precondition", "Event has too many child records to delete in one operation.");
      }

      candidates.docs.forEach((d) => tx.delete(d.ref));
      options.docs.forEach((d) => tx.delete(d.ref));
      tx.delete(db.collection("votingEventEligibility").doc(eventId));
      tx.delete(ref);

      writeAudit(tx, db, {
        organizationId: orgId,
        actorUid: uid,
        action: "DELETE_VOTING_EVENT",
        resourceType: "votingEvent",
        resourceId: eventId,
        metadata: {
          title: ev.title,
          deletedStatus: EVENT_STATUS.DRAFT,
          deletedCandidates: candidates.size,
          deletedOptions: options.size,
        },
      });
      return orgId;
    });
  } catch (error) {
    failWith("deleteVotingEvent", error, "Failed to delete voting event.");
  }

  // Post-transaction cleanup: remove every candidate photo stored under this event.
  try {
    await getStorage().bucket().deleteFiles({
      prefix: `organizations/${organizationId}/events/${eventId}/`,
      force: true,
    });
  } catch (e) {
    logger.warn("deleteVotingEvent: storage cleanup failed", { organizationId, eventId, error: e });
  }

  return { status: "success" };
});
