import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/kivora_colors.dart';
import '../glass/glass.dart';

class KivoraCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
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
    if (isGlass) {
      return GlassSurface(margin: margin, child: content);
    }
    final colors = KivoraColors.of(context);
    return Container(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.elevated,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: colors.border),
      ),
      child: content,
    );
  }
}
