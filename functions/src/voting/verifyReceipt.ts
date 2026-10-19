import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { checkRateLimit } from "../utils/rateLimiter";

export const verifyReceipt = onCall(async (request) => {
  const uid = request.auth?.uid;
  const ip = request.rawRequest?.ip || "unknown-ip";
  const rateLimitKey = uid ? uid : ip;

  await checkRateLimit(rateLimitKey, {
    keyPrefix: "verify",
    maxRequests: 10,
    windowMs: 60 * 1000,
  });

  const hash = typeof request.data?.hash === "string" ? request.data.hash.trim() : "";

  const sha256Regex = /^[A-Fa-f0-9]{64}$/;
  if (!hash || !sha256Regex.test(hash)) {
    throw new HttpsError("invalid-argument", "Valid 64-character hex SHA-256 hash is required.");
  }

  const db = getFirestore();
  const snap = await db.collection("voteReceipts").where("receiptHash", "==", hash).limit(1).get();

  if (snap.empty) {
    throw new HttpsError("not-found", "No matching receipt found.");
  }

  return {
    status: "success",
    verified: true,
  };
});
