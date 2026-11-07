import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";

export const onUserDeleted = onDocumentDeleted(
  {
    document: "users/{userId}",
    memory: "256MiB",
    cpu: "gcf_gen1",
    retry: true,
  },
  async (event) => {
    const userId = event.params.userId;
    const db = getFirestore();

    // Remove personal applications, withdrawing approved draft candidates first.
    // Published ballots remain immutable; their public candidate data is election history.
    for (;;) {
      const page = await db.collection("nominationApplications").where("userId", "==", userId).limit(100).get();
      if (page.empty) break;
      for (const doc of page.docs) {
        await db.runTransaction(async tx => {
          const current = await tx.get(doc.ref);
          const app = current.data();
          if (!app || app.userId !== userId) return;
          const eventRef = db.collection("votingEvents").doc(app.votingEventId);
          const eventSnap = await tx.get(eventRef);
          const ev = eventSnap.data();
          if (ev?.status === "DRAFT" && ev.organizationId === app.organizationId && app.status === "APPROVED") {
            if (ev.ballotMode === "MULTI_CONTEST") {
              const contests = (ev.contests as { id: string; choices: { id: string }[] }[]).map(c => ({ ...c, choices: c.choices.filter(choice => choice.id !== app.candidateId) }));
              tx.update(eventRef, { contests, updatedAt: FieldValue.serverTimestamp() });
            } else {
              const candidateRef = db.collection("candidates").doc(app.candidateId);
              const candidate = await tx.get(candidateRef);
              if (candidate.data()?.votingEventId === eventRef.id && candidate.data()?.organizationId === app.organizationId) tx.delete(candidateRef);
              tx.update(eventRef, { updatedAt: FieldValue.serverTimestamp() });
            }
          }
          tx.delete(doc.ref);
        });
      }
    }

    // Audit history is retained as an organizational record. It can contain
    // account identifiers; this retention is disclosed in the privacy policy.
    // Bound both reads and writes. Loading a user's entire history before
    // batching writes can exhaust trigger memory for long-lived accounts.
    for (const collection of [
      "organizationMembers", "participation", "voteReceipts", "notifications", "userReports",
    ]) {
      for (;;) {
        const page = await db.collection(collection).where("userId", "==", userId).limit(400).get();
        if (page.empty) break;
        const batch = db.batch();
        page.docs.forEach(doc => batch.delete(doc.ref));
        await batch.commit();
      }
    }

    // The profile avatar's extension isn't known here, so delete by prefix
    // rather than guessing a filename. Failures are retried by this trigger.
    try {
      await getStorage().bucket().deleteFiles({ prefix: `users/${userId}/profile/` });
    } catch (error) {
      console.error(`onUserDeleted: failed to delete storage avatar for ${userId}`, error);
      // This trigger has retry enabled. Surface the failure so Firebase retries
      // cleanup instead of leaving a deleted user's image behind permanently.
      throw error;
    }
  }
);
