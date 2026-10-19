import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kivora/core/theme/kivora_icons.dart';

import '../theme/app_theme.dart';
import '../theme/kivora_colors.dart';
import '../layout/responsive.dart';
import '../widgets/ui_kit/kivora_button.dart';
import '../widgets/ui_kit/kivora_card.dart';
import '../widgets/ui_kit/kivora_metric_card.dart';
import '../widgets/ui_kit/kivora_election_card.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../services/auth_service.dart';
import '../../features/organizations/domain/organization_enums.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../features/voting_events/data/voting_event_repository.dart';
import '../../features/voting_events/domain/voting_event.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final activeContextState = ref.watch(activeOrganizationContextProvider);
    final user = ref.watch(authServiceProvider).currentUser;

    return activeContextState.when(
      loading: () => const LoadingView(message: 'Loading dashboard...'),
      error: (e, _) => ErrorView(
        type: ErrorViewType.generic,
        message: 'Failed to load dashboard: $e',
        onRetry: () => ref.invalidate(activeOrganizationContextProvider),
      ),
      data: (orgState) {
        if (orgState.selectionState ==
                ActiveOrgSelectionState.noOrganizations ||
            orgState.context == null) {
          return const _EmptyPlatformWelcome();
        }

        final orgContext = orgState.context!;
        final isAdmin = orgContext.member.role == OrganizationRole.owner ||
            orgContext.member.role == OrganizationRole.admin;
        final eventsArgs = (orgId: orgContext.organization.id, includeDrafts: isAdmin);
        final eventsAsync = ref.watch(organizationVotingEventsProvider(eventsArgs));

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(activeOrganizationContextProvider);
            ref.invalidate(organizationVotingEventsProvider(eventsArgs));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(ResponsiveLayout.isWide(context) ? 40 : 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeHeader(context, user?.displayName ?? 'User'),
                    const SizedBox(height: 32),
                    _buildMetricsRow(context, orgContext.organization.name),
                    const SizedBox(height: 32),
                    ResponsiveLayout.isWide(context)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildEventsFeed(context, eventsAsync, isAdmin),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 1,
                                child: _buildRecentActivityFeed(context),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildEventsFeed(context, eventsAsync, isAdmin),
                              const SizedBox(height: 24),
                              _buildRecentActivityFeed(context),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, String name) {
    final kc = KivoraColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back, ${name.split(' ').first}! 👋',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: kc.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Here is what\'s happening across your organization today.',
          style: TextStyle(
            fontSize: 15,
            color: kc.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsRow(BuildContext context, String orgName) {
    final isDesktop = ResponsiveLayout.isWide(context);
    
    final metrics = [
      KivoraMetricCard(
        title: 'Active Context',
        value: orgName.length > 15 ? '${orgName.substring(0, 15)}...' : orgName,
        icon: KivoraIcons.building,
        subtitle: 'Workspace',
      ),
      const KivoraMetricCard(
        title: 'Live Elections',
        value: '3',
        icon: KivoraIcons.vote,
        subtitle: 'Requires action',
        iconColor: AppTheme.accentTeal,
      ),
      const KivoraMetricCard(
        title: 'Pending Invites',
        value: '2',
        icon: KivoraIcons.mail,
        subtitle: 'Review',
        iconColor: AppTheme.warning,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: metrics.map((m) => Expanded(child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: m,
        ))).toList(),
      );
    } else {
      return Column(
        children: metrics.map((m) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: m,
        )).toList(),
      );
    }
  }

  Widget _buildEventsFeed(BuildContext context, AsyncValue<List<VotingEvent>> eventsAsync, bool isAdmin) {
    final kc = KivoraColors.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming & Active Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kc.textPrimary,
              ),
            ),
            if (isAdmin)
              TextButton(
                onPressed: () => context.go('/admin/events/new'),
                child: const Text('Create Event'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        eventsAsync.when(
          loading: () => const LoadingView(message: 'Loading events...'),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (events) {
            final activeEvents = events.where((e) => e.status == VotingEventStatus.active || e.status == VotingEventStatus.scheduled).toList();
            if (activeEvents.isEmpty) {
              return KivoraCard(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(KivoraIcons.calendarX, size: 48, color: kc.textSecondary),
                        const SizedBox(height: 16),
                        Text(
                          'No active events',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kc.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'There are no ongoing elections in this organization.',
                          style: TextStyle(color: kc.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: activeEvents.map((event) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: KivoraElectionCard(
                  event: event,
                  isAdmin: isAdmin,
                ),
              )).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivityFeed(BuildContext context) {
    final kc = KivoraColors.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kc.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/orgs/audit'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        KivoraCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _buildActivityRow(context, 'You joined the organization', '2 hours ago', KivoraIcons.userCheck),
              const Divider(height: 1),
              _buildActivityRow(context, 'New event scheduled: Board Election', '4 hours ago', KivoraIcons.calendar),
              const Divider(height: 1),
              _buildActivityRow(context, 'Results published for Department Head', '1 day ago', KivoraIcons.barChart2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityRow(BuildContext context, String action, String time, IconData icon) {
    final kc = KivoraColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppTheme.primaryBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kc.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: kc.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPlatformWelcome extends ConsumerWidget {
  const _EmptyPlatformWelcome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: KivoraCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(KivoraIcons.building2, size: 48, color: AppTheme.primaryBlue),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Kivora',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: kc.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You are not currently a member of any organization. Join an existing workspace or create a new one to begin participating in secure elections.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: kc.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              KivoraButton(
                icon: KivoraIcons.plus,
                label: 'Create Organization',
                onPressed: () => context.go('/orgs/create'),
              ),
              const SizedBox(height: 12),
              KivoraButton(
                type: KivoraButtonType.secondary,
                icon: KivoraIcons.logIn,
                label: 'Join via Code',
                onPressed: () => context.go('/orgs/join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
