import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";

const RECENT_LOGIN_WINDOW_SECONDS = 5 * 60;

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

  // Require a recently-issued ID token for this irreversible action, mirroring the
  // re-authentication the client SDK would otherwise demand for self-deletion.
  const authTime = (request.auth?.token?.auth_time as number | undefined) ?? 0;
  if (Date.now() / 1000 - authTime > RECENT_LOGIN_WINDOW_SECONDS) {
    throw new HttpsError(
      "failed-precondition",
      "For security, please sign out and sign back in before deleting your account."
    );
  }

  const db = getFirestore();
  await db.collection("users").doc(uid).delete();
  await getAuth().deleteUser(uid);

  return { status: "success" };
});
