import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep.clamp(0, 4);

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
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Discard Changes?'),
            content: Text(
                'Are you sure you want to leave the builder? Unsaved progress will be lost.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('Cancel')),
              TextButton(
                onPressed: () {
                  ref.read(draftEventProvider(orgId).notifier).reset();
                  Navigator.pop(ctx, true);
                },
                child: Text('Leave',
                    style: TextStyle(color: AppTheme.error)),
              ),
            ],
          ),
        );
        if (confirm == true && context.mounted) {
          // Not Navigator.pop(): canPop is pinned to false above, so a pop
          // here would just re-trigger this same guard (this screen is also
          // always reached via context.go(), never pushed, so there would be
          // nothing on the Navigator stack to pop to anyway). Navigate away
          // directly instead, exactly like the manual back button does.
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/admin/events');
          }
        }
      },
      child: Scaffold(
        backgroundColor: KivoraColors.backgroundOf(context),
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
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/admin/events');
                          }
                        },
                      ),
                      SizedBox(width: 8),
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
                  SizedBox(height: 20),
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
                            title: Text('Basic Info'),
                            content: BasicInfoStep(
                                orgId: orgId, onNext: () => setState(() => _currentStep = 1)),
                            isActive: _currentStep >= 0,
                            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                          ),
                          Step(
                            title: Text('Schedule'),
                            content: ScheduleStep(
                                orgId: orgId,
                                onNext: () => setState(() => _currentStep = 2),
                                onBack: () => setState(() => _currentStep = 0)),
                            isActive: _currentStep >= 1,
                            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                          ),
                          Step(
                            title: Text('Eligibility'),
                            content: EligibilityStep(
                                orgId: orgId,
                                onNext: () => setState(() => _currentStep = 3),
                                onBack: () => setState(() => _currentStep = 1)),
                            isActive: _currentStep >= 2,
                            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                          ),
                          Step(
                            title: Text('Choices'),
                            content: draftState.serverEventId == null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    child: Column(
                                      children: [
                                        Text(
                                            'Please complete the Eligibility step and tap "Create Draft & Continue" first.'),
                                        SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final success = await ref
                                                .read(draftEventProvider(orgId).notifier)
                                                .createServerDraft();
                                            if (!mounted) return;
                                            if (success) {
                                              setState(() {});
                                            } else {
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
                                          child: Text('Create Draft Now'),
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
                            title: Text('Review'),
                            content: draftState.serverEventId == null
                                ? Center(child: Text('Create Draft first.'))
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
