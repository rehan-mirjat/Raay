import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/firebase_service.dart';
import '../../../services/functions_service.dart';
import '../domain/event_result.dart';

class ResultsRepository {
  final FirebaseFirestore _firestore;
  final FunctionsService _functionsService;

  ResultsRepository({
    FirebaseFirestore? firestore,
    FunctionsService? functionsService,
  })  : _firestore = firestore ?? FirebaseService().firestore,
        _functionsService = functionsService ?? FunctionsService();

  Stream<EventResult?> watchEventResult(String eventId) {
    return _firestore
        .collection('eventResults')
        .doc(eventId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return EventResult.fromFirestore(doc);
    });
  }

  Future<EventResult?> getEventResult(String eventId) async {
    final doc = await _firestore.collection('eventResults').doc(eventId).get();
    if (!doc.exists) return null;
    return EventResult.fromFirestore(doc);
  }

  Future<void> calculateResults(String eventId) async {
    await _functionsService.calculateResults(eventId: eventId);
  }

  Future<void> publishResults(String eventId) async {
    await _functionsService.publishResults(eventId: eventId);
  }
}

final resultsRepositoryProvider = Provider<ResultsRepository>((ref) {
  return ResultsRepository(
    functionsService: ref.watch(functionsServiceProvider),
  );
});

final eventResultStreamProvider =
    StreamProvider.family<EventResult?, String>((ref, eventId) {
  final repository = ref.watch(resultsRepositoryProvider);
  return repository.watchEventResult(eventId);
});
