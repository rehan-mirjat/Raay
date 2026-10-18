import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { getFirestore } from "firebase-admin/firestore";

/**
 * Mirrors the minimal, non-sensitive fields of an organization into
 * organizationPublic/{organizationId}, which any signed-in user may read
 * directly (see firestore.rules) without being a member - used to preview
 * an organization (name, logo, verification status) before joining it via
 * a joining code or invitation, without exposing membership rosters,
 * contact email, or anything else on the real organizations document.
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

    const after = event.data?.after;
    if (!after || !after.exists) {
      await publicRef.delete().catch(() => {});
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
    });
  }
);
