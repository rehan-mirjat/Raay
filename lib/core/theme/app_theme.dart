import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors (2026 SaaS / Enterprise Security Palette)
  static const Color primaryBlue = Color(0xFF2563EB); // Modern Royal SaaS Blue
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color secondaryNavy = Color(0xFF0F172A); // Slate 900 Navy
  static const Color accentTeal = Color(0xFF10B981); // Emerald / Verified
  static const Color accentGold =
      Color(0xFFF59E0B); // Kivora Brand Gold / Star Accent
  static const Color surfaceBlue = Color(0xFFEFF6FF); // Slate Blue Tint

  // Neutral Colors
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50 Neutral BG
  static const Color surfaceWhite = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color warning = Color(
      0xFFF97316); // Orange 500 - distinct from accentGold, which shares the FAB/brand gold hue
  static const Color identifiable =
      Color(0xFFBF360C); // Deep Orange 900 - identifiable-vote indicator

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
          minimumSize: const Size(0, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary, width: 1.8),
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

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryNavy,
        tertiary: accentTeal,
        surface: backgroundLight,
        surfaceContainer: surfaceWhite,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0),
        displayMedium: GoogleFonts.inter(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5),
        titleLarge: GoogleFonts.inter(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.2),
        titleMedium: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        titleSmall: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
        bodyLarge:
            GoogleFonts.inter(color: textPrimary, fontSize: 15, height: 1.5),
        bodyMedium:
            GoogleFonts.inter(color: textSecondary, fontSize: 14, height: 1.4),
        labelLarge: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: secondaryNavy),
        titleTextStyle: TextStyle(
          color: secondaryNavy,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: surfaceWhite,
          side: const BorderSide(color: borderLight, width: 1.2),
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle:
              GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderLight, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderLight, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryBlue, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: error, width: 1.8),
        ),
        hintStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        labelStyle: GoogleFonts.inter(
            color: textSecondary, fontWeight: FontWeight.w500, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 1.2),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceWhite,
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceWhite,
        elevation: 12,
        showDragHandle: true,
        dragHandleColor: borderLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: secondaryNavy,
        contentTextStyle: GoogleFonts.inter(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
        backgroundColor: secondaryNavy,
        unselectedIconTheme:
            IconThemeData(color: Color(0xFF94A3B8)), // Slate 400
        unselectedLabelTextStyle:
            TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
        selectedIconTheme: IconThemeData(color: Colors.white),
        selectedLabelTextStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        useIndicator: true,
        indicatorColor: primaryBlue,
      ),
    );
  }
}
