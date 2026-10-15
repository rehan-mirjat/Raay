import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS,
  enforceRateLimit, failWith, loadDraftEventForChild, optionalString, parseSortOrder,
  rejectUnknownKeys, requireAdminMember, requireAuth, requireId, requireOperationalOrg,
  requiredString, writeAudit,
} from "./votingCommon";

export const updateCandidate = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  rejectUnknownKeys(data, ["candidateId", "name", "position", "party", "bio", "displayOrder"], "updateCandidate");

  const candidateId = requireId(data.candidateId, "candidateId");
  const name = data.name !== undefined ? requiredString(data.name, "Candidate name", 2, 100) : undefined;
  const position = data.position !== undefined ? optionalString(data.position, "Position", 100) : undefined;
  const party = data.party !== undefined ? optionalString(data.party, "Party name", 100) : undefined;
  const bio = data.bio !== undefined ? optionalString(data.bio, "Bio", 1000) : undefined;
  const displayOrder = data.displayOrder !== undefined ? parseSortOrder(data.displayOrder) : undefined;

  const db = getFirestore();
  await enforceRateLimit(db, uid, "updateCandidate");
  const candRef = db.collection("candidates").doc(candidateId);

  try {
    await db.runTransaction(async (tx) => {
      const candSnap = await tx.get(candRef);
      if (!candSnap.exists) throw new HttpsError("not-found", "Candidate not found.");
      const cand = candSnap.data()!;
      const organizationId = cand.organizationId as string;

      await requireAdminMember(tx, db, organizationId, uid, "update candidates");
      await requireOperationalOrg(tx, db, organizationId);
      await loadDraftEventForChild(tx, db, organizationId, cand.votingEventId, "Candidates");

      const updates: Record<string, unknown> = {};
      if (name !== undefined && name !== cand.name) {
        const siblings = await tx.get(
          db.collection("candidates")
            .where("organizationId", "==", organizationId)
            .where("votingEventId", "==", cand.votingEventId)
        );
        const lower = name.toLowerCase();
        if (siblings.docs.some((d) => d.id !== candidateId && String(d.data().name || "").trim().toLowerCase() === lower)) {
          throw new HttpsError("already-exists", "A candidate with this name already exists in this event.");
        }
        updates.name = name;
      }
      if (position !== undefined && position !== cand.position) updates.position = position;
      if (party !== undefined && party !== cand.party) updates.party = party;
      if (bio !== undefined && bio !== cand.bio) updates.bio = bio;
      if (displayOrder !== undefined && displayOrder !== cand.displayOrder) updates.displayOrder = displayOrder;

      if (Object.keys(updates).length === 0) throw new HttpsError("invalid-argument", "No changes provided.");

      tx.update(candRef, { ...updates, updatedAt: FieldValue.serverTimestamp() });
      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "UPDATE_CANDIDATE",
        resourceType: "candidate",
        resourceId: candidateId,
        metadata: { candidateName: (updates.name as string) || cand.name, changedFields: Object.keys(updates) },
      });
    });

    return { status: "success" };
  } catch (error) {
    failWith("updateCandidate", error, "Failed to update candidate.");
  }
});
