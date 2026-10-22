import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import * as logger from "firebase-functions/logger";
import {
  CALLABLE_OPTIONS,
  enforceRateLimit, failWith, loadDraftEventForChild, requireAdminMember, requireAuth,
  requireId, requireOperationalOrg, writeAudit,
} from "./votingCommon";

export const deleteCandidate = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const candidateId = requireId((request.data || {}).candidateId, "candidateId");

  const db = getFirestore();
  await enforceRateLimit(db, uid, "deleteCandidate");
  const candRef = db.collection("candidates").doc(candidateId);

  let photoPath: string | null = null;
  try {
    photoPath = await db.runTransaction(async (tx) => {
      const candSnap = await tx.get(candRef);
      if (!candSnap.exists) throw new HttpsError("not-found", "Candidate not found.");
      const cand = candSnap.data()!;
      const organizationId = cand.organizationId as string;

      await requireAdminMember(tx, db, organizationId, uid, "delete candidates");
      await requireOperationalOrg(tx, db, organizationId);
      await loadDraftEventForChild(tx, db, organizationId, cand.votingEventId, "Candidates");

      // Defence in depth with the real ballot field names (votingEventId / choiceId).
      const votesCheck = await tx.get(
        db.collection("votes")
          .where("votingEventId", "==", cand.votingEventId)
          .where("choiceId", "==", candidateId)
          .limit(1)
      );
      if (!votesCheck.empty) throw new HttpsError("failed-precondition", "Cannot delete candidate that has cast votes.");

      tx.delete(candRef);
      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "DELETE_CANDIDATE",
        resourceType: "candidate",
        resourceId: candidateId,
        metadata: { candidateName: cand.name, votingEventId: cand.votingEventId },
      });
      // Also clear a photo that was uploaded but never finalized (photoPath still null).
      return (cand.photoPath as string | null) ||
        `organizations/${organizationId}/events/${cand.votingEventId}/candidates/${candidateId}/photo.jpg`;
    });
  } catch (error) {
    failWith("deleteCandidate", error, "Failed to delete candidate.");
  }

  if (photoPath) {
    try {
      await getStorage().bucket().file(photoPath).delete({ ignoreNotFound: true });
    } catch (e) {
      logger.warn("deleteCandidate: storage cleanup failed", { candidateId, photoPath, error: e });
    }
  }
  return { status: "success" };
});
