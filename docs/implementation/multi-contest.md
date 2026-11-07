# Multi-contest election contract

## Scope

This is an optional mode of a candidate election, not a change to existing polls. The user confirmed one final submission for all contests. All contests share the election window, privacy mode and frozen eligibility roll. Each of 2–10 contests has 2–20 named choices and requires one selection. Ranked voting, weighted/proxy votes, per-contest eligibility and multi-seat allocation are separate future capabilities.

## Configuration and compatibility

- `createVotingEvent` accepts `ballotMode: MULTI_CONTEST` only with `votingType: CANDIDATE_ELECTION`. Omitted mode is `SINGLE`, preserving existing clients and stored elections.
- `updateVotingEvent` accepts `contests` only on a multi-contest draft. Each contest has `id`, `title` and `choices`; each choice has `id`, `label`, optional `description`. IDs are unique within their scope and all text is bounded/sanitized.
- The mode is fixed at creation. All contest configuration becomes immutable once the election leaves DRAFT.
- Publishing validates complete contest configuration; no separate candidate documents are used for this mode. Standalone candidate/option mutation endpoints reject multi-contest events.
- Updated Flutter clients and Functions should be released together. Older Flutter clients do not implement the new ballot layout; do not create new-mode elections until the client rollout is ready. Do not convert live/past elections.

## Submission and secrecy

`castVote` accepts `contestSelections: {contestId: choiceId}` for multi-contest elections. Missing/extra contests, unknown choices and mixed single-choice payloads are rejected before writes. The existing membership, frozen-roll, verified-email, revocation, time-window and duplicate-participation checks still apply.

One Firestore transaction writes every contest selection plus one election participation record and one election receipt. A repeated request cannot create a second set. In anonymous mode, contest selections are separate ballot documents with no voter identity, timestamp, receipt ID or common ballot identifier. Identifiable mode intentionally includes the authenticated user. This is application-level separation, not a claim of cryptographic end-to-end anonymity or protection from the Firebase project owner.

Rehearsal uses the same contest layout with local-only selections. It cannot invoke the voting repository or produce a receipt.

## Counting and publication

Each contest is tallied independently. The election's total is accepted ballots, not the sum of all contest selections. Different stored contest counts or unknown stored choices fail closed instead of silently publishing incomplete outcomes. Results show per-contest winners/ties and export a contest column in CSV. Publishing retains the existing authorization, MFA, audit and notification flow.

Account deletion can remove personal participation history without removing accepted votes. Final totals and live aggregate turnout therefore count accepted ballots. If aggregate totals and personal history differ, detailed monitoring is labelled incomplete and omitted; it is not drawn as a complete history. The frozen denominator remains stable when membership documents are removed.

## Verification boundaries

Unit/callable tests cover configuration bounds, immutable lifecycle, complete/duplicate submissions, privacy fields, independent tallies and deletion-safe totals. Flutter tests cover draft editing, validation, unsaved work, complete review/submission and CSV parsing. Emulator rules tests cover configuration visibility, unpublished results, cross-tenant denial and server-only ballots. These do not establish production load capacity or replace staging verification with real MFA sessions.
