import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/raay_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/firebase_service.dart';
import '../../voting_events/domain/election_results.dart' show csvCell;
import '../domain/organization_enums.dart';
import 'providers/organization_providers.dart';

typedef OrganizationReportQuery = ({
  String orgId,
  String? from,
  String? to,
  String? cursor
});

final organizationReportProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, OrganizationReportQuery>((ref, query) async {
  final response = await FirebaseService()
      .functions
      .httpsCallable('getOrganizationReport')
      .call({
    'organizationId': query.orgId,
    if (query.from != null) 'fromDate': query.from,
    if (query.to != null) 'toDate': query.to,
    if (query.cursor != null) 'cursor': jsonDecode(query.cursor!),
  });
  return Map<String, dynamic>.from(response.data as Map);
});

/// Uses only the authorized, privacy-suppressed page already returned by the server.
String organizationReportCsv(Map<String, dynamic> report) {
  final rows = <String>[
    'Title,Status,Created at (UTC),Results published,Turnout percent'
  ];
  for (final item in report['events'] as List? ?? const []) {
    final row = Map<String, dynamic>.from(item as Map);
    rows.add([
      csvCell(row['title']?.toString() ?? ''),
      csvCell(row['status']?.toString() ?? ''),
      csvCell(row['createdAt']?.toString() ?? ''),
      row['published'] == true ? 'true' : 'false',
      row['turnoutSuppressed'] == true
          ? ''
          : (row['turnoutPercent']?.toString() ?? ''),
    ].join(','));
  }
  return rows.join('\r\n');
}

class OrganizationReportsScreen extends ConsumerStatefulWidget {
  const OrganizationReportsScreen({super.key});

  @override
  ConsumerState<OrganizationReportsScreen> createState() =>
      _OrganizationReportsScreenState();
}

