import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../services/auth_service.dart';
import '../../voting_events/data/candidate_repository.dart';
import '../../voting_events/data/poll_option_repository.dart';
import '../../voting_events/data/voting_event_repository.dart';
import '../../voting_events/domain/candidate.dart';
import '../../voting_events/domain/poll_option.dart';
import '../../voting_events/domain/voting_event.dart';
import '../data/voting_repository.dart';
import 'vote_receipt_screen.dart';
import '../../voting_events/presentation/components/candidate_avatar.dart';
import '../../../core/utils/friendly_error.dart';

final eventCandidatesProvider =
    StreamProvider.autoDispose.family<List<Candidate>, String>((ref, eventId) {
  return ref.watch(candidateRepositoryProvider).watchEventCandidates(eventId);
});

final eventPollOptionsProvider =
    StreamProvider.autoDispose.family<List<PollOption>, String>((ref, eventId) {
  return ref.watch(pollOptionRepositoryProvider).watchEventPollOptions(eventId);
});

final singleVotingEventProvider =
    StreamProvider.autoDispose.family<VotingEvent?, String>((ref, eventId) {
  return ref.watch(votingEventRepositoryProvider).watchVotingEvent(eventId);
});

class CastVoteScreen extends ConsumerStatefulWidget {
  const CastVoteScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  ConsumerState<CastVoteScreen> createState() => _CastVoteScreenState();
}

enum _BallotStep { select, review }

class _CastVoteScreenState extends ConsumerState<CastVoteScreen> {
  String? _selectedCandidateId;
  String? _selectedPollOptionId;
  String? _selectedChoiceName;

  _BallotStep _step = _BallotStep.select;
  bool _isSubmitting = false;
  String? _errorMessage;

  void _goToReview() {
    if (_selectedCandidateId == null && _selectedPollOptionId == null) {
      setState(() => _errorMessage = AppLocalizations.of(context).ballotSelectFirst);
      return;
    }
    setState(() {
      _errorMessage = null;
      _step = _BallotStep.review;
    });
  }

