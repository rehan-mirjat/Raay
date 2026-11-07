# raay permissions contract (draft for approval)

Status: **proposal, no code changed.** Every row is enforced on three layers:
**UI** (not rendered), **Route** (direct URL checked), **Backend** (callable / Firestore / Storage).
A row is "done" only when all three agree and a parity test covers it.

## 1. Inputs to every decision

`user` + `organization (and its status)` + `membership (role, status, observer flag)` + `target member` + `event state` + `participation`.
Switching organization discards the previous organization's permissions and cached data.

Admin/Owner is **not** voting eligibility. `canVote` = active membership + org operational + event ACTIVE and inside its window + server says eligible + not yet participated.

## 2. Statuses

| Membership status | Can vote | Can manage | Sees |
|---|---|---|---|
| active | per eligibility | per role | normal app |
| pending | no | no | "Waiting for approval" + next step |
| inactive | no | no | "Your access is paused" + contact admin |
| suspended | no | no | "Suspended" + contact admin |
| removed | no | no | org disappears from the list |

Organization status: **one** operational set, shared by Firestore rules, every callable and the UI. Proposed: `pending`, `verified`, `active` run elections; `suspended`, `rejected`, `inactive` do not. (Today monitoring allows only `verified/active`, everything else allows `pending`.)

## 3. Role x action matrix

Legend: Y allowed, - hidden and rejected, own = only the user's own record, agg = aggregate only.

| Action | Member | Admin | Owner | Observer (extra) | Platform admin (no membership) |
|---|---|---|---|---|---|
| See my elections, eligibility, my receipt | Y | Y | Y | | - |
| Cast vote | Y if eligible | Y if eligible | Y if eligible | no change | - |
| Published results | Y | Y | Y | | - |
| Unpublished results / tallies | - | Y | Y | - | - |
| Monitoring / timeline (agg, never per-voter) | - | Y | Y | Y agg | - |
| Create / edit / delete elections, candidates, options (DRAFT) | - | Y | Y | - | - |
| Publish, close, cancel election | - | Y | Y | - | - |
| Publish results | - | Y | Y | - | - |
| Member directory, invite, joining codes | - | Y | Y | - | - |
| Change ordinary member status / department | - | Y | Y | - | - |
| Promote / demote Admin, set observer | - | - | Y | - | - |
| Remove / deactivate Owner | - | - | never via normal action | | |
| Departments | - | Y | Y | - | - |
| Audit log | - | Y | Y | - | - |
| Organization settings, branding, logo | - | - | Y | - | - |
| Billing / plans | - | - | Y | - | - |
| Delete organization | - | - | Y | - | - |
| Platform: moderate organizations, platform tools | - | - | - | - | Y (platform area only) |
| Own account, invitations inbox | Y | Y | Y | Y | Y |

Platform admin gets **no** ballots and **no** tenant management by default.

## 4. Navigation (what renders)

| Item | Member | Admin | Owner |
|---|---|---|---|
| My elections / Organizations / Invitations / Account | Y | Y | Y |
| Overview, Elections (manage), People, Activity | - | Y | Y |
| Departments, Calendar | calendar only | Y | Y |
| Observer | if observer | if observer | if observer |
| **Organization settings** | - | **- (today shown: bug)** | Y |
| **Billing** | - | - | Y |
| Platform | platform admin only | | |

## 4b. Routes that need a central guard

Today `app_router.dart` guards only `/admin/*` (minus `/admin/events`) and `OrganizationSettingsScreen` checks Owner inside the screen. Proposal: one table `route prefix -> required capability`, evaluated in `redirect`:

`/orgs/settings` canManageBranding · `/plans` canManageBilling · `/orgs/members`, `/orgs/departments`, `/orgs/audit`, `/orgs/joining-codes` canManageMembers · `/admin/**` canManageElections · `/observer` canMonitor · `/platform/**` platform admin.
Unauthorized -> `/home` with no flash of the screen.

## 5. Known mismatches to fix (verified in source)

| # | Finding | Evidence | Fix |
|---|---|---|---|
| 1 | Admin sees Organization settings | `nav_destinations.dart`: `_orgSettings` in every manager's secondary nav; screen allows Owner only | gate on `isOwner` |
| 2 | `inactive` becomes `pending` in Flutter | `updateMemberStatus.ts` writes `inactive`; `MembershipStatus` has no `inactive`, `fromString` falls back to `pending` | add `inactive` to enum, fix all switches, test |
| 3 | Restricted elections show "Not eligible" to eligible members | `isLikelyEligible` reads `event.eligibilityUserIds/DepartmentIds`; those lists live in admin-only `votingEventEligibility`, so they are empty for members | new callable `getMyEligibility(eventId)` returning only `{eligible, reason}` for the caller; UI uses it |
| 4 | Org status policy differs | `OPERATIONAL_ORG_STATUSES` includes `pending`; `getEventMonitoring` requires `verified/active` | single shared constant; rules + callables + UI use it |
| 5 | Route guard incomplete | only `/admin/*` in router | table in section 4b |

Not yet verified (to check, not assumed): which callables lack a role check, observer-only access paths, cross-organization cache after switching.

## 5b. Status of step 2 (logic corrections)

| # | State |
|---|---|
| 1 Settings link | fixed in nav + profile menu Billing; tested |
| 2 `inactive` | enum fixed; tested (UI labels for the new status still to design) |
| 3 Eligibility | `getMyEligibility` callable + client wiring done, tested; NOT deployed |
| 4 Org status | monitoring and remindNonVoters now use the shared operational set. Joining/invite/add-member intentionally stay stricter (verified/active only: a pending org may run elections but not recruit); decision to confirm |
| 5 Route guard | central table in `route_access.dart`, used by the router; tested |

## 6. Member home (target)

Sections: Available to vote / Upcoming / My participation and receipts / Published results.
One action per election: Vote, View receipt, View details, Results pending, View results, Checking eligibility / Retry.
Scope: selected organization by default; "All organizations" is an explicit filter.

## 7. Verification plan

1. One shared resolver (`canManageMembers`, `canChangeRoles`, `canManageBranding`, `canManageBilling`, `canMonitorEvent`, `canVote`) used by menu, router and screens.
2. Table-driven test: every role x status x action expects the same answer from the Dart resolver and the backend helper.
3. Rules tests for Firestore and Storage per role; cross-organization negative tests.
4. Direct-URL widget tests per role.
