import { acceptedBallotCount, parseContests } from "../utils/multiContest";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { requireActiveMembership, requireNotRevoked } from "../utils/authorization";
import { getEligibleMembers } from "../results/tally";
import { OPERATIONAL_ORG_STATUSES } from "../voting_events/votingCommon";
import { buildDepartmentBreakdown, buildParticipationHistory } from "./monitoringAggregation";

const PARTICIPATION_HISTORY_POINTS = 24;

export const getEventMonitoring = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");

  await requireNotRevoked(request);

  const eventId = typeof request.data?.eventId === "string" ? request.data.eventId.trim() : "";
  if (!eventId) throw new HttpsError("invalid-argument", "Valid eventId is required.");

  const db = getFirestore();
  const eventSnap = await db.collection("votingEvents").doc(eventId).get();
  if (!eventSnap.exists) throw new HttpsError("not-found", "Voting event not found.");
  const event = eventSnap.data()!;
  const organizationId = event.organizationId as string;

  // Package D2: owners/admins see full detail; an Observer (a narrow
  // read-only capability flag on an existing membership, not a new role -
  // see setObserverStatus.ts) gets aggregate-only numbers. isObserver is
  // checked here rather than added to requireActiveMembership's allowedRoles
  // because the two callers need DIFFERENT response shapes, not just a
  // yes/no gate.
  const { role: callerRole } = await requireActiveMembership(db, organizationId, uid);
  const memberSnap = await db.collection("organizationMembers").doc(`${organizationId}_${uid}`).get();
  const isAdminCaller = callerRole === "owner" || callerRole === "admin";
  const isObserverCaller = memberSnap.data()?.isObserver === true;
  if (!isAdminCaller && !isObserverCaller) {
    throw new HttpsError("permission-denied", "Insufficient organization role.");
  }

  const organization = await db.collection("organizations").doc(organizationId).get();
  if (!organization.exists || !OPERATIONAL_ORG_STATUSES.includes(organization.data()?.status)) {
    throw new HttpsError("failed-precondition", "The organization is not currently authorized to manage voting events.");
  }
  if (event.status !== "ACTIVE" && event.status !== "SCHEDULED") {
    throw new HttpsError("failed-precondition", "Live monitoring is available for scheduled or active events.");
  }

  const [eligibleMembers, participationSnap, departmentsSnap, acceptedVotes] = await Promise.all([
    getEligibleMembers(db, organizationId, eventId, event),
    db.collection("participation")
      .where("organizationId", "==", organizationId)
      .where("votingEventId", "==", eventId)
      .get(),
    db.collection("departments").where("organizationId", "==", organizationId).get(),
    db.collection("votes").where("organizationId", "==", organizationId).where("votingEventId", "==", eventId).count().get(),
  ]);

  const departmentNames = new Map<string, string>();
  departmentsSnap.docs.forEach((d) => departmentNames.set(d.id, (d.data()?.name as string) || "Department"));

  const votedUserIds = new Set<string>();
  const votedAtMs: number[] = [];
  participationSnap.docs.forEach((d) => {
    const data = d.data();
    if (typeof data.userId === "string") votedUserIds.add(data.userId);
    if (data.votedAt instanceof Timestamp) votedAtMs.push(data.votedAt.toMillis());
  });
  votedAtMs.sort((a, b) => a - b);

  const eligibleCount = eligibleMembers.length;
  const participationCount = acceptedBallotCount(acceptedVotes.data().count, event.ballotMode === "MULTI_CONTEST" ? parseContests(event.contests).length : 1);
  const detailsComplete = participationCount === votedUserIds.size;
  const turnoutPercent = eligibleCount === 0 ? 0 : Math.round((participationCount / eligibleCount) * 10000) / 100;

  // Per-department counts and vote-timing history can re-identify who voted
  // in a small department or pinpoint a single voter's timestamp - an
  // accepted tradeoff for the org's own owners/admins, but exactly what
  // Package D's spec says an Observer must never see ("do not expose...
  // small-group turnout breakdowns that could reveal sensitive participation
  // patterns"). Only computed for admin callers.
  const departmentBreakdown = isAdminCaller && detailsComplete
    ? buildDepartmentBreakdown(eligibleMembers, votedUserIds, departmentNames)
    : [];
  const openedAtMs = (event.startAt instanceof Timestamp ? event.startAt.toMillis() : null) ?? (votedAtMs[0] ?? Date.now());
  const participationHistory = isAdminCaller && detailsComplete
    ? buildParticipationHistory(votedAtMs, openedAtMs, Date.now(), PARTICIPATION_HISTORY_POINTS)
    : [];

  return {
    eventId,
    status: event.status,
    eligibleCount,
    participationCount,
    turnoutPercent,
    detailsUnavailable: isAdminCaller && !detailsComplete,
    departmentBreakdown,
    participationHistory,
    refreshedAt: new Date().toISOString(),
  };
});
