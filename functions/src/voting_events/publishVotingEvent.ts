import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue, Timestamp } from "firebase-admin/firestore";
import {
  CALLABLE_OPTIONS, EVENT_STATUS,
  assertDepartmentsInOrg, enforceRateLimit, failWith, loadEventAsAdmin, readEligibilityConfig,
  requireAuth, requireId, resolveEligibleUserIds, writeActivationDocs, writeAudit,
} from "./votingCommon";
import { requireNotRevoked, requireRecentAuthentication, requireMfaEnrolled } from "../utils/authorization";

export const publishVotingEvent = onCall(CALLABLE_OPTIONS, async (request) => {
  const uid = requireAuth(request);
  const eventId = requireId((request.data || {}).eventId, "eventId");

  // FR-10 / MFA-REQ-001: publishing a voting event is a sensitive operation.
  // TOTP enrollment UI ships in lib/core/widgets/totp_enroll_dialog.dart.
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);
  await requireMfaEnrolled(uid);

  const db = getFirestore();
  await enforceRateLimit(db, uid, "publishVotingEvent");

  try {
    await db.runTransaction(async (tx) => {
      const { ref: eventRef, data: ev, organizationId } =
        await loadEventAsAdmin(tx, db, eventId, uid, "publish voting events");

      if (ev.status !== EVENT_STATUS.DRAFT) {
        throw new HttpsError("failed-precondition", `Only DRAFT events can be published. Current status: '${ev.status}'`);
      }

      // ---- Eligibility re-validation (departments AND members) ----
      const eligSnap = await tx.get(db.collection("votingEventEligibility").doc(eventId));
      const cfg = readEligibilityConfig(eligSnap, ev);

      if (ev.eligibilityType === "SELECTED_DEPARTMENTS") {
        if (cfg.departmentIds.length === 0) {
          throw new HttpsError("failed-precondition", "SELECTED_DEPARTMENTS requires at least one eligible department.");
        }
        await assertDepartmentsInOrg(tx, db, organizationId, cfg.departmentIds, "failed-precondition");
      } else if (ev.eligibilityType === "SELECTED_MEMBERS" && cfg.userIds.length === 0) {
        throw new HttpsError("failed-precondition", "SELECTED_MEMBERS requires at least one eligible member.");
      }

      // Members removed since drafting are dropped here; at least one voter must remain.
      const eligibleNow = await resolveEligibleUserIds(tx, db, organizationId, ev.eligibilityType, cfg);
      if (eligibleNow.length === 0) {
        throw new HttpsError("failed-precondition", "The event has no eligible voters.");
      }

      // ---- Candidate / option completeness ----
      if (ev.votingType === "CANDIDATE_ELECTION") {
        const snap = await tx.get(
          db.collection("candidates")
            .where("organizationId", "==", organizationId)
            .where("votingEventId", "==", eventId)
        );
        const valid = snap.docs.filter((d) => {
          const c = d.data();
          const nameOk = typeof c.name === "string" && c.name.trim().length >= 2;
          const photoOk = c.photoPath === null || c.photoPath === undefined || typeof c.photoPath === "string";
          return nameOk && photoOk;
        }).length;
        if (valid < 2) {
          throw new HttpsError("failed-precondition",
            `A candidate election requires at least 2 valid candidates before publishing. Current valid count: ${valid}`);
        }
      } else if (ev.votingType === "SINGLE_CHOICE_POLL") {
        const snap = await tx.get(
          db.collection("pollOptions")
            .where("organizationId", "==", organizationId)
            .where("votingEventId", "==", eventId)
        );
        const valid = snap.docs.filter((d) => {
          const o = d.data();
          return typeof o.label === "string" && o.label.trim().length >= 1 &&
            typeof o.sortOrder === "number" && o.sortOrder >= 0;
        }).length;
        if (valid < 2) {
          throw new HttpsError("failed-precondition",
            `A single-choice poll requires at least 2 valid poll options before publishing. Current valid count: ${valid}`);
        }
      } else if (ev.votingType === "YES_NO_POLL") {
        const yn = await tx.getAll(
          db.collection("pollOptions").doc(`${eventId}_YES`),
          db.collection("pollOptions").doc(`${eventId}_NO`)
        );
        if (!yn[0].exists || !yn[1].exists) {
          throw new HttpsError("failed-precondition", "The generated YES/NO options are missing for this poll.");
        }
      }

      // ---- Time window & next status (server time) ----
      const trustedNow = Timestamp.now().toMillis();
      const startMillis = ev.startAt ? ev.startAt.toMillis() : trustedNow;
      const endMillis = ev.endAt ? ev.endAt.toMillis() : trustedNow + 5 * 60 * 1000;
      if (endMillis <= trustedNow) {
        throw new HttpsError("invalid-argument", "Cannot publish event whose endAt has already passed.");
      }
      const nextStatus = startMillis > trustedNow ? EVENT_STATUS.SCHEDULED : EVENT_STATUS.ACTIVE;

      // ---- Writes ----
      if (nextStatus === EVENT_STATUS.ACTIVE) {
        tx.update(eventRef, {
          status: nextStatus,
          activatedAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
        });
        // Freeze the voter roll and create the turnout counter atomically with activation.
        writeActivationDocs(tx, db, organizationId, eventId, eligibleNow);
      } else {
        tx.update(eventRef, { status: nextStatus, updatedAt: FieldValue.serverTimestamp() });
      }

      writeAudit(tx, db, {
        organizationId,
        actorUid: uid,
        action: "PUBLISH_VOTING_EVENT",
        resourceType: "votingEvent",
        resourceId: eventId,
        metadata: {
          previousStatus: EVENT_STATUS.DRAFT,
          newStatus: nextStatus,
          startAt: ev.startAt,
          endAt: ev.endAt,
          eligibleCount: eligibleNow.length,
        },
      });
    });

    return { status: "success" };
  } catch (error) {
    failWith("publishVotingEvent", error, "Failed to publish voting event.");
  }
});
