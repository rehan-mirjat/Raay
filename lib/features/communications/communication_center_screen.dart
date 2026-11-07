import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../services/firebase_service.dart';
import '../organizations/domain/organization_enums.dart';
import '../organizations/presentation/providers/organization_providers.dart';
import '../voting_events/data/voting_event_repository.dart';
import '../voting_events/domain/voting_event.dart';

class CommunicationRepository {
  Stream<List<Map<String, dynamic>>> watch(String orgId, int limit) =>
      FirebaseService()
          .firestore
          .collection('communicationJobs')
          .where('organizationId', isEqualTo: orgId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList());
  Future<void> act(Map<String, dynamic> payload) async {
    await FirebaseService()
        .functions
        .httpsCallable('manageReminderJob')
        .call(payload);
  }
}

final communicationRepositoryProvider =
    Provider((ref) => CommunicationRepository());
final communicationJobsProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, ({String orgId, int limit})>((ref, q) =>
        ref.watch(communicationRepositoryProvider).watch(q.orgId, q.limit));

class CommunicationCenterScreen extends ConsumerStatefulWidget {
  const CommunicationCenterScreen({super.key});
  @override
  ConsumerState<CommunicationCenterScreen> createState() =>
      _CommunicationCenterScreenState();
}

class _CommunicationCenterScreenState
    extends ConsumerState<CommunicationCenterScreen> {
  bool _busy = false;
  int _limit = 20;
  String? _orgId;
  String? _previousPayload;
  String? _requestId;
  AppLocalizations get l => AppLocalizations.of(context);
  Future<bool> _act(Map<String, dynamic> payload) async {
    if (_busy) return false;
    setState(() => _busy = true);
    try {
      await ref.read(communicationRepositoryProvider).act(payload);
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e is FirebaseFunctionsException
                ? e.message ?? l.comFailed
                : l.comFailed)));
      }
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _schedule(List<VotingEvent> events) async {
    VotingEvent selected = events.first;
    DateTime? when;
    final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (ctx) => StatefulBuilder(
            builder: (ctx, update) => AlertDialog(
                  title: Text(l.comSchedule),
                  content: SizedBox(
                      width: 460,
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(l.comAudience),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                                initialValue: selected.id,
                                isExpanded: true,
                                decoration:
                                    InputDecoration(labelText: l.nomElection),
                                items: events
                                    .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.title,
                                            overflow: TextOverflow.ellipsis)))
                                    .toList(),
                                onChanged: (value) => update(() {
                                      selected = events
                                          .firstWhere((e) => e.id == value);
                                      when = null;
                                    })),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                                icon: const Icon(Icons.schedule),
                                label: Text(when == null
                                    ? l.comChooseTime
                                    : '${MaterialLocalizations.of(context).formatFullDate(when!)} · ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(when!))}'),
                                onPressed: () async {
                                  final now = DateTime.now();
                                  final end = selected.endAt.toLocal();
                                  if (!end.isAfter(now)) return;
                                  final date = await showDatePicker(
                                      context: ctx,
                                      firstDate: DateTime(
                                          now.year, now.month, now.day),
                                      lastDate: DateTime(
                                          end.year, end.month, end.day),
                                      initialDate: selected.startAt.isAfter(now)
                                          ? selected.startAt.toLocal()
                                          : now);
                                  if (date == null || !ctx.mounted) return;
                                  final time = await showTimePicker(
                                      context: ctx,
                                      initialTime: TimeOfDay.fromDateTime(
                                          selected.startAt.isAfter(now)
                                              ? selected.startAt.toLocal()
                                              : now.add(
                                                  const Duration(minutes: 5))));
                                  if (time != null && ctx.mounted) {
                                    update(() => when = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute));
                                  }
                                }),
                            const SizedBox(height: 8),
                            Text(l.comTiming),
                          ]))),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l.nomCancel)),
                    FilledButton(
                        onPressed: when == null ||
                                !when!.isAfter(DateTime.now()) ||
                                when!.isBefore(selected.startAt) ||
                                !when!.isBefore(selected.endAt)
                            ? null
                            : () => Navigator.pop(ctx, {
                                  'eventId': selected.id,
                                  'scheduledAt': when!.toUtc().toIso8601String()
                                }),
                        child: Text(l.comSchedule))
                  ],
                )));
    if (result == null || !mounted) return;
    final signature = '${result['eventId']}|${result['scheduledAt']}';
    if (_previousPayload != signature) {
      _previousPayload = signature;
      _requestId = const Uuid().v4();
    }
    final acknowledged = await _act({
      'action': 'schedule',
      ...result,
      'channel': 'IN_APP',
      'requestId': _requestId
    });
    if (acknowledged) {
      _previousPayload = null;
      _requestId = null;
    }
  }

  Future<void> _cancel(String jobId) async {
    final yes = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text(l.comCancel),
                content: Text(l.comCancelHint),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l.nomCancel)),
                  FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l.nomConfirm))
                ]));
    if (yes == true && mounted) {
      await _act({'action': 'cancel', 'jobId': jobId});
    }
  }

  String _status(String status) => switch (status) {
        'QUEUED' => l.comQueued,
        'PROCESSING' => l.comProcessing,
        'COMPLETED' => l.comCompleted,
        'CANCELLED' => l.comCancelled,
        'FAILED' => l.comFailedStatus,
        _ => status
      };
  @override
  Widget build(BuildContext context) {
    final org =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
    if (org == null ||
        !org.member.role.isAdmin ||
        org.member.status != MembershipStatus.active) {
      return Scaffold(body: Center(child: Text(l.orgReportDenied)));
    }
    if (_orgId != org.organization.id) {
      _orgId = org.organization.id;
      _limit = 20;
      _previousPayload = null;
      _requestId = null;
    }
    final events = ref.watch(organizationVotingEventsProvider(
        (orgId: _orgId!, includeDrafts: true)));
    final available = events.valueOrNull
            ?.where((e) =>
                [VotingEventStatus.active, VotingEventStatus.scheduled]
                    .contains(e.status) &&
                e.endAt.isAfter(DateTime.now()))
            .toList() ??
        [];
    final jobs =
        ref.watch(communicationJobsProvider((orgId: _orgId!, limit: _limit)));
    return Scaffold(
        appBar: AppBar(title: Text(l.navCommunications)),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: ListView(padding: const EdgeInsets.all(24), children: [
                  Text(l.comIntro,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  Card(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.comInApp,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 8),
                                Text(l.comExternalUnavailable)
                              ]))),
                  const SizedBox(height: 16),
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FilledButton.icon(
                          onPressed: _busy || available.isEmpty
                              ? null
                              : () => _schedule(available),
                          icon: const Icon(Icons.add_alarm),
                          label: Text(l.comSchedule))),
                  if (events.isLoading) const LinearProgressIndicator(),
                  if (events.hasError) Text(l.comFailed),
                  if (!events.isLoading &&
                      !events.hasError &&
                      available.isEmpty)
                    Text(l.comNeedEvent),
                  if (_busy) const LinearProgressIndicator(),
                  const SizedBox(height: 20),
                  jobs.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Column(children: [
                            Text(l.comFailed),
                            TextButton(
                                onPressed: () => ref.invalidate(
                                    communicationJobsProvider(
                                        (orgId: _orgId!, limit: _limit))),
                                child: Text(l.supportRetry))
                          ]),
                      data: (items) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (items.isEmpty) Text(l.comEmpty),
                                for (final job in items)
                                  Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    job['eventTitle']
                                                            as String? ??
                                                        '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium),
                                                const SizedBox(height: 8),
                                                Wrap(
                                                    spacing: 12,
                                                    runSpacing: 8,
                                                    children: [
                                                      Chip(
                                                          label: Text(_status(
                                                              job['status']
                                                                  as String))),
                                                      Text(l.comInApp)
                                                    ]),
                                                if ((job['requestedAt'] ??
                                                        job['scheduledAt'])
                                                    case final Timestamp time)
                                                  Text(
                                                      '${l.comScheduledFor}: ${MaterialLocalizations.of(context).formatFullDate(time.toDate().toLocal())} · ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(time.toDate().toLocal()))}'),
                                                Text(
                                                    '${l.comCount}: ${job['notificationCount'] ?? 0}'),
                                                if (job['status'] == 'FAILED')
                                                  Text(l.comFailureHint),
                                                if (job['lastError'] ==
                                                        'RETRY_PENDING' &&
                                                    job['status'] == 'QUEUED')
                                                  Text(l.comRetrying),
                                                if (job['status'] == 'QUEUED')
                                                  OutlinedButton(
                                                      onPressed: _busy
                                                          ? null
                                                          : () => _cancel(
                                                              job['id']
                                                                  as String),
                                                      child: Text(l.comCancel)),
                                              ]))),
                                if (items.length == _limit)
                                  OutlinedButton(
                                      onPressed: () =>
                                          setState(() => _limit += 20),
                                      child: Text(l.paLoadMore)),
                              ])),
                ]))));
  }
}
