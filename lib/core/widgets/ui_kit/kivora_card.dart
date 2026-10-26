import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/kivora_colors.dart';

class KivoraCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  /// Emphasized card (e.g. the current plan): accent border, still solid.
  /// Name kept for API compatibility; there is no glass effect.
  final bool isGlass;

  const KivoraCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.isGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Padding(padding: padding, child: child),
      ),
    );
    final colors = KivoraColors.of(context);
    return Container(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: isGlass ? colors.accentText : colors.border,
          width: isGlass ? 1.5 : 1,
        ),
        boxShadow: AppTheme.cardShadow(dark: colors.isDark),
      ),
      child: content,
    );
  }
}
