import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

import '../notifications/notification_providers.dart';
import '../../features/organizations/presentation/organization_context_switcher.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../features/organizations/domain/organization_enums.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../layout/responsive.dart';
import '../navigation/exit_guard.dart';
import '../navigation/nav_destinations.dart';
import '../../features/auth/data/user_repository.dart';
import '../theme/app_theme.dart';
import '../theme/kivora_colors.dart';
import '../theme/theme_provider.dart';
import '../../features/onboarding/presentation/tour_keys.dart';
import '../widgets/global_search_overlay.dart';


/// Leaves the current screen only if it has no unsaved work (or the user
/// confirmed). Every shell navigation goes through here.
Future<void> _navigate(BuildContext context, WidgetRef ref, String route) async {
  final ok = await canLeaveCurrentScreen(ProviderScope.containerOf(context));
  if (ok && context.mounted) context.go(route);
}

String _navLabel(AppLocalizations l10n, NavId id) => switch (id) {
      NavId.myElections => l10n.navMyElections,
      NavId.overview => l10n.navOverview,
      NavId.elections => l10n.navEvents,
      NavId.people => l10n.navPeople,
      NavId.departments => l10n.navDepartments,
      NavId.activity => l10n.navActivity,
      NavId.organizations => l10n.navOrganizations,
      NavId.calendar => l10n.navCalendar,
      NavId.observer => l10n.navObserver,
      NavId.orgSettings => l10n.navOrgSettings,
      NavId.billing => l10n.navBilling,
      NavId.account => l10n.navAccount,
      NavId.help => l10n.navHelp,
      NavId.platform => l10n.navPlatform,
    };

Key? _tourKey(NavId id) => switch (id) {
      NavId.departments => TourKeys.departmentsKey,
      NavId.people => TourKeys.directoryKey,
      _ => null,
    };

class AppNavigationShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigationShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final isExpanded = ResponsiveLayout.isWide(context);
    // The rail grows with its labels; at large text sizes it would crowd out
    // the content, so those users get the compact layout (bottom bar whose
    // "More" sheet shows full-size labels).
    final largeText = MediaQuery.textScalerOf(context).scale(14) / 14 > 1.3;
    final isMedium = ResponsiveLayout.isMedium(context) && !largeText;

    final activeOrgContext =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
    final memberRole = activeOrgContext?.member.role;
    final isOwner = memberRole == OrganizationRole.owner;
    final isManager = isOwner || memberRole == OrganizationRole.admin;
    final isObserver = activeOrgContext?.member.isObserver ?? false;
    final isPlatformAdmin = ref.watch(platformAdminProvider).valueOrNull ?? false;

    final model = navModelFor(
      isManager: isManager,
      isOwner: isOwner,
      isObserver: isObserver,
      isPlatformAdmin: isPlatformAdmin,
    );
    final location = GoRouterState.of(context).matchedLocation;
    final active = activeDestination(model, location);

    Widget content;
    if (isExpanded) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Sidebar(model: model, active: active, canCreate: isManager),
          Expanded(
            child: Column(
              children: [
                const _TopHeader(),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      );
    } else if (isMedium) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MediumRail(model: model, active: active, canCreate: isManager),
          Expanded(
            child: Column(
              children: [
                const _TopHeader(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SizedBox(width: 320, child: OrganizationContextSwitcher()),
                  ),
                ),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      );
    } else {
      content = Column(
        children: [
          const _TopHeader(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: SizedBox(width: double.infinity, child: OrganizationContextSwitcher()),
          ),
          Expanded(child: navigationShell),
        ],
      );
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () =>
            showGlobalSearch(context),
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () =>
            showGlobalSearch(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: KivoraColors.backgroundOf(context),
          body: SafeArea(bottom: false, child: content),
          bottomNavigationBar: isExpanded || isMedium || keyboardVisible
              ? null
              : _CompactBottomBar(model: model, active: active, canCreate: isManager),
        ),
      ),
    );
  }
}

