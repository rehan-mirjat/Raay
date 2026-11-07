import '../../../core/utils/status_text.dart';
import '../../../core/utils/date_text.dart';
import '../../../core/utils/audit_action_label.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/raay_colors.dart';
import '../../../core/widgets/stat_tile.dart';
import '../data/platform_providers.dart';
import '../domain/platform_audit_entry.dart';
import 'platform_scaffold.dart';

/// Platform-wide summary. Every number comes from the platform backend
/// (`getPlatformAnalytics`, the audit log and the reports collection); a
/// section that fails to load says so on its own instead of showing zeros.
class PlatformOverviewScreen extends ConsumerWidget {
  const PlatformOverviewScreen({super.key});

  int? _n(Map<String, dynamic>? m, String k) => (m?[k] as num?)?.toInt();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformPage(
      title: AppLocalizations.of(context).plOverviewTitle,
      subtitle: AppLocalizations.of(context).plOverviewSubtitle,
      actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () => context.go('/platform/health'),
          icon: const Icon(Icons.monitor_heart_outlined, size: 18),
          label: Text(AppLocalizations.of(context).navPlatformHealth),
        ),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () {
            ref.invalidate(platformAnalyticsProvider);
            ref.invalidate(openReportCountProvider);
            ref.invalidate(platformAuditProvider(5));
          },
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(AppLocalizations.of(context).plRefresh),
        ),
      ],
      builder: (context) {
        final kc = RaayColors.of(context);
        final analytics = ref.watch(platformAnalyticsProvider);
        final reports = ref.watch(openReportCountProvider);
        final m = analytics.valueOrNull;
        final pending = _n(m, 'pendingOrganizations');
        final openReports = reports.valueOrNull;

        final alerts = <Widget>[
          if ((pending ?? 0) > 0)
            _Alert(
              icon: Icons.pending_actions_rounded,
              text: pending == 1
                  ? AppLocalizations.of(context).plPendingOne
                  : AppLocalizations.of(context).plPendingMany('$pending'),
              action: AppLocalizations.of(context).plReviewOrgs,
              onTap: () => context.go('/platform/organizations'),
            ),
          if ((openReports ?? 0) > 0)
            _Alert(
              icon: Icons.flag_outlined,
              text: openReports == 1
                  ? AppLocalizations.of(context).plReportsOne
                  : AppLocalizations.of(context).plReportsMany('$openReports'),
              action: AppLocalizations.of(context).plOpenReports,
              onTap: () => context.go('/platform/reports'),
            ),
        ];

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (analytics.hasError)
                _SectionError(
                  message: AppLocalizations.of(context).plTotalsFailed,
                  onRetry: () => ref.invalidate(platformAnalyticsProvider),
                )
              else ...[
                StatTileRow(tiles: [
                  StatTile(
                      label: AppLocalizations.of(context).plStatOrgs,
                      value: _n(m, 'organizations')),
                  StatTile(
                      label: AppLocalizations.of(context).plStatWaiting,
                      value: pending),
                  StatTile(
                      label: AppLocalizations.of(context).plStatActive,
                      value: _n(m, 'activeOrganizations')),
                  StatTile(
                      label: AppLocalizations.of(context).plStatSuspended,
                      value: _n(m, 'suspendedOrganizations')),
                ]),
                const SizedBox(height: 12),
                StatTileRow(tiles: [
                  StatTile(
                      label: AppLocalizations.of(context).plStatAccounts,
                      value: _n(m, 'users')),
                  StatTile(
                      label: AppLocalizations.of(context).plStatMemberships,
                      value: _n(m, 'activeMembers')),
                  StatTile(
                      label: AppLocalizations.of(context).plStatElections,
                      value: _n(m, 'votingEvents')),
                  StatTile(
                      label: AppLocalizations.of(context).plStatOpenNow,
                      value: _n(m, 'activeVotingEvents')),
                ]),
              ],
              const SizedBox(height: 20),
              LayoutBuilder(builder: (context, c) {
                final needs = PlatformPanel(
                  title: AppLocalizations.of(context).plNeedsAttention,
                  child: analytics.isLoading && !analytics.hasValue
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: LinearProgressIndicator())
                      : alerts.isEmpty
                          ? Text(
                              analytics.hasError || reports.hasError
                                  ? AppLocalizations.of(context)
                                      .plChecksIncomplete
                                  : AppLocalizations.of(context)
                                      .plNothingAttention,
                              style: TextStyle(color: kc.textSecondary))
                          : Column(children: alerts),
                );
                final activity = PlatformPanel(
                  title: AppLocalizations.of(context).plRecentActivity,
                  trailing: TextButton(
                    style:
                        TextButton.styleFrom(minimumSize: const Size(48, 48)),
                    onPressed: () => context.go('/platform/audit'),
                    child: Text(AppLocalizations.of(context).plViewAll),
                  ),
                  child: const _RecentActivity(),
                );
                if (c.maxWidth >= 900) {
                  return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: activity),
                        const SizedBox(width: 20),
                        Expanded(flex: 2, child: needs),
                      ]);
                }
                return Column(
                    children: [needs, const SizedBox(height: 16), activity]);
              }),
            ]);
      },
    );
  }
}

