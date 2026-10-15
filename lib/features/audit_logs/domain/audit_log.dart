import 'package:cloud_firestore/cloud_firestore.dart';

class AuditLog {
  final String id;
  final String organizationId;
  final String actorUid;
  final String action;
  final String resourceType;
  final String resourceId;
  final Map<String, dynamic> metadata;
  final String? ipHash;
  final String? userAgentHash;
  final DateTime timestamp;

  AuditLog({
    required this.id,
    required this.organizationId,
    required this.actorUid,
    required this.action,
    required this.resourceType,
    required this.resourceId,
    required this.metadata,
    this.ipHash,
    this.userAgentHash,
    required this.timestamp,
  });

  factory AuditLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AuditLog(
      id: doc.id,
      organizationId: data['organizationId'] as String? ?? '',
      actorUid: data['actorUid'] as String? ?? '',
      action: data['action'] as String? ?? 'UNKNOWN',
      resourceType: data['resourceType'] as String? ?? '',
      resourceId: data['resourceId'] as String? ?? '',
      metadata: Map<String, dynamic>.from(data['metadata'] as Map? ?? {}),
      ipHash: data['ipHash'] as String?,
      userAgentHash: data['userAgentHash'] as String?,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'organizationId': organizationId,
      'actorUid': actorUid,
      'action': action,
      'resourceType': resourceType,
      'resourceId': resourceId,
      'metadata': metadata,
      if (ipHash != null) 'ipHash': ipHash,
      if (userAgentHash != null) 'userAgentHash': userAgentHash,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
