import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/friendly_error.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../voting/presentation/cast_vote_screen.dart'
    show singleVotingEventProvider;
import '../../data/voting_event_repository.dart';
import '../../domain/voting_event.dart';
import '../providers/draft_event_provider.dart';

class MultiContestEditor extends ConsumerStatefulWidget {
  const MultiContestEditor(
      {super.key,
      required this.orgId,
      required this.eventId,
      required this.onNext,
      required this.onBack});
  final String orgId;
  final String eventId;
  final VoidCallback onNext;
  final VoidCallback onBack;
  @override
  ConsumerState<MultiContestEditor> createState() => _MultiContestEditorState();
}

class _MultiContestEditorState extends ConsumerState<MultiContestEditor> {
  final _form = GlobalKey<FormState>();
  List<Map<String, dynamic>>? _contests;
  bool _busy = false;
  String? _error;
  int _sequence = 0;
  String _id() => 'c_${DateTime.now().microsecondsSinceEpoch}_${_sequence++}';
  Map<String, dynamic> _choice() =>
      {'id': _id(), 'label': '', 'description': ''};
  Map<String, dynamic> _contest() => {
        'id': _id(),
        'title': '',
        'choices': [_choice(), _choice()]
      };
  void _dirty() => ref
      .read(draftEventProvider(widget.orgId).notifier)
      .markChoicesDirty(true);
  Future<void> _back() async {
    if (ref.read(draftEventProvider(widget.orgId)).choicesDirty) {
      final l10n = AppLocalizations.of(context);
      final discard = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Text(l10n.mcDiscard),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l10n.rvKeepEditing)),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l10n.rvBack)),
                ],
              ));
      if (!mounted || discard != true) return;
      ref
          .read(draftEventProvider(widget.orgId).notifier)
          .markChoicesDirty(false);
    }
    widget.onBack();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(votingEventRepositoryProvider)
          .updateVotingEvent(eventId: widget.eventId, contests: _contests!);
      if (!mounted) return;
      ref
          .read(draftEventProvider(widget.orgId).notifier)
          .markChoicesDirty(false);
      ref.invalidate(singleVotingEventProvider(widget.eventId));
      widget.onNext();
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final event = ref.watch(singleVotingEventProvider(widget.eventId));
    return event.when(
      loading: () => const LoadingView(),
      error: (_, __) => Text(l10n.rvChoicesError),
      data: (event) {
        if (event == null || !event.isMultiContest) {
          return Text(l10n.rvChoicesError);
        }
        _contests ??= event.contests.isEmpty
            ? [_contest(), _contest()]
            : event.contests.map((c) => c.toMap()).toList();
        final editable = !_busy && event.status == VotingEventStatus.draft;
        String? requiredValue(String? value) =>
            value == null || value.trim().isEmpty ? l10n.mcRequired : null;
        return Form(
            key: _form,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.mcMode,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(l10n.mcPolicy),
                  const SizedBox(height: 16),
                  for (final contest in _contests!)
                    Card(
                        key: ValueKey(contest['id']),
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              Row(children: [
                                Expanded(
                                    child: TextFormField(
                                  initialValue: contest['title'] as String,
                                  enabled: editable,
                                  maxLength: 100,
                                  decoration: InputDecoration(
                                      labelText: l10n.mcContestTitle),
                                  validator: requiredValue,
                                  onChanged: (value) {
                                    contest['title'] = value;
                                    _dirty();
                                  },
                                )),
                                IconButton(
                                    tooltip: l10n.mcRemove,
                                    onPressed:
                                        !editable || _contests!.length <= 2
                                            ? null
                                            : () {
                                                _dirty();
                                                setState(() =>
                                                    _contests!.remove(contest));
                                              },
                                    icon: const Icon(Icons.delete_outline))
                              ]),
                              for (final choice in contest['choices'] as List)
                                Padding(
                                    key: ValueKey(choice['id']),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(children: [
                                      Row(children: [
                                        Expanded(
                                            child: TextFormField(
                                          initialValue:
                                              choice['label'] as String,
                                          enabled: editable,
                                          maxLength: 100,
                                          decoration: InputDecoration(
                                              labelText: l10n.mcChoiceLabel),
                                          validator: requiredValue,
                                          onChanged: (value) {
                                            choice['label'] = value;
                                            _dirty();
                                          },
                                        )),
                                        IconButton(
                                            tooltip: l10n.mcRemove,
                                            onPressed: !editable ||
                                                    (contest['choices'] as List)
                                                            .length <=
                                                        2
                                                ? null
                                                : () {
                                                    _dirty();
                                                    setState(() =>
                                                        (contest['choices']
                                                                as List)
                                                            .remove(choice));
                                                  },
                                            icon: const Icon(
                                                Icons.remove_circle_outline))
                                      ]),
                                      TextFormField(
                                          initialValue: choice['description']
                                                  as String? ??
                                              '',
                                          enabled: editable,
                                          maxLength: 500,
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                              labelText: l10n.mcDescription),
                                          onChanged: (value) {
                                            choice['description'] = value;
                                            _dirty();
                                          }),
                                    ])),
                              OutlinedButton.icon(
                                  onPressed: !editable ||
                                          (contest['choices'] as List).length >=
                                              20
                                      ? null
                                      : () {
                                          _dirty();
                                          setState(() =>
                                              (contest['choices'] as List)
                                                  .add(_choice()));
                                        },
                                  icon: const Icon(Icons.add),
                                  label: Text(l10n.mcAddChoice)),
                            ]))),
                  OutlinedButton.icon(
                      onPressed: !editable || _contests!.length >= 10
                          ? null
                          : () {
                              _dirty();
                              setState(() => _contests!.add(_contest()));
                            },
                      icon: const Icon(Icons.add),
                      label: Text(l10n.mcAddContest)),
                  if (_error != null)
                    Text(_error!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  const SizedBox(height: 20),
                  Wrap(spacing: 12, runSpacing: 12, children: [
                    TextButton(
                        onPressed: _busy ? null : _back,
                        child: Text(l10n.chBack)),
                    FilledButton(
                        onPressed: editable ? _save : null,
                        child: Text(l10n.mcSave)),
                  ]),
                ]));
      },
    );
  }
}
