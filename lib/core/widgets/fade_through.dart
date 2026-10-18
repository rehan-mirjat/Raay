import 'package:flutter/material.dart';

/// Crossfades between states (loading/error/data) instead of the abrupt
/// instant swap every `.when()`/`StreamBuilder`/`FutureBuilder` branch
/// produces by default. [stateKey] identifies which state [child] belongs
/// to - pass something stable per state (e.g. 'loading', 'data:$id') so
/// [AnimatedSwitcher] only transitions on a genuine state change, not every
/// rebuild. Respects the user's reduce-motion setting.
class FadeThrough extends StatelessWidget {
  const FadeThrough({
    super.key,
    required this.stateKey,
    required this.child,
    this.duration = const Duration(milliseconds: 220),
  });

  final Object stateKey;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return AnimatedSwitcher(
      duration: reduceMotion ? Duration.zero : duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(key: ValueKey(stateKey), child: child),
    );
  }
}

/// A one-time fade + slight upward slide entrance for content that appears
/// once content is ready (a screen body, a list item). Plays once on first
/// build of this widget instance - give list items a per-item [index] (or
/// any other distinguishing key) so each new widget instance replays it.
/// Respects the user's reduce-motion setting.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 320),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding
            .instance.platformDispatcher.accessibilityFeatures.disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration: reduceMotion ? Duration.zero : widget.duration,
    );
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _fade = curved;
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(curved);
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
