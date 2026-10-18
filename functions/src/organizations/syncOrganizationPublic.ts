import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { getFirestore } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

/**
 * Mirrors the minimal, non-sensitive fields of an organization into
 * organizationPublic/{organizationId}, which any signed-in user may read
 * directly (see firestore.rules) without being a member - used to preview
 * an organization (name, logo, verification status) before joining it via
 * a joining code or invitation, without exposing membership rosters,
 * contact email, or anything else on the real organizations document.
 *
 * onDocumentWritten triggers for the same document aren't guaranteed to run
 * in the order their source writes happened. Every write here is guarded by
 * comparing this event's time against the sourceUpdatedAt already stored on
 * the public doc, so a late-arriving, out-of-order event is dropped instead
 * of clobbering a newer state that already landed.
 */
export const syncOrganizationPublic = onDocumentWritten(
  {
    document: "organizations/{organizationId}",
    memory: "256MiB",
    cpu: "gcf_gen1",
  },
  async (event) => {
    const organizationId = event.params.organizationId;
    const db = getFirestore();
    const publicRef = db.collection("organizationPublic").doc(organizationId);
    const eventTime = Date.parse(event.time);

    try {
      const existing = await publicRef.get();
      const existingEventTime = existing.exists
        ? (existing.data()?.sourceUpdatedAt as number | undefined)
        : undefined;
      if (typeof existingEventTime === "number" && existingEventTime > eventTime) {
        return;
      }

      const after = event.data?.after;
      if (!after || !after.exists) {
        await publicRef.delete();
        return;
      }

      const data = after.data() || {};
      await publicRef.set({
        organizationId,
        name: data.name ?? "Organization",
        logoUrl: data.logoUrl ?? null,
        type: data.type ?? null,
        status: data.status ?? "pending",
        verified: data.status === "verified" || data.status === "active",
        sourceUpdatedAt: eventTime,
      });
    } catch (error) {
      logger.error("syncOrganizationPublic failed to sync an organization", {
        organizationId,
        error: error instanceof Error ? error.message : String(error),
      });
      throw error;
    }
  }
);
