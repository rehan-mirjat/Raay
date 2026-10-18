import { CallableRequest, HttpsError } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import {
  DocumentData,
  DocumentSnapshot,
  Firestore,
  FieldValue,
  Timestamp,
  Transaction,
} from "firebase-admin/firestore";
import { sanitizePlainText } from "../utils/sanitize";

/* ------------------------------------------------------------------ */
/* Constants (single source of truth)                                  */
/* ------------------------------------------------------------------ */

export const EVENT_STATUS = {
  DRAFT: "DRAFT",
  SCHEDULED: "SCHEDULED",
  ACTIVE: "ACTIVE",
  CLOSED: "CLOSED",
  CANCELLED: "CANCELLED",
  ARCHIVED: "ARCHIVED",
} as const;

export const VOTING_TYPES = ["CANDIDATE_ELECTION", "SINGLE_CHOICE_POLL", "YES_NO_POLL"] as const;
export const ELIGIBILITY_TYPES = ["ALL_MEMBERS", "SELECTED_MEMBERS", "SELECTED_DEPARTMENTS"] as const;
export const PRIVACY_MODES = ["ANONYMOUS", "IDENTIFIABLE"] as const;

export type VotingType = (typeof VOTING_TYPES)[number];
export type EligibilityType = (typeof ELIGIBILITY_TYPES)[number];
export type PrivacyMode = (typeof PRIVACY_MODES)[number];

export const ADMIN_ROLES = ["owner", "admin"];
/** Operational statuses where events can be created, managed, or executed. */
export const OPERATIONAL_ORG_STATUSES = ["pending", "verified", "active"];
export const SYSTEM_ACTOR = "SYSTEM_SCHEDULED_EVALUATOR";

export const LIMITS = {
  MIN_WINDOW_MS: 5 * 60 * 1000,
  MAX_WINDOW_MS: 90 * 24 * 60 * 60 * 1000,
  PAST_START_GRACE_MS: 24 * 60 * 60 * 1000,
  MAX_START_AHEAD_MS: 365 * 24 * 60 * 60 * 1000,
  MAX_ELIGIBILITY_IDS: 1000,
  MAX_ELIGIBLE_VOTERS: 5000,
  MAX_CANDIDATES: 100,
  MAX_OPTIONS: 50,
  MAX_PHOTO_BYTES: 5 * 1024 * 1024,
  MAX_SORT_ORDER: 10000,
} as const;

/**
 * App Check enforcement is OFF: the Flutter client has no App Check SDK wired up
 * (no `firebase_app_check` dependency, no activation in main.dart). Turning this
 * on without that client-side setup rejects every real request - confirmed via
 * production data: votingEvents/candidates/votes were completely empty while this
 * was true, with no sign any of these callables had ever succeeded. Re-enable
 * only once the client is actually sending App Check tokens.
 */
export const CALLABLE_OPTIONS = {
  enforceAppCheck: false,
};

/* ------------------------------------------------------------------ */
/* Request / input validation                                          */
/* ------------------------------------------------------------------ */

const ID_REGEX = /^[A-Za-z0-9_-]{1,128}$/;

export function requireAuth(request: CallableRequest): string {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");
  return uid;
}

export function requireId(value: unknown, name: string): string {
  if (typeof value !== "string" || !ID_REGEX.test(value)) {
    throw new HttpsError("invalid-argument", `Valid ${name} is required.`);
  }
  return value;
}

export function rejectUnknownKeys(data: Record<string, unknown>, allowed: string[], fnName: string): void {
  for (const key of Object.keys(data)) {
    if (!allowed.includes(key)) {
      throw new HttpsError("invalid-argument", `Unpermitted parameter '${key}' in ${fnName} payload.`);
    }
  }
}

export function requiredString(
  value: unknown, label: string, min: number, max: number, options: { multiline?: boolean } = {}
): string {
  if (typeof value !== "string") throw new HttpsError("invalid-argument", `${label} is required.`);
  const t = sanitizePlainText(value, options);
  if (t.length < min || t.length > max) {
    throw new HttpsError("invalid-argument", `${label} must be between ${min} and ${max} characters.`);
  }
  return t;
}

export function optionalString(
  value: unknown, label: string, max: number, options: { multiline?: boolean } = {}
): string {
  if (value === undefined || value === null) return "";
  if (typeof value !== "string") throw new HttpsError("invalid-argument", `${label} must be a string.`);
  const t = sanitizePlainText(value, options);
  if (t.length > max) throw new HttpsError("invalid-argument", `${label} cannot exceed ${max} characters.`);
  return t;
}

