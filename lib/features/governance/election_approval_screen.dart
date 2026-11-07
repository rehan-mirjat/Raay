import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/error_utils.dart';
import '../../core/widgets/reauth_dialog.dart';
import '../../l10n/app_localizations.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';
import '../organizations/domain/organization_enums.dart';
import '../organizations/presentation/providers/organization_providers.dart';
import '../voting/presentation/cast_vote_screen.dart';
import '../voting_events/domain/voting_event.dart';
import '../voting_events/presentation/builder/ballot_rehearsal_dialog.dart';
import '../voting_events/presentation/voter_election_card.dart'
    show formatDeadline;

class ElectionApprovalRepository {
  Stream<List<Map<String, dynamic>>> watch(String orgId, String eventId) =>
      FirebaseService()
          .firestore
          .collection('electionApprovals')
          .where('organizationId', isEqualTo: orgId)
          .where('votingEventId', isEqualTo: eventId)
          .snapshots()
          .map((s) => s.docs.map((d) => d.data()).toList());
  Future<void> run(String callable, Map<String, dynamic> data) async {
    await FirebaseService().functions.httpsCallable(callable).call(data);
  }
}

final electionApprovalRepositoryProvider =
    Provider((ref) => ElectionApprovalRepository());
final electionApprovalsProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, ({String orgId, String eventId})>(
        (ref, q) => ref
            .watch(electionApprovalRepositoryProvider)
            .watch(q.orgId, q.eventId));

class ElectionApprovalScreen extends ConsumerStatefulWidget {
  const ElectionApprovalScreen({super.key, required this.eventId});
  final String eventId;
  @override
  ConsumerState<ElectionApprovalScreen> createState() =>
      _ElectionApprovalScreenState();
}

