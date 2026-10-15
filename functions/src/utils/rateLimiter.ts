import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { createResourceExhaustedError } from "./errors";

interface RateLimitConfig {
  keyPrefix: string;
  maxRequests: number;
  windowMs: number;
}

export async function checkRateLimit(
  uid: string,
  config: RateLimitConfig
): Promise<void> {
  const db = getFirestore();
  const now = Date.now();
  const docId = `${config.keyPrefix}_${uid}`;
  const ref = db.collection("_rateLimits").doc(docId);

  await db.runTransaction(async (transaction) => {
    const doc = await transaction.get(ref);
    if (!doc.exists) {
      transaction.set(ref, {
        count: 1,
        resetAt: now + config.windowMs,
      });
      return;
    }

    const data = doc.data()!;
    if (now > data.resetAt) {
      transaction.set(ref, {
        count: 1,
        resetAt: now + config.windowMs,
      });
      return;
    }

    if (data.count >= config.maxRequests) {
      throw createResourceExhaustedError(
        `Rate limit reached for ${config.keyPrefix}. Try again in ${Math.ceil(
          (data.resetAt - now) / 1000
        )} seconds.`
      );
    }

    transaction.update(ref, {
      count: FieldValue.increment(1),
    });
  });
}

export const RATE_LIMIT_VOTE = {
  keyPrefix: "vote_submission",
  maxRequests: 10,
  windowMs: 60 * 1000,
};

export const RATE_LIMIT_GENERIC_RPC = {
  keyPrefix: "generic_rpc",
  maxRequests: 30,
  windowMs: 60 * 60 * 1000,
};

export const RATE_LIMIT_SMS = {
  keyPrefix: "sms_auth",
  maxRequests: 5,
  windowMs: 60 * 60 * 1000,
};
