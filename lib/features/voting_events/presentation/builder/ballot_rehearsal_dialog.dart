import '../../domain/election_contest.dart';
import '../components/multi_contest_ballot.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/raay_colors.dart';
import '../../../../l10n/app_localizations.dart';

typedef BallotPreviewChoice = ({String id, String label, String description});

/// Local-only interaction with real draft content. This widget has no repository,
/// provider, callable or receipt dependency and cannot submit a ballot.
class BallotRehearsalDialog extends StatefulWidget {
  const BallotRehearsalDialog(
      {super.key,
      required this.title,
      required this.description,
      required this.privacyLabel,
      required this.choices, this.allowAbstain = false, this.quorumPercent, this.contests = const []});
  final bool allowAbstain;
  final int? quorumPercent;
  final List<ElectionContest> contests;
  final String title;
  final String description;
  final String privacyLabel;
  final List<BallotPreviewChoice> choices;

  @override
  State<BallotRehearsalDialog> createState() => _BallotRehearsalDialogState();
}

class _BallotRehearsalDialogState extends State<BallotRehearsalDialog> {
  final Map<String, String> _selections = {};
  String? _selected;
  bool _abstain = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = RaayColors.of(context);
    final selected =
        widget.choices.where((choice) => choice.id == _selected).firstOrNull;
    return AlertDialog(
      title: Text(l10n.rvPreview),
      content: SizedBox(
          width: 580,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.rvPreviewNotice,
                  style: TextStyle(color: kc.warningText, height: 1.4)),
              const SizedBox(height: 20),
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
              if (widget.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(widget.description)
              ],
              const SizedBox(height: 12),
              Text(widget.privacyLabel,
                  style: TextStyle(color: kc.textSecondary)),
              const SizedBox(height: 16),
              if (widget.contests.isNotEmpty) MultiContestBallot(contests: widget.contests, selections: _selections, onChanged: (contestId, choiceId) => setState(() { _abstain = false; _selections[contestId] = choiceId; })),
              for (final choice in widget.choices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Semantics(
                      selected: choice.id == _selected,
                      button: true,
                      child: Material(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                              color: choice.id == _selected
                                  ? kc.accentText
                                  : kc.border),
                        ),
                        color: choice.id == _selected
                            ? kc.accentText.withValues(alpha: .08)
                            : kc.surface,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          leading: Icon(choice.id == _selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off),
                          title: Text(choice.label),
                          subtitle: choice.description.isEmpty
                              ? null
                              : Text(choice.description),
                          onTap: () => setState(() { _abstain = false; _selected = choice.id; }),
                        ),
                      )),
                ),
              if (widget.quorumPercent != null)
                Text('${l10n.quorumLabel}: ${widget.quorumPercent}%. ${l10n.quorumHint}'),
              if (widget.allowAbstain)
                CheckboxListTile(value: _abstain, title: Text(l10n.ballotAbstain), subtitle: Text(l10n.ballotAbstainHint), onChanged: (v) => setState(() { _abstain = v == true; _selected = null; _selections.clear(); })),
              if (selected != null)
                Semantics(
                    liveRegion: true,
                    child: Text(l10n.rvPreviewSelected(selected.label),
                        style: TextStyle(color: kc.accentText))),
            ],
          ))),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.rvPreviewClose))
      ],
    );
  }
}
