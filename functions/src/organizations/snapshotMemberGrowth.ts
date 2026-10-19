import { onSchedule } from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import { getFirestore, FieldValue } from "firebase-admin/firestore";

const MAX_ORGS_PER_RUN = 500;

function todayUtc(): string {
  return new Date().toISOString().slice(0, 10); // YYYY-MM-DD
}

/**
 * Daily snapshot of each organization's active member count, written to
 * organizations/{orgId}/memberGrowthSnapshots/{YYYY-MM-DD}. This is the only
 * source of the "Members Growth" chart in the app - there is no backfilled
 * history, so a newly-deployed organization's chart simply starts recording
 * from the first run and fills in over the following days.
 */
export const snapshotMemberGrowth = onSchedule(
  { schedule: "every day 00:05", timeZone: "UTC", timeoutSeconds: 300 },
  async () => {
    const db = getFirestore();
    const date = todayUtc();

    const orgsSnap = await db.collection("organizations").limit(MAX_ORGS_PER_RUN).get();
    let written = 0;
    let failed = 0;

    for (const orgDoc of orgsSnap.docs) {
      try {
        const countResult = await db
          .collection("organizationMembers")
          .where("organizationId", "==", orgDoc.id)
          .where("status", "==", "active")
          .count()
          .get();
        const memberCount = countResult.data().count;

        await db
          .collection("organizations")
          .doc(orgDoc.id)
          .collection("memberGrowthSnapshots")
          .doc(date)
          .set({
            date,
            memberCount,
            updatedAt: FieldValue.serverTimestamp(),
          });
        written++;
      } catch (error) {
        failed++;
        logger.error(`snapshotMemberGrowth failed for org ${orgDoc.id}`, error);
      }
    }

    logger.info(`snapshotMemberGrowth: wrote ${written} snapshots, ${failed} failed, date=${date}`);
  }
);
