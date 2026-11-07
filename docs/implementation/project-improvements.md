# Project improvements — implementation progress

Date: 2026-10-29. These are local changes, not deployed production features.

## Implemented in this work

- One activation voter-roll policy for every voting type. Explicit event IDs flow through tally, monitoring and reminders. Missing activation snapshots fail closed. Deleted/inactive members remain in the historical denominator; inactive members are excluded from notifications and cannot vote.
- Sensitive callables check both current enrollment and a Firebase-signed second-factor session claim, in addition to recent authentication and revocation checks. Result publication offers reauthentication with one retry.
- CI job for Firestore and Storage rules using an isolated demo-project emulator configuration, Node 22, Java 21 and a pinned Firebase CLI.
- Organization reports: UTC creation-date range, stable timestamp+document-ID cursors, next/previous navigation, explicit page-scoped summaries, safe aggregate CSV sharing and translated report controls.
- Privacy: suppressed small-event results cannot be recovered by subtracting visible events from an aggregate; suppressed events are excluded from aggregate turnout entirely.
- Ballot rehearsal: real draft choices and instructions, local selection only, no vote/receipt writes. Yes/no review checks the actual option documents.
- Multi-contest builder, draft-only configuration, shared local rehearsal, complete-payload voting, election-level receipt, separate contest results and CSV export. No existing event is silently converted to the new mode.
- Accepted-ballot counts remain correct if personal participation history is deleted. Incomplete monitoring details are explicitly labelled and suppressed instead of drawing misleading breakdowns.
- Active-member nominations: consented self-applications, single/multi-contest rounds, owner/admin review, rejection reasons, withdrawal, approval revocation, publication gates, private query rules, and paged deletion cleanup.
- Release reliability: support session-loss fix and own-case history; opt-in App Check client integration; real Auth/Firestore backend integration with genuine emulator MFA; admin scheduled in-app reminders with a leased, deduplicating queue. See [release reliability](release-reliability.md).
- Report navigation translation, iPad CSV share anchor/filename, responsive report controls and RTL/large-text rehearsal checks.

## External setup and confirmed decisions

- Email provider: owner confirmed none is configured. Automated external email delivery is not implemented or represented as working. No emails were sent during development.
- Nomination policy was confirmed: only active organization members may apply. See [nomination contract](nominations.md) for the implemented scope and limits.
- Multi-contest policy was confirmed: all contests are submitted atomically with one receipt. The implemented mode has 2–10 required single-choice contests, a shared eligibility roll and separate contest outcomes. Existing single-contest elections remain unchanged.
- App Check: owner clarified that registration is not configured. Opt-in client integration is now implemented; platform registration, token metrics and staged enforcement remain pending.

## Remaining product work (not marked complete)

- External email/SMS/push provider integration and delivery/bounce tracking. A Communication Center and reliable scheduled IN_APP reminder queue are implemented; this does not imply external delivery.
- Full immutable configuration archive and dispute/recount case workflow. Optional independent launch/result approval is implemented below.
- Runoff policies, reviewed ranked-choice and multi-seat counting. Optional quorum and whole-election abstention are implemented below; this does not imply ranked or multi-seat allocation.
- Report PDF, enterprise SSO/provisioning, scoped integration API and signed webhooks.
- Operational incidents, verified backup/restore runbook and measured capacity/load tests.
- Complete Sindhi localization and further device/screen-reader testing.
- Formal cryptographic end-to-end verifiability requires a separate design and independent review. Participation receipt hashes must never be marketed as proof of a candidate's inclusion in the tally.

## Verification

Local verification on 2026-10-29: 891 Flutter tests, 140 Functions tests (25 suites), 109 Firestore/Storage rules tests, and 22 real Auth/Firestore emulator integration checks passed. Flutter analyzer reports no issues; TypeScript build and `git diff --check` pass. Widget tests cover member consent, manager approval, finalized controls and compact Arabic layout with 200% text. The integration runner covers real emulator tokens/MFA and database transactions; browser/deployed HTTP transport and production acceptance remain unverified. CI workflow additions require an actual CI run before branch-protection status can be claimed. Production configuration and deployment remain separate.

Multi-contest API and rollout details: [multi-contest election contract](multi-contest.md).

## Election governance, history and quorum update

- Admin election lists now use server-side status filters with timestamp/document-ID pagination. Tenant switching resets the cursor and search field; search is explicitly page-scoped. Aggregate/chooser streams are uncapped. Member cross-organization queries run per tenant to avoid Firestore disjunction limits and fetch every page; hydration is bounded to 20 lookups at a time. Member history still loads the full metadata history and needs an archival API for very large accounts.
- Optional owner-controlled independent approval requires another active manager to review the current launch/result fingerprint. Sensitive actions require recent MFA; requesters cannot self-review, only the requester can publish, and role revocation invalidates reviewer authorization. Ballot/eligibility/rule changes invalidate prior reviews. Concurrent recalculation cannot undo result publication. This is not a full historical configuration archive or a defense against a project operator/malicious owner disabling policy in a draft.
- Confirmed quorum policy: election-level submitted ballots against the activation-frozen voter roll, including whole-election abstentions. Active owner/admin users configure an optional integer threshold (1–100%) and abstention in **Election approvals → Ballot rules**, during DRAFT only. No new rule is silently enabled for existing events.
- Abstention is optional, final and mutually exclusive with every candidate/option/contest choice. A multi-contest abstention writes one anonymous record per contest in the same transaction, with one participation and receipt. Anonymous abstention records contain no user, timestamp, receipt link or choice ID. Identifiable mode retains its existing identity policy.
- Results include `totalVotes`, `validVotes`, `abstentionCount`, `quorumPercent`, `quorumMet`. Choice percentages exclude abstentions; turnout and quorum include them. Exact integer comparison avoids rounded-turnout threshold mistakes. Zero eligible voters cannot satisfy an enabled threshold. Quorum failure allows publishing transparent counts but suppresses every winner/tie banner, including contest banners. CSV reports these fields and the percentage basis.
- Runoffs, ranked choice, multi-seat allocation, partial/per-contest abstention, recount/dispute workflow and complete immutable configuration archives remain unimplemented.

Rollout: ship the compatible Flutter client and Functions together before enabling quorum or abstention. Older clients do not interpret the new quorum outcome fields. Existing published results remain unchanged; new policies are available only for drafts. Final analyzer and 13 focused governance/rehearsal/editor checks also passed after the preview update.
