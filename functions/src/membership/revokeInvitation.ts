import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireActiveMembership, requireOperationalOrganization } from "../utils/authorization";

export const revokeInvitation = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  const uid = request.auth.uid;
  const { invitationId } = request.data || {};

  if (!invitationId || typeof invitationId !== "string" || invitationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid invitationId is required to revoke an invitation.");
  }

  const db = getFirestore();

  // Invitations are keyed by their own opaque id (see inviteMember.ts), so a
  // direct doc lookup is both cheaper and more robust than a query.
  const invitationRef = db.collection("organizationInvitations").doc(invitationId.trim());

  await db.runTransaction(async (transaction) => {
    const invSnap = await transaction.get(invitationRef);
    if (!invSnap.exists) {
      throw new HttpsError("not-found", "Invitation document no longer exists.");
    }

    const invData = invSnap.data()!;
    const orgId = invData.organizationId;
    const invRole = invData.role;
    const targetEmail = invData.email;
    const tokenHash = invData.tokenHash;

    if (invData.status !== "pending") {
      throw new HttpsError("failed-precondition", `This invitation is already ${invData.status} and cannot be revoked.`);
    }

    // Verify caller's membership in target organization
    const { role: callerRole } = await requireActiveMembership(
      db, orgId, uid, ["owner", "admin"], { tx: transaction }
    );

    await requireOperationalOrganization(db, orgId, transaction);

    // Role Revocation Hierarchy: Only Owner can revoke an Admin-level invitation
    if (invRole === "admin" && callerRole !== "owner") {
      throw new HttpsError("permission-denied", "Access denied: Only the Organization Owner can revoke an Admin-level invitation.");
    }

    // Update Invitation Status
    transaction.update(invitationRef, {
      status: "revoked",
      revokedAt: FieldValue.serverTimestamp(),
    });

    // Delete Duplicate Lock Document so a new invitation can be re-issued
    if (targetEmail) {
      const lockRef = db.collection("organizationInvitationKeys").doc(`${orgId}_${targetEmail}`);
      transaction.delete(lockRef);
    }

    // Delete Token Lookup Mapping to clean up credential material
    if (tokenHash) {
      const tokenLookupRef = db.collection("organizationInvitationTokens").doc(tokenHash);
      transaction.delete(tokenLookupRef);
    }

    // Write Audit Log (resourceId is opaque invitationId; NO raw tokens/hashes logged)
    const auditRef = db.collection("auditLogs").doc();
    transaction.set(auditRef, {
      organizationId: orgId,
      actorUid: uid,
      action: "REVOKE_INVITATION",
      resourceType: "organizationInvitation",
      resourceId: invitationId,
      metadata: { targetEmail: targetEmail, role: invRole },
      timestamp: FieldValue.serverTimestamp(),
    });
  });

  return { status: "success" };
});
