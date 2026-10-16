import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../domain/organization.dart';
import '../domain/organization_enums.dart';
import '../domain/organization_member.dart';
import 'providers/organization_providers.dart';
import 'membership_directory_screen.dart';
import 'pending_invitations_widget.dart';
import '../../departments/presentation/providers/department_providers.dart';
import '../../voting_events/data/voting_event_repository.dart';
import '../../voting_events/domain/voting_event.dart';
import 'organization_audit_screen.dart';

class OrganizationDashboardScreen extends ConsumerWidget {
  const OrganizationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeOrganizationContextProvider);
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(title: const Text('Organization dashboard')),
      body: state.when(
        loading: () => const LoadingView(message: 'Loading organization…'),
        error: (error, _) => ErrorView(
          type: ErrorViewType.generic,
          message: 'Could not load the active organization: $error',
          onRetry: () => ref.invalidate(activeOrganizationContextProvider),
        ),
        data: (active) {
          final org = active.context?.organization;
          final member = active.context?.member;
          if (org == null || member == null) {
            return const ErrorView(
              type: ErrorViewType.organizationRequired,
              title: 'No active organization',
              message:
                  'Choose an organization to open its administration dashboard.',
            );
          }
          if (!member.isAdmin) {
            return const ErrorView(
              type: ErrorViewType.accessDenied,
              title: 'Access denied',
              message:
                  'This dashboard is available to the organization Owner and Admins.',
            );
          }

          final isWide = ResponsiveLayout.isWide(context);

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: ListView(
                padding: EdgeInsets.all(isWide ? 28 : 16),
                children: [
                  _buildHeader(context, org, member),
                  const SizedBox(height: 24),
                  _buildMetricsRow(context, ref, org.id),
                  const SizedBox(height: 32),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: _buildLeftColumn(context, org, member),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 4,
                          child: _buildRightColumn(context, ref, org),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLeftColumn(context, org, member),
                        const SizedBox(height: 32),
                        _buildRightColumn(context, ref, org),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, Organization org, OrganizationMember member) {
    final user = FirebaseAuth.instance.currentUser;
    final bool phoneVerified =
        user?.phoneNumber != null && user!.phoneNumber!.isNotEmpty;
    final bool emailVerified = user?.emailVerified ?? false;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.surfaceBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              org.type == 'academic'
                  ? Icons.school_outlined
                  : Icons.business_outlined,
              color: AppTheme.primaryBlue,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(org.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryNavy)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusBadge.role(member.role.value),
                    if (phoneVerified)
                      _buildPillBadge('Phone verified', AppTheme.success)
                    else if (emailVerified)
                      _buildPillBadge('Email verified', AppTheme.success),
                  ],
                ),
              ],
            ),
          ),
          if (ResponsiveLayout.isWide(context)) ...[
            OutlinedButton.icon(
              onPressed: () => context.go('/orgs/members'),
              icon: const Icon(Icons.person_add_outlined, size: 18),
              label: const Text('Invite members'),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () => context.go('/admin/events/new'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create voting event'),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ] else ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.person_add_outlined,
                      color: AppTheme.primaryBlue),
                  onPressed: () => context.go('/orgs/members'),
                ),
                IconButton(
                  icon: const Icon(Icons.add_box_rounded,
                      color: AppTheme.primaryBlue),
                  onPressed: () => context.go('/admin/events/new'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPillBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMetricsRow(BuildContext context, WidgetRef ref, String orgId) {
    final isWide = ResponsiveLayout.isWide(context);
    final isTablet = ResponsiveLayout.isMedium(context);

    return LayoutBuilder(builder: (context, constraints) {
      final columns = isWide ? 4 : (isTablet ? 2 : 1);
      const spacing = 16.0;
      final width = (constraints.maxWidth - (columns - 1) * spacing) / columns;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          SizedBox(
              width: width,
              child: _buildStatCard(context, ref, 'MEMBERS', orgId)),
          SizedBox(
              width: width,
              child: _buildStatCard(context, ref, 'ACTIVE EVENTS', orgId)),
          SizedBox(
              width: width,
              child:
                  _buildStatCard(context, ref, 'PENDING INVITATIONS', orgId)),
          SizedBox(
              width: width,
              child: _buildStatCard(context, ref, 'DEPARTMENTS', orgId)),
        ],
      );
    });
  }

  Widget _buildStatCard(
      BuildContext context, WidgetRef ref, String title, String orgId) {
    return Consumer(builder: (context, ref, _) {
      String value = '-';
      String subtitle = 'Loading...';

      if (title == 'MEMBERS') {
        final state = ref.watch(organizationMembersDirectoryProvider(orgId));
        value = state.maybeWhen(
            data: (d) => d.length.toString(), orElse: () => '-');
        subtitle = 'Total accounts';
      } else if (title == 'ACTIVE EVENTS') {
        return StreamBuilder<List<VotingEvent>>(
            stream: ref
                .watch(votingEventRepositoryProvider)
                .watchOrganizationVotingEvents(orgId),
            builder: (ctx, snap) {
              final count = snap.hasData
                  ? snap.data!
                      .where((e) => e.status == VotingEventStatus.active)
                      .length
                      .toString()
                  : '-';
              return _StatCardLayout(
                  title: title, value: count, subtitle: 'Ongoing events');
            });
      } else if (title == 'PENDING INVITATIONS') {
        final state = ref.watch(pendingInvitationsProvider(orgId));
        value = state.maybeWhen(
            data: (d) => d.length.toString(), orElse: () => '-');
        subtitle = 'Awaiting response';
      } else if (title == 'DEPARTMENTS') {
        final state = ref.watch(activeOrganizationDepartmentsProvider);
        value = state.maybeWhen(
            data: (d) => d.length.toString(), orElse: () => '-');
        subtitle = 'Active groups';
      }

      return _StatCardLayout(title: title, value: value, subtitle: subtitle);
    });
  }

  Widget _buildLeftColumn(
      BuildContext context, Organization org, OrganizationMember member) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionGroup(
          context,
          title: 'PEOPLE',
          items: [
            _SectionItem(
                'Members & invitations',
                'Manage members and review invitations.',
                Icons.people_outline_rounded,
                '/orgs/members'),
            _SectionItem(
                'Joining codes',
                'Create, review and revoke access codes.',
                Icons.key_outlined,
                '/orgs/joining-codes'),
            _SectionItem('Departments', 'Organize members into groups.',
                Icons.domain_outlined, '/orgs/departments'),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionGroup(
          context,
          title: 'ELECTIONS',
          items: [
            _SectionItem(
                'Voting events',
                'Create events and monitor participation.',
                Icons.how_to_vote_outlined,
                '/admin/events'),
          ],
        ),
        const SizedBox(height: 32),
        _buildSectionGroup(
          context,
          title: 'GOVERNANCE',
          items: [
            _SectionItem('Activity log', 'Review administrative changes.',
                Icons.history_rounded, '/orgs/audit'),
            if (member.role == OrganizationRole.owner)
              _SectionItem(
                  'Organization branding',
                  'Update name, logo and colors.',
                  Icons.palette_outlined,
                  '/orgs/settings'),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionGroup(BuildContext context,
      {required String title, required List<_SectionItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  InkWell(
                    onTap: () => context.go(item.route),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(idx == 0 ? 16 : 0),
                      bottom: Radius.circular(idx == items.length - 1 ? 16 : 0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item.icon,
                                color: AppTheme.primaryBlue, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: AppTheme.secondaryNavy)),
                                const SizedBox(height: 4),
                                Text(item.description,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppTheme.textSecondary, size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (idx < items.length - 1)
                    const Divider(
                        height: 1, color: AppTheme.borderLight, indent: 76),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn(
      BuildContext context, WidgetRef ref, Organization org) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLiveEventCard(context, ref, org),
        const SizedBox(height: 24),
        _buildAccountSecurityCard(),
        const SizedBox(height: 24),
        _buildRecentActivityCard(context, ref, org),
      ],
    );
  }

  Widget _buildLiveEventCard(
      BuildContext context, WidgetRef ref, Organization org) {
    return StreamBuilder<List<VotingEvent>>(
        stream: ref
            .watch(votingEventRepositoryProvider)
            .watchOrganizationVotingEvents(org.id),
        builder: (ctx, snap) {
          final activeEvents = snap.data
                  ?.where((e) => e.status == VotingEventStatus.active)
                  .toList() ??
              [];
          final hasLive = activeEvents.isNotEmpty;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('LIVE EVENT',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.8)),
                    if (hasLive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text('Active',
                            style: TextStyle(
                                color: AppTheme.success,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (hasLive) ...[
                  Text(activeEvents.first.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.secondaryNavy),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context
                        .go('/admin/events/${activeEvents.first.id}/monitor'),
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44)),
                    child: const Text('Monitor participation'),
                  ),
                ] else ...[
                  const Text('No live events at the moment.',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ],
            ),
          );
        });
  }

  Widget _buildAccountSecurityCard() {
    final user = FirebaseAuth.instance.currentUser;
    final emailVerified = user?.emailVerified ?? false;
    final phoneVerified =
        user?.phoneNumber != null && user!.phoneNumber!.isNotEmpty;

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
          const Text('ACCOUNT SECURITY',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8)),
          const SizedBox(height: 16),
          _buildSecurityItem(
              emailVerified ? 'Email verified' : 'Email not verified',
              emailVerified),
          if (phoneVerified) _buildSecurityItem('Phone number verified', true),
          _buildSecurityItem('Secure account session', true),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(String text, bool isSecure) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
              isSecure
                  ? Icons.check_circle_outline_rounded
                  : Icons.warning_amber_rounded,
              color: isSecure ? AppTheme.success : AppTheme.warning,
              size: 18),
          const SizedBox(width: 12),
          Text(text,
              style:
                  const TextStyle(fontSize: 13, color: AppTheme.secondaryNavy)),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard(
      BuildContext context, WidgetRef ref, Organization org) {
    return Consumer(builder: (context, ref, child) {
      final logsAsync = ref.watch(organizationAuditLogsProvider(org.id));

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('RECENT ACTIVITY',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                        letterSpacing: 0.8)),
                InkWell(
                  onTap: () => context.go('/orgs/audit'),
                  child: const Text('View all',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            logsAsync.when(
              loading: () => const LoadingView(),
              error: (_, __) => const Text('Could not load activity.',
                  style:
                      TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              data: (snapshot) {
                final logs = snapshot.docs;
                if (logs.isEmpty) {
                  return const Text('No recent activity.',
                      style: TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary));
                }
                return Column(
                  children: logs.take(3).map((doc) {
                    final data = doc.data();
                    final action = (data['action'] as String? ?? 'ADMIN_ACTION')
                        .replaceAll('_', ' ')
                        .toLowerCase();
                    final actionFormatted =
                        '${action[0].toUpperCase()}${action.substring(1)}';
                    final stamp = data['timestamp'];
                    final dateStr = stamp is Timestamp
                        ? DateFormat('MMM d, h:mm a')
                            .format(stamp.toDate().toLocal())
                        : '';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: AppTheme.primaryBlue,
                                shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(actionFormatted,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppTheme.secondaryNavy)),
                                const SizedBox(height: 2),
                                Text(dateStr,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

class _StatCardLayout extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _StatCardLayout(
      {required this.title, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
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
          Text(title,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryNavy,
                  height: 1.0)),
          const SizedBox(height: 8),
          Text(subtitle,
              style:
                  const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _SectionItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  _SectionItem(this.title, this.description, this.icon, this.route);
}
