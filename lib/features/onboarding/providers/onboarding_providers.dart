import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/auth_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class OnboardingState {
  final bool hasCompletedTour;
  final bool isChecklistDismissed;

  const OnboardingState({
    this.hasCompletedTour = false,
    this.isChecklistDismissed = false,
  });

  OnboardingState copyWith({
    bool? hasCompletedTour,
    bool? isChecklistDismissed,
  }) {
    return OnboardingState(
      hasCompletedTour: hasCompletedTour ?? this.hasCompletedTour,
      isChecklistDismissed: isChecklistDismissed ?? this.isChecklistDismissed,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final SharedPreferences _prefs;
  final String? _uid;

  // Tracked strictly per-uid, never device-wide: on a shared device, an
  // earlier bug here OR'd a no-suffix fallback key into every user's check,
  // so once any one user completed the tour, every other user who had
  // never signed in before silently had it marked complete too. A genuinely
  // new user must always see this on their own first login, regardless of
  // who else has used the device.
  OnboardingNotifier(this._prefs, this._uid)
      : super(OnboardingState(
          hasCompletedTour:
              _uid != null && (_prefs.getBool('hasCompletedTour_$_uid') ?? false),
          isChecklistDismissed: _uid != null &&
              (_prefs.getBool('isChecklistDismissed_$_uid') ?? false),
        ));

  void completeTour() {
    if (_uid != null) {
      _prefs.setBool('hasCompletedTour_$_uid', true);
    }
    state = state.copyWith(hasCompletedTour: true);
  }

  void restartTour() {
    if (_uid != null) {
      _prefs.setBool('hasCompletedTour_$_uid', false);
    }
    state = state.copyWith(hasCompletedTour: false);
  }

  void dismissChecklist() {
    if (_uid != null) {
      _prefs.setBool('isChecklistDismissed_$_uid', true);
    }
    state = state.copyWith(isChecklistDismissed: true);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final user = ref.watch(authStateChangesProvider).value;
  return OnboardingNotifier(prefs, user?.uid);
});

/// Whether this device/install has ever seen the pre-login marketing intro
/// (MobileOnboardingScreen, shown at `/welcome`). Deliberately device-wide,
/// not per-uid: unlike the post-login tour, this screen runs before anyone
/// is signed in, so there's no user to scope it to - it tracks "has this
/// install seen it", matching first-install semantics (cleared by an
/// uninstall, same as everything else in SharedPreferences).
class IntroSeenNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  IntroSeenNotifier(this._prefs) : super(_prefs.getBool('has_seen_intro') ?? false);

  void markSeen() {
    _prefs.setBool('has_seen_intro', true);
    state = true;
  }
}

final hasSeenIntroProvider = StateNotifierProvider<IntroSeenNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return IntroSeenNotifier(prefs);
});
