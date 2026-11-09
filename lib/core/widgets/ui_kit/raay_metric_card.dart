import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/raay_colors.dart';

/// Raay Design System Metric Card component.
///
/// Cleanly adopts [RaayColors] semantic tokens with support for trends, icons,
/// custom badges, and crisp high-DPI borders.
class RaayMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color? iconColor;
  final Color? iconBgColor;
  final String? trend;
  final bool? isTrendPositive;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double? borderRadius;

  const RaayMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.iconBgColor,
    this.trend,
    this.isTrendPositive,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final isDark = kc.isDark;
    final effectiveRadius = borderRadius ?? AppTheme.radiusCard;

    final effectiveIconColor =
        iconColor ?? (isDark ? kc.accentText : AppTheme.primaryBlue);
    final effectiveIconBgColor = iconBgColor ??
        effectiveIconColor.withValues(alpha: isDark ? 0.20 : 0.10);

    Widget cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: effectiveIconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: effectiveIconColor,
              ),
            ),
            if (trend != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isTrendPositive == true
                      ? kc.successBg
                      : (isTrendPositive == false
                          ? kc.errorBg
                          : kc.subtleBorder),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trend!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isTrendPositive == true
                        ? kc.successText
                        : (isTrendPositive == false
                            ? kc.errorText
                            : kc.textMuted),
                  ),
                ),
              ),
            ] else if (subtitle != null) ...[
              const Spacer(),
              Flexible(
                child: Text(
                  subtitle!,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kc.textMuted,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kc.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: kc.textSecondary,
          ),
        ),
      ],
    );

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: Padding(padding: padding, child: cardContent),
      );
    } else {
      cardContent = Padding(padding: padding, child: cardContent);
    }

    return Container(
      decoration: BoxDecoration(
        color: kc.elevated,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: Border.all(
          color: kc.border,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        boxShadow: AppTheme.cardShadow(dark: isDark),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: cardContent,
      ),
    );
  }
}
