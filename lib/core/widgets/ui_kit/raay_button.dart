import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/raay_colors.dart';

enum RaayButtonType { primary, secondary, ghost, destructive, accent }

/// Raay Design System Button component.
///
/// Implements standardized brand button hierarchy with accessible WCAG contrast,
/// loading spinner, icon placement, and crisp high-DPI rounded borders.
class RaayButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final RaayButtonType type;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isExpanded;
  final double height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const RaayButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = RaayButtonType.primary,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isExpanded = true,
    this.height = 50.0,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = RaayColors.of(context);
    final theme = Theme.of(context);

    Color bg;
    Color fg;
    BorderSide? border;

    switch (type) {
      case RaayButtonType.primary:
        bg = theme.colorScheme.primary;
        fg = theme.colorScheme.onPrimary;
        break;
      case RaayButtonType.secondary:
        bg = colors.elevated;
        fg = colors.textPrimary;
        border = BorderSide(
          color: colors.border,
          width: 1.2,
          strokeAlign: BorderSide.strokeAlignInside,
        );
        break;
      case RaayButtonType.ghost:
        bg = Colors.transparent;
        fg = colors.accentText;
        break;
      case RaayButtonType.destructive:
        bg = colors.errorBg;
        fg = colors.errorText;
        border = BorderSide(
          color: colors.errorBorder,
          width: 1.2,
          strokeAlign: BorderSide.strokeAlignInside,
        );
        break;
      case RaayButtonType.accent:
        bg = const Color(0xFF0F766E);
        fg = Colors.white;
        break;
    }

    final effectiveRadius = borderRadius ?? AppTheme.radiusButton;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      shadowColor: Colors.transparent,
      elevation: 0,
      disabledBackgroundColor: bg.withValues(alpha: 0.4),
      disabledForegroundColor: fg.withValues(alpha: 0.5),
      minimumSize: Size(isExpanded ? double.infinity : 0, height),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
    ).copyWith(
      side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colors.accentText, width: 2.0);
        }
        return border ?? BorderSide.none;
      }),
    );

    Widget content = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsetsDirectional.only(end: 10),
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              strokeCap: StrokeCap.round,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ExcludeSemantics(child: Icon(icon, size: 20, color: fg)),
          ),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        if (!isLoading && trailingIcon != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8),
            child: ExcludeSemantics(child: Icon(trailingIcon, size: 20, color: fg)),
          ),
      ],
    );

    return Semantics(
      button: true,
      enabled: !isLoading && onPressed != null,
      label: isLoading ? '$label, loading' : label,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: content,
      ),
    );
  }
}
