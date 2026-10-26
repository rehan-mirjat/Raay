import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/reauth_dialog.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/firebase_service.dart';
import '../../voting/presentation/cast_vote_screen.dart';
import '../data/voting_event_repository.dart';
import '../domain/voting_event.dart';
import 'voter_election_card.dart' show formatDeadline;
import 'voter_portal_screen.dart' show AdaptiveCardGrid;

typedef MonitoringLoader = Future<Map<String, dynamic>> Function(String eventId);

Future<Map<String, dynamic>> _defaultLoader(String eventId) async {
  final response =
      await FirebaseService().functions.httpsCallable('getEventMonitoring').call({'eventId': eventId});
  return Map<String, dynamic>.from(response.data as Map);
}

/// Live, counts-only turnout for admins. No identities or selections are ever
/// shown; small departments are combined server-side.
class EventMonitoringScreen extends ConsumerStatefulWidget {
  const EventMonitoringScreen({
    super.key,
    required this.eventId,
    this.loader,
    this.pollInterval = const Duration(seconds: 15),
  });

  final String eventId;

  /// Replaces the `getEventMonitoring` callable (tests inject this).
  final MonitoringLoader? loader;
  final Duration pollInterval;

  @override
  ConsumerState<EventMonitoringScreen> createState() => _EventMonitoringScreenState();
}

