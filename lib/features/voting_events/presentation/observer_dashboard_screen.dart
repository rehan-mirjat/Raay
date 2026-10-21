import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/theme/kivora_icons.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../data/voting_event_repository.dart';
import '../domain/voting_event.dart';
import 'providers/command_center_providers.dart';

/// Package D3: a READ-ONLY dashboard for members with the Observer
/// capability (see setObserverStatus.ts / organization_member.dart). Every
/// data source here is something an Observer is explicitly allowed to see
/// per the spec - published results, status, lifecycle milestones, and
/// organization-wide (never per-department) aggregate turnout. No write
/// actions appear anywhere on this screen.
class ObserverDashboardScreen extends ConsumerWidget {
  const ObserverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final orgState = ref.watch(activeOrganizationContextProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Observer Dashboard', style: TextStyle(color: kc.textPrimary)),
        iconTheme: IconThemeData(color: kc.textPrimary),
        actions: [
          IconButton(
            tooltip: 'Trust & Transparency Center',
            icon: const Icon(Icons.verified_outlined),
            onPressed: () => context.go('/transparency'),
          ),
        ],
      ),
      body: orgState.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(type: ErrorViewType.generic, message: '$e'),
        data: (state) {
          final orgContext = state.context;
          if (orgContext == null) {
            return const EmptyView(
              icon: KivoraIcons.building,
              title: 'No active organization',
              message: 'Select an organization to view its observer dashboard.',
            );
          }
          if (!orgContext.member.isObserver) {
            return const EmptyView(
              icon: KivoraIcons.lock,
              title: 'Observer access required',
              message:
                  'This dashboard is only available to members granted observer access by an organization admin.',
            );
          }

          final orgId = orgContext.organization.id;
          final eventsArgs = (orgId: orgId, includeDrafts: false);
          final eventsAsync = ref.watch(organizationVotingEventsProvider(eventsArgs));

          return eventsAsync.when(
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(type: ErrorViewType.generic, message: '$e'),
            data: (events) {
              final sorted = [...events]..sort((a, b) => b.startAt.compareTo(a.startAt));
              final active = sorted.where((e) => e.status == VotingEventStatus.active).toList();
              final others = sorted.where((e) => e.status != VotingEventStatus.active).toList();

              if (sorted.isEmpty) {
                return const EmptyView(
                  icon: KivoraIcons.vote,
                  title: 'No elections yet',
                  message: 'There are no published elections in this organization yet.',
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(ResponsiveLayout.isWide(context) ? 32 : 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.visibility_outlined, color: AppTheme.primaryBlue),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'You have read-only Observer access to ${orgContext.organization.name}. You see organization-wide aggregates only, never individual ballots, voter identities, or per-department breakdowns.',
                                  style: TextStyle(fontSize: 12, color: kc.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (active.isNotEmpty) ...[
                          Text('Active Elections',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                          const SizedBox(height: 12),
                          ...active.map((e) => _ObserverEventTile(event: e)),
                          const SizedBox(height: 24),
                        ],
                        Text('Election Timeline',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                        const SizedBox(height: 12),
                        ...others.map((e) => _TimelineTile(event: e)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ObserverEventTile extends ConsumerWidget {
  const _ObserverEventTile({required this.event});
  final VotingEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final summaryAsync = ref.watch(eventMonitoringSummaryProvider(event.id));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(event.title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: kc.textPrimary)),
              ),
              StatusBadge.eventStatus(event.status.name),
            ],
          ),
          const SizedBox(height: 10),
          summaryAsync.when(
            loading: () => const LinearProgressIndicator(minHeight: 3),
            error: (_, __) => Text('Aggregate turnout unavailable',
                style: TextStyle(fontSize: 12, color: kc.textSecondary)),
            data: (summary) {
              if (summary == null) {
                return Text('Aggregate turnout unavailable',
                    style: TextStyle(fontSize: 12, color: kc.textSecondary));
              }
              final eligible = (summary['eligibleCount'] as num?)?.toInt() ?? 0;
              final voted = (summary['participationCount'] as num?)?.toInt() ?? 0;
              final percent = ((summary['turnoutPercent'] as num?)?.toDouble() ?? 0).clamp(0, 100);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: eligible == 0 ? 0 : (voted / eligible).clamp(0, 1),
                      minHeight: 6,
                      backgroundColor: kc.border,
                      color: AppTheme.success,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('$voted of $eligible eligible voters (${percent.toStringAsFixed(0)}%)',
                      style: TextStyle(fontSize: 12, color: kc.textSecondary)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.event});
  final VotingEvent event;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final format = DateFormat('MMM d, yyyy');
    final isResultsAvailable =
        event.status == VotingEventStatus.closed || event.status == VotingEventStatus.archived;

    return InkWell(
      onTap: isResultsAvailable ? () => context.go('/elections/${event.id}/results') : null,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(Icons.circle, size: 8, color: kc.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title,
                      style: TextStyle(fontWeight: FontWeight.w600, color: kc.textPrimary)),
                  Text('${format.format(event.startAt)} – ${format.format(event.endAt)}',
                      style: TextStyle(fontSize: 12, color: kc.textSecondary)),
                ],
              ),
            ),
            StatusBadge.eventStatus(event.status.name),
            if (isResultsAvailable) ...[
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 18, color: kc.textSecondary),
            ],
          ],
        ),
      ),
    );
  }
}
