import { HttpsError } from "firebase-functions/v2/https";

/**
 * Validates that an anonymous ballot payload contains ZERO voter identity or timing metadata
 * and matches the EXACT approved Firestore ballot record schema in castVote:
 * { organizationId, votingEventId, privacyMode, choiceType, choiceId }
 */
export function validateAnonymousBallotPayload(data: Record<string, any>): void {
  if (!data || typeof data !== "object" || Array.isArray(data)) {
    throw new HttpsError("invalid-argument", "Ballot payload must be a valid object.");
  }

  // Strictly Prohibited Voter Identity, Linkage, and Timing Fields
  const prohibitedFields = [
    "castAt", "createdAt", "userId", "voterId",
    "email", "ipAddress", "participationId", "receiptId",
    "choiceKey", "voterName", "user", "votedAt", "timestamp",
  ];

  for (const field of prohibitedFields) {
    if (field in data) {
      throw new HttpsError(
        "invalid-argument",
        `Prohibited field '${field}' detected in anonymous ballot payload. Anonymous ballots must contain zero voter identity or timing metadata.`
      );
    }
  }

  // Strict Schema Whitelisting: { organizationId, votingEventId, privacyMode, choiceType, choiceId }
  const allowedKeys = ["organizationId", "votingEventId", "privacyMode", "choiceType", "choiceId"];

  for (const field of allowedKeys) {
    if (!(field in data) || typeof data[field] !== "string" || !data[field].trim()) {
      throw new HttpsError(
        "invalid-argument",
        `Missing or invalid required field '${field}' in anonymous ballot payload.`
      );
    }
  }

  if (data.privacyMode !== "ANONYMOUS") {
    throw new HttpsError(
      "invalid-argument",
      "Anonymous ballot privacyMode must be 'ANONYMOUS'."
    );
  }

  const keys = Object.keys(data);
  for (const key of keys) {
    if (!allowedKeys.includes(key)) {
      throw new HttpsError(
        "invalid-argument",
        `Unpermitted field '${key}' in anonymous ballot payload. Allowed fields: ${JSON.stringify(allowedKeys)}`
      );
    }
  }
}

/**
 * Validates that an identifiable ballot payload CONTAINS voter identity and matches
 * the EXACT approved discriminated schema for V1 candidate or poll ballots.
 */
export function validateIdentifiableBallotPayload(data: Record<string, any>, expectedUserId: string): void {
  if (!data || typeof data !== "object") {
    throw new HttpsError("invalid-argument", "Ballot payload must be a valid object.");
  }

  const keys = Object.keys(data);

  // Strict Schema Whitelisting
  const candidateBallotKeys = ["organizationId", "votingEventId", "candidateId", "castAt", "userId"];
  const pollBallotKeys = ["organizationId", "votingEventId", "pollOptionId", "castAt", "userId"];

  const isCandidateBallot = "candidateId" in data && !("pollOptionId" in data);
  const isPollBallot = "pollOptionId" in data && !("candidateId" in data);

  if (!isCandidateBallot && !isPollBallot) {
    throw new HttpsError(
      "invalid-argument",
      "Invalid ballot schema. Must contain either 'candidateId' or 'pollOptionId', never both or neither."
    );
  }

  if (data.userId !== expectedUserId) {
    throw new HttpsError(
      "permission-denied",
      "Voter identity mismatch in identifiable ballot payload."
    );
  }

  const allowedKeys = isCandidateBallot ? candidateBallotKeys : pollBallotKeys;

  for (const key of keys) {
    if (!allowedKeys.includes(key)) {
      throw new HttpsError(
        "invalid-argument",
        `Unpermitted field '${key}' in identifiable ballot payload. Allowed fields: ${JSON.stringify(allowedKeys)}`
      );
    }
  }
}

/**
 * Validates that a participation payload contains ONLY participation data and ZERO choice metadata.
 */
export function validateParticipationPayload(data: Record<string, any>): void {
  if (!data || typeof data !== "object") {
    throw new HttpsError("invalid-argument", "Participation payload must be a valid object.");
  }

  const keys = Object.keys(data);

  // Prohibited Choice Metadata
  const prohibitedFields = [
    "candidateId", "pollOptionId", "voteId", "receiptId",
    "choice", "voteChoice", "selection"
  ];

  for (const field of prohibitedFields) {
    if (field in data) {
      throw new HttpsError(
        "invalid-argument",
        `Prohibited field '${field}' detected in participation payload. Participation records must not contain choice metadata.`
      );
    }
  }

  // Strict Schema Whitelisting
  const allowedKeys = ["organizationId", "votingEventId", "userId", "votedAt"];

  for (const key of keys) {
    if (!allowedKeys.includes(key)) {
      throw new HttpsError(
        "invalid-argument",
        `Unpermitted field '${key}' in participation payload. Allowed fields: ${JSON.stringify(allowedKeys)}`
      );
    }
  }
}
