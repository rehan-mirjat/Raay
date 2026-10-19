import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../notifications/notification_providers.dart';
import '../../features/organizations/presentation/organization_context_switcher.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../features/organizations/domain/organization_enums.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../layout/responsive.dart';
import '../../features/auth/data/user_repository.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../../features/onboarding/presentation/tour_keys.dart';
import '../widgets/global_search_overlay.dart';

// Persists sidebar collapsed state across navigations
final _sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

class AppNavigationShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigationShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveLayout.isWide(context);
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    final activeOrgContext =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
    final memberRole = activeOrgContext?.member.role;
    final canCreateEvent = activeOrgContext != null &&
        (memberRole == OrganizationRole.owner ||
            memberRole == OrganizationRole.admin);
    final isManager = memberRole == OrganizationRole.owner ||
        memberRole == OrganizationRole.admin;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.darkBackground : AppTheme.backgroundLight;
    final collapsed = ref.watch(_sidebarCollapsedProvider);

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
          backgroundColor: bgColor,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const _TopHeader(),
                if (!isDesktop) ...[
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite,
                      border: Border(
                          bottom: BorderSide(
                              color: isDark
                                  ? AppTheme.darkBorder
                                  : AppTheme.borderLight,
                              width: 1)),
                    ),
                    child: Row(
                      children: [
                        const Expanded(child: OrganizationContextSwitcher()),
                        if (isManager) ...[
                          const SizedBox(width: 8),
                          _MobileQuickNavButton(
                            navKey: TourKeys.directoryKey,
                            icon: Icons.groups_outlined,
                            tooltip: 'Directory',
                            route: '/orgs/members',
                          ),
                          const SizedBox(width: 6),
                          _MobileQuickNavButton(
                            navKey: TourKeys.departmentsKey,
                            icon: Icons.apartment_outlined,
                            tooltip: 'Departments',
                            route: '/orgs/departments',
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DesktopSidebar(
                              collapsed: collapsed,
                              isManager: isManager,
                              canCreateEvent: canCreateEvent,
                              onToggleCollapse: () => ref
                                  .read(_sidebarCollapsedProvider.notifier)
                                  .state = !collapsed,
                            ),
                            Expanded(child: navigationShell),
                          ],
                        )
                      : navigationShell,
                ),
              ],
            ),
          ),
          bottomNavigationBar: isDesktop || keyboardVisible
              ? null
              : _FloatingMobileNavBar(
                  navigationShell: navigationShell,
                  showCreateEventButton: canCreateEvent,
                  onCreateEvent: () => context.go('/admin/events/new'),
                ),
        ),
      ),
    );
  }
}

class _MobileQuickNavButton extends StatelessWidget {
  final Key navKey;
  final IconData icon;
  final String tooltip;
  final String route;

