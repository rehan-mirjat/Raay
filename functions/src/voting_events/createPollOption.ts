import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS, LIMITS,
  enforceRateLimit, failWith, loadDraftEventForChild, optionalString, parseSortOrder,
  rejectUnknownKeys, requireAdminMember, requireAuth, requireId, requireOperationalOrg,
  requiredString, writeAudit,
} from "./votingCommon";

export const createPollOption = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  rejectUnknownKeys(data, ["organizationId", "votingEventId", "label", "description", "sortOrder"], "createPollOption");

  const organizationId = requireId(data.organizationId, "organizationId");
  const votingEventId = requireId(data.votingEventId, "votingEventId");
  const label = requiredString(data.label, "Poll option label", 1, 100);
  const description = optionalString(data.description, "Description", 500);
  const sortOrder = data.sortOrder === undefined ? 0 : parseSortOrder(data.sortOrder);

  const db = getFirestore();
  await enforceRateLimit(db, uid, "createPollOption");

  const optionRef = db.collection("pollOptions").doc();
  const optionId = optionRef.id;

  try {
    await db.runTransaction(async (tx) => {
      await requireAdminMember(tx, db, organizationId, uid, "create poll options");
      await requireOperationalOrg(tx, db, organizationId);
      await loadDraftEventForChild(tx, db, organizationId, votingEventId, "Poll options", "SINGLE_CHOICE_POLL");

      const siblings = await tx.get(
        db.collection("pollOptions")
          .where("organizationId", "==", organizationId)
          .where("votingEventId", "==", votingEventId)
      );
      if (siblings.size >= LIMITS.MAX_OPTIONS) {
        throw new HttpsError("failed-precondition", `A poll cannot have more than ${LIMITS.MAX_OPTIONS} options.`);
      }
      const lower = label.toLowerCase();
      if (siblings.docs.some((d) => String(d.data().label || "").trim().toLowerCase() === lower)) {
        throw new HttpsError("already-exists", "An option with this label already exists in this poll.");
      }

      tx.set(optionRef, {
        id: optionId,
        organizationId,
        votingEventId,
        label,
        description,
        sortOrder,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "CREATE_POLL_OPTION",
        resourceType: "pollOption",
        resourceId: optionId,
        metadata: { label, votingEventId },
      });
    });

    return { status: "success", optionId };
  } catch (error) {
    failWith("createPollOption", error, "Failed to create poll option.");
  }
});
