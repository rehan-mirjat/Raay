import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../organizations/domain/organization_enums.dart';
import '../organizations/presentation/providers/organization_providers.dart';
import '../voting_events/data/voting_event_repository.dart';
import '../voting_events/domain/voting_event.dart';
import 'nomination_repository.dart';

class NominationsScreen extends ConsumerStatefulWidget {
  const NominationsScreen({super.key});
  @override
  ConsumerState<NominationsScreen> createState() => _NominationsScreenState();
}

class _NominationsScreenState extends ConsumerState<NominationsScreen> {
  String? _orgId;
  String? _roundId;
  int _roundLimit = 20;
  int _appLimit = 50;
  bool _busy = false;
  AppLocalizations get l => AppLocalizations.of(context);

  Future<bool> _act(Map<String, dynamic> data) async {
    if (_busy) return false;
    setState(() => _busy = true);
    try {
      await ref.read(nominationRepositoryProvider).act(data);
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e is FirebaseFunctionsException
                ? e.message ?? l.nomFailed
                : l.nomFailed)));
      }
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _create(String orgId) async {
    setState(() => _busy = true);
    List<VotingEvent> drafts;
    try {
      drafts = (await ref
              .read(votingEventRepositoryProvider)
              .watchOrganizationVotingEvents(orgId, includeDrafts: true)
              .first)
          .where((e) =>
              e.status == VotingEventStatus.draft &&
              e.votingType == VotingType.candidateElection)
          .toList();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.nomFailed)));
      }
      return;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (!mounted) return;
    if (drafts.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.nomNeedDraft)));
      return;
    }
    VotingEvent selected = drafts.first;
    String? contestId;
    DateTime? closesAt;
    final data = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (ctx) => StatefulBuilder(
            builder: (ctx, update) => AlertDialog(
                  title: Text(l.nomCreate),
                  content: SizedBox(
                      width: 440,
                      child: SingleChildScrollView(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(l.nomCreateHint),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                                initialValue: selected.id,
                                isExpanded: true,
                                decoration:
                                    InputDecoration(labelText: l.nomElection),
                                items: drafts
                                    .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.title,
                                            overflow: TextOverflow.ellipsis)))
                                    .toList(),
                                onChanged: (id) => update(() {
                                      selected =
                                          drafts.firstWhere((e) => e.id == id);
                                      contestId = null;
                                      closesAt = null;
                                    })),
                            if (selected.isMultiContest) ...[
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                  key: ValueKey(selected.id),
                                  isExpanded: true,
                                  decoration:
                                      InputDecoration(labelText: l.nomContest),
                                  items: selected.contests
                                      .map((c) => DropdownMenuItem(
                                          value: c.id,
                                          child: Text(c.title,
                                              overflow: TextOverflow.ellipsis)))
                                      .toList(),
                                  onChanged: (id) =>
                                      update(() => contestId = id)),
                            ],
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                                icon: const Icon(Icons.schedule),
                                label: Text(closesAt == null
                                    ? l.nomDeadline
                                    : '${MaterialLocalizations.of(context).formatFullDate(closesAt!)} · ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(closesAt!))}'),
                                onPressed: () async {
                                  final now = DateTime.now();
                                  final start = selected.startAt.toLocal();
                                  if (!start.isAfter(now)) return;
                                  final date = await showDatePicker(
                                      context: ctx,
                                      firstDate: DateTime(
                                          now.year, now.month, now.day),
                                      lastDate: DateTime(
                                          start.year, start.month, start.day),
                                      initialDate: start);
                                  if (date == null || !ctx.mounted) return;
                                  final time = await showTimePicker(
                                      context: ctx,
                                      initialTime:
                                          TimeOfDay.fromDateTime(start));
                                  if (time != null && ctx.mounted) {
                                    update(() => closesAt = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute));
                                  }
                                }),
                          ]))),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l.nomCancel)),
                    FilledButton(
                        onPressed: closesAt == null ||
                                !closesAt!.isAfter(DateTime.now()) ||
                                closesAt!.isAfter(selected.startAt) ||
                                (selected.isMultiContest && contestId == null)
                            ? null
                            : () => Navigator.pop(ctx, {
                                  'action': 'create',
                                  'eventId': selected.id,
                                  'closesAt':
                                      closesAt!.toUtc().toIso8601String(),
                                  if (contestId != null) 'contestId': contestId
                                }),
                        child: Text(l.nomCreate))
                  ],
                )));
    if (data != null && mounted && _orgId == orgId) await _act(data);
  }

  Future<void> _apply(String roundId) async {
    final form = GlobalKey<FormState>();
    final name = TextEditingController();
    final statement = TextEditingController();
    bool consent = false;
    final data = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (ctx) => StatefulBuilder(
            builder: (ctx, update) => AlertDialog(
                  title: Text(l.nomApply),
                  content: SizedBox(
                      width: 460,
                      child: SingleChildScrollView(
                          child: Form(
                              key: form,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                        controller: name,
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                            labelText: l.nomName),
                                        validator: (v) =>
                                            (v?.trim().length ?? 0) < 2
                                                ? l.nomRequired
                                                : null),
                                    TextFormField(
                                        controller: statement,
                                        maxLength: 500,
                                        minLines: 3,
                                        maxLines: 6,
                                        decoration: InputDecoration(
                                            labelText: l.nomStatement)),
                                    Material(
                                        type: MaterialType.transparency,
                                        child: CheckboxListTile(
                                            contentPadding: EdgeInsets.zero,
                                            value: consent,
                                            onChanged: (v) => update(
                                                () => consent = v ?? false),
                                            title: Text(l.nomConsent))),
                                  ])))),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l.nomCancel)),
                    FilledButton(
                        onPressed: !consent
                            ? null
                            : () {
                                if (form.currentState!.validate()) {
                                  Navigator.pop(ctx, {
                                    'action': 'submit',
                                    'roundId': roundId,
                                    'name': name.text.trim(),
                                    'statement': statement.text.trim(),
                                    'consent': true
                                  });
                                }
                              },
                        child: Text(l.nomSubmit))
                  ],
                )));
    // Dialog route removal finishes on the next frame; dispose after its animation.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    name.dispose();
    statement.dispose();
    if (data != null && mounted) await _act(data);
  }

  Future<void> _review(
      Map<String, dynamic> application, String roundId, bool approve) async {
    final reason = TextEditingController();
    final form = GlobalKey<FormState>();
    final data = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (ctx) => AlertDialog(
              scrollable: true,
              title: Text(approve ? l.nomApprove : l.nomReject),
              content: SizedBox(
                  width: 420,
                  child: Form(
                      key: form,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(approve ? l.nomApproveHint : l.nomRejectHint),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: reason,
                            maxLength: 500,
                            decoration: InputDecoration(labelText: l.nomReason),
                            validator: (v) =>
                                !approve && (v?.trim().isEmpty ?? true)
                                    ? l.nomRequired
                                    : null)
                      ]))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(l.nomCancel)),
                FilledButton(
                    onPressed: () {
                      if (form.currentState!.validate()) {
                        Navigator.pop(ctx, {
                          'action': 'review',
                          'roundId': roundId,
                          'applicationId': application['id'],
                          'decision': approve ? 'APPROVED' : 'REJECTED',
                          'reason': reason.text.trim()
                        });
                      }
                    },
                    child: Text(approve ? l.nomApprove : l.nomReject))
              ],
            ));
    await Future<void>.delayed(const Duration(milliseconds: 250));
    reason.dispose();
    if (data != null && mounted) await _act(data);
  }

  Future<void> _confirm(String action, String roundId) async {
    final yes = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text(action == 'close' ? l.nomClose : l.nomWithdraw),
                content: Text(
                    action == 'close' ? l.nomCloseHint : l.nomWithdrawHint),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l.nomCancel)),
                  FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l.nomConfirm))
                ]));
    if (yes == true && mounted) {
      await _act({'action': action, 'roundId': roundId});
    }
  }

  String _status(String status) => switch (status) {
        'OPEN' => l.nomOpen,
        'CLOSED' => l.nomClosed,
        'SUBMITTED' => l.nomPending,
        'FINALIZED' => l.nomFinalized,
        'APPROVED' => l.nomApproved,
        'REJECTED' => l.nomRejected,
        'WITHDRAWN' => l.nomWithdrawn,
        _ => status,
      };

  @override
  Widget build(BuildContext context) {
    final org =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
    final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
    if (org == null ||
        uid == null ||
        org.member.status != MembershipStatus.active) {
      return Scaffold(body: Center(child: Text(l.nomAccess)));
    }
    if (_orgId != org.organization.id) {
      _orgId = org.organization.id;
      _roundId = null;
      _roundLimit = 20;
      _appLimit = 50;
    }
    final manager = org.member.role.isAdmin;
    final rounds = ref
        .watch(nominationRoundsProvider((orgId: _orgId!, limit: _roundLimit)));
    return Scaffold(
        appBar: AppBar(title: Text(l.navNominations)),
        body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: ListView(padding: const EdgeInsets.all(24), children: [
                  Text(l.nomIntro,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  if (manager)
                    Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: FilledButton.icon(
                            onPressed: _busy ? null : () => _create(_orgId!),
                            icon: const Icon(Icons.add),
                            label: Text(l.nomCreate))),
                  if (_busy) const LinearProgressIndicator(),
                  const SizedBox(height: 16),
                  rounds.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Text(l.nomFailed),
                      data: (items) {
                        if (items.isEmpty) {
                          return Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(l.nomEmpty));
                        }
                        return Column(children: [
                          for (final r in items) ...[
                            Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              [
                                                r['eventTitle'],
                                                r['contestTitle']
                                              ].whereType<String>().join(' · '),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge),
                                          const SizedBox(height: 8),
                                          Text(_status(r['status'] as String)),
                                          if (r['closesAt'] is Timestamp)
                                            Text(
                                                '${l.nomDeadline}: ${MaterialLocalizations.of(context).formatFullDate((r['closesAt'] as Timestamp).toDate().toLocal())} · ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime((r['closesAt'] as Timestamp).toDate().toLocal()))}'),
                                          const SizedBox(height: 12),
                                          Wrap(
                                              spacing: 12,
                                              runSpacing: 8,
                                              children: [
                                                OutlinedButton(
                                                    onPressed: () =>
                                                        setState(() {
                                                          _roundId = _roundId ==
                                                                  r['id']
                                                              ? null
                                                              : r['id']
                                                                  as String;
                                                          _appLimit = 50;
                                                        }),
                                                    child: Text(manager
                                                        ? l.nomReview
                                                        : l.nomMyApplication)),
                                                if (manager &&
                                                    r['status'] == 'OPEN')
                                                  TextButton(
                                                      onPressed: _busy
                                                          ? null
                                                          : () => _confirm(
                                                              'close',
                                                              r['id']
                                                                  as String),
                                                      child: Text(l.nomClose)),
                                                if (manager)
                                                  TextButton(
                                                      onPressed: () => context.go(
                                                          '/elections/${r['votingEventId']}'),
                                                      child:
                                                          Text(l.nomElection)),
                                              ]),
                                          if (_roundId == r['id'])
                                            _applications(r, uid, manager),
                                        ]))),
                            const SizedBox(height: 12),
                          ],
                          if (items.length == _roundLimit)
                            OutlinedButton(
                                onPressed: () =>
                                    setState(() => _roundLimit += 20),
                                child: Text(l.nomMore))
                        ]);
                      }),
                ]))));
  }

  Widget _applications(Map<String, dynamic> round, String uid, bool manager) {
    final apps = ref.watch(nominationApplicationsProvider((
      orgId: round['organizationId'] as String,
      roundId: round['id'] as String,
      uid: manager ? null : uid,
      limit: _appLimit
    )));
    return apps.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, stack) => Text(l.nomFailed),
        data: (items) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(),
              if (round['status'] == 'OPEN' &&
                  (round['closesAt'] as Timestamp)
                      .toDate()
                      .isAfter(DateTime.now()) &&
                  !items.any(
                      (a) => a['userId'] == uid && a['status'] != 'WITHDRAWN'))
                FilledButton(
                    onPressed:
                        _busy ? null : () => _apply(round['id'] as String),
                    child: Text(l.nomApply)),
              if (items.isEmpty) Text(l.nomNoApplications),
              for (final a in items)
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['name'] as String,
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(_status(a['status'] as String)),
                          if ((a['statement'] as String? ?? '').isNotEmpty)
                            Text(a['statement'] as String),
                          if ((a['reason'] as String? ?? '').isNotEmpty)
                            Text('${l.nomReason}: ${a['reason']}'),
                          Wrap(spacing: 8, runSpacing: 8, children: [
                            if (manager &&
                                round['status'] == 'CLOSED' &&
                                ['SUBMITTED', 'APPROVED']
                                    .contains(a['status'])) ...[
                              if (a['status'] == 'SUBMITTED')
                                FilledButton(
                                    onPressed: _busy
                                        ? null
                                        : () => _review(
                                            a, round['id'] as String, true),
                                    child: Text(l.nomApprove)),
                              OutlinedButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _review(
                                          a, round['id'] as String, false),
                                  child: Text(l.nomReject)),
                            ],
                            if (round['status'] != 'FINALIZED' &&
                                a['userId'] == uid &&
                                ['SUBMITTED', 'APPROVED'].contains(a['status']))
                              TextButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _confirm(
                                          'withdraw', round['id'] as String),
                                  child: Text(l.nomWithdraw)),
                          ]),
                        ])),
              if (items.length == _appLimit)
                OutlinedButton(
                    onPressed: () => setState(() => _appLimit += 50),
                    child: Text(l.nomMore)),
            ]));
  }
}
