import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../../../core/widgets/global_search_overlay.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/ui_kit/kivora_metric_card.dart';
import 'voter_portal_screen.dart' show AdaptiveCardGrid;
import '../../organizations/domain/organization_enums.dart';
import '../../organizations/presentation/membership_directory_screen.dart'
    show organizationMembersDirectoryProvider;
import '../../organizations/presentation/organization_audit_screen.dart'
    show organizationAuditLogsProvider;
import '../../organizations/presentation/organization_context_switcher.dart';
import '../../organizations/presentation/pending_invitations_widget.dart'
    show pendingInvitationsProvider;
import '../../organizations/presentation/providers/organization_providers.dart';
import '../data/voting_event_repository.dart';
import '../domain/voting_event.dart';
import 'dashboard/event_card.dart';
import 'providers/command_center_providers.dart';
import 'utils/events_csv_export.dart';

/// Package B1: an integrated operational view of elections, distinct from
/// OrganizationDashboardScreen (a general org home) - this is scoped
/// specifically to election operations and reuses EventCard (with all its
/// existing per-status actions) rather than re-implementing event rows.
class ElectionCommandCenterScreen extends ConsumerStatefulWidget {
  const ElectionCommandCenterScreen({super.key});

  @override
  ConsumerState<ElectionCommandCenterScreen> createState() =>
      _ElectionCommandCenterScreenState();
}

