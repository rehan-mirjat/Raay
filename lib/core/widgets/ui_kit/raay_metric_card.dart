import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/raay_colors.dart';

class RaayMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color? iconColor;
  final Color? iconBgColor;

  const RaayMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final isDark = kc.isDark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kc.elevated,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
            color: isDark ? AppTheme.darkBorder : AppTheme.borderLight,
            width: 1),
        boxShadow: AppTheme.cardShadow(dark: isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor ??
                      (iconColor ?? AppTheme.primaryBlue)
                          .withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? AppTheme.primaryBlue,
                ),
              ),
              if (subtitle != null) ...[
                const Expanded(child: SizedBox()),
                Flexible(
                    child: Text(
                  subtitle!,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kc.textSecondary,
                  ),
                )),
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
      ),
    );
  }
}
