import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/exit_guard.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../../../core/layout/responsive.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../organizations/domain/organization_enums.dart';
import '../../../organizations/presentation/providers/organization_providers.dart';
import '../../data/voting_event_repository.dart';
import '../providers/draft_event_provider.dart';

import 'basic_info_step.dart';
import 'schedule_step.dart';
import 'eligibility_step.dart';
import 'choices_step.dart';
import 'review_step.dart';

class EventBuilderScreen extends ConsumerStatefulWidget {
  final String? existingEventId;
  final int initialStep;
  const EventBuilderScreen(
      {super.key, this.existingEventId, this.initialStep = 0});

  @override
  ConsumerState<EventBuilderScreen> createState() => _EventBuilderScreenState();
}

class _EventBuilderScreenState extends ConsumerState<EventBuilderScreen> {
  int _currentStep = 0;
  String? _loadingEventId;
  String? _orgIdForGuard;
  late final ExitGuardNotifier _guardRegistry;
  late final ExitGuard _guard;

  /// Single exit path for system back, the on-screen back button and shell
  /// navigation (via [exitGuardProvider]). Nothing unsaved -> leave silently.
  Future<bool> _confirmLeave() async {
    final orgId = _orgIdForGuard;
    if (orgId == null) return true;
    if (!ref.read(draftEventProvider(orgId).notifier).hasUnsavedChanges) return true;
    final l10n = AppLocalizations.of(context);
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.builderLeaveTitle),
        content: Text(l10n.builderLeaveBody),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.builderStay),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: KivoraColors.of(ctx).errorText),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.builderLeave),
          ),
        ],
      ),
    );
    return leave == true;
  }

  Future<void> _leave() async {
    if (!await _confirmLeave() || !mounted) return;
    final orgId = _orgIdForGuard;
    if (orgId != null) ref.read(draftEventProvider(orgId).notifier).reset();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/admin/events');
    }
  }

  @override
  void dispose() {
    final registry = _guardRegistry;
    final guard = _guard;
    // The registry notifies listeners; do not do that while the tree is locked.
    Future.microtask(() => registry.unregister(guard));
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep.clamp(0, 4);
    _guardRegistry = ref.read(exitGuardProvider.notifier);
    _guard = _confirmLeave;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _guardRegistry.register(_guard);
    });

    // If creating a NEW event (no existingEventId provided), reset any leftover draft
    if (widget.existingEventId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final activeOrgContext = ref.read(activeOrganizationContextProvider).valueOrNull?.context;
        if (activeOrgContext != null) {
          ref.read(draftEventProvider(activeOrgContext.organization.id).notifier).reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeContextState = ref.watch(activeOrganizationContextProvider);
    final orgContext = activeContextState.valueOrNull?.context;

    if (orgContext == null) {
      return const Scaffold(
        body: ErrorView(
          type: ErrorViewType.organizationRequired,
          message: 'Choose an organization to create or manage voting events.',
        ),
      );
    }

    final orgId = orgContext.organization.id;
    _orgIdForGuard = orgId;
    final role = orgContext.member.role;

    if (widget.existingEventId != null &&
        ref.watch(draftEventProvider(orgId)).serverEventId !=
            widget.existingEventId) {
      if (_loadingEventId != widget.existingEventId) {
        _loadingEventId = widget.existingEventId;
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _loadExistingEvent(orgId));
      }
      return const Scaffold(body: LoadingView(message: 'Loading event draft…'));
    }

    if (!role.isAdmin) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Unauthorized: Admins only.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Return Home'),
              ),
            ],
          ),
        ),
      );
    }

    final draftState = ref.watch(draftEventProvider(orgId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _leave();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1140),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_rounded, color: KivoraColors.textPrimaryOf(context)),
                        onPressed: _leave,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        draftState.serverEventId != null
                            ? 'Edit Event Draft'
                            : 'Create Voting Event',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: KivoraColors.textPrimaryOf(context),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: AppTheme.primaryBlue,
                            ),
                      ),
                      child: Stepper(
                        physics: const ClampingScrollPhysics(),
                        elevation: 0,
                        type: ResponsiveLayout.isWide(context)
                            ? StepperType.horizontal
                            : StepperType.vertical,
                        currentStep: _currentStep,
                        onStepTapped: (step) {
                          _handleStepTap(step, orgId, draftState.serverEventId);
                        },
                        controlsBuilder: (context, details) =>
                            const SizedBox.shrink(), // Custom controls in each step
                        steps: [
                          Step(
                            title: const Text('Basic Info'),
                            content: BasicInfoStep(
                                orgId: orgId, onNext: () => setState(() => _currentStep = 1)),
                            isActive: _currentStep >= 0,
                            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                          ),
                          Step(
                            title: const Text('Schedule'),
                            content: ScheduleStep(
                                orgId: orgId,
                                onNext: () => setState(() => _currentStep = 2),
                                onBack: () => setState(() => _currentStep = 0)),
                            isActive: _currentStep >= 1,
                            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                          ),
                          Step(
                            title: const Text('Eligibility'),
                            content: EligibilityStep(
                                orgId: orgId,
                                onNext: () => setState(() => _currentStep = 3),
                                onBack: () => setState(() => _currentStep = 1)),
                            isActive: _currentStep >= 2,
                            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                          ),
                          Step(
                            title: const Text('Choices'),
                            content: draftState.serverEventId == null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    child: Column(
                                      children: [
                                        const Text(
                                            'Please complete the Eligibility step and tap "Create Draft & Continue" first.'),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final success = await ref
                                                .read(draftEventProvider(orgId).notifier)
                                                .createServerDraft();
                                            if (!mounted) return;
                                            if (success) {
                                              setState(() {});
                                            } else {
                                              if (!context.mounted) return;
                                              final error = ref
                                                  .read(draftEventProvider(orgId))
                                                  .error;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(error ??
                                                      'Could not create draft. Please try again.'),
                                                  backgroundColor: AppTheme.error,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Create Draft Now'),
                                        ),
                                      ],
                                    ),
                                  )
                                : ChoicesStep(
                                    orgId: orgId,
                                    onNext: () => setState(() => _currentStep = 4),
                                    onBack: () => setState(() => _currentStep = 2)),
                            isActive: _currentStep >= 3,
                            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                          ),
                          Step(
                            title: const Text('Review'),
                            content: draftState.serverEventId == null
                                ? const Center(child: Text('Create Draft first.'))
                                : ReviewStep(
                                    orgId: orgId,
                                    onBack: () => setState(() => _currentStep = 3)),
                            isActive: _currentStep >= 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleStepTap(
      int step, String organizationId, String? serverEventId) async {
    if (ref.read(draftEventProvider(organizationId)).isLoading) return;

    if (step <= _currentStep) {
      setState(() => _currentStep = step);
      return;
    }

    if (serverEventId == null) {
      // Basic Info and Schedule must be completed with their own Continue
      // buttons. From Eligibility, tapping Choices is also a valid Continue
      // action: EligibilityStep keeps its current selections in the draft
      // provider, then the server draft is created before opening Choices.
      if (_currentStep != 2 || step != 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Complete each step with its Continue button before moving ahead.'),
            backgroundColor: AppTheme.warning,
          ),
        );
        return;
      }

      final created = await ref
          .read(draftEventProvider(organizationId).notifier)
          .createServerDraft();
      if (!mounted || !created) return;
    }

    if (mounted) setState(() => _currentStep = step);
  }

  Future<void> _loadExistingEvent(String organizationId) async {
    if (!mounted || widget.existingEventId == null) return;
    try {
      final loadedEvent = await ref
          .read(votingEventRepositoryProvider)
          .watchVotingEvent(widget.existingEventId!)
          .first;
      if (!mounted) return;
      if (loadedEvent == null) throw StateError('Event not found.');
      final event = loadedEvent;
      if (event.organizationId != organizationId) {
        throw Exception('This event belongs to a different organization.');
      }
      ref
          .read(draftEventProvider(organizationId).notifier)
          .loadExistingDraft(event);
      setState(() => _currentStep = widget.initialStep.clamp(0, 4).toInt());
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not load this event: $error')));
        Navigator.of(context).maybePop();
      }
    }
  }
}
