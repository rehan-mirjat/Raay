import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/onboarding_providers.dart';
import 'tour_keys.dart';

class QuickTourOverlay extends ConsumerStatefulWidget {
  const QuickTourOverlay({super.key});

  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      barrierLabel: 'Tour',
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: const QuickTourOverlay(),
        );
      },
    );
  }

  @override
  ConsumerState<QuickTourOverlay> createState() => _QuickTourOverlayState();
}

class _QuickTourOverlayState extends ConsumerState<QuickTourOverlay> {
  int _currentStep = 0;
  List<_TourStep>? _visibleSteps;

  final List<_TourStep> _allSteps = [
    _TourStep(
      key: TourKeys.organizationKey,
      title: 'Organization',
      description:
          'Your organization is your workspace. Members, departments, events, and organization settings are managed here.',
    ),
    _TourStep(
      key: TourKeys.directoryKey,
      title: 'Directory',
      description:
          'Manage your organization members, roles, invitations, and membership status here.',
    ),
    _TourStep(
      key: TourKeys.departmentsKey,
      title: 'Departments',
      description:
          'Organize members into departments and manage your organization\'s structure.',
    ),
    _TourStep(
      key: TourKeys.eventsKey,
      title: 'Events',
      description:
          'Create and manage voting events for eligible organization members.',
    ),
    _TourStep(
      key: TourKeys.profileKey,
      title: 'Account',
      description:
          'Manage your account, security settings, and available account actions here.',
    ),
  ];

  Rect? _getTargetRect(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return null;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final position = box.localToGlobal(Offset.zero);
    return position & box.size;
  }

  /// Not every step's target exists for every user/screen size (e.g.
  /// Directory/Departments only render for managers), so the step list is
  /// filtered down to targets that actually resolve, computed once the first
  /// time the overlay is laid out rather than against the static full list -
  /// otherwise non-manager or mobile users would see steps pointing at
  /// nothing.
  List<_TourStep> get _steps {
    return _visibleSteps ??=
        _allSteps.where((s) => _getTargetRect(s.key) != null).toList();
  }

  void _nextStep() {
    if (_currentStep < _steps.length) {
      setState(() {
        _currentStep++;
      });
    } else {
      _close();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _close() {
    ref.read(onboardingProvider.notifier).completeTour();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep >= _steps.length) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded,
                          color: AppTheme.success, size: 40),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'You\'re ready to go!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryNavy),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Kivora is set up for you.\n\nStart by creating an organization, joining an organization, or exploring your workspace.',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _close,
                        style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue),
                        child: const Text('Get Started \u2192'),
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

    final step = _steps[_currentStep];
    final rect = _getTargetRect(step.key);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child:
                CustomPaint(painter: _SpotlightPainter(rect: rect?.inflate(8))),
          ),
          if (rect != null)
            Positioned.fromRect(
              rect: rect.inflate(8),
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppTheme.primaryBlue, width: 2.5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: rect != null
                ? (rect.bottom + 16)
                    .clamp(16.0, MediaQuery.of(context).size.height - 250)
                : MediaQuery.of(context).size.height / 2 - 100,
            left: rect != null
                ? (rect.left + rect.width / 2 - 160)
                    .clamp(16.0, MediaQuery.of(context).size.width - 336)
                : (MediaQuery.of(context).size.width - 320) / 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 320,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 8))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Step ${_currentStep + 1} of ${_steps.length}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue)),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: AppTheme.textSecondary),
                        onPressed: _close,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(step.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryNavy)),
                  const SizedBox(height: 8),
                  Text(step.description,
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.4)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: _prevStep,
                          child: const Text('Back'),
                        )
                      else
                        const SizedBox.shrink(),
                      FilledButton(
                        onPressed: _nextStep,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primaryBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text('Next \u2192'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TourStep {
  final GlobalKey key;
  final String title;
  final String description;

  _TourStep(
      {required this.key, required this.title, required this.description});
}

class _SpotlightPainter extends CustomPainter {
  final Rect? rect;

  _SpotlightPainter({this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x99000000);
    if (rect == null) {
      canvas.drawRect(Offset.zero & size, paint);
      return;
    }
    final screenPath = Path()..addRect(Offset.zero & size);
    final targetPath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect!, const Radius.circular(12.0)));
    final path = Path.combine(PathOperation.difference, screenPath, targetPath);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.rect != rect;
  }
}
