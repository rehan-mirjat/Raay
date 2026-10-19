import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { normalizeOrganizationName } from "../utils/organizationName";
import { sanitizePlainText } from "../utils/sanitize";

export const updateOrganization = onCall(async (request) => {
  // 1. Verify authentication
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "User must be authenticated to update an organization.");
  }

  const uid = request.auth.uid;
  const db = getFirestore();

  const { organizationId, name, description, website, logoUrl, brandColors } = request.data || {};

  if (!organizationId || typeof organizationId !== "string" || organizationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  }

  const orgId = organizationId.trim();

  // 2. Branding and organization metadata are Owner-managed in the SRS.
  const memberRef = db.collection("organizationMembers").doc(`${orgId}_${uid}`);
  const memberSnap = await memberRef.get();

  if (!memberSnap.exists || memberSnap.data()?.status !== "active" ||
      memberSnap.data()?.organizationId !== orgId || memberSnap.data()?.userId !== uid) {
    throw new HttpsError("permission-denied", "You must be an active member of this organization.");
  }

  const role = memberSnap.data()?.role;
  if (role !== "owner") {
    throw new HttpsError("permission-denied", "Only the Organization Owner can update organization settings.");
  }

  // 3. Validate cosmetic fields
  const updates: Record<string, any> = {};

  if (name !== undefined) {
    if (typeof name !== "string") {
      throw new HttpsError("invalid-argument", "Organization name must be a string.");
    }
    const trimmedName = sanitizePlainText(name);
    if (trimmedName.length < 3 || trimmedName.length > 100) {
      throw new HttpsError("invalid-argument", "Organization name must be between 3 and 100 characters.");
    }
    const nameNormalized = normalizeOrganizationName(trimmedName);

    const duplicateSnap = await db.collection("organizations")
      .where("nameNormalized", "==", nameNormalized)
      .limit(2)
      .get();
    const collidesWithAnotherOrg = duplicateSnap.docs.some((doc) => doc.id !== orgId);
    if (collidesWithAnotherOrg) {
      const existingName = duplicateSnap.docs.find((doc) => doc.id !== orgId)?.data().name as string;
      throw new HttpsError(
        "already-exists",
        `An organization with a similar name ("${existingName}") already exists. Please choose a different name.`
      );
    }

    updates.name = trimmedName;
    updates.nameNormalized = nameNormalized;
  }

  if (description !== undefined) {
    if (description !== null && typeof description !== "string") {
      throw new HttpsError("invalid-argument", "Description must be a string.");
    }
    const sanitizedDescription = typeof description === "string"
      ? sanitizePlainText(description, { multiline: true })
      : "";
    if (sanitizedDescription.length > 500) {
      throw new HttpsError("invalid-argument", "Description cannot exceed 500 characters.");
    }
    updates.description = sanitizedDescription;
  }

function isValidUrl(input: string): boolean {
  try {
    const url = new URL(input.trim());
    return url.protocol === "http:" || url.protocol === "https:";
  } catch {
    return false;
  }
}

  if (website !== undefined) {
    const cleanWebsite = typeof website === "string" ? website.trim() : "";
    if (cleanWebsite.length > 0) {
      if (!isValidUrl(cleanWebsite)) {
        throw new HttpsError("invalid-argument", "Website must be a valid URL (e.g. https://example.org).");
      }
      updates.website = cleanWebsite;
    } else {
      updates.website = null;
    }
  }

  if (logoUrl !== undefined) {
    const cleanLogoUrl = typeof logoUrl === "string" ? logoUrl.trim() : "";
    if (cleanLogoUrl.length > 0) {
      if (!isValidUrl(cleanLogoUrl)) {
        throw new HttpsError("invalid-argument", "Logo URL must be a valid URL.");
      }
      updates.logoUrl = cleanLogoUrl;
    } else {
      updates.logoUrl = null;
    }
  }

  if (brandColors !== undefined) {
    const allowedKeys = ["primary", "secondary", "accent"];
    if (!brandColors || typeof brandColors !== "object" || Array.isArray(brandColors) ||
        Object.keys(brandColors).some((key) => !allowedKeys.includes(key))) {
      throw new HttpsError("invalid-argument", "Brand colors must contain only primary, secondary, and accent colors.");
    }
    for (const key of allowedKeys) {
      if (typeof brandColors[key] !== "string" || !/^#[0-9a-fA-F]{6}$/.test(brandColors[key])) {
        throw new HttpsError("invalid-argument", `The ${key} brand color must be a six-digit hexadecimal color.`);
      }
    }
    updates.brandColors = {
      primary: brandColors.primary.toUpperCase(),
      secondary: brandColors.secondary.toUpperCase(),
      accent: brandColors.accent.toUpperCase(),
    };
  }

  if (Object.keys(updates).length === 0) {
    return { status: "success", message: "No fields to update." };
  }

  updates.updatedAt = FieldValue.serverTimestamp();

  try {
    await db.collection("organizations").doc(orgId).update(updates);

    // Audit Log
    await db.collection("auditLogs").add({
      organizationId: orgId,
      actorUid: uid,
      action: "UPDATE_ORGANIZATION_METADATA",
      resourceType: "organization",
      resourceId: orgId,
      metadata: { updatedKeys: Object.keys(updates) },
      timestamp: FieldValue.serverTimestamp(),
    });

    return { status: "success", organizationId: orgId };
  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    console.error("updateOrganization failed", error);
    throw new HttpsError("internal", "Failed to update organization metadata.");
  }
});
