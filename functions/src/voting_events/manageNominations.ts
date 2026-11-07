import { FieldValue, Firestore, getFirestore, Timestamp, Transaction } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { createHash } from "crypto";
import { requireActiveMembership, requireNotRevoked, requireOperationalOrganization } from "../utils/authorization";
import { parseContests } from "../utils/multiContest";
import { CALLABLE_OPTIONS, enforceRateLimit, optionalString, parseMillis, rejectUnknownKeys, requireAuth, requireId, requiredString, writeAudit } from "./votingCommon";

async function requireActiveAccount(tx: Transaction, db: Firestore, uid: string) {
  const profile = await tx.get(db.collection("users").doc(uid));
  if (!profile.exists || profile.data()?.status !== "active") throw new HttpsError("permission-denied", "An active account is required.");
}

/** Called inside the publishing transaction, before any activation writes. */
export async function assertNominationsResolved(tx: Transaction, db: Firestore, eventId: string, ev: FirebaseFirestore.DocumentData) {
  if (!ev.nominationRoundIds?.length) return;
  for (const roundId of ev.nominationRoundIds as string[]) {
    const round = await tx.get(db.collection("nominationRounds").doc(roundId));
    if (!round.exists || round.data()?.organizationId !== ev.organizationId || round.data()?.votingEventId !== eventId || round.data()?.status !== "CLOSED") {
      throw new HttpsError("failed-precondition", "Close every nomination round before publishing.");
    }
    const pending = await tx.get(db.collection("nominationApplications").where("roundId", "==", roundId).where("status", "==", "SUBMITTED").limit(1));
    if (!pending.empty) throw new HttpsError("failed-precondition", "Review or withdraw all pending nominations before publishing.");
    const approved = await tx.get(db.collection("nominationApplications").where("roundId", "==", roundId).where("status", "==", "APPROVED"));
    for (const application of approved.docs) {
      const a = application.data();
      await requireActiveAccount(tx, db, a.userId);
      await requireActiveMembership(db, ev.organizationId, a.userId, undefined, { tx });
      if (ev.ballotMode === "MULTI_CONTEST") {
        const choice = parseContests(ev.contests).find(c => c.id === round.data()?.contestId)?.choices.find(c => c.id === a.candidateId);
        if (!choice || choice.label !== a.name || choice.description !== a.statement) throw new HttpsError("failed-precondition", "An approved nomination no longer matches the ballot. Withdraw it or restore its approved details.");
      } else {
        const candidate = await tx.get(db.collection("candidates").doc(a.candidateId));
        const c = candidate.data();
        if (!candidate.exists || c?.votingEventId !== eventId || c.organizationId !== ev.organizationId || c.name !== a.name || c.bio !== a.statement) {
          throw new HttpsError("failed-precondition", "An approved nomination no longer matches the ballot. Withdraw it or restore its approved details.");
        }
      }
    }
  }
}

