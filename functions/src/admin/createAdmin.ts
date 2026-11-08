import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { requireMfaVerified, requireNotRevoked, requireRecentAuthentication } from "../utils/authorization";

/** Grants the platform-admin custom claim to an existing verified account. */
export const createAdmin = onCall(async (request) => {
  const actorUid = request.auth?.uid;
  if (!actorUid) throw new HttpsError("unauthenticated", "Authentication is required.");
  if (request.auth?.token.platformAdmin !== true) {
    throw new HttpsError("permission-denied", "Platform administrator access required.");
  }

  // FR-10 / MFA-REQ-001: granting privileged access is a role/privilege change - sensitive.
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);
  await requireMfaVerified(request.auth);

  const email = typeof request.data?.email === "string"
    ? request.data.email.trim().toLowerCase()
    : "";
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    throw new HttpsError("invalid-argument", "Enter a valid account email address.");
  }

  let target;
  try {
    target = await getAuth().getUserByEmail(email);
  } catch (error: any) {
    if (error?.code === "auth/user-not-found") {
      throw new HttpsError("not-found", "No raay account uses that email address.");
    }
    console.error("createAdmin could not find the requested account", { code: error?.code ?? "unknown" });
    throw new HttpsError("unavailable", "The account could not be checked. Try again.");
  }

  if (target.disabled || !target.emailVerified) {
    throw new HttpsError("failed-precondition", "The account must be active and email-verified before platform access is granted.");
  }
  if (target.customClaims?.platformAdmin === true) {
    throw new HttpsError("already-exists", "This account is already a Platform Super Admin.");
  }

  await getAuth().setCustomUserClaims(target.uid, {
    ...(target.customClaims ?? {}),
    platformAdmin: true,
  });
  await getFirestore().collection("platformAuditLogs").add({
    actorUid,
    action: "PLATFORM_ADMIN_ACCESS_GRANTED",
    targetUid: target.uid,
    timestamp: FieldValue.serverTimestamp(),
  });

  return { status: "success", uid: target.uid, email };
});
