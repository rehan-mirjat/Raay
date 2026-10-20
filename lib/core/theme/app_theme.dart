import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors ────────────────────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF7857F7);   // Kivora Violet (primary)
  static const Color primaryBlueDark = Color(0xFF6644E8);
  static const Color secondaryBlue = Color(0xFF3284FF); // Secondary Blue
  static const Color accentCyan = Color(0xFF28C8FF);    // Accent Cyan
  static const Color secondaryNavy = Color(0xFF0B1020); // Deep Midnight

  // ── Semantic Colors ──────────────────────────────────────────────────────────
  static const Color accentTeal = Color(0xFF10B981);    // Success / Verified
  static const Color accentGold = Color(0xFFF59E0B);    // Gold / Star Accent
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color identifiable = Color(0xFFBF360C);

  // ── Light Mode Surfaces ──────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF6F8FC);
  static const Color surfaceWhite = Colors.white;
  static const Color textPrimary = Color(0xFF0B1020);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color surfaceBlue = Color(0xFFEEF2FF);   // Light violet tint

  // ── Dark Mode Surfaces ───────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0B1020);
  static const Color darkSurface = Color(0xFF151B30);
  static const Color darkElevated = Color(0xFF202740);
  static const Color darkBorder = Color(0xFF2A3356);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // ── Shape Scale ──────────────────────────────────────────────────────────────
  static const double radiusButton = 14.0;
  static const double radiusInput = 14.0;
  static const double radiusCard = 20.0;
  static const double radiusDialog = 24.0;
  static const double radiusSheet = 28.0;

  // ── Gradient Helpers ─────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7857F7), Color(0xFF3284FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkHeroGradient = LinearGradient(
    colors: [Color(0xFF151B30), Color(0xFF202740)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static BoxDecoration get glassCard => BoxDecoration(
    color: darkElevated.withValues(alpha: 0.85),
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: darkBorder, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // ── Organization Branding ────────────────────────────────────────────────────
  static ThemeData withOrganizationBranding(
    ThemeData base,
    Map<String, String>? brandColors,
  ) {
    if (brandColors == null || brandColors.isEmpty) return base;
    final primary = _parseBrandColor(brandColors['primary'], primaryBlue);
    final secondary = _parseBrandColor(brandColors['secondary'], secondaryNavy);
    final accent = _parseBrandColor(brandColors['accent'], accentTeal);
    final onPrimary =
        primary.computeLuminance() > 0.55 ? Colors.black : Colors.white;
    final scheme = base.colorScheme.copyWith(
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      tertiary: accent,
    );
    return base.copyWith(
      colorScheme: scheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusButton)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(color: primary, width: 1.8),
        ),
      ),
    );
  }

  /// Package C3's "High contrast" accessibility setting. Boosts border/
  /// divider contrast and text emphasis beyond the normal theme - applied
  /// on top of (after) withOrganizationBranding so it always wins.
  static ThemeData withHighContrast(ThemeData base) {
    final isDark = base.brightness == Brightness.dark;
    final outline = isDark ? Colors.white : Colors.black;
    final scheme = base.colorScheme.copyWith(
      outline: outline.withValues(alpha: 0.87),
      outlineVariant: outline.withValues(alpha: 0.6),
    );
    return base.copyWith(
      colorScheme: scheme,
      dividerColor: outline.withValues(alpha: 0.4),
      dividerTheme: base.dividerTheme.copyWith(color: outline.withValues(alpha: 0.4)),
      textTheme: base.textTheme.apply(
        bodyColor: isDark ? Colors.white : Colors.black,
        displayColor: isDark ? Colors.white : Colors.black,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: BorderSide(color: outline.withValues(alpha: 0.6), width: 1.4),
        ),
      ),
    );
  }

  static Color _parseBrandColor(String? value, Color fallback) {
    if (value == null || !RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(value)) {
      return fallback;
    }
    return Color(int.parse(value.substring(1), radix: 16) | 0xFF000000);
  }

  // ── Light Theme ──────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
        secondary: secondaryBlue,
        tertiary: accentTeal,
        surface: backgroundLight,
        surfaceContainer: surfaceWhite,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: _buildTextTheme(isLight: true),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: _SmoothPageTransitionsBuilder(),
          TargetPlatform.macOS: _SmoothPageTransitionsBuilder(),
          TargetPlatform.windows: _SmoothPageTransitionsBuilder(),
          TargetPlatform.linux: _SmoothPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: _elevatedButtonStyle(primaryBlue, Colors.white),
      filledButtonTheme: _filledButtonStyle(primaryBlue, Colors.white),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: surfaceWhite,
          side: const BorderSide(color: borderLight, width: 1.2),
          elevation: 0,
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle:
              GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: _inputDecoration(
        fillColor: surfaceWhite,
        borderColor: borderLight,
        focusColor: primaryBlue,
        hintColor: textSecondary,
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite.withValues(alpha: 0.72),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: BorderSide(color: borderLight.withValues(alpha: 0.7), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceWhite.withValues(alpha: 0.94),
        elevation: 8,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusDialog),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceWhite,
        elevation: 12,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: borderLight,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(radiusSheet)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: secondaryNavy,
        contentTextStyle: GoogleFonts.plusJakartaSans(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusInput),
        ),
        elevation: 4,
      ),
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1.0,
        space: 1.0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceWhite,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: darkSurface,
        unselectedIconTheme: IconThemeData(color: darkTextSecondary),
        unselectedLabelTextStyle:
            TextStyle(color: darkTextSecondary, fontWeight: FontWeight.w500),
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedLabelTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        useIndicator: true,
        indicatorColor: primaryBlue,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceBlue,
        selectedColor: primaryBlue,
        labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13, fontWeight: FontWeight.w500, color: textPrimary),
        side: const BorderSide(color: borderLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        primary: primaryBlue,
        secondary: secondaryBlue,
        tertiary: accentCyan,
        surface: darkBackground,
        surfaceContainer: darkSurface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: _buildTextTheme(isLight: false),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: _SmoothPageTransitionsBuilder(),
          TargetPlatform.macOS: _SmoothPageTransitionsBuilder(),
          TargetPlatform.windows: _SmoothPageTransitionsBuilder(),
          TargetPlatform.linux: _SmoothPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: _elevatedButtonStyle(primaryBlue, Colors.white),
      filledButtonTheme: _filledButtonStyle(primaryBlue, Colors.white),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          backgroundColor: darkElevated,
          side: const BorderSide(color: darkBorder, width: 1.2),
          elevation: 0,
          minimumSize: const Size(0, 50),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusButton),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFAB98FF),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle:
              GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: _inputDecoration(
        fillColor: darkElevated,
        borderColor: darkBorder,
        focusColor: primaryBlue,
        hintColor: darkTextSecondary,
      ),
      cardTheme: CardThemeData(
        color: darkSurface.withValues(alpha: 0.62),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface.withValues(alpha: 0.92),
        elevation: 12,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusDialog),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurface,
        elevation: 16,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: darkBorder,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(radiusSheet)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkElevated,
        contentTextStyle: GoogleFonts.plusJakartaSans(
            color: darkTextPrimary, fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          side: const BorderSide(color: darkBorder),
        ),
        elevation: 4,
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1.0,
        space: 1.0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryBlue,
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: darkSurface,
        unselectedIconTheme: IconThemeData(color: darkTextSecondary),
        unselectedLabelTextStyle:
            TextStyle(color: darkTextSecondary, fontWeight: FontWeight.w500),
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedLabelTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        useIndicator: true,
        indicatorColor: primaryBlue,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkElevated,
        selectedColor: primaryBlue,
        labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: darkTextPrimary),
        side: const BorderSide(color: darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  // ── Private Helpers ──────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme({required bool isLight}) {
    final primary = isLight ? textPrimary : darkTextPrimary;
    final secondary = isLight ? textSecondary : darkTextSecondary;
    return GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
          color: primary, fontWeight: FontWeight.bold, letterSpacing: -1.0),
      displayMedium: GoogleFonts.plusJakartaSans(
          color: primary, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      displaySmall: GoogleFonts.plusJakartaSans(
          color: primary,
          fontWeight: FontWeight.bold,
          fontSize: 28,
          letterSpacing: -0.4),
      headlineLarge: GoogleFonts.plusJakartaSans(
          color: primary,
          fontWeight: FontWeight.bold,
          fontSize: 26,
          letterSpacing: -0.3,
          height: 1.2),
      headlineMedium: GoogleFonts.plusJakartaSans(
          color: primary,
          fontWeight: FontWeight.bold,
          fontSize: 23,
          letterSpacing: -0.3,
          height: 1.25),
      headlineSmall: GoogleFonts.plusJakartaSans(
          color: primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: -0.2,
          height: 1.3),
      titleLarge: GoogleFonts.plusJakartaSans(
          color: primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          letterSpacing: -0.2),
      titleMedium: GoogleFonts.plusJakartaSans(
          color: primary, fontWeight: FontWeight.w600, fontSize: 16),
      titleSmall: GoogleFonts.plusJakartaSans(
          color: primary, fontWeight: FontWeight.w600, fontSize: 14),
      bodyLarge:
          GoogleFonts.plusJakartaSans(color: primary, fontSize: 15, height: 1.5),
      bodyMedium:
          GoogleFonts.plusJakartaSans(color: secondary, fontSize: 14, height: 1.4),
      bodySmall:
          GoogleFonts.plusJakartaSans(color: secondary, fontSize: 12.5, height: 1.4),
      labelLarge: GoogleFonts.plusJakartaSans(
          color: primary, fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonStyle(
      Color bg, Color fg) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: bg.withValues(alpha: 0.35),
        disabledForegroundColor: fg.withValues(alpha: 0.8),
        elevation: 0,
        minimumSize: const Size(0, 50),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusButton),
        ),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonStyle(Color bg, Color fg) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: bg.withValues(alpha: 0.35),
        disabledForegroundColor: fg.withValues(alpha: 0.8),
        minimumSize: const Size(0, 50),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusButton),
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecoration({
    required Color fillColor,
    required Color borderColor,
    required Color focusColor,
    required Color hintColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: BorderSide(color: borderColor, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: BorderSide(color: borderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: BorderSide(color: focusColor, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: const BorderSide(color: error, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: const BorderSide(color: error, width: 1.8),
      ),
      hintStyle: GoogleFonts.plusJakartaSans(color: hintColor, fontSize: 14),
      labelStyle: GoogleFonts.plusJakartaSans(
          color: hintColor, fontWeight: FontWeight.w500, fontSize: 14),
    );
  }
}

/// Smooth cross-platform page transition (subtle fade + slight upward slide).
class _SmoothPageTransitionsBuilder extends PageTransitionsBuilder {
  const _SmoothPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return child;
    }
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
