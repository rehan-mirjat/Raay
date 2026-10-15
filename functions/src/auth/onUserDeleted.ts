import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";

export const onUserDeleted = onDocumentDeleted(
  {
    document: "users/{userId}",
    memory: "256MiB",
    cpu: "gcf_gen1",
  },
  async (event) => {
    const userId = event.params.userId;
    const db = getFirestore();

    // auditLogs are deliberately NOT deleted here - they're a retained audit
    // trail, not the user's own data, and should survive account deletion.
    const [membershipsSnapshot, participationSnapshot, receiptsSnapshot] = await Promise.all([
      db.collection("organizationMembers").where("userId", "==", userId).get(),
      db.collection("participation").where("userId", "==", userId).get(),
      db.collection("voteReceipts").where("userId", "==", userId).get(),
    ]);

    const batch = db.batch();
    membershipsSnapshot.docs.forEach((doc) => batch.delete(doc.ref));
    participationSnapshot.docs.forEach((doc) => batch.delete(doc.ref));
    receiptsSnapshot.docs.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();

    // Best-effort: the profile avatar's extension isn't known here, so delete
    // by prefix rather than guessing a filename.
    try {
      await getStorage().bucket().deleteFiles({ prefix: `users/${userId}/profile/` });
    } catch (error) {
      console.error(`onUserDeleted: failed to delete storage avatar for ${userId}`, error);
    }
  }
);
