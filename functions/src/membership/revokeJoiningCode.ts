import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireActiveMembership, requireOperationalOrganization } from "../utils/authorization";

export const revokeJoiningCode = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  const uid = request.auth.uid;
  const { codeId } = request.data || {};

  if (!codeId || typeof codeId !== "string" || codeId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid codeId is required.");
  }

  const db = getFirestore();
  const codeRef = db.collection("joiningCodes").doc(codeId.trim());

  await db.runTransaction(async (transaction) => {
    const codeSnap = await transaction.get(codeRef);
    if (!codeSnap.exists) {
      throw new HttpsError("not-found", "Joining code not found.");
    }

    const codeData = codeSnap.data()!;
    const orgId = codeData.organizationId;

    if (codeData.status !== "active") {
      throw new HttpsError("failed-precondition", `This joining code is already ${codeData.status}.`);
    }

    await requireActiveMembership(db, orgId, uid, ["owner", "admin"], { tx: transaction });

    await requireOperationalOrganization(db, orgId, transaction);

    transaction.update(codeRef, {
      status: "revoked",
      revokedAt: FieldValue.serverTimestamp(),
      revokedBy: uid,
    });

    // Audit Log (NO raw codes, NO hashes logged — codeId here is already the hash, kept as opaque resourceId only)
    const auditRef = db.collection("auditLogs").doc();
    transaction.set(auditRef, {
      organizationId: orgId,
      actorUid: uid,
      action: "REVOKE_JOINING_CODE",
      resourceType: "joiningCode",
      resourceId: codeId.trim(),
      timestamp: FieldValue.serverTimestamp(),
    });
  });

  return { status: "success" };
});
