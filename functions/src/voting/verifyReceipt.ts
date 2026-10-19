import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";

export const verifyReceipt = onCall(async (request) => {
  const hash = typeof request.data?.hash === "string" ? request.data.hash.trim() : "";
  if (!hash || hash.length !== 64) {
    throw new HttpsError("invalid-argument", "Valid 64-character SHA-256 hash is required.");
  }

  const db = getFirestore();
  const snap = await db.collection("voteReceipts").where("receiptHash", "==", hash).limit(1).get();

  if (snap.empty) {
    throw new HttpsError("not-found", "No matching receipt found in the ledger.");
  }

  const data = snap.docs[0].data();
  return {
    status: "success",
    verified: true,
    votedAt: data.votedAt?.toDate()?.toISOString(),
    privacyMode: data.privacyMode,
    votingEventId: data.votingEventId,
    organizationId: data.organizationId,
  };
});
