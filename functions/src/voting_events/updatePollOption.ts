import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS,
  enforceRateLimit, failWith, loadDraftEventForChild, optionalString, parseSortOrder,
  rejectUnknownKeys, requireAdminMember, requireAuth, requireId, requireOperationalOrg,
  requiredString, writeAudit,
} from "./votingCommon";

export const updatePollOption = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const data = request.data || {};
  rejectUnknownKeys(data, ["optionId", "label", "description", "sortOrder"], "updatePollOption");

  const optionId = requireId(data.optionId, "optionId");
  const label = data.label !== undefined ? requiredString(data.label, "Poll option label", 1, 100) : undefined;
  const description = data.description !== undefined ? optionalString(data.description, "Description", 500) : undefined;
  const sortOrder = data.sortOrder !== undefined ? parseSortOrder(data.sortOrder) : undefined;

  const db = getFirestore();
  await enforceRateLimit(db, uid, "updatePollOption");
  const optionRef = db.collection("pollOptions").doc(optionId);

  try {
    await db.runTransaction(async (tx) => {
      const snap = await tx.get(optionRef);
      if (!snap.exists) throw new HttpsError("not-found", "Poll option not found.");
      const opt = snap.data()!;
      const organizationId = opt.organizationId as string;
      const votingEventId = opt.votingEventId as string;

      await requireAdminMember(tx, db, organizationId, uid, "update poll options");
      await requireOperationalOrg(tx, db, organizationId);

      if (optionId === `${votingEventId}_YES` || optionId === `${votingEventId}_NO`) {
        throw new HttpsError("failed-precondition", "Generated YES/NO poll options cannot be modified.");
      }
      await loadDraftEventForChild(tx, db, organizationId, votingEventId, "Poll options");

      const updates: Record<string, unknown> = {};
      if (label !== undefined && label !== opt.label) {
        const siblings = await tx.get(
          db.collection("pollOptions")
            .where("organizationId", "==", organizationId)
            .where("votingEventId", "==", votingEventId)
        );
        const lower = label.toLowerCase();
        if (siblings.docs.some((d) => d.id !== optionId && String(d.data().label || "").trim().toLowerCase() === lower)) {
          throw new HttpsError("already-exists", "An option with this label already exists in this poll.");
        }
        updates.label = label;
      }
      if (description !== undefined && description !== opt.description) updates.description = description;
      if (sortOrder !== undefined && sortOrder !== opt.sortOrder) updates.sortOrder = sortOrder;

      if (Object.keys(updates).length === 0) throw new HttpsError("invalid-argument", "No changes provided.");

      tx.update(optionRef, { ...updates, updatedAt: FieldValue.serverTimestamp() });
      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "UPDATE_POLL_OPTION",
        resourceType: "pollOption",
        resourceId: optionId,
        metadata: { label: (updates.label as string) || opt.label, changedFields: Object.keys(updates) },
      });
    });

    return { status: "success" };
  } catch (error) {
    failWith("updatePollOption", error, "Failed to update poll option.");
  }
});
