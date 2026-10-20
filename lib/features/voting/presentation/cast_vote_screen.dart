import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
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
      setState(() => _errorMessage =
          'Please select an option before continuing.');
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
          _errorMessage = e.toString().replaceAll('Exception: ', '');
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
    final eventAsync = ref.watch(singleVotingEventProvider(widget.eventId));
    final user = ref.watch(authServiceProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cast Your Ballot'),
      ),
      body: eventAsync.when(
        loading: () => const LoadingView(),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error loading voting event: $err',
                style: const TextStyle(color: AppTheme.error)),
          ),
        ),
        data: (event) {
          if (event == null) {
            return const Center(child: Text('Voting event not found.'));
          }

          if (user == null) {
            return const Center(child: Text('You must be signed in to vote.'));
          }

          // Check if user has already voted
          final participationAsync = ref.watch(userParticipationProvider(
            UserParticipationParams(
              organizationId: event.organizationId,
              eventId: event.id,
              userId: user.uid,
            ),
          ));

          return participationAsync.when(
            loading: () => const LoadingView(),
            error: (err, stack) => _buildBallotView(context, event),
            data: (hasVoted) {
              if (hasVoted) {
                return _buildAlreadyVotedView(context, event, user.uid);
              }
              return _buildBallotView(context, event);
            },
          );
        },
      ),
    );
  }

  Widget _buildAlreadyVotedView(
      BuildContext context, VotingEvent event, String userId) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: ResponsiveLayout.pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 72, color: AppTheme.success),
              const SizedBox(height: 20),
              Text(
                l10n.voteAlreadyVotedTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.voteAlreadyVotedMessage(event.title),
                style:
                    TextStyle(color: KivoraColors.textSecondaryOf(context), height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  final receipt =
                      await ref.read(votingRepositoryProvider).getUserReceipt(
                            organizationId: event.organizationId,
                            eventId: event.id,
                            userId: userId,
                          );
                  if (context.mounted && receipt != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => VoteReceiptScreen(
                          receipt: receipt,
                          eventTitle: event.title,
                        ),
                      ),
                    );
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Receipt not found.')),
                    );
                  }
                },
                icon: const Icon(Icons.receipt_long),
                label: Text(l10n.voteViewReceipt),
              ),
              if (event.status == VotingEventStatus.closed ||
                  event.status == VotingEventStatus.archived) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/elections/${event.id}/results'),
                  icon: const Icon(Icons.bar_chart_rounded),
                  label: Text(l10n.voteViewResults),
                ),
              ],
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/home'),
                child: Text(l10n.receiptReturnHome),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBallotView(BuildContext context, VotingEvent event) {
    // We remove the strict local clock `now.isBefore(event.endAt)` check here.
    // If the local clock is fast, we shouldn't block the user. The backend
    // `FieldValue.serverTimestamp()` transaction will definitively accept or reject it.
    final isWindowOpen = event.status == VotingEventStatus.active;
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: ResponsiveLayout.pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStepIndicator(context),
              const SizedBox(height: 20),

              if (!isWindowOpen) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppTheme.warning),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          event.status == VotingEventStatus.scheduled
                              ? l10n.voteNotOpenYet
                              : l10n.voteClosed,
                          style: TextStyle(
                              color: KivoraColors.textPrimaryOf(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Event Header Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'OFFICIAL BALLOT',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.success,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined,
                                  size: 16, color: KivoraColors.textSecondaryOf(context)),
                              const SizedBox(width: 4),
                              Text(
                                _getTimeRemaining(event.endAt),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: KivoraColors.textSecondaryOf(context),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.title,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textPrimaryOf(context)),
                      ),
                      if (event.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          event.description,
                          style: TextStyle(
                              color: KivoraColors.textSecondaryOf(context), height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (event.privacyMode == PrivacyMode.identifiable)
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      const Icon(Icons.visibility_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Identifiable ballot: your selected choice will be associated with your account.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]),
                  ),
                ),
              if (event.privacyMode == PrivacyMode.identifiable)
                const SizedBox(height: 16),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppTheme.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppTheme.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: AppTheme.error)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (_step == _BallotStep.select) ...[
                Text(
                  l10n.voteSelectionPrompt.toUpperCase(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textSecondaryOf(context),
                      letterSpacing: 1.1),
                ),
                const SizedBox(height: 12),

                // Dynamic Options rendering based on event type
                if (event.votingType == VotingType.candidateElection)
                  _buildCandidateOptions(event)
                else if (event.votingType == VotingType.yesNoPoll)
                  _buildYesNoOptions(event)
                else
                  _buildPollOptions(event),

                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: !isWindowOpen ? null : _goToReview,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(l10n.voteReviewBallot),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                ),
              ] else
                _buildReviewStep(context, event, isWindowOpen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    final kc = KivoraColors.of(context);
    Widget step(int number, String label, bool active, bool complete) {
      final color = active || complete ? AppTheme.primaryBlue : kc.textSecondary;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: active || complete
                ? AppTheme.primaryBlue
                : kc.border,
            child: complete
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text('$number',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : kc.textSecondary)),
          ),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  color: color)),
        ],
      );
    }

    final l10n = AppLocalizations.of(context);
    final isReview = _step == _BallotStep.review;
    return Semantics(
      label: isReview
          ? 'Step 2 of 2: Review your ballot'
          : 'Step 1 of 2: Select your choice',
      child: Row(
        children: [
          step(1, l10n.voteStepSelect, !isReview, isReview),
          const SizedBox(width: 12),
          Container(width: 24, height: 1, color: kc.border),
          const SizedBox(width: 12),
          step(2, l10n.voteStepReview, isReview, false),
        ],
      ),
    );
  }

  Widget _buildReviewStep(
      BuildContext context, VotingEvent event, bool isWindowOpen) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final isIdentifiable = event.privacyMode == PrivacyMode.identifiable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.voteReviewYourBallot.toUpperCase(),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: kc.textSecondary,
              letterSpacing: 1.1),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.how_to_vote, color: AppTheme.primaryBlue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.voteYourSelection,
                        style: TextStyle(fontSize: 12, color: kc.textSecondary)),
                    Text(
                      _selectedChoiceName ?? l10n.voteYourSelection,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isIdentifiable
                ? Colors.deepOrange.withValues(alpha: 0.08)
                : AppTheme.success.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isIdentifiable ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: isIdentifiable ? Colors.deepOrange : AppTheme.success,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isIdentifiable
                      ? l10n.voteIdentifiableExplanation
                      : l10n.voteAnonymousExplanation,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isIdentifiable ? Colors.deepOrange : AppTheme.success),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : () => setState(() => _step = _BallotStep.select),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(l10n.actionBack),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: (!isWindowOpen || _isSubmitting)
                    ? null
                    : () => _submitBallot(event),
                icon: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(_isSubmitting
                    ? l10n.voteSubmitting
                    : l10n.voteConfirmAndCast),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCandidateOptions(VotingEvent event) {
    final candidatesAsync = ref.watch(eventCandidatesProvider(event.id));

    return candidatesAsync.when(
      loading: () => const LoadingView(),
      error: (err, stack) => Text('Error loading candidates: $err',
          style: const TextStyle(color: AppTheme.error)),
      data: (candidates) {
        if (candidates.isEmpty) {
          return const Center(child: Text('No candidates available.'));
        }

        return Column(
          children: candidates.map((cand) {
            final isSelected = _selectedCandidateId == cand.id;

            return _SelectableCard(
              isSelected: isSelected,
              semanticLabel: isSelected
                  ? '${cand.name}, candidate, selected'
                  : '${cand.name}, candidate',
              onTap: () {
                setState(() {
                  _selectedCandidateId = cand.id;
                  _selectedPollOptionId = null;
                  _selectedChoiceName = cand.name;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : KivoraColors.textSecondaryOf(context),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            AppTheme.primaryBlue.withValues(alpha: 0.1),
                        backgroundImage:
                            cand.photoUrl != null && cand.photoUrl!.isNotEmpty
                                ? NetworkImage(cand.photoUrl!)
                                : null,
                        child: cand.photoUrl == null || cand.photoUrl!.isEmpty
                            ? Text(
                                cand.name.isNotEmpty
                                    ? cand.name[0].toUpperCase()
                                    : 'C',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue))
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cand.name,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: KivoraColors.textPrimaryOf(context))),
                            if (cand.party.isNotEmpty)
                              Text(cand.party,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.w500)),
                            if (cand.bio.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(cand.bio,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: KivoraColors.textSecondaryOf(context)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPollOptions(VotingEvent event) {
    final optionsAsync = ref.watch(eventPollOptionsProvider(event.id));

    return optionsAsync.when(
      loading: () => const LoadingView(),
      error: (err, stack) => Text('Error loading options: $err',
          style: const TextStyle(color: AppTheme.error)),
      data: (options) {
        if (options.isEmpty) {
          return const Center(child: Text('No poll options available.'));
        }

        return Column(
          children: options.map((opt) {
            final isSelected = _selectedPollOptionId == opt.id;

            return _SelectableCard(
              isSelected: isSelected,
              semanticLabel: isSelected
                  ? '${opt.label}, option, selected'
                  : '${opt.label}, option',
              onTap: () {
                setState(() {
                  _selectedPollOptionId = opt.id;
                  _selectedCandidateId = null;
                  _selectedChoiceName = opt.label;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? AppTheme.primaryBlue
                          : KivoraColors.textSecondaryOf(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(opt.label,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textPrimaryOf(context))),
                          if (opt.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(opt.description,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: KivoraColors.textSecondaryOf(context))),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildYesNoOptions(VotingEvent event) {
    final yesOptionId = '${event.id}_YES';
    final noOptionId = '${event.id}_NO';

    return Column(
      children: [
        _buildChoiceCard(
          id: yesOptionId,
          title: 'YES',
          subtitle: 'In favor of this proposal',
          icon: Icons.check_circle_outline,
          color: AppTheme.success,
        ),
        const SizedBox(height: 12),
        _buildChoiceCard(
          id: noOptionId,
          title: 'NO',
          subtitle: 'Opposed to this proposal',
          icon: Icons.cancel_outlined,
          color: AppTheme.error,
        ),
      ],
    );
  }

  Widget _buildChoiceCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedPollOptionId == id;

    return _SelectableCard(
      isSelected: isSelected,
      accentColor: color,
      semanticLabel: isSelected
          ? '$title, $subtitle, selected'
          : '$title, $subtitle',
      onTap: () {
        setState(() {
          _selectedPollOptionId = id;
          _selectedCandidateId = null;
          _selectedChoiceName = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? color : KivoraColors.textSecondaryOf(context),
            ),
            const SizedBox(width: 12),
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color)),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeRemaining(DateTime endAt) {
    final diff = endAt.difference(DateTime.now());
    if (diff.isNegative) return 'Voting closed';
    if (diff.inDays > 0) return '${diff.inDays}d left';
    if (diff.inHours > 0) return '${diff.inHours}h left';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m left';
    return 'Closing soon';
  }
}

/// A ballot option card with hover-lift and press-scale feedback on desktop
/// (and no-op elsewhere), matching the established pattern in
/// organization_list_screen.dart's _ActionCard - this is the single most-used
/// interactive surface in the app and was previously a plain, static InkWell.
class _SelectableCard extends StatefulWidget {
  const _SelectableCard({
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.accentColor = AppTheme.primaryBlue,
    this.semanticLabel,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final Color accentColor;

  /// Announced by screen readers along with the selected state, e.g.
  /// "Jane Doe, candidate" - WCAG 2.2's "selection is announced correctly"
  /// requirement for ballot options (Package A3 / C3).
  final String? semanticLabel;

  @override
  State<_SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<_SelectableCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isReducedMotion = MediaQuery.of(context).disableAnimations;
    final highlighted = widget.isSelected || _isHovered;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.semanticLabel,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: widget.accentColor.withValues(alpha: 0.05),
          focusColor: widget.accentColor.withValues(alpha: 0.12),
          child: AnimatedScale(
            scale: (_isPressed && !isReducedMotion) ? 0.985 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: KivoraColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.accentColor
                      : (_isHovered
                          ? widget.accentColor.withValues(alpha: 0.4)
                          : KivoraColors.borderOf(context)),
                  width: widget.isSelected ? 2.0 : (_isHovered ? 1.4 : 1.0),
                ),
                boxShadow: highlighted
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
