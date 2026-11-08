import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/firebase_service.dart';

/// Reuses the same getEventMonitoring callable that EventMonitoringScreen
/// calls directly, so the Command Center's "active election monitoring"
/// cards show live, server-computed turnout - not a client-side guess -
/// without duplicating that aggregation logic.
final eventMonitoringSummaryProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>?, String>((ref, eventId) async {
  try {
    final response = await FirebaseService()
        .functions
        .httpsCallable('getEventMonitoring')
        .call({'eventId': eventId, 'includeDetails': false});
    return Map<String, dynamic>.from(response.data as Map);
  } catch (_) {
    return null;
  }
});
