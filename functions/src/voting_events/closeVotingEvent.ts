import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS, EVENT_STATUS,
  enforceRateLimit, failWith, loadEventAsAdmin, requireAuth, requireId, writeAudit,
} from "./votingCommon";
import { requireNotRevoked, requireRecentAuthentication } from "../utils/authorization";

export const closeVotingEvent = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const eventId = requireId((request.data || {}).eventId, "eventId");

  // FR-10: closing a voting event is an explicitly-named sensitive operation.
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);

  const db = getFirestore();
  await enforceRateLimit(db, uid, "closeVotingEvent");

  try {
    await db.runTransaction(async (tx) => {
      // Authorization and organization checks run BEFORE any state check.
      const { ref, data: ev, organizationId } =
        await loadEventAsAdmin(tx, db, eventId, uid, "close voting events");

      // Strict transition: ACTIVE -> CLOSED only
      if (ev.status !== EVENT_STATUS.ACTIVE) {
        throw new HttpsError("failed-precondition", `Only ACTIVE events can be closed. Current status: '${ev.status}'`);
      }

      tx.update(ref, {
        status: EVENT_STATUS.CLOSED,
        closedAt: FieldValue.serverTimestamp(),
        closedBy: uid,
        updatedAt: FieldValue.serverTimestamp(),
      });

      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "CLOSE_VOTING_EVENT",
        resourceType: "votingEvent",
        resourceId: eventId,
        metadata: { previousStatus: EVENT_STATUS.ACTIVE, newStatus: EVENT_STATUS.CLOSED },
      });
    });

    return { status: "success" };
  } catch (error) {
    failWith("closeVotingEvent", error, "Failed to close voting event.");
  }
});
