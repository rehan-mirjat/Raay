import 'package:flutter/material.dart';

/// Every place the shell can link to. Labels are resolved in the shell via
/// AppLocalizations so this file stays pure and testable.
enum NavId {
  myElections,
  overview,
  elections,
  people,
  departments,
  activity,
  invitations,
  organizations,
  calendar,
  observer,
  joiningCodes,
  orgSettings,
  billing,
  account,
  help,
  platform,
  platformAccounts,
  platformOverview,
  platformReports,
  platformAudit,
}

class NavDestination {
  const NavDestination(this.id, this.route, this.icon, this.iconActive,
      {this.extraPrefixes = const []});
  final NavId id;
  final String route;
  final IconData icon;
  final IconData iconActive;

  /// Other locations that belong to this destination (e.g. an election detail
  /// page highlights "Elections").
  final List<String> extraPrefixes;
}

class NavModel {
  const NavModel(
      {required this.primary, required this.secondary, required this.platform});

  /// Shown in the compact bottom bar (max 4), the rail and the sidebar.
  final List<NavDestination> primary;

  /// Sidebar group "More" / rail overflow / compact "More" sheet.
  final List<NavDestination> secondary;

  /// Separate platform-admin group; empty for everyone else.
  final List<NavDestination> platform;

  List<NavDestination> get all => [...primary, ...secondary, ...platform];
}

const _myElections = NavDestination(NavId.myElections, '/home',
    Icons.how_to_vote_outlined, Icons.how_to_vote_rounded,
    extraPrefixes: ['/elections']);
const _overview = NavDestination(
    NavId.overview, '/home', Icons.dashboard_outlined, Icons.dashboard_rounded);
const _elections = NavDestination(NavId.elections, '/admin/events',
    Icons.how_to_vote_outlined, Icons.how_to_vote_rounded,
    extraPrefixes: ['/elections', '/admin/command-center']);
const _people = NavDestination(
    NavId.people, '/orgs/members', Icons.groups_outlined, Icons.groups_rounded);
const _departments = NavDestination(NavId.departments, '/orgs/departments',
    Icons.apartment_outlined, Icons.apartment_rounded);
const _activityAdmin = NavDestination(NavId.activity, '/orgs/audit',
    Icons.history_outlined, Icons.history_rounded);
const _invitations = NavDestination(NavId.invitations, '/orgs/invitations',
    Icons.notifications_none_rounded, Icons.notifications_rounded);
const _organizations = NavDestination(NavId.organizations, '/orgs',
    Icons.business_outlined, Icons.business_rounded);
const _calendar = NavDestination(NavId.calendar, '/calendar',
    Icons.calendar_month_outlined, Icons.calendar_month_rounded);
const _observer = NavDestination(NavId.observer, '/observer',
    Icons.visibility_outlined, Icons.visibility_rounded);
const _orgSettings = NavDestination(NavId.orgSettings, '/orgs/settings',
    Icons.tune_outlined, Icons.tune_rounded);
const _billing = NavDestination(NavId.billing, '/plans',
    Icons.credit_card_outlined, Icons.credit_card_rounded);
const _account = NavDestination(NavId.account, '/settings',
    Icons.person_outline_rounded, Icons.person_rounded);
const _help = NavDestination(
    NavId.help, '/help', Icons.help_outline_rounded, Icons.help_rounded);
const _joiningCodes = NavDestination(NavId.joiningCodes, '/orgs/joining-codes',
    Icons.qr_code_2_outlined, Icons.qr_code_2_rounded);
const _platformOverview = NavDestination(NavId.platformOverview, '/platform',
    Icons.space_dashboard_outlined, Icons.space_dashboard_rounded);
const _platform = NavDestination(NavId.platform, '/platform/organizations',
    Icons.domain_outlined, Icons.domain_rounded);
const _platformAccounts = NavDestination(
    NavId.platformAccounts,
    '/platform/admin',
    Icons.admin_panel_settings_outlined,
    Icons.admin_panel_settings_rounded);
const _platformReports = NavDestination(NavId.platformReports, '/platform/reports',
    Icons.flag_outlined, Icons.flag_rounded);
const _platformAudit = NavDestination(NavId.platformAudit, '/platform/audit',
    Icons.fact_check_outlined, Icons.fact_check_rounded);

/// Role-based information architecture. Uses the membership role plus the
/// existing observer capability; no new role enum.
NavModel navModelFor({
  required bool isManager,
  required bool isOwner,
  required bool isObserver,
  bool isPlatformAdmin = false,
}) {
  final platform = isPlatformAdmin
      ? const [
          _platformOverview,
          _platform,
          _platformAccounts,
          _platformReports,
          _platformAudit,
        ]
      : const <NavDestination>[];
  if (isManager) {
    return NavModel(
      primary: const [_overview, _elections, _people, _activityAdmin],
      secondary: [
        _departments,
        _joiningCodes,
        _calendar,
        _organizations,
        if (isObserver) _observer,
        if (isOwner) _orgSettings,
        if (isOwner) _billing,
        _account,
        _help,
      ],
      platform: platform,
    );
  }
  return NavModel(
    // Same order as the design reference: elections, organizations, invitations
    // and calendar in the bar; profile and help under More.
    primary: const [_myElections, _organizations, _invitations, _calendar],
    secondary: [
      _account,
      if (isObserver) _observer,
      _help,
    ],
    platform: platform,
  );
}

/// The single destination that should look selected for [location]: the one
/// with the longest matching prefix, so /orgs/members selects People rather
/// than Organizations. `/home` only matches exactly.
NavDestination? activeDestination(NavModel model, String location) {
  NavDestination? best;
  var bestLen = -1;
  for (final d in model.all) {
    for (final prefix in [d.route, ...d.extraPrefixes]) {
      final exact = location == prefix;
      final nested = prefix != '/home' && location.startsWith('$prefix/');
      if ((exact || nested) && prefix.length > bestLen) {
        best = d;
        bestLen = prefix.length;
      }
    }
  }
  return best;
}
