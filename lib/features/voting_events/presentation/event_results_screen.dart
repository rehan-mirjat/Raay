import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/fade_through.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../services/firebase_service.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../../voting/presentation/cast_vote_screen.dart';
import '../domain/voting_event.dart';

/// A fixed, readable palette cycled across result rows so a choice's color
/// stays the same between the vote-split bar and its own row below it.
const _kResultColors = [
  AppTheme.accentTeal,
  AppTheme.primaryBlue,
  AppTheme.accentGold,
  AppTheme.warning,
  AppTheme.identifiable,
];

class EventResultsScreen extends ConsumerStatefulWidget {
  const EventResultsScreen({super.key, required this.eventId});
  final String eventId;

  @override
  ConsumerState<EventResultsScreen> createState() => _EventResultsScreenState();
}

class _EventResultsScreenState extends ConsumerState<EventResultsScreen> {
  bool _busy = false;

  Future<void> _run(String functionName) async {
    setState(() => _busy = true);
    try {
      await FirebaseService()
          .functions
          .httpsCallable(functionName)
          .call({'eventId': widget.eventId});
    } on FirebaseFunctionsException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Action failed.')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not update results.')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final membership = ref
        .watch(activeOrganizationContextProvider)
        .valueOrNull
        ?.context
        ?.member;
    final canManage = membership?.isAdmin ?? false;
    final eventAsync = ref.watch(singleVotingEventProvider(widget.eventId));
    final results = FirebaseService()
        .firestore
        .collection('eventResults')
        .doc(widget.eventId);

    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: results.snapshots(),
                builder: (context, snapshot) {
                  final eventTitle = eventAsync.valueOrNull?.title;

                  Widget withBackLink(String stateKey, Widget body) =>
                      FadeThrough(
                        stateKey: stateKey,
                        child: ListView(
                          children: [
                            _BackLink(
                              label: eventTitle ?? 'Event',
                              eventId: widget.eventId,
                            ),
                            SizedBox(height: 16),
                            body,
                          ],
                        ),
                      );

                  if (snapshot.hasError) {
                    final err = snapshot.error;
                    if (err is FirebaseException &&
                        err.code == 'permission-denied') {
                      if (!canManage) {
                        return withBackLink('not-available', const ErrorView(
                            type: ErrorViewType.generic,
                            title: 'Results are not available',
                            message:
                                'Results will appear here after they are published.'));
                      }
                    }
                    return withBackLink('error', const ErrorView(
                        type: ErrorViewType.generic,
                        title: 'Error loading results',
                        message: 'There was an error trying to load the results.'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return withBackLink('loading',
                        const LoadingView(message: 'Loading published results…'));
                  }

                  final data = snapshot.data?.data();
                  if (data == null) {
                    return withBackLink('empty', _empty(canManage,
                        'Results have not been calculated yet.'));
                  }

                  final isPublished = data['published'] == true;
                  final rawRows = (data['tallies'] as List<dynamic>?) ??
                      (data['choices'] as List<dynamic>?) ??
                      const [];
                  final rows = rawRows.whereType<Map>().map((row) {
                    final value = Map<String, dynamic>.from(row);
                    return <String, dynamic>{
                      'name': value['name'] ?? value['label'] ?? 'Choice',
                      'votes': value['votes'] ?? value['voteCount'] ?? 0,
                      'percent': value['percent'] ?? 0,
                    };
                  }).toList();
                  final total = (data['totalVotes'] as num?)?.toInt() ?? 0;
                  final eligible = ((data['eligibleCount'] ??
                              data['eligibleVoterCount']) as num?)
                          ?.toInt() ??
                      0;
                  final turnout =
                      (data['turnoutPercent'] as num?)?.toDouble() ?? 0;
                  final votingTypeLabel =
                      eventAsync.valueOrNull?.votingType.label;

                  return FadeThrough(
                    stateKey: 'data:${rows.length}:$isPublished',
                    child: ListView(
                    children: [
                      _BackLink(
                        label: eventTitle ?? 'Event',
                        eventId: widget.eventId,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Election results',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: KivoraColors.textPrimaryOf(context)),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: (isPublished
                                      ? AppTheme.success
                                      : AppTheme.warning)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isPublished ? 'Final' : 'Draft',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isPublished
                                    ? AppTheme.success
                                    : AppTheme.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        [
                          if (eventTitle != null) eventTitle,
                          if (votingTypeLabel != null) votingTypeLabel,
                          'calculated by the server after voting closed',
                        ].join(' · '),
                        style: TextStyle(
                            fontSize: 13, color: KivoraColors.textSecondaryOf(context)),
                      ),
                      SizedBox(height: 20),
                      if (rows.isNotEmpty) ...[
                        _OutcomeBanner(rows: rows, total: total),
                        SizedBox(height: 16),
                      ],
                      _StatsCard(
                          total: total, eligible: eligible, turnout: turnout),
                      SizedBox(height: 16),
                      if (!isPublished)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.warning.withValues(alpha: 0.08),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusCard),
                            border: Border.all(
                                color: AppTheme.warning.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'These results are visible to organization administrators only until published.',
                            style: TextStyle(
                                fontSize: 13, color: KivoraColors.textPrimaryOf(context)),
                          ),
                        ),
                      if (rows.length > 1) ...[
                        _VoteSplitBar(rows: rows),
                        SizedBox(height: 20),
                      ],
                      for (var i = 0; i < rows.length; i++) ...[
                        _ResultRow(
                          row: rows[i],
                          color: _kResultColors[i % _kResultColors.length],
                        ),
                        SizedBox(height: 10),
                      ],
                      if (rows.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: KivoraColors.surfaceOf(context),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusCard),
                            border: Border.all(color: KivoraColors.borderOf(context)),
                          ),
                          child: Text(
                              'No ballots were recorded for this event.'),
                        ),
                      SizedBox(height: 16),
                      Text(
                        'Results are shown to eligible members after an administrator publishes them. '
                        'Percentages are of ballots counted.',
                        style: TextStyle(
                            fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                      ),
                      if (canManage) ...[
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            OutlinedButton.icon(
                              onPressed:
                                  _busy ? null : () => _run('calculateResults'),
                              icon: Icon(Icons.refresh_rounded, size: 18),
                              label:
                                  Text(_busy ? 'Working…' : 'Recalculate results'),
                            ),
                            if (!isPublished)
                              FilledButton.icon(
                                onPressed:
                                    _busy ? null : () => _run('publishResults'),
                                icon: Icon(Icons.publish_rounded, size: 18),
                                label: Text('Publish results to members'),
                              ),
                          ],
                        ),
                      ],
                    ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _empty(bool canManage, String message) => EmptyView(
        icon: Icons.query_stats_rounded,
        title: 'No results yet',
        message: message,
        actionLabel:
            canManage ? (_busy ? 'Calculating…' : 'Calculate results') : null,
        onAction: canManage && !_busy ? () => _run('calculateResults') : null,
      );
}

