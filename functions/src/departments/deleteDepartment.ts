import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireActiveMembership, requireOperationalOrganization } from "../utils/authorization";

export const deleteDepartment = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  const uid = request.auth.uid;
  const { departmentId } = request.data || {};

  if (!departmentId || typeof departmentId !== "string" || departmentId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid departmentId is required.");
  }

  const db = getFirestore();
  const deptRef = db.collection("departments").doc(departmentId);

  try {
    await db.runTransaction(async (transaction) => {
      // 1. Fetch existing department
      const deptSnap = await transaction.get(deptRef);
      if (!deptSnap.exists) {
        throw new HttpsError("not-found", "Department not found.");
      }

      const deptData = deptSnap.data()!;
      const organizationId = deptData.organizationId;
      const normalizedName = deptData.normalizedName || (deptData.name ? deptData.name.trim().toLowerCase() : "");
      const canonicalName = deptData.name || "Department";

      // 2. Validate Caller Membership & Role
      await requireActiveMembership(db, organizationId, uid, ["owner", "admin"], { tx: transaction });

      await requireOperationalOrganization(db, organizationId, transaction);

      // 3. Delete Department Document
      transaction.delete(deptRef);

      // 4. Delete Duplicate Lock if exists
      if (normalizedName) {
        const lockKey = `${organizationId}_${normalizedName}`;
        transaction.delete(db.collection("departmentKeys").doc(lockKey));
      }

      // 5. Create Audit Log
      const auditRef = db.collection("auditLogs").doc();
      transaction.set(auditRef, {
        organizationId: organizationId,
        actorUid: uid,
        action: "DELETE_DEPARTMENT",
        resourceType: "department",
        resourceId: departmentId,
        metadata: {
          departmentName: canonicalName,
        },
        timestamp: FieldValue.serverTimestamp(),
      });
    });

    return { status: "success" };
  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    const detailsMsg = error instanceof Error ? error.message : String(error);
    console.error("deleteDepartment error:", error);
    throw new HttpsError("internal", detailsMsg || "Failed to delete department.");
  }
});
