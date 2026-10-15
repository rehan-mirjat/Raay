import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS, LIMITS,
  enforceRateLimit, failWith, loadDraftEventForChild, optionalString, parseSortOrder,
  rejectUnknownKeys, requireAdminMember, requireAuth, requireId, requireOperationalOrg,
  requiredString, writeAudit,
} from "./votingCommon";

export const createCandidate = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  rejectUnknownKeys(data, ["organizationId", "votingEventId", "name", "position", "party", "bio", "displayOrder"], "createCandidate");

  const organizationId = requireId(data.organizationId, "organizationId");
  const votingEventId = requireId(data.votingEventId, "votingEventId");
  const name = requiredString(data.name, "Candidate name", 2, 100);
  const position = optionalString(data.position, "Position", 100);
  const party = optionalString(data.party, "Party name", 100);
  const bio = optionalString(data.bio, "Bio", 1000);
  const displayOrder = data.displayOrder === undefined ? 0 : parseSortOrder(data.displayOrder);

  const db = getFirestore();
  await enforceRateLimit(db, uid, "createCandidate");

  const candidateRef = db.collection("candidates").doc();
  const candidateId = candidateRef.id;
  const expectedPhotoPath = `organizations/${organizationId}/events/${votingEventId}/candidates/${candidateId}/photo.jpg`;

  try {
    await db.runTransaction(async (tx) => {
      await requireAdminMember(tx, db, organizationId, uid, "create candidates");
      await requireOperationalOrg(tx, db, organizationId);
      await loadDraftEventForChild(tx, db, organizationId, votingEventId, "Candidates", "CANDIDATE_ELECTION");

      const siblings = await tx.get(
        db.collection("candidates")
          .where("organizationId", "==", organizationId)
          .where("votingEventId", "==", votingEventId)
      );
      if (siblings.size >= LIMITS.MAX_CANDIDATES) {
        throw new HttpsError("failed-precondition", `An event cannot have more than ${LIMITS.MAX_CANDIDATES} candidates.`);
      }
      const lower = name.toLowerCase();
      if (siblings.docs.some((d) => String(d.data().name || "").trim().toLowerCase() === lower)) {
        throw new HttpsError("already-exists", "A candidate with this name already exists in this event.");
      }

      tx.set(candidateRef, {
        id: candidateId,
        organizationId,
        votingEventId,
        name,
        position,
        party,
        bio,
        displayOrder,
        photoPath: null, // photos are referenced by Storage path only (no permanent token URLs)
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });

      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "CREATE_CANDIDATE",
        resourceType: "candidate",
        resourceId: candidateId,
        metadata: { candidateName: name, votingEventId },
      });
    });

    return { status: "success", candidateId, expectedPhotoPath };
  } catch (error) {
    failWith("createCandidate", error, "Failed to create candidate.");
  }
});
