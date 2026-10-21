import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../departments/presentation/providers/department_providers.dart';
import '../../voting_events/data/voting_event_repository.dart';
import '../../voting_events/domain/voting_event.dart';
import '../../voting_events/presentation/dashboard/event_card.dart';
import '../../voting_events/presentation/voter_portal_screen.dart' show AdaptiveCardGrid;
import '../domain/active_organization_context.dart';
import '../domain/organization_enums.dart';
import '../domain/overview_state.dart';
import 'membership_directory_screen.dart' show organizationMembersDirectoryProvider;
import 'organization_audit_screen.dart' show organizationAuditLogsProvider;
import 'pending_invitations_widget.dart' show pendingInvitationsProvider;
import '../../onboarding/presentation/setup_checklist_widget.dart';
import 'widgets/members_growth_chart.dart';

/// The single landing page for owners and admins. Replaces the former Home
/// dashboard, Organization Dashboard and (as an entry point) the Command
/// Center, which stays reachable from here and from Elections.
class AdminOverviewScreen extends ConsumerWidget {
  const AdminOverviewScreen({super.key, required this.orgContext});

  final ActiveOrganizationContext orgContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final org = orgContext.organization;
    final role = orgContext.member.role;
    final isOwner = role == OrganizationRole.owner;
    final isDesktop = ResponsiveLayout.isWide(context);

    final eventsArgs = (orgId: org.id, includeDrafts: true);
    final eventsAsync = ref.watch(organizationVotingEventsProvider(eventsArgs));
    final membersAsync = ref.watch(organizationMembersDirectoryProvider(org.id));
    final departmentsAsync = ref.watch(activeOrganizationDepartmentsProvider);
    final invitesAsync = ref.watch(pendingInvitationsProvider(org.id));

    MetricValue metric(AsyncValue<Object?> a, int? Function(Object?) count) =>
        metricFrom(hasValue: a.hasValue, hasError: a.hasError && !a.hasValue, count: a.hasValue ? count(a.value) : null);

    final events = eventsAsync.valueOrNull;
    final pendingInvites = invitesAsync.valueOrNull?.length;
    final actions = requiredActionsFor(events: events, pendingInvites: pendingInvites);

    final metrics = <(String, IconData, MetricValue)>[
      (l10n.overviewMetricMembers, Icons.groups_outlined,
          metric(membersAsync, (v) => (v as List?)?.length)),
      (l10n.overviewMetricLive, Icons.how_to_vote_outlined,
          metric(eventsAsync, (v) => (v as List<VotingEvent>?)?.where((e) => e.status == VotingEventStatus.active).length)),
      (l10n.overviewMetricUpcoming, Icons.event_outlined,
          metric(eventsAsync, (v) => (v as List<VotingEvent>?)?.where((e) => e.status == VotingEventStatus.scheduled).length)),
      (l10n.overviewMetricInvites, Icons.mail_outline_rounded,
          metric(invitesAsync, (v) => (v as List?)?.length)),
      (l10n.overviewMetricDepartments, Icons.apartment_outlined,
          metric(departmentsAsync, (v) => (v as List?)?.length)),
    ];

