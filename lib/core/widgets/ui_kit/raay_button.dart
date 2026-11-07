import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/raay_colors.dart';

enum RaayButtonType { primary, secondary, ghost, destructive }

class RaayButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final RaayButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  const RaayButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = RaayButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = RaayColors.of(context);

    Color bg;
    Color fg;
    BorderSide? border;

    switch (type) {
      case RaayButtonType.primary:
        bg = Theme.of(context).colorScheme.primary;
        fg = Theme.of(context).colorScheme.onPrimary;
        break;
      case RaayButtonType.secondary:
        bg = isDark ? AppTheme.darkElevated : AppTheme.surfaceWhite;
        fg = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
        border = BorderSide(
          color: isDark ? AppTheme.darkBorder : AppTheme.borderLight,
          width: 1.2,
        );
        break;
      case RaayButtonType.ghost:
        bg = Colors.transparent;
        fg = colors.accentText;
        break;
      case RaayButtonType.destructive:
        bg = colors.errorText.withValues(alpha: 0.1);
        fg = colors.errorText;
        border = BorderSide(color: colors.errorText.withValues(alpha: 0.5));
        break;
    }

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      shadowColor: Colors.transparent,
      disabledBackgroundColor: bg.withValues(alpha: 0.5),
      disabledForegroundColor: fg.withValues(alpha: 0.5),
      minimumSize: Size(isExpanded ? double.infinity : 0, 50),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        side: border ?? BorderSide.none,
      ),
    );

    Widget content = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsetsDirectional.only(end: 12),
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: Icon(icon, size: 20),
          ),
        Flexible(
            child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        )),
      ],
    );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: content,
    );
  }
}
