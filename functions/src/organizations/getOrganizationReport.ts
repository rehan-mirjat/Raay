import { FieldPath, getFirestore, Timestamp } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { requireActiveMembership, requireNotRevoked } from "../utils/authorization";

const MAX_EVENTS = 100;
const PRIVACY_MINIMUM = 10;

export interface ReportCursor { seconds: number; nanoseconds: number; id: string }

export function parseReportQuery(data: Record<string, unknown>) {
  const date = (value: unknown, name: string): Timestamp | undefined => {
    if (value === undefined || value === null) return undefined;
    if (typeof value !== "string" || value.startsWith("0000-") || !/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z$/.test(value) ||
        !Number.isFinite(Date.parse(value)) || new Date(value).toISOString() !== value) {
      throw new HttpsError("invalid-argument", `${name} must be an ISO UTC timestamp.`);
    }
    return Timestamp.fromDate(new Date(value));
  };
  const from = date(data.fromDate, "fromDate");
  const to = date(data.toDate, "toDate");
  if (from && to && from.toMillis() >= to.toMillis()) {
    throw new HttpsError("invalid-argument", "The date range must end after it starts.");
  }
  let cursor: ReportCursor | undefined;
  if (data.cursor !== undefined && data.cursor !== null) {
    const c = data.cursor as Partial<ReportCursor>;
    if (!c || !Number.isInteger(c.seconds) || c.seconds! < 0 || c.seconds! >= 253402300800 ||
        !Number.isInteger(c.nanoseconds) || c.nanoseconds! < 0 || c.nanoseconds! > 999999999 ||
        typeof c.id !== "string" || !/^[A-Za-z0-9_-]{1,128}$/.test(c.id)) {
      throw new HttpsError("invalid-argument", "Invalid report cursor.");
    }
    cursor = c as ReportCursor;
  }
  return { from, to, cursor };
}

/** Organization-only, aggregate report. Ballot choices and voter identities are never returned. */
export const getOrganizationReport = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");
  await requireNotRevoked(request);

  const organizationId = typeof request.data?.organizationId === "string"
    ? request.data.organizationId.trim()
    : "";
  if (!organizationId) throw new HttpsError("invalid-argument", "Valid organizationId is required.");

  const filters = parseReportQuery(request.data ?? {});
  const db = getFirestore();
  await requireActiveMembership(db, organizationId, uid, ["owner", "admin"]);
  let query = db.collection("votingEvents").where("organizationId", "==", organizationId);
  if (filters.from) query = query.where("createdAt", ">=", filters.from);
  if (filters.to) query = query.where("createdAt", "<", filters.to);
  query = query.orderBy("createdAt", "desc").orderBy(FieldPath.documentId(), "desc");
  if (filters.cursor) {
    query = query.startAfter(new Timestamp(filters.cursor.seconds, filters.cursor.nanoseconds), filters.cursor.id);
  }
  const [members, eventsSnapshot] = await Promise.all([
    db.collection("organizationMembers")
      .where("organizationId", "==", organizationId)
      .where("status", "==", "active")
      .count().get(),
    query.limit(MAX_EVENTS + 1).get(),
  ]);

  const hasMore = eventsSnapshot.docs.length > MAX_EVENTS;
  const eventDocs = eventsSnapshot.docs.slice(0, MAX_EVENTS);
  const last = eventDocs[eventDocs.length - 1];
  const lastTime = last?.data().createdAt as Timestamp | undefined;
  const nextCursor = hasMore && lastTime ? {
    seconds: lastTime.seconds, nanoseconds: lastTime.nanoseconds, id: last.id,
  } : null;
  const resultDocs = eventDocs.length
    ? await db.getAll(...eventDocs.map((event) => db.collection("eventResults").doc(event.id)))
    : [];
  const resultsById = new Map(resultDocs.map((doc) => [doc.id, doc.exists ? doc.data() : undefined]));
  const events = eventDocs.map((doc) => {
    const event = doc.data();
    const result = resultsById.get(doc.id);
    const eligible = Number(result?.eligibleCount) || 0;
    const votes = Number(result?.totalVotes ?? result?.participationCount) || 0;
    const published = result?.published === true;
    const turnoutPercent = eligible >= PRIVACY_MINIMUM && published
      ? Math.round((votes / eligible) * 10000) / 100
      : null;
    return {
      id: doc.id,
      title: typeof event.title === "string" ? event.title : "Untitled election",
      status: typeof event.status === "string" ? event.status : "UNKNOWN",
      createdAt: event.createdAt?.toDate?.()?.toISOString?.() ?? null,
      published,
      turnoutPercent,
      turnoutSuppressed: published && eligible > 0 && eligible < PRIVACY_MINIMUM,
    };
  }).sort((a, b) => (b.createdAt ?? "").localeCompare(a.createdAt ?? ""));

  const publishedResults = eventDocs
    .map((event) => resultsById.get(event.id))
    .filter((result) => result?.published === true);
  // Never recover a suppressed small election through aggregate subtraction.
  const reportableResults = publishedResults.filter((result) => (Number(result?.eligibleCount) || 0) >= PRIVACY_MINIMUM);
  const eligibleSlots = reportableResults.reduce((sum, result) => sum + (Number(result?.eligibleCount) || 0), 0);
  const totalVotes = reportableResults.reduce((sum, result) => sum + (Number(result?.totalVotes ?? result?.participationCount) || 0), 0);

  return {
    status: "success",
    generatedAt: new Date().toISOString(),
    activeMembers: members.data().count,
    eventCount: eventDocs.length,
    truncated: hasMore,
    hasMore,
    nextCursor,
    summaryScope: "page",
    aggregateEventCount: reportableResults.length,
    publishedEventCount: publishedResults.length,
    aggregateTurnoutPercent: eligibleSlots >= PRIVACY_MINIMUM
      ? Math.round((totalVotes / eligibleSlots) * 10000) / 100
      : null,
    aggregateTurnoutSuppressed: publishedResults.length > 0 && reportableResults.length === 0,
    events,
  };
});
