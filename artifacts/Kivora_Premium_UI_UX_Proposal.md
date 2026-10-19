# Kivora Premium UI/UX Transformation Proposal

## Executive Summary
This document serves as the Phase 1 & 2 deliverable for the Kivora UI/UX Modernization. Based on the `Kivora_Screen_Reference.docx` and the provided high-fidelity mockups, this proposal outlines the exact technical mapping, design tokens, and component architecture required to transform Kivora into a premium SaaS product. 

**Zero functionality will be removed. Backend schemas, Firebase Auth, voting transaction safety, and role-based permissions will remain exactly as they are.** Brand logos and core icons are preserved.

---

## Phase 1: Project Audit & Screen Coverage Matrix

The project currently uses Riverpod for state management, go_router for navigation, and Firebase as the backend. The below matrix maps the 31 required screens to their existing or planned paths in the `lib/features/` architecture.

| # | Screen Name | Current/Planned Route | Target Transformation |
|---|---|---|---|
| 1 | Splash Screen | `/` -> `lib/core/presentation/splash_screen.dart` | Full-screen glowing gradient, animated brand logo, loading indicator. |
| 2 | MobileOnboardingScreen | `/onboarding` | 3-step swiping carousel with custom illustrations and dot indicators. |
| 3 | LandingPageScreen | `/landing` | Responsive Light/Dark landing page with multi-column features. |
| 4 | LoginScreen | `/login` | Centered glass card (Desktop) / Full-screen form (Mobile) with Google Auth. |
| 5 | RegisterScreen | `/register` | Unified form, matching Login visual weight. |
| 6 | EmailVerificationScreen| `/verify-email` | Mail icon focal point, resend timer, "Open Email App" intent. |
| 7 | ProfileScreen | `/profile` | Split layout (Desktop) / List layout (Mobile) for avatar, 2FA, settings. |
| 8 | HomeScreen | `/home` | Organization summary grid, growth charts, active events, quick actions. |
| 9 | AppNavigationShell | `lib/core/presentation/app_navigation_shell.dart` | **Desktop:** Persistent Sidebar. **Mobile:** Bottom Navigation Bar + App Bar. |
| 10| OrganizationListScreen | `/orgs` | Grid (Desktop) / List (Mobile) of joined orgs. |
| 11| OrganizationDashboard | `/orgs/:id` | Unified dashboard specific to the active organization context. |
| 12| OrganizationSettings | `/orgs/:id/settings` | Multi-tab settings (General, Branding, Danger Zone). |
| 13| CreateOrganization | `/orgs/create` | Step-by-step or tall card form. |
| 14| JoinOrganization | `/orgs/join` | Segmented control (Join with Code / Join with Link), large PIN input. |
| 15| InvitationInbox | `/orgs/invitations` | Sent/Received tabs, Accept/Decline action chips. |
| 16| AcceptInvitationLink | `/join/:code` | Deep-link receiver screen. |
| 17| JoiningCodesScreen | `/orgs/:id/codes` | List of active codes, generate new code modal. |
| 18| MembershipDirectory | `/orgs/:id/directory` | Searchable list, role chips, avatar placeholders. |
| 19| OrganizationAudit | `/orgs/:id/audit` | Chronological timeline view of logs. |
| 20| DepartmentsScreen | `/orgs/:id/departments` | List of departments with member counts. |
| 21| DepartmentMembers | `/orgs/:id/departments/:deptId`| Filtered directory view. |
| 22| AdminEventDashboard | `/admin/events` | Tabs (All, Upcoming, Completed), detailed event cards. |
| 23| EventBuilderScreen | `/admin/events/new` | Multi-step wizard (Details, Candidates, Settings, Review). |
| 24| EventDetailScreen | `/elections/:id` | Event info, countdown timer, cast vote trigger. |
| 25| CastVoteScreen | `/elections/:id/vote` | Radio/Check selection, sticky "Next/Submit" bottom bar. |
| 26| EventResultsScreen | `/elections/:id/results` | FlChart visualizations, percentage bars, metric cards. |
| 27| EventMonitoringScreen | `/admin/events/:id/monitoring` | Real-time participation ring charts. |
| 28| VoteReceiptScreen | `/elections/:id/receipt` | Cryptographic hash display, copy button, verified badge. |
| 29| HelpSupportScreen | `/support` | FAQ accordions, contact form. |
| 30| PlatformOrganizations| `/super-admin/orgs` | Data table of all organizations (Admin only). |
| 31| PlatformAdminScreen | `/super-admin` | Multi-panel dashboard with global analytics. |

