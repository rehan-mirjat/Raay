import '../../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../../../core/theme/kivora_icons.dart';
import '../../../../core/utils/friendly_error.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../voting/presentation/cast_vote_screen.dart'
    show eventCandidatesProvider;
import '../../data/candidate_repository.dart';
import '../../domain/candidate.dart';
import 'candidate_avatar.dart';
import 'candidate_form_dialog.dart';

/// An election needs at least this many candidates before it can be published.
const kMinCandidatesToPublish = 2;

class CandidateList extends ConsumerWidget {
  final String orgId;
  final String eventId;
  final bool isDraft;

  const CandidateList(
      {super.key,
      required this.orgId,
      required this.eventId,
      required this.isDraft});

  Future<void> _delete(
      BuildContext context, WidgetRef ref, Candidate cand) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10nAsync_ = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(AppLocalizations.of(context).clRemoveTitle),
        content: Text(
            AppLocalizations.of(context).clRemoveBody(cand.name.toString())),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(c, false),
            child: Text(AppLocalizations.of(context).clKeep),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48), foregroundColor: kc.errorText),
            onPressed: () => Navigator.pop(c, true),
            child: Text(AppLocalizations.of(context).clRemove),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await ref.read(candidateRepositoryProvider).deleteCandidate(cand.id);
    } catch (e) {
      messenger.showSnackBar(SnackBar(
          content:
              Text(friendlyError(e, fallback: l10nAsync_.clRemoveFailed))));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    // Stable provider: a stream created in build() would reload on every rebuild
    // (for example each time a dialog closes).
    final candsAsync = ref.watch(eventCandidatesProvider(eventId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isDraft)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              icon: const Icon(KivoraIcons.plus, size: 18),
              label: Text(AppLocalizations.of(context).clAdd),
              onPressed: () => showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    CandidateFormDialog(orgId: orgId, eventId: eventId),
              ),
            ),
          )
        else
          _note(kc, Icons.lock_outline_rounded,
              AppLocalizations.of(context).clLocked),
        const SizedBox(height: 16),
        candsAsync.when(
          loading: () => const LoadingView(),
          error: (_, __) => Column(children: [
            Text(AppLocalizations.of(context).clLoadError,
                style: TextStyle(color: kc.errorText)),
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => ref.invalidate(eventCandidatesProvider(eventId)),
              child: Text(AppLocalizations.of(context).clRetry),
            ),
          ]),
          data: (candidates) {
            final missing = kMinCandidatesToPublish - candidates.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tells the admin what is still needed before Review will allow publishing.
                Semantics(
                  liveRegion: true,
                  child: _note(
                    kc,
                    missing > 0
                        ? Icons.info_outline_rounded
                        : Icons.check_circle_outline_rounded,
                    missing > 0
                        ? (missing == 1
                            ? AppLocalizations.of(context)
                                .clNeedOne(kMinCandidatesToPublish.toString())
                            : AppLocalizations.of(context).clNeedMany(
                                missing.toString(),
                                kMinCandidatesToPublish.toString()))
                        : AppLocalizations.of(context)
                            .clCount(candidates.length.toString()),
                    color: missing > 0 ? kc.warningText : kc.successText,
                  ),
                ),
                const SizedBox(height: 12),
                if (candidates.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(AppLocalizations.of(context).clNone,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kc.textSecondary)),
                  )
                else
                  for (final cand in candidates) ...[
                    _CandidateCard(
                      cand: cand,
                      isDraft: isDraft,
                      onEdit: () => showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => CandidateFormDialog(
                            orgId: orgId,
                            eventId: eventId,
                            existingCandidate: cand),
                      ),
                      onDelete: () => _delete(context, ref, cand),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _note(KivoraColors kc, IconData icon, String text, {Color? color}) {
    final c = color ?? kc.accentText;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: kc.isDark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        border: Border.all(color: c.withValues(alpha: 0.5)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 20, color: c),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 14, color: kc.textPrimary))),
      ]),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard(
      {required this.cand,
      required this.isDraft,
      required this.onEdit,
      required this.onDelete});
  final Candidate cand;
  final bool isDraft;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CandidateAvatar(candidate: cand),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cand.name,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kc.textPrimary)),
                const SizedBox(height: 2),
                Text(
                    cand.party.isNotEmpty
                        ? cand.party
                        : AppLocalizations.of(context).clIndependent,
                    style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                if (cand.bio.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(cand.bio,
                      style: TextStyle(
                          fontSize: 14, color: kc.textSecondary, height: 1.3),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          if (isDraft)
            Column(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                tooltip:
                    AppLocalizations.of(context).clEdit(cand.name.toString()),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: const Icon(KivoraIcons.edit3, size: 20),
                onPressed: onEdit,
              ),
              IconButton(
                tooltip: AppLocalizations.of(context)
                    .clRemoveName(cand.name.toString()),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(KivoraIcons.trash2, size: 20, color: kc.errorText),
                onPressed: onDelete,
              ),
            ]),
        ],
      ),
    );
  }
}
