import '../../../core/utils/date_utils.dart';
import '../../../l10n/app_localizations.dart';

/// One record from `userReports` (filed from Help & support). Platform admins
/// can read these, but nothing in the backend changes their status, so a
/// report stays "open" and the UI must not offer to resolve it.
class PlatformReport {
  const PlatformReport({
    required this.id,
    required this.category,
    required this.subject,
    required this.message,
    required this.userEmail,
    required this.status,
    required this.time,
    this.receiptReference,
  });

  final String id;
  final String category;
  final String subject;
  final String message;
  final String userEmail;
  final String status;
  final DateTime? time;
  final String? receiptReference;

  factory PlatformReport.fromMap(String id, Map<String, dynamic> d) {
    String s(String k) => d[k] is String ? d[k] as String : '';
    final ref = s('receiptReference');
    return PlatformReport(
      id: id,
      category: s('category').isEmpty ? 'General feedback' : s('category'),
      subject: s('subject'),
      message: s('message'),
      userEmail: s('userEmail'),
      status: s('status').isEmpty ? 'open' : s('status'),
      time: parseFirestoreDate(d['createdAt']),
      receiptReference: ref.isEmpty ? null : ref,
    );
  }
}

/// Localized name for the four report categories the Help screen offers; any
/// other value is shown as stored.
String reportCategoryText(AppLocalizations l, String category) => switch (category) {
      'General feedback' => l.plCatGeneral,
      'Election issue' => l.plCatElection,
      'Technical problem' => l.plCatTechnical,
      'Account issue' => l.plCatAccount,
      _ => category,
    };
