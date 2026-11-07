import { onCall, HttpsError } from "firebase-functions/v2/https";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { requireActiveMembership, requireNotRevoked, requireRecentAuthentication, requireMfaVerified } from "../utils/authorization";

/** Atomically hands an organization to another active member; the former owner becomes an admin. */
export const transferOrganizationOwnership = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);
  await requireMfaVerified(request.auth);

  const organizationId = typeof request.data?.organizationId === "string" ? request.data.organizationId.trim() : "";
  const targetUid = typeof request.data?.targetUid === "string" ? request.data.targetUid.trim() : "";
  if (!organizationId || !targetUid) throw new HttpsError("invalid-argument", "Organization and new owner are required.");
  if (targetUid === uid) throw new HttpsError("failed-precondition", "You are already the organization owner.");

  const db = getFirestore();
  await db.runTransaction(async (transaction) => {
    const callerRef = db.collection("organizationMembers").doc(`${organizationId}_${uid}`);
    const targetRef = db.collection("organizationMembers").doc(`${organizationId}_${targetUid}`);
    const orgRef = db.collection("organizations").doc(organizationId);
    const [caller, target, organization] = await transaction.getAll(callerRef, targetRef, orgRef);
    await requireActiveMembership(db, organizationId, uid, ["owner"], { preFetchedSnap: caller });
    if (!organization.exists) throw new HttpsError("not-found", "Organization not found.");
    if (!target.exists || target.data()?.status !== "active" || target.data()?.organizationId !== organizationId || target.data()?.userId !== targetUid) {
      throw new HttpsError("failed-precondition", "The new owner must be an active member of this organization.");
    }
    if (organization.data()?.ownerId && organization.data()?.ownerId !== uid) {
      throw new HttpsError("failed-precondition", "Organization ownership is inconsistent; contact platform support.");
    }

    transaction.update(callerRef, { role: "admin", updatedAt: FieldValue.serverTimestamp() });
    transaction.update(targetRef, { role: "owner", updatedAt: FieldValue.serverTimestamp() });
    transaction.update(orgRef, { ownerId: targetUid, updatedAt: FieldValue.serverTimestamp() });
    transaction.set(db.collection("auditLogs").doc(), {
      organizationId, actorUid: uid, action: "TRANSFER_ORGANIZATION_OWNERSHIP",
      resourceType: "organization", resourceId: organizationId,
      metadata: { previousOwnerUid: uid, newOwnerUid: targetUid },
      timestamp: FieldValue.serverTimestamp(),
    });
  });
  return { status: "success", organizationId, newOwnerUid: targetUid };
});
