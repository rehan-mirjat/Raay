import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/providers/onboarding_providers.dart';

const _kLocaleKey = 'kivora_locale';

/// null means "follow the system locale" - MaterialApp.router's `locale`
/// parameter already does exactly that when passed null, falling back to the
/// nearest entry in `supportedLocales` via its own localeResolutionCallback.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static Locale? _load(SharedPreferences prefs) {
    final saved = prefs.getString(_kLocaleKey);
    if (saved == null || saved.isEmpty) return null;
    return Locale(saved);
  }

  void setLocale(Locale? locale) {
    state = locale;
    if (locale == null) {
      _prefs.remove(_kLocaleKey);
    } else {
      _prefs.setString(_kLocaleKey, locale.languageCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});
