import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kivora/core/theme/kivora_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/ui_kit/kivora_button.dart';
import '../../../core/widgets/ui_kit/kivora_card.dart';
import '../../../core/widgets/ui_kit/kivora_metric_card.dart';
import '../../../core/widgets/ui_kit/kivora_election_card.dart';
import '../domain/organization_enums.dart';
import 'providers/organization_providers.dart';
import 'membership_directory_screen.dart' show organizationMembersDirectoryProvider;
import 'pending_invitations_widget.dart' show pendingInvitationsProvider;
import 'widgets/members_growth_chart.dart';
import '../../departments/presentation/providers/department_providers.dart';
import '../../voting_events/data/voting_event_repository.dart';
import '../../voting_events/domain/voting_event.dart';

class OrganizationDashboardScreen extends ConsumerWidget {
  const OrganizationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeOrganizationContextProvider);
    final kc = KivoraColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);

    return state.when(
      loading: () => const LoadingView(message: 'Loading workspace...'),
      error: (e, _) => ErrorView(type: ErrorViewType.generic, message: 'Failed to load organization: $e'),
      data: (orgState) {
        if (orgState.context == null) {
          return const Center(child: Text('No active organization.'));
        }

        final org = orgState.context!.organization;
        final member = orgState.context!.member;
        final isAdmin = member.role == OrganizationRole.owner || member.role == OrganizationRole.admin;
        
        final eventsArgs = (orgId: org.id, includeDrafts: isAdmin);
        final eventsAsync = ref.watch(organizationVotingEventsProvider(eventsArgs));
        final membersAsync = ref.watch(organizationMembersDirectoryProvider(org.id));
        final departmentsAsync = ref.watch(activeOrganizationDepartmentsProvider);
        final pendingInvitesAsync = ref.watch(pendingInvitationsProvider(org.id));

        final totalMembers = membersAsync.valueOrNull?.length;
        final totalDepartments = departmentsAsync.valueOrNull?.length;
        final activeEventCount = eventsAsync.valueOrNull
            ?.where((e) => e.status == VotingEventStatus.active)
            .length;
        final pendingInviteCount = pendingInvitesAsync.valueOrNull?.length;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activeOrganizationContextProvider);
            ref.invalidate(organizationVotingEventsProvider(eventsArgs));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktop ? 40 : 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (org.logoUrl != null)
                          Container(
                            width: 64,
                            height: 64,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(org.logoUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 64,
                            height: 64,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(KivoraIcons.building2, size: 28, color: AppTheme.primaryBlue),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                org.name,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: kc.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: member.role == OrganizationRole.owner 
                                          ? AppTheme.accentGold.withValues(alpha: 0.1)
                                          : AppTheme.primaryBlue.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      member.role.name.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: member.role == OrganizationRole.owner ? AppTheme.accentGold : AppTheme.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Joined ${org.createdAt.year}',
                                    style: TextStyle(fontSize: 13, color: kc.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isAdmin)
                          KivoraButton(
                            type: KivoraButtonType.secondary,
                            icon: KivoraIcons.settings,
                            label: 'Settings',
                            isExpanded: false,
                            onPressed: () => context.go('/orgs/settings'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    if (isDesktop)
                      Row(
                        children: [
                          Expanded(child: KivoraMetricCard(title: 'Total Members', value: totalMembers?.toString() ?? '—', icon: KivoraIcons.users)),
                          const SizedBox(width: 16),
                          Expanded(child: KivoraMetricCard(title: 'Departments', value: totalDepartments?.toString() ?? '—', icon: KivoraIcons.network, iconColor: AppTheme.accentGold)),
                          const SizedBox(width: 16),
                          Expanded(child: KivoraMetricCard(title: 'Active Events', value: activeEventCount?.toString() ?? '—', icon: KivoraIcons.vote, iconColor: AppTheme.accentTeal)),
                          const SizedBox(width: 16),
                          Expanded(child: KivoraMetricCard(title: 'Pending Invites', value: pendingInviteCount?.toString() ?? '—', icon: KivoraIcons.mail, iconColor: AppTheme.warning)),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: KivoraMetricCard(title: 'Total Members', value: totalMembers?.toString() ?? '—', icon: KivoraIcons.users)),
                              const SizedBox(width: 16),
                              Expanded(child: KivoraMetricCard(title: 'Departments', value: totalDepartments?.toString() ?? '—', icon: KivoraIcons.network, iconColor: AppTheme.accentGold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: KivoraMetricCard(title: 'Active Events', value: activeEventCount?.toString() ?? '—', icon: KivoraIcons.vote, iconColor: AppTheme.accentTeal)),
                              const SizedBox(width: 16),
                              Expanded(child: KivoraMetricCard(title: 'Pending Invites', value: pendingInviteCount?.toString() ?? '—', icon: KivoraIcons.mail, iconColor: AppTheme.warning)),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),
                    
                    if (isAdmin) ...[
                      MembersGrowthChart(organizationId: org.id),
                      const SizedBox(height: 24),
                    ],
                    isDesktop ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildEventsFeed(context, eventsAsync, isAdmin)),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: _buildQuickActions(context, isAdmin)),
                      ],
                    ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildQuickActions(context, isAdmin),
                        const SizedBox(height: 24),
                        _buildEventsFeed(context, eventsAsync, isAdmin),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isAdmin) {
    final kc = KivoraColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kc.textPrimary)),
        const SizedBox(height: 16),
        KivoraCard(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              if (isAdmin) ...[
                ListTile(
                  leading: const Icon(KivoraIcons.userPlus, color: AppTheme.primaryBlue),
                  title: const Text('Invite Members', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(KivoraIcons.chevronRight, size: 16),
                  onTap: () => context.go('/orgs/invitations'),
                ),
                ListTile(
                  leading: const Icon(KivoraIcons.qrCode, color: AppTheme.primaryBlue),
                  title: const Text('Joining Codes', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(KivoraIcons.chevronRight, size: 16),
                  onTap: () => context.go('/orgs/joining-codes'),
                ),
                ListTile(
                  leading: const Icon(KivoraIcons.plusSquare, color: AppTheme.primaryBlue),
                  title: const Text('Create Event', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(KivoraIcons.chevronRight, size: 16),
                  onTap: () => context.go('/admin/events/new'),
                ),
              ],
              ListTile(
                leading: const Icon(KivoraIcons.users, color: AppTheme.primaryBlue),
                title: const Text('Member Directory', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(KivoraIcons.chevronRight, size: 16),
                onTap: () => context.go('/orgs/members'),
              ),
              ListTile(
                leading: const Icon(KivoraIcons.network, color: AppTheme.primaryBlue),
                title: const Text('Departments', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(KivoraIcons.chevronRight, size: 16),
                onTap: () => context.go('/orgs/departments'),
              ),
              ListTile(
                leading: const Icon(KivoraIcons.history, color: AppTheme.primaryBlue),
                title: const Text('Audit Log', style: TextStyle(fontWeight: FontWeight.w600)),
                trailing: const Icon(KivoraIcons.chevronRight, size: 16),
                onTap: () => context.go('/orgs/audit'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventsFeed(BuildContext context, AsyncValue eventsAsync, bool isAdmin) {
    final kc = KivoraColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Upcoming & Active Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kc.textPrimary)),
            TextButton(
              onPressed: () => context.go('/admin/events'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        eventsAsync.when(
          loading: () => const LoadingView(message: 'Loading events...'),
          error: (e, _) => ErrorView(type: ErrorViewType.generic, message: 'Failed: $e'),
          data: (events) {
            if (events.isEmpty) {
              return KivoraCard(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(child: Text('No active events.', style: TextStyle(color: kc.textSecondary))),
                ),
              );
            }
            return Column(
              children: events.take(5).map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: KivoraElectionCard(event: e, isAdmin: isAdmin),
              )).toList(),
            );
          },
        ),
      ],
    );
  }
}
