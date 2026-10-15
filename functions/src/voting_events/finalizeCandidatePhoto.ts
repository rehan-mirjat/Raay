import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import {
  CALLABLE_OPTIONS, LIMITS,
  enforceRateLimit, failWith, loadDraftEventForChild, requireAdminMember, requireAuth,
  requireId, requireOperationalOrg, writeAudit,
} from "./votingCommon";

export const finalizeCandidatePhoto = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const candidateId = requireId((request.data || {}).candidateId, "candidateId");

  const db = getFirestore();
  await enforceRateLimit(db, uid, "finalizeCandidatePhoto");
  const candRef = db.collection("candidates").doc(candidateId);

  try {
    // 1. Authorize and validate state
    const cand = await db.runTransaction(async (tx) => {
      const snap = await tx.get(candRef);
      if (!snap.exists) throw new HttpsError("not-found", "Candidate not found.");
      const c = snap.data()!;
      await requireAdminMember(tx, db, c.organizationId, uid, "finalize candidate photos");
      await requireOperationalOrg(tx, db, c.organizationId);
      await loadDraftEventForChild(tx, db, c.organizationId, c.votingEventId, "Candidate photos");
      return c;
    });

    const organizationId = cand.organizationId as string;
    const votingEventId = cand.votingEventId as string;
    const expectedPhotoPath = `organizations/${organizationId}/events/${votingEventId}/candidates/${candidateId}/photo.jpg`;

    // 2. Verify the uploaded object
    const file = getStorage().bucket().file(expectedPhotoPath);
    const [exists] = await file.exists();
    if (!exists) {
      throw new HttpsError("failed-precondition", "Candidate photo has not been uploaded. Upload the photo before finalization.");
    }

    const [metadata] = await file.getMetadata();
    if (metadata.contentType !== "image/jpeg") {
      throw new HttpsError("invalid-argument", "Candidate photo must be a valid 'image/jpeg'.");
    }
    const size = Number(metadata.size) || 0;
    if (size <= 0 || size > LIMITS.MAX_PHOTO_BYTES) {
      throw new HttpsError("invalid-argument", "Candidate photo size must be between 1 byte and 5MB.");
    }

    // contentType is client-supplied metadata, so also verify the JPEG signature (FF D8 FF).
    const [head] = await file.download({ start: 0, end: 2 });
    if (head.length < 3 || head[0] !== 0xff || head[1] !== 0xd8 || head[2] !== 0xff) {
      await file.delete({ ignoreNotFound: true }); // do not keep a non-JPEG object under this path
      throw new HttpsError("invalid-argument", "Candidate photo is not a valid JPEG image.");
    }

    // 3. Store ONLY the storage path. Reads are authorized by Storage security rules;
    //    no permanent, shareable token URL is created.
    await db.runTransaction(async (tx) => {
      const snap = await tx.get(candRef);
      if (!snap.exists) throw new HttpsError("not-found", "Candidate not found.");
      await requireAdminMember(tx, db, organizationId, uid, "finalize candidate photos");
      await requireOperationalOrg(tx, db, organizationId);
      await loadDraftEventForChild(tx, db, organizationId, votingEventId, "Candidate photos");

      tx.update(candRef, {
        photoPath: expectedPhotoPath,
        photoUrl: FieldValue.delete(), // removes the legacy token-URL field if present
        updatedAt: FieldValue.serverTimestamp(),
      });
      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "FINALIZE_CANDIDATE_PHOTO",
        resourceType: "candidate",
        resourceId: candidateId,
        metadata: { photoPath: expectedPhotoPath },
      });
    });

    return { status: "success", photoPath: expectedPhotoPath };
  } catch (error) {
    failWith("finalizeCandidatePhoto", error, "Failed to finalize candidate photo.");
  }
});
