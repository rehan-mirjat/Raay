import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions";
import { HttpsError, onCall } from "firebase-functions/v2/https";

/**
 * Read-only, platform-admin diagnostics. This proves that this callable and a
 * Firestore read completed; it intentionally makes no claims about Storage,
 * client devices, or other services that it does not probe.
 */
export const getPlatformHealth = onCall(async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "Authentication is required.");
  }
  if (request.auth.token.platformAdmin !== true) {
    throw new HttpsError("permission-denied", "Platform administrator access required.");
  }

  const checkedAt = new Date().toISOString();
  const startedAt = Date.now();
  try {
    await getFirestore().collection("organizations").limit(1).get();
    return {
      checkedAt,
      functions: "ok",
      firestore: "ok",
      firestoreLatencyMs: Date.now() - startedAt,
    };
  } catch (error) {
    // Keep infrastructure details in server logs, never in the client payload.
    logger.error("Platform health Firestore probe failed", error);
    return {
      checkedAt,
      functions: "ok",
      firestore: "unavailable",
      firestoreLatencyMs: Date.now() - startedAt,
    };
  }
});