  Future<void> _submitBallot(VotingEvent event) async {
    if (_isSubmitting) return; // re-entry guard against rapid double-taps
    if (_selectedCandidateId == null && _selectedPollOptionId == null) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final receipt = await ref.read(votingRepositoryProvider).castVote(
            organizationId: event.organizationId,
            eventId: event.id,
            candidateId: _selectedCandidateId,
            pollOptionId: _selectedPollOptionId,
          );

      if (mounted) {
        setState(() => _isSubmitting = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => VoteReceiptScreen(
              receipt: receipt,
              eventTitle: event.title,
            ),
          ),
        );
      }
    } catch (e) {
      final alreadyHandledByRecovery = await _tryRecoverOrShowError(event, e);
      if (!alreadyHandledByRecovery && mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = friendlyError(e);
        });
      }
    }
  }

  /// A network failure here is ambiguous - the request may have actually
  /// reached the server and been committed before the response was lost.
  /// castVote is already idempotent server-side (a deterministic
  /// organizationId_eventId_userId participation doc makes a resubmission
  /// fail with "already voted" rather than double-counting), but silently
  /// telling the user "something went wrong, try again" when their vote in
  /// fact succeeded would be actively misleading. So on any failure, before
  /// showing an error, re-check the authoritative receipt state and route to
  /// it if it turns out the vote did go through. Returns true if recovery
  /// found a real receipt and already navigated away, meaning the caller
  /// should NOT also show an error message.
  Future<bool> _tryRecoverOrShowError(VotingEvent event, Object error) async {
    final uid = ref.read(authServiceProvider).currentUser?.uid;
    if (uid == null) return false;
    try {
      final receipt = await ref.read(votingRepositoryProvider).getUserReceipt(
            organizationId: event.organizationId,
            eventId: event.id,
            userId: uid,
          );
      if (receipt != null && mounted) {
        setState(() => _isSubmitting = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) =>
                VoteReceiptScreen(receipt: receipt, eventTitle: event.title),
          ),
        );
        return true;
      }
    } catch (_) {
      // Ignore - fall through to showing the original error.
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final eventAsync = ref.watch(singleVotingEventProvider(widget.eventId));
    final user = ref.watch(authServiceProvider).currentUser;

    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: KivoraColors.backgroundOf(context),
        title: Text(l10n.ballotTitle),
      ),
      body: eventAsync.when(
        loading: () => const LoadingView(),
        error: (_, __) => ErrorView(
          type: ErrorViewType.generic,
          message: l10n.ballotLoadError,
          onRetry: () => ref.invalidate(singleVotingEventProvider(widget.eventId)),
        ),
        data: (event) {
          if (event == null) return Center(child: Text(l10n.ballotNotFound));
          if (user == null) return Center(child: Text(l10n.ballotSignIn));

          final participationAsync = ref.watch(userParticipationProvider(
            UserParticipationParams(
              organizationId: event.organizationId,
              eventId: event.id,
              userId: user.uid,
            ),
          ));

          return participationAsync.when(
            loading: () => const LoadingView(),
            // A failed lookup must not block voting: the server rejects a
            // second ballot, and a failed submit re-checks for a receipt.
            error: (_, __) => _buildBallotView(context, event),
            data: (hasVoted) => hasVoted
                ? _buildAlreadyVotedView(context, event, user.uid)
                : _buildBallotView(context, event),
          );
        },
      ),
    );
  }

  Widget _buildAlreadyVotedView(BuildContext context, VotingEvent event, String userId) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    return SingleChildScrollView(
      padding: ResponsiveLayout.pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.check_circle_outline, size: 72, color: kc.successText),
              const SizedBox(height: 20),
              Semantics(
                header: true,
                child: Text(l10n.voteAlreadyVotedTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kc.textPrimary)),
              ),
              const SizedBox(height: 12),
              Text(l10n.voteAlreadyVotedMessage(event.title),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kc.textSecondary, height: 1.4)),
              const SizedBox(height: 32),
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(context);
                  final receipt = await ref.read(votingRepositoryProvider).getUserReceipt(
                        organizationId: event.organizationId,
                        eventId: event.id,
                        userId: userId,
                      );
                  if (!mounted) return;
                  if (receipt != null) {
                    nav.push(MaterialPageRoute(
                        builder: (_) => VoteReceiptScreen(receipt: receipt, eventTitle: event.title)));
                  } else {
                    messenger.showSnackBar(SnackBar(content: Text(l10n.ballotReceiptMissing)));
                  }
                },
                icon: const Icon(Icons.receipt_long),
                label: Text(l10n.voteViewReceipt),
              ),
              if (event.status == VotingEventStatus.closed ||
                  event.status == VotingEventStatus.archived) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => context.go('/elections/${event.id}/results'),
                  icon: const Icon(Icons.bar_chart_rounded),
                  label: Text(l10n.voteViewResults),
                ),
              ],
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                onPressed: () => context.go('/home'),
                child: Text(l10n.receiptReturnHome),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _banner(BuildContext context, {required IconData icon, required Color color, required String text}) {
    final kc = KivoraColors.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: kc.isDark ? 0.16 : 0.10),
        borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kc.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildBallotView(BuildContext context, VotingEvent event) {
    // No strict local-clock check: if the device clock is fast we should not
    // block the voter. The server transaction definitively accepts or rejects.
    final isWindowOpen = event.status == VotingEventStatus.active;
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final inReview = _step == _BallotStep.review;
    final pad = ResponsiveLayout.pagePadding(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: pad,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxBallotWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStepIndicator(context),
                    const SizedBox(height: 20),
                    if (!isWindowOpen) ...[
                      _banner(context,
                          icon: Icons.info_outline_rounded,
                          color: kc.warningText,
                          text: event.status == VotingEventStatus.scheduled
                              ? l10n.voteNotOpenYet
                              : l10n.voteClosed),
                      const SizedBox(height: 16),
                    ],
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kc.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                        border: Border.all(color: kc.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              StatusBadge(
                                label: l10n.ballotOfficial.toUpperCase(),
                                backgroundColor: kc.successText.withValues(alpha: kc.isDark ? 0.16 : 0.10),
                                textColor: kc.successText,
                                icon: Icons.verified_outlined,
                              ),
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.timer_outlined, size: 16, color: kc.textSecondary),
                                const SizedBox(width: 4),
                                Text(_timeRemaining(l10n, event.endAt),
                                    style: TextStyle(
                                        fontSize: 14, color: kc.textSecondary, fontWeight: FontWeight.w600)),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Semantics(
                            header: true,
                            child: Text(event.title,
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                          ),
                          if (event.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(event.description,
                                style: TextStyle(color: kc.textSecondary, height: 1.4)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!inReview && event.privacyMode == PrivacyMode.identifiable) ...[
                      _banner(context,
                          icon: Icons.visibility_outlined,
                          color: kc.warningText,
                          text: l10n.voteIdentifiableExplanation),
                      const SizedBox(height: 16),
                    ],
                    if (_errorMessage != null) ...[
                      Semantics(
                        liveRegion: true,
                        child: _banner(context,
                            icon: Icons.error_outline, color: kc.errorText, text: _errorMessage!),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (!inReview) ...[
                      Text(l10n.voteSelectionPrompt,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kc.textSecondary)),
                      const SizedBox(height: 12),
                      if (event.votingType == VotingType.candidateElection)
                        _buildCandidateOptions(event)
                      else if (event.votingType == VotingType.yesNoPoll)
                        _buildYesNoOptions(event)
                      else
                        _buildPollOptions(event),
                    ] else
                      _buildReviewContent(context, event),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildActionBar(context, event, isWindowOpen),
      ],
    );
  }

  /// Sticky bottom bar. The scroll view above sits in an Expanded, so the
  /// bar never covers content and moves above the keyboard / safe area.
  Widget _buildActionBar(BuildContext context, VotingEvent event, bool isWindowOpen) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final inReview = _step == _BallotStep.review;

    final Widget actions = inReview
        ? Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.end,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: _isSubmitting ? null : () => setState(() => _step = _BallotStep.select),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(l10n.actionBack),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: (!isWindowOpen || _isSubmitting) ? null : () => _submitBallot(event),
                icon: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(_isSubmitting ? l10n.voteSubmitting : l10n.voteConfirmAndCast),
              ),
            ],
          )
        : Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: !isWindowOpen ? null : _goToReview,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(l10n.voteReviewBallot),
            ),
          );

    return Container(
      decoration: BoxDecoration(color: kc.surface, border: Border(top: BorderSide(color: kc.border))),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxBallotWidth),
            child: Padding(padding: const EdgeInsets.all(16), child: actions),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final isReview = _step == _BallotStep.review;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final primary = Theme.of(context).colorScheme.primary;

    Widget step(int number, String label, bool active, bool complete) {
      final color = active || complete ? kc.accentText : kc.textSecondary;
      return Flexible(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: active || complete ? primary : kc.border,
            child: complete
                ? Icon(Icons.check, size: 16, color: onPrimary)
                : Text('$number',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: active ? onPrimary : kc.textSecondary)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label,
                style: TextStyle(
                    fontSize: 14, fontWeight: active ? FontWeight.bold : FontWeight.normal, color: color)),
          ),
        ]),
      );
    }

    return Semantics(
      label: l10n.ballotStepsLabel(isReview ? 2 : 1, 2, isReview ? l10n.voteStepReview : l10n.voteStepSelect),
      child: ExcludeSemantics(
        child: Row(children: [
          step(1, l10n.voteStepSelect, !isReview, isReview),
          const SizedBox(width: 12),
          Container(width: 24, height: 1, color: kc.border),
          const SizedBox(width: 12),
          step(2, l10n.voteStepReview, isReview, false),
        ]),
      ),
    );
  }

  Widget _buildReviewContent(BuildContext context, VotingEvent event) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final isIdentifiable = event.privacyMode == PrivacyMode.identifiable;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(l10n.voteReviewYourBallot,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kc.textSecondary)),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: kc.isDark ? 0.16 : 0.08),
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: primary.withValues(alpha: 0.5)),
          ),
          child: Row(children: [
            Icon(Icons.how_to_vote, color: kc.accentText),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.ballotYourChoice, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                Text(_selectedChoiceName ?? l10n.voteYourSelection,
                    style: TextStyle(fontWeight: FontWeight.bold, color: kc.textPrimary, fontSize: 18)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        _banner(context,
            icon: isIdentifiable ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: isIdentifiable ? kc.warningText : kc.successText,
            text: isIdentifiable ? l10n.voteIdentifiableExplanation : l10n.voteAnonymousExplanation),
        const SizedBox(height: 12),
        _banner(context, icon: Icons.lock_outline_rounded, color: kc.accentText, text: l10n.ballotFinality),
      ],
    );
  }

  Widget _optionError(BuildContext context, String message, VoidCallback onRetry) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(children: [
      Text(message, style: TextStyle(color: kc.errorText)),
      TextButton(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
        onPressed: onRetry,
        child: Text(l10n.ballotRetry),
      ),
    ]);
  }

  Widget _buildCandidateOptions(VotingEvent event) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final candidatesAsync = ref.watch(eventCandidatesProvider(event.id));

    return candidatesAsync.when(
      loading: () => const LoadingView(),
      error: (_, __) => _optionError(context, l10n.ballotOptionsLoadError,
          () => ref.invalidate(eventCandidatesProvider(event.id))),
      data: (candidates) {
        if (candidates.isEmpty) return Center(child: Text(l10n.ballotNoCandidates));
        return Column(
          children: [
            for (final cand in candidates)
              _SelectableCard(
                isSelected: _selectedCandidateId == cand.id,
                semanticLabel: _selectedCandidateId == cand.id
                    ? '${l10n.ballotCandidate(cand.name)}, ${l10n.ballotSelectedSuffix}'
                    : l10n.ballotCandidate(cand.name),
                onTap: () => setState(() {
                  _selectedCandidateId = cand.id;
                  _selectedPollOptionId = null;
                  _selectedChoiceName = cand.name;
                }),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    _RadioMark(selected: _selectedCandidateId == cand.id),
                    const SizedBox(width: 12),
                    CandidateAvatar(candidate: cand),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(cand.name,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                        if (cand.party.isNotEmpty)
                          Text(cand.party,
                              style: TextStyle(fontSize: 14, color: kc.accentText, fontWeight: FontWeight.w500)),
                        if (cand.bio.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(cand.bio,
                              style: TextStyle(fontSize: 14, color: kc.textSecondary),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ]),
                    ),
                  ]),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPollOptions(VotingEvent event) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final optionsAsync = ref.watch(eventPollOptionsProvider(event.id));

    return optionsAsync.when(
      loading: () => const LoadingView(),
      error: (_, __) => _optionError(context, l10n.ballotOptionsLoadError,
          () => ref.invalidate(eventPollOptionsProvider(event.id))),
      data: (options) {
        if (options.isEmpty) return Center(child: Text(l10n.ballotNoOptions));
        return Column(
          children: [
            for (final opt in options)
              _SelectableCard(
                isSelected: _selectedPollOptionId == opt.id,
                semanticLabel: _selectedPollOptionId == opt.id
                    ? '${l10n.ballotOption(opt.label)}, ${l10n.ballotSelectedSuffix}'
                    : l10n.ballotOption(opt.label),
                onTap: () => setState(() {
                  _selectedPollOptionId = opt.id;
                  _selectedCandidateId = null;
                  _selectedChoiceName = opt.label;
                }),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    _RadioMark(selected: _selectedPollOptionId == opt.id),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(opt.label,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                        if (opt.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(opt.description, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                        ],
                      ]),
                    ),
                  ]),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildYesNoOptions(VotingEvent event) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    return Column(children: [
      _buildChoiceCard(
        id: '${event.id}_YES',
        title: l10n.ballotYes,
        subtitle: l10n.ballotYesDesc,
        icon: Icons.check_circle_outline,
        color: kc.successText,
      ),
      _buildChoiceCard(
        id: '${event.id}_NO',
        title: l10n.ballotNo,
        subtitle: l10n.ballotNoDesc,
        icon: Icons.cancel_outlined,
        color: kc.errorText,
      ),
    ]);
  }

  Widget _buildChoiceCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final kc = KivoraColors.of(context);
    final isSelected = _selectedPollOptionId == id;
    return _SelectableCard(
      isSelected: isSelected,
      semanticLabel: isSelected ? '$title, $subtitle, ${AppLocalizations.of(context).ballotSelectedSuffix}' : '$title, $subtitle',
      onTap: () => setState(() {
        _selectedPollOptionId = id;
        _selectedCandidateId = null;
        _selectedChoiceName = title;
      }),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          _RadioMark(selected: isSelected),
          const SizedBox(width: 12),
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              Text(subtitle, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            ]),
          ),
        ]),
      ),
    );
  }

  String _timeRemaining(AppLocalizations l10n, DateTime endAt) {
    final diff = endAt.difference(DateTime.now());
    if (diff.isNegative) return l10n.ballotTimeClosed;
    if (diff.inDays > 0) return l10n.ballotTimeDays(diff.inDays);
    if (diff.inHours > 0) return l10n.ballotTimeHours(diff.inHours);
    if (diff.inMinutes > 0) return l10n.ballotTimeMinutes(diff.inMinutes);
    return l10n.ballotTimeSoon;
  }
}

/// Selection mark: icon + label/border carry the state (never color alone).
class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Icon(
      selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: selected ? kc.accentText : kc.textSecondary,
    );
  }
}

/// Solid ballot option card: a thicker accent border plus a filled radio mark
/// show the selection. No hover-lift, scale or shadow animation.
class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.semanticLabel,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        button: true,
        selected: isSelected,
        inMutuallyExclusiveGroup: true,
        label: semanticLabel,
        child: ExcludeSemantics(
          child: Material(
            color: isSelected ? primary.withValues(alpha: kc.isDark ? 0.16 : 0.08) : kc.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              side: BorderSide(color: isSelected ? primary : kc.border, width: isSelected ? 2 : 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(onTap: onTap, child: ConstrainedBox(constraints: const BoxConstraints(minHeight: 56), child: child)),
          ),
        ),
      ),
    );
  }
}
