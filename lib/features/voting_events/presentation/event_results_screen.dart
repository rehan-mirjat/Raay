import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseException;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/firebase_service.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../../voting/presentation/cast_vote_screen.dart';
import '../domain/election_results.dart';
import 'providers/voter_portal_providers.dart';
import 'voter_portal_screen.dart' show AdaptiveCardGrid;

/// Series colors for result rows. Each pairs with a text label and the row's
/// own percentage, so color is never the only identifier.
List<Color> _seriesColors(KivoraColors kc) => [
      kc.isDark ? const Color(0xFF5EEAD4) : const Color(0xFF0F766E),
      kc.isDark ? const Color(0xFFB8A8FF) : const Color(0xFF5936DB),
      kc.isDark ? const Color(0xFFF5B94A) : const Color(0xFF8A5A00),
      kc.isDark ? const Color(0xFFFF8A80) : const Color(0xFFB42318),
      kc.isDark ? const Color(0xFF7DB8FF) : const Color(0xFF0B5CAD),
    ];

/// Admin results: management actions live here, so no ads on this screen.
class EventResultsScreen extends ConsumerStatefulWidget {
  const EventResultsScreen({super.key, required this.eventId});
  final String eventId;

  @override
  ConsumerState<EventResultsScreen> createState() => _EventResultsScreenState();
}

class _EventResultsScreenState extends ConsumerState<EventResultsScreen> {
  bool _busy = false;

  Future<void> _run(String functionName) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await FirebaseService().functions.httpsCallable(functionName).call({'eventId': widget.eventId});
    } on FirebaseFunctionsException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.message ?? l10n.resActionFailed)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.resActionFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmPublish() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resPublishConfirmTitle),
        content: Text(l10n.resPublishConfirmBody),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.resCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.resPublishConfirm),
          ),
        ],
      ),
    );
    if (ok == true) await _run('publishResults');
  }

  void _showCsv(String title, ElectionResults results) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final csv = resultsCsv(title: title, results: results);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resExportTitle),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kc.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                border: Border.all(color: kc.border),
              ),
              child: SelectableText(csv, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
            ),
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.resClose),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: csv));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.resCsvCopied)));
            },
            icon: const Icon(Icons.copy, size: 18),
            label: Text(l10n.resCopyCsv),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final canManage =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context?.member.isAdmin ?? false;
    final event = ref.watch(singleVotingEventProvider(widget.eventId)).valueOrNull;
    final dataAsync = ref.watch(eventResultsDataProvider(widget.eventId));
    final pad = ResponsiveLayout.pagePadding(context);

    Widget back() => Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => context.go('/elections/${widget.eventId}'),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: Text(event?.title ?? l10n.resBack, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        );

    Widget shell(Widget body) => SafeArea(
          child: SingleChildScrollView(
            padding: pad,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [back(), const SizedBox(height: 8), body]),
              ),
            ),
          ),
        );

    return Scaffold(
      backgroundColor: kc.background,
      body: dataAsync.when(
        loading: () => shell(const Padding(padding: EdgeInsets.all(32), child: LoadingView())),
        error: (err, _) {
          final denied = err is FirebaseException && err.code == 'permission-denied';
          if (denied && !canManage) {
            return shell(ErrorView(
                type: ErrorViewType.generic,
                title: l10n.resNotAvailableTitle,
                message: l10n.resNotAvailableBody));
          }
          return shell(ErrorView(
            type: ErrorViewType.generic,
            title: l10n.resLoadErrorTitle,
            message: l10n.resLoadErrorBody,
            onRetry: () => ref.invalidate(eventResultsDataProvider(widget.eventId)),
          ));
        },
        data: (data) {
          if (data == null) {
            return shell(EmptyView(
              icon: Icons.query_stats_rounded,
              title: l10n.resNoneTitle,
              message: l10n.resNoneBody,
              actionLabel: canManage ? (_busy ? l10n.resWorking : l10n.resCalculate) : null,
              onAction: canManage && !_busy ? () => _run('calculateResults') : null,
            ));
          }
          final results = parseElectionResults(data);
          return shell(_body(context, l10n, kc, event?.title, results, canManage));
        },
      ),
    );
  }

  Widget _body(BuildContext context, AppLocalizations l10n, KivoraColors kc, String? eventTitle,
      ElectionResults results, bool canManage) {
    final colors = _seriesColors(kc);
    final outcome = outcomeFor(results.rows, results.total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(spacing: 12, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
          Semantics(
            header: true,
            child: Text(l10n.resTitle,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kc.textPrimary)),
          ),
          results.published
              ? StatusBadge(
                  label: l10n.resPublished.toUpperCase(),
                  backgroundColor: kc.successText.withValues(alpha: kc.isDark ? 0.16 : 0.10),
                  textColor: kc.successText,
                  icon: Icons.public_rounded)
              : StatusBadge(
                  label: l10n.resNotPublished.toUpperCase(),
                  backgroundColor: kc.warningText.withValues(alpha: kc.isDark ? 0.16 : 0.10),
                  textColor: kc.warningText,
                  icon: Icons.lock_outline_rounded),
        ]),
        const SizedBox(height: 4),
        Text(l10n.resSubtitle, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
        const SizedBox(height: 20),
        if (outcome != null) ...[_OutcomeBanner(outcome: outcome), const SizedBox(height: 16)],
        AdaptiveCardGrid(minColumnWidth: 200, children: [
          _Stat(label: l10n.resBallots, value: '${results.total}'),
          _Stat(label: l10n.resEligible, value: '${results.eligible}'),
          _Stat(label: l10n.resTurnout, value: '${results.turnout.toStringAsFixed(0)}%', progress: results.turnout / 100),
        ]),
        const SizedBox(height: 16),
        if (!results.published) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kc.warningText.withValues(alpha: kc.isDark ? 0.14 : 0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              border: Border.all(color: kc.warningText.withValues(alpha: 0.5)),
            ),
            child: Text(l10n.resAdminOnly, style: TextStyle(fontSize: 14, color: kc.textPrimary)),
          ),
          const SizedBox(height: 16),
        ],
        if (results.rows.length > 1) ...[
          Text(l10n.resSplit, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kc.textSecondary)),
          const SizedBox(height: 8),
          _SplitBar(rows: results.rows, colors: colors),
          const SizedBox(height: 20),
        ],
        for (var i = 0; i < results.rows.length; i++) ...[
          _ResultRowCard(row: results.rows[i], color: colors[i % colors.length]),
          const SizedBox(height: 10),
        ],
        if (results.rows.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kc.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              border: Border.all(color: kc.border),
            ),
            child: Text(l10n.resNoBallots, style: TextStyle(color: kc.textPrimary)),
          ),
        const SizedBox(height: 16),
        Text(l10n.resFootnote, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
        if (canManage) ...[
          const SizedBox(height: 20),
          Divider(color: kc.border),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: _busy ? null : () => _run('calculateResults'),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(_busy ? l10n.resWorking : l10n.resRecalculate),
            ),
            if (!results.published)
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                onPressed: _busy ? null : _confirmPublish,
                icon: const Icon(Icons.publish_rounded, size: 18),
                label: Text(l10n.resPublish),
              ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => _showCsv(eventTitle ?? l10n.resEventFallback, results),
              icon: const Icon(Icons.table_chart_outlined, size: 18),
              label: Text(l10n.resExport),
            ),
          ]),
        ],
      ],
    );
  }
}