export function oneOf<T extends string>(value: unknown, allowed: readonly T[], name: string): T {
  if (typeof value !== "string" || !(allowed as readonly string[]).includes(value)) {
    throw new HttpsError("invalid-argument", `Invalid ${name}.`);
  }
  return value as T;
}

export function parsePrivacyMode(value: unknown): PrivacyMode {
  if (typeof value !== "string") throw new HttpsError("invalid-argument", "Invalid privacyMode.");
  return oneOf(value.trim().toUpperCase(), PRIVACY_MODES, "privacyMode");
}

export function parseSortOrder(value: unknown): number {
  if (typeof value !== "number" || !Number.isInteger(value) || value < 0 || value > LIMITS.MAX_SORT_ORDER) {
    throw new HttpsError("invalid-argument", `sortOrder must be an integer between 0 and ${LIMITS.MAX_SORT_ORDER}.`);
  }
  return value;
}

/** Accepts an ISO-8601 string or epoch milliseconds only. */
export function parseMillis(value: unknown, name: string): number {
  if (typeof value === "number" && Number.isFinite(value) && value > 0) return value;
  if (typeof value === "string" && /^\d{4}-\d{2}-\d{2}T/.test(value)) {
    const ms = Date.parse(value);
    if (!Number.isNaN(ms)) return ms;
  }
  throw new HttpsError("invalid-argument", `${name} must be an ISO-8601 timestamp or epoch milliseconds.`);
}

export function assertStartAcceptable(startMillis: number, nowMillis: number): void {
  if (startMillis < nowMillis - LIMITS.PAST_START_GRACE_MS) {
    throw new HttpsError("invalid-argument", "startAt cannot be more than 24 hours in the past for a draft event.");
  }
  if (startMillis > nowMillis + LIMITS.MAX_START_AHEAD_MS) {
    throw new HttpsError("invalid-argument", "startAt cannot be more than 365 days in the future.");
  }
}

export function assertEndInFuture(endMillis: number, nowMillis: number): void {
  if (endMillis <= nowMillis) throw new HttpsError("invalid-argument", "endAt must be in the future.");
}

export function assertWindow(startMillis: number, endMillis: number): void {
  const d = endMillis - startMillis;
  if (d < LIMITS.MIN_WINDOW_MS) {
    throw new HttpsError("invalid-argument", "Voting window (endAt - startAt) must be at least 5 minutes.");
  }
  if (d > LIMITS.MAX_WINDOW_MS) {
    throw new HttpsError("invalid-argument", "Voting window (endAt - startAt) cannot exceed 90 days.");
  }
}

/** Validates, de-duplicates and bounds an array of document IDs. */
export function validateIdArray(value: unknown, name: string): string[] {
  if (!Array.isArray(value)) throw new HttpsError("invalid-argument", `${name} must be an array.`);
  if (value.length > LIMITS.MAX_ELIGIBILITY_IDS) {
    throw new HttpsError("invalid-argument", `${name} cannot contain more than ${LIMITS.MAX_ELIGIBILITY_IDS} entries.`);
  }
  const out = new Set<string>();
  for (const v of value) out.add(requireId(v, `${name} entry`));
  return Array.from(out);
}

export function assertEligibilityShape(type: EligibilityType, deptIds: string[], userIds: string[]): void {
  if (type === "ALL_MEMBERS" && (deptIds.length > 0 || userIds.length > 0)) {
    throw new HttpsError("invalid-argument", "eligibilityDepartmentIds and eligibilityUserIds must be empty when eligibilityType is ALL_MEMBERS.");
  }
  if (type === "SELECTED_DEPARTMENTS" && userIds.length > 0) {
    throw new HttpsError("invalid-argument", "eligibilityUserIds must be empty when eligibilityType is SELECTED_DEPARTMENTS.");
  }
  if (type === "SELECTED_MEMBERS" && deptIds.length > 0) {
    throw new HttpsError("invalid-argument", "eligibilityDepartmentIds must be empty when eligibilityType is SELECTED_MEMBERS.");
  }
}

/* ------------------------------------------------------------------ */
/* Errors & audit                                                      */
/* ------------------------------------------------------------------ */

/** Never leaks internal details to the client; logs them server-side instead. */
export function failWith(fnName: string, error: unknown, publicMessage: string): never {
  if (error instanceof HttpsError) throw error;
  logger.error(`${fnName} failed`, { error });
  throw new HttpsError("internal", publicMessage);
}

export interface AuditEntry {
  organizationId: string;
  actorUid: string;
  action: string;
  resourceType: string;
  resourceId: string;
  metadata?: Record<string, unknown>;
}

