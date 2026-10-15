import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
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
    final eventsAsync = ref.watch(votingEventRepositoryProvider).watchOrganizationVotingEvents(orgId);

    // Calculate completions
    final hasLogo = orgContext.organization.logoUrl?.isNotEmpty == true;
    final hasMembers = (membersAsync.valueOrNull?.length ?? 0) > 1; // More than just the owner
    final hasDepartments = (departmentsAsync.valueOrNull?.length ?? 0) > 0;
    
    return StreamBuilder(
      stream: eventsAsync,
      builder: (context, snapshot) {
        final hasEvents = (snapshot.data?.length ?? 0) > 0;

        final items = [
          _ChecklistItem(title: 'Complete organization profile', isCompleted: hasLogo),
          _ChecklistItem(title: 'Add members', isCompleted: hasMembers),
          _ChecklistItem(title: 'Set up departments', isCompleted: hasDepartments),
          _ChecklistItem(title: 'Create your first voting event', isCompleted: hasEvents),
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
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Get your organization ready',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.secondaryNavy),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: AppTheme.textSecondary),
                    onPressed: () => ref.read(onboardingProvider.notifier).dismissChecklist(),
                    tooltip: 'Dismiss',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: completedCount / items.length,
                      backgroundColor: AppTheme.borderLight,
                      color: AppTheme.success,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$completedCount of ${items.length} completed',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      item.isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: item.isCompleted ? AppTheme.success : AppTheme.borderLight,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: item.isCompleted ? AppTheme.textSecondary : AppTheme.secondaryNavy,
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        );
      }
    );
  }
}

class _ChecklistItem {
  final String title;
  final bool isCompleted;
  _ChecklistItem({required this.title, required this.isCompleted});
}
