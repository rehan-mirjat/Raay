import '../../../core/utils/date_utils.dart';

/// One record from `platformAuditLogs`. Only actions that completed are
/// written there, so there is no "outcome" field to show: every entry is a
/// success, and failed attempts leave no record.
class PlatformAuditEntry {
  const PlatformAuditEntry({
    required this.id,
    required this.action,
    required this.actorUid,
    required this.time,
    this.targetUid,
    this.organizationId,
    this.previousStatus,
    this.newStatus,
  });

  final String id;
  final String action;
  final String actorUid;
  final DateTime? time;
  final String? targetUid;
  final String? organizationId;
  final String? previousStatus;
  final String? newStatus;

  factory PlatformAuditEntry.fromMap(String id, Map<String, dynamic> d) {
    String? str(String k) {
      final v = d[k];
      return v is String && v.isNotEmpty ? v : null;
    }

    // writeAuditLog() records the target as resourceType/resourceId instead.
    final resourceType = str('resourceType');
    final resourceId = str('resourceId');
    return PlatformAuditEntry(
      id: id,
      action: str('action') ?? 'UNKNOWN',
      actorUid: str('actorUid') ?? 'SYSTEM',
      time: parseFirestoreDate(d['timestamp']),
      targetUid:
          str('targetUid') ?? (resourceType == 'user' ? resourceId : null),
      organizationId: str('organizationId') ??
          (resourceType == 'organization' ? resourceId : null),
      previousStatus: str('previousStatus'),
      newStatus: str('newStatus'),
    );
  }

  /// Plain-language name for the action codes the backend writes. Unknown
  /// codes are shown as readable words rather than hidden.
  String get actionLabel => auditActionLabel(action);
}

String auditActionLabel(String action) {
  switch (action) {
    case 'ORGANIZATION_VERIFY':
      return 'Organization verified';
    case 'ORGANIZATION_REJECT':
      return 'Organization rejected';
    case 'ORGANIZATION_SUSPEND':
      return 'Organization suspended';
    case 'ORGANIZATION_REACTIVATE':
      return 'Organization reactivated';
    case 'PLATFORM_ADMIN_ACCESS_GRANTED':
      return 'Platform admin access granted';
    case 'PLATFORM_ADMIN_ACCESS_REMOVED':
      return 'Platform admin access removed';
  }
  final words =
      action.toLowerCase().split('_').where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return action;
  words[0] = words[0][0].toUpperCase() + words[0].substring(1);
  return words.join(' ');
}

/// Filters by exact action code and a free-text query over the names/ids the
/// screen shows (actor, target and organization).
List<PlatformAuditEntry> filterAuditEntries(
  List<PlatformAuditEntry> entries, {
  String? action,
  String query = '',
  required String Function(String uid) userName,
  required String Function(String orgId) orgName,
}) {
  final q = query.trim().toLowerCase();
  return entries.where((e) {
    if (action != null && e.action != action) return false;
    if (q.isEmpty) return true;
    final hay = [
      e.actionLabel,
      userName(e.actorUid),
      if (e.targetUid != null) userName(e.targetUid!),
      if (e.organizationId != null) orgName(e.organizationId!),
    ].join(' ').toLowerCase();
    return hay.contains(q);
  }).toList();
}
