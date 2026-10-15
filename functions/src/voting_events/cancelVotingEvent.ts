import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS, EVENT_STATUS,
  enforceRateLimit, failWith, loadEventAsAdmin, optionalString, rejectUnknownKeys,
  requireAuth, requireId, writeAudit,
} from "./votingCommon";

export const cancelVotingEvent = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  rejectUnknownKeys(data, ["eventId", "reason"], "cancelVotingEvent");

  const eventId = requireId(data.eventId, "eventId");
  const reason = optionalString(data.reason, "Reason", 500);

  const db = getFirestore();
  await enforceRateLimit(db, uid, "cancelVotingEvent");

  try {
    await db.runTransaction(async (tx) => {
      const { ref, data: ev, organizationId } =
        await loadEventAsAdmin(tx, db, eventId, uid, "cancel voting events");

      // Strict transition: SCHEDULED -> CANCELLED only
      if (ev.status !== EVENT_STATUS.SCHEDULED) {
        throw new HttpsError("failed-precondition", `Only SCHEDULED events can be cancelled. Current status: '${ev.status}'`);
      }

      tx.update(ref, {
        status: EVENT_STATUS.CANCELLED,
        cancelledAt: FieldValue.serverTimestamp(),
        cancelledBy: uid,
        cancelReason: reason,
        updatedAt: FieldValue.serverTimestamp(),
      });

      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "CANCEL_VOTING_EVENT",
        resourceType: "votingEvent",
        resourceId: eventId,
        metadata: { previousStatus: EVENT_STATUS.SCHEDULED, newStatus: EVENT_STATUS.CANCELLED, reason },
      });
    });

    return { status: "success" };
  } catch (error) {
    failWith("cancelVotingEvent", error, "Failed to cancel voting event.");
  }
});
