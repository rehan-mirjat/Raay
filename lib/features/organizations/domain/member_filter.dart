enum MemberFilter { all, managers, members, notActive }

/// Anything other than an explicit "active" is not active. A missing status is
/// treated as active (the directory's historical default).
bool memberIsActive(Map<String, dynamic> m) =>
    ((m['status'] as String?) ?? 'active').toLowerCase() == 'active';

String memberRole(Map<String, dynamic> m) =>
    ((m['role'] as String?) ?? 'member').toLowerCase();

List<Map<String, dynamic>> filterMembers(
  List<Map<String, dynamic>> members, {
  required String query,
  required MemberFilter filter,
}) {
  final q = query.trim().toLowerCase();
  return members.where((m) {
    if (q.isNotEmpty) {
      final name = ((m['displayName'] as String?) ?? '').toLowerCase();
      final email = ((m['email'] as String?) ?? '').toLowerCase();
      if (!name.contains(q) && !email.contains(q)) return false;
    }
    final role = memberRole(m);
    return switch (filter) {
      MemberFilter.all => true,
      MemberFilter.managers => role == 'owner' || role == 'admin',
      MemberFilter.members => role == 'member',
      MemberFilter.notActive => !memberIsActive(m),
    };
  }).toList();
}
