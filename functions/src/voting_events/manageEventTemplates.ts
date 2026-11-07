import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { requireActiveMembership, requireNotRevoked, requireOperationalOrganization } from "../utils/authorization";
import { sanitizePlainText } from "../utils/sanitize";

const MAX_TEMPLATES = 20;
const VOTING_TYPES = new Set(["candidateElection", "singleChoicePoll", "yesNoPoll"]);
const PRIVACY_MODES = new Set(["anonymous", "identifiable"]);

/** Organization-shared event setup only. Never accepts eligibility, voters, choices, or dates. */
export const manageEventTemplates = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication required.");
  await requireNotRevoked(request);

  const organizationId = typeof request.data?.organizationId === "string"
    ? request.data.organizationId.trim()
    : "";
  const action = request.data?.action;
  if (!organizationId) throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  if (!["list", "save", "delete"].includes(action)) {
    throw new HttpsError("invalid-argument", "Unsupported template action.");
  }

  const db = getFirestore();
  await requireActiveMembership(db, organizationId, uid, ["owner", "admin"]);
  await requireOperationalOrganization(db, organizationId);
  const templates = db.collection("organizations").doc(organizationId).collection("eventTemplates");

  if (action === "list") {
    const snapshot = await templates.orderBy("updatedAt", "desc").limit(MAX_TEMPLATES).get();
    return {
      status: "success",
      templates: snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() })),
    };
  }

  if (action === "delete") {
    const templateId = typeof request.data?.templateId === "string" ? request.data.templateId.trim() : "";
    if (!templateId || templateId.length > 128) throw new HttpsError("invalid-argument", "Valid templateId is required.");
    const ref = templates.doc(templateId);
    const snap = await ref.get();
    if (!snap.exists) throw new HttpsError("not-found", "Template not found.");
    await ref.delete();
    await db.collection("auditLogs").add({
      organizationId, actorUid: uid, action: "DELETE_EVENT_TEMPLATE", resourceType: "eventTemplate",
      resourceId: templateId, metadata: {}, timestamp: FieldValue.serverTimestamp(),
    });
    return { status: "success" };
  }

  const name = typeof request.data?.name === "string" ? sanitizePlainText(request.data.name).trim() : "";
  const title = typeof request.data?.title === "string" ? sanitizePlainText(request.data.title).trim() : "";
  const description = typeof request.data?.description === "string"
    ? sanitizePlainText(request.data.description, { multiline: true }).trim()
    : "";
  const votingType = request.data?.votingType;
  const privacyMode = request.data?.privacyMode;
  if (name.length < 1 || name.length > 48) throw new HttpsError("invalid-argument", "Template name must be 1–48 characters.");
  if (title.length < 1 || title.length > 120) throw new HttpsError("invalid-argument", "Template title must be 1–120 characters.");
  if (description.length > 5000) throw new HttpsError("invalid-argument", "Template description is too long.");
  if (!VOTING_TYPES.has(votingType) || !PRIVACY_MODES.has(privacyMode)) {
    throw new HttpsError("invalid-argument", "Unsupported voting type or privacy mode.");
  }

  const ref = templates.doc();
  await db.runTransaction(async (transaction) => {
    const current = await transaction.get(templates.limit(MAX_TEMPLATES + 1));
    if (current.docs.some((doc) => String(doc.data().name ?? "").trim().toLocaleLowerCase() === name.toLocaleLowerCase())) {
      throw new HttpsError("already-exists", "A template with this name already exists for the organization.");
    }
    if (current.size >= MAX_TEMPLATES) {
      throw new HttpsError("resource-exhausted", "This organization already has 20 saved templates.");
    }
    transaction.create(ref, { name, title, description, votingType, privacyMode, createdBy: uid,
      createdAt: FieldValue.serverTimestamp(), updatedAt: FieldValue.serverTimestamp() });
  });
  await db.collection("auditLogs").add({
    organizationId, actorUid: uid, action: "CREATE_EVENT_TEMPLATE", resourceType: "eventTemplate",
    resourceId: ref.id, metadata: { name }, timestamp: FieldValue.serverTimestamp(),
  });
  return { status: "success", templateId: ref.id };
});
