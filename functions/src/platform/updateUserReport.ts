import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

type ReportAction = "ASSIGN_TO_ME" | "RESOLVE" | "REOPEN";

/** Platform-admin report triage. Report content is never copied into the audit log. */
export const updateUserReport = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication is required.");
  if (request.auth?.token.platformAdmin !== true) {
    throw new HttpsError("permission-denied", "Platform administrator access required.");
  }

  const reportId = typeof request.data?.reportId === "string"
    ? request.data.reportId.trim()
    : "";
  const action = request.data?.action as ReportAction;
  if (!reportId || reportId.length > 150 || reportId.includes("/") ||
      !["ASSIGN_TO_ME", "RESOLVE", "REOPEN"].includes(action)) {
    throw new HttpsError("invalid-argument", "Report and a valid action are required.");
  }

  const db = getFirestore();
  const reportRef = db.collection("userReports").doc(reportId);
  const auditRef = db.collection("platformAuditLogs").doc();
  try {
    await db.runTransaction(async (transaction) => {
      const report = await transaction.get(reportRef);
      if (!report.exists) throw new HttpsError("not-found", "Report not found.");

      const previousStatus = report.data()?.status as string;
      let nextStatus: string;
      let assignment: Record<string, unknown> = {};
      if (action === "ASSIGN_TO_ME") {
        if (!["open", "in_progress"].includes(previousStatus)) {
          throw new HttpsError("failed-precondition", "Only open reports can be assigned.");
        }
        nextStatus = "in_progress";
        assignment = { assignedToUid: uid, assignedAt: FieldValue.serverTimestamp() };
      } else if (action === "RESOLVE") {
        if (!["open", "in_progress"].includes(previousStatus)) {
          throw new HttpsError("failed-precondition", "Only active reports can be resolved.");
        }
        nextStatus = "resolved";
        assignment = { resolvedByUid: uid, resolvedAt: FieldValue.serverTimestamp() };
      } else {
        if (previousStatus !== "resolved") {
          throw new HttpsError("failed-precondition", "Only resolved reports can be reopened.");
        }
        nextStatus = "open";
        assignment = {
          assignedToUid: FieldValue.delete(),
          assignedAt: FieldValue.delete(),
          resolvedByUid: FieldValue.delete(),
          resolvedAt: FieldValue.delete(),
        };
      }

      transaction.update(reportRef, {
        status: nextStatus,
        updatedAt: FieldValue.serverTimestamp(),
        ...assignment,
      });
      transaction.set(auditRef, {
        actorUid: uid,
        action: `USER_REPORT_${action}`,
        resourceType: "userReport",
        resourceId: reportId,
        previousStatus,
        newStatus: nextStatus,
        timestamp: FieldValue.serverTimestamp(),
      });
    });
    return { status: "success", reportId, action };
  } catch (error) {
    if (error instanceof HttpsError) throw error;
    throw new HttpsError("internal", "Could not update report status.");
  }
});
