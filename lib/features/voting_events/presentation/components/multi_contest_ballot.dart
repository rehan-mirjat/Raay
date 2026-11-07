import 'package:flutter/material.dart';
import '../../domain/election_contest.dart';

/// Shared content layout for the real ballot and its local rehearsal.
class MultiContestBallot extends StatelessWidget {
  const MultiContestBallot(
      {super.key,
      required this.contests,
      required this.selections,
      required this.onChanged});
  final List<ElectionContest> contests;
  final Map<String, String> selections;
  final void Function(String contestId, String choiceId) onChanged;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final contest in contests)
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Semantics(
                            header: true,
                            child: Text(contest.title,
                                style:
                                    Theme.of(context).textTheme.titleMedium)),
                        const SizedBox(height: 8),
                        for (final choice in contest.choices)
                          Semantics(
                            checked: selections[contest.id] == choice.id,
                            inMutuallyExclusiveGroup: true,
                            child: ListTile(
                              selected: selections[contest.id] == choice.id,
                              leading: Icon(selections[contest.id] == choice.id
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off),
                              title: Text(choice.label),
                              subtitle: choice.description.isEmpty
                                  ? null
                                  : Text(choice.description),
                              onTap: () => onChanged(contest.id, choice.id),
                            ),
                          ),
                      ]))),
      ]);
}
