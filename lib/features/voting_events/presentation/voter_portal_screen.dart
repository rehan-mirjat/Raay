import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../core/theme/raay_icons.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/hero_banner.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/election_card_state.dart';
import '../domain/voting_event.dart';
import 'portal_grouping.dart';
import 'providers/voter_portal_providers.dart';
import 'voter_election_card.dart';

enum _PortalFilter {
  all,
  ready,
  upcoming,
  participated,
  closed,
  resultsPublished
}

const _pageSize = 12;

/// The voter home ("My elections"): every election the signed-in user can see
/// across their organizations, grouped by what they can do next. Used as its
/// own route and embedded for non-admin members on the shared Events
/// destination (see admin_event_dashboard_screen.dart).
class VoterPortalScreen extends StatelessWidget {
  const VoterPortalScreen({super.key, this.embedded = false});

  /// true when rendered inside another Scaffold: skips its own Scaffold.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    const body = _VoterPortalBody();
    if (embedded) {
      return ColoredBox(color: RaayColors.backgroundOf(context), child: body);
    }
    return Scaffold(
      backgroundColor: RaayColors.backgroundOf(context),
      body: const SafeArea(child: body),
    );
  }
}

class _VoterPortalBody extends ConsumerStatefulWidget {
  const _VoterPortalBody();

  @override
  ConsumerState<_VoterPortalBody> createState() => _VoterPortalBodyState();
}

class _VoterPortalBodyState extends ConsumerState<_VoterPortalBody> {
  _PortalFilter _filter = _PortalFilter.all;
  final _searchController = TextEditingController();
  int _visibleCount = _pageSize;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _label(AppLocalizations l10n, _PortalFilter f) => switch (f) {
        _PortalFilter.all => l10n.voterFilterAll,
        _PortalFilter.ready => l10n.voterFilterReady,
        _PortalFilter.upcoming => l10n.voterFilterUpcoming,
        _PortalFilter.participated => l10n.voterFilterParticipated,
        _PortalFilter.closed => l10n.voterFilterClosed,
        _PortalFilter.resultsPublished => l10n.voterFilterResults,
      };

  List<VoterPortalEntry> _applyFilters(
    List<VoterPortalEntry> entries,
    Map<String, ParticipationStatus> participation,
    Map<String, ResultsStatus> results,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return entries.where((entry) {
      if (query.isNotEmpty &&
          !entry.event.title.toLowerCase().contains(query) &&
          !entry.organization.name.toLowerCase().contains(query)) {
        return false;
      }
      final id = entry.event.id;
      final p = participation[id] ?? ParticipationStatus.unknown;
      final finished = entry.event.status == VotingEventStatus.closed ||
          entry.event.status == VotingEventStatus.archived;
      switch (_filter) {
        case _PortalFilter.all:
          return true;
        case _PortalFilter.ready:
          return entry.event.status == VotingEventStatus.active &&
              entry.isLikelyEligible &&
              p != ParticipationStatus.voted;
        case _PortalFilter.upcoming:
          return entry.event.status == VotingEventStatus.scheduled;
        case _PortalFilter.participated:
          return p == ParticipationStatus.voted;
        case _PortalFilter.closed:
          return finished;
        case _PortalFilter.resultsPublished:
          return finished && results[id] == ResultsStatus.published;
      }
    }).toList();
  }

