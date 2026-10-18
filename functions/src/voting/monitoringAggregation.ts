import { EligibleMember } from "../results/tally";

export interface DepartmentBreakdownRow {
  departmentId: string | null;
  name: string;
  eligible: number;
  participated: number;
  turnoutPercent: number;
}

// Below this many eligible members, a department's own turnout numbers could
// single out an individual's participation (e.g. "1 of 1 voted" names them
// outright). Small groups are folded into a single "Other" bucket instead of
// being hidden entirely, so turnout-by-department stays useful without
// weakening the anonymity guarantee the rest of the app makes.
export const MIN_GROUP_SIZE_FOR_BREAKDOWN = 5;

/**
 * Pure aggregation, no Firestore access - kept separate from
 * getEventMonitoring so the privacy-sensitive suppression rule is directly
 * unit-testable without an emulator.
 */
export function buildDepartmentBreakdown(
  eligibleMembers: EligibleMember[],
  votedUserIds: ReadonlySet<string>,
  departmentNames: ReadonlyMap<string, string>
): DepartmentBreakdownRow[] {
  const groups = new Map<string, { eligible: number; participated: number }>();
  for (const member of eligibleMembers) {
    const key = member.departmentId ?? "__none__";
    const g = groups.get(key) ?? { eligible: 0, participated: 0 };
    g.eligible += 1;
    if (votedUserIds.has(member.userId)) g.participated += 1;
    groups.set(key, g);
  }

  const rows: DepartmentBreakdownRow[] = [];
  let otherEligible = 0;
  let otherParticipated = 0;
  for (const [key, g] of groups.entries()) {
    if (g.eligible < MIN_GROUP_SIZE_FOR_BREAKDOWN) {
      otherEligible += g.eligible;
      otherParticipated += g.participated;
      continue;
    }
    rows.push({
      departmentId: key === "__none__" ? null : key,
      name: key === "__none__" ? "No department" : (departmentNames.get(key) || "Department"),
      eligible: g.eligible,
      participated: g.participated,
      turnoutPercent: Math.round((g.participated / g.eligible) * 10000) / 100,
    });
  }
  if (otherEligible > 0) {
    rows.push({
      departmentId: null,
      name: "Other",
      eligible: otherEligible,
      participated: otherParticipated,
      turnoutPercent: Math.round((otherParticipated / otherEligible) * 10000) / 100,
    });
  }
  rows.sort((a, b) => b.eligible - a.eligible);
  return rows;
}

export interface ParticipationHistoryPoint {
  atMs: number;
  cumulativeCount: number;
}

/**
 * Buckets sorted vote timestamps into a cumulative-count time series from
 * openedAtMs through nowMs. Pure function - no Firestore access.
 */
export function buildParticipationHistory(
  sortedVotedAtMs: number[],
  openedAtMs: number,
  nowMs: number,
  maxPoints: number
): ParticipationHistoryPoint[] {
  const spanMs = Math.max(nowMs - openedAtMs, 1);
  const bucketCount = Math.min(maxPoints, Math.max(sortedVotedAtMs.length, 1));
  const history: ParticipationHistoryPoint[] = [];
  let cursor = 0;
  for (let i = 0; i <= bucketCount; i++) {
    const bucketEndMs = openedAtMs + (spanMs * i) / bucketCount;
    while (cursor < sortedVotedAtMs.length && sortedVotedAtMs[cursor] <= bucketEndMs) {
      cursor++;
    }
    history.push({ atMs: Math.round(bucketEndMs), cumulativeCount: cursor });
  }
  return history;
}
