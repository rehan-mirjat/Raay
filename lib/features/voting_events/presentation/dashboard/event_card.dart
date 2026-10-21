import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/voting_event.dart';
import '../providers/event_lifecycle_provider.dart';
import '../voter_election_card.dart' show formatDeadline;

/// One election in the admin list. Height follows content, the title wraps,
/// every control is at least 48px, and the card's primary action is the only
/// filled button.
class EventCard extends ConsumerWidget {
  final VotingEvent event;

  const EventCard({super.key, required this.event});

  static const _minSize = Size(48, 48);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);

    return Material(
      color: kc.surface,
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        onTap: () => context.go('/elections/${event.id}'),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: kc.border),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kc.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(_typeLabel(l10n, event.votingType),
                  style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                StatusBadge.eventStatus(event.status.name),
                StatusBadge.privacyMode(event.privacyMode.name),
              ]),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 2, end: 8),
                    child: ExcludeSemantics(
                        child: Icon(Icons.schedule_rounded, size: 16, color: kc.textSecondary)),
                  ),
                  Expanded(
                    child: Text(
                      l10n.adminEventRange(
                          formatDeadline(context, event.startAt), formatDeadline(context, event.endAt)),
                      style: TextStyle(fontSize: 14, color: kc.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _actions(context, ref, l10n, kc),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(AppLocalizations l10n, VotingType type) => switch (type) {
        VotingType.candidateElection => l10n.adminTypeCandidate,
        VotingType.singleChoicePoll => l10n.adminTypeSingle,
        VotingType.yesNoPoll => l10n.adminTypeYesNo,
      };

  Widget _actions(BuildContext context, WidgetRef ref, AppLocalizations l10n, KivoraColors kc) {
    Widget filled(String label, String path) => FilledButton(
          style: FilledButton.styleFrom(minimumSize: _minSize),
          onPressed: () => context.go(path),
          child: Text(label, textAlign: TextAlign.center),
        );
    Widget outlined(String label, String path) => OutlinedButton(
          style: OutlinedButton.styleFrom(minimumSize: _minSize),
          onPressed: () => context.go(path),
          child: Text(label, textAlign: TextAlign.center),
        );
    Widget danger(String label, IconData icon, VoidCallback onTap) => TextButton.icon(
          style: TextButton.styleFrom(minimumSize: _minSize, foregroundColor: kc.errorText),
          onPressed: onTap,
          icon: Icon(icon, size: 18),
          label: Text(label),
        );
    Widget wrap(List<Widget> children) => Wrap(spacing: 8, runSpacing: 8, children: children);
    final id = event.id;

    switch (event.status) {
      case VotingEventStatus.draft:
        return wrap([
          filled(l10n.adminActionPublish, '/admin/events/$id/review'),
          outlined(l10n.adminActionEdit, '/admin/events/$id/edit'),
          outlined(l10n.adminActionManageChoices, '/admin/events/$id/choices'),
          danger(l10n.adminActionDelete, Icons.delete_outline_rounded,
              () => _confirm(context, ref, l10n, kind: _Destructive.delete)),
        ]);
      case VotingEventStatus.scheduled:
        return wrap([
          outlined(l10n.adminActionViewDetails, '/elections/$id'),
          danger(l10n.adminActionCancel, Icons.cancel_outlined,
              () => _confirm(context, ref, l10n, kind: _Destructive.cancel)),
        ]);
      case VotingEventStatus.active:
        return wrap([
          filled(l10n.adminActionMonitor, '/admin/events/$id/monitor'),
          danger(l10n.adminActionCloseEarly, Icons.stop_circle_outlined,
              () => _confirm(context, ref, l10n, kind: _Destructive.close)),
        ]);
      case VotingEventStatus.closed:
      case VotingEventStatus.archived:
        return wrap([filled(l10n.adminActionResults, '/elections/$id/results')]);
      case VotingEventStatus.cancelled:
        return wrap([outlined(l10n.adminActionViewDetails, '/elections/$id')]);
    }
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref, AppLocalizations l10n,
      {required _Destructive kind}) async {
    final (title, body, confirmLabel, keepLabel) = switch (kind) {
      _Destructive.delete => (
          l10n.adminDeleteTitle, l10n.adminDeleteBody(event.title), l10n.adminConfirmDelete, l10n.adminKeep),
      _Destructive.cancel => (
          l10n.adminCancelTitle, l10n.adminCancelBody(event.title), l10n.adminConfirmCancel, l10n.adminKeep),
      _Destructive.close => (
          l10n.adminCloseTitle, l10n.adminCloseBody(event.title), l10n.adminConfirmClose, l10n.adminKeep),
    };
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: _minSize),
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(keepLabel),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: _minSize, foregroundColor: KivoraColors.of(ctx).errorText),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final notifier = ref.read(eventLifecycleProvider.notifier);
    switch (kind) {
      case _Destructive.delete:
        notifier.deleteEvent(event.id);
      case _Destructive.cancel:
        notifier.cancelEvent(event.id);
      case _Destructive.close:
        notifier.closeEventEarly(event.id);
    }
  }
}

enum _Destructive { delete, cancel, close }
