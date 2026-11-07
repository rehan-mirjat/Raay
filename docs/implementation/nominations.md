# Active-member nominations

Local implementation; not deployed. The owner confirmed that only active organization members may apply.

## Workflow

1. An active owner/admin creates a round from **Nominations** for a draft candidate election. For a multi-contest election, select one of its saved contests. A round closes no later than the election start. One round per ballot/contest, maximum ten per event.
2. Any active member, including an owner/admin, can apply for themselves with a public name, optional statement and explicit consent. Applicants cannot supply a different user ID. The round must still be open according to server time. Duplicate applications are rejected; a withdrawn application may be resubmitted while open.
3. The manager explicitly closes the round. A passed deadline stops submissions but does not skip the close/review step.
4. Owners/admins approve or reject individual applications. Rejection requires a reason visible to the applicant. Approval rechecks current membership and adds a randomly identified candidate/contest choice atomically. Public ballot data does not expose application IDs or member UIDs. Candidate limits and duplicate names still apply.
5. Applicants may withdraw pending/approved applications while the election is a draft. Withdrawing an approved application also removes its draft candidate. Managers may revoke an approval with a rejection reason, including when the applicant is no longer active.
6. Publishing requires every linked round to be closed, no applications pending, and each approved candidate to remain active with matching consented name and statement on the ballot. Publication locks nomination controls atomically. Existing events without nominations follow the existing flow.

The builder must first save valid multi-contest configuration (2–10 contests, at least two choices each). Additional members can then nominate for those contests. This phase does not introduce empty-contest drafting, external nominees, nominator/seconder rules, nomination attachments, appeals, or email delivery.

## Access and storage

- `nominationRounds`: safe election title, contest title, cutoff and status; readable only by active members in an operational organization.
- `nominationApplications`: own application or organization owner/admin only. Platform-admin status alone does not grant access. All client writes are denied.
- The `manageNominations` callable performs revocation, membership, organization, deadline, draft-state and strict payload checks. Changes touch the event in a transaction, serializing against publication. Active account profiles are read inside transactions so account deletion also blocks in-flight applications and approvals. Applications are deterministically keyed by a hash of round and applicant to enforce uniqueness, never reused as public candidate IDs.
- The Flutter query shapes include organization scope and, for members, their own user ID. Rounds and application lists expose incremental load-more controls instead of silently truncating the first page.
- Event deletion triggers idempotent cleanup in batches of 400. Account deletion removes private applications and approved draft candidacies; published ballots retain public candidate history and cast votes remain untouched. Personal history cleanup is also chunked below Firestore's batch limit.
- No automatic emails or fictional delivery status are created.

## Rollout

Deploy the callable, Firestore indexes/rules and deletion trigger together with the client after testing in a staging project. Existing clients need no migration. Production rollout, backfill and external provider configuration have not been performed by this implementation.
