import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kivora/core/theme/kivora_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/ui_kit/kivora_button.dart';
import '../../../core/widgets/ui_kit/kivora_card.dart';
import '../domain/organization_enums.dart';
import 'providers/organization_providers.dart';

class OrganizationListScreen extends ConsumerWidget {
  const OrganizationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipsAsync = ref.watch(userMembershipsProvider);
    final organizationsAsync = ref.watch(userOrganizationsProvider);
    final kc = KivoraColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: membershipsAsync.when(
        loading: () => const LoadingView(message: 'Loading workspaces...'),
        error: (e, _) => ErrorView(
          type: ErrorViewType.generic,
          message: 'Error loading organizations: $e',
        ),
        data: (memberships) {
          return organizationsAsync.when(
            loading: () => const LoadingView(message: 'Loading details...'),
            error: (e, _) => ErrorView(
              type: ErrorViewType.generic,
              message: 'Error loading details: $e',
            ),
            data: (organizations) {
              if (organizations.isEmpty) {
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
                            'No organizations yet',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: kc.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Join an existing workspace or create a new one to begin participating in secure elections.',
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

              return SingleChildScrollView(
                padding: EdgeInsets.all(isDesktop ? 40 : 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Organizations',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: kc.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                KivoraButton(
                                  type: KivoraButtonType.secondary,
                                  icon: KivoraIcons.plus,
                                  label: 'Create',
                                  isExpanded: false,
                                  onPressed: () => context.go('/orgs/create'),
                                ),
                                const SizedBox(width: 8),
                                Tooltip(
                                  message: 'Scan to Join',
                                  child: IconButton.outlined(
                                    icon: const Icon(KivoraIcons.qrCode),
                                    onPressed: () => context.go('/orgs/join/scan'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                KivoraButton(
                                  icon: KivoraIcons.logIn,
                                  label: 'Join',
                                  isExpanded: false,
                                  onPressed: () => context.go('/orgs/join'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isDesktop ? 3 : (ResponsiveLayout.isMedium(context) ? 2 : 1),
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: isDesktop ? 1.6 : 2.0,
                          ),
                          itemCount: organizations.length,
                          itemBuilder: (context, index) {
                            final org = organizations[index];
                            final member = memberships.firstWhere(
                                (m) => m.organizationId == org.id);
                            
                            return KivoraCard(
                              padding: const EdgeInsets.all(20),
                              onTap: () {
                                ref.read(activeOrgIdProvider.notifier).selectOrganization(org.id);
                                context.go('/orgs/dashboard');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          image: org.logoUrl != null
                                              ? DecorationImage(
                                                  image: NetworkImage(org.logoUrl!),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: org.logoUrl == null
                                            ? const Icon(KivoraIcons.building2, color: AppTheme.primaryBlue)
                                            : null,
                                      ),
                                      const Expanded(child: SizedBox()),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: member.role == OrganizationRole.owner
                                              ? AppTheme.accentGold.withValues(alpha: 0.1)
                                              : member.role == OrganizationRole.admin
                                                  ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                                                  : kc.border,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          member.role == OrganizationRole.owner
                                              ? 'Owner'
                                              : member.role == OrganizationRole.admin
                                                  ? 'Admin'
                                                  : 'Member',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: member.role == OrganizationRole.owner
                                                ? AppTheme.accentGold
                                                : member.role == OrganizationRole.admin
                                                    ? AppTheme.primaryBlue
                                                    : kc.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Text(
                                    org.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: kc.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Joined workspace',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: kc.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
