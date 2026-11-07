# raay UI/UX Specification: "Clear & Confident"

Status: **historical design specification; verify current source before implementation.**
The file predates the current Raay theme and several later screen changes. The live
theme source is `lib/core/theme/app_theme.dart`; the values in section 2 are updated
to match the current Raay palette. Do not use the older workflow notes below as proof
that a screen or behavior is still missing.
The wireframes below are ASCII layout intent, **not rendered mockups of the running app**.
Nothing in this document claims a live visual audit of authenticated screens (see
"Verification limits").

## 1. Verification findings

### 1.1 Confirmed defects (reproduced by reading the code path; fix status in section 9)

| # | Defect | Evidence |
|---|--------|----------|
| 1 | Receipt verification shows "Not Found" for network/service failures | `receipt_verification_screen.dart`: `catch (_) { // Ignored - will show "Not Found" }` |
| 2 | Portal "Results available" is inferred from lifecycle status | `voter_portal_screen.dart`: filter `resultsAvailable` returns `closed \|\| archived` |
| 3 | Participation failure/loading falls back to "not voted" | `participationMap[id] ?? false`; provider failure -> empty map |
| 4 | Unreachable medium branch + fixed aspect ratio | `isDesktop ? (isMedium ? 2 : 3)`: `isMedium` is false whenever `isWide` is true; `childAspectRatio: 1.15 / 1.9` |
| 5 | `StatusBadge` has no Archived case, defaults to Draft | `status_badge.dart` `default:` falls into DRAFT |
| 6 | Builder exits are not guarded consistently | `PopScope` guards system back; the on-screen back button calls `context.pop()/go()` directly |
| 7 | "System" theme reloads as dark | `ThemeModeNotifier._load`: `default: return ThemeMode.dark` (the saved value `'system'` is not handled) |
| 8 | Hardcoded colors bypass branding/high contrast; custom animations ignore reduced motion | many `AppTheme.primaryBlue`, `Colors.white`, `AnimatedContainer`, `FadeThrough` usages |
| 9 | Hardcoded English strings / directional spacing | e.g. `'Participated'`, `'Results available'`, `EdgeInsets.only(left/right)` |

### 1.2 Not reproduced / unverified
* All authenticated-screen layouts at 360-1440px. No emulator seed data or demo accounts exist in the repo,
  and production election data must not be used to populate screens.
* Urdu/Arabic/Sindhi font glyph coverage (to be checked with a rendered test, section 8).
* Whether the previous glass pass hurts readability. The spec replaces it; no measurement was made.

### 1.3 Current palette (Raay violet, verified 2026-11-01)
The app currently uses violet primary controls and context-aware violet text accents.
Run `python3 docs/design/contrast_check.py` after changing these tokens. The checker
uses current theme values; it is a token-pair check, not a full accessibility audit.

## 2. Tokens (source: `lib/core/theme/app_theme.dart`, consumed by `RaayColors`)

| Token | Light | Dark |
|-------|-------|------|
| background | `#F7F8FC` | `#0F1420` |
| surface | `#FFFFFF` | `#171F2E` |
| surfaceElevated | `#FFFFFF` | `#202B3D` |
| textPrimary | `#172033` | `#F4F6FB` |
| textSecondary | `#526078` | `#B0BCD0` |
| border | `#E2E7F0` | `#354158` |
| primary (filled controls) | `#6D4AFF` (white label 5.15:1) | `#6D4AFF` (white label 5.15:1) |
| primaryPressed | `#5936DB` | `#5936DB` |
| accentText (links, selected text, focus ring) | `#5936DB` | `#B8A8FF` |
| sidebar | see `AppTheme` and current navigation shell | same |
| selectedFill | primary at 10% over surface | primary at 16% over surface |
| success / warning / error / info | `#0F7A4F` / `#8A5A00` / `#B42318` / `#0B5CAD` | `#4ADE9A` / `#F5B94A` / `#FF8A80` / `#7DB8FF` |

Rules: status is never color-only (icon + label). Disabled controls are exempt from contrast but must keep
a text label. Organization branding may replace `primary`/`primaryPressed`; the theme re-derives `onPrimary`
by contrast so a light brand color gets a dark label. High contrast mode raises borders and text.

