import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { requireActiveMembership, requireNotRevoked } from "../utils/authorization";

/**
 * Table 3-4 / "Protected-download URLs": at most 10 minutes, issued only after
 * an authorization check. This is an ADDITIONAL access path alongside the
 * existing rules-governed direct reads in storage.rules - it does not replace
 * them, and it authorizes to EXACTLY the same rule each file class already
 * has (so it can never grant more access than a direct read already would).
 */
const SIGNED_URL_TTL_MS = 10 * 60 * 1000;

type FileClass = "candidatePhoto" | "organizationLogo" | "profileAvatar";
const FILE_CLASSES: FileClass[] = ["candidatePhoto", "organizationLogo", "profileAvatar"];

/** Mirrors the candidate-photo READ expression in storage.rules exactly. */
export function canReadCandidatePhoto(
  role: string,
  eventStatus: string,
  organizationStatus: string,
): boolean {
  if (role === "owner" || role === "admin") return true;
  return ["pending", "verified", "active"].includes(organizationStatus)
    && eventStatus !== "DRAFT";
}

interface SignedUrlRequest {
  fileClass: FileClass;
  organizationId?: string;
  eventId?: string;
  candidateId?: string;
  targetUid?: string;
}

export const getSignedDownloadUrl = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  await requireNotRevoked(request);

  const data = (request.data || {}) as SignedUrlRequest;
  if (!FILE_CLASSES.includes(data.fileClass)) {
    throw new HttpsError("invalid-argument", "A valid fileClass is required.");
  }

  const db = getFirestore();
  const bucket = getStorage().bucket();
  let filePath: string;

  if (data.fileClass === "candidatePhoto") {
    const { organizationId, eventId, candidateId } = data;
    if (!organizationId || !eventId || !candidateId) {
      throw new HttpsError("invalid-argument", "organizationId, eventId and candidateId are required.");
    }

    const { role } = await requireActiveMembership(db, organizationId, uid);

    // Resource-ownership check: confirm the candidate actually belongs to
    // this organization and event before signing a URL for it, rather than
    // trusting client-supplied IDs to build the path blind.
    const candidateSnap = await db.collection("candidates").doc(candidateId).get();
    const candidateData = candidateSnap.data();
    if (!candidateSnap.exists || candidateData?.organizationId !== organizationId || candidateData?.votingEventId !== eventId) {
      throw new HttpsError("not-found", "Candidate not found in this organization/event.");
    }

    const [eventSnap, organizationSnap] = await Promise.all([
      db.collection("votingEvents").doc(eventId).get(),
      db.collection("organizations").doc(organizationId).get(),
    ]);
    const eventData = eventSnap.data();
    const organizationStatus = organizationSnap.data()?.status;
    if (!eventSnap.exists || eventData?.organizationId !== organizationId ||
        typeof eventData.status !== "string" || typeof organizationStatus !== "string") {
      throw new HttpsError("not-found", "Candidate event not found.");
    }
    if (!canReadCandidatePhoto(role, eventData.status, organizationStatus)) {
      throw new HttpsError("permission-denied", "Candidate photos are not available for this event.");
    }

    filePath = `organizations/${organizationId}/events/${eventId}/candidates/${candidateId}/photo.jpg`;
  } else if (data.fileClass === "organizationLogo") {
    const { organizationId } = data;
    if (!organizationId) {
      throw new HttpsError("invalid-argument", "organizationId is required.");
    }

    // Matches storage.rules organizations/{orgId}/logo: any active member.
    await requireActiveMembership(db, organizationId, uid);

    const [files] = await bucket.getFiles({ prefix: `organizations/${organizationId}/logo/` });
    if (files.length === 0) {
      throw new HttpsError("not-found", "This organization has no logo uploaded.");
    }
    filePath = files[0].name;
  } else {
    // profileAvatar - matches storage.rules users/{uid}/profile: any signed-in
    // user may read profile avatars (used in organization member directories).
    const targetUid = typeof data.targetUid === "string" && data.targetUid.trim() ? data.targetUid.trim() : uid;
    const [files] = await bucket.getFiles({ prefix: `users/${targetUid}/profile/` });
    if (files.length === 0) {
      throw new HttpsError("not-found", "This user has no profile photo uploaded.");
    }
    filePath = files[0].name;
  }

  const expiresAt = Date.now() + SIGNED_URL_TTL_MS;
  let url: string;
  try {
    [url] = await bucket.file(filePath).getSignedUrl({
      version: "v4",
      action: "read",
      expires: expiresAt,
    });
  } catch (error) {
    // Never include the error payload verbatim - it can echo the requested
    // path/credentials context. Log server-side only, without the URL itself
    // (the URL is a bearer credential and must never be logged or persisted).
    console.error("getSignedDownloadUrl: failed to sign URL", { fileClass: data.fileClass });
    throw new HttpsError("internal", "Could not generate a download link. Please try again.");
  }

  return { url, expiresAt };
});
