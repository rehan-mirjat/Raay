import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/raay_colors.dart';

/// Raay Design System Card component.
///
/// Features high-DPI crisp rendering, semantic surface tokens, subtle borders,
/// elevation layers, and smooth anti-aliased rounded corners (12px - 16px).
class RaayCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;

  /// Emphasized card (e.g. current plan / featured card): accent border.
  final bool isGlass;

  /// Whether to use the elevated surface background token.
  final bool isElevated;

  /// Optional custom background color; defaults to [RaayColors.surface] (or [RaayColors.elevated]).
  final Color? color;

  /// Optional custom border color; defaults to [RaayColors.border] (or [RaayColors.accentText] if [isGlass]).
  final Color? borderColor;

  /// Optional border width in logical pixels. Defaults to 1.5 if [isGlass] else 1.0.
  final double? borderWidth;

  /// Optional border radius; defaults to [AppTheme.radiusCard] (14.0).
  final BorderRadiusGeometry? borderRadius;

  /// Custom box shadow; defaults to [AppTheme.cardShadow].
  final List<BoxShadow>? boxShadow;

  /// Whether to use subtle border opacity for subdued card containers.
  final bool subtleBorder;

  const RaayCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.isGlass = false,
    this.isElevated = false,
    this.color,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.boxShadow,
    this.subtleBorder = false,
  });

  @override
  State<RaayCard> createState() => _RaayCardState();
}

class _RaayCardState extends State<RaayCard> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = RaayColors.of(context);
    final effectiveRadius = widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusCard);
    final effectiveBg = widget.color ?? (widget.isElevated ? colors.elevated : colors.surface);
    final baseBorderColor = widget.borderColor ??
        (widget.isGlass
            ? colors.accentText
            : (widget.subtleBorder ? colors.subtleBorder : colors.border));
    final baseBorderWidth = widget.borderWidth ?? (widget.isGlass ? 1.5 : 1.0);

    // Visible focus indicator (WCAG 2.4.7 & WCAG 2.2 2.4.11)
    final effectiveBorderColor = _isFocused ? colors.accentText : baseBorderColor;
    final effectiveBorderWidth = _isFocused ? 2.0 : baseBorderWidth;

    final border = BorderSide(
      color: effectiveBorderColor,
      width: effectiveBorderWidth,
      strokeAlign: BorderSide.strokeAlignInside,
    );

    Widget content = Padding(padding: widget.padding, child: widget.child);

    if (widget.onTap != null) {
      content = InkWell(
        onTap: widget.onTap,
        onFocusChange: (focused) {
          if (_isFocused != focused) {
            setState(() => _isFocused = focused);
          }
        },
        borderRadius: effectiveRadius is BorderRadius
            ? effectiveRadius
            : BorderRadius.circular(AppTheme.radiusCard),
        focusColor: colors.accentText.withValues(alpha: 0.12),
        child: content,
      );
    }

    final card = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: effectiveRadius,
        border: Border.fromBorderSide(border),
        boxShadow: widget.boxShadow ?? AppTheme.cardShadow(dark: colors.isDark),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: content,
      ),
    );

    if (widget.onTap != null) {
      return Semantics(
        button: true,
        enabled: true,
        child: card,
      );
    }

    return card;
  }
}
