import '../../features/organizations/domain/organization_enums.dart';

/// Which membership a route needs. One table instead of checks scattered
/// across screens; screens keep their own checks as a second layer and the
/// backend remains the real enforcement.
enum RouteNeed { ownerOnly, manager }

/// Longest-prefix rules. Paths not listed here need no organization role.
const _rules = <(String, RouteNeed)>[
  ('/orgs/settings', RouteNeed.ownerOnly),
  ('/plans/legacy', RouteNeed.ownerOnly),
  ('/orgs/dashboard', RouteNeed.manager),
  ('/orgs/members', RouteNeed.manager),
  ('/orgs/departments', RouteNeed.manager),
  ('/orgs/audit', RouteNeed.manager),
  ('/orgs/reports', RouteNeed.manager),
  ('/orgs/joining-codes', RouteNeed.manager),
  ('/communications', RouteNeed.manager),
  ('/admin', RouteNeed.manager),
];

/// Patterns for routes whose guarded segment is not a fixed prefix
/// (e.g. `/elections/<id>/approvals`).
final _patternRules = <(RegExp, RouteNeed)>[
  (RegExp(r'^/elections/[^/]+/approvals(/|$)'), RouteNeed.manager),
];

RouteNeed? routeNeed(String location) {
  final path = location.split('?').first;
  for (final (pattern, need) in _patternRules) {
    if (pattern.hasMatch(path)) return need;
  }
  RouteNeed? best;
  var bestLen = -1;
  for (final (prefix, need) in _rules) {
    final hit = location == prefix || location.startsWith('$prefix/');
    if (hit && prefix.length > bestLen) {
      best = need;
      bestLen = prefix.length;
    }
  }
  return best;
}

/// Whether [role] (the ACTIVE membership role in the selected organization,
/// null when there is none or it is not active) may open [location].
bool roleMayOpen(String location, OrganizationRole? role) {
  final need = routeNeed(location);
  if (need == null) return true;
  return switch (need) {
    RouteNeed.ownerOnly => role == OrganizationRole.owner,
    RouteNeed.manager =>
      role == OrganizationRole.owner || role == OrganizationRole.admin,
  };
}
