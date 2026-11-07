import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/firebase_service.dart';
import '../domain/platform_audit_entry.dart';
import '../domain/platform_report.dart';

const kPlatformPageSize = 50;

/// Live, read-only diagnostics from the platform health callable.
final platformHealthProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final response = await FirebaseService()
      .functions
      .httpsCallable('getPlatformHealth')
      .call();
  return Map<String, dynamic>.from(response.data as Map);
});

/// Aggregate counts from the `getPlatformAnalytics` callable (platform admins
/// only; the server checks the claim).
final platformAnalyticsProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final res = await FirebaseService()
      .functions
      .httpsCallable('getPlatformAnalytics')
      .call();
  return Map<String, dynamic>.from(res.data as Map);
});

/// Newest-first platform audit entries, [limit] at a time. Platform admins may
/// read this collection directly under the Firestore rules.
final platformAuditProvider = StreamProvider.autoDispose
    .family<List<PlatformAuditEntry>, int>((ref, limit) {
  return FirebaseService()
      .firestore
      .collection('platformAuditLogs')
      .orderBy('timestamp', descending: true)
      .limit(limit)
      .snapshots()
      .map((s) => s.docs
          .map((d) => PlatformAuditEntry.fromMap(d.id, d.data()))
          .toList());
});

/// Newest-first user reports, [limit] at a time.
final platformReportsProvider =
    StreamProvider.autoDispose.family<List<PlatformReport>, int>((ref, limit) {
  return FirebaseService()
      .firestore
      .collection('userReports')
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map((s) =>
          s.docs.map((d) => PlatformReport.fromMap(d.id, d.data())).toList());
});

/// Applies a server-authorized triage action; client rules do not allow report
/// status writes, so every update is checked and audited by the callable.
Future<void> updatePlatformReport(String reportId, String action) async {
  await FirebaseService().functions.httpsCallable('updateUserReport').call({
    'reportId': reportId,
    'action': action,
  });
}

typedef PlatformReportUpdater = Future<void> Function(
    String reportId, String action);

final platformReportUpdaterProvider = Provider<PlatformReportUpdater>(
  (ref) => updatePlatformReport,
);

/// How many reports are still "open". (The analytics callable counts a
/// different collection, `platformReports`, which nothing writes to.)
final openReportCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final snap = await FirebaseService()
      .firestore
      .collection('userReports')
      .where('status', isEqualTo: 'open')
      .count()
      .get();
  return snap.count ?? 0;
});

/// Names for ids shown in the audit log. Best effort: it covers the first
/// page of each list, and a failure just means ids are shown instead.
class PlatformDirectory {
  const PlatformDirectory(
      {this.orgNames = const {}, this.userNames = const {}});
  final Map<String, String> orgNames;
  final Map<String, String> userNames;

  String user(String uid) {
    if (uid == 'SYSTEM') return 'System';
    return userNames[uid] ?? shortId(uid);
  }

  String org(String id) => orgNames[id] ?? shortId(id);
}

String shortId(String id) => id.length <= 10 ? id : '${id.substring(0, 8)}…';

final platformDirectoryProvider =
    FutureProvider.autoDispose<PlatformDirectory>((ref) async {
  final functions = FirebaseService().functions;
  final orgs = <String, String>{};
  final users = <String, String>{};
  await Future.wait([
    () async {
      try {
        final r = await functions
            .httpsCallable('listOrganizationsForPlatformAdmin')
            .call();
        for (final o
            in (Map<String, dynamic>.from(r.data as Map)['organizations']
                    as List? ??
                const [])) {
          final m = Map<String, dynamic>.from(o as Map);
          orgs[m['id'] as String] = (m['name'] as String?) ?? m['id'] as String;
        }
      } catch (_) {}
    }(),
    () async {
      try {
        final r = await functions.httpsCallable('listPlatformUsers').call();
        for (final u
            in (Map<String, dynamic>.from(r.data as Map)['users'] as List? ??
                const [])) {
          final m = Map<String, dynamic>.from(u as Map);
          final name = (m['displayName'] as String?) ?? '';
          final email = (m['email'] as String?) ?? '';
          users[m['uid'] as String] = name.isNotEmpty
              ? name
              : (email.isNotEmpty ? email : m['uid'] as String);
        }
      } catch (_) {}
    }(),
  ]);
  return PlatformDirectory(orgNames: orgs, userNames: users);
});
