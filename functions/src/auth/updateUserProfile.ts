import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { sanitizePlainText } from "../utils/sanitize";

const PHONE_REGEX = /^[+()\-.\s\d]{0,20}$/;

/**
 * Updates the caller's own users/{uid} profile fields. Firestore rules lock
 * this document to client-writable photoUrl only, specifically because
 * firstName/lastName/phoneNumber need the same sanitizePlainText() control-
 * character / bidi-spoofing stripping every other free-text field in this
 * project goes through - rules can bound size/type but can't strip
 * characters, so this callable is the only path to edit them.
 */
export const updateUserProfile = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");

  const data = request.data ?? {};
  const update: Record<string, unknown> = {};

  if (data.firstName !== undefined) {
    const firstName = sanitizePlainText(String(data.firstName));
    if (!firstName || firstName.length > 50) {
      throw new HttpsError("invalid-argument", "First name must be 1-50 characters.");
    }
    update.firstName = firstName;
  }

  if (data.lastName !== undefined) {
    const lastName = sanitizePlainText(String(data.lastName));
    if (!lastName || lastName.length > 50) {
      throw new HttpsError("invalid-argument", "Last name must be 1-50 characters.");
    }
    update.lastName = lastName;
  }

  if (update.firstName || update.lastName) {
    const userSnap = await getFirestore().collection("users").doc(uid).get();
    const existing = userSnap.data() ?? {};
    const firstName = (update.firstName as string | undefined) ?? existing.firstName ?? "";
    const lastName = (update.lastName as string | undefined) ?? existing.lastName ?? "";
    update.displayName = `${firstName} ${lastName}`.trim();
  }

  if (data.phoneNumber !== undefined) {
    if (data.phoneNumber === null) {
      update.phoneNumber = null;
    } else {
      const phoneNumber = sanitizePlainText(String(data.phoneNumber));
      if (phoneNumber.length > 20 || !PHONE_REGEX.test(phoneNumber)) {
        throw new HttpsError("invalid-argument", "Invalid phone number.");
      }
      update.phoneNumber = phoneNumber || null;
    }
  }

  if (data.notificationPreferences !== undefined) {
    const prefs = data.notificationPreferences;
    if (typeof prefs !== "object" || prefs === null || Array.isArray(prefs)) {
      throw new HttpsError("invalid-argument", "notificationPreferences must be an object.");
    }
    const allowedKeys = ["voteReminders", "invitationAlerts", "eventUpdates"];
    const sanitizedPrefs: Record<string, boolean> = {};
    for (const key of allowedKeys) {
      if (typeof prefs[key] === "boolean") sanitizedPrefs[key] = prefs[key];
    }
    update.notificationPreferences = sanitizedPrefs;
  }

  if (Object.keys(update).length === 0) {
    throw new HttpsError("invalid-argument", "No valid fields to update.");
  }

  await getFirestore().collection("users").doc(uid).update(update);

  return { status: "success" };
});
