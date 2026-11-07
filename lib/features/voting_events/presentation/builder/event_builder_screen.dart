import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/exit_guard.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/raay_colors.dart';
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
                foregroundColor: RaayColors.of(ctx).errorText),
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
      return Scaffold(body: LoadingView(message: AppLocalizations.of(context).builderLoadingDraft));
    }

    if (!role.isAdmin) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).builderAdminsOnly),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text(AppLocalizations.of(context).builderReturnHome),
              ),
            ],
          ),
        ),
      );
    }

    final draftState = ref.watch(draftEventProvider(orgId));
    final l10n = AppLocalizations.of(context);
    final kc = RaayColors.of(context);
    final isWide = !ResponsiveLayout.isCompact(context);
    final labels = [
      l10n.builderStepBasic,
      l10n.builderStepSchedule,
      l10n.builderStepEligibility,
      l10n.builderStepChoices,
      l10n.builderStepReview,
    ];

    final title = Row(
      children: [
        IconButton(
          tooltip: l10n.builderBack,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          icon: Icon(Icons.arrow_back_rounded, color: kc.textPrimary),
          onPressed: _leave,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              draftState.serverEventId != null ? l10n.builderEditTitle : l10n.builderCreateTitle,
              style: TextStyle(fontSize: isWide ? 28 : 22, fontWeight: FontWeight.bold, color: kc.textPrimary),
            ),
          ),
        ),
      ],
    );

    final stepBody = KeyedSubtree(
      key: ValueKey(_currentStep),
      child: _stepContent(context, l10n, orgId, draftState),
    );

    final Widget body = isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 220,
                child: Semantics(
                  container: true,
                  label: l10n.builderStepsLabel,
                  child: Column(
                    children: [
                      for (var i = 0; i < labels.length; i++)
                        _StepTile(
                          index: i,
                          label: labels[i],
                          current: i == _currentStep,
                          done: i < _currentStep,
                          onTap: () => _handleStepTap(i, orgId, draftState.serverEventId),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxFormWidth),
                    child: stepBody,
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                liveRegion: true,
                child: Text(
                  '${l10n.builderStepOf(_currentStep + 1, labels.length)} · ${labels[_currentStep]}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kc.accentText),
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentStep + 1) / labels.length,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 16),
              Expanded(child: SingleChildScrollView(child: stepBody)),
            ],
          );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _leave();
      },
      child: Scaffold(
        backgroundColor: RaayColors.backgroundOf(context),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16, vertical: isWide ? 24 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [title, const SizedBox(height: 16), Expanded(child: body)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepContent(BuildContext context, AppLocalizations l10n, String orgId, DraftEventState draftState) {
    switch (_currentStep) {
      case 0:
        return BasicInfoStep(orgId: orgId, onNext: () => setState(() => _currentStep = 1));
      case 1:
        return ScheduleStep(
            orgId: orgId,
            onNext: () => setState(() => _currentStep = 2),
            onBack: () => setState(() => _currentStep = 0));
      case 2:
        return EligibilityStep(
            orgId: orgId,
            onNext: () => setState(() => _currentStep = 3),
            onBack: () => setState(() => _currentStep = 1));
      case 3:
        if (draftState.serverEventId == null) {
          return _DraftRequired(
            message: l10n.builderDraftNeeded,
            buttonLabel: l10n.builderCreateDraftNow,
            onPressed: () async {
              final success = await ref.read(draftEventProvider(orgId).notifier).createServerDraft();
              if (!mounted || !context.mounted) return;
              if (success) {
                setState(() {});
              } else {
                final error = ref.read(draftEventProvider(orgId)).error;
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error ?? l10n.builderCreateDraftFailed)));
              }
            },
          );
        }
        return ChoicesStep(
            orgId: orgId,
            onNext: () => setState(() => _currentStep = 4),
            onBack: () => setState(() => _currentStep = 2));
      default:
        if (draftState.serverEventId == null) {
          return _DraftRequired(message: l10n.builderDraftNeeded);
        }
        return ReviewStep(orgId: orgId, onBack: () => setState(() => _currentStep = 3));
    }
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
          SnackBar(content: Text(AppLocalizations.of(context).builderStepBlocked)),
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
            const SnackBar(content: Text('We could not load this election. Please try again.')));
        Navigator.of(context).maybePop();
      }
    }
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.index,
    required this.label,
    required this.current,
    required this.done,
    required this.onTap,
  });
  final int index;
  final String label;
  final bool current;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Semantics(
        button: true,
        selected: current,
        label: label,
        child: ExcludeSemantics(
          child: Material(
            color: current ? primary.withValues(alpha: kc.isDark ? 0.16 : 0.10) : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusInput),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radiusInput),
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        done ? Icons.check_circle_rounded : Icons.circle_outlined,
                        size: 20,
                        color: done ? kc.successText : (current ? kc.accentText : kc.textSecondary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${index + 1}. $label',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: current ? FontWeight.w700 : FontWeight.w500,
                            color: current ? kc.accentText : kc.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DraftRequired extends StatelessWidget {
  const _DraftRequired({required this.message, this.buttonLabel, this.onPressed});
  final String message;
  final String? buttonLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          if (buttonLabel != null) ...[
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: onPressed,
              child: Text(buttonLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
