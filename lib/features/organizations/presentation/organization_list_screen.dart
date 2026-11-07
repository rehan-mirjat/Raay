import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../billing/ads/ad_banner.dart';
import '../../voting_events/presentation/voter_portal_screen.dart' show AdaptiveCardGrid;
import '../domain/organization.dart';
import '../domain/organization_enums.dart';
import '../domain/organization_member.dart';
import 'providers/organization_providers.dart';

/// Pairs each organization with the user's membership. An organization whose
/// membership is momentarily missing (stale stream) is skipped instead of
/// crashing the screen.
List<({Organization org, OrganizationMember member})> pairOrganizations(
    List<Organization> orgs, List<OrganizationMember> memberships) {
  final out = <({Organization org, OrganizationMember member})>[];
  for (final org in orgs) {
    for (final m in memberships) {
      if (m.organizationId == org.id) {
        out.add((org: org, member: m));
        break;
      }
    }
  }
  return out;
}

class OrganizationListScreen extends ConsumerWidget {
  const OrganizationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final membershipsAsync = ref.watch(userMembershipsProvider);
    final organizationsAsync = ref.watch(userOrganizationsProvider);
    final activeId = ref.watch(activeOrganizationContextProvider).valueOrNull?.context?.organization.id;

    void retry() {
      ref.invalidate(userMembershipsProvider);
      ref.invalidate(userOrganizationsProvider);
    }

    Widget body;
    if (membershipsAsync.hasError || organizationsAsync.hasError) {
      body = ErrorView(type: ErrorViewType.generic, message: l10n.orgsLoadError, onRetry: retry);
    } else if (!membershipsAsync.hasValue || !organizationsAsync.hasValue) {
      body = const LoadingView();
    } else {
      final pairs = pairOrganizations(organizationsAsync.requireValue, membershipsAsync.requireValue);
      body = pairs.isEmpty
          ? const _EmptyState()
          : _OrgGrid(pairs: pairs, activeId: activeId);
    }

    return Scaffold(
      backgroundColor: RaayColors.backgroundOf(context),
      bottomNavigationBar: const AdBanner(),
      body: body,
    );
  }
}

class _OrgGrid extends ConsumerWidget {
  const _OrgGrid({required this.pairs, required this.activeId});
  final List<({Organization org, OrganizationMember member})> pairs;
  final String? activeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = RaayColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 32 : 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(l10n.orgsTitle,
                              style: TextStyle(
                                  fontSize: isDesktop ? 28 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: kc.textPrimary)),
                        ),
                        const SizedBox(height: 4),
                        Text(l10n.orgsSubtitle, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                      ],
                    ),
                  ),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
                      onPressed: () => context.go('/orgs/invitations'),
                      icon: const Icon(Icons.mail_outline_rounded, size: 18),
                      label: Text(l10n.orgsInvitations),
                    ),
                    IconButton.outlined(
                      tooltip: l10n.orgsScan,
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      onPressed: () => context.go('/orgs/join/scan'),
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
                      onPressed: () => context.go('/orgs/join'),
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: Text(l10n.orgsJoin),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                      onPressed: () => context.go('/orgs/create'),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: Text(l10n.orgsCreate),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 24),
              AdaptiveCardGrid(
                minColumnWidth: 340,
                children: [
                  for (final p in pairs)
                    OrgCard(
                      key: ValueKey(p.org.id),
                      org: p.org,
                      role: p.member.role,
                      isCurrent: p.org.id == activeId,
                      onOpen: () async {
                        await ref.read(activeOrgIdProvider.notifier).selectOrganization(p.org.id);
                        if (context.mounted) context.go('/home');
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrgCard extends StatelessWidget {
  const OrgCard({
    super.key,
    required this.org,
    required this.role,
    required this.isCurrent,
    required this.onOpen,
  });

  final Organization org;
  final OrganizationRole role;
  final bool isCurrent;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    final statusLabel = switch (org.status) {
      OrganizationStatus.pending => l10n.orgsStatusPending,
      OrganizationStatus.suspended => l10n.orgsStatusSuspended,
      OrganizationStatus.rejected => l10n.orgsStatusRejected,
      _ => null,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: isCurrent ? primary : kc.border, width: isCurrent ? 2 : 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                  image: org.logoUrl != null
                      ? DecorationImage(image: NetworkImage(org.logoUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: org.logoUrl == null
                    ? Icon(Icons.business_rounded, color: kc.accentText)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  org.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kc.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            StatusBadge.role(role.name),
            if (statusLabel != null)
              StatusBadge(
                  label: statusLabel.toUpperCase(),
                  backgroundColor: kc.warningText.withValues(alpha: kc.isDark ? 0.16 : 0.10),
                  textColor: kc.warningText,
                  icon: Icons.info_outline_rounded),
            if (isCurrent)
              StatusBadge(
                  label: l10n.orgsCurrent.toUpperCase(),
                  backgroundColor: primary.withValues(alpha: kc.isDark ? 0.16 : 0.10),
                  textColor: kc.accentText,
                  icon: Icons.check_circle_rounded),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: isCurrent
                ? FilledButton(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    onPressed: onOpen,
                    child: Text(l10n.orgsOpen, textAlign: TextAlign.center),
                  )
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    onPressed: onOpen,
                    child: Text(l10n.orgsOpen, textAlign: TextAlign.center),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kc.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              border: Border.all(color: kc.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(child: Icon(Icons.business_rounded, size: 48, color: kc.accentText)),
                const SizedBox(height: 16),
                Text(l10n.orgsEmptyTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                const SizedBox(height: 8),
                Text(l10n.orgsEmptyBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.5, color: kc.textSecondary)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    onPressed: () => context.go('/orgs/create'),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.orgsCreateFull),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    onPressed: () => context.go('/orgs/join'),
                    icon: const Icon(Icons.login_rounded),
                    label: Text(l10n.orgsJoinFull),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
