# raay Enterprise Expansion & Improvement Roadmap

Based on the 51-screen strategic plan and enterprise requirements.

## Phase 1: Security Foundation (In Progress / Mostly Complete)
- [x] Source code and Firestore security audit (Completed in M6 Audit)
- [x] Voter eligibility and duplicate prevention (Implemented in `castVote.ts` transaction)
- [x] Ballot secrecy & privacy modes (Implemented: `votes` and `participation` collections are isolated)
- [x] Authorization and election lifecycle tests (Firestore Emulator tests added in M6)
- [ ] **Pending:** Public Receipt Verification UI (Independent verifiability without revealing vote)

## Phase 2: Election Management (Pending)
- [ ] Election Templates (Board, Student Council, Referendum)
- [ ] Advanced Ballot Designer (Order, preview)
- [ ] Voter Registry & Bulk Import (CSV/Excel upload, validation)
- [ ] Candidate Management & Approval Center
- [ ] Results Publication Workflow (Embargo, Review)

## Phase 3: Premium UI/UX (In Progress)
- [x] Desktop, Android, and tablet navigation shells (`app_navigation_shell.dart` overhauled)
- [x] Dark, Light, and System themes (`app_theme.dart` design tokens established)
- [x] Premium icon pack (`lucide_icons`) and typography (`Plus Jakarta Sans`)
- [ ] **Pending:** Refactor existing screens (Auth, Dashboards, Voting) to use new UI Kit
- [ ] **Pending:** Accessibility and multilingual interfaces (RTL, Text Scaling)

## Phase 4: Enterprise Expansion (Pending)
- [ ] Advanced analytics and reports (Exportable CSVs/PDFs)
- [ ] Notification Center & Delivery Tracking (Email/Push statuses)
- [ ] Roles & Permissions (Custom org-level controls)
- [ ] Platform Operations Center & Health
- [ ] Support tickets, data privacy (GDPR compliance), and retention