# raay platform console — proposed UI reference

Scope: design references and recommendations only. No application or backend changes. Generated with the built-in image-generation tool. All displayed identities, dates and counts are illustrative.

## Findings from current files
- Only /platform/admin and /platform/organizations exist as platform routes.
- PlatformAdminScreen combines ten aggregate metrics, user listing and privilege changes.
- listOrganizationsForPlatformAdmin returns the latest 100 organizations without a cursor. Local search/counts cover that subset only.
- listPlatformUsers supports 100-account pagination but no server search endpoint.
- getPlatformAnalytics counts pending platformReports; support submits open userReports. These should not be presented as one queue without mapping the sources and status vocabulary.
- reviewOrganization supports pending->verified/rejected, verified/active->suspended, suspended->active. It records platformAuditLogs but accepts no decision reason.
- createAdmin/removeAdmin require a platform claim, non-revoked session and recent authentication. removeAdmin blocks self-removal; createAdmin requires an enabled, verified target.
- Audit data exists, but no dedicated platform audit page was found. Report assignment/resolution workflow is proposed, not implemented.

## Proposed pages
1. Overview: priority queues, a few correctly labeled aggregate counts, generatedAt and partial-error recovery.
2. Organizations: server pagination/search, explicit counts scope and filters.
3. Organization review/detail: submitted metadata, current status, permitted transitions, reason capture and actual consequences. No tenant editing or private ballots.
4. Accounts & Access: separate account directory from platform grants; read-only profile detail, account verification status, explicit target confirmation, recent-auth flow, self-removal blocked. Do not add disable/reset/impersonate actions without scoped backend authorization.
5. Reports: connect actual userReports source; new backend for status changes, assignment and internal notes. Minimize exposed report data.
6. Audit log: read-only paginated platform events, safe filters and existing fields. Legacy absent reasons/outcomes must stay absent. New event schema should distinguish committed changes from failed attempts; do not invent historical events.

## Boundary and implementation order
A platform claim does not grant tenant membership, candidate editing, individual vote access or impersonation. Preserve this separation in UI, routes and backend.

Build order: shared platform shell + overview/list data contracts; organization pagination/detail/moderation reason; accounts/access; read-only audit; report triage backend and UI. Add loading/empty/error/denied states and cross-role tests for every page. Verify demotion/revocation propagates to existing sessions; do not claim immediate revocation from deleting a custom claim alone.

No new custom super-admin tiers are assumed. MFA step-up is an enhancement to verify and implement, not claimed as present on these platform actions. Health dashboards, revenue charts and global feature flags are deferred until real data sources and control APIs exist.

## Image interpretation
Use layout, palette, density and hierarchy as references. Generated microcopy never overrides verified backend effects. Any restore action, security claim, editable field or result/outcome must be supported and reviewed before implementation. New workflows are marked proposed.

## Generation prompt brief
raay PLATFORM CONSOLE; two-screen reference boards, navy #142333 sidebar, teal #0F766E controls, warm gray #F5F6F8 workspace, white surfaces and ink #17212F typography; flat views, readable tables, explicit platform role, role-specific actions, no ballot access, no fabricated analytics. Boards: Overview/Organizations; Organization review/Accounts & Access; Reports/Audit Log.
