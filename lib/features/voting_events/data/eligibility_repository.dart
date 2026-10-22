import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/firebase_service.dart';
import '../domain/eligibility_decision.dart';

class EligibilityRepository {
  /// Asks the server for the caller's own decision per event. Never throws:
  /// a failed lookup returns an empty map, which the UI treats as "unknown".
  Future<Map<String, EligibilityDecision>> fetchMine(List<String> eventIds) async {
    if (eventIds.isEmpty) return {};
    final out = <String, EligibilityDecision>{};
    try {
      final callable = FirebaseService().functions.httpsCallable('getMyEligibility');
      // The callable accepts at most 50 events per request.
      for (var i = 0; i < eventIds.length; i += 50) {
        final chunk = eventIds.sublist(i, i + 50 > eventIds.length ? eventIds.length : i + 50);
        final res = await callable.call({'eventIds': chunk});
        final decisions = (res.data as Map)['decisions'];
        if (decisions is Map) {
          decisions.forEach((k, v) => out[k as String] = EligibilityDecision.fromMap(v));
        }
      }
    } catch (_) {
      // leave whatever was fetched; missing ids are "unknown"
    }
    return out;
  }
}

final eligibilityRepositoryProvider = Provider<EligibilityRepository>((ref) => EligibilityRepository());