export const manageNominations = onCall(CALLABLE_OPTIONS, async request => {
  const uid = requireAuth(request);
  await requireNotRevoked(request);
  const d = request.data || {};
  const action = d.action;
  if (!["create", "close", "submit", "withdraw", "review"].includes(action)) throw new HttpsError("invalid-argument", "Unsupported nomination action.");
  const allowed: Record<string, string[]> = {
    create: ["action", "eventId", "contestId", "closesAt"], close: ["action", "roundId"],
    submit: ["action", "roundId", "name", "statement", "consent"], withdraw: ["action", "roundId"],
    review: ["action", "roundId", "applicationId", "decision", "reason"],
  };
  rejectUnknownKeys(d, allowed[action], "manageNominations");
  const db = getFirestore();
  await enforceRateLimit(db, uid, "manageNominations");
  const newRound = db.collection("nominationRounds").doc();
  const newCandidate = db.collection("candidates").doc();
  return db.runTransaction(async tx => {
    // Reading the profile inside this transaction also serializes against account deletion.
    await requireActiveAccount(tx, db, uid);
    const roundRef = action === "create" ? newRound : db.collection("nominationRounds").doc(requireId(d.roundId, "roundId"));
    const roundSnap = action === "create" ? null : await tx.get(roundRef);
    if (roundSnap && !roundSnap.exists) throw new HttpsError("not-found", "Nomination round not found.");
    const round = roundSnap?.data();
    const eventId = action === "create" ? requireId(d.eventId, "eventId") : round!.votingEventId;
    const eventRef = db.collection("votingEvents").doc(eventId);
    const eventSnap = await tx.get(eventRef);
    const ev = eventSnap.data();
    if (!eventSnap.exists || !ev || (round && ev.organizationId !== round.organizationId)) throw new HttpsError("not-found", "Election not found.");
    const organizationId = ev.organizationId as string;
    const managerAction = ["create", "close", "review"].includes(action);
    await requireActiveMembership(db, organizationId, uid, managerAction ? ["owner", "admin"] : undefined, { tx });
    await requireOperationalOrganization(db, organizationId, tx);
    if (ev.status !== "DRAFT" || ev.votingType !== "CANDIDATE_ELECTION") throw new HttpsError("failed-precondition", "Nominations can only change for a draft candidate election.");
    const now = Date.now();
    const stamp = FieldValue.serverTimestamp();
    let applicationId: string | undefined;
    if (action === "create") {
      const closes = parseMillis(d.closesAt, "closesAt");
      if (closes <= now || closes > ev.startAt.toMillis()) throw new HttpsError("invalid-argument", "Nominations must close in the future and no later than the election starts.");
      const contestId = ev.ballotMode === "MULTI_CONTEST" ? requireId(d.contestId, "contestId") : null;
      const contest = ev.ballotMode === "MULTI_CONTEST" ? parseContests(ev.contests).find(c => c.id === contestId) : null;
      if (ev.ballotMode === "MULTI_CONTEST" && !contest) throw new HttpsError("invalid-argument", "Choose a configured contest.");
      if (contestId === null && d.contestId != null) throw new HttpsError("invalid-argument", "This election has no separate contests.");
      const existing = await tx.get(db.collection("nominationRounds").where("votingEventId", "==", eventId));
      if (existing.size >= 10 || existing.docs.some(r => r.data().contestId === contestId)) throw new HttpsError("already-exists", "A nomination round already exists for this ballot.");
      tx.create(roundRef, { organizationId, votingEventId: eventId, eventTitle: ev.title, contestId,
        contestTitle: contest?.title ?? null, status: "OPEN", closesAt: Timestamp.fromMillis(closes), createdAt: stamp, createdBy: uid });
      tx.update(eventRef, { nominationRoundIds: FieldValue.arrayUnion(roundRef.id), updatedAt: stamp });
    } else if (action === "close") {
      if (round!.status !== "OPEN") throw new HttpsError("failed-precondition", "This round is already closed.");
      tx.update(roundRef, { status: "CLOSED", closedAt: stamp, closedBy: uid });
      tx.update(eventRef, { updatedAt: stamp });
    } else {
      applicationId = action === "review" ? requireId(d.applicationId, "applicationId")
        : createHash("sha256").update(JSON.stringify([roundRef.id, uid])).digest("hex");
      const applicationRef = db.collection("nominationApplications").doc(applicationId);
      const appSnap = await tx.get(applicationRef);
      const app = appSnap.data();
      if (app && (app.roundId !== roundRef.id || app.organizationId !== organizationId || app.votingEventId !== eventId)) throw new HttpsError("permission-denied", "Application belongs to another round.");
      if (action === "submit") {
        if (round!.status !== "OPEN" || round!.closesAt.toMillis() <= now) throw new HttpsError("failed-precondition", "Nominations are closed.");
        if (appSnap.exists && app?.status !== "WITHDRAWN") throw new HttpsError("already-exists", "You already applied to this round.");
        if (d.consent !== true) throw new HttpsError("invalid-argument", "Explicit candidate consent is required.");
        const name = requiredString(d.name, "Public candidate name", 2, 100);
        const statement = optionalString(d.statement, "Public candidate statement", 500, { multiline: true });
        tx.set(applicationRef, { organizationId, votingEventId: eventId, roundId: roundRef.id, userId: uid,
          name, statement, consent: true, consentAt: stamp, status: "SUBMITTED", submittedAt: stamp, updatedAt: stamp });
      } else {
        if (!app) throw new HttpsError("not-found", "Application not found.");
        if (action === "withdraw" && app.userId !== uid) throw new HttpsError("permission-denied", "You can only withdraw your own application.");
        if (action === "review" && (round!.status !== "CLOSED" || !["SUBMITTED", "APPROVED"].includes(app.status))) throw new HttpsError("failed-precondition", "Close the round before reviewing an application.");
        if (action === "withdraw" && !["SUBMITTED", "APPROVED"].includes(app.status)) throw new HttpsError("failed-precondition", "This application cannot be withdrawn.");
        if (action === "review" && app.userId === uid) throw new HttpsError("permission-denied", "You cannot review your own nomination application.");
        const approval = action === "review" && d.decision === "APPROVED";
        if (approval && app.status !== "SUBMITTED") throw new HttpsError("failed-precondition", "This candidate is already approved.");
        const reason = action === "review" ? optionalString(d.reason, "Review reason", 500) : "";
        if (action === "review" && !["APPROVED", "REJECTED"].includes(d.decision)) throw new HttpsError("invalid-argument", "Choose approve or reject.");
        if (action === "review" && !approval && !reason) throw new HttpsError("invalid-argument", "Give a reason for rejection.");
        if (approval) {
          await requireActiveAccount(tx, db, app.userId);
          await requireActiveMembership(db, organizationId, app.userId, undefined, { tx });
        }
        let contests;
        if (approval || app.status === "APPROVED") {
          if (ev.ballotMode === "MULTI_CONTEST") {
            contests = parseContests(ev.contests);
            const target = contests.find(c => c.id === round!.contestId);
            if (!target) throw new HttpsError("failed-precondition", "The nomination contest was removed.");
            if (approval) {
              if (target.choices.length >= 20) throw new HttpsError("resource-exhausted", "A contest supports at most 20 choices.");
              if (target.choices.some(c => c.label.toLowerCase() === app.name.toLowerCase())) throw new HttpsError("already-exists", "A candidate with that name is already on this ballot.");
              target.choices.push({ id: newCandidate.id, label: app.name, description: app.statement });
            } else target.choices = target.choices.filter(c => c.id !== app.candidateId);
          } else if (approval) {
            const candidates = await tx.get(db.collection("candidates").where("votingEventId", "==", eventId));
            if (candidates.size >= 100) throw new HttpsError("resource-exhausted", "An election supports at most 100 candidates.");
            if (candidates.docs.some(c => String(c.data().name).toLowerCase() === app.name.toLowerCase())) throw new HttpsError("already-exists", "A candidate with that name is already on this ballot.");
          }
        }
        // All reads precede writes. Every change touches the event to serialize against publishing.
        if (contests) tx.update(eventRef, { contests, updatedAt: stamp });
        else if (approval) tx.create(newCandidate, { id: newCandidate.id, organizationId, votingEventId: eventId,
          name: app.name, bio: app.statement, position: "", party: "", displayOrder: 0, photoPath: null, createdBy: uid, createdAt: stamp, updatedAt: stamp });
        else if (app.status === "APPROVED") tx.delete(db.collection("candidates").doc(app.candidateId));
        tx.update(applicationRef, { status: action === "withdraw" ? "WITHDRAWN" : d.decision,
          ...(approval ? { candidateId: newCandidate.id } : {}), reason, updatedAt: stamp,
          ...(action === "review" ? { reviewedBy: uid, reviewedAt: stamp } : {}) });
      }
      tx.update(eventRef, { updatedAt: stamp });
    }
    writeAudit(tx, db, { organizationId, actorUid: uid, action: `NOMINATION_${action.toUpperCase()}`, resourceType: "nominationRound", resourceId: roundRef.id, metadata: { votingEventId: eventId } });
    return { status: "success", roundId: roundRef.id, ...(applicationId ? { applicationId } : {}) };
  });
});
