import { onCall } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { createUnauthenticatedError, createPermissionDeniedError, createNotFoundError } from "../utils/errors";
import { writeAuditLog } from "../security/writeAuditLog";

export const verifyOrganization = onCall(async (request) => {
  if (!request.auth) throw createUnauthenticatedError();
  if (request.auth.token.platformAdmin !== true) {
    throw createPermissionDeniedError("Super Admin privilege required.");
  }

  const { organizationId } = request.data || {};
  if (!organizationId) throw new Error("organizationId is required.");

  const db = getFirestore();
  const orgRef = db.collection("organizations").doc(organizationId);
  const orgDoc = await orgRef.get();
  if (!orgDoc.exists) throw createNotFoundError("Organization not found.");

  await orgRef.update({
    status: "verified",
    verifiedAt: FieldValue.serverTimestamp(),
    verifiedBy: request.auth.uid,
  });

  await writeAuditLog({
    organizationId,
    actorUid: request.auth.uid,
    action: "ORGANIZATION_VERIFIED",
    resourceType: "organization",
    resourceId: organizationId,
  });

  return { status: "success", message: "Organization verified." };
});
