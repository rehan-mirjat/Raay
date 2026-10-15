import { getFirestore, FieldValue } from "firebase-admin/firestore";

export interface AuditLogEntry {
  organizationId?: string;
  actorUid: string;
  action: string;
  resourceType: string;
  resourceId: string;
  metadata?: Record<string, any>;
  ipHash?: string;
  userAgentHash?: string;
}

export async function writeAuditLog(entry: AuditLogEntry): Promise<void> {
  const db = getFirestore();
  const timestamp = FieldValue.serverTimestamp();

  const payload = {
    organizationId: entry.organizationId || "",
    actorUid: entry.actorUid || "SYSTEM",
    action: entry.action,
    resourceType: entry.resourceType,
    resourceId: entry.resourceId,
    metadata: entry.metadata || {},
    ipHash: entry.ipHash || null,
    userAgentHash: entry.userAgentHash || null,
    timestamp,
  };

  if (entry.organizationId) {
    await db.collection("auditLogs").add(payload);
  } else {
    await db.collection("platformAuditLogs").add(payload);
  }
}
