import { Firestore, Transaction } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";

export type PlanId = "free" | "pro" | "enterprise";

export interface PlanLimits {
  /** Max active members (owner included). null = unlimited. */
  maxMembers: number | null;
  /** Max events that are SCHEDULED or ACTIVE at the same time. null = unlimited. */
  maxLiveEvents: number | null;
  csvExport: boolean;
  observers: boolean;
  /** Ads are shown only to members of organizations on a plan with this flag. */
  showsAds: boolean;
}

/**
 * Single source of truth for plan limits. The Flutter client mirrors this only
 * for display; every limit that matters is enforced here, server-side.
 * Voters are never charged and never blocked from voting by a plan.
 */
export const PLANS: Record<PlanId, PlanLimits> = {
  free: { maxMembers: 50, maxLiveEvents: 2, csvExport: false, observers: false, showsAds: true },
  pro: { maxMembers: 1000, maxLiveEvents: 25, csvExport: true, observers: true, showsAds: false },
  enterprise: { maxMembers: null, maxLiveEvents: null, csvExport: true, observers: true, showsAds: false },
};

export function resolvePlanId(orgData: FirebaseFirestore.DocumentData | undefined): PlanId {
  const plan = orgData?.plan;
  const status = orgData?.planStatus;
  const expiresAt = orgData?.planExpiresAt?.toMillis?.() as number | undefined;
  const paidAndCurrent =
    (plan === "pro" || plan === "enterprise") &&
    (status === "active" || status === "trialing" || status === "past_due") &&
    (expiresAt === undefined || expiresAt > Date.now());
  return paidAndCurrent ? plan : "free";
}

export function limitsFor(orgData: FirebaseFirestore.DocumentData | undefined): PlanLimits {
  return PLANS[resolvePlanId(orgData)];
}

/** Throws if adding one more active member would exceed the organization's plan. */
export async function requireMemberCapacity(
  db: Firestore,
  tx: Transaction,
  organizationId: string,
  orgData: FirebaseFirestore.DocumentData | undefined,
): Promise<void> {
  const max = limitsFor(orgData).maxMembers;
  if (max === null) return;
  const countSnap = await tx.get(
    db.collection("organizationMembers")
      .where("organizationId", "==", organizationId)
      .where("status", "==", "active")
      .count()
  );
  if (countSnap.data().count >= max) {
    throw new HttpsError(
      "failed-precondition",
      `This organization has reached its plan limit of ${max} members. Upgrade the plan to add more.`
    );
  }
}

/** Throws if publishing one more live event would exceed the organization's plan. */
export async function requireLiveEventCapacity(
  db: Firestore,
  tx: Transaction,
  organizationId: string,
  orgData: FirebaseFirestore.DocumentData | undefined,
): Promise<void> {
  const max = limitsFor(orgData).maxLiveEvents;
  if (max === null) return;
  const countSnap = await tx.get(
    db.collection("votingEvents")
      .where("organizationId", "==", organizationId)
      .where("status", "in", ["SCHEDULED", "ACTIVE"])
      .count()
  );
  if (countSnap.data().count >= max) {
    throw new HttpsError(
      "failed-precondition",
      `This plan allows ${max} live elections at a time. Close one or upgrade the plan.`
    );
  }
}