    final electionsSection = _ElectionsSection(eventsAsync: eventsAsync, onRetry: () => ref.invalidate(organizationVotingEventsProvider));
    final side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Shortcuts(isOwner: isOwner),
        const SizedBox(height: 24),
        MembersGrowthChart(organizationId: org.id),
        const SizedBox(height: 24),
        _ActivitySection(orgId: org.id),
      ],
    );

    return ColoredBox(
      color: kc.background,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(organizationVotingEventsProvider);
          ref.invalidate(organizationMembersDirectoryProvider(org.id));
          ref.invalidate(pendingInvitationsProvider(org.id));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(orgName: org.name, role: role, l10n: l10n),
                  const SizedBox(height: 24),
                  // Shows itself only to owners, only until it is complete or dismissed.
                  const SetupChecklistWidget(),
                  if (actions.isNotEmpty) ...[
                    _RequiredActions(actions: actions),
                    const SizedBox(height: 24),
                  ],
                  AdaptiveCardGrid(
                    minColumnWidth: 200,
                    children: [for (final m in metrics) _MetricTile(label: m.$1, icon: m.$2, value: m.$3)],
                  ),
                  const SizedBox(height: 32),
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: electionsSection),
                        const SizedBox(width: 24),
                        Expanded(child: side),
                      ],
                    )
                  else ...[
                    electionsSection,
                    const SizedBox(height: 24),
                    side,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bordered rounded surface that, unlike a DecoratedBox, lets ListTile ink show.
ShapeBorder _cardShape(KivoraColors kc) => RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      side: BorderSide(color: kc.border),
    );

class _Header extends StatelessWidget {
  const _Header({required this.orgName, required this.role, required this.l10n});
  final String orgName;
  final OrganizationRole role;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(orgName,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: kc.textPrimary)),
              ),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                StatusBadge.role(role.name),
                Text(l10n.overviewSubtitle, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              ]),
            ],
          ),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () => context.go('/admin/events/new'),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: Text(l10n.adminCreateElection),
        ),
      ],
    );
  }
}

class _RequiredActions extends StatelessWidget {
  const _RequiredActions({required this.actions});
  final List<RequiredAction> actions;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.warningText.withValues(alpha: kc.isDark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.warningText.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Row(children: [
              Icon(Icons.flag_outlined, color: kc.warningText, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(l10n.overviewRequiredTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kc.textPrimary)),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          for (final a in actions)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Text(
                    switch (a.kind) {
                      RequiredActionKind.finishDrafts => l10n.overviewFinishDrafts(a.count),
                      RequiredActionKind.reviewInvites => l10n.overviewReviewInvites(a.count),
                    },
                    style: TextStyle(fontSize: 14, color: kc.textPrimary),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                  onPressed: () => context.go(switch (a.kind) {
                    RequiredActionKind.finishDrafts => '/admin/events',
                    RequiredActionKind.reviewInvites => '/orgs/members',
                  }),
                  child: Text(switch (a.kind) {
                    RequiredActionKind.finishDrafts => l10n.overviewOpenElections,
                    RequiredActionKind.reviewInvites => l10n.overviewOpenPeople,
                  }),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.icon, required this.value});
  final String label;
  final IconData icon;
  final MetricValue value;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final text = switch (value) {
      MetricCount(:final count) => '$count',
      MetricUnavailable() => l10n.overviewUnavailable,
      MetricLoading() => '…',
    };
    final isNumber = value is MetricCount;
    return Semantics(
      container: true,
      label: '$label: ${value is MetricLoading ? l10n.overviewLoading : text}',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kc.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: kc.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: kc.accentText),
              const SizedBox(height: 12),
              Text(text,
                  style: TextStyle(
                      fontSize: isNumber ? 28 : 16,
                      fontWeight: FontWeight.w800,
                      color: isNumber ? kc.textPrimary : kc.textSecondary)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElectionsSection extends StatelessWidget {
  const _ElectionsSection({required this.eventsAsync, required this.onRetry});
  final AsyncValue<List<VotingEvent>> eventsAsync;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);

    Widget body = eventsAsync.when(
      loading: () => const Padding(
          padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator())),
      error: (_, __) => _Message(
        text: l10n.overviewElectionsError,
        action: TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: onRetry,
            child: Text(l10n.overviewRetry)),
      ),
      data: (events) {
        final featured = featuredElections(events);
        if (featured.isEmpty) {
          return _Message(text: '${l10n.overviewNoLive} ${l10n.overviewNoLiveBody}');
        }
        return AdaptiveCardGrid(
          minColumnWidth: 380,
          children: [for (final e in featured) EventCard(key: ValueKey(e.id), event: e)],
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(l10n.overviewElectionsTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kc.textPrimary)),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => context.go('/admin/events'),
            child: Text(l10n.overviewViewAll),
          ),
        ]),
        const SizedBox(height: 12),
        body,
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.action});
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(children: [
        Text(text, textAlign: TextAlign.center, style: TextStyle(color: kc.textSecondary)),
        if (action != null) action!,
      ]),
    );
  }
}

