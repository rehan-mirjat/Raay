import 'package:flutter/material.dart';
import '../../features/voting_events/presentation/voter_portal_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raay/core/theme/raay_icons.dart';

import '../theme/app_theme.dart';
import '../theme/raay_colors.dart';
import '../widgets/ui_kit/raay_button.dart';
import '../widgets/ui_kit/raay_card.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../features/organizations/domain/organization_enums.dart';
import '../../features/organizations/presentation/admin_overview_screen.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final activeContextState = ref.watch(activeOrganizationContextProvider);

    return activeContextState.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        type: ErrorViewType.generic,
        message: l10n.overviewLoadError,
        onRetry: () => ref.invalidate(activeOrganizationContextProvider),
      ),
      data: (orgState) {
        final orgContext = orgState.context;
        if (orgState.selectionState ==
                ActiveOrgSelectionState.noOrganizations ||
            orgContext == null) {
          return const _EmptyPlatformWelcome();
        }
        final role = orgContext.member.role;
        final isAdmin =
            role == OrganizationRole.owner || role == OrganizationRole.admin;
        // Voters land on their elections; owners/admins on the one Overview.
        if (!isAdmin) return const VoterPortalScreen(embedded: true);
        return AdminOverviewScreen(orgContext: orgContext);
      },
    );
  }
}

class _EmptyPlatformWelcome extends ConsumerWidget {
  const _EmptyPlatformWelcome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = RaayColors.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: RaayCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(RaayIcons.building2,
                    size: 48, color: RaayColors.of(context).accentText),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.homeNoOrgTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: kc.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.homeNoOrgBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: kc.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              RaayButton(
                icon: RaayIcons.plus,
                label: l10n.homeCreateOrg,
                onPressed: () => context.go('/orgs/create'),
              ),
              const SizedBox(height: 12),
              RaayButton(
                type: RaayButtonType.secondary,
                icon: RaayIcons.logIn,
                label: l10n.homeJoinByCode,
                onPressed: () => context.go('/orgs/join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
