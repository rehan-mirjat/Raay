import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/raay_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../organizations/domain/organization_enums.dart';
import '../../../organizations/presentation/providers/organization_providers.dart';
import '../../data/voting_event_repository.dart';
import '../../domain/voting_event.dart';
import '../providers/event_lifecycle_provider.dart';
import '../voter_portal_screen.dart';
import 'event_card.dart';

enum EventFilter { all, active, scheduled, draft, closed, archived }

extension EventFilterX on EventFilter {
  String label(AppLocalizations l10n) => switch (this) {
        EventFilter.all => l10n.adminFilterAll,
        EventFilter.active => l10n.adminFilterActive,
        EventFilter.scheduled => l10n.adminFilterScheduled,
        EventFilter.draft => l10n.adminFilterDraft,
        EventFilter.closed => l10n.adminFilterClosed,
        EventFilter.archived => l10n.adminFilterArchived,
      };

  /// Null means "no status filter" (All). Cancelled events have no chip but
  /// stay visible under All rather than being hidden.
  VotingEventStatus? get status => switch (this) {
        EventFilter.all => null,
        EventFilter.active => VotingEventStatus.active,
        EventFilter.scheduled => VotingEventStatus.scheduled,
        EventFilter.draft => VotingEventStatus.draft,
        EventFilter.closed => VotingEventStatus.closed,
        EventFilter.archived => VotingEventStatus.archived,
      };
}

/// Pure filter used by the screen (and tested directly).
List<VotingEvent> filterEvents(List<VotingEvent> events, EventFilter filter, String query) {
  final status = filter.status;
  final q = query.trim().toLowerCase();
  return events.where((e) {
    if (status != null && e.status != status) return false;
    if (q.isNotEmpty && !e.title.toLowerCase().contains(q)) return false;
    return true;
  }).toList();
}

class AdminEventDashboardScreen extends ConsumerStatefulWidget {
  const AdminEventDashboardScreen({super.key});

  @override
  ConsumerState<AdminEventDashboardScreen> createState() => _AdminEventDashboardScreenState();
}

class _AdminEventDashboardScreenState extends ConsumerState<AdminEventDashboardScreen> {
  EventFilter _filter = EventFilter.all;
  String _searchQuery = '';
  String? _organizationId;
  EventCursor? _after;
  final List<EventCursor?> _history = [];

  void _resetPage() { _after = null; _history.clear(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final orgContext = ref.watch(activeOrganizationContextProvider).valueOrNull?.context;

    if (orgContext == null) {
      return Scaffold(
        body: ErrorView(
          type: ErrorViewType.generic,
          title: l10n.adminOrgRequiredTitle,
          message: l10n.adminOrgRequiredBody,
        ),
      );
    }

    final orgId = orgContext.organization.id;
    if (_organizationId != orgId) { _organizationId = orgId; _resetPage(); _filter = EventFilter.all; _searchQuery = ''; }

    if (orgContext.organization.status == OrganizationStatus.suspended) {
      return Scaffold(
        body: ErrorView(
          type: ErrorViewType.generic,
          title: l10n.adminSuspendedTitle,
          message: l10n.adminSuspendedBody,
        ),
      );
    }

    if (!orgContext.member.role.isAdmin) {
      // Members share the "Elections" destination but see their own voter home.
      return const VoterPortalScreen(embedded: true);
    }

    // Stable provider: the stream is not recreated on rebuild, so typing in the
    // search box never flashes the loading state.
    final eventsAsync =
        ref.watch(organizationEventPageProvider((orgId: orgId, includeDrafts: true, status: _filter.status?.name.toUpperCase(), after: _after, size: 50)));
    final lifecycleState = ref.watch(eventLifecycleProvider);

    ref.listen<EventLifecycleState>(eventLifecycleProvider, (prev, next) {
      if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      backgroundColor: RaayColors.backgroundOf(context),
      body: Stack(
        children: [
          eventsAsync.when(
            loading: () => const LoadingView(),
            error: (_, __) => ErrorView(
              type: ErrorViewType.generic,
              message: l10n.adminLoadError,
              onRetry: () => ref.invalidate(organizationEventPageProvider),
            ),
            data: (page) => _buildBody(context, l10n, page),
          ),
          if (lifecycleState.isLoading)
            Positioned.fill(
              child: ColoredBox(
                color: RaayColors.backgroundOf(context).withValues(alpha: 0.8),
                child: LoadingView(message: l10n.adminProcessing),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, EventPage page) {
    final events = page.events;
    final kc = RaayColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);
    final filtered = filterEvents(events, _filter, _searchQuery);

    final header = Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(l10n.adminEventsTitle,
                    style: TextStyle(
                        fontSize: isDesktop ? 28 : 24,
                        fontWeight: FontWeight.bold,
                        color: kc.textPrimary)),
              ),
              const SizedBox(height: 4),
              Text(l10n.adminEventsSubtitle, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            ],
          ),
        ),
        Wrap(spacing: 12, runSpacing: 12, children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => context.go('/admin/command-center'),
            icon: const Icon(Icons.dashboard_customize_outlined, size: 18),
            label: Text(l10n.adminCommandCenter),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => context.go('/admin/events/new'),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(l10n.adminCreateElection),
          ),
        ]),
      ],
    );