class _Shortcuts extends StatelessWidget {
  const _Shortcuts({required this.isOwner});
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final items = [
      (Icons.groups_outlined, l10n.overviewShortcutPeople, '/orgs/members'),
      (Icons.apartment_outlined, l10n.overviewShortcutDepartments, '/orgs/departments'),
      (Icons.qr_code_2_rounded, l10n.overviewShortcutCodes, '/orgs/joining-codes'),
      (Icons.mail_outline_rounded, l10n.overviewShortcutInvites, '/orgs/invitations'),
      (Icons.dashboard_customize_outlined, l10n.overviewShortcutCommand, '/admin/command-center'),
      if (isOwner) (Icons.tune_rounded, l10n.overviewShortcutSettings, '/orgs/settings'),
      if (isOwner) (Icons.credit_card_outlined, l10n.overviewShortcutBilling, '/plans'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.overviewShortcuts,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kc.textPrimary)),
        ),
        const SizedBox(height: 12),
        Material(
          color: kc.surface,
          clipBehavior: Clip.antiAlias,
          shape: _cardShape(kc),
          child: Column(children: [
            for (final (icon, label, path) in items)
              ListTile(
                minTileHeight: 48,
                leading: Icon(icon, color: kc.accentText),
                title: Text(label),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.go(path),
              ),
          ]),
        ),
      ],
    );
  }
}

class _ActivitySection extends ConsumerWidget {
  const _ActivitySection({required this.orgId});
  final String orgId;

  String _age(AppLocalizations l10n, Timestamp? stamp) {
    if (stamp == null) return '';
    final a = ageOf(DateTime.now().difference(stamp.toDate()));
    return switch (a.unit) {
      AgeUnit.justNow => l10n.overviewAgoNow,
      AgeUnit.minutes => l10n.overviewAgoMinutes(a.n),
      AgeUnit.hours => l10n.overviewAgoHours(a.n),
      AgeUnit.days => l10n.overviewAgoDays(a.n),
      AgeUnit.weeks => l10n.overviewAgoWeeks(a.n),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final logs = ref.watch(organizationAuditLogsProvider(orgId));

    Widget body = logs.when(
      loading: () => const Padding(
          padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      error: (_, __) => _Message(text: l10n.overviewActivityError),
      data: (snap) {
        final docs = snap.docs.take(4).toList();
        if (docs.isEmpty) return _Message(text: l10n.overviewNoActivity);
        return Material(
          color: kc.surface,
          clipBehavior: Clip.antiAlias,
          shape: _cardShape(kc),
          child: Column(children: [
            for (var i = 0; i < docs.length; i++) ...[
              if (i > 0) Divider(height: 1, color: kc.border),
              Builder(builder: (context) {
                final data = docs[i].data();
                final action = humanizeAuditAction(data['action'] as String? ?? '');
                return ListTile(
                  minTileHeight: 48,
                  leading: Icon(Icons.history_rounded, color: kc.accentText, size: 20),
                  title: Text(action.isEmpty ? l10n.overviewActivityUnknown : action),
                  subtitle: Text(_age(l10n, data['timestamp'] as Timestamp?)),
                );
              }),
            ],
          ]),
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(l10n.overviewActivityTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kc.textPrimary)),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => context.go('/orgs/audit'),
            child: Text(l10n.overviewViewAll),
          ),
        ]),
        const SizedBox(height: 12),
        body,
      ],
    );
  }
}
