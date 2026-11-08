import { onCall, HttpsError } from "firebase-functions/v2/https";
import { OPERATIONAL_ORG_STATUSES } from "../voting_events/votingCommon";
import { getFirestore, FieldValue, Firestore, DocumentData } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { requireActiveMembership, requireMfaVerified, requireNotRevoked, requireRecentAuthentication } from "../utils/authorization";
import { getEligibleMembers, publishEventResults } from "../results/tally";
import { filterOptedIn } from "../utils/notificationPreferences";

const NOTIFICATIONS_BATCH_SIZE = 400; // headroom under Firestore's 500-write batch limit

/**
 * Best-effort "results published" notification to eligible members who
 * haven't opted out (eventUpdates preference). Failures here are logged and
 * swallowed - results are already published and committed by this point, so
 * a notification-delivery problem must never surface as a publish failure.
 */
async function notifyResultsPublished(
  db: Firestore,
  organizationId: string,
  eventId: string,
  event: DocumentData
): Promise<void> {
  try {
    const eligibleMembers = await getEligibleMembers(db, organizationId, eventId, event);
    if (eligibleMembers.length === 0) return;

    const optedInUserIds = new Set(
      await filterOptedIn(db, eligibleMembers.filter((m) => m.active !== false).map((m) => m.userId), "eventUpdates")
    );
    const recipients = eligibleMembers.filter((m) => optedInUserIds.has(m.userId));
    if (recipients.length === 0) return;

    const eventTitle = (event.title as string)?.trim() || "a voting event";
    for (let i = 0; i < recipients.length; i += NOTIFICATIONS_BATCH_SIZE) {
      const slice = recipients.slice(i, i + NOTIFICATIONS_BATCH_SIZE);
      const batch = db.batch();
      for (const member of slice) {
        batch.set(db.collection("notifications").doc(), {
          userId: member.userId,
          organizationId,
          type: "RESULTS_PUBLISHED",
          title: "Results are in",
          message: `Results for "${eventTitle}" have been published.`,
          votingEventId: eventId,
          createdAt: FieldValue.serverTimestamp(),
          read: false,
        });
      }
      await batch.commit();
    }
  } catch (error) {
    logger.error(`notifyResultsPublished failed for event ${eventId}`, error);
  }
}

export const publishResults = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");

  // FR-10 / MFA-REQ-001: publishing results is a sensitive, irreversible operation.
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);
  await requireMfaVerified(request.auth);

  const eventId = typeof request.data?.eventId === "string" ? request.data.eventId.trim() : "";
  if (!eventId) throw new HttpsError("invalid-argument", "Valid eventId is required.");

  const db = getFirestore();
  const eventSnap = await db.collection("votingEvents").doc(eventId).get();
  if (!eventSnap.exists) throw new HttpsError("not-found", "Voting event not found.");
  const organizationId = eventSnap.data()?.organizationId as string;
  if (!organizationId) throw new HttpsError("failed-precondition", "Event has no organization.");

  const [, organization] = await Promise.all([
    requireActiveMembership(db, organizationId, uid, ["owner", "admin"]),
    db.collection("organizations").doc(organizationId).get(),
  ]);
  if (!organization.exists || !OPERATIONAL_ORG_STATUSES.includes(organization.data()?.status)) {
    throw new HttpsError("failed-precondition", "The organization is not currently authorized to manage voting events.");
  }
  try {
    // Idempotent: a repeat call (double click, retry after a timeout) must not
    // write a second audit entry or re-notify every eligible member.
    const existing = await db.collection("eventResults").doc(eventId).get();
    if (existing.exists && existing.data()?.published === true) {
      return { status: "success", eventId, published: true, alreadyPublished: true };
    }

    // The audit entry commits with the publication. A concurrent call can pass
    // the check above and still lose the transaction, so only the winner notifies.
    const { transitioned } = await publishEventResults(db, eventId, uid);
    if (!transitioned) {
      return { status: "success", eventId, published: true, alreadyPublished: true };
    }

    await notifyResultsPublished(db, organizationId, eventId, eventSnap.data()!);

    return { status: "success", eventId, published: true };
  } catch (error) {
    if (error instanceof HttpsError) throw error;
    if ((error as Error).message === "NOT_FOUND") throw new HttpsError("not-found", "Voting event not found.");
    if ((error as Error).message === "NOT_CLOSED") throw new HttpsError("failed-precondition", "Results can only be published after the event closes.");
    throw new HttpsError("internal", "Could not publish results.");
  }
});
