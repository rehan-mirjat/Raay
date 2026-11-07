import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";
import { requireNotRevoked, requireRecentAuthentication, requireMfaVerified } from "../utils/authorization";
import { checkRateLimit, RATE_LIMIT_SENSITIVE_ACTION } from "../utils/rateLimiter";

/**
 * Deletes the caller's own account. Uses the Admin SDK so it can delete the
 * `users/{uid}` Firestore document (the client is denied this by firestore.rules,
 * and that denial must never be relaxed just to allow self-deletion) - deleting it
 * fires the `onUserDeleted` trigger for related-data cleanup - then deletes the
 * Firebase Auth user record itself.
 */
export const deleteAccount = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  // FR-10 / DEL-REQ-004 / MFA-REQ-001: account deletion requires MFA.
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);
  await requireMfaVerified(request.auth);
  // Table 3-4: "sensitive account actions 5 per hour".
  await checkRateLimit(uid, RATE_LIMIT_SENSITIVE_ACTION);

  const db = getFirestore();
  await db.collection("users").doc(uid).delete();
  await getAuth().deleteUser(uid);

  return { status: "success" };
});
