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

/** Table 3-4: 3 organization-creation attempts per user per 24 hours. */
export const RATE_LIMIT_ORG_CREATION = {
  keyPrefix: "org_creation",
  maxRequests: 3,
  windowMs: 24 * 60 * 60 * 1000,
};

/** Table 3-4: "Invitation actions 30 per hour" - covers inviteMember, createJoiningCode,
 * revokeJoiningCode and revokeInvitation as one per-user bucket, per the thesis wording. */
export const RATE_LIMIT_INVITATION_ACTION = {
  keyPrefix: "invitation_action",
  maxRequests: 30,
  windowMs: 60 * 60 * 1000,
};

/**
 * Table 3-4: "5 failed attempts per user per 10 minutes, then a 15-minute lockout."
 * Approximated as a single 15-minute window capped at 5 attempts (the 6th+ attempt
 * is denied for the remainder of that window) rather than a separate two-phase
 * accrual+lockout state machine - noted as an approximation, not an exact match,
 * since the existing fixed-window primitive doesn't support two distinct durations.
 */
export const RATE_LIMIT_JOINING_CODE_ATTEMPT = {
  keyPrefix: "joining_code_attempt",
  maxRequests: 5,
  windowMs: 15 * 60 * 1000,
};

/** Table 3-4: "sensitive account actions 5 per hour" (e.g. account deletion). */
export const RATE_LIMIT_SENSITIVE_ACTION = {
  keyPrefix: "sensitive_action",
  maxRequests: 5,
  windowMs: 60 * 60 * 1000,
};
