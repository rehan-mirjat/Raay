import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
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

class _CastVoteScreenState extends ConsumerState<CastVoteScreen> {
  String? _selectedCandidateId;
  String? _selectedPollOptionId;
  String? _selectedChoiceName;

  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _submitBallot(VotingEvent event) async {
    if (_selectedCandidateId == null && _selectedPollOptionId == null) {
      setState(() => _errorMessage =
          'Please select an option before casting your ballot.');
      return;
    }

    // Show Confirmation Dialog
    final isIdentifiable = event.privacyMode == PrivacyMode.identifiable;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Icon(Icons.how_to_vote, color: AppTheme.primaryBlue),
            Text('Confirm Ballot Submission'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isIdentifiable)
                Text(
                  'This voting event records your selected choice against your account. Your selection will be associated with your identity and cannot be changed after submission.',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepOrange),
                )
              else
                Text(
                  'The ballot is anonymous and cannot be changed after submission.',
                  style: TextStyle(fontSize: 14),
                ),
              SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Text('Selection: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    Expanded(
                      child: Text(
                        _selectedChoiceName ?? 'Selected Choice',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
            child: Text('Confirm & Cast Ballot'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

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
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(singleVotingEventProvider(widget.eventId));
    final user = ref.watch(authServiceProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cast Your Ballot'),
      ),
      body: eventAsync.when(
        loading: () => const LoadingView(),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Error loading voting event: $err',
                style: TextStyle(color: AppTheme.error)),
          ),
        ),
        data: (event) {
          if (event == null) {
            return Center(child: Text('Voting event not found.'));
          }

          if (user == null) {
            return Center(child: Text('You must be signed in to vote.'));
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
    return SingleChildScrollView(
      padding: ResponsiveLayout.pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              Icon(Icons.check_circle_outline,
                  size: 72, color: AppTheme.success),
              SizedBox(height: 20),
              Text(
                'You Have Already Voted',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context),
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Your ballot for "${event.title}" has already been cast and accepted into the anonymous tally.',
                style:
                    TextStyle(color: KivoraColors.textSecondaryOf(context), height: 1.4),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
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
                icon: Icon(Icons.receipt_long),
                label: Text('View Your Confirmation Receipt'),
              ),
              SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/home'),
                child: Text('Return to Home Feed'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBallotView(BuildContext context, VotingEvent event) {
    final now = DateTime.now();
    final isWindowOpen = event.status == VotingEventStatus.active &&
        now.isAfter(event.startAt) &&
        now.isBefore(event.endAt);

    return SingleChildScrollView(
      padding: ResponsiveLayout.pagePadding(context),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                            child: Text(
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
                              SizedBox(width: 4),
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
                      SizedBox(height: 12),
                      Text(
                        event.title,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textPrimaryOf(context)),
                      ),
                      if (event.description.isNotEmpty) ...[
                        SizedBox(height: 8),
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
              SizedBox(height: 24),

              if (event.privacyMode == PrivacyMode.identifiable)
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Icon(Icons.visibility_outlined),
                      SizedBox(width: 12),
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
                SizedBox(height: 16),

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
                      Icon(Icons.error_outline, color: AppTheme.error),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(_errorMessage!,
                            style: TextStyle(color: AppTheme.error)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],

              Text(
                'MAKE YOUR SELECTION',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: KivoraColors.textSecondaryOf(context),
                    letterSpacing: 1.1),
              ),
              SizedBox(height: 12),

              // Dynamic Options rendering based on event type
              if (event.votingType == VotingType.candidateElection)
                _buildCandidateOptions(event)
              else if (event.votingType == VotingType.yesNoPoll)
                _buildYesNoOptions(event)
              else
                _buildPollOptions(event),

              SizedBox(height: 32),

              // Submit Button
              ElevatedButton.icon(
                onPressed: (!isWindowOpen || _isSubmitting)
                    ? null
                    : () => _submitBallot(event),
                icon: _isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Icon(Icons.send_rounded),
                label: Text(_isSubmitting
                    ? 'Submitting Ballot...'
                    : 'Submit Official Ballot'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateOptions(VotingEvent event) {
    final candidatesAsync = ref.watch(eventCandidatesProvider(event.id));

    return candidatesAsync.when(
      loading: () => const LoadingView(),
      error: (err, stack) => Text('Error loading candidates: $err',
          style: TextStyle(color: AppTheme.error)),
      data: (candidates) {
        if (candidates.isEmpty) {
          return Center(child: Text('No candidates available.'));
        }

        return Column(
          children: candidates.map((cand) {
            final isSelected = _selectedCandidateId == cand.id;

            return _SelectableCard(
              isSelected: isSelected,
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
                      SizedBox(width: 12),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue))
                            : null,
                      ),
                      SizedBox(width: 16),
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
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.primaryBlue,
                                      fontWeight: FontWeight.w500)),
                            if (cand.bio.isNotEmpty) ...[
                              SizedBox(height: 4),
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
          style: TextStyle(color: AppTheme.error)),
      data: (options) {
        if (options.isEmpty) {
          return Center(child: Text('No poll options available.'));
        }

        return Column(
          children: options.map((opt) {
            final isSelected = _selectedPollOptionId == opt.id;

            return _SelectableCard(
              isSelected: isSelected,
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
                    SizedBox(width: 12),
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
                            SizedBox(height: 4),
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
        SizedBox(height: 12),
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
            SizedBox(width: 12),
            Icon(icon, color: color, size: 28),
            SizedBox(width: 16),
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
  });

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final Color accentColor;

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

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
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
    );
  }
}
