import 'multi_contest_editor.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/raay_colors.dart';
import '../../domain/voting_event.dart';
import '../providers/draft_event_provider.dart';
import '../components/candidate_list.dart';
import '../components/poll_option_list.dart';

class ChoicesStep extends ConsumerWidget {
  final String orgId;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ChoicesStep(
      {super.key,
      required this.orgId,
      required this.onNext,
      required this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftState = ref.watch(draftEventProvider(orgId));
    final eventId = draftState.serverEventId;

    if (eventId == null) return const SizedBox.shrink();
    if (draftState.multiContest) return MultiContestEditor(orgId: orgId, eventId: eventId, onNext: onNext, onBack: onBack);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          draftState.votingType == VotingType.candidateElection
              ? AppLocalizations.of(context).chRoster
              : draftState.votingType == VotingType.yesNoPoll
                  ? AppLocalizations.of(context).chYesNo
                  : AppLocalizations.of(context).chPoll,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (draftState.votingType == VotingType.candidateElection)
          CandidateList(
              orgId: orgId,
              eventId: eventId,
              isDraft: draftState.status == VotingEventStatus.draft)
        else if (draftState.votingType == VotingType.singleChoicePoll)
          PollOptionList(
              orgId: orgId,
              eventId: eventId,
              isDraft: draftState.status == VotingEventStatus.draft)
        else
          _buildYesNoList(context),
        const SizedBox(height: 32),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 12,
          runSpacing: 12,
          children: [
            TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: onBack,
                child: Text(AppLocalizations.of(context).chBack)),
            FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: onNext,
                child: Text(AppLocalizations.of(context).chNext)),
          ],
        ),
      ],
    );
  }

  Widget _buildYesNoList(BuildContext context) {
    final kc = RaayColors.of(context);
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.check_circle, color: kc.successText),
          title: Text(AppLocalizations.of(context).chYes),
          subtitle: Text(AppLocalizations.of(context).chSystem),
        ),
        ListTile(
          leading: Icon(Icons.cancel, color: kc.errorText),
          title: Text(AppLocalizations.of(context).chNo),
          subtitle: Text(AppLocalizations.of(context).chSystem),
        ),
      ],
    );
  }
}
