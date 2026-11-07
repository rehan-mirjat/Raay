import { HttpsError } from "firebase-functions/v2/https";

export function parseBallotRules(data: Record<string, unknown>) {
  const quorumPercent = data.quorumPercent ?? null;
  if (quorumPercent !== null && (typeof quorumPercent !== "number" || !Number.isInteger(quorumPercent) || quorumPercent < 1 || quorumPercent > 100)) {
    throw new HttpsError("invalid-argument", "Quorum must be a whole percentage from 1 to 100, or disabled.");
  }
  if (typeof data.allowAbstain !== "boolean") throw new HttpsError("invalid-argument", "Choose whether abstention is allowed.");
  return { quorumPercent: quorumPercent as number | null, allowAbstain: data.allowAbstain };
}

/** Abstention is a whole-election submission, never a partial contest ballot. */
export function isAbstention(data: Record<string, unknown>, allowed: boolean): boolean {
  if (data.abstain !== undefined && typeof data.abstain !== "boolean") throw new HttpsError("invalid-argument", "Invalid abstention value.");
  if (data.abstain !== true) return false;
  if (!allowed) throw new HttpsError("failed-precondition", "Abstention is not enabled for this election.");
  if (data.candidateId !== undefined || data.pollOptionId !== undefined || data.contestSelections !== undefined) throw new HttpsError("invalid-argument", "An abstention cannot include a choice.");
  return true;
}

export function quorumReached(submitted: number, eligible: number, percent: number | null): boolean | null {
  return percent === null ? null : eligible > 0 && submitted * 100 >= eligible * percent;
}
