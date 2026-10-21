import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Registered by a screen that holds unsaved work (e.g. the election builder).
/// Returns true if leaving is OK (nothing to lose, or the user confirmed),
/// false if the user chose to stay.
typedef ExitGuard = Future<bool> Function();

class ExitGuardNotifier extends StateNotifier<ExitGuard?> {
  ExitGuardNotifier() : super(null);

  void register(ExitGuard guard) => state = guard;

  /// Only clears the guard if [guard] is still the registered one, so a screen
  /// being disposed cannot remove a newer screen's guard.
  void unregister(ExitGuard guard) {
    if (identical(state, guard)) state = null;
  }
}

final exitGuardProvider =
    StateNotifierProvider<ExitGuardNotifier, ExitGuard?>((ref) => ExitGuardNotifier());

/// Navigation entry points call this before leaving a guarded screen.
Future<bool> canLeaveCurrentScreen(ProviderContainer container) async {
  final guard = container.read(exitGuardProvider);
  return guard == null ? true : await guard();
}
