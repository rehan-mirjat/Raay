import 'package:flutter/material.dart';
import '../../features/voting_events/presentation/voter_portal_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kivora/core/theme/kivora_icons.dart';

import '../theme/app_theme.dart';
import '../theme/kivora_colors.dart';
import '../widgets/ui_kit/kivora_button.dart';
import '../widgets/ui_kit/kivora_card.dart';
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
        if (orgState.selectionState == ActiveOrgSelectionState.noOrganizations ||
            orgContext == null) {
          return const _EmptyPlatformWelcome();
        }
        final role = orgContext.member.role;
        final isAdmin = role == OrganizationRole.owner || role == OrganizationRole.admin;
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
    final kc = KivoraColors.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: KivoraCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(KivoraIcons.building2,
                    size: 48, color: AppTheme.primaryBlue),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Kivora',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: kc.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You are not currently a member of any organization. Join an existing workspace or create a new one to begin participating in secure elections.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: kc.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              KivoraButton(
                icon: KivoraIcons.plus,
                label: 'Create Organization',
                onPressed: () => context.go('/orgs/create'),
              ),
              const SizedBox(height: 12),
              KivoraButton(
                type: KivoraButtonType.secondary,
                icon: KivoraIcons.logIn,
                label: 'Join via Code',
                onPressed: () => context.go('/orgs/join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
