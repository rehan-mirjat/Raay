import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";
import * as crypto from "crypto";
import {
  getJoinCodeSecret,
  getLegacyJoinCodeSecret,
  JOIN_CODE_SECRET,
  LEGACY_JOIN_CODE_SECRET,
} from "../utils/joinCodeSecret";
import { requireNotRevoked } from "../utils/authorization";
import { checkJoinCodeAttempt } from "../utils/joinCodeAttemptLimiter";

function computeCodeHmac(rawCode: string, secret = getJoinCodeSecret()): string {
  const normalized = rawCode.trim().toUpperCase().replace(/[\s-]/g, "");
  return crypto.createHmac("sha256", secret).update(normalized).digest("hex");
}

const ORG_THROTTLE_WINDOW_MS = 60 * 60 * 1000;
const ORG_THROTTLE_MAX = 100;

/**
 * Resolves a joining code to the organization it belongs to, WITHOUT joining
 * - lets the member confirm "is this the organization I expect?" before
 * committing, mirroring joinOrganizationWithCode's validation exactly so a
 * code that previews successfully is guaranteed to also join successfully.
 * Shares that function's rate-limit state (same joinCodeRateLimit/
 * joinCodeOrgThrottle documents): a preview is just as viable a vector for
 * code-guessing as an actual join attempt would be, so it must count
 * against the same limits rather than opening a free side channel.
 */