  const _MobileQuickNavButton({
    required this.navKey,
    required this.icon,
    required this.tooltip,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Material(
          key: navKey,
          color: isDark ? AppTheme.darkElevated : AppTheme.backgroundLight,
          shape: CircleBorder(
              side: BorderSide(
                  color: isDark ? AppTheme.darkBorder : AppTheme.borderLight,
                  width: 1.2)),
          child: InkWell(
            onTap: () => context.go(route),
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Icon(icon,
                  size: 18,
                  color: isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Desktop collapsible sidebar ─────────────────────────────────────────────

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.collapsed,
    required this.isManager,
    required this.canCreateEvent,
    required this.onToggleCollapse,
  });
  final bool collapsed;
  final bool isManager;
  final bool canCreateEvent;
  final VoidCallback onToggleCollapse;

  static const _expandedWidth = 220.0;
  static const _collapsedWidth = 64.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sidebarBg = isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite;
    final borderColor = isDark ? AppTheme.darkBorder : AppTheme.borderLight;

    final items = [
      _SidebarItem(
          icon: Icons.home_outlined,
          iconActive: Icons.home_rounded,
          label: 'Home',
          route: '/home'),
      _SidebarItem(
          icon: Icons.business_outlined,
          iconActive: Icons.business_rounded,
          label: 'Organizations',
          route: '/orgs'),
      _SidebarItem(
          icon: Icons.how_to_vote_outlined,
          iconActive: Icons.how_to_vote_rounded,
          label: 'Events',
          route: '/admin/events'),
      if (isManager) ...[
        _SidebarItem(
            icon: Icons.groups_outlined,
            iconActive: Icons.groups_rounded,
            label: 'Directory',
            route: '/orgs/members',
            key: TourKeys.directoryKey),
        _SidebarItem(
            icon: Icons.apartment_outlined,
            iconActive: Icons.apartment_rounded,
            label: 'Departments',
            route: '/orgs/departments',
            key: TourKeys.departmentsKey),
      ],
      _SidebarItem(
          icon: Icons.person_outline_rounded,
          iconActive: Icons.person_rounded,
          label: 'Profile',
          route: '/settings'),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: collapsed ? _collapsedWidth : _expandedWidth,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: sidebarBg,
        border: Border(right: BorderSide(color: borderColor, width: 1)),
      ),
      child: Column(
        children: [
          // Org switcher (only when expanded)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: collapsed
                ? const SizedBox(height: 12)
                : Padding(
                    key: const ValueKey('switcher'),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    child: const OrganizationContextSwitcher(),
                  ),
          ),

          // Nav items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: collapsed ? 8 : 10, vertical: 4),
              children: items
                  .map((item) => _SidebarTile(item: item, collapsed: collapsed))
                  .toList(),
            ),
          ),

          // Create event button
          if (canCreateEvent)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: collapsed ? 10 : 12, vertical: 8),
              child: Tooltip(
                message: 'Create voting event',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  child: InkWell(
                    onTap: () => context.go('/admin/events/new'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9D7BFF), AppTheme.primaryBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: collapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_rounded,
                              color: Colors.white, size: 20),
                          if (!collapsed) ...[
                            const SizedBox(width: 6),
                            const Text(
                              'Create Event',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Collapse toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: Tooltip(
              message: collapsed ? 'Expand sidebar' : 'Collapse sidebar',
              child: InkWell(
                onTap: onToggleCollapse,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 36,
                  alignment: Alignment.center,
                  child: AnimatedRotation(
                    turns: collapsed ? 0 : 0.5,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark
                          ? AppTheme.darkTextSecondary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  const _SidebarItem({
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.route,
    this.key,
  });
  final IconData icon;
  final IconData iconActive;
  final String label;
  final String route;
  final Key? key;
}

class _SidebarTile extends StatefulWidget {
  const _SidebarTile({required this.item, required this.collapsed});
  final _SidebarItem item;
  final bool collapsed;

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isActive = widget.item.route == '/orgs'
        ? (location == '/orgs' || location.startsWith('/orgs/'))
        : (location == widget.item.route ||
            (widget.item.route != '/home' &&
                location.startsWith('${widget.item.route}/')));

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppTheme.primaryBlue;
    final inactiveColor =
        isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final activeBg = isDark
        ? AppTheme.primaryBlue.withValues(alpha: 0.15)
        : AppTheme.primaryBlue.withValues(alpha: 0.09);
    final hoverBg = isDark
        ? AppTheme.primaryBlue.withValues(alpha: 0.07)
        : AppTheme.primaryBlue.withValues(alpha: 0.05);

    final color = isActive ? activeColor : (_hovered ? activeColor : inactiveColor);

    return MouseRegion(
      key: widget.item.key,
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.symmetric(
              horizontal: widget.collapsed ? 0 : 10, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? activeBg
                : (_hovered ? hoverBg : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: widget.collapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                isActive ? widget.item.iconActive : widget.item.icon,
                size: 20,
                color: color,
              ),
              if (!widget.collapsed) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w500,
                      color: color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isActive)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _FloatingMobileNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final bool showCreateEventButton;
  final VoidCallback onCreateEvent;

  const _FloatingMobileNavBar({
    required this.navigationShell,
    required this.showCreateEventButton,
    required this.onCreateEvent,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final currentIndex = navigationShell.currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBg = isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite;
    final navBorder = isDark ? AppTheme.darkBorder : AppTheme.borderLight;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : AppTheme.secondaryNavy.withValues(alpha: 0.08);

    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, bottomPadding > 0 ? bottomPadding + 4 : 12),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: navBg,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: navBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(context, 0, Icons.home_outlined,
                      Icons.home_rounded, 'Home', currentIndex),
                  _navItem(context, 1, Icons.business_outlined,
                      Icons.business_rounded, 'Orgs', currentIndex),
                  if (showCreateEventButton) const SizedBox(width: 52),
                  _navItem(context, 3, Icons.how_to_vote_outlined,
                      Icons.how_to_vote_rounded, 'Events', currentIndex),
                  _navItem(context, 2, Icons.person_outline_rounded,
                      Icons.person_rounded, 'Profile', currentIndex),
                ],
              ),
            ),
          ),

          // Gold floating + Create Event button (admin/owner only)
          if (showCreateEventButton)
            Positioned(
              top: -14,
              child: Tooltip(
                message: 'Create voting event',
                child: Semantics(
                  button: true,
                  label: 'Create voting event',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onCreateEvent,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9D7BFF), AppTheme.primaryBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.5),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    int index,
    IconData iconOutlined,
    IconData iconFilled,
    String label,
    int currentIndex,
  ) {
    final isSelected = index == currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = AppTheme.primaryBlue;
    final unselectedColor =
        isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
    final selectedBg = isDark
        ? AppTheme.primaryBlue.withValues(alpha: 0.18)
        : AppTheme.primaryBlue.withValues(alpha: 0.10);

    return Expanded(
      child: InkWell(
        onTap: () {
          navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16 : 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected ? selectedBg : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSelected ? iconFilled : iconOutlined,
                color: isSelected ? selectedColor : unselectedColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final headerBg = isDark ? AppTheme.darkBackground : AppTheme.backgroundLight;
    final pillBg = isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite;
    final pillBorder = isDark ? AppTheme.darkBorder : AppTheme.borderLight;
    final pillShadow = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : AppTheme.secondaryNavy.withValues(alpha: 0.06);

    return Container(
      color: headerBg,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 12,
        vertical: isDesktop ? 12 : 6,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            height: isDesktop ? 60 : 52,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: pillBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: pillShadow,
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const _BrandLogoLink(),

                const Spacer(),

                // Global search button
                _SearchButton(),
                const SizedBox(width: 8),

                // Theme toggle
                _ThemeToggleButton(),
                if (user != null) ...[
                  const SizedBox(width: 8),
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
    );
  }
}

class _ThemeToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pillBorder = isDark ? AppTheme.darkBorder : AppTheme.borderLight;
    final iconColor = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
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
    final textColor = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

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
            color: _hovered
                ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                : bg,
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
  const _BrandLogoLink();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/home'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Kivora',
                style: TextStyle(
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.secondaryNavy,
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
    final invitationsAsync = ref.watch(memberInvitationsProvider);
    final items = invitationsAsync.valueOrNull ?? [];
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
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 15, minHeight: 15),
                    child: Center(
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
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
          final itemBg = isDark
              ? AppTheme.darkElevated
              : const Color(0xFFF0F5FF);

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
                      child: const Text(
                        'Mark all read',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryBlue,
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
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryBlue,
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
            const PopupMenuItem<String>(
              value: 'view_all',
              child: Center(
                child: Text(
                  'View all notifications',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
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
    final textColor = isDark ? AppTheme.darkTextPrimary : AppTheme.secondaryNavy;
    final subColor = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

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
                      color:
                          _isHovered ? AppTheme.primaryBlue : textColor,
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
          } else if (value == 'platform_admin') {
            context.go('/platform/admin');
          } else if (value == 'platform_organizations') {
            context.go('/platform/organizations');
          }
        },
        itemBuilder: (BuildContext context) {
          final labelColor = isDark ? AppTheme.darkTextPrimary : AppTheme.secondaryNavy;
          final subLabelColor = isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

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
                            style: TextStyle(
                                color: subLabelColor, fontSize: 12),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            _buildMenuItem(context, isDark, 'settings',
                Icons.settings_outlined, 'Account settings'),
            _buildMenuItem(
                context, isDark, 'help', Icons.help_outline, 'Help & support'),
            if (ref.watch(platformAdminProvider).valueOrNull == true) ...[
              const PopupMenuDivider(),
              _buildMenuItem(context, isDark, 'platform_admin',
                  Icons.admin_panel_settings_outlined, 'Platform admin'),
              _buildMenuItem(context, isDark, 'platform_organizations',
                  Icons.domain_outlined, 'Organizations'),
            ],
            const PopupMenuDivider(),
            _buildMenuItem(context, isDark, 'logout', Icons.logout_rounded,
                'Log out',
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
      backgroundImage:
          photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
      child: photoUrl.isEmpty
          ? Text(
              widget.displayName.isNotEmpty
                  ? widget.displayName[0].toUpperCase()
                  : 'U',
              style: TextStyle(
                fontSize: size * 0.75,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            )
          : null,
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      BuildContext context, bool isDark, String value, IconData icon, String label,
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
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