    final List<Widget> content;
    if (events.isEmpty && _filter == EventFilter.all && _searchQuery.isEmpty && _after == null) {
      content = [_EmptyState(l10n: l10n)];
    } else {
      content = [
        _filters(context, l10n, events),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(l10n.adminNoMatch,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kc.textSecondary, fontSize: 14)),
            ),
          )
        else
          AdaptiveCardGrid(
            minColumnWidth: 420,
            children: [for (final e in filtered) EventCard(key: ValueKey(e.id), event: e)],
          ),
      ];
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 32 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [header, const SizedBox(height: 24), ...content,
              const SizedBox(height: 20), Text(l10n.eventPageScope), const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 8, children: [
                OutlinedButton(onPressed: _history.isEmpty ? null : () => setState(() { _after = _history.removeLast(); }), child: Text(l10n.orgReportPrevious)),
                OutlinedButton(onPressed: !page.hasMore || page.next == null ? null : () => setState(() { _history.add(_after); _after = page.next; }), child: Text(l10n.orgReportNext)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filters(BuildContext context, AppLocalizations l10n, List<VotingEvent> events) {
    final search = TextField(
      key: ValueKey('event-search-$_organizationId'),
      onChanged: (v) => setState(() => _searchQuery = v),
      decoration: InputDecoration(
        hintText: l10n.adminSearchEvents,
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
      ),
    );
    final chips = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final f in EventFilter.values)
          ChoiceChip(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            showCheckmark: true,
            label: Text(
                f.label(l10n)),
            selected: _filter == f,
            onSelected: (_) => setState(() { _filter = f; _resetPage(); }),
          ),
      ],
    );
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth >= 700) {
        return Row(children: [
          Expanded(child: chips),
          const SizedBox(width: 16),
          SizedBox(width: 280, child: search),
        ]);
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [search, const SizedBox(height: 12), chips]);
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final steps = [
      (Icons.tune_rounded, l10n.adminGuideTitle1, l10n.adminGuideBody1),
      (Icons.people_outline_rounded, l10n.adminGuideTitle2, l10n.adminGuideBody2),
      (Icons.rocket_launch_outlined, l10n.adminGuideTitle3, l10n.adminGuideBody3),
      (Icons.bar_chart_rounded, l10n.adminGuideTitle4, l10n.adminGuideBody4),
    ];
    return Column(
      children: [
        const SizedBox(height: 24),
        ExcludeSemantics(
            child: Icon(Icons.how_to_vote_outlined, size: 48, color: kc.accentText)),
        const SizedBox(height: 16),
        Text(l10n.adminNoEventsTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kc.textPrimary)),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(l10n.adminNoEventsBody,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.4, color: kc.textSecondary)),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () => context.go('/admin/events/new'),
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.adminCreateElection),
        ),
        const SizedBox(height: 32),
        AdaptiveCardGrid(
          minColumnWidth: 220,
          children: [
            for (final (icon, title, body) in steps)
              Container(
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
                    Icon(icon, color: kc.accentText, size: 22),
                    const SizedBox(height: 8),
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14, color: kc.textPrimary)),
                    const SizedBox(height: 4),
                    Text(body, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
