import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kivora/core/theme/kivora_colors.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_button.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_card.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/poll_option_repository.dart';
import '../../domain/poll_option.dart';
import 'poll_option_form_dialog.dart';

class PollOptionList extends ConsumerWidget {
  final String orgId;
  final String eventId;
  final bool isDraft;

  const PollOptionList(
      {super.key,
      required this.orgId,
      required this.eventId,
      required this.isDraft});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optsAsync =
        ref.watch(pollOptionRepositoryProvider).watchEventPollOptions(eventId);
    final kc = KivoraColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isDraft)
          KivoraButton(
            icon: KivoraIcons.plus,
            label: 'Add Option',
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) =>
                    PollOptionFormDialog(orgId: orgId, eventId: eventId),
              );
            },
          ),
        const SizedBox(height: 20),
        StreamBuilder<List<PollOption>>(
          stream: optsAsync,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}',
                  style: TextStyle(color: KivoraColors.of(context).errorText));
            }
            final options = snapshot.data ?? [];
            if (options.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'No poll options added to this ballot yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kc.textSecondary),
                ),
              );
            }
            return ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              onReorderItem: isDraft
                  ? (oldIndex, newIndex) async {
                      final item = options.removeAt(oldIndex);
                      options.insert(newIndex, item);

                      final repo = ref.read(pollOptionRepositoryProvider);
                      for (int i = 0; i < options.length; i++) {
                        if (options[i].sortOrder != i) {
                          await repo.updatePollOption(
                              optionId: options[i].id, sortOrder: i);
                        }
                      }
                    }
                  : (o, n) {},
              itemBuilder: (ctx, i) {
                final opt = options[i];
                return Padding(
                  key: ValueKey(opt.id),
                  padding: const EdgeInsets.only(bottom: 12),
                  child: KivoraCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        if (isDraft)
                          ReorderableDragStartListener(
                            index: i,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Icon(KivoraIcons.gripVertical,
                                  color: kc.textSecondary, size: 18),
                            ),
                          ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                color: KivoraColors.of(context).accentText,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opt.label,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kc.textPrimary,
                                ),
                              ),
                              if (opt.description.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  opt.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: kc.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isDraft)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(KivoraIcons.edit3, size: 18),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (ctx) => PollOptionFormDialog(
                                        orgId: orgId,
                                        eventId: eventId,
                                        existingOption: opt),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(KivoraIcons.trash2,
                                    size: 18, color: KivoraColors.of(context).errorText),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                            title: const Text('Delete Option?'),
                                            content: Text(
                                                'Are you sure you want to delete ${opt.label}?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(c, false),
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(c, true),
                                                child: Text('Delete',
                                                    style: TextStyle(
                                                        color: KivoraColors.of(context).errorText)),
                                              ),
                                            ],
                                          ));
                                  if (confirm == true) {
                                    try {
                                      await ref
                                          .read(pollOptionRepositoryProvider)
                                          .deletePollOption(opt.id);
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(e
                                                    .toString()
                                                    .replaceAll(
                                                        'Exception: ', ''))));
                                      }
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
