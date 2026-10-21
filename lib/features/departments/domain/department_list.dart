import 'department.dart';

enum DepartmentSort { nameAsc, nameDesc, membersDesc }

/// Members per department id, or null when the member list is unknown (still
/// loading, failed, or not visible to this role). Unknown is never zero.
Map<String, int>? memberCountsByDepartment(List<Map<String, dynamic>>? members) {
  if (members == null) return null;
  final out = <String, int>{};
  for (final m in members) {
    final id = m['departmentId'] as String?;
    if (id == null || id.isEmpty) continue;
    out[id] = (out[id] ?? 0) + 1;
  }
  return out;
}

List<Department> filterAndSortDepartments(
  List<Department> departments, {
  required String query,
  required DepartmentSort sort,
  required Map<String, int>? counts,
}) {
  final q = query.trim().toLowerCase();
  final out = departments.where((d) {
    if (q.isEmpty) return true;
    return d.name.toLowerCase().contains(q) || d.description.toLowerCase().contains(q);
  }).toList();

  int byName(Department a, Department b) => a.name.toLowerCase().compareTo(b.name.toLowerCase());
  switch (sort) {
    case DepartmentSort.nameAsc:
      out.sort(byName);
    case DepartmentSort.nameDesc:
      out.sort((a, b) => byName(b, a));
    case DepartmentSort.membersDesc:
      // Without known counts, fall back to name order instead of faking zeros.
      if (counts == null) {
        out.sort(byName);
      } else {
        out.sort((a, b) {
          final c = (counts[b.id] ?? 0).compareTo(counts[a.id] ?? 0);
          return c != 0 ? c : byName(a, b);
        });
      }
  }
  return out;
}

String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  final p = parts[0];
  return p.substring(0, p.length >= 2 ? 2 : 1).toUpperCase();
}
