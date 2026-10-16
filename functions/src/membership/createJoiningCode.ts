import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import * as crypto from "crypto";
import { getJoinCodeSecret, JOIN_CODE_SECRET } from "../utils/joinCodeSecret";
import { requireActiveMembership, requireOperationalOrganization, MAX_CREDENTIAL_EXPIRY_HOURS, requireNotRevoked, requireRecentAuthentication } from "../utils/authorization";
import { checkRateLimit, RATE_LIMIT_INVITATION_ACTION } from "../utils/rateLimiter";

function generateRandomCode(): string {
  // 12-character high-entropy CSPRNG code formatted as JOIN-XXXX-XXXX-XXXX
  const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // 32 unambiguous chars
  const bytes = crypto.randomBytes(12);
  let raw = "";
  for (let i = 0; i < 12; i++) {
    raw += chars.charAt(bytes[i] % chars.length);
  }
  return `JOIN-${raw.substring(0, 4)}-${raw.substring(4, 8)}-${raw.substring(8, 12)}`;
}

function computeCodeHmac(rawCode: string): string {
  const normalized = rawCode.trim().toUpperCase().replace(/[\s-]/g, "");
  const secret = getJoinCodeSecret();
  return crypto.createHmac("sha256", secret).update(normalized).digest("hex");
}

export const createJoiningCode = onCall({ secrets: [JOIN_CODE_SECRET] }, async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  // FR-10: bulk issuing of joining codes is an explicitly-named sensitive operation.
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);

  const uid = request.auth.uid;
  // Table 3-4: "Invitation actions 30 per hour" per user.
  await checkRateLimit(uid, RATE_LIMIT_INVITATION_ACTION);
  const { organizationId, customCode, expiresInHours = 168, maxUses = 0 } = request.data || {};

  if (!organizationId || typeof organizationId !== "string" || organizationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  }

  // Strict Duration Validation: Table 3-4 caps joining-code lifetime at 30 days.
  if (!Number.isInteger(expiresInHours) || expiresInHours <= 0 || expiresInHours > MAX_CREDENTIAL_EXPIRY_HOURS) {
    throw new HttpsError("invalid-argument", `expiresInHours must be a positive integer between 1 and ${MAX_CREDENTIAL_EXPIRY_HOURS}.`);
  }

  // Strict MaxUses Validation: Must be integer >= 0
  if (!Number.isInteger(maxUses) || maxUses < 0 || maxUses > 100000) {
    throw new HttpsError("invalid-argument", "maxUses must be an integer between 0 and 100000.");
  }

  const db = getFirestore();

  // Verify caller is Org Owner or Admin
  await requireActiveMembership(db, organizationId, uid, ["owner", "admin"]);

  await requireOperationalOrganization(db, organizationId);

  const expiresAt = new Date();
  expiresAt.setHours(expiresAt.getHours() + expiresInHours);

  let rawCode: string;
  let codeHash: string;

  // Transactionally set joiningCodes/{codeHash} to guarantee 100% uniqueness
  const createdCodeId = await db.runTransaction(async (transaction) => {
    if (customCode && typeof customCode === "string") {
      const normalizedCustom = customCode.trim().toUpperCase().replace(/[\s-]/g, "");
      if (normalizedCustom.length < 8 || !/^[A-Z0-9]+$/.test(normalizedCustom)) {
        throw new HttpsError("invalid-argument", "Custom joining code must contain at least 8 alphanumeric characters.");
      }
      rawCode = customCode.trim().toUpperCase();
      codeHash = computeCodeHmac(rawCode);

      const codeRef = db.collection("joiningCodes").doc(codeHash);
      const codeSnap = await transaction.get(codeRef);
      if (codeSnap.exists) {
        throw new HttpsError("already-exists", "This joining code is already in use.");
      }

      transaction.set(codeRef, {
        id: codeHash,
        organizationId: organizationId,
        codeHash: codeHash,
        status: "active",
        maxUses: maxUses,
        currentUses: 0,
        expiresAt: expiresAt,
        createdBy: uid,
        createdAt: FieldValue.serverTimestamp(),
      });

      return codeHash;
    } else {
      // Generated CSPRNG code with transactional uniqueness guarantee
      let attempts = 0;
      while (attempts < 5) {
        rawCode = generateRandomCode();
        codeHash = computeCodeHmac(rawCode);
        const codeRef = db.collection("joiningCodes").doc(codeHash);
        const codeSnap = await transaction.get(codeRef);

        if (!codeSnap.exists) {
          transaction.set(codeRef, {
            id: codeHash,
            organizationId: organizationId,
            codeHash: codeHash,
            status: "active",
            maxUses: maxUses,
            currentUses: 0,
            expiresAt: expiresAt,
            createdBy: uid,
            createdAt: FieldValue.serverTimestamp(),
          });
          return codeHash;
        }
        attempts++;
      }
      throw new HttpsError("internal", "Failed to generate unique joining code. Please try again.");
    }
  });

  // Audit log (NO RAW CODES, NO NORMALIZED STRINGS, NO HASHES)
  const auditRef = db.collection("auditLogs").doc();
  await auditRef.set({
    organizationId: organizationId,
    actorUid: uid,
    action: "CREATE_JOINING_CODE",
    resourceType: "joiningCode",
    resourceId: createdCodeId,
    metadata: { joiningCodeId: createdCodeId, maxUses: maxUses, expiresInHours: expiresInHours },
    timestamp: FieldValue.serverTimestamp(),
  });

  return {
    status: "success",
    joiningCodeId: createdCodeId,
    rawCode: rawCode!, // Returned ONLY ONCE to Admin
  };
});
