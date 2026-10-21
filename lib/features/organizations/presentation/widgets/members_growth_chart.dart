import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../domain/member_growth_point.dart';
import '../providers/organization_providers.dart';

/// "Members Growth" line chart for the Home / Organization Dashboard screens.
/// Backed by real daily snapshots (see snapshotMemberGrowth Cloud Function) -
/// a brand-new organization will show a short or empty line until the
/// scheduler has had a few days to accumulate history, rather than fake data.
class MembersGrowthChart extends ConsumerWidget {
  const MembersGrowthChart({super.key, required this.organizationId});

  final String organizationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(memberGrowthProvider(organizationId));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: KivoraColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text('Members Growth',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: KivoraColors.textPrimaryOf(context))),
              Text('Last 30 days',
                  style: TextStyle(
                      fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: pointsAsync.when(
              loading: () => const Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))),
              error: (e, _) => Center(
                  child: Text('Could not load growth data',
                      style: TextStyle(
                          fontSize: 14,
                          color: KivoraColors.textSecondaryOf(context)))),
              data: (points) => _buildChart(context, points),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<MemberGrowthPoint> points) {
    if (points.length < 2) {
      return Center(
        child: Text(
          'Not enough data yet - check back after a few days.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14, color: KivoraColors.textSecondaryOf(context)),
        ),
      );
    }

    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].memberCount.toDouble()),
    ];
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    final format = DateFormat('MMM d');

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY <= 0 ? 10 : maxY * 1.2,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY <= 0 ? 10 : maxY * 1.2) / 4,
          getDrawingHorizontalLine: (_) => FlLine(
            color: KivoraColors.borderOf(context),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: (maxY <= 0 ? 10 : maxY * 1.2) / 4,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(
                    fontSize: 10, color: KivoraColors.textSecondaryOf(context)),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (points.length / 4).clamp(1, points.length).toDouble(),
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= points.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    format.format(points[i].date),
                    style: TextStyle(
                        fontSize: 10, color: KivoraColors.textSecondaryOf(context)),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => AppTheme.primaryBlue,
            getTooltipItems: (spots) => spots.map((s) {
              final i = s.x.toInt();
              final date = i >= 0 && i < points.length
                  ? format.format(points[i].date)
                  : '';
              return LineTooltipItem(
                '$date\n${s.y.toInt()} members',
                const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: const LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.accentCyan],
            ),
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryBlue.withValues(alpha: 0.18),
                  AppTheme.primaryBlue.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
