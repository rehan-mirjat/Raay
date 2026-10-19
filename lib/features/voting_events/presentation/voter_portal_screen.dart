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
import '../../../services/auth_service.dart';
import '../../voting/data/participation_repository.dart';
import '../domain/voting_event.dart';
import 'providers/voter_portal_providers.dart';

enum _PortalFilter { all, active, upcoming, completed, participated, resultsAvailable }

extension on _PortalFilter {
  String get label => switch (this) {
        _PortalFilter.all => 'All',
        _PortalFilter.active => 'Active',
        _PortalFilter.upcoming => 'Upcoming',
        _PortalFilter.completed => 'Completed',
        _PortalFilter.participated => 'Participated',
        _PortalFilter.resultsAvailable => 'Results available',
      };
}

const _pageSize = 12;

/// Package A1: "My Voting Portal" - a cross-organization, filterable, search-
/// able view of every election the signed-in user can see, with the correct
/// action per election (Vote Now / View Details / View Receipt / View
/// Results / Upcoming). Used both as its own route and embedded for non-admin
/// members on the shared Events destination (see admin_event_dashboard_screen.dart).
class VoterPortalScreen extends StatelessWidget {
  const VoterPortalScreen({super.key, this.embedded = false});

  /// true when rendered inside another Scaffold (the shared /admin/events
  /// route for non-admins) - skips its own Scaffold/AppBar in that case.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final body = const _VoterPortalBody();
    if (embedded) return body;
    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      body: SafeArea(child: body),
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

