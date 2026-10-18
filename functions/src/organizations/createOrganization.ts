import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { checkRateLimit, RATE_LIMIT_ORG_CREATION } from "../utils/rateLimiter";
import { requireNotRevoked } from "../utils/authorization";
import { normalizeOrganizationName } from "../utils/organizationName";
import { sanitizePlainText } from "../utils/sanitize";

const ALLOWED_TYPES = ["academic", "corporate", "nonProfit", "club", "community", "other"];
const UUID_V4_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export const createOrganization = onCall(async (request) => {
  // 1. Verify authentication
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "User must be authenticated to create an organization.");
  }

  await requireNotRevoked(request);

  // Org verification is self-service: a user whose own account email is
  // confirmed can create an already-verified organization directly, with
  // no platform-admin review step. The client already gates every route
  // behind email verification (see RouterNotifier), so this is a
  // server-side assertion of that same invariant, not new friction.
  if (request.auth.token.email_verified !== true) {
    throw new HttpsError(
      "failed-precondition",
      "Please verify your email address before you can create an organization."
    );
  }

  const uid = request.auth.uid;
  const db = getFirestore();

  // Table 3-4: 3 organization-creation attempts per user per 24 hours.
  await checkRateLimit(uid, RATE_LIMIT_ORG_CREATION);

  // 2. Validate authenticated user's profile and account state in Firestore
  const userRef = db.collection("users").doc(uid);
  const userSnap = await userRef.get();

  if (!userSnap.exists) {
    throw new HttpsError("permission-denied", "User profile does not exist.");
  }

  const userData = userSnap.data();
  if (!userData || userData.status !== "active") {
    throw new HttpsError("permission-denied", "Your account must be active to create an organization.");
  }

  // 3. Extract and validate payload
  const {
    requestId,
    name,
    type,
    description,
    country,
    city,
    website,
    logoUrl,
  } = request.data || {};

  // Validate requestId (Must be valid UUID v4 format)
  if (!requestId || typeof requestId !== "string" || !UUID_V4_REGEX.test(requestId.trim())) {
    throw new HttpsError("invalid-argument", "Valid UUID v4 requestId string is required for idempotency.");
  }

  const cleanRequestId = requestId.trim().toLowerCase();

  // Validate Organization Name (sanitize before measuring length so control/
  // bidi-spoofing characters don't count toward the limit they won't occupy
  // in the stored value).
  if (!name || typeof name !== "string") {
    throw new HttpsError("invalid-argument", "Organization name is required.");
  }
  const sanitizedName = sanitizePlainText(name);
  if (sanitizedName.length < 3 || sanitizedName.length > 100) {
    throw new HttpsError("invalid-argument", "Organization name must be between 3 and 100 characters.");
  }

  // Validate Controlled Organization Type Vocabulary
  if (!type || typeof type !== "string" || !ALLOWED_TYPES.includes(type.trim())) {
    throw new HttpsError(
      "invalid-argument",
      `Invalid organization type. Allowed values: ${ALLOWED_TYPES.join(", ")}`
    );
  }

  // Validate Description
  if (description !== undefined && description !== null) {
    if (typeof description !== "string") {
      throw new HttpsError("invalid-argument", "Description must be a string.");
    }
    if (sanitizePlainText(description, { multiline: true }).length > 500) {
      throw new HttpsError("invalid-argument", "Description cannot exceed 500 characters.");
    }
  }

  // Contact email is the organization creator's own (already-verified)
  // account email, not a separately-collected field - this is both the
  // basis for self-service verification and avoids a second, unverified
  // email address being attached to the organization.
  const authEmail = request.auth.token.email;
  if (!authEmail || typeof authEmail !== "string") {
    throw new HttpsError("failed-precondition", "Your account has no verified email address.");
  }

  // Validate Country and City (optional)
  if (country !== undefined && country !== null && typeof country !== "string") {
    throw new HttpsError("invalid-argument", "Country must be a string.");
  }

  if (city !== undefined && city !== null && typeof city !== "string") {
    throw new HttpsError("invalid-argument", "City must be a string.");
  }