---

## Phase 2: Design System Proposal

We will centralize all UI definitions in a new `KivoraDesignSystem` class (replacing the current standard `AppTheme`).

### 1. Typography
*   **Font Family:** `Plus Jakarta Sans` (to be added to pubspec.yaml via google_fonts if not already present, or downloaded as assets).
*   **Scale:** High contrast, strict hierarchy (H1 -> H6, BodyLarge, BodyMedium, LabelSmall).

### 2. Design Tokens (Colors)
Derived directly from the mockups:
*   **Dark Background:** `#0B1020`
*   **Dark Surface:** `#151B30`
*   **Dark Elevated:** `#202740`
*   **Light Background:** `#F6F8FC`
*   **Light Surface:** `#FFFFFF`
*   **Primary Brand:** `#7857F7` (Violet)
*   **Secondary Accent:** `#3284FF` (Blue)
*   **Highlight Accent:** `#28C8FF` (Cyan)
*   **Success:** `#10B981`
*   **Warning:** `#F59E0B`
*   **Error:** `#EF4444`
*   **Glow/Glass:** Extensive use of `BackdropFilter` with `sigmaX: 10, sigmaY: 10` for floating components.

### 3. Iconography
*   **Package:** `lucide_icons` (Offers exact match to the clean, consistent, rounded-corner line icons seen in the designs).

### 4. Component Architecture
We will build a strict UI kit in `lib/core/widgets/ui_kit/` before updating individual screens:
*   `KivoraButton` (Primary gradient, Secondary outline, Ghost, Destructive)
*   `KivoraCard` (Glassmorphic in dark mode, flat with subtle shadow in light mode)
*   `KivoraTextField` (Floating labels, solid background fill, distinct focus ring)
*   `KivoraBottomNav` (Floating pill style or cleanly separated bottom bar)
*   `KivoraSidebar` (Desktop navigation rail with expand/collapse)
*   `KivoraAvatar` (Standardized sizing, automated initials fallback)
*   `KivoraMetricCard` (Used on dashboards for Turnout, Total Members, etc.)
*   `KivoraProgressBar` (Animated widths, glowing trails)

### 5. Layout Paradigms
*   **Mobile (< 600px):** Full-width lists, bottom sheet modals, sticky bottom action bars, AppBars with centered titles.
*   **Tablet (600px - 1024px):** Navigation Rail, max-width constrained forms (avoiding stretched fields), side-by-side split where appropriate.
*   **Desktop (> 1024px):** Fixed left Sidebar, Top header with breadcrumbs and global search, multi-column dashboard layouts.

---

## Next Steps (Awaiting Approval)
If this audit and design proposal is approved, Phase 4 (Implementation) will proceed in the following safe, reversible order:
1.  **Foundation:** Install `lucide_icons` and `google_fonts`. Implement the raw `KivoraDesignSystem` tokens.
2.  **Core Components:** Build the reusable UI Kit widgets.
3.  **Shell & Navigation:** Overhaul `AppNavigationShell` to match the Premium Desktop Sidebar / Mobile Bottom Nav mockup.
4.  **Screen Upgrades:** Progressively convert features (Auth -> Dashboard -> Org Management -> Voting) without touching business logic.