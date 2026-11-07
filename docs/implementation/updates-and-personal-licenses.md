# Update policy and personal licensing

## Supported-build gate

Android/iOS clients fetch `appReleases/android` or `appReleases/ios` at startup and on resume, before showing the app. The installed build number comes from package_info_plus, not a manually maintained version constant.

Trusted operators can configure a document using the Admin SDK/Firebase Console:

- `enabled`: boolean
- `minimumBuild`: positive integer (Android versionCode / iOS numeric CFBundleVersion)
- `updateUrl`: the HTTPS URL of the already published store listing

Android URLs must point to `play.google.com/store/apps/details?id=com.raay.app`. iOS URLs must use `apps.apple.com` and end in an actual numeric app ID. No store listing is assumed to exist and no release policy is activated automatically.

Publish and verify the new store release first, then increase minimumBuild. Disable the policy to roll it back. Firestore clients can fetch only the two public release documents; no client, including a platform administrator, may write the policy. No secrets belong in these documents.

A first-time network failure permits access so an outage does not stop elections. A valid policy is cached locally; once the app has learned a mandatory update, a failed refresh keeps that gate visible even after restarting. This is a UX gate, not security enforcement: modified clients can bypass it, and older apps without this code cannot be retroactively forced to update. Backend authentication and entitlement checks remain necessary. Web continues to use deployed Hosting assets rather than mobile store updates.

## Owner-selected licensing model

The owner selected PERSONAL licenses: only the Firebase UID which purchased a subscription may receive its paid privileges. Existing Stripe billing is organization-based. It must not be described as personal licensing or migrated by assigning every organization's owner an unverified purchase.

Recommended implementation contract:

1. Store personal entitlements at `userLicenses/{uid}`, written exclusively by verified payment webhooks/store receipt verification. Include ownerUid, productId, status, subscriptionId, provider, expiresAt and revokedAt. Never trust a local premium flag or checkout redirect.
2. Every paid backend action verifies the authenticated UID's current license, expiry and revocation. Organization membership/roles remain a separate check. Organization limits and voter access need an explicit migration policy; voters should still be able to participate without buying the organizer's personal subscription.
3. Bind each verified store purchase token/subscription to one UID in a server-only unique purchase registry. A copied token must not activate another account. Refund, chargeback, cancellation and renewal notifications update the entitlement idempotently.
4. For account sharing, use a server-issued installation/session lease and a stated device allowance (recommended: two registered devices, one active paid session). Provide a device list, revoke action and recovery/change-device flow. Avoid IMEI or permanent hardware fingerprinting. A reinstall/device identifier alone is not proof of identity.
5. Check the license again on paid mutations and periodically for active paid sessions; use App Check/Play Integrity as an additional signal after platform registration. A user can still share login credentials, so UID binding alone cannot promise to stop sharing.
6. Android digital subscription purchases require Google Play Billing unless an applicable allowed program/exemption is verified; do not route a Play app to the existing web Stripe checkout as a substitute. Web Stripe purchases require their own personal product/UID metadata and verified webhook path.

These licensing restrictions are a design contract. The current organization checkout and plan entitlements have not been silently converted to personal licenses. Store product IDs, purchase verification configuration, device allowance and migration of existing organization subscriptions must be settled before enforcement.