class _ElectionCommandCenterScreenState
    extends ConsumerState<ElectionCommandCenterScreen> {
  DateTimeRange? _dateRange;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  @override
  Widget build(BuildContext context) {
    final orgState = ref.watch(activeOrganizationContextProvider);

    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      body: orgState.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          type: ErrorViewType.generic,
          message: 'We could not load the command center. Check your connection and try again.',
          onRetry: () => ref.invalidate(activeOrganizationContextProvider),
        ),
        data: (state) {
          final orgContext = state.context;
          if (orgContext == null) {
            return const EmptyView(
              icon: KivoraIcons.building,
              title: 'No active organization',
              message: 'Select an organization to view its command center.',
            );
          }
          if (!orgContext.member.role.isAdmin) {
            return const EmptyView(
              icon: KivoraIcons.lock,
              title: 'Administrator access required',
              message: 'The election command center is available to organization owners and admins.',
            );
          }

          final orgId = orgContext.organization.id;
          final eventsArgs = (orgId: orgId, includeDrafts: true);
          final eventsAsync = ref.watch(organizationVotingEventsProvider(eventsArgs));
          final membersAsync = ref.watch(organizationMembersDirectoryProvider(orgId));
          final pendingInvitesAsync = ref.watch(pendingInvitationsProvider(orgId));
          final auditAsync = ref.watch(organizationAuditLogsProvider(orgId));

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(organizationVotingEventsProvider(eventsArgs));
              ref.invalidate(organizationMembersDirectoryProvider(orgId));
              ref.invalidate(pendingInvitationsProvider(orgId));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(ResponsiveLayout.isWide(context) ? 32 : 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(context,
                          orgContext.organization.status == OrganizationStatus.suspended),
                      const SizedBox(height: 24),
                      eventsAsync.when(
                        loading: () => const LoadingView(),
                        error: (e, _) => ErrorView(
                          type: ErrorViewType.generic,
                          message: 'We could not load elections. Check your connection and try again.',
                          onRetry: () => ref.invalidate(organizationVotingEventsProvider),
                        ),
                        data: (events) => _buildBody(
                          context,
                          events,
                          membersAsync.valueOrNull?.length,
                          pendingInvitesAsync.valueOrNull?.length,
                          auditAsync.valueOrNull,
                          orgContext.organization.name,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool orgSuspended) {
    final kc = KivoraColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Semantics(
              header: true,
              child: Text('Election Command Center',
                  style: TextStyle(
                      fontSize: isDesktop ? 26 : 22,
                      fontWeight: FontWeight.bold,
                      color: kc.textPrimary)),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                IconButton(
                  tooltip: 'Search',
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: const Icon(KivoraIcons.search),
                  onPressed: () => showGlobalSearch(context),
                ),
                IconButton(
                  tooltip: 'Filter by date range',
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: const Icon(Icons.date_range_outlined),
                  onPressed: _pickDateRange,
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                  onPressed: () => context.go('/admin/events/new'),
                  icon: const Icon(KivoraIcons.plus, size: 18),
                  label: const Text('Create election'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            const OrganizationContextSwitcher(),
            if (_dateRange != null)
              Chip(
                label: Text(
                    '${DateFormat.yMMMd().format(_dateRange!.start)} - ${DateFormat.yMMMd().format(_dateRange!.end)}'),
                onDeleted: () => setState(() => _dateRange = null),
              ),
          ],
        ),
        if (orgSuspended) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kc.errorText.withValues(alpha: kc.isDark ? 0.14 : 0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusInput),
              border: Border.all(color: kc.errorText.withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: kc.errorText),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This organization is suspended. Election management is disabled until it is reinstated.',
                    style: TextStyle(color: kc.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<VotingEvent> allEvents,
    int? totalMembers,
    int? pendingInvites,
    dynamic auditSnapshot,
    String organizationName,
  ) {
    final isDesktop = ResponsiveLayout.isWide(context);

    final filteredByDate = _dateRange == null
        ? allEvents
        : allEvents
            .where((e) =>
                !e.startAt.isBefore(_dateRange!.start) &&
                !e.startAt.isAfter(_dateRange!.end.add(const Duration(days: 1))))
            .toList();

    final active = filteredByDate.where((e) => e.status == VotingEventStatus.active).toList();
    final scheduled = filteredByDate.where((e) => e.status == VotingEventStatus.scheduled).toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
    final drafts = filteredByDate.where((e) => e.status == VotingEventStatus.draft).toList();
    final closed = filteredByDate
        .where((e) => e.status == VotingEventStatus.closed || e.status == VotingEventStatus.archived)
        .toList();

    final misconfigured = filteredByDate.where((e) =>
        (e.status == VotingEventStatus.scheduled || e.status == VotingEventStatus.active) &&
        e.eligibilityType != EligibilityType.allMembers &&
        e.eligibilityDepartmentIds.isEmpty &&
        e.eligibilityUserIds.isEmpty);

    final statsRow = AdaptiveCardGrid(
      minColumnWidth: 200,
      children: _statCards(allEvents, active, scheduled, closed, totalMembers),
    );

    final leftPanels = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _panelCard(
          context,
          title: 'Active Election Monitoring',
          icon: Icons.sensors_rounded,
          child: active.isEmpty
              ? _emptyPanelText(context, 'No elections are currently active.')
              : Column(children: active.map((e) => _ActiveEventTile(event: e)).toList()),
        ),
        const SizedBox(height: 20),
        _panelCard(
          context,
          title: 'Upcoming Election Schedule',
          icon: Icons.schedule_rounded,
          child: scheduled.isEmpty
              ? _emptyPanelText(context, 'No elections are scheduled.')
              : Column(children: scheduled.take(5).map((e) => EventCard(event: e)).toList()),
        ),
      ],
    );

    final rightPanels = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (misconfigured.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _panelCard(
              context,
              title: 'Alerts',
              icon: Icons.warning_amber_rounded,
              accentColor: KivoraColors.of(context).errorText,
              child: Column(
                children: misconfigured
                    .map((e) => _AlertTile(
                          text: '"${e.title}" has no eligible voters configured.',
                          onTap: () => context.go('/admin/events/${e.id}/edit'),
                        ))
                    .toList(),
              ),
            ),
          ),
        _panelCard(
          context,
          title: 'Pending Administrative Tasks',
          icon: Icons.checklist_rounded,
          child: (drafts.isEmpty && (pendingInvites ?? 0) == 0)
              ? _emptyPanelText(context, 'No pending tasks. You\'re all caught up.')
              : Column(
                  children: [
                    for (final d in drafts)
                      _AlertTile(
                        text: '"${d.title}" is still a draft and needs review before publishing.',
                        onTap: () => context.go('/admin/events/${d.id}/review'),
                      ),
                    if ((pendingInvites ?? 0) > 0)
                      _AlertTile(
                        text: pendingInvites == 1 ? '1 invitation is awaiting a response.' : '$pendingInvites invitations are awaiting a response.',
                        onTap: () => context.go('/orgs/members'),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 20),
        _panelCard(
          context,
          title: 'Membership & Invitations',
          icon: Icons.groups_rounded,
          child: Column(
            children: [
              _summaryRow(context, 'Total members', totalMembers?.toString() ?? '—',
                  () => context.go('/orgs/members')),
              _summaryRow(context, 'Pending invitations', pendingInvites?.toString() ?? '—',
                  () => context.go('/orgs/members')),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _panelCard(
          context,
          title: 'Recent Administrative Activity',
          icon: Icons.history_rounded,
          child: _buildRecentActivity(context, auditSnapshot),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: filteredByDate.isEmpty
                ? null
                : () => exportEventsReportCsv(filteredByDate, organizationName),
            icon: const Icon(Icons.file_download_outlined, size: 18),
            label: const Text('Export report (CSV)'),
          ),
        ),
        statsRow,
        const SizedBox(height: 24),
        isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: leftPanels),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: rightPanels),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [leftPanels, const SizedBox(height: 20), rightPanels],
              ),
      ],
    );
  }

  List<Widget> _statCards(
    List<VotingEvent> all,
    List<VotingEvent> active,
    List<VotingEvent> scheduled,
    List<VotingEvent> closed,
    int? totalMembers,
  ) {
    return [
      KivoraMetricCard(
          title: 'Total Elections', value: '${all.length}', icon: KivoraIcons.vote),
      KivoraMetricCard(
          title: 'Active', value: '${active.length}', icon: Icons.sensors_rounded, iconColor: AppTheme.success),
      KivoraMetricCard(
          title: 'Scheduled', value: '${scheduled.length}', icon: Icons.schedule_rounded, iconColor: AppTheme.accentGold),
      KivoraMetricCard(
          title: 'Closed', value: '${closed.length}', icon: Icons.task_alt_rounded, iconColor: AppTheme.textSecondary),
      KivoraMetricCard(
          title: 'Members',
          value: totalMembers?.toString() ?? '—',
          icon: KivoraIcons.users,
          subtitle: 'All organization members',
          iconColor: AppTheme.secondaryBlue),
    ];
  }

  Widget _buildRecentActivity(BuildContext context, dynamic auditSnapshot) {
    final kc = KivoraColors.of(context);
    if (auditSnapshot == null) return _emptyPanelText(context, 'No recent activity.');
    final docs = (auditSnapshot.docs as List).take(6).toList();
    if (docs.isEmpty) return _emptyPanelText(context, 'No recent activity.');

    String titleCase(String raw) {
      final words = raw.replaceAll('_', ' ').toLowerCase().split(' ');
      return words.map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
    }

    return Column(
      children: docs.map<Widget>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final action = titleCase(data['action'] as String? ?? 'Admin action');
        final ts = data['timestamp'];
        final date = ts is Timestamp ? ts.toDate() : null;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.circle, size: 6, color: kc.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(action,
                    style: TextStyle(fontSize: 13, color: kc.textPrimary)),
              ),
              if (date != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  child: Text(DateFormat.MMMd().add_jm().format(date),
                      style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value, VoidCallback onTap) {
    final kc = KivoraColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: kc.textSecondary))),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: kc.textPrimary)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 20, color: kc.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _emptyPanelText(BuildContext context, String text) {
    final kc = KivoraColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(text, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
    );
  }

  Widget _panelCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    Color? accentColor,
  }) {
    final kc = KivoraColors.of(context);
    final color = accentColor ?? AppTheme.primaryBlue;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              Icon(icon, size: 20, color: color == AppTheme.primaryBlue ? kc.accentText : color),
              const SizedBox(width: 8),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16, color: kc.textPrimary)),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.arrow_right_rounded, size: 22, color: kc.warningText),
              const SizedBox(width: 6),
              Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: kc.textPrimary))),
            ],
          ),
        ),
      ),
    );
  }
}

