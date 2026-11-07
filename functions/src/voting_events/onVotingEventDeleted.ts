import { getFirestore } from "firebase-admin/firestore";
import { onDocumentDeleted } from "firebase-functions/v2/firestore";

/** Idempotent, paged cleanup: drafts can have more applications than a single batch allows. */
export const onVotingEventDeleted = onDocumentDeleted({ document: "votingEvents/{eventId}", retry: true }, async event => {
  const db = getFirestore();
  for (const collection of ["nominationApplications", "nominationRounds"]) {
    for (;;) {
      const page = await db.collection(collection).where("votingEventId", "==", event.params.eventId).limit(400).get();
      if (page.empty) break;
      const batch = db.batch();
      page.docs.forEach(doc => batch.delete(doc.ref));
      await batch.commit();
    }
  }
});