class _OrganizationReportsScreenState
    extends ConsumerState<OrganizationReportsScreen> {
  DateTimeRange? _dates;
  String? _cursor;
  String? _organizationId;
  final List<String?> _previous = [];
  bool _exporting = false;

  void _resetPages() {
    _cursor = null;
    _previous.clear();
  }

  Future<void> _chooseDates() async {
    final now = DateTime.now();
    final selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: _dates,
    );
    if (!mounted || selected == null) return;
    setState(() {
      _dates = selected;
      _resetPages();
    });
  }

  Future<void> _export(Map<String, dynamic> data, String name) async {
    final l10n = AppLocalizations.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;
    setState(() => _exporting = true);
    try {
      await SharePlus.instance.share(ShareParams(
        files: [
          XFile.fromData(
              Uint8List.fromList(utf8.encode(organizationReportCsv(data))),
              mimeType: 'text/csv')
        ],
        fileNameOverrides: ['raay_organization_report.csv'],
        subject: name,
        sharePositionOrigin: origin,
      ));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.resActionFailed)));
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final org =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
    if (org == null ||
        !org.member.role.isAdmin ||
        org.member.status != MembershipStatus.active) {
      return Scaffold(
          body: ErrorView(
              type: ErrorViewType.accessDenied, message: l10n.orgReportDenied));
    }
    // A tenant switch starts a fresh page; old cursors cannot affect the new organization.
    if (_organizationId != org.organization.id) {
      _organizationId = org.organization.id;
      _resetPages();
    }
    final end = _dates?.end;
    final query = (
      orgId: org.organization.id,
      from: _dates?.start.toUtc().toIso8601String(),
      to: end == null
          ? null
          : DateTime(end.year, end.month, end.day + 1)
              .toUtc()
              .toIso8601String(),
      cursor: _cursor,
    );
    final report = ref.watch(organizationReportProvider(query));
    final compact = ResponsiveLayout.isCompact(context);
    final kc = RaayColors.of(context);
    final material = MaterialLocalizations.of(context);
    final dateLabel = _dates == null
        ? l10n.orgReportAllDates
        : '${material.formatShortDate(_dates!.start)} – ${material.formatShortDate(_dates!.end)}';
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
        child: ListView(padding: EdgeInsets.all(compact ? 16 : 32), children: [
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(l10n.orgReportTitle,
                      style: TextStyle(
                          fontSize: compact ? 24 : 30,
                          fontWeight: FontWeight.w800,
                          color: kc.textPrimary)),
                  const SizedBox(height: 4),
                  Text(l10n.orgReportSubtitle(org.organization.name),
                      style: TextStyle(color: kc.textSecondary)),
                ])),
            IconButton(
                tooltip: l10n.orgReportRefresh,
                onPressed: () =>
                    ref.invalidate(organizationReportProvider(query)),
                icon: const Icon(Icons.refresh_rounded)),
          ]),
          const SizedBox(height: 20),
          Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton.icon(
                    onPressed: _chooseDates,
                    icon: const Icon(Icons.date_range_outlined),
                    label: Text('${l10n.orgReportDates}: $dateLabel')),
                if (_dates != null)
                  TextButton(
                      onPressed: () => setState(() {
                            _dates = null;
                            _resetPages();
                          }),
                      child: Text(l10n.orgReportClearDates)),
              ]),
          const SizedBox(height: 12),
          Text(l10n.orgReportScope, style: TextStyle(color: kc.textSecondary)),
          const SizedBox(height: 20),
          report.when(
            loading: () => const Padding(
                padding: EdgeInsets.all(32), child: LoadingView()),
            error: (_, __) => ErrorView(
                type: ErrorViewType.generic,
                message: l10n.orgReportFailed,
                onRetry: () =>
                    ref.invalidate(organizationReportProvider(query))),
            data: (data) {
              final events = data['events'] as List? ?? const [];
              final tiles = <(String, String)>[
                (l10n.orgReportMembers, '${data['activeMembers'] ?? 0}'),
                (l10n.orgReportEvents, '${data['eventCount'] ?? 0}'),
                (
                  l10n.orgReportPublishedCount,
                  '${data['publishedEventCount'] ?? 0}'
                ),
                (
                  l10n.orgReportTurnout,
                  data['aggregateTurnoutPercent'] == null
                      ? (data['aggregateTurnoutSuppressed'] == true
                          ? l10n.orgReportPrivate
                          : l10n.orgReportUnavailable)
                      : '${data['aggregateTurnoutPercent']}%'
                ),
              ];
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: tiles
                            .map((item) => SizedBox(
                                  width: compact ? double.infinity : 250,
                                  child: Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(18),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(item.$2,
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: kc.textPrimary)),
                                                Text(item.$1,
                                                    style: TextStyle(
                                                        color:
                                                            kc.textSecondary)),
                                              ]))),
                                ))
                            .toList()),
                    const SizedBox(height: 20),
                    Card(
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.orgReportActivity,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: kc.textPrimary)),
                                  const SizedBox(height: 8),
                                  for (final item in events)
                                    _EventReportRow(
                                        data: Map<String, dynamic>.from(
                                            item as Map)),
                                  if (events.isEmpty)
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24),
                                        child: Text(l10n.orgReportEmpty)),
                                ]))),
                    const SizedBox(height: 12),
                    Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          OutlinedButton(
                              onPressed: _previous.isEmpty
                                  ? null
                                  : () => setState(
                                      () => _cursor = _previous.removeLast()),
                              child: Text(l10n.orgReportPrevious)),
                          Text(l10n.orgReportPage('${_previous.length + 1}')),
                          OutlinedButton(
                              onPressed: data['hasMore'] != true ||
                                      data['nextCursor'] == null
                                  ? null
                                  : () => setState(() {
                                        _previous.add(_cursor);
                                        _cursor =
                                            jsonEncode(data['nextCursor']);
                                      }),
                              child: Text(l10n.orgReportNext)),
                          FilledButton.icon(
                              onPressed: events.isEmpty || _exporting
                                  ? null
                                  : () => _export(data, org.organization.name),
                              icon: const Icon(Icons.ios_share_rounded),
                              label: Text(l10n.orgReportExport)),
                        ]),
                    const SizedBox(height: 12),
                    Text(l10n.orgReportPrivacy,
                        style: TextStyle(color: kc.textSecondary, height: 1.4)),
                  ]);
            },
          ),
        ]),
      )),
    );
  }
}

class _EventReportRow extends StatelessWidget {
  const _EventReportRow({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    final turnout = data['turnoutPercent'];
    final status = switch (data['status']) {
      'DRAFT' => l10n.statusDraft,
      'SCHEDULED' => l10n.statusScheduled,
      'ACTIVE' => l10n.statusActive,
      'CLOSED' => l10n.statusClosed,
      'ARCHIVED' => l10n.statusArchived,
      'CANCELLED' => l10n.statusCancelled,
      _ => l10n.statusUnknown,
    };
    return ListTile(
      onTap: data['id'] is String
          ? () => context.go('/elections/${data['id']}')
          : null,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.how_to_vote_outlined),
      title: Text(data['title'] as String? ?? l10n.resEventFallback),
      subtitle: Text(
          '$status · ${data['published'] == true ? l10n.orgReportPublished : l10n.orgReportUnpublished}'),
      trailing: turnout != null
          ? Text('$turnout%',
              style: TextStyle(
                  color: kc.textSecondary, fontWeight: FontWeight.w600))
          : Tooltip(
              message: data['turnoutSuppressed'] == true
                  ? l10n.orgReportPrivate
                  : l10n.orgReportUnavailable,
              child: Icon(
                  data['turnoutSuppressed'] == true
                      ? Icons.lock_outline
                      : Icons.remove,
                  color: kc.textSecondary)),
    );
  }
}
