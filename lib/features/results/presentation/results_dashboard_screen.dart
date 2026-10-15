import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/results_repository.dart';
import '../domain/event_result.dart';

class ResultsDashboardScreen extends ConsumerWidget {
  final String eventId;

  const ResultsDashboardScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsync = ref.watch(eventResultStreamProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Election Results Dashboard'),
      ),
      body: resultAsync.when(
        data: (result) {
          if (result == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Results not published or calculated yet.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await ref
                            .read(resultsRepositoryProvider)
                            .calculateResults(eventId);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Results calculated successfully!')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Calculate Tallies'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryHeader(context, result),
                const SizedBox(height: 24),
                if (result.candidateTallies.isNotEmpty) ...[
                  Text(
                    'Candidate Standings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildCandidateChart(context, result.candidateTallies),
                  const SizedBox(height: 16),
                  ...result.candidateTallies.map((c) => _buildTallyCard(
                        context,
                        title: c.candidateName,
                        votes: c.voteCount,
                        total: result.totalBallotsCast,
                        icon: Icons.person,
                      )),
                  const SizedBox(height: 24),
                ],
                if (result.optionTallies.isNotEmpty) ...[
                  Text(
                    'Poll Option Breakdown',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ...result.optionTallies.map((o) => _buildTallyCard(
                        context,
                        title: o.title,
                        votes: o.voteCount,
                        total: result.totalBallotsCast,
                        icon: Icons.how_to_vote,
                      )),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: SelectableText('Error loading results: $err'),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context, EventResult result) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Ballots Cast',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${result.totalBallotsCast}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    result.published ? 'PUBLISHED' : 'PREVIEW',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  backgroundColor: result.published ? Colors.green : Colors.orange,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Calculated: ${dateFormat.format(result.calculatedAt)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidateChart(
      BuildContext context, List<CandidateTally> tallies) {
    if (tallies.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < tallies.length) {
                    final name = tallies[index].candidateName;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        name.length > 8 ? '${name.substring(0, 6)}...' : name,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: tallies.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: item.voteCount.toDouble(),
                  color: Theme.of(context).primaryColor,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTallyCard(
    BuildContext context, {
    required String title,
    required int votes,
    required int total,
    required IconData icon,
  }) {
    final percentage = total > 0 ? (votes / total) : 0.0;
    final percentStr = (percentage * 100).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  '$votes votes ($percentStr%)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              color: Theme.of(context).primaryColor,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
