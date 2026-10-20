import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Frosted-glass surface: blurred backdrop, translucent gradient fill and a
/// luminous hairline border. Works in light and dark mode.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius = AppTheme.radiusCard,
    this.padding,
    this.margin,
    this.blur = 18,
    this.opacity,
    this.tint,
    this.glow = false,
    this.shadow = true,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;

  /// Overrides the default fill strength (0..1).
  final double? opacity;

  /// Optional accent that tints the glass (e.g. selected / highlighted).
  final Color? tint;

  /// Adds a soft accent glow around the surface.
  final bool glow;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(borderRadius);
    final base = isDark ? Colors.white : Colors.white;
    final strength = opacity ?? (isDark ? 0.07 : 0.62);

    final fillTop = base.withValues(alpha: strength + (isDark ? 0.04 : 0.12));
    final fillBottom = base.withValues(alpha: strength);
    final accent = tint ?? AppTheme.primaryBlue;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          if (shadow)
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          if (glow)
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.35 : 0.22),
              blurRadius: 24,
              spreadRadius: -2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tint != null
                      ? Color.alphaBlend(
                          accent.withValues(alpha: isDark ? 0.16 : 0.10),
                          fillTop)
                      : fillTop,
                  fillBottom,
                ],
              ),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.14)
                    : Colors.white.withValues(alpha: 0.85),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Ambient futuristic backdrop: deep gradient with soft glowing orbs that the
/// glass surfaces blur against. Placed once, behind the whole app.
class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradient = isDark
        ? const [Color(0xFF070B1A), Color(0xFF0E1230), Color(0xFF120D2B)]
        : const [Color(0xFFEFF1FF), Color(0xFFF6F0FF), Color(0xFFEAF4FF)];

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
        ),
        _Orb(
          alignment: const Alignment(-1.1, -0.9),
          color: AppTheme.primaryBlue,
          size: 360,
          opacity: isDark ? 0.32 : 0.22,
        ),
        _Orb(
          alignment: const Alignment(1.2, -0.2),
          color: const Color(0xFF3284FF),
          size: 320,
          opacity: isDark ? 0.26 : 0.18,
        ),
        _Orb(
          alignment: const Alignment(-0.6, 1.2),
          color: const Color(0xFF14B8A6),
          size: 300,
          opacity: isDark ? 0.18 : 0.14,
        ),
        child,
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.alignment,
    required this.color,
    required this.size,
    required this.opacity,
  });

  final Alignment alignment;
  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withValues(alpha: opacity), color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}
