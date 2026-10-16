import { HttpsError, CallableRequest } from "firebase-functions/v2/https";
import { Firestore, Transaction, DocumentSnapshot } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";
import { OPERATIONAL_ORG_STATUSES } from "../voting_events/votingCommon";

/**
 * Single source of truth for numeric security parameters (SRS Table 3-4) -
 * defined once and referenced by identifier so code and specification cannot
 * silently drift apart.
 */

/** FR-10 / MFA-REQ-006 / DEL-REQ-004: sensitive operations require authentication within this window. */
export const RECENT_AUTH_WINDOW_SECONDS = 900;

/** Table 3-4: joining codes and invitation tokens may not outlive this. */
export const MAX_CREDENTIAL_EXPIRY_HOURS = 24 * 30; // 30 days

export function isPlatformAdmin(auth: { token?: Record<string, unknown> } | undefined): boolean {
  return auth?.token?.platformAdmin === true;
}

/**
 * FR-10: sensitive operations require that the caller's ID token was issued
 * (auth_time) within RECENT_AUTH_WINDOW_SECONDS of the server's own clock.
 * auth_time is a Firebase-signed claim the client cannot forge.
 */
export function requireRecentAuthentication(auth: CallableRequest["auth"]): void {
  const authTime = auth?.token?.auth_time as number | undefined;
  if (typeof authTime !== "number" || !Number.isFinite(authTime)) {
    throw new HttpsError("failed-precondition", "A valid authentication timestamp is required for this action.");
  }
  const ageSeconds = Date.now() / 1000 - authTime;
  if (ageSeconds > RECENT_AUTH_WINDOW_SECONDS || ageSeconds < 0) {
    throw new HttpsError(
      "failed-precondition",
      "For security, please sign out and sign back in before performing this action."
    );
  }
}

/**
 * SEC-08: verifies the caller's raw ID token with Firebase's revocation check,
 * so a disabled/revoked session is rejected immediately rather than only at
 * natural token expiry (~60 minutes). request.auth alone does NOT guarantee
 * this - the Functions Framework verifies signature/expiry but not revocation.
 */
export async function requireNotRevoked(request: CallableRequest): Promise<void> {
  const authHeader = request.rawRequest?.headers?.authorization;
  const idToken = typeof authHeader === "string" ? authHeader.replace(/^Bearer /i, "") : undefined;
  if (!idToken) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }
  try {
    await getAuth().verifyIdToken(idToken, /* checkRevoked */ true);
  } catch (error: unknown) {
    const code = (error as { code?: string })?.code;
    if (code === "auth/id-token-revoked") {
      throw new HttpsError("unauthenticated", "Your session has been revoked. Please sign in again.");
    }
    throw new HttpsError("unauthenticated", "Your session is no longer valid. Please sign in again.");
  }
}

/**
 * FR-09 / MFA-REQ-001-005: MFA state is read live from Firebase Auth (Admin
 * SDK), never from a Firestore field - a client-writable flag is never proof.
 *
 * NOT WIRED INTO ANY CALLABLE YET. The Flutter client has no MFA enrollment
 * flow at all - lib/features/auth/presentation/profile_screen.dart:231 is a
 * literal placeholder ("...will be implemented shortly."). Calling this from
 * any production function today would permanently lock out every current
 * Owner/Admin, since none of them have any way to enroll a second factor.
 * This helper is correct and ready; wire it in only after a real client-side
 * enrollment UI ships.
 */
export async function requireMfaEnrolled(uid: string): Promise<void> {
  const user = await getAuth().getUser(uid);
  const factors = user.multiFactor?.enrolledFactors ?? [];
  if (factors.length === 0) {
    throw new HttpsError(
      "failed-precondition",
      "This action requires multi-factor authentication to be enabled on your account."
    );
  }
}

/** Blocks membership/department management while an organization is suspended (or otherwise non-operational). */
export async function requireOperationalOrganization(
  db: Firestore,
  organizationId: string,
  tx?: Transaction
): Promise<void> {
  const ref = db.collection("organizations").doc(organizationId);
  const snap = tx ? await tx.get(ref) : await ref.get();
  if (!snap.exists || !OPERATIONAL_ORG_STATUSES.includes(snap.data()?.status)) {
    throw new HttpsError("failed-precondition", "This organization is not currently active.");
  }
}

/**
 * The single source of truth for "is this uid an active member (optionally with
 * one of allowedRoles) of this organization?" - callers inside a transaction
 * that already fetched the membership doc (e.g. via a batched `getAll`) should
 * pass `preFetchedSnap` to avoid a redundant read; callers that haven't read it
 * yet but are inside a transaction should pass `tx` instead.
 */
export async function requireActiveMembership(
  db: Firestore,
  organizationId: string,
  uid: string,
  allowedRoles?: string[],
  opts?: { tx?: Transaction; preFetchedSnap?: DocumentSnapshot }
): Promise<{ role: string }> {
  const ref = db.collection("organizationMembers").doc(`${organizationId}_${uid}`);
  const snap = opts?.preFetchedSnap ?? (opts?.tx ? await opts.tx.get(ref) : await ref.get());
  const data = snap.data();
  if (!snap.exists || data?.status !== "active") {
    throw new HttpsError("permission-denied", "You are not an active member of this organization.");
  }
  if (data.organizationId !== organizationId || data.userId !== uid) {
    throw new HttpsError("permission-denied", "Membership record is invalid.");
  }
  const role = data.role as string;
  if (allowedRoles && !allowedRoles.includes(role)) {
    throw new HttpsError("permission-denied", "Insufficient organization role.");
  }
  return { role };
}