  void _refresh() {
    ref.invalidate(voterPortalEntriesProvider);
    ref.invalidate(participationStatusesProvider);
    ref.invalidate(resultsStatusesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(voterPortalEntriesProvider);

    return RefreshIndicator(
      onRefresh: () async => _refresh(),
      child: entriesAsync.when(
        loading: () => const LoadingView(),
        error: (err, _) => ErrorView(
          type: ErrorViewType.generic,
          message: l10n.voterLoadError,
          onRetry: _refresh,
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 420,
                child: EmptyView(
                  icon: RaayIcons.vote,
                  title: l10n.voterNoElectionsTitle,
                  message: l10n.voterNoElectionsBody,
                ),
              ),
            );
          }
          return _buildList(context, l10n, entries);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, AppLocalizations l10n,
      List<VoterPortalEntry> entries) {
    final participationAsync = ref.watch(participationStatusesProvider);
    final resultsAsync = ref.watch(resultsStatusesProvider);
    // Loading or failed lookups leave the map empty -> every event reads as
    // "unknown", never as "not voted" or "results pending".
    final participation =
        participationAsync.valueOrNull ?? const <String, ParticipationStatus>{};
    final results = resultsAsync.valueOrNull ?? const <String, ResultsStatus>{};
    final hasUnknowns = participationAsync.hasError ||
        resultsAsync.hasError ||
        participation.values.contains(ParticipationStatus.unknown) ||
        results.values.contains(ResultsStatus.unknown);

    final filtered = _applyFilters(entries, participation, results);
    final grouped =
        _filter == _PortalFilter.all && _searchController.text.trim().isEmpty;
    final isDesktop = ResponsiveLayout.isWide(context);

    Widget cardFor(VoterPortalEntry e) => VoterElectionCard(
          entry: e,
          participation:
              participation[e.event.id] ?? ParticipationStatus.unknown,
          results: results[e.event.id] ?? ResultsStatus.unknown,
        );

    final groups = participationAsync.hasValue
        ? groupPortalEntries(entries, participation)
        : null;
    final ready = groups?[PortalSection.ready] ?? const <VoterPortalEntry>[];
    final firstName = ref.watch(greetingNameProvider);

    final children = <Widget>[
      HeroBanner(
        eyebrow: l10n.voterHomeTitle,
        title:
            firstName == null ? l10n.vpWelcome : l10n.vpWelcomeNamed(firstName),
        // Only claim something about the user's elections once participation is
        // known; before that the subtitle stays neutral.
        subtitle: groups == null
            ? l10n.voterHomeSubtitle
            : ready.isEmpty
                ? l10n.vpAllCaughtUp
                : (ready.length == 1
                    ? l10n.vpReadyOne
                    : l10n.vpReadyMany(ready.length.toString())),
        actions: [
          if (ready.isNotEmpty)
            HeroAction(
              label: l10n.vpOpenFirst,
              icon: Icons.how_to_vote_rounded,
              onPressed: () => context.go('/elections/${ready.first.event.id}'),
            ),
          HeroAction(
            filled: ready.isEmpty,
            label: l10n.voterCalendar,
            icon: RaayIcons.calendar,
            onPressed: () => context.go('/calendar'),
          ),
        ],
      ),
      const SizedBox(height: 16),
      // Counts come from the same grouping the list below uses. While the
      // participation lookup has not answered they show a dash, never a guess.
      Builder(builder: (context) {
        final groups = participationAsync.hasValue
            ? groupPortalEntries(entries, participation)
            : null;
        int? n(PortalSection s) => groups?[s]!.length;
        return StatTileRow(tiles: [
          StatTile(
              label: l10n.voterSectionReady, value: n(PortalSection.ready)),
          StatTile(
              label: l10n.voterSectionUpcoming,
              value: n(PortalSection.upcoming)),
          StatTile(
              label: l10n.voterSectionParticipated,
              value: n(PortalSection.participated)),
          StatTile(
              label: l10n.voterSectionOther, value: n(PortalSection.other)),
        ]);
      }),
      const SizedBox(height: 16),
      TextField(
        controller: _searchController,
        onChanged: (_) => setState(() => _visibleCount = _pageSize),
        decoration: InputDecoration(
          hintText: l10n.voterSearchHint,
          prefixIcon: const Icon(RaayIcons.search),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _PortalFilter.values.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final f = _PortalFilter.values[i];
            final selected = f == _filter;
            return Center(
              child: ChoiceChip(
                label: Text(_label(l10n, f)),
                selected: selected,
                showCheckmark: true,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onSelected: (_) => setState(() {
                  _filter = f;
                  _visibleCount = _pageSize;
                }),
              ),
            );
          },
        ),
      ),
      if (hasUnknowns) ...[
        const SizedBox(height: 12),
        _WarningBanner(
            message: l10n.voterStatusWarning,
            retryLabel: l10n.voterRetry,
            onRetry: _refresh),
      ],
      const SizedBox(height: 16),
    ];

    if (filtered.isEmpty) {
      children.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: EmptyView(
          icon: RaayIcons.search,
          title: l10n.voterNoMatchTitle,
          message: l10n.voterNoMatchBody,
        ),
      ));
    } else if (grouped) {
      final sections = groupPortalEntries(filtered, participation);
      var remaining = _visibleCount;
      for (final section in PortalSection.values) {
        final items = sections[section]!;
        if (items.isEmpty || remaining <= 0) continue;
        final shown = items.take(remaining).toList();
        remaining -= shown.length;
        children
          ..add(_SectionHeader(
            title: switch (section) {
              PortalSection.ready => l10n.voterSectionReady,
              PortalSection.upcoming => l10n.voterSectionUpcoming,
              PortalSection.participated => l10n.voterSectionParticipated,
              PortalSection.other => l10n.voterSectionOther,
            },
            count: items.length,
          ))
          ..add(AdaptiveCardGrid(children: shown.map(cardFor).toList()))
          ..add(const SizedBox(height: 24));
      }
    } else {
      children
        ..add(AdaptiveCardGrid(
            children: filtered.take(_visibleCount).map(cardFor).toList()))
        ..add(const SizedBox(height: 24));
    }

    if (_visibleCount < filtered.length) {
      children.add(Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () => setState(() => _visibleCount += _pageSize),
          child: Text(
              '${l10n.voterLoadMore} (${filtered.length - _visibleCount})'),
        ),
      ));
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(isDesktop ? 32 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        header: true,
        child: Text('$title ($count)',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kc.textPrimary)),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner(
      {required this.message, required this.retryLabel, required this.onRetry});
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kc.warningText.withValues(alpha: kc.isDark ? 0.16 : 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kc.warningText.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: kc.warningText),
          const SizedBox(width: 12),
          Expanded(
              child: Text(message,
                  style: TextStyle(fontSize: 14, color: kc.textPrimary))),
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: onRetry,
            child: Text(retryLabel),
          ),
        ],
      ),
    );
  }
}

/// Lays cards out in 1..3 equal-width columns chosen from the width this
/// widget actually receives (so the shell's sidebar/rail is accounted for).
/// Card heights follow their content; there is no fixed aspect ratio.
class AdaptiveCardGrid extends StatelessWidget {
  const AdaptiveCardGrid(
      {super.key,
      required this.children,
      this.minColumnWidth = 340,
      this.gap = 16});

  final List<Widget> children;
  final double minColumnWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = ResponsiveLayout.columnsFor(constraints.maxWidth,
          minColumnWidth: minColumnWidth, gap: gap);
      final itemWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final c in children) SizedBox(width: itemWidth, child: c)
        ],
      );
    });
  }
}
