import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Accessibility Helper ─────────────────────────────────────────────────────

/// Returns true if reduced motion is requested via system accessibility
/// or the Raay user preference (layered into MediaQuery at the app root).
bool _reduceMotion(BuildContext context) =>
    MediaQuery.maybeOf(context)?.disableAnimations ?? false;

// ─── Page route transitions ───────────────────────────────────────────────────

/// Fade + upward-slide page entry. Use as GoRouter's pageBuilder.
/// Respects accessibility reduced-motion settings.
class RaayFadeSlideRoute<T> extends PageRouteBuilder<T> {
  RaayFadeSlideRoute({required WidgetBuilder builder, super.settings})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (_reduceMotion(context)) {
              return child;
            }
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));
            return FadeTransition(
              opacity: fade,
              child: SlideTransition(position: slide, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 220),
          reverseTransitionDuration: const Duration(milliseconds: 180),
        );
}

// ─── Animated page entry widget ───────────────────────────────────────────────

/// Wraps any screen content in a fade + upward-slide entry.
/// Drop it at the top of each screen's build() body.
/// Instantly renders child without animation when reduced motion is preferred.
class PageEntry extends StatefulWidget {
  const PageEntry({super.key, required this.child, this.delay = Duration.zero});
  final Widget child;
  final Duration delay;

  @override
  State<PageEntry> createState() => _PageEntryState();
}

class _PageEntryState extends State<PageEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    if (widget.delay == Duration.zero) {
      _ctrl.forward();
    } else {
      _delayTimer = Timer(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion(context)) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ─── Staggered list entry ─────────────────────────────────────────────────────

/// Animates a list item in with a progressive delay based on [index].
/// Automatically capped so deep lists remain snappy (<300ms max stagger).
/// Skips animation when reduced motion is requested.
class StaggeredListItem extends StatefulWidget {
  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = const Duration(milliseconds: 35),
  });
  final int index;
  final Widget child;
  final Duration baseDelay;

  @override
  State<StaggeredListItem> createState() => _StaggeredListItemState();
}

class _StaggeredListItemState extends State<StaggeredListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Cap at 8 items worth of stagger so long lists don't feel slow
    final delay = widget.baseDelay * (widget.index.clamp(0, 8));
    if (delay == Duration.zero) {
      _ctrl.forward();
    } else {
      _timer = Timer(delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion(context)) {
      return widget.child;
    }
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ─── Press-scale button wrapper ───────────────────────────────────────────────

/// Wraps interactive widgets with a subtle (scale 0.97) tactile compression
/// and responsive (<100ms) spring release with gentle haptic feedback.
/// Disables scale animation when reduced motion is preferred.
class PressScaleWidget extends StatefulWidget {
  const PressScaleWidget({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
  });
  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  State<PressScaleWidget> createState() => _PressScaleWidgetState();
}

class _PressScaleWidgetState extends State<PressScaleWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
      reverseDuration: const Duration(milliseconds: 90),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.scale).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _triggerHaptic() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) {
      return widget.child;
    }

    if (_reduceMotion(context)) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _triggerHaptic();
          widget.onTap?.call();
        },
        child: widget.child,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) async {
        _triggerHaptic();
        await Future.delayed(const Duration(milliseconds: 40));
        if (mounted) {
          _ctrl.reverse();
          widget.onTap?.call();
        }
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ─── Hover-lift card wrapper ──────────────────────────────────────────────────

/// Wraps a card and elevates + lifts it slightly on hover (desktop/web).
/// Provides smooth 60fps micro-elevation while honoring reduced motion preferences.
class HoverLiftCard extends StatefulWidget {
  const HoverLiftCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 16.0,
  });
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _elevation;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _elevation = Tween<double>(begin: 0, end: 5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.008))
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCursor = widget.onTap != null
        ? SystemMouseCursors.click
        : MouseCursor.defer;

    if (_reduceMotion(context)) {
      return MouseRegion(
        cursor: effectiveCursor,
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.child,
        ),
      );
    }

    return MouseRegion(
      cursor: effectiveCursor,
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => SlideTransition(
            position: _offset,
            child: Material(
              elevation: _elevation.value,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: Colors.transparent,
              shadowColor: Colors.black.withValues(alpha: 0.12),
              child: child,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