class _OutcomeBanner extends StatelessWidget {
  const _OutcomeBanner({required this.outcome});
  final Outcome outcome;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final percent = outcome.percent.toStringAsFixed(1);
    final title = outcome.isTie ? l10n.resTie : l10n.resWins(outcome.leaders.first.name);
    final body = outcome.isTie
        ? l10n.resTieBody(outcome.leaders.map((r) => r.name).join(' / '), outcome.votes, percent)
        : l10n.resWinsBody(outcome.votes, percent);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.accentText, width: 2),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(outcome.isTie ? Icons.balance_rounded : Icons.emoji_events_rounded, color: kc.accentText),
        const SizedBox(width: 12),
        Expanded(
          child: Semantics(
            liveRegion: true,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kc.textPrimary)),
              const SizedBox(height: 2),
              Text(body, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.progress});
  final String label;
  final String value;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Semantics(
      container: true,
      label: '$label: $value',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kc.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: kc.border),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kc.textPrimary)),
            if (progress != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress!.clamp(0, 1),
                  minHeight: 6,
                  backgroundColor: kc.border,
                  valueColor: AlwaysStoppedAnimation<Color>(kc.accentText),
                ),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

class _SplitBar extends StatelessWidget {
  const _SplitBar({required this.rows, required this.colors});
  final List<ResultRow> rows;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    // Decorative summary: every choice also has its own labelled row below.
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 16,
          child: Row(children: [
            for (var i = 0; i < rows.length; i++)
              Expanded(
                flex: rows[i].percent.round().clamp(1, 1000),
                child: Container(color: colors[i % colors.length]),
              ),
          ]),
        ),
      ),
    );
  }
}

class _ResultRowCard extends StatelessWidget {
  const _ResultRowCard({required this.row, required this.color});
  final ResultRow row;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Semantics(
      container: true,
      label: '${row.name}: ${l10n.resVotes(row.votes)}, ${row.percent.toStringAsFixed(1)}%',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kc.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: kc.border),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(row.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: kc.textPrimary)),
              ),
            ]),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 18),
              child: Text.rich(TextSpan(
                text: '${l10n.resVotes(row.votes)} · ',
                style: TextStyle(fontSize: 14, color: kc.textSecondary),
                children: [
                  TextSpan(
                    text: '${row.percent.toStringAsFixed(1)}%',
                    style: TextStyle(fontWeight: FontWeight.bold, color: kc.textPrimary),
                  ),
                ],
              )),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: row.percent / 100,
                minHeight: 8,
                backgroundColor: kc.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