function isValidUrl(input: string): boolean {
  try {
    const url = new URL(input.trim());
    return url.protocol === "http:" || url.protocol === "https:";
  } catch {
    return false;
  }
}

  // Validate Optional URLs (must be valid HTTP/HTTPS)
  if (website && (typeof website !== "string" || !isValidUrl(website))) {
    throw new HttpsError("invalid-argument", "Website must be a valid URL (e.g. https://domain.com).");
  }

  if (logoUrl && (typeof logoUrl !== "string" || !isValidUrl(logoUrl))) {
    throw new HttpsError("invalid-argument", "Logo URL must be a valid URL.");
  }

  const trimmedName = sanitizedName;
  const trimmedType = type.trim();
  const trimmedDescription = typeof description === "string"
    ? sanitizePlainText(description, { multiline: true })
    : "";
  const trimmedEmail = authEmail.trim();
  const trimmedCountry = typeof country === "string" ? sanitizePlainText(country) : "";
  const trimmedCity = typeof city === "string" ? sanitizePlainText(city) : "";
  const cleanWebsite = website ? website.trim() : null;
  const cleanLogoUrl = logoUrl ? logoUrl.trim() : null;
  const nameNormalized = normalizeOrganizationName(trimmedName);

  // 4. Transactional Idempotency Claiming, Duplicate-Name Check, and Document Creation
  try {
    const createdOrgId = await db.runTransaction(async (transaction) => {
      const idempotencyRef = db.collection("organizationIdempotency").doc(cleanRequestId);
      const idempotencySnap = await transaction.get(idempotencyRef);

      // Check if this requestId was already processed
      if (idempotencySnap.exists) {
        const idData = idempotencySnap.data();
        if (idData && idData.actorUid !== uid) {
          // Cross-user reuse attempt: REJECT without revealing existing org ID
          throw new HttpsError("permission-denied", "Access denied.");
        }
        // Identical request from same user: Return previously generated organizationId
        return idData?.organizationId as string;
      }

      // Reject near-duplicate names (case/whitespace/punctuation-insensitive)
      // so two organizations can't collide under slightly different spellings.
      const duplicateQuery = db.collection("organizations")
        .where("nameNormalized", "==", nameNormalized)
        .limit(1);
      const duplicateSnap = await transaction.get(duplicateQuery);
      if (!duplicateSnap.empty) {
        const existingName = duplicateSnap.docs[0].data().name as string;
        throw new HttpsError(
          "already-exists",
          `An organization with a similar name ("${existingName}") already exists. Please choose a different name.`
        );
      }

      // Generate Firestore Auto-ID for Organization
      const orgRef = db.collection("organizations").doc();
      const orgId = orgRef.id;

      const membershipRef = db.collection("organizationMembers").doc(`${orgId}_${uid}`);
      const auditRef = db.collection("auditLogs").doc();

      // Write 1: Organization Document. Verification is self-service: the
      // creator's account email is already confirmed (checked above), so
      // the organization is verified immediately - no platform-admin
      // review step in the common case.
      transaction.set(orgRef, {
        id: orgId,
        name: trimmedName,
        nameNormalized,
        type: trimmedType,
        description: trimmedDescription,
        email: trimmedEmail,
        website: cleanWebsite,
        logoUrl: cleanLogoUrl,
        country: trimmedCountry,
        city: trimmedCity,
        status: "verified",
        ownerId: uid,
        createdAt: FieldValue.serverTimestamp(),
        verifiedAt: FieldValue.serverTimestamp(),
        verifiedBy: "self-service:email-verification",
        suspendedAt: null,
      });

      // Write 2: Organization Member Document (Owner)
      transaction.set(membershipRef, {
        membershipId: `${orgId}_${uid}`,
        organizationId: orgId,
        userId: uid,
        role: "owner",
        status: "active",
        employeeId: null,
        departmentId: null,
        joinedAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });

      // Write 3: Audit Log Document
      transaction.set(auditRef, {
        organizationId: orgId,
        actorUid: uid,
        action: "CREATE_ORGANIZATION",
        resourceType: "organization",
        resourceId: orgId,
        metadata: {
          organizationName: trimmedName,
          type: trimmedType,
          verifiedVia: "email-verification",
        },
        timestamp: FieldValue.serverTimestamp(),
      });

      // Write 4: Idempotency Claim Record
      transaction.set(idempotencyRef, {
        requestId: cleanRequestId,
        actorUid: uid,
        organizationId: orgId,
        createdAt: FieldValue.serverTimestamp(),
      });

      return orgId;
    });

    return { status: "success", organizationId: createdOrgId };
  } catch (error: any) {
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Failed to create organization.", error);
  }
});
