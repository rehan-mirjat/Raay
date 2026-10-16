import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
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

export const joinOrganizationWithCode = onCall(
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

  // 1. Server-Side Email Verification Check via Firebase Auth Admin SDK
  try {
    const userAuthRecord = await getAuth().getUser(uid);
    if (!userAuthRecord.emailVerified) {
      throw new HttpsError("permission-denied", "Your email address must be verified before joining an organization.");
    }
  } catch (e: any) {
    if (e instanceof HttpsError) throw e;
    throw new HttpsError("permission-denied", "Failed to verify authentication status.", e);
  }

  // 2. Validate User Account in Firestore
  const userSnap = await db.collection("users").doc(uid).get();
  if (!userSnap.exists || userSnap.data()?.status !== "active") {
    throw new HttpsError("permission-denied", "Your account must be active to join an organization.");
  }

  // 3. Atomic Transactional Rate Limiting Check & Counter Increment
  // Table 3-4: "5 failed attempts per user per 10 minutes, then a 15-minute
  // lockout" - see checkJoinCodeAttempt for the (unit-tested) boundary logic.
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

  // 4. Read Joining Code Document Deterministically by `codeHash`
  let codeRef = db.collection("joiningCodes").doc(computedHash);
  let codeSnap = await codeRef.get();

  // Maintain acceptance for codes issued before the HMAC key was rotated.
  if (!codeSnap.exists) {
    const legacySecret = getLegacyJoinCodeSecret();
    if (legacySecret) {
      computedHash = computeCodeHmac(rawCode, legacySecret);
      codeRef = db.collection("joiningCodes").doc(computedHash);
      codeSnap = await codeRef.get();
    }
  }

  if (!codeSnap.exists) {
    throw new HttpsError("invalid-argument", "Invalid joining code.");
  }

  const codeData = codeSnap.data()!;
  const orgId = codeData.organizationId;

  // Table 3-4: "100 failed attempts per organization per hour trigger an
  // organization-level throttle" - a separate, coarser control from the
  // per-user lockout above, so a distributed attack against one org's codes
  // (many different accounts, each under their own per-user limit) is still caught.
  const ORG_THROTTLE_WINDOW_MS = 60 * 60 * 1000;
  const ORG_THROTTLE_MAX = 100;
  const orgThrottleRef = db.collection("joinCodeOrgThrottle").doc(orgId);
  const orgThrottleSnap = await orgThrottleRef.get();
  if (orgThrottleSnap.exists) {
    const d = orgThrottleSnap.data()!;
    if (Date.now() - (d.windowStart || 0) < ORG_THROTTLE_WINDOW_MS && (d.failures || 0) >= ORG_THROTTLE_MAX) {
      throw new HttpsError("resource-exhausted", "This organization is receiving too many failed join attempts. Please try again later.");
    }
  }

  // 5. Transactional Join
  try {
    const result = await db.runTransaction(async (transaction) => {
      // FIRST: Check User Membership inside Transaction (Does NOT count as failed attempt if already member)
      const membershipRef = db.collection("organizationMembers").doc(`${orgId}_${uid}`);
      const memberSnap = await transaction.get(membershipRef);

      if (memberSnap.exists && memberSnap.data()?.status === "active") {
        throw new HttpsError("already-exists", "You are already an active member of this organization.");
      }

      // Re-read code inside transaction
      const freshCodeSnap = await transaction.get(codeRef);
      if (!freshCodeSnap.exists || freshCodeSnap.data()?.status !== "active") {
        throw new HttpsError("failed-precondition", "This joining code is no longer active.");
      }

      const freshCodeData = freshCodeSnap.data()!;

      // Validate Code Expiry
      const expiresAt = freshCodeData.expiresAt ? freshCodeData.expiresAt.toDate() : null;
      if (expiresAt && expiresAt.getTime() <= Date.now()) {
        throw new HttpsError("failed-precondition", "This joining code has expired.");
      }

      // Validate Usage Limit
      const maxUses = freshCodeData.maxUses || 0;
      const currentUses = freshCodeData.currentUses || 0;
      if (maxUses > 0 && currentUses >= maxUses) {
        throw new HttpsError("failed-precondition", "This joining code has reached its maximum usage limit.");
      }

      // Validate Organization Status
      const orgRef = db.collection("organizations").doc(orgId);
      const orgSnap = await transaction.get(orgRef);

      if (!orgSnap.exists) {
        throw new HttpsError("failed-precondition", "Organization no longer exists.");
      }

      const orgStatus = orgSnap.data()?.status;
      if (orgStatus !== "active" && orgStatus !== "verified") {
        throw new HttpsError("failed-precondition", `Organization is currently ${orgStatus} and cannot accept new members.`);
      }

      // SUCCESSFUL JOIN: Transactional Writes
      // Write 1: Create Organization Member Document
      transaction.set(membershipRef, {
        membershipId: `${orgId}_${uid}`,
        organizationId: orgId,
        userId: uid,
        role: "member",
        status: "active",
        employeeId: null,
        departmentId: null,
        joinedAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });

      // Write 2: Increment Code Uses
      transaction.update(codeRef, {
        currentUses: FieldValue.increment(1),
      });

      // Write 3: Audit Log (NO RAW CODES, NO NORMALIZED STRINGS, NO HASHES LOGGED)
      const auditRef = db.collection("auditLogs").doc();
      transaction.set(auditRef, {
        organizationId: orgId,
        actorUid: uid,
        action: "JOIN_ORGANIZATION_WITH_CODE",
        resourceType: "joiningCode",
        resourceId: computedHash,
        metadata: { joiningCodeId: computedHash },
        timestamp: FieldValue.serverTimestamp(),
      });

      // Clear rate limit record on successful join
      transaction.delete(rateLimitRef);

      return {
        organizationId: orgId,
        organizationName: orgSnap.data()?.name || "",
      };
    });

    return {
      status: "success",
      organizationId: result.organizationId,
      organizationName: result.organizationName,
    };
  } catch (error: any) {
    // Count genuine abuse-relevant failures toward the org-level throttle -
    // "already a member" isn't an attack signal, so it's excluded.
    if (!(error instanceof HttpsError && error.code === "already-exists")) {
      await db.runTransaction(async (transaction) => {
        const snap = await transaction.get(orgThrottleRef);
        const d = snap.exists ? snap.data()! : {};
        const windowStart = Date.now() - (d.windowStart || 0) < ORG_THROTTLE_WINDOW_MS ? d.windowStart : Date.now();
        const failures = windowStart === d.windowStart ? (d.failures || 0) + 1 : 1;
        transaction.set(orgThrottleRef, { windowStart, failures }, { merge: true });
      });
    }
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to join organization.", error);
  }
  },
);
