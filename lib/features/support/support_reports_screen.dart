import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/date_utils.dart';
import '../../l10n/app_localizations.dart';
import '../platform/domain/platform_report.dart';
import 'support_repository.dart';

class SupportReportsScreen extends ConsumerStatefulWidget {
  const SupportReportsScreen({super.key});
  @override
  ConsumerState<SupportReportsScreen> createState() =>
      _SupportReportsScreenState();
}

class _SupportReportsScreenState extends ConsumerState<SupportReportsScreen> {
  int _limit = 20;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final reports = ref.watch(mySupportReportsProvider(_limit));
    return Scaffold(
        appBar: AppBar(title: Text(l.supportMyReports)),
        body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 880),
              child: reports.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(l.supportLoadFailed),
                  const SizedBox(height: 12),
                  OutlinedButton(
                      onPressed: () =>
                          ref.invalidate(mySupportReportsProvider(_limit)),
                      child: Text(l.supportRetry)),
                ])),
                data: (rows) => rows.isEmpty
                    ? Center(child: Text(l.supportEmpty))
                    : ListView(padding: const EdgeInsets.all(20), children: [
                        for (final row in rows)
                          Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(row['subject'] as String? ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                        const SizedBox(height: 8),
                                        Wrap(
                                            spacing: 12,
                                            runSpacing: 8,
                                            children: [
                                              Chip(
                                                  label: Text(
                                                      switch (row['status']) {
                                                'in_progress' =>
                                                  l.plStatusInProgress,
                                                'resolved' =>
                                                  l.plStatusResolved,
                                                _ => l.plStatusOpen
                                              })),
                                              Text(reportCategoryText(
                                                  l,
                                                  row['category'] as String? ??
                                                      'General feedback')),
                                            ]),
                                        if (parseFirestoreDate(row['createdAt'])
                                            case final DateTime date)
                                          Text(MaterialLocalizations.of(context)
                                              .formatFullDate(date.toLocal())),
                                        const SizedBox(height: 8),
                                        SelectableText(
                                            row['message'] as String? ?? ''),
                                        if ((row['receiptReference']
                                                    as String? ??
                                                '')
                                            .isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          SelectableText(
                                              '${l.hsReceipt}: ${row['receiptReference']}')
                                        ],
                                        const SizedBox(height: 12),
                                        SelectableText(
                                            '${l.supportCaseId}: ${row['id']}'),
                                      ]))),
                        if (rows.length == _limit)
                          OutlinedButton(
                              onPressed: () => setState(() => _limit += 20),
                              child: Text(l.paLoadMore)),
                      ]),
              )),
        ));
  }
}
