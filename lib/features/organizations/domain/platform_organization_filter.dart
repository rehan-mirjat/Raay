import '../../../l10n/app_localizations.dart';

/// Filtering for the platform moderation list. Pure so it can be tested
/// without Firebase.
enum OrgFilter { needsReview, running, suspended, closed, all }

extension OrgFilterLabel on OrgFilter {
  String get label => switch (this) {
        OrgFilter.needsReview => 'Needs review',
        OrgFilter.running => 'Verified',
        OrgFilter.suspended => 'Suspended',
        OrgFilter.closed => 'Archived / rejected',
        OrgFilter.all => 'All',
      };

  String localized(AppLocalizations l) => switch (this) {
        OrgFilter.needsReview => l.pfNeedsReview,
        OrgFilter.running => l.pfVerified,
        OrgFilter.suspended => l.pfSuspended,
        OrgFilter.closed => l.pfClosed,
        OrgFilter.all => l.pfAll,
      };

  bool matches(String status) => switch (this) {
        OrgFilter.needsReview => status == 'pending',
        OrgFilter.running => status == 'verified' || status == 'active',
        OrgFilter.suspended => status == 'suspended',
        OrgFilter.closed => status == 'archived' || status == 'rejected',
        OrgFilter.all => true,
      };
}

String _status(Map<String, dynamic> o) => (o['status'] as String? ?? 'pending').toLowerCase();

Map<OrgFilter, int> countByFilter(List<Map<String, dynamic>> orgs) => {
      for (final f in OrgFilter.values) f: orgs.where((o) => f.matches(_status(o))).length,
    };

/// Applies [filter] and a free-text [query] (name, email, city, country), and
/// puts organizations waiting for review first so they are never buried.
List<Map<String, dynamic>> filterOrganizations(
  List<Map<String, dynamic>> orgs,
  OrgFilter filter,
  String query,
) {
  final q = query.trim().toLowerCase();
  bool hit(Map<String, dynamic> o) {
    if (!filter.matches(_status(o))) return false;
    if (q.isEmpty) return true;
    return ['name', 'email', 'city', 'country']
        .any((k) => ((o[k] as String?) ?? '').toLowerCase().contains(q));
  }

  final out = orgs.where(hit).toList();
  // Stable: pending first, everything else keeps the server order (newest first).
  final pending = out.where((o) => _status(o) == 'pending');
  final rest = out.where((o) => _status(o) != 'pending');
  return [...pending, ...rest];
}
