import { HttpsError } from "firebase-functions/v2/https";
import { Firestore, Transaction, DocumentSnapshot } from "firebase-admin/firestore";
import { OPERATIONAL_ORG_STATUSES } from "../voting_events/votingCommon";

export function isPlatformAdmin(auth: { token?: Record<string, unknown> } | undefined): boolean {
  return auth?.token?.platformAdmin === true;
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
