# Release reliability and scheduled communications

Local implementation, 29 October 2026. No deployment, production setting changes or external messages were performed.

## Support cases

Support submission now uses an injectable repository. A missing user session is an error before any database access. Success follows the acknowledged Firestore write; failure preserves the form. Pending submissions block duplicate taps and field edits. Field limits match the existing rules. An election receipt reference is submitted only for the election-issue category and is cleared after success.

`/help/reports` displays only the signed-in user's actual report records, including the platform's existing open/in-progress/resolved status and case reference. It supports incremental loading. No fictional reply system is shown; threaded replies remain future work. Firestore continues to deny reporter updates/deletion and cross-user reading.

## App Check rollout

The owner clarified that App Check is **not configured**. The client dependency and opt-in startup integration are implemented, but default activation and backend enforcement remain off.

For a staging build after Firebase Console registration:

```sh
flutter run -d chrome --dart-define=APP_CHECK_ENABLED=true --dart-define=APP_CHECK_WEB_SITE_KEY=YOUR_PUBLIC_RECAPTCHA_ENTERPRISE_SITE_KEY
```

The web implementation uses reCAPTCHA Enterprise. The site key must match that provider and authorized web domains. It is a public site key, not a secret. Android uses Play Integrity; Apple uses App Attest with DeviceCheck fallback. Platform registration/entitlements still require real-device validation. Explicit native development debug providers use `APP_CHECK_DEBUG=true`; release builds reject that flag. Local emulator mode skips live attestation. Enabled startup failures are surfaced rather than silently disabling App Check.

Register each platform, validate staging token metrics and existing client versions, then plan enforcement by service/callable. A package being installed is not evidence that all real clients send valid tokens. The repository has not enabled production enforcement.

## Real backend integration

`functions/integration/election-journey.test.cjs` uses real local Auth and Firestore emulators, the real Admin SDK, real rules, and compiled exported handlers. It does not load Jest mocks. User sessions come from the Auth emulator. SMS-MFA enrollment completes through the emulator's REST API and its own local verification code; protected actions use the resulting second-factor session.

Coverage includes organization creation, an actual invitation and acceptance, draft privacy, MFA launch denial/success, frozen eligibility, outsider/cross-tenant denial, concurrent duplicate votes, receipt verification, private ballots, close/calculate/publish and member result visibility. Multi-contest coverage verifies partial-submission rollback, one complete receipt, separate anonymous choice records and separate contest tallies with one ballot total.

The runner refuses non-`demo-` projects and non-loopback emulator hosts. It does not launch a Flutter browser or cover deployed HTTP transport. No complete browser/device E2E claim is made.

```sh
npm --prefix functions run build
firebase emulators:exec --config firebase.integration-ci.json --project demo-raay-journey --only auth,firestore "node --test functions/integration/election-journey.test.cjs"
```

The CI workflow includes this journey as a separate Node 22 / Java 21 job with pinned Firebase CLI tooling. A remote CI result has not been inspected.

## Scheduled in-app reminders

Owners/admins use `/communications` to schedule and cancel queued reminders for a published election. Recipient identities are not returned. The server selects eligible active non-voters and respects `voteReminders` preferences. The worker rechecks account status, current membership, participation, organizer authority, organization status and the election window before committing each chunk.

- Only `IN_APP` is supported. Email/SMS requests fail explicitly because no provider is configured. These are persisted inbox notifications, not push messages or email.
- `communicationJobs` stores only manager-visible scheduling/history metadata and aggregate notification counts. Client writes and ordinary member/platform-only reading are denied.
- Scheduling uses a sender/request-key idempotency ID, with payload checks on reuse. Organizations are capped at 20 pending jobs; rate limits also apply.
- A minute-based scheduler claims work with a lease. Each 50-recipient transaction checks lease ownership and notification existence. Deterministic notification IDs prevent duplicate creation and preserve existing read states after a crash/retry.
- Expired leases are recoverable; transient failures back off with at most five attempts. Closed/unavailable elections or revoked organizer access stop the job. Counts mean notifications created, never members reached or messages read.
- Only queued jobs can be cancelled; processing may already have committed notifications. Completion and scheduling/cancellation are audited.
- Deploy the callable, scheduler, indexes, rules and client together in staging before enabling real jobs. Large-roster throughput and production Cloud Scheduler behavior remain unmeasured.

The emulator integration additionally covers actual job scheduling, idempotency, concurrent workers, opt-outs, frozen late-join exclusion, already-voted exclusion, lease recovery without unread reset, cancellation and terminal election failure.

## Remaining roadmap

External email/SMS/push delivery, independent approvals, advanced election policies, disputes/recounts, PDF audit packs, enterprise identity/provisioning and public election integrations remain separate work. Production backup/restore drills, measured load capacity, full Sindhi translation and browser/device accessibility acceptance are still outstanding. The main progress file records those items without treating this phase as completion of the entire roadmap.

## Recorded local verification

877 Flutter tests, 131 Functions tests, 105 authorization rules tests and 14 real Auth/Firestore integration checks passed. Flutter analyzer and TypeScript build passed. These counts do not establish production deployment, remote CI success, browser acceptance, App Check registration or load-tested capacity.
