# SecureVote M6 — Readiness Audit & Implementation Specification

## M6.1 — Repository and Requirements Audit

### Discrepancies and Findings

1. **Schema Mismatch (Contract Discrepancy):**
   - The Flutter client `EventResult` model and `ResultsDashboardScreen` are expecting an older payload structure: `totalBallotsCast`, `candidateTallies` (list of CandidateTally), and `optionTallies` (list of OptionTally).
   - The new server-authoritative Cloud Function `calculateEventResults` (`functions/src/results/tally.ts`) strictly generates an `EventResultsPayload` containing:
     - `totalVotes` (number)
     - `eligibleCount` (number)
     - `participationCount` (number)
     - `turnoutPercent` (number)
     - A unified `tallies` array (`TallyRow[]` where `choiceType` is `'CANDIDATE'` or `'POLL_OPTION'`).
   - **Impact:** The Flutter UI crashes or shows empty data because it fails to parse the new server schema. We must reconcile the domain contract by adapting the Flutter `EventResult` model to parse the new unified backend schema.

2. **Client Read Paths & Permission Denied:**
   - `firestore.rules` correctly restricts the `eventResults/{eventId}` collection. Normal members can *only* read if `resource.data.published == true`.
   - The current Flutter Riverpod Stream (`eventResultStreamProvider`) tries to read this document. If unpublished, Firebase throws a `permission-denied` exception.
   - **Impact:** The UI does not gracefully catch this to display an "Unavailable" state. It crashes or shows raw errors.

3. **Data Consistency & Edge Cases:**
   - **Zero-vote Handling:** Handled securely by the backend. `calculateEventResults` maps all options upfront.
   - **Vote/Participation Independence:** `castVote.ts` correctly isolates vote records from participation records.
   - **Result Authorization:** Handled correctly. `calculateEventResults` blocks processing unless the event is `CLOSED` or `ARCHIVED`.

## Proposed Implementation Plan

**Step 1: Reconcile the Domain Contract (Flutter Client)**
- Update `lib/features/results/domain/event_result.dart` to match `EventResultsPayload` from `functions/src/results/tally.ts`.
- Introduce parsing for `turnoutPercent`, `eligibleCount`, and `participationCount`.
- Parse the backend's unified `tallies` array into separate lists or handle them correctly in the UI.

**Step 2: Graceful Client Authorization Handling**
- Update `lib/features/results/data/results_repository.dart` to handle Firebase `permission-denied` errors gracefully. If an error is caught and is related to permissions, emit a state indicating results are unavailable/unpublished.

**Step 3: Flutter UI (Dashboard) Overhaul**
- Update `lib/features/results/presentation/results_dashboard_screen.dart` to display the new turnout statistics.
- Implement explicit UI states: Loading, Unavailable/Unpublished, Empty, Success, and Error.
- Ensure the UI handles zero-vote options cleanly.

**Step 4: Security and Regression Testing Suite**
- Write tests in `firestore-tests/` to verify `eventResults` security rules (members can only read published results).
- Add backend Jest tests for `tally.ts` (calculateResults).
- Ensure existing voting transaction tests continue to pass.

**Status: READY FOR EXECUTION**