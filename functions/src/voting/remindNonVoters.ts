import { onCall, HttpsError } from "firebase-functions/v2/https";
import { OPERATIONAL_ORG_STATUSES } from "../voting_events/votingCommon";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { requireActiveMembership, requireNotRevoked } from "../utils/authorization";
import { requireAuth, requireId, ADMIN_ROLES, CALLABLE_OPTIONS, enforceRateLimit } from "../voting_events/votingCommon";
import { getEligibleMembers } from "../results/tally";
import { filterOptedIn } from "../utils/notificationPreferences";

const NOTIFICATIONS_BATCH_SIZE = 400; // headroom under Firestore's 500-write batch limit

/**
 * Sends an in-app reminder notification to every eligible member of an
 * ACTIVE event who has not yet voted. The non-voter list is computed and
 * used here, server-side, and never returned to the caller - only a count -
 * so the admin who triggers this still can't see who has or hasn't voted,
 * matching the same privacy guarantee the rest of the monitoring UI makes.
 */
export const remindNonVoters = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  await requireNotRevoked(request);

  const eventId = requireId(request.data?.eventId, "eventId");

  const db = getFirestore();
  const eventSnap = await db.collection("votingEvents").doc(eventId).get();
  if (!eventSnap.exists) throw new HttpsError("not-found", "Voting event not found.");
  const event = eventSnap.data()!;
  const organizationId = event.organizationId as string;

  await requireActiveMembership(db, organizationId, uid, ADMIN_ROLES);

  const organization = await db.collection("organizations").doc(organizationId).get();
  if (!organization.exists || !OPERATIONAL_ORG_STATUSES.includes(organization.data()?.status)) {
    throw new HttpsError("failed-precondition", "The organization is not currently authorized to manage voting events.");
  }
  if (event.status !== "ACTIVE") {
    throw new HttpsError("failed-precondition", "Reminders can only be sent while the event is active.");
  }

  await enforceRateLimit(db, eventId, "remindNonVoters", 3, 60 * 60 * 1000);

  const [eligibleMembers, participationSnap] = await Promise.all([
    getEligibleMembers(db, organizationId, event),
    db.collection("participation")
      .where("organizationId", "==", organizationId)
      .where("votingEventId", "==", eventId)
      .get(),
  ]);

  const votedUserIds = new Set<string>();
  participationSnap.docs.forEach((d) => {
    const data = d.data();
    if (typeof data.userId === "string") votedUserIds.add(data.userId);
  });

  const nonVoters = eligibleMembers.filter((m) => !votedUserIds.has(m.userId));
  if (nonVoters.length === 0) {
    return { status: "success", remindedCount: 0 };
  }

  const optedInUserIds = new Set(
    await filterOptedIn(db, nonVoters.map((m) => m.userId), "voteReminders")
  );
  const recipients = nonVoters.filter((m) => optedInUserIds.has(m.userId));

  const eventTitle = (event.title as string)?.trim() || "a voting event";
  let remindedCount = 0;
  for (let i = 0; i < recipients.length; i += NOTIFICATIONS_BATCH_SIZE) {
    const slice = recipients.slice(i, i + NOTIFICATIONS_BATCH_SIZE);
    const batch = db.batch();
    for (const member of slice) {
      batch.set(db.collection("notifications").doc(), {
        userId: member.userId,
        organizationId,
        type: "VOTE_REMINDER",
        title: "Don't forget to vote",
        message: `"${eventTitle}" is still open. Cast your ballot before it closes.`,
        votingEventId: eventId,
        createdAt: FieldValue.serverTimestamp(),
        read: false,
      });
    }
    await batch.commit();
    remindedCount += slice.length;
  }

  await db.collection("auditLogs").add({
    organizationId,
    actorUid: uid,
    action: "REMIND_NON_VOTERS",
    resourceType: "votingEvent",
    resourceId: eventId,
    // Deliberately a count only - never which members were reminded. The
    // whole point of this feature is that non-voter identity stays private,
    // including from the admin who triggered it.
    metadata: { remindedCount },
    timestamp: FieldValue.serverTimestamp(),
  });

  return { status: "success", remindedCount };
});
