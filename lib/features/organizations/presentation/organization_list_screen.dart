import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../services/firebase_service.dart';
import '../domain/organization.dart';
import '../domain/organization_enums.dart';
import '../domain/organization_member.dart';
import '../data/organization_repository.dart';
import 'providers/organization_providers.dart';
import 'organization_context_switcher.dart';

class OrganizationListScreen extends ConsumerWidget {
  const OrganizationListScreen({
    super.key,
    this.onCreateOrgTap,
    this.onSignOutTap,
  });

  final VoidCallback? onCreateOrgTap;
  final VoidCallback? onSignOutTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipsAsync = ref.watch(userMembershipsProvider);
    final orgsAsync = ref.watch(userOrganizationsProvider);
    final activeOrgStateAsync = ref.watch(activeOrganizationContextProvider);
    final isDesktop = ResponsiveLayout.isWide(context);

    final activeOrgId = activeOrgStateAsync.valueOrNull?.context?.organization.id;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1140),
            child: membershipsAsync.when(
              loading: () => const LoadingView(message: 'Loading memberships...'),
              error: (err, stack) => ErrorView(type: ErrorViewType.generic, 
                message: 'Error loading memberships: $err',
                onRetry: () => ref.invalidate(userMembershipsProvider),
              ),
              data: (memberships) {
                return orgsAsync.when(
                  loading: () => const LoadingView(message: 'Loading organization details...'),
                  error: (err, stack) => ErrorView(type: ErrorViewType.generic, 
                    message: 'Error loading organizations: $err',
                    onRetry: () => ref.invalidate(userOrganizationsProvider),
                  ),
                  data: (organizations) {
                    final activeOrg = activeOrgId != null 
                        ? organizations.where((o) => o.id == activeOrgId).firstOrNull 
                        : null;
                    final activeMember = activeOrg != null 
                        ? memberships.where((m) => m.organizationId == activeOrg.id).firstOrNull 
                        : null;
                    final otherOrgs = organizations.where((o) => activeOrg == null || o.id != activeOrg.id).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sub-header Breadcrumb & Switcher bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.corporate_fare_outlined, size: 16, color: AppTheme.textSecondary),
                                SizedBox(width: 8),
                                Text('Organization', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                                SizedBox(width: 6),
                                Icon(Icons.chevron_right, size: 14, color: AppTheme.textSecondary),
                                SizedBox(width: 6),
                                Text('Overview', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.secondaryNavy)),
                              ],
                            ),
                            if (isDesktop) const OrganizationContextSwitcher(),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Main Header Title & Actions
                        if (isDesktop)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your organizations',
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.secondaryNavy,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Choose your workspace. Connect with your community.',
                                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => context.go('/orgs/join'),
                                    icon: const Icon(Icons.key_outlined, size: 16),
                                    label: const Text('Join with code'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  FilledButton.icon(
                                    onPressed: () {
                                      if (onCreateOrgTap != null) {
                                        onCreateOrgTap!();
                                      } else {
                                        context.go('/orgs/create');
                                      }
                                    },
                                    icon: const Icon(Icons.add_rounded, size: 18),
                                    label: const Text('Create organization'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppTheme.primaryBlue,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your organizations',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.secondaryNavy,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Choose your workspace. Connect with your community.',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: () => context.go('/orgs/join'),
                                    icon: const Icon(Icons.key_outlined, size: 16),
                                    label: const Text('Join with code'),
                                  ),
                                  FilledButton.icon(
                                    onPressed: () {
                                      if (onCreateOrgTap != null) {
                                        onCreateOrgTap!();
                                      } else {
                                        context.go('/orgs/create');
                                      }
                                    },
                                    icon: const Icon(Icons.add_rounded, size: 18),
                                    label: const Text('Create organization'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppTheme.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(height: 28),

                        // Content Grid
                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // LEFT COLUMN: Workspaces & Other Orgs
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    if (activeOrg != null)
                                      _buildPrimaryWorkspaceCard(context, ref, activeOrg, activeMember)
                                    else
                                      _buildNoWorkspaceSelectedCard(context),

                                    if (otherOrgs.isNotEmpty) ...[
                                      const SizedBox(height: 32),
                                      Text(
                                        activeOrg != null ? 'OTHER ORGANIZATIONS' : 'YOUR ORGANIZATIONS',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textSecondary,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ...otherOrgs.map((org) {
                                        final matchingMember = memberships.where((m) => m.organizationId == org.id).firstOrNull;
                                        return _buildOtherOrgCard(context, ref, org, matchingMember);
                                      }),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 32),
                              // RIGHT SIDEBAR: Workspace info & invitations callout
                              SizedBox(
                                width: 320,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildOneWorkspacePanel(context, activeOrg),
                                    const SizedBox(height: 20),
                                    _buildInvitationsCalloutPanel(context),
                                    const SizedBox(height: 20),
                                    const Row(
                                      children: [
                                        Icon(Icons.info_outline_rounded, size: 15, color: AppTheme.textSecondary),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Have a joining code? Get it from your organization\'s owner, then choose Join with code.',
                                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (activeOrg != null)
                                _buildPrimaryWorkspaceCard(context, ref, activeOrg, activeMember)
                              else
                                _buildNoWorkspaceSelectedCard(context),

                              if (otherOrgs.isNotEmpty) ...[
                                const SizedBox(height: 32),
                                Text(
                                  activeOrg != null ? 'OTHER ORGANIZATIONS' : 'YOUR ORGANIZATIONS',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textSecondary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...otherOrgs.map((org) {
                                  final matchingMember = memberships.where((m) => m.organizationId == org.id).firstOrNull;
                                  return _buildOtherOrgCard(context, ref, org, matchingMember);
                                }),
                              ],

                              const SizedBox(height: 24),
                              _buildInvitationsCalloutPanel(context),
                            ],
                          ),
                        const SizedBox(height: 48),

                        // Bottom Footer
                        const Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Text(
                              'Switch organizations anytime from the menu above.',
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                            Text(
                              'Your community, connected.',
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryWorkspaceCard(
    BuildContext context,
    WidgetRef ref,
    Organization org,
    OrganizationMember? member,
  ) {
    final role = member?.role;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF), // Subtle blue-tinted container
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2), width: 1.5),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.antiAlias,
                child: (org.logoUrl != null && org.logoUrl!.isNotEmpty)
                    ? Image.network(
                        FirebaseService.sanitizeStorageUrl(org.logoUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Center(
                          child: Icon(
                            org.type == 'academic' ? Icons.school_outlined : Icons.business_outlined,
                            color: AppTheme.primaryBlue,
                            size: 26,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          org.type == 'academic' ? Icons.school_outlined : Icons.business_outlined,
                          color: AppTheme.primaryBlue,
                          size: 26,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      org.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryNavy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${org.type[0].toUpperCase()}${org.type.substring(1)} · ${org.city}, ${org.country}',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (role != null) StatusBadge.role(role.value),
                        _buildOrgStatusBadge(org.status),
                        const Text(
                          'Current workspace',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildOrgPopupMenu(
                context: context,
                ref: ref,
                org: org,
                member: member,
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Divider(height: 1, color: AppTheme.borderLight),
          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 6,
            children: [
              const Text(
                'Explore your workspace',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.secondaryNavy),
              ),
              Text(
                'You\'re working in ${org.name}',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 6 Workspace Action Cards Grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionCard(context, 'Dashboard', 'Your workspace at a glance', Icons.grid_view_rounded, () => context.go('/orgs/dashboard')),
              _buildActionCard(context, 'Directory', 'Find people in your organization', Icons.people_outline_rounded, () => context.go('/orgs/members')),
              _buildActionCard(context, 'Departments', 'Explore teams and departments', Icons.account_tree_outlined, () => context.go('/orgs/departments')),
              _buildActionCard(context, 'Joining Codes', 'Manage access to your workspace', Icons.key_outlined, () => context.go('/orgs/joining-codes')),
              _buildActionCard(context, 'Branding', 'Shape your organization\'s identity', Icons.palette_outlined, () => context.go('/orgs/settings')),
              _buildActionCard(context, 'Activity', 'See what\'s happening here', Icons.show_chart_rounded, () => context.go('/orgs/audit')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth >= 600
            ? (constraints.maxWidth - 24) / 3
            : (constraints.maxWidth >= 360 ? (constraints.maxWidth - 12) / 2 : double.infinity);
        return SizedBox(
          width: cardWidth,
          child: _ActionCard(
            title: title,
            subtitle: subtitle,
            icon: icon,
            onTap: onTap,
          ),
        );
      },
    );
  }

  Widget _buildOtherOrgCard(
    BuildContext context,
    WidgetRef ref,
    Organization org,
    OrganizationMember? member,
  ) {
    return _OtherOrgCard(
      org: org,
      member: member,
      onSwitch: () {
        ref.read(activeOrgIdProvider.notifier).selectOrganization(org.id);
      },
    );
  }

  Widget _buildNoWorkspaceSelectedCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderLight, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.business_outlined,
              size: 32,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select an organization workspace to get started',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryNavy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose an organization from the list below to select your workspace and access its options.',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOneWorkspacePanel(BuildContext context, Organization? activeOrg) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.layers_outlined, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(height: 16),
          const Text('One workspace at a time.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.secondaryNavy)),
          const SizedBox(height: 8),
          const Text('Your directory, departments and activity follow your selected organization.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.borderLight),
          const SizedBox(height: 16),
          const Text('YOU\'RE CURRENTLY IN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textSecondary, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle, size: 16, color: AppTheme.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  activeOrg?.name ?? 'None',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.secondaryNavy),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationsCalloutPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.mail_outline_rounded, color: AppTheme.primaryBlue, size: 20),
          ),
          const SizedBox(height: 16),
          const Text('Invited to a workspace?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.secondaryNavy)),
          const SizedBox(height: 8),
          const Text('Review organization invitations sent to your account, all in one place.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/orgs/invitations'),
              icon: const Icon(Icons.east_rounded, size: 16),
              label: const Text('View invitations'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrgStatusBadge(OrganizationStatus status) {
    final value = status.value.toLowerCase();
    final String label;
    final IconData icon;
    final Color color;
    if (value == 'active' || value == 'verified') {
      label = 'VERIFIED';
      icon = Icons.verified_rounded;
      color = AppTheme.success;
    } else if (value == 'suspended') {
      label = 'SUSPENDED';
      icon = Icons.block_rounded;
      color = AppTheme.error;
    } else if (value == 'rejected') {
      label = 'REJECTED';
      icon = Icons.cancel_rounded;
      color = AppTheme.error;
    } else {
      label = 'PENDING VERIFICATION';
      icon = Icons.pending_rounded;
      color = AppTheme.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: (_isPressed && !isReducedMotion) ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            transform: (_isHovered && !_isPressed && !isReducedMotion)
                ? Matrix4.translationValues(0.0, -2.0, 0.0)
                : Matrix4.identity(),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isHovered ? AppTheme.primaryBlue.withValues(alpha: 0.4) : AppTheme.borderLight,
                width: _isHovered ? 1.4 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: _isHovered ? 0.06 : 0.02),
                  blurRadius: _isHovered ? 12 : 6,
                  offset: Offset(0, _isHovered ? 4 : 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      widget.icon,
                      color: AppTheme.primaryBlue,
                      size: 22,
                    ),
                    AnimatedSlide(
                      offset: (_isHovered && !isReducedMotion)
                          ? const Offset(0.15, -0.15)
                          : Offset.zero,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOutCubic,
                      child: const Icon(
                        Icons.north_east_rounded,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.secondaryNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildOrgPopupMenu({
  required BuildContext context,
  required WidgetRef ref,
  required Organization org,
  required OrganizationMember? member,
}) {
  final role = member?.role;
  final isOwner = role == OrganizationRole.owner;
  final isAdminOrOwner = role?.isAdmin ?? false;

  return PopupMenuButton<String>(
    icon: const Icon(Icons.more_horiz_rounded, color: AppTheme.textSecondary),
    tooltip: 'Show menu',
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    onSelected: (val) async {
      if (val == 'edit') {
        ref.read(activeOrgIdProvider.notifier).selectOrganization(org.id);
        context.go('/orgs/settings');
      } else if (val == 'leave') {
        await _confirmAndLeaveOrg(context, ref, org);
      } else if (val == 'delete') {
        await _confirmAndDeleteOrg(context, ref, org);
      }
    },
    itemBuilder: (context) => [
      if (isAdminOrOwner)
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: AppTheme.secondaryNavy),
              SizedBox(width: 10),
              Text('Edit organization'),
            ],
          ),
        ),
      const PopupMenuItem(
        value: 'leave',
        child: Row(
          children: [
            Icon(Icons.logout_rounded, size: 18, color: AppTheme.error),
            SizedBox(width: 10),
            Text('Leave organization', style: TextStyle(color: AppTheme.error)),
          ],
        ),
      ),
      if (isOwner)
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.error),
              SizedBox(width: 10),
              Text('Delete organization', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
    ],
  );
}

Future<void> _confirmAndLeaveOrg(
  BuildContext context,
  WidgetRef ref,
  Organization org,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Leave ${org.name}?'),
      content: Text('Are you sure you want to leave ${org.name}? You will lose access to this organization\'s workspace.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
          child: const Text('Leave Organization'),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  try {
    final repo = ref.read(organizationRepositoryProvider);
    await repo.leaveOrganization(organizationId: org.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Left ${org.name} successfully.')),
    );

    // Refresh user memberships & active org selection
    ref.invalidate(userMembershipsProvider);
    final activeOrgId = ref.read(activeOrgIdProvider);
    if (activeOrgId == org.id) {
      ref.read(activeOrgIdProvider.notifier).clearSelection();
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString().replaceAll('Exception: ', '')),
        backgroundColor: AppTheme.error,
      ),
    );
  }
}

Future<void> _confirmAndDeleteOrg(
  BuildContext context,
  WidgetRef ref,
  Organization org,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Delete ${org.name}?'),
      content: Text('Are you sure you want to delete ${org.name}? This action is permanent and will remove the workspace.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
          child: const Text('Delete Organization'),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  try {
    final repo = ref.read(organizationRepositoryProvider);
    await repo.deleteOrganization(organizationId: org.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Organization ${org.name} deleted.')),
    );

    // Refresh user memberships & active org selection
    ref.invalidate(userMembershipsProvider);
    final activeOrgId = ref.read(activeOrgIdProvider);
    if (activeOrgId == org.id) {
      ref.read(activeOrgIdProvider.notifier).clearSelection();
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString().replaceAll('Exception: ', '')),
        backgroundColor: AppTheme.error,
      ),
    );
  }
}

class _OtherOrgCard extends ConsumerStatefulWidget {
  const _OtherOrgCard({
    required this.org,
    required this.member,
    required this.onSwitch,
  });

  final Organization org;
  final OrganizationMember? member;
  final VoidCallback onSwitch;

  @override
  ConsumerState<_OtherOrgCard> createState() => _OtherOrgCardState();
}

class _OtherOrgCardState extends ConsumerState<_OtherOrgCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final role = widget.member?.role;
    final isReducedMotion = MediaQuery.of(context).disableAnimations;
    final isDesktop = ResponsiveLayout.isWide(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppTheme.primaryBlue.withValues(alpha: 0.3) : AppTheme.borderLight,
            width: _isHovered ? 1.4 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.04 : 0.0),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: (widget.org.logoUrl != null && widget.org.logoUrl!.isNotEmpty)
                      ? Image.network(
                          FirebaseService.sanitizeStorageUrl(widget.org.logoUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Icon(
                            widget.org.type == 'academic' ? Icons.school_outlined : Icons.business_outlined,
                            color: AppTheme.primaryBlue,
                            size: 22,
                          ),
                        )
                      : Icon(
                          widget.org.type == 'academic' ? Icons.school_outlined : Icons.business_outlined,
                          color: AppTheme.primaryBlue,
                          size: 22,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.org.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.secondaryNavy),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.org.type[0].toUpperCase()}${widget.org.type.substring(1)} · ${widget.org.city}, ${widget.org.country}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (role != null) StatusBadge.role(role.value),
                          _buildOrgStatusBadge(widget.org.status),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildOrgPopupMenu(
                  context: context,
                  ref: ref,
                  org: widget.org,
                  member: widget.member,
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: widget.onSwitch,
                    icon: AnimatedSlide(
                      offset: (_isHovered && !isReducedMotion) ? const Offset(0.15, 0) : Offset.zero,
                      duration: const Duration(milliseconds: 150),
                      child: const Icon(Icons.east_rounded, size: 16),
                    ),
                    label: Text(ref.watch(activeOrgIdProvider) == null ? 'Select workspace' : 'Switch organization'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ],
            ),
            if (!isDesktop) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onSwitch,
                  icon: const Icon(Icons.east_rounded, size: 16),
                  label: Text(ref.watch(activeOrgIdProvider) == null ? 'Select workspace' : 'Switch organization'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrgStatusBadge(OrganizationStatus status) {
    final value = status.value.toLowerCase();
    final String label;
    final IconData icon;
    final Color color;
    if (value == 'active' || value == 'verified') {
      label = 'VERIFIED';
      icon = Icons.verified_rounded;
      color = AppTheme.success;
    } else if (value == 'suspended') {
      label = 'SUSPENDED';
      icon = Icons.block_rounded;
      color = AppTheme.error;
    } else if (value == 'rejected') {
      label = 'REJECTED';
      icon = Icons.cancel_rounded;
      color = AppTheme.error;
    } else {
      label = 'PENDING VERIFICATION';
      icon = Icons.pending_rounded;
      color = AppTheme.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
