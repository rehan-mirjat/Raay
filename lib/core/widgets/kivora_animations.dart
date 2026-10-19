import 'package:flutter/material.dart';

// ─── Page route transitions ───────────────────────────────────────────────────

/// Fade + upward-slide page entry. Use as GoRouter's pageBuilder.
class KivoraFadeSlideRoute<T> extends PageRouteBuilder<T> {
  KivoraFadeSlideRoute({required WidgetBuilder builder, super.settings})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fade = CurvedAnimation(
                parent: animation, curve: Curves.easeOutCubic);
            final slide = Tween<Offset>(
                    begin: const Offset(0, 0.03), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOutCubic));
            return FadeTransition(
                opacity: fade, child: SlideTransition(position: slide, child: child));
          },
          transitionDuration: const Duration(milliseconds: 220),
          reverseTransitionDuration: const Duration(milliseconds: 180),
        );
}

// ─── Animated page entry widget ───────────────────────────────────────────────

/// Wraps any screen content in a fade + upward-slide entry.
/// Drop it at the top of each screen's build() body.
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

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    if (widget.delay == Duration.zero) {
      _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: widget.child));
}

// ─── Staggered list entry ─────────────────────────────────────────────────────

/// Animates a list item in with a delay based on [index].
class StaggeredListItem extends StatefulWidget {
  const StaggeredListItem({
    super.key,
    required this.index,
    required this.child,
    this.baseDelay = const Duration(milliseconds: 40),
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

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 240));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    // Cap at 8 items worth of stagger so long lists don't feel slow
    final delay = widget.baseDelay * (widget.index.clamp(0, 8));
    Future.delayed(delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: widget.child));
}

// ─── Press-scale button wrapper ───────────────────────────────────────────────

/// Wraps any widget and scales it down slightly on press.
class PressScaleWidget extends StatefulWidget {
  const PressScaleWidget({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.96,
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
        vsync: this, duration: const Duration(milliseconds: 80));
    _scale = Tween<double>(begin: 1.0, end: widget.scale)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 60));
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

/// Wraps a card and elevates + lifts it slightly on hover (desktop).
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
        vsync: this, duration: const Duration(milliseconds: 160));
    _elevation = Tween<double>(begin: 0, end: 6)
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
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
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
