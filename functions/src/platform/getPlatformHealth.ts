import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { logger } from "firebase-functions";
import { HttpsError, onCall } from "firebase-functions/v2/https";

/**
 * Read-only, platform-admin diagnostics. It probes the callable, Firestore,
 * and the configured Cloud Storage bucket; it does not claim anything about
 * email/push delivery or client devices.
 */
export const getPlatformHealth = onCall(async (request) => {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "Authentication is required.");
  }
  if (request.auth.token.platformAdmin !== true) {
    throw new HttpsError("permission-denied", "Platform administrator access required.");
  }

  const checkedAt = new Date().toISOString();
  const firestoreStartedAt = Date.now();
  let firestoreLatencyMs: number;
  let firestore = "ok";
  try {
    await getFirestore().collection("organizations").limit(1).get();
    firestoreLatencyMs = Date.now() - firestoreStartedAt;
  } catch (error) {
    // Keep infrastructure details in server logs, never in the client payload.
    logger.error("Platform health Firestore probe failed", error);
    firestore = "unavailable";
    firestoreLatencyMs = Date.now() - firestoreStartedAt;
  }

  const storageStartedAt = Date.now();
  let storage = "ok";
  try {
    const [exists] = await getStorage().bucket().exists();
    if (!exists) storage = "unavailable";
  } catch (error) {
    logger.error("Platform health Storage probe failed", error);
    storage = "unavailable";
  }

  return {
    checkedAt,
    functions: "ok",
    firestore,
    firestoreLatencyMs,
    storage,
    storageLatencyMs: Date.now() - storageStartedAt,
  };
});
