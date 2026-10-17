import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/providers/onboarding_providers.dart';

/// How long the app may sit backgrounded (or fully closed) before the next
/// foreground/cold-start requires the user to re-prove their identity.
/// Firebase Auth's own session is persisted indefinitely by design - this is
/// an app-level gate on top of that, not a change to how long the
/// underlying Firebase session itself stays valid.
const Duration sessionIdleTimeout = Duration(minutes: 15);

const _kLastBackgroundedKey = 'session_last_backgrounded_ms';

/// Tracks whether the app should show the re-authentication lock screen.
/// `true` means locked. The notifier only decides *whether* a lock is due;
/// whether one is actually shown also depends on a user being signed in at
/// all, which the UI checks separately.
class SessionLockNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  SessionLockNotifier(this._prefs) : super(false) {
    _checkIfLockIsDue();
  }

  void _checkIfLockIsDue() {
    final lastBackgrounded = _prefs.getInt(_kLastBackgroundedKey);
    if (lastBackgrounded == null) return;
    final elapsed = DateTime.now().millisecondsSinceEpoch - lastBackgrounded;
    if (elapsed > sessionIdleTimeout.inMilliseconds) {
      state = true;
    }
  }

  /// Call when the app is backgrounded (paused) or about to be terminated
  /// (detached) - records the moment so the next resume/cold-start can tell
  /// how long the app was actually away, surviving process death since it's
  /// persisted rather than kept only in memory.
  void recordBackgrounded() {
    _prefs.setInt(_kLastBackgroundedKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Call when the app returns to the foreground - re-checks elapsed time
  /// since it was last backgrounded and locks if the idle timeout was
  /// exceeded.
  void checkOnResume() => _checkIfLockIsDue();

  /// Call once the user has successfully re-authenticated.
  void unlock() {
    state = false;
  }
}

final sessionLockProvider = StateNotifierProvider<SessionLockNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SessionLockNotifier(prefs);
});