* Spacing: 4, 8, 12, 16, 24, 32, 48. Card radius 16, controls 12, chips 10.
* Type: body 14-16, secondary at least 13, page heading 24-32 (clamped by text scale), min touch target 48x48.
* Surfaces are solid with a border and a soft shadow (`AppTheme.cardShadow`); overlays use stronger elevation. Use shared page composition as it is introduced; do not assume every workspace currently has a `HeroBanner`.
* No global gradient/orbs/blur. Gradients allowed only in landing/auth branding panels.
* Motion: every custom animation checks `MediaQuery.disableAnimations` (the app's reduced-motion setting already sets it).

## 3. Responsive policy

`ResponsiveLayout`: compact `< 600`, medium `600 <= w < 1024`, expanded `>= 1024` (replaces 600/900).
Grids use a `LayoutBuilder` on the **available content width** (not window width), because the sidebar
or rail consumes width: columns = `floor(contentWidth / 360)` clamped 1..3. Cards size to content
(no `childAspectRatio`). Max content width 1200; forms 640-720; ballot 680.

## 4. Navigation and information architecture

| Width | Shell |
|-------|-------|
| Expanded | 248px sidebar (org switcher at top, grouped nav, active state) + compact header (page title, search, notifications, account) |
| Medium | NavigationRail with labels as tooltips/semantics + same header |
| Compact | Compact top bar (logo, org switcher chip, notifications, account) + 4 bottom destinations + "More" sheet |

Destinations by role (membership role + `isObserver` capability, no new enum):

| Role | Primary | Secondary ("More" / sidebar groups) |
|------|---------|--------------------------------------|
| Voter | My Elections, Organizations, Activity, Account | Calendar (inside My Elections), Help, Trust & Transparency |
| Admin/Owner | Overview, Elections, People, Activity | Departments, Organization Settings, Billing (owner only), Calendar, Command Center |
| Observer (capability) | Monitored elections first, aggregate turnout, timeline | Observer view is added for any member with `isObserver` |
| Platform admin | adds a separate "Platform" group: Organization moderation, Accounts | |

Route compatibility (existing deep links keep working via redirects):
`/home` -> My Elections (voters) / Overview (admins). `/admin/events` stays for admins and redirects
voters to `/home`. `/orgs/members`, `/orgs/departments`, `/orgs/audit`, `/calendar`, `/receipt`,
`/receipt-verify`, `/transparency`, `/plans`, `/invite`, `/elections/:id/*` are unchanged.

## 5. Screen layouts (wireframes)

**Voter home (compact):**
```
[ raay ]  [Org v]        [bell][acct]
My elections                 <- title + one line of context
[search_____________] [filter v]
READY TO VOTE
+--------------------------------------+
| Board election          [ACTIVE]     |  title wraps, never clipped
| Nexaura                              |
| Closes Oct 24, 6:00 PM PKT | Anonymous|
| [ Vote now ]                         |
+--------------------------------------+
UPCOMING ...   PARTICIPATED (receipt) ...
[Home][Orgs][Activity][Account]
```
Primary action by authoritative state: Vote now / View receipt / View details / Results pending /
View published results. Participation unknown (loading or failed) shows a neutral "Checking..." chip with
**View details**, never "Vote now" and never "Participated".

**Admin overview (expanded):**
```
Nexaura                                    [ + Create election ]
REQUIRED ACTIONS  (incomplete drafts, pending tasks; hidden if none)
Metrics: [Members] [Active elections] [Pending invites]  (error -> "Unavailable", never 0)
ACTIVE ELECTIONS   turnout bar + live count      | UPCOMING | RECENT ACTIVITY
```
Home, Organization Dashboard and Command Center overlap today: Overview becomes the single landing page;
Command Center keeps its report/date-range tools as a section reachable from Elections.

**Builder:** desktop = left step list (Details, Schedule, Eligibility, Choices, Review) + form (max 720);
mobile = one step with a step counter. Footer: Back (left) / Continue (right) on every step.
Saving state is shown only for real persistence ("Draft saved" after the server confirms,
"Could not save" on failure). Timezone label next to the schedule fields.

**Ballot:** `Choose -> Review -> Confirm -> Receipt`. Candidate cards: full names (wrap), equal size,
selected = check icon + label + border + fill. The consequences panel states (a) anonymous: your choice is
not linked to your account; (b) identifiable: your choice is recorded with your identity and visible to
administrators. Finality note before the Confirm button. The sticky action bar reserves bottom padding
in the scroll view and sits above the keyboard inset.

**Receipt:** success banner first; Receipt ID and time with Copy/Verify; the hash in a collapsed
"Technical details" section. Copy states that an anonymous receipt does not prove the selected choice.

**Verification states:** `verified`, `not found` (genuine negative), `invalid input`, `service unavailable`
(retry), each with its own message/icon.

## 6. Component states

Buttons: default, hover, pressed, focused (3px ring, accentText), disabled, loading (label kept, spinner,
width stable). Cards: static vs tappable (hover border + focus ring). Badges: status and privacy with
icon + text, Archived included. Inputs: error text below the field, helper text, 48px height.
Every list/async region has loading, empty, error (with retry), permission-denied and populated states.
Failed refreshes keep the last successful data and show a warning banner.

## 7. Authentication, onboarding, settings, platform

Auth: one split layout (branding panel on expanded, compact form otherwise), autofill hints, Enter submits,
password visibility, inline errors, one primary action. Verification, resend (cooldown), MFA challenge
and session unlock share the layout. Onboarding: 3 short skippable pages; pending invitation context is
kept through sign-up. Settings: account and organization settings are separate screens with a shared
unsaved-changes guard. Billing text follows `BILLING_ENABLED` and owner permission. Ads policy unchanged:
never on ballot, receipt, verification, transparency, or management screens. Platform admin has its own
nav group and confirmation dialogs that state the consequence of each moderation/privilege action.

## 8. Validation plan

Widths 360, 390, 600, 768, 1024, 1440; light/dark/system; en + ur/ar/sd (RTL); long names;
text scale up to 2.0; keyboard focus order and visible focus; empty/populated; slow and failing network;
already-voted and unknown participation; unpublished results; builder exit; submission failure and
receipt recovery. Method: widget tests with `tester.view` sizes and `textScaler`, golden-free layout assertions
(no overflow exceptions, key widgets reachable), plus Chrome-headless screenshots of public screens
(landing, login, receipt verification). Authenticated screens are covered by widget tests with
provider overrides and clearly-labelled fixtures, **not** by screenshots of live data.

## 9. Implementation phases and status

| Phase | Scope | Status |
|-------|-------|--------|
| 0 | Specification, contrast validation | done |
| 1 | Tokens, theme, breakpoints, StatusBadge, theme-preference fix, remove glass/orbs | done (widget-tested, not visually rendered) |
| 2 | Navigation shell + role IA (248px sidebar, rail, 4 + More, exit guard on every nav) | done (widget-tested at 360-1440px / 200% text; not visually rendered). Medium width + text scale > 1.3 uses the compact layout. Platform group needs `platformAdminProvider`. Route redirects not yet added. |
| 3 | Voter journey: home, event detail, ballot, receipt, verification | done. Event detail no longer calls closed elections' results "ready" unless published (same fix as the voter home); participation failure shows a retry, never a ballot button. Ballot: sticky action bar, finality + privacy consequence on review, no raw errors. Receipt: success first, hash under Technical details. Widget-tested at 360-1440px / 200% text; not rendered. |
| 4 | Admin journey | done: builder exit guard (issue 6), election list, builder shell (side steps / step counter), all five steps widget-tested at 360-1024px / 200% text. Review step now asks before publishing and states what gets locked; it reads choices from stable providers (it resubscribed on every rebuild). Overview consolidated: `/home` shows one `AdminOverviewScreen` for owners/admins; `/orgs/dashboard` redirects to `/home`; the old Organization Dashboard screen was deleted; Command Center is a shortcut (its screen is unchanged). Turnout bars on the Overview are **not** built (they need the monitoring callable). |
| 5 | Organizations, invitations, people, departments | done for: organization list, invitation inbox, People directory + pending invitations, Departments list, Department members screen (layout fixes only, not a full redesign). **Not done:** create/join organization screens, invite / add-existing / member-profile / department dialogs, organization settings, joining codes, audit log. Widget-tested at 360-1440px / 200% text; not rendered. |
| 6 | Remaining screens, localization sweep (issue 9), reduced motion / hardcoded colors (issue 8) | in progress. Done: results, monitoring, calendar, command center ("Eligible Voters" label was really total members: renamed), login/register/forgot-password (no raw errors, real 48px buttons, scrollable branding panel), profile/settings (all 5 tabs, compact chip switcher), plans & billing, create/join organization. MFA, password-change and delete-account logic were not touched. Also done: joining codes, organization settings (layout, danger zone consequence dialog). Also done: landing page (menu moves into the drawer below 1100px or at large text; security-pipeline cards stack) and mobile onboarding (pages scroll instead of clipping; welcome link is a real 48px button), both probed at 360-1440px / 200% text with a scroll-through of the whole landing page. Also done: help/support (dead "Restart Product Tour" replaced by real links), setup checklist (back on the Overview, owners only), invite / add-existing / add-to-department / member-profile dialogs, observer dashboard, shared ErrorView (responsive), platform admin + audit log *error/denied states only*. Removed unreferenced QuickTourOverlay and WelcomeDialog. **Not done:** populated audit-log and platform-admin lists (they read Firebase directly, so only error/denied states are tested), email-verification layout test, quick product tour (removed, not rebuilt). ur/ar/sd translations of all new strings; app-wide hardcoded-color and reduced-motion sweep. |
| 6b | App-wide sweeps | done: raw exception text no longer reaches users (17 files use `friendlyError`; startup failure is plain); 118 text/icon colors moved to `accentText/errorText/successText/warningText` tokens (landing, auth branding panel and app_theme intentionally excluded); physical left/right spacing and alignment converted to directional in 11 files. **Still raw:** ~360 `AppTheme.*` uses as *fills/tints* (background alpha tints are fine in both themes; solid fills under white text were checked individually), landing page colors, `Colors.white` on dark panels. Custom hover/press animations were mostly removed earlier; remaining implicit `AnimatedContainer` hover effects on the landing page do not honor reduced motion. |
| 6c | Unsaved-data protection (review follow-up) | done: builder fields sync to the draft on every keystroke / selection / date pick (a typed title used to look "clean" until Continue); global search and workspace switching ask via the same exit guard; organization settings has Save / Discard / Keep editing on Overview, system back, sidebar, search and workspace switching; a chosen logo is staged in memory and only uploaded + published on Save (Reset / Discard drop it). Covered by tests that type into the real fields. Search and switcher wiring is analyzer-checked only (no widget test). |
| 7 | Verification pass and final report | done for what can be verified without a device: `flutter analyze` clean, 599 tests pass, release web build and release APK build succeed. **Not done / not verifiable here:** no screen was rendered or screenshotted (headless capture came out blank); no real-device or screen-reader pass; Urdu and Arabic now cover all 552 ARB strings (written by the assistant, not reviewed by a native speaker; checked for placeholders/plurals by tests); Sindhi still covers 83 of 552 (rest fall back to English) and needs a native speaker; ~495 literal English UI strings remain hardcoded in screens (landing, profile, org settings, command center, platform admin, audit, joining codes, department members, builder basics) and are NOT translated yet, only status/privacy/role badges were wired; the unsupported Terms/Privacy agreement line was removed from onboarding (no Terms/Privacy content exists). Nothing was deployed or pushed. |


### Landing page (redesign, 2026-10-23)
Glass nav, scroll reveals (off with reduced motion), verified-only copy in `landing_content.dart`. Hero ballot is a labelled, inert illustration. Joining needs an account, so the hero's join link opens registration (the join screen `/orgs/join` is behind sign-in). Checked in widget tests at 360-1440px and 200% text, light and dark, plus rendered screenshots (test renderer, Noto Sans stand-in for Plus Jakarta Sans). Not checked in a real browser: headless Chromium renders Flutter web blank here.

### Current follow-up (2026-10-27)
This note supersedes any older status above where they conflict. Profile Storage writes now accept only the app's fixed `avatar.jpg/png/webp` object names. Platform health probes Cloud Functions, Firestore, and the configured Firebase Storage bucket; email/push delivery and client devices remain explicitly unmonitored. Platform admins can assign a user report to themselves, resolve it, or reopen it through an audited callable; report replies and email delivery are not implemented. Eligibility CSV imports support pasted data and selected `.csv` files, respecting quoted fields and an Email header. The Members screen can create up to 25 invitations per CSV batch and exposes one-time links for manual sharing; it does not send email. Event setup templates can now be shared within an organization through a role-checked callable, with a 20-template cap and no voter/date fields; older device-local templates remain accessible as legacy entries. Organization reports provide aggregate activity/turnout only, suppressing per-event turnout below 10 eligible voters. Ownership transfer is now a transaction protected by recent authentication and TOTP MFA; the former owner becomes an admin and the change is audited. Organization status parsing now includes archived workspaces. Phone verification, configured email/push delivery, cryptographic end-to-end verifiability, external scale testing and real-device accessibility QA remain unimplemented or unverified. Result publication enforces enrolled TOTP MFA. Validation for this change: TypeScript build passed and all 85 Cloud Functions tests passed. Dart analysis reported no issues in changed files, but the process exits after an attempted write to the host's read-only telemetry directory; Flutter widget tests and Firestore emulator tests could not start because the sandbox denies SDK cache writes and loopback port binding, respectively.