class _BackLink extends StatelessWidget {
  const _BackLink({required this.label, required this.eventId});
  final String label;
  final String eventId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/elections/$eventId'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_rounded,
                size: 16, color: AppTheme.primaryBlue),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutcomeBanner extends StatelessWidget {
  const _OutcomeBanner({required this.rows, required this.total});
  final List<Map<String, dynamic>> rows;
  final int total;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) return const SizedBox.shrink();

    final maxVotes =
        rows.map((r) => (r['votes'] as num).toInt()).reduce((a, b) => a > b ? a : b);
    if (maxVotes <= 0) return const SizedBox.shrink();

    final leaders =
        rows.where((r) => (r['votes'] as num).toInt() == maxVotes).toList();
    final isTie = leaders.length > 1;

    final String title;
    final String subtitle;
    if (isTie) {
      final names = leaders.map((r) => r['name'] as String).join(' and ');
      final percent = (leaders.first['percent'] as num).toDouble();
      title = "It's a tie";
      subtitle =
          '$names each received $maxVotes vote${maxVotes == 1 ? '' : 's'} (${percent.toStringAsFixed(1)}%).';
    } else {
      final winner = leaders.first;
      final percent = (winner['percent'] as num).toDouble();
      title = '${winner['name']} wins';
      subtitle =
          '$maxVotes vote${maxVotes == 1 ? '' : 's'} (${percent.toStringAsFixed(1)}%).';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.accentGold.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isTie ? Icons.auto_awesome_rounded : Icons.emoji_events_rounded,
              size: 18,
              color: const Color(0xFFB45309),
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: KivoraColors.textPrimaryOf(context))),
                SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 13, color: KivoraColors.textSecondaryOf(context))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard(
      {required this.total, required this.eligible, required this.turnout});
  final int total;
  final int eligible;
  final double turnout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: KivoraColors.borderOf(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _stat(context, 'BALLOTS COUNTED', '$total')),
          Expanded(child: _stat(context, 'ELIGIBLE VOTERS', '$eligible')),
          Expanded(
            child: _stat(context, 'TURNOUT', '${turnout.toStringAsFixed(0)}%',
                progress: (turnout / 100).clamp(0, 1)),
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String value, {double? progress}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: KivoraColors.textSecondaryOf(context),
              letterSpacing: 0.8),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: KivoraColors.textPrimaryOf(context)),
        ),
        if (progress != null) ...[
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: KivoraColors.borderOf(context),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
            ),
          ),
        ],
      ],
    );
  }
}

class _VoteSplitBar extends StatelessWidget {
  const _VoteSplitBar({required this.rows});
  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'VOTE SPLIT',
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: KivoraColors.textSecondaryOf(context),
              letterSpacing: 0.8),
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 36,
            child: Row(
              children: [
                for (var i = 0; i < rows.length; i++)
                  Expanded(
                    flex: ((rows[i]['percent'] as num).round()).clamp(1, 1000),
                    child: Container(
                      color: _kResultColors[i % _kResultColors.length],
                      alignment: i == 0
                          ? Alignment.centerLeft
                          : (i == rows.length - 1
                              ? Alignment.centerRight
                              : Alignment.center),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: (rows[i]['percent'] as num) >= 12
                          ? Text(
                              '${rows[i]['name']} ${(rows[i]['percent'] as num).toStringAsFixed(0)}%',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.row, required this.color});
  final Map<String, dynamic> row;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final name = row['name'] as String? ?? 'Choice';
    final votes = (row['votes'] as num?)?.toInt() ?? 0;
    final percent = ((row['percent'] as num?)?.toDouble() ?? 0).clamp(0, 100);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: KivoraColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(name,
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              Text.rich(
                TextSpan(
                  text: '$votes vote${votes == 1 ? '' : 's'} · ',
                  style: TextStyle(
                      fontSize: 13, color: KivoraColors.textSecondaryOf(context)),
                  children: [
                    TextSpan(
                      text: '${percent.toStringAsFixed(1)}%',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 8,
              backgroundColor: KivoraColors.borderOf(context),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
