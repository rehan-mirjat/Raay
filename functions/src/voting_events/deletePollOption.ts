import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS,
  enforceRateLimit, failWith, loadDraftEventForChild, requireAdminMember, requireAuth,
  requireId, requireOperationalOrg, writeAudit,
} from "./votingCommon";

export const deletePollOption = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const optionId = requireId((request.data || {}).optionId, "optionId");

  const db = getFirestore();
  await enforceRateLimit(db, uid, "deletePollOption");
  const optionRef = db.collection("pollOptions").doc(optionId);

  try {
    await db.runTransaction(async (tx) => {
      const snap = await tx.get(optionRef);
      if (!snap.exists) throw new HttpsError("not-found", "Poll option not found.");
      const opt = snap.data()!;
      const organizationId = opt.organizationId as string;
      const votingEventId = opt.votingEventId as string;

      await requireAdminMember(tx, db, organizationId, uid, "delete poll options");
      await requireOperationalOrg(tx, db, organizationId);

      // Generated YES/NO options are protected.
      if (optionId === `${votingEventId}_YES` || optionId === `${votingEventId}_NO`) {
        throw new HttpsError("failed-precondition", "Generated YES/NO poll options cannot be individually deleted.");
      }
      await loadDraftEventForChild(tx, db, organizationId, votingEventId, "Poll options");

      // Defence in depth with the real ballot field names.
      const votesCheck = await tx.get(
        db.collection("votes")
          .where("votingEventId", "==", votingEventId)
          .where("choiceId", "==", optionId)
          .limit(1)
      );
      if (!votesCheck.empty) throw new HttpsError("failed-precondition", "Cannot delete a poll option that has cast votes.");

      tx.delete(optionRef);
      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "DELETE_POLL_OPTION",
        resourceType: "pollOption",
        resourceId: optionId,
        metadata: { label: opt.label, votingEventId },
      });
    });

    return { status: "success" };
  } catch (error) {
    failWith("deletePollOption", error, "Failed to delete poll option.");
  }
});
