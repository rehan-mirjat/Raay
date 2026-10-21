import 'package:flutter/material.dart';
import '../../../features/billing/ads/ad_banner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/theme/kivora_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import 'voter_election_card.dart' show formatDeadline;
import 'providers/voter_portal_providers.dart';
import 'utils/ics_export.dart';

DateTime _dayKey(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// Places each election on every local day it is open. A span is capped so a
/// mistakenly huge window cannot freeze the calendar with thousands of days.
Map<DateTime, List<VoterPortalEntry>> groupEntriesByDay(List<VoterPortalEntry> entries,
    {int maxSpanDays = 92}) {
  final map = <DateTime, List<VoterPortalEntry>>{};
  for (final entry in entries) {
    final start = _dayKey(entry.event.startAt);
    var end = _dayKey(entry.event.endAt);
    if (end.isBefore(start)) end = start;
    final cap = start.add(Duration(days: maxSpanDays));
    if (end.isAfter(cap)) end = cap;
    for (var d = start; !d.isAfter(end); d = DateTime(d.year, d.month, d.day + 1)) {
      map.putIfAbsent(d, () => []).add(entry);
    }
  }
  return map;
}

/// Package A2: a responsive election calendar built entirely on top of the
/// voter portal's already-fetched cross-organization event list (A1) - no
/// separate scheduling data model, since VotingEvent.startAt/endAt is already
/// everything a calendar needs.
class ElectionCalendarScreen extends ConsumerStatefulWidget {
  const ElectionCalendarScreen({super.key});

  @override
  ConsumerState<ElectionCalendarScreen> createState() =>
      _ElectionCalendarScreenState();
}

class _ElectionCalendarScreenState
    extends ConsumerState<ElectionCalendarScreen> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = _dayKey(DateTime.now());
  String? _orgFilter; // null = all organizations
  bool _agendaView = false;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(voterPortalEntriesProvider);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: kc.background,
      bottomNavigationBar: const AdBanner(),
      appBar: AppBar(
        backgroundColor: kc.background,
        elevation: 0,
        title: Text(l10n.calTitle,
            style: TextStyle(color: kc.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: kc.textPrimary),
        actions: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            tooltip: _agendaView ? l10n.calCalendarView : l10n.calAgendaView,
            icon: Icon(_agendaView ? Icons.calendar_month_rounded : Icons.view_agenda_rounded),
            onPressed: () => setState(() => _agendaView = !_agendaView),
          ),
        ],
      ),
      body: entriesAsync.when(
        loading: () => const LoadingView(),
        error: (_, __) => ErrorView(
          type: ErrorViewType.generic,
          message: l10n.calLoadError,
          onRetry: () => ref.invalidate(voterPortalEntriesProvider),
        ),
        data: (allEntries) {
          final orgNames = {
            for (final e in allEntries) e.organization.id: e.organization.name
          };
          final entries = _orgFilter == null
              ? allEntries
              : allEntries.where((e) => e.organization.id == _orgFilter).toList();
          final byDay = groupEntriesByDay(entries);
          final selectedEvents = byDay[_selectedDay] ?? const [];

          final orgFilterRow = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _orgChip(context, null, l10n.calAllOrgs),
                  const SizedBox(width: 8),
                  for (final id in orgNames.keys) ...[
                    _orgChip(context, id, orgNames[id]!),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          );

          if (_agendaView) {
            return Column(
              children: [
                orgFilterRow,
                Expanded(child: _buildAgendaList(context, entries)),
              ],
            );
          }

          final calendar = _buildCalendar(context, byDay);

          if (isDesktop) {
            return Column(
              children: [
                orgFilterRow,
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: calendar),
                      Container(width: 1, color: kc.border),
                      Expanded(
                        flex: 2,
                        child: _buildDetailPanel(context, selectedEvents),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Compact: one scroll view so a tall calendar (large text) never
          // overflows; the day's elections follow the calendar.
          return SingleChildScrollView(
            child: Column(
              children: [
                orgFilterRow,
                calendar,
                _buildDetailPanel(context, selectedEvents, shrink: true),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _orgChip(BuildContext context, String? id, String label) {
    final selected = _orgFilter == id;
    final kc = KivoraColors.of(context);
    return Center(
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: true,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onSelected: (_) => setState(() => _orgFilter = id),
        labelStyle: TextStyle(
          color: selected ? kc.accentText : kc.textPrimary,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCalendar(
      BuildContext context, Map<DateTime, List<VoterPortalEntry>> byDay) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    return TableCalendar<VoterPortalEntry>(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
      focusedDay: _focusedDay,
      currentDay: DateTime.now(),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _format,
      locale: Localizations.localeOf(context).toString(),
      availableCalendarFormats: {
        CalendarFormat.month: l10n.calMonth,
        CalendarFormat.week: l10n.calWeek,
      },
      eventLoader: (day) => byDay[_dayKey(day)] ?? const [],
      startingDayOfWeek: StartingDayOfWeek.monday,
      onFormatChanged: (format) => setState(() => _format = format),
      onPageChanged: (focusedDay) => _focusedDay = focusedDay,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = _dayKey(selectedDay);
          _focusedDay = focusedDay;
        });
      },
      headerStyle: HeaderStyle(
        formatButtonShowsNext: false,
        titleTextStyle: TextStyle(
            color: kc.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
        formatButtonTextStyle: TextStyle(color: kc.accentText),
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: kc.accentText),
          borderRadius: BorderRadius.circular(8),
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: kc.textPrimary),
        rightChevronIcon: Icon(Icons.chevron_right, color: kc.textPrimary),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: kc.textSecondary),
        weekendStyle: TextStyle(color: kc.textSecondary),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyle(color: kc.textPrimary),
        weekendTextStyle: TextStyle(color: kc.textPrimary),
        selectedDecoration: BoxDecoration(color: primary, shape: BoxShape.circle),
        selectedTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
        todayDecoration: BoxDecoration(
            color: primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: kc.accentText)),
        todayTextStyle: TextStyle(color: kc.textPrimary, fontWeight: FontWeight.bold),
        markerDecoration: BoxDecoration(color: kc.accentText, shape: BoxShape.circle),
        markersMaxCount: 3,
      ),
    );
  }

  Widget _buildAgendaList(BuildContext context, List<VoterPortalEntry> entries) {
    final sorted = [...entries]
      ..sort((a, b) => a.event.startAt.compareTo(b.event.startAt));
    if (sorted.isEmpty) {
      final l10n = AppLocalizations.of(context);
      return EmptyView(
        icon: KivoraIcons.calendar,
        title: l10n.calNoneTitle,
        message: l10n.calNoneBody,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _AgendaCard(entry: sorted[i]),
    );
  }

  Widget _buildDetailPanel(BuildContext context, List<VoterPortalEntry> selectedEvents,
      {bool shrink = false}) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    String dayLabel;
    try {
      dayLabel = DateFormat.yMMMMEEEEd(locale).format(_selectedDay);
    } catch (_) {
      dayLabel = DateFormat.yMMMMEEEEd('en').format(_selectedDay);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(dayLabel,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kc.textPrimary)),
          ),
          const SizedBox(height: 4),
          Text(l10n.calCount(selectedEvents.length),
              style: TextStyle(fontSize: 14, color: kc.textSecondary)),
          const SizedBox(height: 16),
          if (shrink)
            (selectedEvents.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: EmptyView(
                      icon: KivoraIcons.calendar,
                      title: l10n.calNoDayTitle,
                      message: l10n.calNoDayBody,
                    ),
                  )
                : Column(children: [
                    for (final e in selectedEvents) ...[
                      _AgendaCard(entry: e),
                      const SizedBox(height: 10),
                    ],
                  ]))
          else
            Expanded(
              child: selectedEvents.isEmpty
                  ? EmptyView(
                      icon: KivoraIcons.calendar,
                      title: l10n.calNoDayTitle,
                      message: l10n.calNoDayBody,
                    )
                  : ListView.separated(
                      itemCount: selectedEvents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _AgendaCard(entry: selectedEvents[i]),
                    ),
            ),
        ],
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({required this.entry});

  final VoterPortalEntry entry;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final event = entry.event;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kc.textPrimary)),
          const SizedBox(height: 4),
          Text(entry.organization.name, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [StatusBadge.eventStatus(event.status.name)]),
          const SizedBox(height: 8),
          Text(
            l10n.calRange(formatDeadline(context, event.startAt), formatDeadline(context, event.endAt)),
            style: TextStyle(fontSize: 14, color: kc.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 4, children: [
            TextButton.icon(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => context.go('/elections/${event.id}'),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(l10n.calDetails),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => exportVotingEventToCalendar(event, entry.organization.name),
              icon: const Icon(Icons.event_available_outlined, size: 18),
              label: Text(l10n.calAdd),
            ),
          ]),
        ],
      ),
    );
  }
}
