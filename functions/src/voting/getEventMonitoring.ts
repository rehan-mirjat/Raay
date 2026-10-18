import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { requireActiveMembership } from "../utils/authorization";
import { getEligibleMembers } from "../results/tally";
import { buildDepartmentBreakdown, buildParticipationHistory } from "./monitoringAggregation";

const PARTICIPATION_HISTORY_POINTS = 24;

export const getEventMonitoring = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");
  const eventId = typeof request.data?.eventId === "string" ? request.data.eventId.trim() : "";
  if (!eventId) throw new HttpsError("invalid-argument", "Valid eventId is required.");

  const db = getFirestore();
  const eventSnap = await db.collection("votingEvents").doc(eventId).get();
  if (!eventSnap.exists) throw new HttpsError("not-found", "Voting event not found.");
  const event = eventSnap.data()!;
  const organizationId = event.organizationId as string;
  await requireActiveMembership(db, organizationId, uid, ["owner", "admin"]);
  const organization = await db.collection("organizations").doc(organizationId).get();
  if (!organization.exists || !["verified", "active"].includes(organization.data()?.status)) {
    throw new HttpsError("failed-precondition", "The organization is not currently authorized to manage voting events.");
  }
  if (event.status !== "ACTIVE" && event.status !== "SCHEDULED") {
    throw new HttpsError("failed-precondition", "Live monitoring is available for scheduled or active events.");
  }

  const [eligibleMembers, participationSnap, departmentsSnap] = await Promise.all([
    getEligibleMembers(db, organizationId, event),
    db.collection("participation")
      .where("organizationId", "==", organizationId)
      .where("votingEventId", "==", eventId)
      .get(),
    db.collection("departments").where("organizationId", "==", organizationId).get(),
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
  const participationCount = votedUserIds.size;
  const turnoutPercent = eligibleCount === 0 ? 0 : Math.round((participationCount / eligibleCount) * 10000) / 100;

  const departmentBreakdown = buildDepartmentBreakdown(eligibleMembers, votedUserIds, departmentNames);

  const openedAtMs = (event.startAt instanceof Timestamp ? event.startAt.toMillis() : null) ?? (votedAtMs[0] ?? Date.now());
  const participationHistory = buildParticipationHistory(votedAtMs, openedAtMs, Date.now(), PARTICIPATION_HISTORY_POINTS);

  return {
    eventId,
    status: event.status,
    eligibleCount,
    participationCount,
    turnoutPercent,
    departmentBreakdown,
    participationHistory,
    refreshedAt: new Date().toISOString(),
  };
});
