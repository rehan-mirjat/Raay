import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/firebase_service.dart';

class NominationRepository {
  Stream<List<Map<String, dynamic>>> rounds(String orgId, int limit) =>
      FirebaseService()
          .firestore
          .collection('nominationRounds')
          .where('organizationId', isEqualTo: orgId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList());
  Stream<List<Map<String, dynamic>>> applications(
      String orgId, String roundId, String? uid, int limit) {
    Query<Map<String, dynamic>> q = FirebaseService()
        .firestore
        .collection('nominationApplications')
        .where('organizationId', isEqualTo: orgId)
        .where('roundId', isEqualTo: roundId);
    // Rules must be able to prove the caller's tenant and ownership constraints.
    if (uid != null) q = q.where('userId', isEqualTo: uid);
    return q
        .orderBy('submittedAt')
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList());
  }

  Future<void> act(Map<String, dynamic> data) async {
    await FirebaseService()
        .functions
        .httpsCallable('manageNominations')
        .call(data);
  }
}

final nominationRepositoryProvider = Provider((ref) => NominationRepository());
final nominationRoundsProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, ({String orgId, int limit})>((ref, q) =>
        ref.watch(nominationRepositoryProvider).rounds(q.orgId, q.limit));
final nominationApplicationsProvider = StreamProvider.autoDispose.family<
        List<Map<String, dynamic>>,
        ({String orgId, String roundId, String? uid, int limit})>(
    (ref, q) => ref
        .watch(nominationRepositoryProvider)
        .applications(q.orgId, q.roundId, q.uid, q.limit));