export function writeAudit(tx: Transaction, db: Firestore, entry: AuditEntry): void {
  tx.set(db.collection("auditLogs").doc(), {
    organizationId: entry.organizationId,
    actorUid: entry.actorUid,
    action: entry.action,
    resourceType: entry.resourceType,
    resourceId: entry.resourceId,
    metadata: entry.metadata || {},
    timestamp: FieldValue.serverTimestamp(),
  });
}

/* ------------------------------------------------------------------ */
/* Rate limiting (per user, per function; fixed window)               */
/* ------------------------------------------------------------------ */

export async function enforceRateLimit(
  db: Firestore,
  uid: string,
  key: string,
  max = 30,
  windowMs = 60_000
): Promise<void> {
  const ref = db.collection("rateLimits").doc(`${key}_${uid}`);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const now = Date.now();
    const d = snap.data();
    if (!d || now - (d.windowStart as number) >= windowMs) {
      // expireAt can be used by a Firestore TTL policy to clean up old documents.
      tx.set(ref, { windowStart: now, count: 1, expireAt: Timestamp.fromMillis(now + windowMs * 10) });
    } else if ((d.count as number) >= max) {
      throw new HttpsError("resource-exhausted", "Too many requests. Please try again shortly.");
    } else {
      tx.update(ref, { count: (d.count as number) + 1 });
    }
  });
}

/* ------------------------------------------------------------------ */
/* Authorization (all helpers perform READS only)                      */
/* ------------------------------------------------------------------ */

export async function requireAdminMember(
  tx: Transaction,
  db: Firestore,
  organizationId: string,
  uid: string,
  action: string
): Promise<void> {
  const snap = await tx.get(db.collection("organizationMembers").doc(`${organizationId}_${uid}`));
  const m = snap.data();
  if (!snap.exists || !m || m.status !== "active" || m.organizationId !== organizationId || m.userId !== uid) {
    throw new HttpsError("permission-denied", "You are not an active member of this organization.");
  }
  if (!ADMIN_ROLES.includes(m.role)) {
    throw new HttpsError("permission-denied", `Only Organization Owners or Admins can ${action}.`);
  }
}

export async function requireOperationalOrg(tx: Transaction, db: Firestore, organizationId: string): Promise<void> {
  const snap = await tx.get(db.collection("organizations").doc(organizationId));
  if (!snap.exists || !OPERATIONAL_ORG_STATUSES.includes(snap.data()?.status)) {
    throw new HttpsError("failed-precondition", "The organization must be verified to manage voting events.");
  }
}

/**
 * Loads a voting event, then checks authorization BEFORE any state check so that
 * non-members never learn about event status or organization state.
 */
export async function loadEventAsAdmin(
  tx: Transaction,
  db: Firestore,
  eventId: string,
  uid: string,
  action: string
) {
  const ref = db.collection("votingEvents").doc(eventId);
  const snap = await tx.get(ref);
  if (!snap.exists) throw new HttpsError("not-found", "Voting event not found.");
  const data = snap.data() as DocumentData;
  const organizationId = data.organizationId as string;
  await requireAdminMember(tx, db, organizationId, uid, action);
  await requireOperationalOrg(tx, db, organizationId);
  return { ref, data, organizationId };
}

/** Loads a parent event for a candidate/option operation and enforces tenant + DRAFT rules. */
export async function loadDraftEventForChild(
  tx: Transaction,
  db: Firestore,
  organizationId: string,
  eventId: string,
  what: string,
  requiredType?: VotingType
): Promise<DocumentData> {
  const snap = await tx.get(db.collection("votingEvents").doc(eventId));
  if (!snap.exists) throw new HttpsError("not-found", "Target voting event not found.");
  const ev = snap.data() as DocumentData;
  if (ev.organizationId !== organizationId) {
    throw new HttpsError("permission-denied", "Voting event belongs to a different organization.");
  }
  if (ev.status !== EVENT_STATUS.DRAFT) {
    throw new HttpsError("failed-precondition", `${what} can be changed ONLY in DRAFT events. Current status: '${ev.status}'`);
  }
  if (requiredType && ev.votingType !== requiredType) {
    throw new HttpsError("failed-precondition", `${what} apply ONLY to ${requiredType} events. Event type: '${ev.votingType}'`);
  }
  return ev;
}

/* ------------------------------------------------------------------ */
/* Eligibility (roster lives in votingEventEligibility, admin-only)    */
/* ------------------------------------------------------------------ */

