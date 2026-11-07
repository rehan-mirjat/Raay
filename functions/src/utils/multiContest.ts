import { HttpsError } from "firebase-functions/v2/https";
import { sanitizePlainText } from "./sanitize";

export interface ContestOption { id: string; label: string; description: string }
export interface ElectionContest { id: string; title: string; choices: ContestOption[] }
export interface ContestSelection { contestId: string; choiceId: string }
const idPattern = /^[A-Za-z0-9_-]{1,128}$/;
const fail = (message: string): never => { throw new HttpsError("invalid-argument", message); };
function text(value: unknown, name: string, max: number, optional = false): string {
  if (optional && value === undefined) return "";
  if (typeof value !== "string" || value.length > max) return fail(`Invalid ${name}.`);
  const clean = sanitizePlainText(value, { multiline: optional });
  if (!optional && !clean) return fail(`${name} is required.`);
  return clean;
}
function id(value: unknown): string {
  if (typeof value !== "string" || !idPattern.test(value)) return fail("Invalid contest/choice ID.");
  return value;
}
function object(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== "object" || Array.isArray(value)) return fail("Expected a contest object.");
  return value as Record<string, unknown>;
}
function keys(value: Record<string, unknown>, allowed: string[]) {
  if (Object.keys(value).some((key) => !allowed.includes(key))) fail("Unexpected contest field.");
}

export function parseContests(value: unknown): ElectionContest[] {
  if (!Array.isArray(value) || value.length < 2 || value.length > 10) return fail("An election requires 2–10 contests.");
  const seen = new Set<string>();
  return value.map((raw) => {
    const c = object(raw); keys(c, ["id", "title", "choices"]);
    const contestId = id(c.id);
    if (seen.has(contestId)) return fail("Contest IDs must be unique.");
    seen.add(contestId);
    if (!Array.isArray(c.choices) || c.choices.length < 2 || c.choices.length > 20) return fail("Each contest requires 2–20 choices.");
    const choiceIds = new Set<string>();
    const choices = c.choices.map((rawChoice) => {
      const choice = object(rawChoice); keys(choice, ["id", "label", "description"]);
      const choiceId = id(choice.id);
      if (choiceIds.has(choiceId)) return fail("Choice IDs must be unique within a contest.");
      choiceIds.add(choiceId);
      return { id: choiceId, label: text(choice.label, "choice label", 100), description: text(choice.description, "choice description", 500, true) };
    });
    return { id: contestId, title: text(c.title, "contest title", 100), choices };
  });
}

export function validateContestSelections(contests: ElectionContest[], value: unknown): ContestSelection[] {
  const selections = object(value);
  if (Object.keys(selections).length !== contests.length || Object.keys(selections).some((key) => !contests.some((c) => c.id === key))) {
    return fail("Select exactly one choice in every contest.");
  }
  return contests.map((contest) => {
    const choiceId = selections[contest.id];
    if (typeof choiceId !== "string" || !contest.choices.some((c) => c.id === choiceId)) return fail("A contest selection is invalid.");
    return { contestId: contest.id, choiceId };
  });
}

/** Separate anonymous documents have no voter, receipt, timestamp or shared ballot ID. */
export function contestVoteRecords(organizationId: string, eventId: string, selections: ContestSelection[], uid?: string, createdAt?: unknown) {
  return selections.map((selection) => ({
    organizationId, votingEventId: eventId, choiceType: "CONTEST_OPTION", ...selection,
    privacyMode: uid ? "IDENTIFIABLE" : "ANONYMOUS",
    ...(uid ? { userId: uid, createdAt } : {}),
  }));
}

export function tallyContests(contests: ElectionContest[], records: Record<string, unknown>[], ballotCount = records.filter((record) => record.contestId === contests[0]?.id).length) {
  const valid = new Map(contests.map((c) => [c.id, new Set(c.choices.map((choice) => choice.id))]));
  for (const record of records) {
    if (typeof record.contestId !== "string" || (!valid.has(record.contestId) || (record.choiceType === "ABSTAIN" ? record.choiceId !== undefined : typeof record.choiceId !== "string" || !valid.get(record.contestId)?.has(record.choiceId)))) {
      throw new HttpsError("failed-precondition", "A stored contest ballot is invalid; investigate before publishing.");
    }
  }
  const abstentionCount = records.filter(r => r.contestId === contests[0].id && r.choiceType === "ABSTAIN").length;
  return contests.map((contest) => {
    const votes = records.filter((record) => record.contestId === contest.id);
    if (votes.length !== ballotCount) throw new HttpsError("failed-precondition", "Contest ballot counts do not match participation; investigate before publishing.");
    if (votes.filter(r => r.choiceType === "ABSTAIN").length !== abstentionCount) throw new HttpsError("failed-precondition", "Contest abstention counts do not match.");
    const validVotes = ballotCount - abstentionCount;
    return {
      contestId: contest.id, title: contest.title, totalVotes: ballotCount, validVotes, abstentionCount,
      tallies: contest.choices.map((choice) => {
        const count = votes.filter((vote) => vote.choiceId === choice.id).length;
        return { choiceId: choice.id, choiceType: "CONTEST_OPTION", name: choice.label, votes: count, percent: validVotes === 0 ? 0 : Math.round(count / validVotes * 10000) / 100 };
      }).sort((a, b) => b.votes - a.votes || a.name.localeCompare(b.name)),
    };
  });
}


export function acceptedBallotCount(recordCount: number, contestCount = 1): number {
  if (!Number.isInteger(recordCount) || recordCount < 0 || !Number.isInteger(contestCount) || contestCount < 1 || recordCount % contestCount !== 0) {
    throw new HttpsError("failed-precondition", "Stored ballot counts are inconsistent; contact the organizer.");
  }
  return recordCount / contestCount;
}
