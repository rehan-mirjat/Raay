import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { checkRateLimit } from "../utils/rateLimiter";

/**
 * PUBLIC receipt verifier — intentionally unauthenticated.
 *
 * Design rationale (SRS §4.7 / V1 boundaries §8):
 *  - A receipt hash is a plain SHA-256 digest (not an HMAC) of
 *    orgId:eventId:uid:timestampMillis:salt, where salt is a random per-receipt
 *    value that is discarded after hashing. The hash therefore cannot be
 *    recomputed from those inputs; it is checked only by lookup.
 *    It proves participation without revealing the voter's identity or choice.
 *  - Any third party (observer, auditor, the voter themselves) should be able
 *    to verify a receipt without needing a raay account, exactly like a
 *    paper receipt checked against a public register.
 *  - The response is deliberately minimal:
 *    { status: "success", verified: true, votingEventId: doc.votingEventId, organizationId: doc.organizationId }
 *    No userId, no choiceId, no votedAt is returned.
 *  - Callers can optionally scope verification by passing eventId and/or organizationId.
 *  - Rate-limiting falls back to the caller's IP when no uid is present,
 *    capping at 10 lookups per minute to deter brute-force hash enumeration.
 *
 * NOTE: This does NOT provide cryptographic (ZKP) receipt verification —
 * that is out of V1 scope (see §8). It confirms only that a receipt with
 * the given hash was accepted by this system.
 */
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
  const eventId = typeof request.data?.eventId === "string" && request.data.eventId.trim()
    ? request.data.eventId.trim()
    : undefined;
  const organizationId = typeof request.data?.organizationId === "string" && request.data.organizationId.trim()
    ? request.data.organizationId.trim()
    : undefined;

  const sha256Regex = /^[A-Fa-f0-9]{64}$/;
  if (!hash || !sha256Regex.test(hash)) {
    throw new HttpsError("invalid-argument", "Valid 64-character hex SHA-256 hash is required.");
  }

  const db = getFirestore();
  let query: FirebaseFirestore.Query = db.collection("voteReceipts").where("receiptHash", "==", hash);

  if (eventId) {
    query = query.where("votingEventId", "==", eventId);
  }

  if (organizationId) {
    query = query.where("organizationId", "==", organizationId);
  }

  const snap = await query.limit(1).get();

  if (snap.empty) {
    throw new HttpsError("not-found", "No matching receipt found.");
  }

  const doc = snap.docs[0].data();

  return {
    status: "success",
    verified: true,
    votingEventId: doc.votingEventId,
    organizationId: doc.organizationId,
  };
});
