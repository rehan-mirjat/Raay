import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../../../core/layout/responsive.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/reauth_dialog.dart';
import '../../data/voting_event_repository.dart';
import '../providers/draft_event_provider.dart';
import '../../data/candidate_repository.dart';
import '../../data/poll_option_repository.dart';
import '../../domain/voting_event.dart';
import '../../../../core/utils/error_utils.dart';

class ReviewStep extends ConsumerStatefulWidget {
  final String orgId;
  final VoidCallback onBack;

  const ReviewStep({super.key, required this.orgId, required this.onBack});

  @override
  ConsumerState<ReviewStep> createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  static final _dateFormat = DateFormat('MMM d, yyyy h:mm a');
  bool _isPublishing = false;
  String? _error;

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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Voting Event Published Successfully!',
                style: TextStyle(color: AppTheme.success))));
        // Navigate back to admin events dashboard
        context.go('/admin/events');
      }
    } on RequiresRecentAuthException {
      if (!mounted) return;
      final verified = await showReauthDialog(context, ref,
          reason: 'For security, publishing an election requires you to have '
              'signed in within the last 15 minutes. Please verify your '
              'identity to continue.');
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
          _error = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(draftEventProvider(widget.orgId));
    final eventId = draft.serverEventId;
    if (eventId == null) return const SizedBox.shrink();

    // Check completeness locally for UX warning
    final bool isCand = draft.votingType == VotingType.candidateElection;
    final bool isPoll = draft.votingType == VotingType.singleChoicePoll;

    Stream<int> countStream;
    if (isCand) {
      countStream = ref
          .watch(candidateRepositoryProvider)
          .watchEventCandidates(eventId)
          .map((v) => v.length);
    } else if (isPoll) {
      countStream = ref
          .watch(pollOptionRepositoryProvider)
          .watchEventPollOptions(eventId)
          .map((v) => v.length);
    } else {
      countStream = Stream.value(2); // Safe for YesNo
    }

    return StreamBuilder<int>(
        stream: countStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          if (snapshot.hasError) {
            return Text('Error loading choices: ${snapshot.error}');
          }

          final count = snapshot.data ?? 0;
          final hasChoices =
              count >= 2 || draft.votingType == VotingType.yesNoPoll;
          final hasSchedule = draft.startAt != null &&
              draft.endAt != null &&
              draft.endAt!.isAfter(draft.startAt!);
          final hasEligibility = draft.eligibilityType == EligibilityType.allMembers ||
              draft.selectedDepartmentIds.isNotEmpty ||
              draft.selectedUserIds.isNotEmpty;
          final hasTitle = draft.title.trim().isNotEmpty;
          final checklist = <_ChecklistItem>[
            _ChecklistItem('Title configured', hasTitle),
            _ChecklistItem(
                'Description added',
                draft.description.trim().isNotEmpty,
                optional: true),
            _ChecklistItem('Voting window scheduled', hasSchedule),
            _ChecklistItem(
                'Privacy mode set (${draft.privacyMode == PrivacyMode.identifiable ? 'Identifiable' : 'Anonymous'})',
                true),
            _ChecklistItem(
                'Candidates/options configured ($count)', hasChoices),
            _ChecklistItem(
                'Eligibility rules valid (${draft.eligibilityType.label})',
                hasEligibility),
          ];
          final isReady = checklist.every((c) => c.done || c.optional);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Review & Publish',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('ELECTION SETUP CHECKLIST',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textSecondaryOf(context),
                      letterSpacing: 0.8)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: KivoraColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: KivoraColors.borderOf(context)),
                ),
                child: Column(
                  children: checklist.map((c) => _checklistRow(context, c)).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _summaryRow('Title', draft.title),
              _summaryRow(
                  'Start At',
                  draft.startAt != null
                      ? _dateFormat.format(draft.startAt!)
                      : ''),
              _summaryRow(
                  'End At',
                  draft.endAt != null
                      ? _dateFormat.format(draft.endAt!)
                      : ''),
              _summaryRow('Choices', '$count items configured'),
              if (!isReady) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                      'Complete every required checklist item above before publishing.',
                      style: TextStyle(color: AppTheme.warning, fontWeight: FontWeight.w600)),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppTheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('Publish Error: $_error',
                      style: const TextStyle(color: AppTheme.error)),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: _isPublishing ? null : widget.onBack,
                      child: const Text('Back')),
                  ElevatedButton(
                    onPressed: _isPublishing || !isReady ? null : _publish,
                    child: _isPublishing
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Publish Event'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget _checklistRow(BuildContext context, _ChecklistItem item) {
    final color = item.done
        ? AppTheme.success
        : (item.optional ? KivoraColors.textSecondaryOf(context) : AppTheme.error);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            item.done
                ? Icons.check_circle_rounded
                : (item.optional ? Icons.radio_button_unchecked : Icons.error_outline_rounded),
            size: 18,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label + (item.optional && !item.done ? ' (optional)' : ''),
              style: TextStyle(
                  fontSize: 13,
                  color: KivoraColors.textPrimaryOf(context),
                  decoration: item.done ? null : null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveLayout.isCompact(context) ? 76 : 100,
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: KivoraColors.textPrimaryOf(context))),
          ),
          Expanded(child: Text(value, softWrap: true)),
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
