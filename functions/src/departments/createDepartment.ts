import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireActiveMembership, requireOperationalOrganization } from "../utils/authorization";

export const createDepartment = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  const uid = request.auth.uid;
  const { organizationId, name, description } = request.data || {};

  if (!organizationId || typeof organizationId !== "string" || organizationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  }

  if (!name || typeof name !== "string" || name.trim().length < 2 || name.trim().length > 50) {
    throw new HttpsError("invalid-argument", "Department name must be between 2 and 50 characters.");
  }

  const db = getFirestore();

  // Validate Caller Membership & Role
  await requireActiveMembership(db, organizationId, uid, ["owner", "admin"]);

  await requireOperationalOrganization(db, organizationId);

  // Canonical Formatting & Normalization
  // Trim leading/trailing and collapse consecutive internal spaces
  const canonicalName = name.trim().replace(/\s+/g, ' ');
  const normalizedName = canonicalName.toLowerCase();
  const cleanDescription = description && typeof description === "string" ? description.trim() : "";

  const lockKey = `${organizationId}_${normalizedName}`;
  const lockRef = db.collection("departmentKeys").doc(lockKey);
  const deptRef = db.collection("departments").doc();
  const deptId = deptRef.id;

  try {
    await db.runTransaction(async (transaction) => {
      // 1. Transactional Duplicate Name Prevention
      const lockSnap = await transaction.get(lockRef);
      if (lockSnap.exists) {
        throw new HttpsError("already-exists", "A department with this name already exists in the organization.");
      }

      // 2. Claim Duplicate Lock
      transaction.set(lockRef, {
        organizationId: organizationId,
        normalizedName: normalizedName,
        departmentId: deptId,
        createdAt: FieldValue.serverTimestamp(),
      });

      // 3. Create Department Document
      transaction.set(deptRef, {
        id: deptId,
        organizationId: organizationId,
        name: canonicalName,
        normalizedName: normalizedName,
        description: cleanDescription,
        createdBy: uid,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });

      // 4. Create Audit Log
      const auditRef = db.collection("auditLogs").doc();
      transaction.set(auditRef, {
        organizationId: organizationId,
        actorUid: uid,
        action: "CREATE_DEPARTMENT",
        resourceType: "department",
        resourceId: deptId,
        metadata: {
          departmentName: canonicalName,
        },
        timestamp: FieldValue.serverTimestamp(),
      });
    });

    return { status: "success", departmentId: deptId };
  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to create department.", error);
  }
});
