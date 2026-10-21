import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kivora/core/theme/kivora_colors.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_button.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_card.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/candidate_repository.dart';
import '../../domain/candidate.dart';
import 'candidate_form_dialog.dart';

class CandidateList extends ConsumerWidget {
  final String orgId;
  final String eventId;
  final bool isDraft;

  const CandidateList(
      {super.key,
      required this.orgId,
      required this.eventId,
      required this.isDraft});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candsAsync =
        ref.watch(candidateRepositoryProvider).watchEventCandidates(eventId);
    final kc = KivoraColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isDraft)
          KivoraButton(
            icon: KivoraIcons.plus,
            label: 'Add Candidate',
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) =>
                    CandidateFormDialog(orgId: orgId, eventId: eventId),
              );
            },
          ),
        const SizedBox(height: 20),
        StreamBuilder<List<Candidate>>(
          stream: candsAsync,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}',
                  style: TextStyle(color: KivoraColors.of(context).errorText));
            }
            final candidates = snapshot.data ?? [];
            if (candidates.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'No candidates added to this election roster yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kc.textSecondary),
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: candidates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final cand = candidates[i];
                return KivoraCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          image: cand.photoUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(cand.photoUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: cand.photoUrl == null
                            ? Icon(KivoraIcons.user, color: KivoraColors.of(context).accentText)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cand.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kc.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cand.party.isNotEmpty ? cand.party : 'Independent / No affiliation',
                              style: TextStyle(
                                fontSize: 13,
                                color: kc.textSecondary,
                              ),
                            ),
                            if (cand.bio.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                cand.bio,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kc.textSecondary,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                  builder: (ctx) => CandidateFormDialog(
                                      orgId: orgId,
                                      eventId: eventId,
                                      existingCandidate: cand),
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
                                          title:
                                              const Text('Delete Candidate?'),
                                          content: Text(
                                              'Are you sure you want to delete ${cand.name}?'),
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
                                        .read(candidateRepositoryProvider)
                                        .deleteCandidate(cand.id);
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
                );
              },
            );
          },
        ),
      ],
    );
  }
}
