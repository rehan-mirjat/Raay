import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../services/firebase_service.dart';
import 'providers/organization_providers.dart';

class OrganizationContextSwitcher extends ConsumerWidget {
  const OrganizationContextSwitcher({super.key});

  void _showSwitcherModal(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 650;

    Widget contentBuilder(BuildContext context) {
      return Consumer(
        builder: (context, ref, child) {
          
          final orgsAsync = ref.watch(userOrganizationsProvider);
          final activeOrgStateAsync = ref.watch(activeOrganizationContextProvider);

          final activeOrgId = activeOrgStateAsync.valueOrNull?.context?.organization.id;
          final organizations = orgsAsync.valueOrNull ?? [];
          final orgsLoading = orgsAsync.isLoading && !orgsAsync.hasValue;
          final orgsError = orgsAsync.hasError && !orgsAsync.hasValue;

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Switch organization',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.secondaryNavy),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Choose the workspace you want to work in.',
                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (orgsLoading) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ] else if (orgsError) ...[
                    Column(
                      children: [
                        const Text(
                          'Could not load your organizations.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.error),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => ref.invalidate(userOrganizationsProvider),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Try again'),
                        ),
                      ],
                    ),
                  ] else if (organizations.isEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No joined organizations found.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ] else ...[
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < organizations.length; i++) ...[
                              if (i > 0) const SizedBox(height: 8),
                              Builder(builder: (context) {
                                final org = organizations[i];
                                final isSelected = org.id == activeOrgId;

                                return _SwitcherOrgItem(
                                  org: org,
                                  isSelected: isSelected,
                                  onTap: () {
                                    ref.read(activeOrgIdProvider.notifier).selectOrganization(org.id);
                                    Navigator.pop(context);
                                  },
                                );
                              }),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppTheme.borderLight),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    context,
                    icon: Icons.key_outlined,
                    label: 'Join organization with code',
                    onTap: () {
                      final router = GoRouter.of(context);
                      Navigator.pop(context);
                      router.go('/orgs/join');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.add_rounded,
                    label: 'Create new organization',
                    onTap: () {
                      final router = GoRouter.of(context);
                      Navigator.pop(context);
                      router.go('/orgs/create');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.mail_outline_rounded,
                    label: 'View invitations',
                    onTap: () {
                      final router = GoRouter.of(context);
                      Navigator.pop(context);
                      router.go('/orgs/invitations');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    if (isDesktop) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: contentBuilder(context),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => contentBuilder(context),
      );
    }
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryBlue),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppTheme.secondaryNavy, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeContextState = ref.watch(activeOrganizationContextProvider);

    return activeContextState.when(
      loading: () => const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => TextButton.icon(
        onPressed: () => ref.invalidate(activeOrganizationContextProvider),
        icon: const Icon(Icons.refresh_rounded, size: 18),
        label: const Text('Retry'),
      ),
      data: (state) {
        final contextObj = state.context;
        final orgName = contextObj?.organization.name ?? 'Select Organization';

        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceBlue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showSwitcherModal(context, ref),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.business_rounded, color: AppTheme.primaryBlue, size: 16),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CURRENT ORGANIZATION',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          orgName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppTheme.secondaryNavy,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.unfold_more_rounded, color: AppTheme.textSecondary, size: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SwitcherOrgItem extends StatefulWidget {
  const _SwitcherOrgItem({
    required this.org,
    required this.isSelected,
    required this.onTap,
  });

  final dynamic org;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_SwitcherOrgItem> createState() => _SwitcherOrgItemState();
}

class _SwitcherOrgItemState extends State<_SwitcherOrgItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFF0F5FF)
                : (_isHovered ? AppTheme.surfaceBlue.withValues(alpha: 0.5) : AppTheme.surfaceWhite),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                  : (_isHovered ? AppTheme.primaryBlue.withValues(alpha: 0.2) : AppTheme.borderLight),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                      : AppTheme.surfaceBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: (widget.org.logoUrl != null && widget.org.logoUrl!.isNotEmpty)
                    ? Image.network(
                        FirebaseService.sanitizeStorageUrl(widget.org.logoUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Center(
                          child: Icon(
                            widget.org.type == 'academic' ? Icons.school_outlined : Icons.business_outlined,
                            size: 20,
                            color: widget.isSelected ? AppTheme.primaryBlue : AppTheme.secondaryNavy,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          widget.org.type == 'academic' ? Icons.school_outlined : Icons.business_outlined,
                          size: 20,
                          color: widget.isSelected ? AppTheme.primaryBlue : AppTheme.secondaryNavy,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.org.name as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: widget.isSelected ? AppTheme.primaryBlue : AppTheme.secondaryNavy,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.isSelected ? 'Current organization' : 'Switch to this organization',
                      style: TextStyle(
                        fontSize: 11,
                        color: widget.isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
                        fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSlide(
                offset: (_isHovered && !widget.isSelected && !isReducedMotion)
                    ? const Offset(0.15, 0)
                    : Offset.zero,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  widget.isSelected ? Icons.check_rounded : Icons.east_rounded,
                  color: widget.isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
