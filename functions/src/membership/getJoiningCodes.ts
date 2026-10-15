import { getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { requireActiveMembership } from "../utils/authorization";

function parseDate(val: any): Date | null {
  if (!val) return null;
  if (typeof val.toDate === "function") return val.toDate();
  if (val instanceof Date) return val;
  if (typeof val === "number") return new Date(val);
  if (typeof val === "string") {
    const d = new Date(val);
    return isNaN(d.getTime()) ? null : d;
  }
  return null;
}

/** Lists safe joining-code metadata; the original codes and HMACs are never returned. */
export const getJoiningCodes = onCall(async (request) => {
  try {
    const uid = request.auth?.uid;
    if (!uid) throw new HttpsError("unauthenticated", "Authentication is required.");

    const organizationId = typeof request.data?.organizationId === "string"
      ? request.data.organizationId.trim()
      : "";
    if (!organizationId) {
      throw new HttpsError("invalid-argument", "A valid organizationId is required.");
    }

    const db = getFirestore();
    await requireActiveMembership(db, organizationId, uid, ["owner", "admin"]);

    const snapshot = await db.collection("joiningCodes")
      .where("organizationId", "==", organizationId)
      .get();
    const now = Date.now();
    const codes = snapshot.docs.map((doc) => {
      const code = doc.data();
      const expiresAt = parseDate(code.expiresAt);
      const createdAt = parseDate(code.createdAt);
      const status = code.status === "active" && expiresAt && expiresAt.getTime() <= now
        ? "expired"
        : code.status ?? "unknown";
      return {
        codeId: doc.id,
        displayId: doc.id.slice(-8).toUpperCase(),
        status,
        currentUses: Number(code.currentUses ?? 0),
        maxUses: Number(code.maxUses ?? 0),
        expiresAt: expiresAt?.toISOString() ?? null,
        createdAt: createdAt?.toISOString() ?? null,
      };
    }).sort((a, b) => (b.createdAt ?? "").localeCompare(a.createdAt ?? ""));

    return { status: "success", codes };
  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Unable to load joining codes.", error);
  }
});
