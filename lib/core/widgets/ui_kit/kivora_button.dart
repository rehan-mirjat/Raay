import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum KivoraButtonType { primary, secondary, ghost, destructive }

class KivoraButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final KivoraButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  const KivoraButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = KivoraButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;
    BorderSide? border;

    switch (type) {
      case KivoraButtonType.primary:
        bg = AppTheme.primaryBlue;
        fg = Colors.white;
        break;
      case KivoraButtonType.secondary:
        bg = isDark ? AppTheme.darkElevated : AppTheme.surfaceWhite;
        fg = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
        border = BorderSide(
          color: isDark ? AppTheme.darkBorder : AppTheme.borderLight,
          width: 1.2,
        );
        break;
      case KivoraButtonType.ghost:
        bg = Colors.transparent;
        fg = AppTheme.primaryBlue;
        break;
      case KivoraButtonType.destructive:
        bg = AppTheme.error.withValues(alpha: 0.1);
        fg = AppTheme.error;
        border = BorderSide(color: AppTheme.error.withValues(alpha: 0.3));
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
            margin: const EdgeInsets.only(right: 12),
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(icon, size: 20),
          ),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: content,
    );
  }
}
