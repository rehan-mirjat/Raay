import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/platform_providers.dart';
import '../domain/platform_report.dart';
import 'platform_scaffold.dart';

/// Reports people filed from Help & support, read from `userReports`. The
/// backend gives platform admins read access only: a report cannot be assigned,
/// resolved or closed from here, and the screen says so instead of pretending.
class PlatformReportsScreen extends ConsumerStatefulWidget {
  const PlatformReportsScreen({super.key});

  @override
  ConsumerState<PlatformReportsScreen> createState() =>
      _PlatformReportsScreenState();
}

class _PlatformReportsScreenState extends ConsumerState<PlatformReportsScreen> {
  int _limit = kPlatformPageSize;
  String? _category;

  @override
  Widget build(BuildContext context) {
    return PlatformPage(
      title: 'User reports',
      subtitle: 'Feedback and issues submitted from Help & support.',
      actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () => ref.invalidate(platformReportsProvider(_limit)),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
        ),
      ],
      builder: (context) {
        final kc = KivoraColors.of(context);
        final reports = ref.watch(platformReportsProvider(_limit));
        return reports.when(
          loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: LoadingView(message: 'Loading reports…')),
          error: (e, _) => ErrorView(
            type: ErrorViewType.generic,
            message: 'The reports could not be loaded.',
            onRetry: () => ref.invalidate(platformReportsProvider(_limit)),
          ),
          data: (all) {
            if (all.isEmpty) {
              return const EmptyView(
                icon: Icons.flag_outlined,
                title: 'No reports',
                message: 'Nobody has submitted a report yet.',
              );
            }
            final categories = {for (final r in all) r.category}.toList()
              ..sort();
            if (_category != null && !categories.contains(_category)) {
              _category = null;
            }
            final shown = _category == null
                ? all
                : all.where((r) => r.category == _category).toList();
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                      'Read-only for now: the platform does not yet support assigning or resolving reports, so every report stays open. There is no flagged-organization feed either.',
                      style: TextStyle(fontSize: 13, color: kc.textSecondary)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    ChoiceChip(
                        label: Text('All (${all.length})'),
                        selected: _category == null,
                        onSelected: (_) => setState(() => _category = null)),
                    for (final c in categories)
                      ChoiceChip(
                          label: Text(
                              '$c (${all.where((r) => r.category == c).length})'),
                          selected: _category == c,
                          onSelected: (_) => setState(() => _category = c)),
                  ]),
                  const SizedBox(height: 16),
                  for (final r in shown) ...[
                    _ReportCard(report: r),
                    const SizedBox(height: 12)
                  ],
                  if (all.length >= _limit)
                    Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        onPressed: () =>
                            setState(() => _limit += kPlatformPageSize),
                        child: const Text('Load older reports'),
                      ),
                    ),
                ]);
          },
        );
      },
    );
  }
}

class _ReportCard extends StatefulWidget {
  const _ReportCard({required this.report});
  final PlatformReport report;

  @override
  State<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<_ReportCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final r = widget.report;
    final when = r.time == null
        ? ''
        : DateFormat('MMM d, yyyy · HH:mm').format(r.time!.toLocal());
    final long = r.message.length > 160 || r.message.contains('\n');
    return PlatformPanel(
      title: r.subject.isEmpty ? '(No subject)' : r.subject,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: kc.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(r.status.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: kc.textSecondary)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            [
              r.category,
              if (r.userEmail.isNotEmpty) r.userEmail,
              if (when.isNotEmpty) when
            ].join(' · '),
            style: TextStyle(fontSize: 13, color: kc.textSecondary)),
        if (r.receiptReference != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SelectableText('Receipt reference: ${r.receiptReference}',
                style: TextStyle(fontSize: 13, color: kc.textSecondary)),
          ),
        const SizedBox(height: 10),
        Text(r.message,
            maxLines: _open ? null : 3,
            overflow: _open ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(height: 1.5, color: kc.textPrimary)),
        if (long)
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48), padding: EdgeInsets.zero),
            onPressed: () => setState(() => _open = !_open),
            child: Text(_open ? 'Show less' : 'Show full message'),
          ),
      ]),
    );
  }
}
