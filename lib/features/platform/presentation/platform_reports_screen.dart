import '../../../core/utils/date_text.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/raay_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/platform_providers.dart';
import '../domain/platform_report.dart';
import 'platform_scaffold.dart';

/// Reports filed from Help & support. Platform admins can assign a report to
/// themselves, resolve it, or reopen it; each change is enforced and audited
/// by a Cloud Function.
class PlatformReportsScreen extends ConsumerStatefulWidget {
  const PlatformReportsScreen({super.key});

  @override
  ConsumerState<PlatformReportsScreen> createState() =>
      _PlatformReportsScreenState();
}

class _PlatformReportsScreenState extends ConsumerState<PlatformReportsScreen> {
  int _limit = kPlatformPageSize;
  String? _category;
  String? _status;

  @override
  Widget build(BuildContext context) {
    return PlatformPage(
      title: AppLocalizations.of(context).plReportsTitle,
      subtitle: AppLocalizations.of(context).salesReportsSubtitle,
      actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () => ref.invalidate(platformReportsProvider(_limit)),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(AppLocalizations.of(context).plRefresh),
        ),
      ],
      builder: (context) {
        final kc = RaayColors.of(context);
        final reports = ref.watch(platformReportsProvider(_limit));
        return reports.when(
          loading: () => Padding(
              padding: const EdgeInsets.all(32),
              child: LoadingView(
                  message: AppLocalizations.of(context).plReportsLoading)),
          error: (e, _) => ErrorView(
            type: ErrorViewType.generic,
            message: AppLocalizations.of(context).plReportsFailed,
            onRetry: () => ref.invalidate(platformReportsProvider(_limit)),
          ),
          data: (all) {
            if (all.isEmpty) {
              return EmptyView(
                icon: Icons.flag_outlined,
                title: AppLocalizations.of(context).plReportsEmptyTitle,
                message: AppLocalizations.of(context).plReportsEmptyBody,
              );
            }
            final categories = {for (final r in all) r.category}.toList()
              ..sort();
            if (_category != null && !categories.contains(_category)) {
              _category = null;
            }
            final shown = _category == null
                ? all
                    .where((r) => _status == null || r.status == _status)
                    .toList()
                : all
                    .where((r) =>
                        r.category == _category &&
                        (_status == null || r.status == _status))
                    .toList();
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(AppLocalizations.of(context).plReportsReadOnly,
                      style: TextStyle(fontSize: 13, color: kc.textSecondary)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    ChoiceChip(
                        label: Text(AppLocalizations.of(context)
                            .plAllCount('${all.length}')),
                        selected: _category == null,
                        onSelected: (_) => setState(() => _category = null)),
                    for (final c in categories)
                      ChoiceChip(
                          label: Text(
                              '${reportCategoryText(AppLocalizations.of(context), c)} (${all.where((r) => r.category == c).length})'),
                          selected: _category == c,
                          onSelected: (_) => setState(() => _category = c)),
                  ]),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)
                          .plAllCount('${all.length}')),
                      selected: _status == null,
                      onSelected: (_) => setState(() => _status = null),
                    ),
                    for (final value in const [
                      'open',
                      'in_progress',
                      'resolved'
                    ])
                      if (all.any((report) => report.status == value))
                        ChoiceChip(
                          label: Text(
                            '${switch (value) {
                              'open' =>
                                AppLocalizations.of(context).plStatusOpen,
                              'in_progress' =>
                                AppLocalizations.of(context).plStatusInProgress,
                              _ =>
                                AppLocalizations.of(context).plStatusResolved,
                            }} (${all.where((report) => report.status == value).length})',
                          ),
                          selected: _status == value,
                          onSelected: (_) => setState(() => _status = value),
                        ),
                  ]),
                  const SizedBox(height: 16),
                  if (shown.isEmpty)
                    EmptyView(
                      icon: Icons.filter_alt_off_outlined,
                      title: AppLocalizations.of(context).plReportsEmptyTitle,
                      message: AppLocalizations.of(context).plReportsEmptyBody,
                    ),
                  for (final r in shown) ...[
                    _ReportCard(report: r, limit: _limit),
                    const SizedBox(height: 12)
                  ],
                  if (all.length >= _limit)
                    Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        onPressed: () =>
                            setState(() => _limit += kPlatformPageSize),
                        child: Text(
                            AppLocalizations.of(context).plLoadOlderReports),
                      ),
                    ),
                ]);
          },
        );
      },
    );
  }
}

class _ReportCard extends ConsumerStatefulWidget {
  const _ReportCard({required this.report, required this.limit});
  final PlatformReport report;
  final int limit;

  @override
  ConsumerState<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends ConsumerState<_ReportCard> {
  bool _open = false;
  bool _updating = false;

  Future<void> _update(String action) async {
    if (_updating) return;
    setState(() => _updating = true);
    try {
      await ref.read(platformReportUpdaterProvider)(widget.report.id, action);
      ref.invalidate(platformReportsProvider(widget.limit));
      ref.invalidate(openReportCountProvider);
      ref.invalidate(platformAnalyticsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).plReportUpdateSuccess),
        ));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).plReportUpdateFailed),
        ));
      }
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final r = widget.report;
    final when = r.time == null ? '' : formatDateTimeText(context, r.time!);
    final long = r.message.length > 160 || r.message.contains('\n');
    return PlatformPanel(
      title: r.subject.isEmpty
          ? AppLocalizations.of(context).plNoSubject
          : r.subject,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: kc.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              switch (r.status) {
                'open' => AppLocalizations.of(context).plStatusOpen,
                'in_progress' =>
                  AppLocalizations.of(context).plStatusInProgress,
                'resolved' => AppLocalizations.of(context).plStatusResolved,
                _ => r.status,
              }
                  .toUpperCase(),
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: kc.textSecondary),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: AppLocalizations.of(context).plReportsTitle,
            enabled: !_updating,
            onSelected: _update,
            itemBuilder: (context) => [
              if (r.status != 'resolved')
                PopupMenuItem(
                  value: 'ASSIGN_TO_ME',
                  child: Text(AppLocalizations.of(context).plAssignToMe),
                ),
              if (r.status != 'resolved')
                PopupMenuItem(
                  value: 'RESOLVE',
                  child: Text(AppLocalizations.of(context).plResolveReport),
                ),
              if (r.status == 'resolved')
                PopupMenuItem(
                  value: 'REOPEN',
                  child: Text(AppLocalizations.of(context).plReopenReport),
                ),
            ],
            icon: _updating
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            [
              reportCategoryText(AppLocalizations.of(context), r.category),
              if (r.userEmail.isNotEmpty) r.userEmail,
              if (when.isNotEmpty) when
            ].join(' · '),
            style: TextStyle(fontSize: 13, color: kc.textSecondary)),
        if (r.receiptReference != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SelectableText(
                AppLocalizations.of(context).plReceiptRef(r.receiptReference!),
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
            child: Text(_open
                ? AppLocalizations.of(context).plShowLess
                : AppLocalizations.of(context).plShowFull),
          ),
      ]),
    );
  }
}
