import { HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";

export const JOIN_CODE_SECRET = defineSecret("JOIN_CODE_SECRET");
export const LEGACY_INVITATION_SECRET = defineSecret("LEGACY_INVITATION_SECRET");
export const LEGACY_JOIN_CODE_SECRET = defineSecret("LEGACY_JOIN_CODE_SECRET");

export function getJoinCodeSecret(): string {
  const configuredSecret = process.env.JOIN_CODE_SECRET?.trim();
  if (configuredSecret) return configuredSecret;

  if (process.env.FUNCTIONS_EMULATOR === "true" || process.env.FIREBASE_AUTH_EMULATOR_HOST) {
    return "emulator-secret-key-98765-do-not-use-in-prod";
  }

  try {
    const boundSecret = JOIN_CODE_SECRET.value()?.trim();
    if (boundSecret) return boundSecret;
  } catch (e) {
    // Secret is not bound in Secret Manager - fall through to fail closed below.
  }

  // Never fall back to a source-committed secret in production: that would let anyone
  // who has read this file compute valid join-code HMACs. Fail closed instead.
  throw new HttpsError("internal", "Join code signing is not configured.");
}

export function getLegacyJoinCodeSecret(): string | null {
  const configuredSecret = process.env.LEGACY_JOIN_CODE_SECRET?.trim();
  if (configuredSecret) return configuredSecret;

  if (process.env.FUNCTIONS_EMULATOR === "true" || process.env.FIREBASE_AUTH_EMULATOR_HOST) {
    return null;
  }

  try {
    const boundSecret = LEGACY_JOIN_CODE_SECRET.value()?.trim();
    return boundSecret || null;
  } catch (_) {
    return null;
  }
}

export function getLegacyInvitationSecret(): string | null {
  const configuredSecret = process.env.LEGACY_INVITATION_SECRET?.trim();
  if (configuredSecret) return configuredSecret;

  if (process.env.FUNCTIONS_EMULATOR === "true" || process.env.FIREBASE_AUTH_EMULATOR_HOST) {
    return null;
  }

  try {
    const boundSecret = LEGACY_INVITATION_SECRET.value()?.trim();
    return boundSecret || null;
  } catch (_) {
    return null;
  }
}
