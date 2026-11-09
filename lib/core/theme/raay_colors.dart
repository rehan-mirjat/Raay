import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Theme-context-aware color accessors.
/// Usage: RaayColors.of(context).surface
class RaayColors {
  RaayColors._(this._isDark, this._isHighContrast);

  final bool _isDark;
  final bool _isHighContrast;

  factory RaayColors.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHighContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    return RaayColors._(isDark, isHighContrast);
  }

  // Surfaces & Backgrounds
  Color get background =>
      _isDark ? AppTheme.darkBackground : AppTheme.backgroundLight;

  Color get surface => _isDark ? AppTheme.darkSurface : AppTheme.surfaceWhite;

  Color get elevated =>
      _isDark ? AppTheme.darkElevated : AppTheme.surfaceWhite;

  Color get border {
    if (_isHighContrast) {
      return _isDark ? Colors.white : Colors.black;
    }
    return _isDark ? AppTheme.darkBorder : AppTheme.borderLight;
  }

  Color get subtleBorder {
    if (_isHighContrast) {
      return _isDark ? Colors.white70 : Colors.black87;
    }
    return _isDark
        ? AppTheme.darkBorder.withValues(alpha: 0.6)
        : AppTheme.borderLight.withValues(alpha: 0.7);
  }

  // Text Hierarchy
  Color get textPrimary =>
      _isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;

  Color get textSecondary {
    if (_isHighContrast) {
      return _isDark ? Colors.white : Colors.black;
    }
    return _isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary;
  }

  Color get textMuted {
    if (_isHighContrast) {
      return _isDark ? const Color(0xFFE2E7F0) : const Color(0xFF354158);
    }
    return _isDark ? AppTheme.darkTextMuted : AppTheme.textMuted;
  }

  // Brand Tokens
  Color get brandNavy => AppTheme.primaryNavy;
  Color get brandSlate => AppTheme.primarySlate;
  Color get brandEmerald => AppTheme.accentEmerald;
  Color get brandTeal => AppTheme.accentTeal;

  Color get surfaceTint =>
      _isDark
          ? AppTheme.primaryBlue.withValues(alpha: 0.12)
          : AppTheme.surfaceBlue;

  /// Text/link/selected-state accent. Use this (not [AppTheme.primaryBlue])
  /// for violet TEXT or thin icons: primaryBlue fails contrast on dark surfaces.
  Color get accentText =>
      _isDark ? AppTheme.accentTextDark : AppTheme.accentTextLight;

  // Status Colors (Accessible Text)
  Color get successText =>
      _isDark ? AppTheme.successTextDark : AppTheme.successTextLight;
  Color get warningText =>
      _isDark ? AppTheme.warningTextDark : AppTheme.warningTextLight;
  Color get errorText =>
      _isDark ? AppTheme.errorTextDark : AppTheme.errorTextLight;
  Color get infoText =>
      _isDark ? AppTheme.infoTextDark : AppTheme.infoTextLight;

  // Status Solid Fills
  Color get success =>
      _isDark ? AppTheme.successTextDark : AppTheme.success;
  Color get warning =>
      _isDark ? AppTheme.warningTextDark : AppTheme.warning;
  Color get error =>
      _isDark ? AppTheme.errorTextDark : AppTheme.error;
  Color get info =>
      _isDark ? AppTheme.infoTextDark : AppTheme.accentCyan;

  // Status Background Tints
  Color get successBg =>
      (_isDark ? AppTheme.successTextDark : AppTheme.success)
          .withValues(alpha: _isDark ? 0.16 : 0.10);

  Color get warningBg =>
      (_isDark ? AppTheme.warningTextDark : AppTheme.warning)
          .withValues(alpha: _isDark ? 0.16 : 0.10);

  Color get errorBg =>
      (_isDark ? AppTheme.errorTextDark : AppTheme.error)
          .withValues(alpha: _isDark ? 0.16 : 0.10);

  Color get infoBg =>
      (_isDark ? AppTheme.infoTextDark : AppTheme.infoTextLight)
          .withValues(alpha: _isDark ? 0.16 : 0.10);

  // Status Border Tints
  Color get successBorder =>
      (_isDark ? AppTheme.successTextDark : AppTheme.success)
          .withValues(alpha: _isDark ? 0.35 : 0.25);

  Color get warningBorder =>
      (_isDark ? AppTheme.warningTextDark : AppTheme.warning)
          .withValues(alpha: _isDark ? 0.35 : 0.25);

  Color get errorBorder =>
      (_isDark ? AppTheme.errorTextDark : AppTheme.error)
          .withValues(alpha: _isDark ? 0.35 : 0.25);

  Color get infoBorder =>
      (_isDark ? AppTheme.infoTextDark : AppTheme.infoTextLight)
          .withValues(alpha: _isDark ? 0.35 : 0.25);

  bool get isDark => _isDark;
  bool get isHighContrast => _isHighContrast;

  static Color textPrimaryOf(BuildContext ctx) => RaayColors.of(ctx).textPrimary;
  static Color textSecondaryOf(BuildContext ctx) => RaayColors.of(ctx).textSecondary;
  static Color textMutedOf(BuildContext ctx) => RaayColors.of(ctx).textMuted;
  static Color surfaceOf(BuildContext ctx) => RaayColors.of(ctx).surface;
  static Color elevatedOf(BuildContext ctx) => RaayColors.of(ctx).elevated;
  static Color borderOf(BuildContext ctx) => RaayColors.of(ctx).border;
  static Color subtleBorderOf(BuildContext ctx) => RaayColors.of(ctx).subtleBorder;
  static Color backgroundOf(BuildContext ctx) => RaayColors.of(ctx).background;
}