class _EventMonitoringScreenState extends ConsumerState<EventMonitoringScreen> {
  Map<String, dynamic>? _summary;
  bool _failed = false;
  bool _loading = true;
  bool _isClosing = false;
  bool _isReminding = false;
  DateTime? _refreshedAt;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(widget.pollInterval, (_) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final data = await (widget.loader ?? _defaultLoader)(widget.eventId);
      if (!mounted) return;
      setState(() {
        _summary = data;
        _failed = false;
        _loading = false;
        _refreshedAt = DateTime.now();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  Future<void> _closeVotingNow() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.monCloseDialogTitle),
        content: Text(l10n.monCloseDialogBody),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.monCancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48), foregroundColor: KivoraColors.of(ctx).errorText),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.monCloseConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isClosing = true);
    try {
      await ref.read(votingEventRepositoryProvider).closeVotingEvent(widget.eventId);
      messenger.showSnackBar(SnackBar(content: Text(l10n.monClosed)));
      if (mounted) router.pop();
    } on RequiresRecentAuthException {
      if (!mounted) return;
      final verified = await showReauthDialog(context, ref, reason: l10n.monReauth);
      if (!mounted) return;
      if (verified) {
        _closeVotingNow();
      } else {
        setState(() => _isClosing = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isClosing = false);
      messenger.showSnackBar(SnackBar(content: Text(l10n.monCloseFailed)));
    }
  }

  Future<void> _remindNonVoters() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isReminding = true);
    try {
      final response =
          await FirebaseService().functions.httpsCallable('remindNonVoters').call({'eventId': widget.eventId});
      final count = (response.data as Map)['remindedCount'] as int? ?? 0;
      messenger.showSnackBar(
          SnackBar(content: Text(count == 0 ? l10n.monRemindNone : l10n.monRemindDone(count))));
    } on FirebaseFunctionsException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message ?? l10n.monRemindFailed)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.monRemindFailed)));
    } finally {
      if (mounted) setState(() => _isReminding = false);
    }
  }

  String _remaining(AppLocalizations l10n, DateTime endAt) {
    final diff = endAt.difference(DateTime.now());
    if (diff.isNegative) return l10n.monRemainMin(0);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    if (days > 0) return l10n.monRemainDaysHours(days, hours);
    if (diff.inHours > 0) return l10n.monRemainHoursMin(diff.inHours, diff.inMinutes % 60);
    return l10n.monRemainMin(diff.inMinutes);
  }

  BoxDecoration _card(KivoraColors kc) => BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    // Stable provider: the stream is not recreated every 15s refresh.
    final event = ref.watch(singleVotingEventProvider(widget.eventId)).valueOrNull;
    final isDesktop = ResponsiveLayout.isWide(context);

    Widget body;
    if (_loading && _summary == null) {
      body = const LoadingView();
    } else if (_summary == null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.cloud_off_outlined, size: 44, color: kc.textSecondary),
            const SizedBox(height: 12),
            Text(l10n.monLoadError, textAlign: TextAlign.center, style: TextStyle(color: kc.textPrimary)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.monRetry),
            ),
          ]),
        ),
      );
    } else {
      body = SingleChildScrollView(
        padding: ResponsiveLayout.pagePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(context, l10n, kc, event),
                const SizedBox(height: 20),
                _note(kc, Icons.lock_outline_rounded, l10n.monPrivacy),
                if (_failed) ...[
                  const SizedBox(height: 12),
                  _note(kc, Icons.sync_problem_rounded, l10n.monRefreshIssue, color: kc.warningText),
                ],
                const SizedBox(height: 20),
                _stats(context, l10n, kc),
                const SizedBox(height: 20),
                _mainGrid(context, l10n, kc, event, isDesktop),
                if (event?.status == VotingEventStatus.active) ...[
                  const SizedBox(height: 20),
                  _closeEarly(context, l10n, kc),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(backgroundColor: kc.background, body: SafeArea(child: body));
  }

  Widget _note(KivoraColors kc, IconData icon, String text, {Color? color}) {
    final c = color ?? kc.accentText;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.withValues(alpha: kc.isDark ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        border: Border.all(color: c.withValues(alpha: 0.5)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 20, color: c),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: kc.textPrimary))),
      ]),
    );
  }

  Widget _header(BuildContext context, AppLocalizations l10n, KivoraColors kc, VotingEvent? event) {
    final secondsAgo = _refreshedAt == null ? 0 : DateTime.now().difference(_refreshedAt!).inSeconds;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      TextButton.icon(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
        onPressed: () => context.canPop() ? context.pop() : context.go('/admin/events'),
        icon: const Icon(Icons.arrow_back_rounded, size: 18),
        label: Text(event?.title ?? l10n.monBack, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
      const SizedBox(height: 4),
      Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 12, runSpacing: 8, children: [
        Semantics(
          header: true,
          child: Text(l10n.monTitle, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: kc.textPrimary)),
        ),
        if (event != null) StatusBadge.eventStatus(event.status.name),
      ]),
      if (event != null) ...[
        const SizedBox(height: 4),
        Text(
          '${event.title} · ${l10n.monClosesIn(_remaining(l10n, event.endAt))}',
          style: TextStyle(color: kc.textSecondary, fontSize: 14),
        ),
      ],
      const SizedBox(height: 12),
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 32 - 60),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(_failed ? Icons.sync_problem_rounded : Icons.circle, size: 10, color: _failed ? kc.warningText : kc.successText),
            const SizedBox(width: 6),
            Flexible(
              child: Text(_refreshedAt == null ? l10n.monLive : l10n.monUpdated(secondsAgo),
                  style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            ),
          ])),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: _loading ? null : _refresh,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(l10n.monRefresh),
          ),
        ],
      ),
    ]);
  }

  Widget _stats(BuildContext context, AppLocalizations l10n, KivoraColors kc) {
    final eligible = (_summary?['eligibleCount'] as num?)?.toInt() ?? 0;
    final voted = (_summary?['participationCount'] as num?)?.toInt() ?? 0;
    final notYet = (eligible - voted).clamp(0, eligible);
    final turnout = ((_summary?['turnoutPercent'] as num?)?.toDouble() ?? 0).clamp(0, 100).toDouble();

    final turnoutCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(kc),
      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 16, runSpacing: 8, children: [
        Text('${turnout.toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: kc.accentText)),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 160, maxWidth: 360),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(l10n.monTurnoutLabel, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: eligible == 0 ? 0 : (voted / eligible).clamp(0, 1).toDouble(),
                minHeight: 8,
                backgroundColor: kc.border,
                valueColor: AlwaysStoppedAnimation<Color>(kc.accentText),
              ),
            ),
            const SizedBox(height: 4),
            Text(l10n.monOfEligible(voted, eligible), style: TextStyle(fontSize: 14, color: kc.textSecondary)),
          ]),
        ),
      ]),
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      turnoutCard,
      const SizedBox(height: 12),
      AdaptiveCardGrid(minColumnWidth: 200, children: [
        _mini(kc, l10n.monEligible, '$eligible', Icons.groups_outlined, l10n.monEligibleCap),
        _mini(kc, l10n.monVoted, '$voted', Icons.check_circle_outline_rounded, l10n.monVotedCap),
        _mini(kc, l10n.monNotYet, '$notYet', Icons.schedule_rounded, l10n.monNotYetCap),
      ]),
    ]);
  }

  Widget _mini(KivoraColors kc, String label, String value, IconData icon, String caption) {
    return Semantics(
      container: true,
      label: '$label: $value. $caption',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: _card(kc),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              Icon(icon, size: 18, color: kc.textSecondary),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: kc.textSecondary))),
            ]),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kc.textPrimary)),
            const SizedBox(height: 2),
            Text(caption, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
          ]),
        ),
      ),
    );
  }

  Widget _mainGrid(BuildContext context, AppLocalizations l10n, KivoraColors kc, VotingEvent? event, bool isDesktop) {
    final left = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _chart(l10n, kc),
      const SizedBox(height: 16),
      _departments(l10n, kc),
    ]);
    final right = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (event != null) ...[_details(context, l10n, kc, event), const SizedBox(height: 16)],
      _boost(l10n, kc),
    ]);
    if (isDesktop) {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 2, child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ]);
    }
    return Column(children: [left, const SizedBox(height: 16), right]);
  }

  Widget _chart(AppLocalizations l10n, KivoraColors kc) {
    final history = (_summary?['participationHistory'] as List?) ?? const [];
    if (history.length < 2) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: _card(kc),
        child: Text(l10n.monChartNone, style: TextStyle(color: kc.textSecondary, fontSize: 14)),
      );
    }
    final spots = <FlSpot>[];
    double maxY = 1;
    for (var i = 0; i < history.length; i++) {
      final raw = history[i];
      final count = (raw is Map ? (raw['cumulativeCount'] as num?)?.toDouble() : null) ?? 0;
      spots.add(FlSpot(i.toDouble(), count));
      if (count > maxY) maxY = count;
    }
    final total = spots.last.y.toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(kc),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(alignment: WrapAlignment.spaceBetween, spacing: 8, runSpacing: 8, children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Semantics(
                header: true,
                child: Text(l10n.monChartTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kc.textPrimary)),
              ),
              const SizedBox(height: 2),
              Text(l10n.monChartSub, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            ]),
          ),
          StatusBadge(
            label: l10n.monChartTotal(total),
            backgroundColor: kc.accentText.withValues(alpha: kc.isDark ? 0.16 : 0.10),
            textColor: kc.accentText,
          ),
        ]),
        const SizedBox(height: 16),
        // Decorative trend; the total above and the stats cards carry the data.
        ExcludeSemantics(
          child: SizedBox(
            height: 180,
            child: LineChart(LineChartData(
              minY: 0,
              maxY: maxY * 1.15,
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: kc.accentText,
                  barWidth: 2.5,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: kc.accentText.withValues(alpha: 0.10)),
                ),
              ],
            )),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l10n.monChartStart, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
          Text(l10n.monChartNow, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
        ]),
      ]),
    );
  }

  Widget _departments(AppLocalizations l10n, KivoraColors kc) {
    final rows = (_summary?['departmentBreakdown'] as List?) ?? const [];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(kc),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Semantics(
          header: true,
          child: Text(l10n.monDeptTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kc.textPrimary)),
        ),
        const SizedBox(height: 16),
        if (rows.isEmpty)
          Text(l10n.monDeptNone, style: TextStyle(fontSize: 14, color: kc.textSecondary))
        else ...[
          for (final raw in rows.whereType<Map>()) _deptRow(l10n, kc, Map<String, dynamic>.from(raw)),
          const SizedBox(height: 4),
          Text(l10n.monDeptNote, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
        ],
      ]),
    );
  }

  Widget _deptRow(AppLocalizations l10n, KivoraColors kc, Map<String, dynamic> row) {
    final name = (row['name'] as String?) ?? l10n.monDeptFallback;
    final eligible = (row['eligible'] as num?)?.toInt() ?? 0;
    final participated = (row['participated'] as num?)?.toInt() ?? 0;
    final percent = (row['turnoutPercent'] as num?)?.toDouble() ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kc.textPrimary)),
        Text(l10n.monDeptRow(participated, eligible, percent.toStringAsFixed(0)),
            style: TextStyle(fontSize: 14, color: kc.textSecondary)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: eligible == 0 ? 0 : (participated / eligible).clamp(0, 1).toDouble(),
            minHeight: 8,
            backgroundColor: kc.border,
            valueColor: AlwaysStoppedAnimation<Color>(kc.accentText),
          ),
        ),
      ]),
    );
  }

  Widget _details(BuildContext context, AppLocalizations l10n, KivoraColors kc, VotingEvent event) {
    Widget row(String label, String value) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: kc.textPrimary)),
          ]),
        );
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(kc),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Semantics(
          header: true,
          child: Text(l10n.monDetails, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kc.textPrimary)),
        ),
        const SizedBox(height: 16),
        row(l10n.monWindow, '${formatDeadline(context, event.startAt)} – ${formatDeadline(context, event.endAt)}'),
        row(l10n.monBallotType,
            event.privacyMode == PrivacyMode.identifiable ? l10n.monIdentifiable : l10n.monAnonymous),
        row(l10n.monEligibility, event.eligibilityType.localized(l10n)),
        row(l10n.monVotingType, event.votingType.localized(l10n)),
      ]),
    );
  }

  Widget _boost(AppLocalizations l10n, KivoraColors kc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _card(kc),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Semantics(
          header: true,
          child: Text(l10n.monBoostTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kc.textPrimary)),
        ),
        const SizedBox(height: 10),
        Text(l10n.monBoostBody, style: TextStyle(fontSize: 14, color: kc.textSecondary, height: 1.4)),
        const SizedBox(height: 14),
        FilledButton.icon(
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          onPressed: _isReminding ? null : _remindNonVoters,
          icon: _isReminding
              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.campaign_outlined, size: 18),
          label: Text(_isReminding ? l10n.monSending : l10n.monRemind),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Icon(Icons.shield_outlined, size: 16, color: kc.textSecondary),
          const SizedBox(width: 6),
          Expanded(child: Text(l10n.monPrivateNote, style: TextStyle(fontSize: 14, color: kc.textSecondary))),
        ]),
      ]),
    );
  }

  Widget _closeEarly(BuildContext context, AppLocalizations l10n, KivoraColors kc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.errorText.withValues(alpha: kc.isDark ? 0.14 : 0.06),
        borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        border: Border.all(color: kc.errorText.withValues(alpha: 0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.warning_amber_rounded, size: 22, color: kc.errorText),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Semantics(
                header: true,
                child: Text(l10n.monCloseTitle, style: TextStyle(fontWeight: FontWeight.bold, color: kc.textPrimary)),
              ),
              const SizedBox(height: 2),
              Text(l10n.monCloseNote, style: TextStyle(fontSize: 14, color: kc.textSecondary, height: 1.4)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(48, 48),
              foregroundColor: kc.errorText,
              side: BorderSide(color: kc.errorText),
            ),
            onPressed: _isClosing ? null : _closeVotingNow,
            child: _isClosing
                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.monCloseButton),
          ),
        ),
      ]),
    );
  }
}
