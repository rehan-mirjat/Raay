import { onCall } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { createUnauthenticatedError, createPermissionDeniedError, createNotFoundError } from "../utils/errors";
import { writeAuditLog } from "../security/writeAuditLog";

export const suspendOrganization = onCall(async (request) => {
  if (!request.auth) throw createUnauthenticatedError();
  if (request.auth.token.platformAdmin !== true) {
    throw createPermissionDeniedError("Super Admin privilege required.");
  }

  const { organizationId, reason } = request.data || {};
  if (!organizationId) throw new Error("organizationId is required.");

  const db = getFirestore();
  const orgRef = db.collection("organizations").doc(organizationId);
  const orgDoc = await orgRef.get();
  if (!orgDoc.exists) throw createNotFoundError("Organization not found.");

  await orgRef.update({
    status: "suspended",
    suspensionReason: reason || "Administrative suspension",
    suspendedAt: FieldValue.serverTimestamp(),
  });

  await writeAuditLog({
    organizationId,
    actorUid: request.auth.uid,
    action: "ORGANIZATION_SUSPENDED",
    resourceType: "organization",
    resourceId: organizationId,
    metadata: { reason },
  });

  return { status: "success", message: "Organization suspended." };
});
