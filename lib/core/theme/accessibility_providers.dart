import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/providers/onboarding_providers.dart';

const _kReducedMotionKey = 'kivora_reduced_motion';
const _kHighContrastKey = 'kivora_high_contrast';

/// Package C3's "Reduce motion" setting. This is a USER PREFERENCE layered
/// on top of (not a replacement for) the OS-level accessibility flag that
/// MediaQuery.disableAnimations already reports - the app-root builder
/// combines both, so turning this on works even on platforms/browsers where
/// the OS-level reduce-motion setting isn't exposed to Flutter.
class ReducedMotionNotifier extends StateNotifier<bool> {
  ReducedMotionNotifier(this._prefs) : super(_prefs.getBool(_kReducedMotionKey) ?? false);
  final SharedPreferences _prefs;

  void setEnabled(bool enabled) {
    state = enabled;
    _prefs.setBool(_kReducedMotionKey, enabled);
  }
}

final reducedMotionProvider = StateNotifierProvider<ReducedMotionNotifier, bool>((ref) {
  return ReducedMotionNotifier(ref.watch(sharedPreferencesProvider));
});

/// Package C3's "High contrast" setting - swaps secondary/border colors for
/// higher-contrast variants app-wide (see AppTheme.highContrastOverrides).
class HighContrastNotifier extends StateNotifier<bool> {
  HighContrastNotifier(this._prefs) : super(_prefs.getBool(_kHighContrastKey) ?? false);
  final SharedPreferences _prefs;

  void setEnabled(bool enabled) {
    state = enabled;
    _prefs.setBool(_kHighContrastKey, enabled);
  }
}

final highContrastProvider = StateNotifierProvider<HighContrastNotifier, bool>((ref) {
  return HighContrastNotifier(ref.watch(sharedPreferencesProvider));
});
