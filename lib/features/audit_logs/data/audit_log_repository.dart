import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/firebase_service.dart';
import '../domain/audit_log.dart';

class AuditLogRepository {
  final FirebaseFirestore _firestore;

  AuditLogRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseService().firestore;

  Stream<List<AuditLog>> watchOrganizationAuditLogs(String organizationId, {int limit = 50}) {
    return _firestore
        .collection('auditLogs')
        .where('organizationId', isEqualTo: organizationId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AuditLog.fromFirestore(doc)).toList());
  }

  Stream<List<AuditLog>> watchPlatformAuditLogs({int limit = 100}) {
    return _firestore
        .collection('platformAuditLogs')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AuditLog.fromFirestore(doc)).toList());
  }
}

final auditLogRepositoryProvider = Provider<AuditLogRepository>((ref) {
  return AuditLogRepository();
});

final organizationAuditLogsStreamProvider =
    StreamProvider.family<List<AuditLog>, String>((ref, organizationId) {
  return ref
      .watch(auditLogRepositoryProvider)
      .watchOrganizationAuditLogs(organizationId);
});

final platformAuditLogsStreamProvider = StreamProvider<List<AuditLog>>((ref) {
  return ref.watch(auditLogRepositoryProvider).watchPlatformAuditLogs();
});
