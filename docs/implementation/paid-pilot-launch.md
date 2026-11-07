# Raay inquiry-first commercial launch

## What this release delivers

Public `/pricing` and authenticated `/plans` show introductory USD quote prices: Demo (free mock walkthrough for groups up to 20), Starter ($15/election, 100 eligible voters), Standard ($39/election, 500 voters), Assisted (from $99, scope agreed individually), and Annual organizer ($129/year, four elections, each up to 500 voters).

These are quote requests, not automatic paid entitlements. Current organization subscriptions remain separately managed at `/plans/legacy`, owner-only. Existing quotas are not increased by sending an inquiry. Personal organizer-license enforcement and device leases remain a separate implementation; an inquiry must never be represented as an active personal license.

1. A public visitor chooses a package, signs in/verifies email, and returns to the inquiry form with that package selected. The in-memory selection survives ordinary navigation, not a browser refresh during sign-in.
2. The form collects organization name, expected eligible voters, optional preferred date and support notes. It tells the user that follow-up uses their verified account email. It does not collect voter lists or payment data.
3. `requestSalesInquiry` validates the package and voter limit, uses the authenticated email/UID, checks manager authorization for a supplied organization ID, and limits new requests to five per day.
4. It creates a private `userReports` record with category `Sales enquiry`. The reference is deterministic per account/request UUID, so identical retries return the same request. Changed data cannot reuse an existing reference. Server-generated prices cannot be overridden by the client.
5. The buyer sees status through `/help/reports`. Platform administrators see the inquiry and verified contact email in `/platform/reports`, filter by `Sales enquiry`, and assign/resolve it using the existing audited triage function.

## Operator workflow for the first three pilots

- Review the Sales enquiry category daily and assign each lead to an operator.
- Contact the verified account email manually. No email is automatically sent by this release.
- Confirm election date, voter count, ballot mode, authorized organizer, training/support scope, applicable taxes and payment/refund terms in a written quote.
- Explain current limits honestly: invitations are shared manually; there is no independent election certification claim. Rehearse the ballot with the organizer before a live election.
- Take payment only through your configured, supported payment method after accepting the scope. This release does not collect, verify, or process payments and does not provide a paid-activation workflow. Provisioning must follow a separately verified payment/entitlement implementation; do not change a support request to "resolved" as a substitute for payment proof.
- Track actual support hours, hosting cost and feedback. Request permission before publishing any testimonial.

Native apps show paid package information but do not initiate paid inquiries/purchases. Free demo requests remain available. Paid inquiries are currently a web-product flow; Google Play Billing or an applicable approved program must be implemented before selling in-app digital features on Android.

## Deployment

Build and deploy the updated Functions codebase (includes `requestSalesInquiry`) and the Flutter web build together. The existing userReports rules and composite index for userId/createdAt already cover buyer history. No rules have been weakened for sales. Existing account-deletion cleanup removes userReports, including these inquiries.

Before advertising, verify a real verified-email account can submit one inquiry, that a platform administrator sees it, and that your team can handle follow-up. Checkout, payment webhooks, license sharing controls and automated email are not advertised as active capabilities.
