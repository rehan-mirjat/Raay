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
export async function requireNotRevoked(request: CallableRequest): Promise<import("firebase-admin/auth").DecodedIdToken> {
  const authHeader = request.rawRequest?.headers?.authorization;
  const idToken = typeof authHeader === "string" ? authHeader.replace(/^Bearer /i, "") : undefined;
  if (!idToken) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }
  try {
    return await getAuth().verifyIdToken(idToken, /* checkRevoked */ true);
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
 * STATUS: WIRED. The Flutter client ships TOTP enrollment
 * (lib/core/widgets/totp_enroll_dialog.dart, Profile > Security). A caller
 * without an enrolled factor is NOT auto-prompted: they receive the
 * failed-precondition message below telling them where to enable it.
 * Roll out by asking Owners/Admins to enroll BEFORE deploying.
 *
 * WIRED INTO:
 *  - deleteOrganization  (org deletion)
 *  - updateMemberRole    (role escalation/demotion)
 *  - removeMember        (member removal)
 *  - publishVotingEvent  (election go-live)
 *  - closeVotingEvent    (early close)
 *  - deleteAccount       (account deletion)
 *
 * Callers pass the uid AFTER requireNotRevoked and requireRecentAuthentication
 * so we skip those extra Admin SDK round-trips when auth is already rejected.
 */
export async function requireMfaEnrolled(uid: string): Promise<void> {
  const user = await getAuth().getUser(uid);
  const factors = user.multiFactor?.enrolledFactors ?? [];
  if (factors.length === 0) {
    throw new HttpsError(
      "failed-precondition",
      "Two-factor authentication is required for this action. Open Profile > Security & Settings, turn on two-factor authentication, then try again."
    );
  }
}

/** Sensitive operations require an MFA-authenticated session, not enrollment alone.
 * Call only after requireNotRevoked; auth contains Firebase-signed claims.
 */
export async function requireMfaVerified(auth: CallableRequest["auth"]): Promise<void> {
  if (!auth) throw new HttpsError("unauthenticated", "Authentication required.");
  await requireMfaEnrolled(auth.uid);
  const factor = auth.token.firebase?.sign_in_second_factor;
  if (factor !== "totp" && factor !== "phone") {
    throw new HttpsError(
      "failed-precondition",
      "Sign out and sign back in using two-factor authentication before performing this action.",
      { reason: "MFA_SESSION_REQUIRED" }
    );
  }
}

/** Blocks membership/department management while an organization is suspended (or otherwise non-operational). */
export async function requireOperationalOrganization(
  db: Firestore,
  organizationId: string,
  tx?: Transaction,
  opts?: { preFetchedSnap?: DocumentSnapshot }
): Promise<DocumentSnapshot> {
  const ref = db.collection("organizations").doc(organizationId);
  const snap = opts?.preFetchedSnap ?? (tx ? await tx.get(ref) : await ref.get());
  if (!snap.exists || !OPERATIONAL_ORG_STATUSES.includes(snap.data()?.status)) {
    throw new HttpsError("failed-precondition", "This organization is not currently active.");
  }
  return snap;
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
