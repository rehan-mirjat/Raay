import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import * as logger from "firebase-functions/logger";
import {
  CALLABLE_OPTIONS,
  enforceRateLimit, failWith, loadDraftEventForChild, requireAdminMember, requireAuth,
  requireId, requireOperationalOrg, writeAudit,
} from "./votingCommon";

export const deleteCandidatePhoto = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const candidateId = requireId((request.data || {}).candidateId, "candidateId");

  const db = getFirestore();
  await enforceRateLimit(db, uid, "deleteCandidatePhoto");
  const candRef = db.collection("candidates").doc(candidateId);

  let photoPath: string;
  try {
    photoPath = await db.runTransaction(async (tx) => {
      const candSnap = await tx.get(candRef);
      if (!candSnap.exists) throw new HttpsError("not-found", "Candidate not found.");
      const cand = candSnap.data()!;
      const organizationId = cand.organizationId as string;
      const votingEventId = cand.votingEventId as string;

      await requireAdminMember(tx, db, organizationId, uid, "delete candidate photos");
      await requireOperationalOrg(tx, db, organizationId);
      await loadDraftEventForChild(tx, db, organizationId, votingEventId, "Candidate photos");

      tx.update(candRef, {
        photoPath: null,
        photoUrl: FieldValue.delete(), // removes the legacy token-URL field if present
        updatedAt: FieldValue.serverTimestamp(),
      });
      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "DELETE_CANDIDATE_PHOTO",
        resourceType: "candidate",
        resourceId: candidateId,
        metadata: { candidateName: cand.name },
      });
      return (cand.photoPath as string) ||
        `organizations/${organizationId}/events/${votingEventId}/candidates/${candidateId}/photo.jpg`;
    });
  } catch (error) {
    failWith("deleteCandidatePhoto", error, "Failed to delete candidate photo.");
  }

  try {
    await getStorage().bucket().file(photoPath).delete({ ignoreNotFound: true });
  } catch (e) {
    logger.warn("deleteCandidatePhoto: storage cleanup failed", { candidateId, photoPath, error: e });
  }
  return { status: "success" };
});