class _Alert extends StatelessWidget {
  const _Alert(
      {required this.icon,
      required this.text,
      required this.action,
      required this.onTap});
  final IconData icon;
  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: kc.warningText),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: kc.textPrimary)),
            TextButton(
              style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48), padding: EdgeInsets.zero),
              onPressed: onTap,
              child: Text(action),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    return PlatformPanel(
      title: AppLocalizations.of(context).plUnavailable,
      child: Row(children: [
        Expanded(child: Text(message, style: TextStyle(color: kc.errorText))),
        TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).plTryAgain)),
      ]),
    );
  }
}

class _RecentActivity extends ConsumerWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = RaayColors.of(context);
    final entries = ref.watch(platformAuditProvider(5));
    final dir = ref.watch(platformDirectoryProvider).valueOrNull ??
        const PlatformDirectory();
    return entries.when(
      loading: () => const Padding(
          padding: EdgeInsets.all(12), child: LinearProgressIndicator()),
      error: (e, _) => Text(AppLocalizations.of(context).plActivityFailed,
          style: TextStyle(color: kc.errorText)),
      data: (list) => list.isEmpty
          ? Text(AppLocalizations.of(context).plNoActivity,
              style: TextStyle(color: kc.textSecondary))
          : Column(children: [
              for (final e in list) AuditEntryRow(entry: e, directory: dir)
            ]),
    );
  }
}

/// One audit entry as a row: what happened, to what, by whom, and when.
class AuditEntryRow extends StatelessWidget {
  const AuditEntryRow(
      {super.key, required this.entry, required this.directory});
  final PlatformAuditEntry entry;
  final PlatformDirectory directory;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final target = entry.organizationId != null
        ? directory.org(entry.organizationId!)
        : entry.targetUid != null
            ? directory.user(entry.targetUid!)
            : null;
    final change = entry.previousStatus != null && entry.newStatus != null
        ? '${orgStatusText(AppLocalizations.of(context), entry.previousStatus!)} → ${orgStatusText(AppLocalizations.of(context), entry.newStatus!)}'
        : null;
    final when = entry.time == null
        ? AppLocalizations.of(context).plTimeUnknown
        : formatDateTimeText(context, entry.time!);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.history_rounded, size: 20, color: kc.accentText),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(auditActionText(AppLocalizations.of(context), entry.action),
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: kc.textPrimary)),
            const SizedBox(height: 2),
            Text(
              [
                if (target != null)
                  AppLocalizations.of(context).plTarget(target),
                if (change != null) change,
                AppLocalizations.of(context)
                    .plBy(directory.user(entry.actorUid))
              ].join(' · '),
              style: TextStyle(fontSize: 13, color: kc.textSecondary),
            ),
            Text(when, style: TextStyle(fontSize: 12, color: kc.textSecondary)),
          ]),
        ),
      ]),
    );
  }
}
