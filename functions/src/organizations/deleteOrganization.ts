import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireNotRevoked, requireRecentAuthentication, requireMfaEnrolled } from "../utils/authorization";

export const deleteOrganization = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  // FR-10 / MFA-REQ-001: organization deletion is a destructive sensitive operation.
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);
  await requireMfaEnrolled(request.auth.uid);

  const uid = request.auth.uid;
  const { organizationId } = request.data || {};

  if (!organizationId || typeof organizationId !== "string" || organizationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  }

  const orgId = organizationId.trim();
  const db = getFirestore();

  try {
    await db.runTransaction(async (transaction) => {
      const memberRef = db.collection("organizationMembers").doc(`${orgId}_${uid}`);
      const memberSnap = await transaction.get(memberRef);

      if (!memberSnap.exists || memberSnap.data()?.status !== "active" || memberSnap.data()?.organizationId !== orgId) {
        throw new HttpsError("permission-denied", "You are not an active member of this organization.");
      }

      if (memberSnap.data()?.role !== "owner") {
        throw new HttpsError("permission-denied", "Only the Organization Owner can delete the organization.");
      }

      const orgRef = db.collection("organizations").doc(orgId);
      const orgSnap = await transaction.get(orgRef);

      if (!orgSnap.exists) {
        throw new HttpsError("not-found", "Organization not found.");
      }

      // Archive organization
      transaction.update(orgRef, {
        status: "archived",
        archivedAt: FieldValue.serverTimestamp(),
        archivedBy: uid,
      });

      // Update owner's membership status
      transaction.update(memberRef, {
        status: "inactive",
        updatedAt: FieldValue.serverTimestamp(),
      });

      // Audit Log
      const auditRef = db.collection("auditLogs").doc();
      transaction.set(auditRef, {
        organizationId: orgId,
        actorUid: uid,
        action: "DELETE_ORGANIZATION",
        resourceType: "organization",
        resourceId: orgId,
        metadata: {
          organizationName: orgSnap.data()?.name,
        },
        timestamp: FieldValue.serverTimestamp(),
      });
    });

    return { status: "success" };
  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    const detailsMsg = error instanceof Error ? error.message : String(error);
    throw new HttpsError("internal", detailsMsg || "Failed to delete organization.");
  }
});