export const previewJoiningCode = onCall(
  { secrets: [JOIN_CODE_SECRET, LEGACY_JOIN_CODE_SECRET] },
  async (request) => {
    if (!request.auth || !request.auth.uid) {
      throw new HttpsError("unauthenticated", "Authentication required.");
    }

    await requireNotRevoked(request);

    const uid = request.auth.uid;
    const { rawCode } = request.data || {};

    if (!rawCode || typeof rawCode !== "string" || rawCode.trim().length === 0) {
      throw new HttpsError("invalid-argument", "Valid joining code is required.");
    }

    const db = getFirestore();

    // Same account-eligibility checks joinOrganizationWithCode performs, so
    // a successful preview can't promise a join that's actually blocked here.
    try {
      const userAuthRecord = await getAuth().getUser(uid);
      if (!userAuthRecord.emailVerified) {
        throw new HttpsError("permission-denied", "Your email address must be verified before joining an organization.");
      }
    } catch (e: any) {
      if (e instanceof HttpsError) throw e;
      throw new HttpsError("permission-denied", "Failed to verify authentication status.", e);
    }

    const userSnap = await db.collection("users").doc(uid).get();
    if (!userSnap.exists || userSnap.data()?.status !== "active") {
      throw new HttpsError("permission-denied", "Your account must be active to join an organization.");
    }

    // Table 3-4: "5 failed attempts per user per 10 minutes, then a 15-minute
    // lockout" - shared with joinOrganizationWithCode via the same document.
    const rateLimitRef = db.collection("joinCodeRateLimit").doc(uid);
    const now = Date.now();

    await db.runTransaction(async (transaction) => {
      const rateLimitSnap = await transaction.get(rateLimitRef);
      const state = rateLimitSnap.exists ? rateLimitSnap.data()! : {};
      const result = checkJoinCodeAttempt(now, state);
      transaction.set(rateLimitRef, result.nextState, { merge: true });
      if (!result.allowed) {
        throw new HttpsError(
          "resource-exhausted",
          `Too many failed attempts. Please wait ${Math.ceil((result.retryAfterMs ?? 0) / 1000)} seconds before trying again.`
        );
      }
    });

    let computedHash = computeCodeHmac(rawCode);
    let codeSnap = await db.collection("joiningCodes").doc(computedHash).get();

    if (!codeSnap.exists) {
      const legacySecret = getLegacyJoinCodeSecret();
      if (legacySecret) {
        computedHash = computeCodeHmac(rawCode, legacySecret);
        codeSnap = await db.collection("joiningCodes").doc(computedHash).get();
      }
    }

    if (!codeSnap.exists) {
      throw new HttpsError("invalid-argument", "Invalid joining code.");
    }

    const codeData = codeSnap.data()!;
    const organizationId = codeData.organizationId as string;

    // Table 3-4: "100 failed attempts per organization per hour trigger an
    // organization-level throttle" - a coarser control catching a distributed
    // attack spread across many accounts, each under their own per-user limit.
    const orgThrottleRef = db.collection("joinCodeOrgThrottle").doc(organizationId);
    const orgThrottleSnap = await orgThrottleRef.get();
    if (orgThrottleSnap.exists) {
      const d = orgThrottleSnap.data()!;
      if (Date.now() - (d.windowStart || 0) < ORG_THROTTLE_WINDOW_MS && (d.failures || 0) >= ORG_THROTTLE_MAX) {
        throw new HttpsError("resource-exhausted", "This organization is receiving too many failed join attempts. Please try again later.");
      }
    }

    try {
      const expiresAt = codeData.expiresAt ? codeData.expiresAt.toDate() : null;
      if (codeData.status !== "active" || (expiresAt && expiresAt.getTime() <= Date.now())) {
        throw new HttpsError("failed-precondition", "This joining code is no longer active.");
      }

      const maxUses = codeData.maxUses || 0;
      const currentUses = codeData.currentUses || 0;
      if (maxUses > 0 && currentUses >= maxUses) {
        throw new HttpsError("failed-precondition", "This joining code has reached its maximum usage limit.");
      }

      // Prefer the synced public projection; fall back to a privileged direct
      // read for an organization that existed before syncOrganizationPublic
      // was deployed and hasn't been written to since.
      const publicSnap = await db.collection("organizationPublic").doc(organizationId).get();
      let name: string;
      let logoUrl: string | null;
      let verified: boolean;
      let orgStatus: string;

      if (publicSnap.exists) {
        const p = publicSnap.data()!;
        name = p.name ?? "Organization";
        logoUrl = p.logoUrl ?? null;
        verified = p.verified === true;
        orgStatus = p.status ?? "pending";
      } else {
        const orgSnap = await db.collection("organizations").doc(organizationId).get();
        const o = orgSnap.data() || {};
        name = o.name ?? "Organization";
        logoUrl = o.logoUrl ?? null;
        orgStatus = o.status ?? "pending";
        verified = orgStatus === "verified" || orgStatus === "active";
      }

      // Keep this in lockstep with joinOrganizationWithCode's own org-status
      // check, so a successful preview is a reliable promise that the actual
      // join will succeed too.
      if (orgStatus !== "active" && orgStatus !== "verified") {
        throw new HttpsError("failed-precondition", `Organization is currently ${orgStatus} and cannot accept new members.`);
      }

      // A successful preview isn't an attack signal, so it shouldn't eat into
      // the budget the real join attempt needs - clear it, same as a
      // successful join does.
      await rateLimitRef.delete().catch(() => {});

      return {
        status: "success",
        organizationId,
        organizationName: name,
        logoUrl,
        verified,
      };
    } catch (error: any) {
      // Count genuine abuse-relevant failures toward the org-level throttle.
      await db.runTransaction(async (transaction) => {
        const snap = await transaction.get(orgThrottleRef);
        const d = snap.exists ? snap.data()! : {};
        const windowStart = Date.now() - (d.windowStart || 0) < ORG_THROTTLE_WINDOW_MS ? d.windowStart : Date.now();
        const failures = windowStart === d.windowStart ? (d.failures || 0) + 1 : 1;
        transaction.set(orgThrottleRef, { windowStart, failures }, { merge: true });
      });
      if (error instanceof HttpsError) throw error;
      throw new HttpsError("internal", "Failed to preview this joining code.", error);
    }
  }
);
