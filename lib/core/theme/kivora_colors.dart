import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Theme-context-aware color accessors.
/// Usage: KivoraColors.of(context).surface
class KivoraColors {
  KivoraColors._(this._isDark);

  final bool _isDark;

  factory KivoraColors.of(BuildContext context) {
    return KivoraColors._(
      Theme.of(context).brightness == Brightness.dark,
    );
  }

  Color get background =>
      _isDark ? AppTheme.darkBackground : AppTheme.backgroundLight;

  Color get surface =>
      _isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite;

  Color get elevated =>
      _isDark ? AppTheme.darkElevated : AppTheme.surfaceWhite;

  Color get border =>
      _isDark ? AppTheme.darkBorder : AppTheme.borderLight;

  Color get textPrimary =>
      _isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;

  Color get textSecondary =>
      _isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;

  Color get surfaceTint =>
      _isDark
          ? AppTheme.primaryBlue.withValues(alpha: 0.12)
          : AppTheme.surfaceBlue;

  bool get isDark => _isDark;

  static Color textPrimaryOf(BuildContext ctx) => KivoraColors.of(ctx).textPrimary;
  static Color textSecondaryOf(BuildContext ctx) => KivoraColors.of(ctx).textSecondary;
  static Color surfaceOf(BuildContext ctx) => KivoraColors.of(ctx).surface;
  static Color elevatedOf(BuildContext ctx) => KivoraColors.of(ctx).elevated;
  static Color borderOf(BuildContext ctx) => KivoraColors.of(ctx).border;
  static Color backgroundOf(BuildContext ctx) => KivoraColors.of(ctx).background;
}
