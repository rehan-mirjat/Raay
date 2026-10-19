import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireActiveMembership, requireOperationalOrganization, requireNotRevoked, requireRecentAuthentication } from "../utils/authorization";

export const removeMember = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  // FR-10: removing a member is an explicitly-named sensitive operation.
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);

  const uid = request.auth.uid;
  const { organizationId, targetUid } = request.data || {};

  if (!organizationId || typeof organizationId !== "string" || organizationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  }

  if (!targetUid || typeof targetUid !== "string" || targetUid.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid targetUid is required.");
  }

  if (uid === targetUid) {
    throw new HttpsError("permission-denied", "You cannot remove yourself through this API. Use leaveOrganization instead.");
  }

  const db = getFirestore();

  try {
    await db.runTransaction(async (transaction) => {
      const callerRef = db.collection("organizationMembers").doc(`${organizationId}_${uid}`);
      const targetRef = db.collection("organizationMembers").doc(`${organizationId}_${targetUid}`);

      const [callerSnap, targetSnap] = await transaction.getAll(callerRef, targetRef);

      const { role: callerRole } = await requireActiveMembership(
        db, organizationId, uid, ["owner", "admin"], { preFetchedSnap: callerSnap }
      );

      await requireOperationalOrganization(db, organizationId, transaction);

      if (!targetSnap.exists) {
        throw new HttpsError("not-found", "Target user is not a member of this organization.");
      }

      const targetRole = targetSnap.data()?.role;
      const targetStatus = targetSnap.data()?.status;

      if (targetRole === "owner") {
        throw new HttpsError("permission-denied", "You cannot remove an owner. Ownership must be transferred first.");
      }

      if (targetRole === "admin" && callerRole !== "owner") {
        throw new HttpsError("permission-denied", "Only the Organization Owner can remove an Admin.");
      }

      // Hard Delete
      transaction.delete(targetRef);

      // Audit Log
      const auditRef = db.collection("auditLogs").doc();
      transaction.set(auditRef, {
        organizationId: organizationId,
        actorUid: uid,
        action: "REMOVE_MEMBER",
        resourceType: "organizationMember",
        resourceId: targetUid,
        metadata: {
          targetUid: targetUid,
          previousRole: targetRole,
          previousStatus: targetStatus,
        },
        timestamp: FieldValue.serverTimestamp(),
      });
    });

    return { status: "success" };
  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    console.error("removeMember failed", error);
    throw new HttpsError("internal", "Failed to remove member.");
  }
});