  List<VoterPortalEntry> _applyFilters(
    List<VoterPortalEntry> entries,
    Map<String, bool> participationByEventId,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return entries.where((entry) {
      if (query.isNotEmpty) {
        final matches = entry.event.title.toLowerCase().contains(query) ||
            entry.organization.name.toLowerCase().contains(query);
        if (!matches) return false;
      }

      final hasVoted = participationByEventId[entry.event.id] ?? false;

      switch (_filter) {
        case _PortalFilter.all:
          return true;
        case _PortalFilter.active:
          return entry.event.status == VotingEventStatus.active;
        case _PortalFilter.upcoming:
          return entry.event.status == VotingEventStatus.scheduled;
        case _PortalFilter.completed:
          return entry.event.status == VotingEventStatus.closed ||
              entry.event.status == VotingEventStatus.archived;
        case _PortalFilter.participated:
          return hasVoted;
        case _PortalFilter.resultsAvailable:
          return (entry.event.status == VotingEventStatus.closed ||
              entry.event.status == VotingEventStatus.archived);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final entriesAsync = ref.watch(voterPortalEntriesProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(voterPortalEntriesProvider),
      child: entriesAsync.when(
        loading: () => const LoadingView(message: 'Loading your elections...'),
        error: (err, _) => ErrorView(
          type: ErrorViewType.generic,
          message: 'Could not load your elections: $err',
          onRetry: () => ref.invalidate(voterPortalEntriesProvider),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 420,
                child: EmptyView(
                  icon: KivoraIcons.vote,
                  title: 'No elections yet',
                  message:
                      'Elections you\'re eligible for across your organizations will show up here.',
                ),
              ),
            );
          }

          // Participation status for every visible event, fetched once up
          // front so filtering by "Participated" works without each card
          // running its own query.
          final participationAsync = ref.watch(_bulkParticipationProvider);
          final participationMap = participationAsync.valueOrNull ?? const {};

          final filtered = _applyFilters(entries, participationMap);
          final visible = filtered.take(_visibleCount).toList();
          final isDesktop = ResponsiveLayout.isWide(context);

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktop ? 32 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Elections',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: kc.textPrimary)),
                          const SizedBox(height: 4),
                          Text(
                              'Every election you can see across your organizations, in one place.',
                              style: TextStyle(
                                  fontSize: 14, color: kc.textSecondary)),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.go('/calendar'),
                      icon: const Icon(KivoraIcons.calendar, size: 18),
                      label: const Text('Calendar'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search by election title or organization...',
                    prefixIcon: const Icon(KivoraIcons.search),
                    filled: true,
                    fillColor: kc.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: kc.border),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _PortalFilter.values.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final f = _PortalFilter.values[i];
                      final selected = f == _filter;
                      return ChoiceChip(
                        label: Text(f.label),
                        selected: selected,
                        onSelected: (_) => setState(() {
                          _filter = f;
                          _visibleCount = _pageSize;
                        }),
                        selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                        labelStyle: TextStyle(
                          color: selected ? AppTheme.primaryBlue : kc.textSecondary,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                            color: selected ? AppTheme.primaryBlue : kc.border),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: EmptyView(
                      icon: KivoraIcons.search,
                      title: 'No matching elections',
                      message: 'Try a different search term or filter.',
                    ),
                  )
                else ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop
                          ? (ResponsiveLayout.isMedium(context) ? 2 : 3)
                          : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 1.15 : 1.9,
                    ),
                    itemCount: visible.length,
                    itemBuilder: (context, i) => _ElectionCard(
                      entry: visible[i],
                      hasVoted: participationMap[visible[i].event.id] ?? false,
                    ),
                  ),
                  if (_visibleCount < filtered.length) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: OutlinedButton(
                        onPressed: () =>
                            setState(() => _visibleCount += _pageSize),
                        child: Text(
                            'Load more (${filtered.length - _visibleCount} remaining)'),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Batches participation lookups for every visible card into one provider so
/// filtering by "Participated" doesn't require N independent round trips
/// before the list can even be filtered.
final _bulkParticipationProvider =
    FutureProvider.autoDispose<Map<String, bool>>((ref) async {
  final uid = ref.watch(authServiceProvider).currentUser?.uid;
  if (uid == null) return {};
  final entries = await ref.watch(voterPortalEntriesProvider.future);
  if (entries.isEmpty) return {};

  final repo = ref.watch(participationRepositoryProvider);
  final results = await Future.wait(entries.map((e) async {
    final voted =
        await repo.hasUserVoted(e.organization.id, e.event.id, uid);
    return MapEntry(e.event.id, voted);
  }));
  return Map.fromEntries(results);
});

class _ElectionCard extends StatelessWidget {
  const _ElectionCard({required this.entry, required this.hasVoted});

  final VoterPortalEntry entry;
  final bool hasVoted;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final event = entry.event;
    final format = DateFormat('MMM d, yyyy - h:mm a');

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kc.textPrimary)),
              ),
              StatusBadge.eventStatus(event.status.name),
            ],
          ),
          const SizedBox(height: 4),
          Text(entry.organization.name,
              style: TextStyle(fontSize: 12, color: kc.textSecondary)),
          const SizedBox(height: 2),
          Text(event.votingType.label,
              style: TextStyle(fontSize: 11, color: kc.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.schedule, size: 13, color: kc.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${format.format(event.startAt)} → ${format.format(event.endAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: kc.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (!entry.isLikelyEligible)
                _miniBadge(context, 'Not eligible', AppTheme.textSecondary),
              if (hasVoted) _miniBadge(context, 'Participated', AppTheme.success),
            ],
          ),
          const Spacer(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: _buildAction(context),
          ),
        ],
      ),
    );
  }

  Widget _miniBadge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildAction(BuildContext context) {
    final event = entry.event;

    switch (event.status) {
      case VotingEventStatus.scheduled:
        return OutlinedButton.icon(
          onPressed: () => context.go('/elections/${event.id}'),
          icon: const Icon(Icons.hourglass_top_rounded, size: 16),
          label: const Text('Upcoming'),
        );
      case VotingEventStatus.active:
        if (!entry.isLikelyEligible) {
          return OutlinedButton(
            onPressed: () => context.go('/elections/${event.id}'),
            child: const Text('View Details'),
          );
        }
        if (hasVoted) {
          return ElevatedButton.icon(
            onPressed: () => context.go('/elections/${event.id}'),
            icon: const Icon(Icons.receipt_long_rounded, size: 16),
            label: const Text('View Receipt'),
          );
        }
        return ElevatedButton(
          onPressed: () => context.go('/elections/${event.id}/vote'),
          child: const Text('Vote Now'),
        );
      case VotingEventStatus.closed:
      case VotingEventStatus.archived:
        return ElevatedButton.icon(
          onPressed: () => context.go('/elections/${event.id}/results'),
          icon: const Icon(Icons.bar_chart_rounded, size: 16),
          label: const Text('View Results'),
        );
      case VotingEventStatus.cancelled:
      case VotingEventStatus.draft:
        return OutlinedButton(
          onPressed: () => context.go('/elections/${event.id}'),
          child: const Text('View Details'),
        );
    }
  }
}
