import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/organizations/presentation/organization_context_switcher.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../features/organizations/domain/organization_enums.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../layout/responsive.dart';
import '../../features/auth/data/user_repository.dart';
import '../theme/app_theme.dart';
import '../../features/onboarding/presentation/tour_keys.dart';

class AppNavigationShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigationShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = ResponsiveLayout.isWide(context);
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    final activeOrgContext = ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
    final memberRole = activeOrgContext?.member.role;
    final canCreateEvent = activeOrgContext != null &&
        (memberRole == OrganizationRole.owner || memberRole == OrganizationRole.admin);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _TopHeader(),
            if (!isDesktop) ...[
              // Mobile specific: The Organization Context Switcher goes right below the header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  border: Border(bottom: BorderSide(color: AppTheme.borderLight, width: 1)),
                ),
                child: const OrganizationContextSwitcher(),
              ),
            ],
            Expanded(child: navigationShell),
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
    );
  }
}

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

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding > 0 ? bottomPadding + 4 : 12),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Main Floating Glass Container
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.8), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(context, 0, Icons.home_outlined, Icons.home_rounded, 'Home', currentIndex),
                      _navItem(context, 1, Icons.business_outlined, Icons.business_rounded, 'Orgs', currentIndex),
                      if (showCreateEventButton) ...[
                        // Spacer for central floating + button
                        const SizedBox(width: 52),
                      ],
                      _navItem(context, 3, Icons.inventory_2_outlined, Icons.inventory_2_rounded, 'Events', currentIndex),
                      _navItem(context, 2, Icons.person_outline_rounded, Icons.person_rounded, 'Profile', currentIndex),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Central Floating + Action Button (Owner & Admin Only with Kivora Gold Accent)
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
                            colors: [Color(0xFFFBBF24), AppTheme.accentGold],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentGold.withValues(alpha: 0.45),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppTheme.secondaryNavy,
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
                color: isSelected ? AppTheme.primaryBlue.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSelected ? iconFilled : iconOutlined,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
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
    final appUserAsync = user != null ? ref.watch(userProfileProvider(user.uid)) : null;
    final photoUrlToUse = appUserAsync?.valueOrNull?.photoUrl ?? user?.photoURL;

    return Container(
      color: AppTheme.backgroundLight,
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
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.borderLight, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Logo & Wordmark with Hover State
                const _BrandLogoLink(),
                
                if (isDesktop) ...[
                  const SizedBox(width: 16),
                  Container(width: 1, height: 20, color: AppTheme.borderLight),
                  const SizedBox(width: 16),
                  _DesktopNavLink(label: 'Events', route: '/admin/events', navKey: TourKeys.eventsKey),
                  const SizedBox(width: 4),
                  _DesktopNavLink(label: 'Organization', route: '/orgs', navKey: TourKeys.organizationKey),
                  const SizedBox(width: 4),
                  _DesktopNavLink(label: 'Directory', route: '/orgs/members', navKey: TourKeys.directoryKey),
                  const SizedBox(width: 4),
                  _DesktopNavLink(label: 'Departments', route: '/orgs/departments', navKey: TourKeys.departmentsKey),
                ],

                const Spacer(),

                // Notifications Dropdown
                if (user != null) ...[
                  const _NotificationDropdown(),
                  const SizedBox(width: 10),
                ],

                // Profile Dropdown
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

class _BrandLogoLink extends StatelessWidget {
  const _BrandLogoLink();

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Kivora',
                style: TextStyle(
                  color: AppTheme.secondaryNavy,
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

class _DesktopNavLink extends StatefulWidget {
  final String label;
  final String route;
  final Key? navKey;

  const _DesktopNavLink({
    required this.label,
    required this.route,
    this.navKey,
  });

  @override
  State<_DesktopNavLink> createState() => _DesktopNavLinkState();
}

class _DesktopNavLinkState extends State<_DesktopNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isActive = widget.route == '/orgs'
        ? (location == '/orgs' || location == '/orgs/dashboard')
        : (location == widget.route || (widget.route != '/home' && location.startsWith('${widget.route}/')));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        key: widget.navKey,
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.surfaceBlue
                : (_isHovered ? AppTheme.surfaceBlue.withValues(alpha: 0.6) : Colors.transparent),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? AppTheme.primaryBlue.withValues(alpha: 0.3)
                  : (_isHovered ? AppTheme.primaryBlue.withValues(alpha: 0.2) : Colors.transparent),
              width: 1.0,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: isActive
                  ? AppTheme.primaryBlue
                  : (_isHovered ? AppTheme.primaryBlue : AppTheme.secondaryNavy),
              fontWeight: (isActive || _isHovered) ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationDropdown extends ConsumerStatefulWidget {
  const _NotificationDropdown();

  @override
  ConsumerState<_NotificationDropdown> createState() => _NotificationDropdownState();
}

class _NotificationDropdownState extends ConsumerState<_NotificationDropdown> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final invitationsAsync = ref.watch(memberInvitationsProvider);
    final items = invitationsAsync.valueOrNull ?? [];
    final unreadCount = items.length;
    final hasUnread = unreadCount > 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton<String>(
        offset: const Offset(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.borderLight),
        ),
        color: AppTheme.surfaceWhite,
        elevation: 6,
        tooltip: 'Notifications',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: hasUnread
                ? AppTheme.surfaceBlue
                : (_isHovered ? AppTheme.surfaceBlue.withValues(alpha: 0.6) : AppTheme.backgroundLight),
            shape: BoxShape.circle,
            border: Border.all(
              color: (hasUnread || _isHovered)
                  ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                  : AppTheme.borderLight,
              width: 1.2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                hasUnread ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                size: 18,
                color: (hasUnread || _isHovered) ? AppTheme.primaryBlue : AppTheme.secondaryNavy,
              ),
              if (hasUnread)
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
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
          }
        },
        itemBuilder: (context) {
          return <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              enabled: false,
              child: SizedBox(
                width: 320,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppTheme.secondaryNavy,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        ref.invalidate(memberInvitationsProvider);
                      },
                      child: const Text(
                        'Mark all as read',
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
            if (items.isEmpty)
              const PopupMenuItem<String>(
                enabled: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'No new notifications',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ),
                ),
              )
            else
              ...items.take(4).map((item) {
                final orgName = item['organizationName'] as String? ?? 'Organization';
                final role = item['role'] as String? ?? 'member';

                return PopupMenuItem<String>(
                  value: 'view_all',
                  child: SizedBox(
                    width: 320,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5FF),
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
                                  'You\'re invited to join $orgName',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppTheme.secondaryNavy,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Role: ${role.toUpperCase()} • Action required',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
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
    final sanitizedPhotoUrl = FirebaseService.sanitizeStorageUrl(widget.photoUrl);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: PopupMenuButton<String>(
        offset: const Offset(0, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.borderLight),
        ),
        color: AppTheme.surfaceWhite,
        elevation: 6,
        tooltip: 'Account menu',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _isHovered ? AppTheme.surfaceBlue.withValues(alpha: 0.6) : AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? AppTheme.primaryBlue.withValues(alpha: 0.4) : AppTheme.borderLight,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppTheme.surfaceBlue,
                backgroundImage: sanitizedPhotoUrl.isNotEmpty
                    ? NetworkImage(sanitizedPhotoUrl)
                    : null,
                child: sanitizedPhotoUrl.isEmpty
                    ? Text(
                        widget.displayName.isNotEmpty ? widget.displayName[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                        ),
                      )
                    : null,
              ),
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
                      color: _isHovered ? AppTheme.primaryBlue : AppTheme.secondaryNavy,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final role = ref.watch(activeOrganizationContextProvider).valueOrNull?.context?.member.role.value;
                      final roleLabel = role != null ? 'Account ${role.toLowerCase()}' : 'Account user';
                      return Text(
                        roleLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
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
                color: _isHovered ? AppTheme.primaryBlue : AppTheme.textSecondary,
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
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            enabled: false,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.surfaceBlue,
                  backgroundImage: sanitizedPhotoUrl.isNotEmpty ? NetworkImage(sanitizedPhotoUrl) : null,
                  child: sanitizedPhotoUrl.isEmpty
                      ? Text(widget.displayName.isNotEmpty ? widget.displayName[0].toUpperCase() : 'U', style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold))
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.displayName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryNavy, fontSize: 14)),
                      Text(widget.email, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(),
          _buildMenuItem('settings', Icons.settings_outlined, 'Account settings'),
          _buildMenuItem('help', Icons.help_outline, 'Help & support'),
          const PopupMenuDivider(),
          _buildMenuItem('logout', Icons.logout_rounded, 'Log out', isDestructive: true),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String label, {bool isDestructive = false}) {
    final color = isDestructive ? AppTheme.error : AppTheme.secondaryNavy;
    return PopupMenuItem<String>(
      value: value,
      height: 40,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
