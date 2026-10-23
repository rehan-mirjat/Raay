import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/kivora_colors.dart';
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
      title: 'Platform overview',
      subtitle:
          'Organizations, reviews and recent administrator activity across Kivora.',
      actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () {
            ref.invalidate(platformAnalyticsProvider);
            ref.invalidate(openReportCountProvider);
            ref.invalidate(platformAuditProvider(5));
          },
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Refresh'),
        ),
      ],
      builder: (context) {
        final kc = KivoraColors.of(context);
        final analytics = ref.watch(platformAnalyticsProvider);
        final reports = ref.watch(openReportCountProvider);
        final m = analytics.valueOrNull;
        final pending = _n(m, 'pendingOrganizations');
        final openReports = reports.valueOrNull;

        final alerts = <Widget>[
          if ((pending ?? 0) > 0)
            _Alert(
              icon: Icons.pending_actions_rounded,
              text:
                  '$pending ${pending == 1 ? 'organization is' : 'organizations are'} waiting for review.',
              action: 'Review organizations',
              onTap: () => context.go('/platform/organizations'),
            ),
          if ((openReports ?? 0) > 0)
            _Alert(
              icon: Icons.flag_outlined,
              text:
                  '$openReports open user ${openReports == 1 ? 'report' : 'reports'}.',
              action: 'Open reports',
              onTap: () => context.go('/platform/reports'),
            ),
        ];

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (analytics.hasError)
                _SectionError(
                  message: 'Platform totals could not be loaded.',
                  onRetry: () => ref.invalidate(platformAnalyticsProvider),
                )
              else ...[
                StatTileRow(tiles: [
                  StatTile(
                      label: 'Organizations', value: _n(m, 'organizations')),
                  StatTile(label: 'Waiting for review', value: pending),
                  StatTile(
                      label: 'Active or verified',
                      value: _n(m, 'activeOrganizations')),
                  StatTile(
                      label: 'Suspended',
                      value: _n(m, 'suspendedOrganizations')),
                ]),
                const SizedBox(height: 12),
                StatTileRow(tiles: [
                  StatTile(label: 'Accounts', value: _n(m, 'users')),
                  StatTile(
                      label: 'Active memberships',
                      value: _n(m, 'activeMembers')),
                  StatTile(
                      label: 'Elections and polls',
                      value: _n(m, 'votingEvents')),
                  StatTile(
                      label: 'Voting open now',
                      value: _n(m, 'activeVotingEvents')),
                ]),
              ],
              const SizedBox(height: 20),
              LayoutBuilder(builder: (context, c) {
                final needs = PlatformPanel(
                  title: 'Needs attention',
                  child: analytics.isLoading && !analytics.hasValue
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: LinearProgressIndicator())
                      : alerts.isEmpty
                          ? Text(
                              analytics.hasError || reports.hasError
                                  ? 'Some checks could not run, so this list may be incomplete.'
                                  : 'Nothing needs attention right now.',
                              style: TextStyle(color: kc.textSecondary))
                          : Column(children: alerts),
                );
                final activity = PlatformPanel(
                  title: 'Recent administrator activity',
                  trailing: TextButton(
                    style:
                        TextButton.styleFrom(minimumSize: const Size(48, 48)),
                    onPressed: () => context.go('/platform/audit'),
                    child: const Text('View all'),
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
    final kc = KivoraColors.of(context);
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
    final kc = KivoraColors.of(context);
    return PlatformPanel(
      title: 'Unavailable',
      child: Row(children: [
        Expanded(child: Text(message, style: TextStyle(color: kc.errorText))),
        TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: onRetry,
            child: const Text('Try again')),
      ]),
    );
  }
}

class _RecentActivity extends ConsumerWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = KivoraColors.of(context);
    final entries = ref.watch(platformAuditProvider(5));
    final dir = ref.watch(platformDirectoryProvider).valueOrNull ??
        const PlatformDirectory();
    return entries.when(
      loading: () => const Padding(
          padding: EdgeInsets.all(12), child: LinearProgressIndicator()),
      error: (e, _) => Text('The activity log could not be loaded.',
          style: TextStyle(color: kc.errorText)),
      data: (list) => list.isEmpty
          ? Text('No administrator actions have been recorded yet.',
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
    final kc = KivoraColors.of(context);
    final target = entry.organizationId != null
        ? directory.org(entry.organizationId!)
        : entry.targetUid != null
            ? directory.user(entry.targetUid!)
            : null;
    final change = entry.previousStatus != null && entry.newStatus != null
        ? '${entry.previousStatus} → ${entry.newStatus}'
        : null;
    final when = entry.time == null
        ? 'Time unavailable'
        : DateFormat('MMM d, yyyy · HH:mm').format(entry.time!.toLocal());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.history_rounded, size: 20, color: kc.accentText),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(entry.actionLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w700, color: kc.textPrimary)),
            const SizedBox(height: 2),
            Text(
              [
                if (target != null) 'Target: $target',
                if (change != null) change,
                'By ${directory.user(entry.actorUid)}'
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
