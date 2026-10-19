import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireActiveMembership, requireOperationalOrganization, requireNotRevoked, requireRecentAuthentication } from "../utils/authorization";

/**
 * Package D2's Observer capability: a narrow READ-ONLY flag layered on an
 * EXISTING membership (isObserver: boolean on organizationMembers), not a
 * new entry in the owner/admin/member role enum. That enum is checked
 * throughout the rules and every callable (requireActiveMembership's
 * allowedRoles, isOwnerOrAdmin, etc.) - inserting a fourth value there would
 * mean auditing every one of those call sites for whether "observer" should
 * match or not. A boolean a caller can check in the one or two places that
 * actually grant Observers something (getEventMonitoring.ts; nothing else
 * changes) is safer and the spec explicitly allows this: "determine whether
 * a narrowly scoped observer permission set is safer than a new role."
 *
 * Granting this does not change the member's role, elevate any write
 * capability, or affect any existing permission check - it only makes
 * getEventMonitoring callable for this member on active/scheduled elections,
 * returning organization-wide aggregates only (no department breakdown or
 * timing history - see getEventMonitoring.ts for why).
 */
export const setObserverStatus = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);

  const uid = request.auth.uid;
  const { organizationId, targetUid, isObserver } = request.data || {};

  if (!organizationId || typeof organizationId !== "string" || organizationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  }
  if (!targetUid || typeof targetUid !== "string" || targetUid.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid targetUid is required.");
  }
  if (typeof isObserver !== "boolean") {
    throw new HttpsError("invalid-argument", "isObserver must be a boolean.");
  }

  const db = getFirestore();

  try {
    await db.runTransaction(async (transaction) => {
      const callerRef = db.collection("organizationMembers").doc(`${organizationId}_${uid}`);
      const targetRef = db.collection("organizationMembers").doc(`${organizationId}_${targetUid}`);
      const [callerSnap, targetSnap] = await transaction.getAll(callerRef, targetRef);

      await requireActiveMembership(db, organizationId, uid, ["owner", "admin"], { preFetchedSnap: callerSnap });
      await requireOperationalOrganization(db, organizationId, transaction);

      if (!targetSnap.exists || targetSnap.data()?.status !== "active") {
        throw new HttpsError("not-found", "Target user is not an active member of this organization.");
      }
      if (targetSnap.data()?.isObserver === isObserver) {
        throw new HttpsError("failed-precondition",
          `Member is already ${isObserver ? "an observer" : "not an observer"}.`);
      }

      transaction.update(targetRef, {
        isObserver,
        updatedAt: FieldValue.serverTimestamp(),
      });

      const auditRef = db.collection("auditLogs").doc();
      transaction.set(auditRef, {
        organizationId,
        actorUid: uid,
        action: isObserver ? "GRANT_OBSERVER_STATUS" : "REVOKE_OBSERVER_STATUS",
        resourceType: "organizationMember",
        resourceId: targetUid,
        metadata: { targetUid },
        timestamp: FieldValue.serverTimestamp(),
      });
    });

    return { status: "success" };
  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    console.error("setObserverStatus failed", error);
    throw new HttpsError("internal", "Failed to update observer status.");
  }
});
