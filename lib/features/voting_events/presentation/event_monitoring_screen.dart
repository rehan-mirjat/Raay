import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/reauth_dialog.dart';
import '../../../services/firebase_service.dart';
import '../data/voting_event_repository.dart';
import '../domain/voting_event.dart';

class EventMonitoringScreen extends ConsumerStatefulWidget {
  const EventMonitoringScreen({super.key, required this.eventId});
  final String eventId;

  @override
  ConsumerState<EventMonitoringScreen> createState() =>
      _EventMonitoringScreenState();
}

class _EventMonitoringScreenState extends ConsumerState<EventMonitoringScreen> {
  static final _dateFormat = DateFormat('d MMM, HH:mm');
  Map<String, dynamic>? _summary;
  Object? _error;
  bool _loading = true;
  bool _isClosing = false;
  bool _isReminding = false;
  DateTime? _refreshedAt;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _refresh();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _refresh());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final response = await FirebaseService()
          .functions
          .httpsCallable('getEventMonitoring')
          .call({'eventId': widget.eventId});
      if (!mounted) return;
      setState(() {
        _summary = Map<String, dynamic>.from(response.data as Map);
        _error = null;
        _loading = false;
        _refreshedAt = DateTime.now();
      });
    } on FirebaseFunctionsException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message ?? 'Could not load turnout.';
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  Future<void> _closeVotingNow() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close voting now?'),
        content: const Text(
            'Closing is final. Members will no longer be able to vote, and this cannot be undone. Results stay hidden until you calculate and publish them.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Close voting'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isClosing = true);
    try {
      await ref
          .read(votingEventRepositoryProvider)
          .closeVotingEvent(widget.eventId);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Voting closed.')));
        context.pop();
      }
    } on RequiresRecentAuthException {
      if (!mounted) return;
      final verified = await showReauthDialog(context, ref,
          reason: 'For security, closing an election requires you to have '
              'signed in within the last 15 minutes. Please verify your '
              'identity to continue.');
      if (!mounted) return;
      if (verified) {
        _closeVotingNow();
      } else {
        setState(() => _isClosing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isClosing = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppTheme.error,
        ));
      }
    }
  }

  Future<void> _remindNonVoters() async {
    setState(() => _isReminding = true);
    try {
      final response = await FirebaseService()
          .functions
          .httpsCallable('remindNonVoters')
          .call({'eventId': widget.eventId});
      final count = (response.data as Map)['remindedCount'] as int? ?? 0;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(count == 0
              ? 'Everyone eligible has already voted.'
              : 'Reminder sent to $count non-voter${count == 1 ? '' : 's'}.'),
          backgroundColor: AppTheme.success,
        ));
      }
    } on FirebaseFunctionsException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? 'Could not send reminders.'),
          backgroundColor: AppTheme.error,
        ));
      }
    } finally {
      if (mounted) setState(() => _isReminding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VotingEvent?>(
      stream: ref
          .watch(votingEventRepositoryProvider)
          .watchVotingEvent(widget.eventId),
      builder: (context, eventSnapshot) {
        final event = eventSnapshot.data;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: _loading && _summary == null
                ? const LoadingView(message: 'Loading live turnout…')
                : _error != null && _summary == null
                    ? _buildErrorState()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildHeader(event),
                                const SizedBox(height: 20),
                                _buildPrivacyBanner(),
                                const SizedBox(height: 20),
                                _buildStatsRow(),
                                const SizedBox(height: 20),
                                _buildMainGrid(event),
                                if (event?.status ==
                                    VotingEventStatus.active) ...[
                                  const SizedBox(height: 20),
                                  _buildCloseEarlyBanner(),
                                ],
                                if (_error != null) ...[
                                  const SizedBox(height: 12),
                                  Text('Refresh issue: $_error',
                                      style: const TextStyle(
                                          color: AppTheme.error, fontSize: 12)),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.lock_outline_rounded,
              size: 44, color: KivoraColors.textSecondaryOf(context)),
          const SizedBox(height: 12),
          Text('Turnout could not be loaded: $_error',
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again')),
        ]),
      ),
    );
  }

  Widget _buildHeader(VotingEvent? event) {
    final closesIn = event != null ? _formatRemaining(event.endAt) : null;
    final secondsAgo = _refreshedAt == null
        ? 0
        : DateTime.now().difference(_refreshedAt!).inSeconds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_rounded,
                    size: 16, color: KivoraColors.textSecondaryOf(context)),
                const SizedBox(width: 6),
                Text(event?.title ?? 'Back',
                    style: TextStyle(
                        color: KivoraColors.textSecondaryOf(context), fontSize: 13)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            Text('Live turnout',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: KivoraColors.textPrimaryOf(context))),
            if (event != null) _statusChip(event.status),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          [
            if (event != null) event.title,
            if (closesIn != null) 'Closes in $closesIn',
          ].join(' · '),
          style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 13),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppTheme.success, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  _refreshedAt == null
                      ? 'Live'
                      : 'Live · Updated ${secondsAgo}s ago',
                  style: TextStyle(
                      fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                ),
              ],
            ),
            OutlinedButton.icon(
              onPressed: _loading ? null : _refresh,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusChip(VotingEventStatus status) {
    final (label, color) = switch (status) {
      VotingEventStatus.active => ('Active', AppTheme.success),
      VotingEventStatus.scheduled => ('Scheduled', AppTheme.primaryBlue),
      _ => (status.name, KivoraColors.textSecondaryOf(context)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPrivacyBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 18, color: AppTheme.primaryBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Counts only. No voter identities or ballot selections are visible. Results stay hidden until this event is closed and published.',
              style: TextStyle(fontSize: 13, color: KivoraColors.textPrimaryOf(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final eligible = (_summary?['eligibleCount'] as num?)?.toInt() ?? 0;
    final voted = (_summary?['participationCount'] as num?)?.toInt() ?? 0;
    final notYet = (eligible - voted).clamp(0, eligible);
    final turnout =
        ((_summary?['turnoutPercent'] as num?)?.toDouble() ?? 0).clamp(0, 100);
    final isWide = ResponsiveLayout.isWide(context);

    final turnoutCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Text('${turnout.toStringAsFixed(0)}%',
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Eligible members who participated',
                    style:
                        TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: eligible == 0
                      ? 0
                      : (voted / eligible).clamp(0, 1).toDouble(),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(999),
                ),
                const SizedBox(height: 4),
                Text('$voted of $eligible',
                    style: TextStyle(
                        fontSize: 11, color: KivoraColors.textSecondaryOf(context))),
              ],
            ),
          ),
        ],
      ),
    );

    final miniStats = Row(
      children: [
        Expanded(
            child: _miniStat('Eligible', '$eligible', Icons.groups_outlined,
                'All active members')),
        const SizedBox(width: 12),
        Expanded(
            child: _miniStat('Voted', '$voted',
                Icons.check_circle_outline_rounded, 'Ballots submitted')),
        const SizedBox(width: 12),
        Expanded(
            child: _miniStat('Not yet', '$notYet', Icons.schedule_rounded,
                'Members remaining')),
      ],
    );

    if (isWide) {
      // IntrinsicHeight gives the Row a bounded height to stretch to - this
      // sits inside a SingleChildScrollView, where the incoming height
      // constraint is unbounded, and CrossAxisAlignment.stretch on a Row
      // with an unbounded height constraint throws (can't stretch to
      // infinity).
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 2, child: turnoutCard),
            const SizedBox(width: 16),
            Expanded(flex: 3, child: miniStats),
          ],
        ),
      );
    }
    return Column(
        children: [turnoutCard, const SizedBox(height: 12), miniStats]);
  }

  Widget _miniStat(String label, String value, IconData icon, String caption) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: KivoraColors.textSecondaryOf(context)),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: KivoraColors.textPrimaryOf(context))),
          const SizedBox(height: 2),
          Text(caption,
              style:
                  TextStyle(fontSize: 10, color: KivoraColors.textSecondaryOf(context))),
        ],
      ),
    );
  }

  Widget _buildMainGrid(VotingEvent? event) {
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildParticipationChart(),
        const SizedBox(height: 16),
        _buildDepartmentBreakdown(),
      ],
    );
    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (event != null) _buildEventDetailsCard(event),
        const SizedBox(height: 16),
        _buildBoostTurnoutCard(),
      ],
    );

    if (ResponsiveLayout.isWide(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: left),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: right),
        ],
      );
    }
    return Column(children: [left, const SizedBox(height: 16), right]);
  }

  Widget _buildParticipationChart() {
    final history = (_summary?['participationHistory'] as List?) ?? const [];
    if (history.length < 2) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(),
        child: Text(
            'Not enough data yet to chart participation over time.',
            style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 13)),
      );
    }
    final spots = <FlSpot>[];
    double maxY = 1;
    for (var i = 0; i < history.length; i++) {
      final count =
          ((history[i] as Map)['cumulativeCount'] as num?)?.toDouble() ?? 0;
      spots.add(FlSpot(i.toDouble(), count));
      if (count > maxY) maxY = count;
    }
    final total = spots.last.y.toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Participation over time',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context))),
                  const SizedBox(height: 2),
                  Text('Cumulative participation since the event opened',
                      style: TextStyle(
                          fontSize: 11, color: KivoraColors.textSecondaryOf(context))),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('$total voted',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY * 1.15,
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.primaryBlue,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Event opened',
                  style:
                      TextStyle(fontSize: 10, color: KivoraColors.textSecondaryOf(context))),
              Text('Now',
                  style:
                      TextStyle(fontSize: 10, color: KivoraColors.textSecondaryOf(context))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentBreakdown() {
    final rows = (_summary?['departmentBreakdown'] as List?) ?? const [];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Turnout by department',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context))),
          const SizedBox(height: 16),
          if (rows.isEmpty)
            Text('No department data available for this event.',
                style: TextStyle(fontSize: 13, color: KivoraColors.textSecondaryOf(context)))
          else ...[
            for (final raw in rows)
              _departmentRow(Map<String, dynamic>.from(raw as Map)),
            const SizedBox(height: 4),
            Text(
                'Groups with fewer than 5 eligible members are combined.',
                style: TextStyle(fontSize: 10, color: KivoraColors.textSecondaryOf(context))),
          ],
        ],
      ),
    );
  }

  Widget _departmentRow(Map<String, dynamic> row) {
    final name = row['name'] as String? ?? 'Department';
    final eligible = (row['eligible'] as num?)?.toInt() ?? 0;
    final participated = (row['participated'] as num?)?.toInt() ?? 0;
    final percent = (row['turnoutPercent'] as num?)?.toDouble() ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis)),
              Text(
                  '$participated of $eligible · ${percent.toStringAsFixed(0)}%',
                  style: TextStyle(
                      fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: eligible == 0
                ? 0
                : (participated / eligible).clamp(0, 1).toDouble(),
            minHeight: 6,
            borderRadius: BorderRadius.circular(999),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetailsCard(VotingEvent event) {
    final dateFormat = _dateFormat;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.info_outline_rounded,
                size: 16, color: KivoraColors.textPrimaryOf(context)),
            const SizedBox(width: 8),
            Text('Event details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: KivoraColors.textPrimaryOf(context))),
          ]),
          const SizedBox(height: 16),
          _detailRow('Voting window',
              '${dateFormat.format(event.startAt)} – ${dateFormat.format(event.endAt)}'),
          _detailRow(
              'Ballot type',
              event.privacyMode == PrivacyMode.identifiable
                  ? 'Identifiable'
                  : 'Anonymous'),
          _detailRow('Eligible', event.eligibilityType.label),
          _detailRow('Type', event.votingType.label),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context))),
          const SizedBox(height: 2),
          Text(value,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildBoostTurnoutCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.notifications_outlined,
                size: 16, color: KivoraColors.textPrimaryOf(context)),
            const SizedBox(width: 8),
            Text('Boost turnout',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: KivoraColors.textPrimaryOf(context))),
          ]),
          const SizedBox(height: 10),
          Text(
            "Remind members who haven't voted. Reminders go to non-voters automatically; you won't see who has or hasn't.",
            style: TextStyle(
                fontSize: 12, color: KivoraColors.textSecondaryOf(context), height: 1.4),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isReminding ? null : _remindNonVoters,
              icon: _isReminding
                  ? const SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.campaign_outlined, size: 16),
              label: Text(_isReminding ? 'Sending…' : 'Remind non-voters'),
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.shield_outlined,
                size: 12, color: KivoraColors.textSecondaryOf(context)),
            const SizedBox(width: 4),
            Text('Participation stays private',
                style: TextStyle(fontSize: 10, color: KivoraColors.textSecondaryOf(context))),
          ]),
        ],
      ),
    );
  }

  Widget _buildCloseEarlyBanner() {
    final isWide = ResponsiveLayout.isWide(context);
    final warning = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.warning_amber_rounded, size: 20, color: AppTheme.error),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Close voting early',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context))),
              const SizedBox(height: 2),
              Text(
                "Closing is final. You'll need to sign in again if your last sign-in was over 15 minutes ago. Results remain hidden until the event is closed and published.",
                style: TextStyle(
                    fontSize: 12, color: KivoraColors.textSecondaryOf(context), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
      onPressed: _isClosing ? null : _closeVotingNow,
      child: _isClosing
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2))
          : const Text('Close voting now'),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.25)),
      ),
      child: isWide
          ? Row(children: [
              Expanded(child: warning),
              const SizedBox(width: 16),
              button
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              warning,
              const SizedBox(height: 12),
              button,
            ]),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: KivoraColors.surfaceOf(context),
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      border: Border.all(color: KivoraColors.borderOf(context).withValues(alpha: 0.7)),
      boxShadow: [
        BoxShadow(
          color: KivoraColors.textPrimaryOf(context).withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  String _formatRemaining(DateTime endAt) {
    final diff = endAt.difference(DateTime.now());
    if (diff.isNegative) return '0 hours';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    if (days > 0) {
      return '$days day${days == 1 ? '' : 's'} $hours hour${hours == 1 ? '' : 's'}';
    }
    final minutes = diff.inMinutes % 60;
    if (hours > 0) return '$hours hour${hours == 1 ? '' : 's'} $minutes min';
    return '${diff.inMinutes} min';
  }
}
