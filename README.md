# Kivora

**Secure, multi-tenant voting and polling for organizations.**

Kivora is a Flutter + Firebase application for running candidate elections, single-choice polls, and Yes/No polls inside an organization — with server-enforced eligibility, anonymous or identifiable ballots, and audited administration. Built for academic and small-to-mid-size organizational elections (roughly 100–1,000 eligible voters per event).

[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.5.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud%20Functions%20%7C%20Firestore%20%7C%20Storage-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Node](https://img.shields.io/badge/Node-22-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.9-3178C6?logo=typescript&logoColor=white)](https://www.typescriptlang.org)

---

## Table of contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Security model](#security-model)
- [Tech stack](#tech-stack)
- [Project structure](#project-structure)
- [Getting started](#getting-started)
- [Testing](#testing)
- [Deployment](#deployment)
- [Known limitations](#known-limitations)
- [Operational notes](#operational-notes)

## Overview

Organizations register on the platform, get verified by a platform administrator, and run their own elections inside their own tenant. Members join by invitation, joining code, or being added directly by an admin. Everything that affects a vote's integrity — eligibility, duplicate-vote prevention, event timing, result tallying — is enforced server-side in Cloud Functions, never trusted to the client.

## Features

**Organizations**
- Registration, platform verification, white-label branding (logo, accent colors), and multi-organization switching for users who belong to more than one.
- Owner / Admin / Member roles, scoped per organization (not global).
- Departments, for grouping members and scoping eligibility.
- Member invitations (email-based), joining codes, and direct member addition by admins.

**Voting events**
- Candidate elections, single-choice polls, and Yes/No polls.
- Eligibility scoped to all members, selected members, or selected departments.
- Anonymous or identifiable privacy modes, with anonymous ballots stored separately from participation records so selections can never be traced back to a voter.
- One vote per event per eligible voter, enforced server-side.
- Participation receipts so a voter can confirm they voted without revealing their selection.
- Live turnout monitoring for admins while an event is active.
- Server-calculated results with an explicit publish step — unpublished results are visible only to Owners/Admins; publishing makes them visible to members.
- Scheduled lifecycle transitions (draft → scheduled → active → closed) run on a Cloud Scheduler job, not client-triggered.

**Administration & trust**
- Organization-scoped audit logs for membership, role, and voting-event actions.
- A separate platform-administration area (verify/suspend organizations, platform analytics) gated by a trusted `platformAdmin` custom claim the client cannot set.
- Recent-authentication requirements on sensitive actions (publishing/closing an event, role changes, account deletion) with an in-app re-verification flow.
- Rate limiting on organization creation, invitations, joining-code redemption, and other sensitive operations.
- Signed, time-limited download URLs for candidate photos, organization logos, and avatars — never public storage links.

## Architecture

```
Flutter client (Android · iOS · Web)
        │
        ├── Firebase Authentication ── identity (email/password, Google)
        │
        ├── Cloud Functions (TypeScript, callable) ── all writes that affect
        │   trust: membership, roles, votes, results, invitations, audit logs
        │
        ├── Cloud Firestore ── application data, locked down by security
        │   rules so the client can only read what its role permits and can
        │   write almost nothing directly
        │
        └── Cloud Storage ── candidate photos, org logos, avatars, served
            through short-lived signed URLs issued by a Cloud Function
```

State management is [Riverpod](https://riverpod.dev); navigation is [go_router](https://pub.dev/packages/go_router). The backend is a single Cloud Functions codebase (2nd gen, Node 22) organized by domain under `functions/src/`.

## Security model

- Firebase Authentication provides identity; roles are stored **per organization**, never globally.
- Every organization-scoped Cloud Function call checks the caller's authentication, active membership, role, and resource ownership before touching data.
- Firestore rules deny client writes to votes, participation records, invitations, results, memberships, and audit logs outright — only Cloud Functions (running with elevated trust) can write them.
- Anonymous ballots omit voter identity entirely; selection data is kept out of participation and receipt records so the two can never be joined.
- Eligibility, duplicate-vote checks, event status, and voting-window checks are all evaluated server-side against server time — the client's clock and state are never trusted for these decisions.
- Sensitive operations (publish/close an event, change a role, delete an account) require a recent sign-in (within a configured window); an expired session prompts in-app re-authentication rather than silently failing.
- Platform administration uses a trusted `platformAdmin` custom claim, assignable only through a reviewed, out-of-band administrative process — never through the client.

See [`firestore.rules`](firestore.rules) and [`storage.rules`](storage.rules) for the authoritative access policy, and [`functions/src/utils/authorization.ts`](functions/src/utils/authorization.ts) for the shared authorization helpers every callable function uses.

## Tech stack

| Layer | Technology |
|---|---|
| Client | Flutter (Dart ≥3.5.0), Riverpod, go_router |
| Identity | Firebase Authentication (email/password, Google Sign-In) |
| Backend | Cloud Functions for Firebase (TypeScript, 2nd gen, Node 22) |
| Database | Cloud Firestore |
| File storage | Cloud Storage for Firebase |
| Scheduling | Cloud Scheduler (voting-event lifecycle transitions) |

## Project structure

```
lib/
├── core/            # Theme, routing, shared widgets, cross-cutting utilities
├── features/         # Feature-first modules: auth, organizations, departments,
│                      voting_events, voting, onboarding, landing, support
└── services/         # Firebase service wrappers

functions/src/
├── auth/              # Registration, account deletion, auth triggers
├── organizations/      # Create/update/verify/suspend organizations
├── membership/         # Invitations, joining codes, member management
├── departments/         # Department CRUD and assignment
├── voting_events/       # Event CRUD, candidates, poll options, lifecycle
├── voting/              # Vote casting, result calculation, publication
├── admin/, platform/    # Platform-administrator operations
├── storage/              # Signed download URLs
├── security/              # Shared security utilities
└── utils/                  # Authorization, rate limiting, validation helpers

firestore.rules, firestore.indexes.json   # Firestore access policy and indexes
storage.rules                              # Cloud Storage access policy
test/, functions/src/__tests__/, firestore-tests/   # Flutter, functions, and rules tests
```

## Getting started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (Dart SDK ≥3.5.0)
- [Node.js 22](https://nodejs.org)
- A [Firebase project](https://console.firebase.google.com) with Authentication, Firestore, Cloud Storage, and Cloud Functions enabled
- The [Firebase CLI](https://firebase.google.com/docs/cli) (`npm install -g firebase-tools`)

### Setup

```sh
# Install dependencies
flutter pub get
npm --prefix functions install

# Point the project at your own Firebase project
firebase use --add
flutterfire configure
```

Configure the required Cloud Functions secrets in Secret Manager before deploying (invitation email delivery also needs a configured mail provider if email sending is enabled). Then deploy the backend:

```sh
firebase deploy --only firestore:rules,firestore:indexes,storage,functions
```

> Never grant the `platformAdmin` claim through the client. Assign it through a trusted, reviewed administrative process only.

### Run the app

```sh
flutter run                 # whatever device/emulator is attached
flutter run -d chrome       # web
```

### Build

```sh
flutter build apk           # Android
flutter build ios           # iOS
flutter build web           # Web
```

## Testing

```sh
# Flutter unit/widget tests
flutter test

# Cloud Functions unit tests
npm --prefix functions test

# Firestore security rules tests (requires the Firebase emulator)
firebase emulators:exec --only firestore "cd firestore-tests && npm test"
```

`flutter analyze` and `npx tsc --noEmit` (run from `functions/`) should both be clean before opening a PR.

## Known limitations

This is a working application under active development, not a certified election system. Specifically:

- **No multi-factor authentication yet.** The server-side enrollment check exists but isn't wired into any flow — there's no MFA enrollment UI, and the Firebase project isn't upgraded to Identity Platform (required for MFA). Do not treat any account as MFA-protected.
- **No formal cryptographic end-to-end verifiability.** Ballot integrity relies on server-side enforcement and Firestore security rules, not a verifiable-voting cryptographic scheme.
- **A Firebase project owner can access backend data outside application-level controls.** This is inherent to the Firebase trust model, not a Kivora-specific gap.
- **Scale target is ~100–1,000 eligible voters per event.** Larger elections would need separate capacity and aggregation planning.
- No in-app phone verification, no organization-level reports/notifications backend, and no formal organization lifecycle beyond the states described above — these are not implemented, not partially-working stubs.

## Operational notes

- Organization administration and platform administration are separate, independently-scoped permission systems.
- Organization invitations appear in the recipient's in-app notifications once they sign in with the invited, verified email address. The recipient can accept or decline; invitations expire after a configured period.
- Google Sign-In on Android requires the signing certificate's SHA-1/SHA-256 fingerprint registered against the Android app in the Firebase console — see [`android/app/google-services.json`](android/app/google-services.json) (gitignored; provision it per-environment).
