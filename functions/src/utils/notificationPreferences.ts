import { Firestore } from "firebase-admin/firestore";

const CHUNK_SIZE = 30; // Firestore "in" query limit

/**
 * Given a list of user ids, returns only those who have NOT opted out of the
 * given notification preference key. Users with no users/{uid} doc, or no
 * notificationPreferences field, default to opted-in (true) - the same
 * default the client uses - so this only ever removes an explicit opt-out.
 */
export async function filterOptedIn(
  db: Firestore,
  userIds: string[],
  preferenceKey: "voteReminders" | "invitationAlerts" | "eventUpdates"
): Promise<string[]> {
  if (userIds.length === 0) return [];

  const optedOut = new Set<string>();
  for (let i = 0; i < userIds.length; i += CHUNK_SIZE) {
    const chunk = userIds.slice(i, i + CHUNK_SIZE);
    const snap = await db
      .collection("users")
      .where("__name__", "in", chunk)
      .get();
    for (const doc of snap.docs) {
      const prefs = doc.data().notificationPreferences;
      if (prefs && prefs[preferenceKey] === false) {
        optedOut.add(doc.id);
      }
    }
  }

  return userIds.filter((id) => !optedOut.has(id));
}