/// An active election's live turnout strip, backed by the same
/// getEventMonitoring callable as the full monitoring screen.
class _ActiveEventTile extends ConsumerWidget {
  const _ActiveEventTile({required this.event});
  final VotingEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final summaryAsync = ref.watch(eventMonitoringSummaryProvider(event.id));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: KivoraColors.backgroundOf(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(event.title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: kc.textPrimary)),
              ),
              TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: () => context.go('/admin/events/${event.id}/monitor'),
                child: const Text('Monitor'),
              ),
            ],
          ),
          summaryAsync.when(
            loading: () => const LinearProgressIndicator(minHeight: 3),
            error: (_, __) => Text('Live turnout unavailable',
                style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            data: (summary) {
              if (summary == null) {
                return Text('Live turnout unavailable',
                    style: TextStyle(fontSize: 12, color: kc.textSecondary));
              }
              final eligible = (summary['eligibleCount'] as num?)?.toInt() ?? 0;
              final voted = (summary['participationCount'] as num?)?.toInt() ?? 0;
              final percent = ((summary['turnoutPercent'] as num?)?.toDouble() ?? 0).clamp(0, 100);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: eligible == 0 ? 0 : (voted / eligible).clamp(0, 1),
                      minHeight: 6,
                      backgroundColor: kc.border,
                      color: kc.successText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('$voted of $eligible voted (${percent.toStringAsFixed(0)}%)',
                      style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