export interface EligibilityConfig {
  departmentIds: string[];
  userIds: string[];
}

const asStringArray = (v: unknown): string[] => (Array.isArray(v) ? v.filter((x) => typeof x === "string") : []);

/** Reads draft roster config; falls back to legacy fields still stored on the event document. */
export function readEligibilityConfig(eligSnap: DocumentSnapshot, eventData: DocumentData): EligibilityConfig {
  const src = eligSnap.exists ? (eligSnap.data() as DocumentData) : eventData;
  return {
    departmentIds: asStringArray(src.eligibilityDepartmentIds),
    userIds: asStringArray(src.eligibilityUserIds),
  };
}

export async function assertDepartmentsInOrg(
  tx: Transaction,
  db: Firestore,
  organizationId: string,
  ids: string[],
  code: "invalid-argument" | "failed-precondition"
): Promise<void> {
  if (ids.length === 0) return;
  const snaps = await tx.getAll(...ids.map((id) => db.collection("departments").doc(id)));
  snaps.forEach((s, i) => {
    if (!s.exists || s.data()?.organizationId !== organizationId) {
      throw new HttpsError(code, `Department '${ids[i]}' does not exist in this organization.`);
    }
  });
}

export async function assertActiveMembers(
  tx: Transaction,
  db: Firestore,
  organizationId: string,
  uids: string[],
  code: "invalid-argument" | "failed-precondition"
): Promise<void> {
  if (uids.length === 0) return;
  const snaps = await tx.getAll(...uids.map((u) => db.collection("organizationMembers").doc(`${organizationId}_${u}`)));
  snaps.forEach((s, i) => {
    const d = s.data();
    if (!s.exists || !d || d.status !== "active" || d.organizationId !== organizationId) {
      throw new HttpsError(code, `User '${uids[i]}' is not an active member in this organization.`);
    }
  });
}

/**
 * Computes the exact set of eligible voter UIDs right now (READS only).
 * ASSUMPTION: organizationMembers documents carry `departmentIds: string[]`.
 */
export async function resolveEligibleUserIds(
  tx: Transaction,
  db: Firestore,
  organizationId: string,
  type: EligibilityType,
  cfg: EligibilityConfig
): Promise<string[]> {
  const max = LIMITS.MAX_ELIGIBLE_VOTERS;
  const tooMany = () =>
    new HttpsError("failed-precondition", `An event cannot have more than ${max} eligible voters in this version.`);
  const activeMembers = () =>
    db.collection("organizationMembers").where("organizationId", "==", organizationId).where("status", "==", "active");

  if (type === "ALL_MEMBERS") {
    const q = await tx.get(activeMembers().limit(max + 1));
    if (q.size > max) throw tooMany();
    return q.docs.map((d) => d.data().userId).filter((u): u is string => typeof u === "string");
  }

  if (type === "SELECTED_DEPARTMENTS") {
    const set = new Set<string>();
    for (const deptId of cfg.departmentIds) {
      // organizationMembers stores a single `departmentId` (string), not an array.
      const q = await tx.get(activeMembers().where("departmentId", "==", deptId).limit(max + 1));
      q.docs.forEach((d) => {
        const u = d.data().userId;
        if (typeof u === "string") set.add(u);
      });
      if (set.size > max) throw tooMany();
    }
    return Array.from(set);
  }

  // SELECTED_MEMBERS: keep only users who are still active members.
  if (cfg.userIds.length === 0) return [];
  const snaps = await tx.getAll(...cfg.userIds.map((u) => db.collection("organizationMembers").doc(`${organizationId}_${u}`)));
  const out: string[] = [];
  snaps.forEach((s, i) => {
    const d = s.data();
    if (s.exists && d && d.status === "active" && d.organizationId === organizationId) out.push(cfg.userIds[i]);
  });
  return out;
}

/** WRITES: freeze the voter roll and create the turnout counter at activation time. */
export function writeActivationDocs(
  tx: Transaction,
  db: Firestore,
  organizationId: string,
  eventId: string,
  eligibleUserIds: string[]
): void {
  tx.set(
    db.collection("votingEventEligibility").doc(eventId),
    {
      organizationId,
      votingEventId: eventId,
      eligibleUserIds,
      eligibleCount: eligibleUserIds.length,
      snapshotAt: FieldValue.serverTimestamp(),
    },
    { merge: true }
  );
  tx.set(db.collection("turnout").doc(eventId), {
    organizationId,
    votingEventId: eventId,
    eligibleCount: eligibleUserIds.length,
    participationCount: 0,
    updatedAt: FieldValue.serverTimestamp(),
  });
}
