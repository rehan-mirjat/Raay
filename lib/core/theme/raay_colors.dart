import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Theme-context-aware color accessors.
/// Usage: RaayColors.of(context).surface
class RaayColors {
  RaayColors._(this._isDark);

  final bool _isDark;

  factory RaayColors.of(BuildContext context) {
    return RaayColors._(
      Theme.of(context).brightness == Brightness.dark,
    );
  }

  Color get background =>
      _isDark ? AppTheme.darkBackground : AppTheme.backgroundLight;

  Color get surface => _isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite;

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

  /// Text/link/selected-state accent. Use this (not [AppTheme.primaryBlue])
  /// for violet TEXT or thin icons: primaryBlue fails contrast on dark surfaces.
  Color get accentText =>
      _isDark ? AppTheme.accentTextDark : AppTheme.accentTextLight;

  Color get successText =>
      _isDark ? AppTheme.successTextDark : AppTheme.successTextLight;
  Color get warningText =>
      _isDark ? AppTheme.warningTextDark : AppTheme.warningTextLight;
  Color get errorText =>
      _isDark ? AppTheme.errorTextDark : AppTheme.errorTextLight;
  Color get infoText =>
      _isDark ? AppTheme.infoTextDark : AppTheme.infoTextLight;

  bool get isDark => _isDark;

  static Color textPrimaryOf(BuildContext ctx) => RaayColors.of(ctx).textPrimary;
  static Color textSecondaryOf(BuildContext ctx) => RaayColors.of(ctx).textSecondary;
  static Color surfaceOf(BuildContext ctx) => RaayColors.of(ctx).surface;
  static Color elevatedOf(BuildContext ctx) => RaayColors.of(ctx).elevated;
  static Color borderOf(BuildContext ctx) => RaayColors.of(ctx).border;
  static Color backgroundOf(BuildContext ctx) => RaayColors.of(ctx).background;
}
