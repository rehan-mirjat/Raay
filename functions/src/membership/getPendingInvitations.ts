import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { requireActiveMembership } from "../utils/authorization";

export const getPendingInvitations = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  const uid = request.auth.uid;
  const { organizationId } = request.data || {};

  if (!organizationId || typeof organizationId !== "string" || organizationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  }

  const db = getFirestore();

  // Verify caller is active Org Owner or Admin
  await requireActiveMembership(db, organizationId, uid, ["owner", "admin"]);

  // Fetch pending invitations for organization
  const querySnap = await db.collection("organizationInvitations")
    .where("organizationId", "==", organizationId)
    .where("status", "==", "pending")
    .get();

  // Filter out any expired invitations on the fly
  const now = Date.now();
  const invitations = querySnap.docs
    .filter((doc) => {
      const expiresAt = doc.data().expiresAt ? doc.data().expiresAt.toDate().getTime() : Infinity;
      return expiresAt > now;
    })
    .map((doc) => {
      const data = doc.data();
      return {
        invitationId: data.id || doc.id, // Opaque invitation ID only
        email: data.email || "",
        role: data.role || "member",
        status: data.status || "pending",
        expiresAt: data.expiresAt ? data.expiresAt.toDate().toISOString() : null,
        createdAt: data.createdAt ? data.createdAt.toDate().toISOString() : null,
      };
    });

  return {
    status: "success",
    invitations: invitations,
  };
});
