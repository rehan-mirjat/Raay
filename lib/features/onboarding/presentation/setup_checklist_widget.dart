import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kivora_colors.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../../departments/presentation/providers/department_providers.dart';
import '../../voting_events/data/voting_event_repository.dart';
import '../providers/onboarding_providers.dart';
import '../../organizations/presentation/membership_directory_screen.dart';

class SetupChecklistWidget extends ConsumerWidget {
  const SetupChecklistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    if (onboardingState.isChecklistDismissed) return const SizedBox.shrink();

    final activeContextState = ref.watch(activeOrganizationContextProvider);
    final orgContext = activeContextState.valueOrNull?.context;

    if (orgContext == null) return const SizedBox.shrink();

    final orgId = orgContext.organization.id;
    final isOwner = orgContext.member.role.value == 'owner';

    // Only show to owners for simplicity, or we can show a simpler one to members.
    if (!isOwner) return const SizedBox.shrink();

    final membersAsync = ref.watch(organizationMembersDirectoryProvider(orgId));
    final departmentsAsync = ref.watch(activeOrganizationDepartmentsProvider);
    // Stable provider (a stream built in build() would resubscribe each frame).
    final eventsAsync = ref.watch(
        organizationVotingEventsProvider((orgId: orgId, includeDrafts: true)));

    // Calculate completions
    final hasLogo = orgContext.organization.logoUrl?.isNotEmpty == true;
    final hasMembers =
        (membersAsync.valueOrNull?.length ?? 0) > 1; // More than just the owner
    final hasDepartments = (departmentsAsync.valueOrNull?.length ?? 0) > 0;

    {
      final hasEvents = (eventsAsync.valueOrNull?.length ?? 0) > 0;

      final items = [
        _ChecklistItem(
            title: AppLocalizations.of(context).sclProfile,
            isCompleted: hasLogo),
        _ChecklistItem(
            title: AppLocalizations.of(context).sclMembers,
            isCompleted: hasMembers),
        _ChecklistItem(
            title: AppLocalizations.of(context).sclDepts,
            isCompleted: hasDepartments),
        _ChecklistItem(
            title: AppLocalizations.of(context).sclFirst,
            isCompleted: hasEvents),
      ];

      final completedCount = items.where((i) => i.isCompleted).length;

      // If everything is completed, hide it or allow dismissal
      if (completedCount == items.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(onboardingProvider.notifier).dismissChecklist();
        });
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: KivoraColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: KivoraColors.borderOf(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).sclTitle,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context)),
                  ),
                ),
                IconButton(
                  constraints:
                      const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(Icons.close_rounded,
                      size: 20, color: KivoraColors.textSecondaryOf(context)),
                  onPressed: () =>
                      ref.read(onboardingProvider.notifier).dismissChecklist(),
                  tooltip: AppLocalizations.of(context).sclDismiss,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: [
                SizedBox(
                  width: 160,
                  child: LinearProgressIndicator(
                    value: completedCount / items.length,
                    backgroundColor: KivoraColors.borderOf(context),
                    color: KivoraColors.of(context).successText,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(
                  AppLocalizations.of(context).sclProgress(
                      completedCount.toString(), items.length.toString()),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textSecondaryOf(context)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        item.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: item.isCompleted
                            ? KivoraColors.of(context).successText
                            : KivoraColors.textSecondaryOf(context),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: item.isCompleted
                              ? KivoraColors.textSecondaryOf(context)
                              : KivoraColors.textPrimaryOf(context),
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      )),
                    ],
                  ),
                )),
          ],
        ),
      );
    }
  }
}

class _ChecklistItem {
  final String title;
  final bool isCompleted;
  _ChecklistItem({required this.title, required this.isCompleted});
}
