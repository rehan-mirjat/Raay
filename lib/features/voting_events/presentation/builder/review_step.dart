import '../../../../l10n/app_localizations.dart';
import 'ballot_rehearsal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/raay_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/reauth_dialog.dart';
import '../../data/voting_event_repository.dart';
import '../providers/draft_event_provider.dart';
import '../../../voting/presentation/cast_vote_screen.dart'
    show
        eventCandidatesProvider,
        eventPollOptionsProvider,
        singleVotingEventProvider;
import '../voter_election_card.dart' show formatDeadline;
import '../../domain/voting_event.dart';
import '../../../../core/utils/error_utils.dart';
import '../../../../core/utils/friendly_error.dart';

class ReviewStep extends ConsumerStatefulWidget {
  final String orgId;
  final VoidCallback onBack;

  const ReviewStep({super.key, required this.orgId, required this.onBack});

  @override
  ConsumerState<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  bool _isPublishing = false;
  String? _error;

  Future<void> _confirmAndPublish() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).rvPublishTitle),
        content: Text(AppLocalizations.of(context).rvPublishBody),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context).rvKeepEditing),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context).rvPublish),
          ),
        ],
      ),
    );
    if (ok == true && mounted) await _publish();
  }

  Future<void> _publish() async {
    final draft = ref.read(draftEventProvider(widget.orgId));
    final eventId = draft.serverEventId;
    if (eventId == null) return;

    setState(() {
      _isPublishing = true;
      _error = null;
    });

    try {
      await ref.read(votingEventRepositoryProvider).publishVotingEvent(eventId);
      if (mounted) {
        ref.read(draftEventProvider(widget.orgId).notifier).reset();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).rvPublished)));
        // Navigate back to admin events dashboard
        context.go('/admin/events');
      }
    } on RequiresRecentAuthException {
      if (!mounted) return;
      final verified = await showReauthDialog(context, ref,
          reason: AppLocalizations.of(context).rvReauth);
      if (!mounted) return;
      if (verified) {
        // Identity re-verified: retry the publish with the now-fresh session.
        _publish();
      } else {
        setState(() => _isPublishing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPublishing = false;
          _error = friendlyError(e,
              fallback: AppLocalizations.of(context).rvPublishFailed);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(draftEventProvider(widget.orgId));
    final eventId = draft.serverEventId;
    if (eventId == null) return const SizedBox.shrink();
    final policyEvent =
        ref.watch(singleVotingEventProvider(eventId)).valueOrNull;

    // Check completeness locally for UX warning
    final bool isCand = draft.votingType == VotingType.candidateElection;

    final AsyncValue<int> countAsync = draft.multiContest
        ? ref
            .watch(singleVotingEventProvider(eventId))
            .whenData((event) => event?.contests.length ?? 0)
        : isCand
            ? ref
                .watch(eventCandidatesProvider(eventId))
                .whenData((v) => v.length)
            : ref
                .watch(eventPollOptionsProvider(eventId))
                .whenData((v) => v.length);

    return countAsync.when(
        loading: () => const LoadingView(),
        error: (_, __) => Text(AppLocalizations.of(context).rvChoicesError,
            style: TextStyle(color: RaayColors.of(context).errorText)),
        data: (count) {
          final hasChoices = count >= 2;
          final hasSchedule = draft.startAt != null &&
              draft.endAt != null &&
              draft.endAt!.isAfter(draft.startAt!);
          final hasEligibility =
              draft.eligibilityType == EligibilityType.allMembers ||
                  draft.selectedDepartmentIds.isNotEmpty ||
                  draft.selectedUserIds.isNotEmpty;
          final hasTitle = draft.title.trim().isNotEmpty;
          final checklist = <_ChecklistItem>[
            _ChecklistItem(AppLocalizations.of(context).rvCheckTitle, hasTitle),
            _ChecklistItem(AppLocalizations.of(context).rvCheckDesc,
                draft.description.trim().isNotEmpty,
                optional: true),
            _ChecklistItem(
                AppLocalizations.of(context).rvCheckSchedule, hasSchedule),
            _ChecklistItem(
                draft.privacyMode == PrivacyMode.identifiable
                    ? AppLocalizations.of(context).rvCheckPrivacyId
                    : AppLocalizations.of(context).rvCheckPrivacyAnon,
                true),
            _ChecklistItem(
                AppLocalizations.of(context).rvCheckChoices(count.toString()),
                hasChoices),
            _ChecklistItem(
                AppLocalizations.of(context).rvCheckEligibility((draft
                        .eligibilityType
                        .localized(AppLocalizations.of(context)))
                    .toString()),
                hasEligibility),
          ];
          final isReady = checklist.every((c) => c.done || c.optional);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppLocalizations.of(context).rvTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(AppLocalizations.of(context).rvChecklist,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: RaayColors.textSecondaryOf(context),
                      letterSpacing: 0.8)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: RaayColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: RaayColors.borderOf(context)),
                ),
                child: Column(
                  children:
                      checklist.map((c) => _checklistRow(context, c)).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _summaryRow(
                  AppLocalizations.of(context).rvTitleLabel, draft.title),
              _summaryRow(
                  AppLocalizations.of(context).rvStart,
                  draft.startAt != null
                      ? formatDeadline(context, draft.startAt!)
                      : ''),
              _summaryRow(
                  AppLocalizations.of(context).rvEnd,
                  draft.endAt != null
                      ? formatDeadline(context, draft.endAt!)
                      : ''),
              _summaryRow(AppLocalizations.of(context).rvChoices,
                  AppLocalizations.of(context).rvItems(count.toString())),
              if (policyEvent != null) ...[
                _summaryRow(
                  AppLocalizations.of(context).quorumLabel,
                  policyEvent.quorumPercent == null
                      ? AppLocalizations.of(context).quorumDisabled
                      : '${policyEvent.quorumPercent}%',
                ),
                _summaryRow(
                  AppLocalizations.of(context).ballotAbstain,
                  policyEvent.allowAbstain
                      ? AppLocalizations.of(context).ballotAbstainHint
                      : AppLocalizations.of(context).quorumDisabled,
                ),
              ],
              if (!isReady) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: RaayColors.of(context)
                          .warningText
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(AppLocalizations.of(context).rvIncomplete,
                      style: TextStyle(
                          color: RaayColors.of(context).warningText,
                          fontWeight: FontWeight.w600)),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: RaayColors.of(context)
                          .errorText
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(_error!,
                        style: TextStyle(
                            color: RaayColors.of(context).errorText)),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                runSpacing: 12,
                children: [
                  TextButton(
                      style:
                          TextButton.styleFrom(minimumSize: const Size(48, 48)),
                      onPressed: _isPublishing ? null : widget.onBack,
                      child: Text(AppLocalizations.of(context).rvBack)),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.preview_outlined),
                    label: Text(AppLocalizations.of(context).rvPreview),
                    onPressed: _isPublishing || count == 0
                        ? null
                        : () {
                            final List<BallotPreviewChoice> choices = draft
                                    .multiContest
                                ? []
                                : isCand
                                    ? (ref
                                                .read(eventCandidatesProvider(
                                                    eventId))
                                                .valueOrNull ??
                                            [])
                                        .map<BallotPreviewChoice>((c) => (
                                              id: c.id,
                                              label: c.name,
                                              description: [c.party, c.bio]
                                                  .where((s) => s.isNotEmpty)
                                                  .join(' · ')
                                            ))
                                        .toList()
                                    : (ref
                                                .read(eventPollOptionsProvider(
                                                    eventId))
                                                .valueOrNull ??
                                            [])
                                        .map<BallotPreviewChoice>((o) => (
                                              id: o.id,
                                              label: o.label,
                                              description: o.description
                                            ))
                                        .toList();
                            showDialog<void>(
                                context: context,
                                builder: (_) => BallotRehearsalDialog(
                                      title: draft.title,
                                      description: draft.description,
                                      privacyLabel: draft.privacyMode ==
                                              PrivacyMode.anonymous
                                          ? AppLocalizations.of(context)
                                              .privacyAnonymous
                                          : AppLocalizations.of(context)
                                              .privacyIdentifiable,
                                      choices: choices,
                                      allowAbstain:
                                          policyEvent?.allowAbstain ?? false,
                                      quorumPercent: policyEvent?.quorumPercent,
                                      contests: draft.multiContest
                                          ? ref
                                                  .read(
                                                      singleVotingEventProvider(
                                                          eventId))
                                                  .valueOrNull
                                                  ?.contests ??
                                              const []
                                          : const [],
                                    ));
                          },
                  ),
                  FilledButton(
                    style:
                        FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                    onPressed:
                        _isPublishing || !isReady ? null : _confirmAndPublish,
                    child: _isPublishing
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(AppLocalizations.of(context).rvPublishButton),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget _checklistRow(BuildContext context, _ChecklistItem item) {
    final kc = RaayColors.of(context);
    final color = item.done
        ? kc.successText
        : (item.optional ? kc.textSecondary : kc.errorText);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            item.done
                ? Icons.check_circle_rounded
                : (item.optional
                    ? Icons.radio_button_unchecked
                    : Icons.error_outline_rounded),
            size: 18,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label +
                  (item.optional && !item.done
                      ? AppLocalizations.of(context).rvOptional
                      : ''),
              style: TextStyle(
                  fontSize: 14, color: RaayColors.textPrimaryOf(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        spacing: 12,
        runSpacing: 2,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 100),
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: RaayColors.textPrimaryOf(context))),
          ),
          Text(value, softWrap: true),
        ],
      ),
    );
  }
}

/// Package B2's election setup checklist item: [optional] items (currently
/// just the description) don't block publishing even when incomplete.
class _ChecklistItem {
  const _ChecklistItem(this.label, this.done, {this.optional = false});
  final String label;
  final bool done;
  final bool optional;
}
