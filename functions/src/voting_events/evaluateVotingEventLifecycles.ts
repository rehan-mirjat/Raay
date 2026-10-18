import { onSchedule } from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import { getFirestore, FieldValue, Timestamp, Firestore, Transaction, DocumentData, DocumentReference } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";
import {
  EVENT_STATUS, OPERATIONAL_ORG_STATUSES, SYSTEM_ACTOR,
  readEligibilityConfig, resolveEligibleUserIds, writeActivationDocs, writeAudit,
} from "./votingCommon";

const MAX_EVENTS_PER_RUN = 200;

/**
 * Server-controlled lifecycle evaluator.
 *   SCHEDULED -> ACTIVE     (startAt <= now, org operational, >= 1 eligible voter)
 *   SCHEDULED -> CANCELLED  (window already elapsed, or no eligible voters)
 *   ACTIVE    -> CLOSED     (endAt <= now)
 *
 * REQUIRES composite indexes: votingEvents(status ASC, startAt ASC) and (status ASC, endAt ASC).
 * See firestore.indexes.json.
 */
export const evaluateVotingEventLifecycles = onSchedule(
  { schedule: "every 1 minutes", timeoutSeconds: 120 },
  async () => {
    const db = getFirestore();
    const trustedNow = Timestamp.now();
    const counts = { activated: 0, cancelled: 0, closed: 0, failed: 0 };

    const scheduled = await db.collection("votingEvents")
      .where("status", "==", EVENT_STATUS.SCHEDULED)
      .where("startAt", "<=", trustedNow)
      .limit(MAX_EVENTS_PER_RUN)
      .get();

    const activateResults = await Promise.allSettled(
      scheduled.docs.map((doc) => db.runTransaction((tx) => activateOrCancel(tx, db, doc.ref, trustedNow))
        .then((outcome) => ({ docId: doc.id, outcome }))
      )
    );
    for (const result of activateResults) {
      if (result.status === "fulfilled") {
        if (result.value.outcome === "activated") counts.activated++;
        else if (result.value.outcome === "cancelled") counts.cancelled++;
      } else {
        counts.failed++;
        logger.error("Failed to activate event", { error: result.reason });
      }
    }

    const active = await db.collection("votingEvents")
      .where("status", "==", EVENT_STATUS.ACTIVE)
      .where("endAt", "<=", trustedNow)
      .limit(MAX_EVENTS_PER_RUN)
      .get();

    const closeResults = await Promise.allSettled(
      active.docs.map((doc) => db.runTransaction((tx) => closeIfDue(tx, db, doc.ref))
        .then((closed) => ({ docId: doc.id, closed }))
      )
    );
    for (const result of closeResults) {
      if (result.status === "fulfilled") {
        if (result.value.closed) counts.closed++;
      } else {
        counts.failed++;
        logger.error("Failed to close event", { error: result.reason });
      }
    }

    // Counters are tallied from transaction RESULTS, so transaction retries cannot double count.
    logger.info("Voting event lifecycle evaluation completed.", counts);
  }
);

type Outcome = "activated" | "cancelled" | "skipped";

async function activateOrCancel(
  tx: Transaction,
  db: Firestore,
  ref: DocumentReference,
  now: Timestamp
): Promise<Outcome> {
  // ---------- reads ----------
  const snap = await tx.get(ref);
  const ev = snap.data() as DocumentData | undefined;
  if (!snap.exists || !ev || ev.status !== EVENT_STATUS.SCHEDULED) return "skipped";

  const organizationId = ev.organizationId as string | undefined;
  if (!organizationId) return "skipped";

  const orgSnap = await tx.get(db.collection("organizations").doc(organizationId));
  const operational = orgSnap.exists && OPERATIONAL_ORG_STATUSES.includes(orgSnap.data()?.status);
  const endMillis: number = ev.endAt?.toMillis?.() ?? 0;

  let cancelReason: string | null = null;
  let eligible: string[] = [];

  if (endMillis <= now.toMillis()) {
    cancelReason = "Voting window elapsed before activation.";
  } else if (!operational) {
    // Suspended organization: stay SCHEDULED so it can still start after reactivation.
    return "skipped";
  } else {
    const eligSnap = await tx.get(db.collection("votingEventEligibility").doc(ref.id));
    const cfg = readEligibilityConfig(eligSnap, ev);
    try {
      eligible = await resolveEligibleUserIds(tx, db, organizationId, ev.eligibilityType, cfg);
      if (eligible.length === 0) cancelReason = "No eligible voters at activation.";
    } catch (e) {
      if (e instanceof HttpsError) cancelReason = e.message;
      else throw e;
    }
  }

  // ---------- writes ----------
  if (cancelReason) {
    tx.update(ref, {
      status: EVENT_STATUS.CANCELLED,
      cancelledAt: FieldValue.serverTimestamp(),
      cancelledBy: SYSTEM_ACTOR,
      cancelReason,
      updatedAt: FieldValue.serverTimestamp(),
    });
    writeAudit(tx, db, {
      organizationId,
      actorUid: SYSTEM_ACTOR,
      action: "CANCEL_VOTING_EVENT",
      resourceType: "votingEvent",
      resourceId: ref.id,
      metadata: { previousStatus: EVENT_STATUS.SCHEDULED, newStatus: EVENT_STATUS.CANCELLED, reason: cancelReason },
    });
    return "cancelled";
  }

  tx.update(ref, {
    status: EVENT_STATUS.ACTIVE,
    activatedAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });
  writeActivationDocs(tx, db, organizationId, ref.id, eligible); // frozen voter roll + turnout counter
  writeAudit(tx, db, {
    organizationId,
    actorUid: SYSTEM_ACTOR,
    action: "ACTIVATE_VOTING_EVENT",
    resourceType: "votingEvent",
    resourceId: ref.id,
    metadata: {
      previousStatus: EVENT_STATUS.SCHEDULED,
      newStatus: EVENT_STATUS.ACTIVE,
      eligibleCount: eligible.length,
      reason: "Automatic schedule start",
    },
  });
  return "activated";
}

async function closeIfDue(tx: Transaction, db: Firestore, ref: DocumentReference): Promise<boolean> {
  const snap = await tx.get(ref);
  const ev = snap.data();
  if (!snap.exists || !ev || ev.status !== EVENT_STATUS.ACTIVE) return false;

  tx.update(ref, {
    status: EVENT_STATUS.CLOSED,
    closedAt: FieldValue.serverTimestamp(),
    closedBy: SYSTEM_ACTOR,
    updatedAt: FieldValue.serverTimestamp(),
  });
  writeAudit(tx, db, {
    organizationId: ev.organizationId,
    actorUid: SYSTEM_ACTOR,
    action: "CLOSE_VOTING_EVENT",
    resourceType: "votingEvent",
    resourceId: ref.id,
    metadata: {
      previousStatus: EVENT_STATUS.ACTIVE,
      newStatus: EVENT_STATUS.CLOSED,
      reason: "Automatic schedule completion",
    },
  });
  return true;
}
