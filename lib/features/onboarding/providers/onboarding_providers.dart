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

  OnboardingNotifier(this._prefs, this._uid)
      : super(OnboardingState(
          hasCompletedTour: (_uid != null && (_prefs.getBool('hasCompletedTour_$_uid') ?? false)) ||
              (_prefs.getBool('hasCompletedTour') ?? false),
          isChecklistDismissed: (_uid != null && (_prefs.getBool('isChecklistDismissed_$_uid') ?? false)) ||
              (_prefs.getBool('isChecklistDismissed') ?? false),
        ));

  void completeTour() {
    _prefs.setBool('hasCompletedTour', true);
    if (_uid != null) {
      _prefs.setBool('hasCompletedTour_$_uid', true);
    }
    state = state.copyWith(hasCompletedTour: true);
  }

  void restartTour() {
    _prefs.setBool('hasCompletedTour', false);
    if (_uid != null) {
      _prefs.setBool('hasCompletedTour_$_uid', false);
    }
    state = state.copyWith(hasCompletedTour: false);
  }

  void dismissChecklist() {
    _prefs.setBool('isChecklistDismissed', true);
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
