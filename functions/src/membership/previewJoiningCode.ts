import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
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

    const expiresAt = codeData.expiresAt ? codeData.expiresAt.toDate() : null;
    if (codeData.status !== "active" || (expiresAt && expiresAt.getTime() <= Date.now())) {
      throw new HttpsError("failed-precondition", "This joining code is no longer active.");
    }

    const maxUses = codeData.maxUses || 0;
    const currentUses = codeData.currentUses || 0;
    if (maxUses > 0 && currentUses >= maxUses) {
      throw new HttpsError("failed-precondition", "This joining code has reached its maximum usage limit.");
    }

    const organizationId = codeData.organizationId as string;

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

    return {
      status: "success",
      organizationId,
      organizationName: name,
      logoUrl,
      verified,
    };
  }
);
