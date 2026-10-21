import 'package:flutter/material.dart';
import '../../../features/billing/ads/ad_banner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/theme/kivora_icons.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import 'providers/voter_portal_providers.dart';
import 'utils/ics_export.dart';

DateTime _dayKey(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

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

  Map<DateTime, List<VoterPortalEntry>> _groupByDay(
      List<VoterPortalEntry> entries) {
    final map = <DateTime, List<VoterPortalEntry>>{};
    for (final entry in entries) {
      // An election can span multiple days; show it on every day it's open,
      // plus its scheduled start day so upcoming elections are visible too.
      final start = _dayKey(entry.event.startAt);
      final end = _dayKey(entry.event.endAt);
      for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
        map.putIfAbsent(d, () => []).add(entry);
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final entriesAsync = ref.watch(voterPortalEntriesProvider);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const AdBanner(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Election Calendar',
            style: TextStyle(color: kc.textPrimary, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: kc.textPrimary),
        actions: [
          IconButton(
            tooltip: _agendaView ? 'Calendar view' : 'Agenda view',
            icon: Icon(_agendaView ? Icons.calendar_month_rounded : Icons.view_agenda_rounded),
            onPressed: () => setState(() => _agendaView = !_agendaView),
          ),
        ],
      ),
      body: entriesAsync.when(
        loading: () => const LoadingView(message: 'Loading election calendar...'),
        error: (err, _) => ErrorView(
          type: ErrorViewType.generic,
          message: 'Could not load the calendar: $err',
          onRetry: () => ref.invalidate(voterPortalEntriesProvider),
        ),
        data: (allEntries) {
          final orgNames = {
            for (final e in allEntries) e.organization.id: e.organization.name
          };
          final entries = _orgFilter == null
              ? allEntries
              : allEntries.where((e) => e.organization.id == _orgFilter).toList();
          final byDay = _groupByDay(entries);
          final selectedEvents = byDay[_selectedDay] ?? const [];

          final orgFilterRow = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _orgChip(context, null, 'All organizations'),
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

          return Column(
            children: [
              orgFilterRow,
              calendar,
              Expanded(child: _buildDetailPanel(context, selectedEvents)),
            ],
          );
        },
      ),
    );
  }

  Widget _orgChip(BuildContext context, String? id, String label) {
    final selected = _orgFilter == id;
    final kc = KivoraColors.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _orgFilter = id),
      selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: selected ? AppTheme.primaryBlue : kc.textSecondary,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: selected ? AppTheme.primaryBlue : kc.border),
    );
  }

  Widget _buildCalendar(
      BuildContext context, Map<DateTime, List<VoterPortalEntry>> byDay) {
    final kc = KivoraColors.of(context);
    return TableCalendar<VoterPortalEntry>(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
      focusedDay: _focusedDay,
      currentDay: DateTime.now(),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      calendarFormat: _format,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week',
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
        formatButtonTextStyle: const TextStyle(color: AppTheme.primaryBlue),
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryBlue),
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
        selectedDecoration: const BoxDecoration(
            color: AppTheme.primaryBlue, shape: BoxShape.circle),
        todayDecoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
            shape: BoxShape.circle),
        todayTextStyle: TextStyle(color: kc.textPrimary),
        markerDecoration: const BoxDecoration(
            color: AppTheme.accentCyan, shape: BoxShape.circle),
        markersMaxCount: 3,
      ),
    );
  }

  Widget _buildAgendaList(BuildContext context, List<VoterPortalEntry> entries) {
    final sorted = [...entries]
      ..sort((a, b) => a.event.startAt.compareTo(b.event.startAt));
    if (sorted.isEmpty) {
      return const EmptyView(
        icon: KivoraIcons.calendar,
        title: 'No elections to show',
        message: 'There are no elections in your organizations yet.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _AgendaCard(entry: sorted[i]),
    );
  }

  Widget _buildDetailPanel(
      BuildContext context, List<VoterPortalEntry> selectedEvents) {
    final kc = KivoraColors.of(context);
    final format = DateFormat('EEEE, MMM d, yyyy');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(format.format(_selectedDay),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: kc.textPrimary)),
          const SizedBox(height: 4),
          Text('${selectedEvents.length} election(s)',
              style: TextStyle(fontSize: 13, color: kc.textSecondary)),
          const SizedBox(height: 16),
          Expanded(
            child: selectedEvents.isEmpty
                ? const EmptyView(
                    icon: KivoraIcons.calendar,
                    title: 'No elections on this day',
                    message: 'Pick another date to see what\'s scheduled.',
                  )
                : ListView.separated(
                    itemCount: selectedEvents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) =>
                        _AgendaCard(entry: selectedEvents[i]),
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
    final event = entry.event;
    final timeFormat = DateFormat('MMM d, h:mm a');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(14),
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
                    style: TextStyle(fontWeight: FontWeight.bold, color: kc.textPrimary)),
              ),
              StatusBadge.eventStatus(event.status.name),
            ],
          ),
          const SizedBox(height: 4),
          Text(entry.organization.name,
              style: TextStyle(fontSize: 12, color: kc.textSecondary)),
          const SizedBox(height: 6),
          Text(
            '${timeFormat.format(event.startAt)} → ${timeFormat.format(event.endAt)}',
            style: TextStyle(fontSize: 12, color: kc.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => context.go('/elections/${event.id}'),
                icon: const Icon(Icons.open_in_new_rounded, size: 15),
                label: const Text('Details'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () =>
                    exportVotingEventToCalendar(event, entry.organization.name),
                icon: const Icon(Icons.event_available_outlined, size: 15),
                label: const Text('Add to calendar'),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
