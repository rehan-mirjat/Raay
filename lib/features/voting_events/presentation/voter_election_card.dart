import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/election_card_state.dart';
import '../domain/voting_event.dart';
import 'providers/voter_portal_providers.dart';

/// "Oct 24, 6:00 PM PKT". Falls back to English if intl has no date data for
/// the locale, so an unsupported locale can never crash the screen.
String formatDeadline(BuildContext context, DateTime value) {
  final local = value.toLocal();
  String pattern(String locale) => DateFormat('MMM d, h:mm a', locale).format(local);
  String text;
  try {
    text = pattern(Localizations.localeOf(context).toString());
  } catch (_) {
    text = pattern('en');
  }
  return '$text ${local.timeZoneName}';
}

/// One election on the voter home. Height follows its content (no fixed
/// aspect ratio), titles wrap, and the primary action comes only from
/// [primaryActionFor].
class VoterElectionCard extends StatelessWidget {
  const VoterElectionCard({
    super.key,
    required this.entry,
    required this.participation,
    required this.results,
  });

  final VoterPortalEntry entry;
  final ParticipationStatus participation;
  final ResultsStatus results;

  ElectionCardAction get action => primaryActionFor(
        status: entry.event.status,
        isLikelyEligible: entry.isLikelyEligible,
        participation: participation,
        results: results,
      );

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final event = entry.event;

    final String timing = switch (event.status) {
      VotingEventStatus.scheduled => l10n.voterOpens(formatDeadline(context, event.startAt)),
      VotingEventStatus.active => l10n.voterCloses(formatDeadline(context, event.endAt)),
      _ => l10n.voterClosedOn(formatDeadline(context, event.endAt)),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
        boxShadow: AppTheme.cardShadow(dark: kc.isDark),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: kc.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            entry.organization.name,
            style: TextStyle(fontSize: 14, color: kc.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusBadge.eventStatus(event.status.name),
              StatusBadge.privacyMode(event.privacyMode.name),
              ..._chips(context, l10n),
            ],
          ),
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
                child: Text(timing, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: _buildAction(context, l10n)),
        ],
      ),
    );
  }

  List<Widget> _chips(BuildContext context, AppLocalizations l10n) {
    final kc = KivoraColors.of(context);
    final out = <Widget>[];
    Widget chip(String text, Color color) => Container(
          constraints: const BoxConstraints(minHeight: 24),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: kc.isDark ? 0.16 : 0.10),
            borderRadius: BorderRadius.circular(AppTheme.radiusInput),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Text(text,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        );

    if (!entry.isLikelyEligible) {
      out.add(chip(l10n.voterChipNotEligible, kc.textSecondary));
    } else if (participation == ParticipationStatus.voted) {
      out.add(chip(l10n.voterChipParticipated, kc.successText));
    } else if (participation == ParticipationStatus.unknown &&
        entry.event.status == VotingEventStatus.active) {
      out.add(chip(l10n.voterChipChecking, kc.textSecondary));
    }
    return out;
  }

  Widget _buildAction(BuildContext context, AppLocalizations l10n) {
    final id = entry.event.id;
    void go(String path) => context.go(path);
    const size = Size.fromHeight(48);

    Widget filled(String label, IconData icon, String path) => FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: size),
          onPressed: () => go(path),
          icon: Icon(icon, size: 18),
          label: Text(label, textAlign: TextAlign.center),
        );
    Widget outlined(String label, IconData icon, String path, {bool enabled = true}) =>
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: size),
          onPressed: enabled ? () => go(path) : null,
          icon: Icon(icon, size: 18),
          label: Text(label, textAlign: TextAlign.center),
        );

    switch (action) {
      case ElectionCardAction.voteNow:
        return filled(l10n.voterActionVoteNow, Icons.how_to_vote_rounded, '/elections/$id/vote');
      case ElectionCardAction.viewReceipt:
        return filled(l10n.voterActionViewReceipt, Icons.receipt_long_rounded, '/elections/$id');
      case ElectionCardAction.viewResults:
        return filled(l10n.voterActionViewResults, Icons.bar_chart_rounded, '/elections/$id/results');
      case ElectionCardAction.resultsPending:
        return outlined(l10n.voterActionResultsPending, Icons.hourglass_top_rounded, '/elections/$id');
      case ElectionCardAction.checkingStatus:
        return outlined(l10n.voterActionChecking, Icons.sync_rounded, '/elections/$id', enabled: false);
      case ElectionCardAction.viewDetails:
        return outlined(l10n.voterActionViewDetails, Icons.info_outline_rounded, '/elections/$id');
    }
  }
}
