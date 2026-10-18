import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/providers/onboarding_providers.dart';

const _kThemeKey = 'kivora_theme_mode';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static ThemeMode _load(SharedPreferences prefs) {
    final saved = prefs.getString(_kThemeKey);
    switch (saved) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.dark; // Default: dark mode
    }
  }

  void setMode(ThemeMode mode) {
    state = mode;
    switch (mode) {
      case ThemeMode.light:
        _prefs.setString(_kThemeKey, 'light');
      case ThemeMode.dark:
        _prefs.setString(_kThemeKey, 'dark');
      case ThemeMode.system:
        _prefs.setString(_kThemeKey, 'system');
    }
  }

  void toggle() {
    setMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});
