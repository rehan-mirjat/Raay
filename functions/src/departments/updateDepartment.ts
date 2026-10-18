import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireActiveMembership, requireOperationalOrganization, requireNotRevoked } from "../utils/authorization";
import { sanitizePlainText } from "../utils/sanitize";

export const updateDepartment = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  await requireNotRevoked(request);

  const uid = request.auth.uid;
  const { departmentId, name, description } = request.data || {};

  if (!departmentId || typeof departmentId !== "string" || departmentId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid departmentId is required.");
  }

  if (name !== undefined && name !== null) {
    if (typeof name !== "string") {
      throw new HttpsError("invalid-argument", "Department name must be a string.");
    }
    const sanitizedLength = sanitizePlainText(name).length;
    if (sanitizedLength < 2 || sanitizedLength > 50) {
      throw new HttpsError("invalid-argument", "Department name must be between 2 and 50 characters.");
    }
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
      const oldNormalizedName = deptData.normalizedName;

      // 2. Validate Caller Membership & Role
      await requireActiveMembership(db, organizationId, uid, ["owner", "admin"], { tx: transaction });

      await requireOperationalOrganization(db, organizationId, transaction);

      const updates: any = {
        updatedAt: FieldValue.serverTimestamp(),
      };

      let canonicalName = deptData.name;

      if (name) {
        canonicalName = sanitizePlainText(name);
        const newNormalizedName = canonicalName.toLowerCase();

        // If name changed, manage deterministic locks
        if (newNormalizedName !== oldNormalizedName) {
          const newLockKey = `${organizationId}_${newNormalizedName}`;
          const newLockRef = db.collection("departmentKeys").doc(newLockKey);

          const newLockSnap = await transaction.get(newLockRef);
          if (newLockSnap.exists) {
            throw new HttpsError("already-exists", "A department with this name already exists in the organization.");
          }

          // Release old lock & claim new lock
          const oldLockKey = `${organizationId}_${oldNormalizedName}`;
          transaction.delete(db.collection("departmentKeys").doc(oldLockKey));
          transaction.set(newLockRef, {
            organizationId: organizationId,
            normalizedName: newNormalizedName,
            departmentId: departmentId,
            createdAt: FieldValue.serverTimestamp(),
          });

          updates.name = canonicalName;
          updates.normalizedName = newNormalizedName;
        }
      }

      if (description !== undefined) {
        updates.description = typeof description === "string"
          ? sanitizePlainText(description, { multiline: true })
          : "";
      }

      transaction.update(deptRef, updates);

      // Audit Log
      const auditRef = db.collection("auditLogs").doc();
      transaction.set(auditRef, {
        organizationId: organizationId,
        actorUid: uid,
        action: "UPDATE_DEPARTMENT",
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
    throw new HttpsError("internal", "Failed to update department.", error);
  }
});