class _ElectionApprovalScreenState
    extends ConsumerState<ElectionApprovalScreen> {
  bool _busy = false;
  AppLocalizations get l => AppLocalizations.of(context);
  Future<void> _run(String function, Map<String, dynamic> data) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      try {
        await ref
            .read(electionApprovalRepositoryProvider)
            .run(function, {'eventId': widget.eventId, ...data});
      } on FirebaseFunctionsException catch (e) {
        if (!isRecentAuthError(e) || !mounted) rethrow;
        if (await showReauthDialog(context, ref, reason: l.rvReauth) &&
            mounted) {
          await ref
              .read(electionApprovalRepositoryProvider)
              .run(function, {'eventId': widget.eventId, ...data});
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e is FirebaseFunctionsException
                ? e.message ?? l.resActionFailed
                : l.resActionFailed)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _review(
      String stage, Map<String, dynamic> approval, bool approve) async {
    final reason = TextEditingController();
    final form = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text(approve ? l.govApprove : l.govReject),
                content: SizedBox(
                    width: 440,
                    child: SingleChildScrollView(
                        child: Form(
                            key: form,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(l.govReviewNotice),
                                  if (!approve)
                                    TextFormField(
                                        controller: reason,
                                        maxLength: 500,
                                        decoration: InputDecoration(
                                            labelText: l.nomReason),
                                        validator: (v) =>
                                            (v?.trim().isEmpty ?? true)
                                                ? l.nomRequired
                                                : null)
                                ])))),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l.nomCancel)),
                  FilledButton(
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          Navigator.pop(ctx, true);
                        }
                      },
                      child: Text(approve ? l.govApprove : l.govReject))
                ]));
    final text = reason.text.trim();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    reason.dispose();
    if (confirmed == true && mounted) {
      await _run('manageElectionApproval', {
        'action': approve ? 'approve' : 'reject',
        'stage': stage,
        'requestId': approval['requestId'],
        if (!approve) 'reason': text
      });
    }
  }

  Future<void> _editRules(VotingEvent event) async {
    final percent =
        TextEditingController(text: event.quorumPercent?.toString() ?? '');
    var abstain = event.allowAbstain;
    final form = GlobalKey<FormState>();
    final saved = await showDialog<bool>(
        context: context,
        builder: (ctx) => StatefulBuilder(
            builder: (ctx, update) => AlertDialog(
                  title: Text(l.ballotRules),
                  content: SizedBox(
                      width: 440,
                      child: SingleChildScrollView(
                          child: Form(
                              key: form,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(l.quorumHint),
                                    TextFormField(
                                        controller: percent,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            labelText: l.quorumLabel,
                                            helperText: l.quorumInputHint),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return null;
                                          }
                                          final n = int.tryParse(value.trim());
                                          return n == null || n < 1 || n > 100
                                              ? l.quorumValidation
                                              : null;
                                        }),
                                    SwitchListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(l.ballotAbstain),
                                        subtitle: Text(l.ballotAbstainHint),
                                        value: abstain,
                                        onChanged: (v) =>
                                            update(() => abstain = v)),
                                  ])))),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l.nomCancel)),
                    FilledButton(
                        onPressed: () {
                          if (form.currentState!.validate()) {
                            Navigator.pop(ctx, true);
                          }
                        },
                        child: Text(l.ballotRulesSave))
                  ],
                )));
    final quorum = int.tryParse(percent.text.trim());
    await Future<void>.delayed(const Duration(milliseconds: 250));
    percent.dispose();
    if (saved == true && mounted) {
      await _run('manageElectionApproval', {
        'action': 'configureRules',
        'quorumPercent': quorum,
        'allowAbstain': abstain
      });
    }
  }

  Future<void> _preview(VotingEvent event) async {
    try {
      final choices = <BallotPreviewChoice>[];
      if (!event.isMultiContest) {
        if (event.votingType == VotingType.candidateElection) {
          final candidates =
              await ref.read(eventCandidatesProvider(event.id).future);
          choices.addAll(candidates
              .map((c) => (id: c.id, label: c.name, description: c.bio)));
        } else {
          final options =
              await ref.read(eventPollOptionsProvider(event.id).future);
          choices.addAll(options.map(
              (o) => (id: o.id, label: o.label, description: o.description)));
        }
      }
      if (!mounted) return;
      await showDialog<void>(
          context: context,
          builder: (_) => BallotRehearsalDialog(
              title: event.title,
              description: event.description,
              privacyLabel: event.privacyMode.name,
              choices: choices,
              allowAbstain: event.allowAbstain,
              quorumPercent: event.quorumPercent,
              contests: event.contests));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.resActionFailed)));
      }
    }
  }

  String _status(String? status) => switch (status) {
        'PENDING' => l.govPending,
        'APPROVED' => l.nomApproved,
        'REJECTED' => l.nomRejected,
        _ => l.govNoRequest
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
    final event = ref.watch(singleVotingEventProvider(widget.eventId));
    return Scaffold(
        appBar: AppBar(title: Text(l.govTitle)),
        body: event.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text(l.resActionFailed)),
            data: (ev) {
              if (ev == null || ev.organizationId != org.organization.id) {
                return Center(child: Text(l.orgReportDenied));
              }
              final uid = ref.watch(authServiceProvider).currentUser?.uid;
              final approvals = ref.watch(electionApprovalsProvider(
                  (orgId: org.organization.id, eventId: ev.id)));
              return Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: ListView(
                          padding: const EdgeInsets.all(24),
                          children: [
                            Text(ev.title,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 12),
                            Text(l.govIntro),
                            const SizedBox(height: 16),
                            Material(
                                type: MaterialType.transparency,
                                child: SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(l.govPolicy),
                                    subtitle: Text(l.govPolicyHint),
                                    value: ev.independentApprovalRequired,
                                    onChanged: _busy ||
                                            org.member.role !=
                                                OrganizationRole.owner ||
                                            ev.status != VotingEventStatus.draft
                                        ? null
                                        : (enabled) => _run(
                                                'manageElectionApproval', {
                                              'action': 'configure',
                                              'enabled': enabled
                                            }))),
                            Text(
                                '${l.quorumLabel}: ${ev.quorumPercent == null ? l.quorumDisabled : '${ev.quorumPercent}%'}'),
                            Text(
                                '${l.abstentionsLabel}: ${ev.allowAbstain ? l.ballotAbstainEnabled : l.quorumDisabled}'),
                            Text(l.quorumHint),
                            if (ev.status == VotingEventStatus.draft)
                              OutlinedButton(
                                  onPressed:
                                      _busy ? null : () => _editRules(ev),
                                  child: Text(l.ballotRules)),
                            if (_busy) const LinearProgressIndicator(),
                            const SizedBox(height: 12),
                            Text(
                                '${ev.votingType.localized(l)} · ${ev.privacyMode.name} · ${ev.eligibilityType.localized(l)}'),
                            Text(
                                '${formatDeadline(context, ev.startAt)} → ${formatDeadline(context, ev.endAt)}'),
                            Wrap(spacing: 12, runSpacing: 8, children: [
                              OutlinedButton(
                                  onPressed: _busy ? null : () => _preview(ev),
                                  child: Text(l.rvPreview)),
                              if ([
                                VotingEventStatus.closed,
                                VotingEventStatus.archived
                              ].contains(ev.status))
                                OutlinedButton(
                                    onPressed: () => context
                                        .go('/elections/${ev.id}/results'),
                                    child: Text(l.govViewResults))
                            ]),
                            const SizedBox(height: 20),
                            if (ev.independentApprovalRequired)
                              approvals.when(
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                  error: (e, s) => Text(l.resActionFailed),
                                  data: (rows) => Column(children: [
                                        for (final stage in [
                                          'LAUNCH',
                                          'RESULTS'
                                        ])
                                          Builder(builder: (_) {
                                            final record = rows
                                                .where(
                                                    (r) => r['stage'] == stage)
                                                .firstOrNull;
                                            final available = stage == 'LAUNCH'
                                                ? ev.status ==
                                                    VotingEventStatus.draft
                                                : [
                                                    VotingEventStatus.closed,
                                                    VotingEventStatus.archived
                                                  ].contains(ev.status);
                                            return Card(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              stage == 'LAUNCH'
                                                                  ? l.govLaunch
                                                                  : l
                                                                      .govResults,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge),
                                                          Text(_status(
                                                              record?['status']
                                                                  as String?)),
                                                          if (record?[
                                                                  'fingerprint'] !=
                                                              null)
                                                            ExpansionTile(
                                                              tilePadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              title: Text(
                                                                  l.govVersion),
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .centerStart,
                                                                  child:
                                                                      SelectableText(
                                                                    record!['fingerprint']
                                                                        as String,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          if ((record?['reason']
                                                                      as String? ??
                                                                  '')
                                                              .isNotEmpty)
                                                            Text(
                                                                '${l.nomReason}: ${record!['reason']}'),
                                                          const SizedBox(
                                                              height: 12),
                                                          Text(l.govFreshness),
                                                          if (available)
                                                            Wrap(
                                                                spacing: 12,
                                                                runSpacing: 8,
                                                                children: [
                                                                  if (stage ==
                                                                      'RESULTS')
                                                                    OutlinedButton(
                                                                        onPressed: _busy
                                                                            ? null
                                                                            : () => _run('calculateResults',
                                                                                {}),
                                                                        child: Text(
                                                                            l.govCalculate)),
                                                                  OutlinedButton(
                                                                      onPressed: _busy
                                                                          ? null
                                                                          : () =>
                                                                              _run('manageElectionApproval', {
                                                                                'action': 'request',
                                                                                'stage': stage
                                                                              }),
                                                                      child: Text(
                                                                          l.govRequest)),
                                                                  if (record?['status'] ==
                                                                          'PENDING' &&
                                                                      record?['requestedBy'] !=
                                                                          uid) ...[
                                                                    FilledButton(
                                                                        onPressed: _busy
                                                                            ? null
                                                                            : () => _review(
                                                                                stage,
                                                                                record!,
                                                                                true),
                                                                        child: Text(
                                                                            l.govApprove)),
                                                                    TextButton(
                                                                        onPressed: _busy
                                                                            ? null
                                                                            : () => _review(
                                                                                stage,
                                                                                record!,
                                                                                false),
                                                                        child: Text(
                                                                            l.govReject))
                                                                  ],
                                                                  if (record?['status'] ==
                                                                          'APPROVED' &&
                                                                      record?['requestedBy'] ==
                                                                          uid)
                                                                    FilledButton(
                                                                        onPressed: _busy
                                                                            ? null
                                                                            : () => _run(
                                                                                stage == 'LAUNCH'
                                                                                    ? 'publishVotingEvent'
                                                                                    : 'publishResults',
                                                                                {}),
                                                                        child: Text(stage ==
                                                                                'LAUNCH'
                                                                            ? l.govPublishElection
                                                                            : l.govPublishResults)),
                                                                ]),
                                                        ])));
                                          }),
                                      ])),
                          ])));
            }));
  }
}
