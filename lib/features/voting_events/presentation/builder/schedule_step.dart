import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../domain/voting_event.dart';
import '../providers/draft_event_provider.dart';

class ScheduleStep extends ConsumerStatefulWidget {
  final String orgId;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ScheduleStep({super.key, required this.orgId, required this.onNext, required this.onBack});

  @override
  ConsumerState<ScheduleStep> createState() => _ScheduleStepState();
}

class _ScheduleStepState extends ConsumerState<ScheduleStep> {
  DateTime? _startAt;
  DateTime? _endAt;
  String? _localError;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(draftEventProvider(widget.orgId));
    _startAt = draft.startAt;
    _endAt = draft.endAt;
  }

  Future<void> _pickDateTime(bool isStart) async {
    final now = DateTime.now();
    var safeInitialDate = isStart
        ? (_startAt ?? now)
        : (_endAt ?? _startAt ?? now.add(const Duration(minutes: 5)));

    final firstDate = now.subtract(const Duration(days: 365));
    final lastDate = now.add(const Duration(days: 365));

    if (safeInitialDate.isBefore(firstDate)) {
      safeInitialDate = firstDate;
    } else if (safeInitialDate.isAfter(lastDate)) {
      safeInitialDate = lastDate;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(safeInitialDate),
    );
    if (time == null) return;

    final selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    if (!mounted) return;

    setState(() {
      _localError = null;
      if (isStart) {
        _startAt = selected;
      } else {
        _endAt = selected;
      }
    });
    // Keep the draft in step with the pickers so leaving is guarded.
    final start = _startAt;
    final end = _endAt;
    if (start != null && end != null) {
      ref.read(draftEventProvider(widget.orgId).notifier).updateSchedule(start, end);
    }
  }

  void _validateAndProceed() {
    if (_startAt == null || _endAt == null) {
      setState(() => _localError = 'Start and End times are required.');
      return;
    }

    final now = DateTime.now();
    if (_startAt!.isBefore(now.subtract(const Duration(minutes: 1)))) {
      setState(() => _localError = 'Start time cannot be in the past.');
      return;
    }

    if (_endAt!.difference(_startAt!).inMinutes < 5) {
      setState(() => _localError = 'Voting window must be at least 5 minutes.');
      return;
    }

    ref.read(draftEventProvider(widget.orgId).notifier).updateSchedule(_startAt!, _endAt!);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMM d, yyyy - h:mm a');
    final isDraft = ref.watch(draftEventProvider(widget.orgId)).status == VotingEventStatus.draft;
    final kc = KivoraColors.of(context);
    final offset = DateTime.now().timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final zone = '${DateTime.now().timeZoneName} (UTC$sign${offset.inHours.abs().toString().padLeft(2, '0')}:${(offset.inMinutes.abs() % 60).toString().padLeft(2, '0')})';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isDraft)
           Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
                 color: kc.surface,
                 borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                 border: Border.all(color: kc.border)),
             child: Text('Event is no longer a DRAFT. Schedule is strictly immutable.', style: TextStyle(color: kc.textSecondary)),
           ),
        const SizedBox(height: 16),
        const Text('Voting Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Times are entered in your time zone: $zone. All times are evaluated securely against the server clock.', style: TextStyle(fontSize: 14, color: kc.textSecondary)),
        const SizedBox(height: 24),
        
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: kc.border)),
          minVerticalPadding: 12,
          title: const Text('Start Time'),
          subtitle: Text(_startAt != null ? format.format(_startAt!) : 'Not set', style: TextStyle(color: _startAt != null ? KivoraColors.textPrimaryOf(context) : kc.errorText)),
          trailing: const Icon(Icons.calendar_today),
          onTap: isDraft ? () => _pickDateTime(true) : null,
        ),
        const SizedBox(height: 16),
        ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: kc.border)),
          minVerticalPadding: 12,
          title: const Text('End Time'),
          subtitle: Text(_endAt != null ? format.format(_endAt!) : 'Not set', style: TextStyle(color: _endAt != null ? KivoraColors.textPrimaryOf(context) : kc.errorText)),
          trailing: const Icon(Icons.calendar_today),
          onTap: isDraft ? () => _pickDateTime(false) : null,
        ),
        
        if (_localError != null) ...[
          const SizedBox(height: 16),
          Text(_localError!, style: TextStyle(color: kc.errorText, fontWeight: FontWeight.bold)),
        ],

        const SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 12,
          runSpacing: 12,
          children: [
            TextButton(style: TextButton.styleFrom(minimumSize: const Size(48, 48)), onPressed: widget.onBack, child: const Text('Back')),
            FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(48, 48)), onPressed: isDraft ? _validateAndProceed : widget.onNext, child: const Text('Next: Eligibility')),
          ],
        ),
      ],
    );
  }
}