// ─── Expanded: 248px sidebar ─────────────────────────────────────────────────

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.model, required this.active, required this.canCreate});
  final NavModel model;
  final NavDestination? active;
  final bool canCreate;

  static const width = 248.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);

    Widget sectionLabel(String text) => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 4),
          child: Text(text.toUpperCase(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: kc.textSecondary)),
        );

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: kc.surface,
        border: BorderDirectional(end: BorderSide(color: kc.border)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: OrganizationContextSwitcher(),
          ),
          Expanded(
            child: FocusTraversalGroup(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                children: [
                  Semantics(
                    container: true,
                    label: l10n.navMainLabel,
                    child: Column(children: [
                      for (final d in model.primary)
                        _SidebarTile(dest: d, selected: d == active, label: _navLabel(l10n, d.id)),
                    ]),
                  ),
                  if (model.secondary.isNotEmpty) sectionLabel(l10n.navMoreSectionLabel),
                  for (final d in model.secondary)
                    _SidebarTile(dest: d, selected: d == active, label: _navLabel(l10n, d.id)),
                  if (model.platform.isNotEmpty) sectionLabel(l10n.navPlatformSectionLabel),
                  for (final d in model.platform)
                    _SidebarTile(dest: d, selected: d == active, label: _navLabel(l10n, d.id)),
                ],
              ),
            ),
          ),
          if (canCreate)
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => _navigate(context, ref, '/admin/events/new'),
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text(l10n.navCreateElection),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SidebarTile extends ConsumerWidget {
  const _SidebarTile({required this.dest, required this.selected, required this.label});
  final NavDestination dest;
  final bool selected;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    final color = selected ? kc.accentText : kc.textSecondary;

    return Padding(
      key: _tourKey(dest.id),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: ExcludeSemantics(
          child: Material(
            color: selected
                ? primary.withValues(alpha: kc.isDark ? 0.16 : 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusInput),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radiusInput),
              onTap: () => _navigate(context, ref, dest.route),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(selected ? dest.iconActive : dest.icon, size: 22, color: color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected ? kc.accentText : kc.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Medium: NavigationRail ──────────────────────────────────────────────────

class _MediumRail extends ConsumerWidget {
  const _MediumRail({required this.model, required this.active, required this.canCreate});
  final NavModel model;
  final NavDestination? active;
  final bool canCreate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final items = [...model.primary, ...model.secondary, ...model.platform];
    final selectedIndex = active == null ? null : items.indexOf(active!);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: kc.surface,
        border: BorderDirectional(end: BorderSide(color: kc.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: NavigationRail(
                backgroundColor: Colors.transparent,
                extended: false,
                labelType: NavigationRailLabelType.all,
                minWidth: 88,
                selectedIndex: selectedIndex == -1 ? null : selectedIndex,
                onDestinationSelected: (i) => _navigate(context, ref, items[i].route),
                trailing: canCreate
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: IconButton.filled(
                          tooltip: l10n.navCreateElection,
                          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                          onPressed: () => _navigate(context, ref, '/admin/events/new'),
                          icon: const Icon(Icons.add_rounded),
                        ),
                      )
                    : null,
                destinations: [
                  for (final d in items)
                    NavigationRailDestination(
                      icon: Icon(d.icon, key: _tourKey(d.id)),
                      selectedIcon: Icon(d.iconActive),
                      label: Text(_navLabel(l10n, d.id),
                          textAlign: TextAlign.center, maxLines: 2),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Compact: 4 destinations + labeled More ──────────────────────────────────

class _CompactBottomBar extends ConsumerWidget {
  const _CompactBottomBar({required this.model, required this.active, required this.canCreate});
  final NavModel model;
  final NavDestination? active;
  final bool canCreate;

  void _openMore(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canCreate)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _navigate(context, ref, '/admin/events/new');
                      },
                      icon: const Icon(Icons.add_rounded),
                      label: Text(l10n.navCreateElection),
                    ),
                  ),
                ),
              for (final d in [...model.secondary, ...model.platform])
                ListTile(
                  minTileHeight: 48,
                  selected: d == active,
                  selectedColor: kc.accentText,
                  leading: Icon(d == active ? d.iconActive : d.icon),
                  title: Text(_navLabel(l10n, d.id)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _navigate(context, ref, d.route);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final moreActive = active != null && !model.primary.contains(active);

    Widget item({
      required IconData icon,
      required String label,
      required bool selected,
      required VoidCallback onTap,
    }) {
      final color = selected ? kc.accentText : kc.textSecondary;
      return Expanded(
        child: Semantics(
          button: true,
          selected: selected,
          label: label,
          child: ExcludeSemantics(
            child: InkWell(
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 24, color: color),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: kc.surface,
        border: Border(top: BorderSide(color: kc.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final d in model.primary)
              item(
                icon: d == active ? d.iconActive : d.icon,
                label: _navLabel(l10n, d.id),
                selected: d == active,
                onTap: () => _navigate(context, ref, d.route),
              ),
            item(
              icon: Icons.menu_rounded,
              label: l10n.navMore,
              selected: moreActive,
              onTap: () => _openMore(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}


class _TopHeader extends ConsumerWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveLayout.isWide(context);
    final user = ref.watch(authServiceProvider).currentUser;
    final appUserAsync =
        user != null ? ref.watch(userProfileProvider(user.uid)) : null;
    final photoUrlToUse = appUserAsync?.valueOrNull?.photoUrl ?? user?.photoURL;


    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: isDesktop ? 12 : 4,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: _BarSurface(
            borderRadius: 20,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 16 : 10,
              vertical: 6,
            ),
            child: SizedBox(
            height: isDesktop ? 48 : 40,
            child: Row(
              children: [
                _BrandLogoLink(compact: !isDesktop),

                const Spacer(),

                // Desktop-only: search, calendar, theme toggle
                if (isDesktop) ...[
                  _SearchButton(),
                  const SizedBox(width: 8),
                  if (user != null) ...[
                    Tooltip(
                      message: 'Election Calendar',
                      child: IconButton(
                        icon: const Icon(Icons.calendar_month_outlined),
                        onPressed: () => context.go('/calendar'),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  _ThemeToggleButton(),
                  const SizedBox(width: 8),
                ],

                // Always show notification + profile (mobile & desktop)
                if (user != null) ...[
                  const _NotificationDropdown(),
                  const SizedBox(width: 10),
                ],
                if (user != null)
                  _ProfileDropdown(
                    key: TourKeys.profileKey,
                    uid: user.uid,
                    displayName: user.displayName ?? 'User',
                    email: user.email ?? '',
                    photoUrl: photoUrlToUse,
                  ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillBorder = isDark ? AppTheme.darkBorder : AppTheme.borderLight;
    final iconColor =
        isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final bgColor = isDark ? AppTheme.darkElevated : AppTheme.backgroundLight;

    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: GestureDetector(
        onTap: () => ref.read(themeModeProvider.notifier).toggle(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: pillBorder, width: 1.2),
          ),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: 17,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class _SearchButton extends StatefulWidget {
  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = ResponsiveLayout.isWide(context);
    final border = isDark ? AppTheme.darkBorder : AppTheme.borderLight;
    final bg = isDark ? AppTheme.darkElevated : AppTheme.backgroundLight;
    final textColor =
        isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => showGlobalSearch(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 36,
          padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 12 : 10, vertical: 0),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.primaryBlue.withValues(alpha: 0.08) : bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                  : border,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_rounded, size: 16, color: textColor),
              if (isDesktop) ...[
                const SizedBox(width: 6),
                Text('Search',
                    style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                        fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('⌘K',
                      style: TextStyle(
                          fontSize: 10,
                          color: textColor,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandLogoLink extends StatelessWidget {
  const _BrandLogoLink({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/home'),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: compact ? 2 : 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: compact ? 30 : 32,
                  height: compact ? 30 : 32,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: compact ? 8 : 10),
              Text(
                'Kivora',
                style: TextStyle(
                  color: isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.secondaryNavy,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationDropdown extends ConsumerStatefulWidget {
  const _NotificationDropdown();

  @override
  ConsumerState<_NotificationDropdown> createState() =>
      _NotificationDropdownState();
}

class _NotificationDropdownState extends ConsumerState<_NotificationDropdown> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(authServiceProvider).currentUser?.uid;
    final invitationAlertsEnabled = uid == null
        ? true
        : (ref
                .watch(userProfileProvider(uid))
                .valueOrNull
                ?.notificationPreferences['invitationAlerts'] ??
            true);
    final invitationsAsync = ref.watch(memberInvitationsProvider);
    final items = invitationAlertsEnabled
        ? (invitationsAsync.valueOrNull ?? []).where((i) => !isInvitationExpired(i)).toList()
        : const <Map<String, dynamic>>[];
    final reminders = ref.watch(unreadNotificationsProvider).valueOrNull ?? [];
    final unreadCount = items.length + reminders.length;
    final hasUnread = unreadCount > 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconBg = isDark ? AppTheme.darkElevated : AppTheme.backgroundLight;
    final iconBorder = isDark ? AppTheme.darkBorder : AppTheme.borderLight;
    final menuBg = isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite;
    final menuBorder = isDark ? AppTheme.darkBorder : AppTheme.borderLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton<String>(
        offset: const Offset(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          side: BorderSide(color: menuBorder),
        ),
        color: menuBg,
        elevation: 6,
        tooltip: 'Notifications',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: hasUnread
                ? AppTheme.primaryBlue.withValues(alpha: 0.15)
                : (_isHovered
                    ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                    : iconBg),
            shape: BoxShape.circle,
            border: Border.all(
              color: (hasUnread || _isHovered)
                  ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                  : iconBorder,
              width: 1.2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                hasUnread
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_none_rounded,
                size: 17,
                color: (hasUnread || _isHovered)
                    ? AppTheme.primaryBlue
                    : (isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary),
              ),
              if (hasUnread)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      // Solid fill under white text: #B42318 gives 6.5:1.
                      color: Color(0xFFB42318),
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Center(
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        onSelected: (value) {
          if (value == 'view_all') {
            context.go('/orgs/invitations');
          } else if (value == 'mark_read') {
            ref.invalidate(memberInvitationsProvider);
            for (final r in reminders) {
              markNotificationRead(r.id);
            }
          } else if (value.startsWith('reminder:')) {
            final id = value.substring('reminder:'.length);
            final matches = reminders.where((r) => r.id == id);
            markNotificationRead(id);
            if (matches.isNotEmpty && matches.first.votingEventId != null) {
              context.go('/elections/${matches.first.votingEventId}');
            }
          }
        },
        itemBuilder: (context) {
          final menuWidth =
              (MediaQuery.sizeOf(context).width - 32).clamp(200.0, 320.0);
          final labelColor =
              isDark ? AppTheme.darkTextPrimary : AppTheme.secondaryNavy;
          final subColor =
              isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
          final itemBg =
              isDark ? AppTheme.darkElevated : const Color(0xFFF0F5FF);

          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              enabled: false,
              child: SizedBox(
                width: menuWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: labelColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ref.invalidate(memberInvitationsProvider);
                        for (final r in reminders) {
                          markNotificationRead(r.id);
                        }
                      },
                      child: Text(
                        'Mark all read',
                        style: TextStyle(
                          fontSize: 12,
                          color: KivoraColors.of(context).accentText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const PopupMenuDivider(),
            if (items.isEmpty && reminders.isEmpty)
              PopupMenuItem<String>(
                enabled: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No new notifications',
                      style: TextStyle(color: subColor, fontSize: 13),
                    ),
                  ),
                ),
              )
            else
              ...items.take(4).map((item) {
                final orgName =
                    item['organizationName'] as String? ?? 'Organization';
                final role = item['role'] as String? ?? 'member';

                return PopupMenuItem<String>(
                  value: 'view_all',
                  child: SizedBox(
                    width: menuWidth,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: itemBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              color: KivoraColors.of(context).accentText,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Invited to join $orgName',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: labelColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Role: ${role.toUpperCase()} • Action required',
                                  style:
                                      TextStyle(fontSize: 11, color: subColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ...reminders.take(4).map((reminder) {
              return PopupMenuItem<String>(
                value: 'reminder:${reminder.id}',
                child: SizedBox(
                  width: menuWidth,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: itemBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.campaign_outlined,
                            size: 16, color: AppTheme.accentGold),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminder.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: labelColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                reminder.message,
                                style: TextStyle(fontSize: 11, color: subColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'view_all',
              child: Center(
                child: Text(
                  'View all notifications',
                  style: TextStyle(
                    color: KivoraColors.of(context).accentText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ];
        },
      ),
    );
  }
}

class _ProfileDropdown extends ConsumerStatefulWidget {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;

  const _ProfileDropdown({
    super.key,
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  @override
  ConsumerState<_ProfileDropdown> createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends ConsumerState<_ProfileDropdown> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final sanitizedPhotoUrl =
        FirebaseService.sanitizeStorageUrl(widget.photoUrl);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pillBg = isDark ? AppTheme.darkElevated : AppTheme.backgroundLight;
    final pillBorder = isDark ? AppTheme.darkBorder : AppTheme.borderLight;
    final menuBg = isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite;
    final menuBorder = isDark ? AppTheme.darkBorder : AppTheme.borderLight;
    final textColor =
        isDark ? AppTheme.darkTextPrimary : AppTheme.secondaryNavy;
    final subColor =
        isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton<String>(
        offset: const Offset(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          side: BorderSide(color: menuBorder),
        ),
        color: menuBg,
        elevation: 6,
        tooltip: 'Account menu',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                : pillBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                  : pillBorder,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _avatar(sanitizedPhotoUrl, size: 14),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _isHovered ? AppTheme.primaryBlue : textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final role = ref
                          .watch(activeOrganizationContextProvider)
                          .valueOrNull
                          ?.context
                          ?.member
                          .role
                          .value;
                      final roleLabel = role != null
                          ? 'Account ${role.toLowerCase()}'
                          : 'Account user';
                      return Text(
                        roleLabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: subColor,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 14,
                color: _isHovered ? AppTheme.primaryBlue : subColor,
              ),
            ],
          ),
        ),
        onSelected: (value) {
          if (value == 'logout') {
            ref.read(authServiceProvider).signOut();
          } else if (value == 'settings') {
            context.go('/settings', extra: {'initialTab': 0});
          } else if (value == 'notifications') {
            context.go('/orgs/invitations');
          } else if (value == 'help') {
            context.go('/help');
          } else if (value == 'transparency') {
            context.go('/transparency');
          } else if (value == 'plans') {
            context.go('/plans');
          } else if (value == 'platform_admin') {
            context.go('/platform/admin');
          } else if (value == 'platform_organizations') {
            context.go('/platform/organizations');
          }
        },
        itemBuilder: (BuildContext context) {
          final labelColor =
              isDark ? AppTheme.darkTextPrimary : AppTheme.secondaryNavy;
          final subLabelColor =
              isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              enabled: false,
              child: Row(
                children: [
                  _avatar(sanitizedPhotoUrl, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: labelColor,
                                fontSize: 14)),
                        Text(widget.email,
                            style:
                                TextStyle(color: subLabelColor, fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            _buildMenuItem(context, isDark, 'settings', Icons.settings_outlined,
                'Account settings'),
            _buildMenuItem(
                context, isDark, 'help', Icons.help_outline, 'Help & support'),
            if (ref.watch(activeOrganizationContextProvider).valueOrNull?.context?.member.role ==
                OrganizationRole.owner)
              _buildMenuItem(context, isDark, 'plans',
                  Icons.workspace_premium_outlined, 'Plans & Billing'),
            _buildMenuItem(context, isDark, 'transparency',
                Icons.verified_outlined, 'Trust & Transparency'),
            if (ref.watch(platformAdminProvider).valueOrNull == true) ...[
              const PopupMenuDivider(),
              _buildMenuItem(context, isDark, 'platform_admin',
                  Icons.admin_panel_settings_outlined, 'Platform admin'),
              _buildMenuItem(context, isDark, 'platform_organizations',
                  Icons.domain_outlined, 'Organizations'),
            ],
            const PopupMenuDivider(),
            _buildMenuItem(
                context, isDark, 'logout', Icons.logout_rounded, 'Log out',
                isDestructive: true),
          ];
        },
      ),
    );
  }

  Widget _avatar(String photoUrl, {required double size}) {
    return CircleAvatar(
      radius: size,
      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
      backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
      child: photoUrl.isEmpty
          ? Text(
              widget.displayName.isNotEmpty
                  ? widget.displayName[0].toUpperCase()
                  : 'U',
              style: TextStyle(
                fontSize: size * 0.75,
                fontWeight: FontWeight.bold,
                color: KivoraColors.of(context).accentText,
              ),
            )
          : null,
    );
  }

  PopupMenuItem<String> _buildMenuItem(BuildContext context, bool isDark,
      String value, IconData icon, String label,
      {bool isDestructive = false}) {
    final color = isDestructive
        ? AppTheme.error
        : (isDark ? AppTheme.darkTextPrimary : AppTheme.secondaryNavy);
    return PopupMenuItem<String>(
      value: value,
      height: 40,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}


/// Solid, bordered bar surface used by the header and bottom navigation.
class _BarSurface extends StatelessWidget {
  const _BarSurface({required this.borderRadius, required this.child, this.padding});

  final double borderRadius;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: kc.border),
      ),
      child: child,
    );
  }
}
