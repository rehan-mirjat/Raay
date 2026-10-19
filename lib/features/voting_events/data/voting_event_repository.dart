import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/firebase_service.dart';
import '../../../core/utils/error_utils.dart';
import '../domain/voting_event.dart';

class VotingEventRepository {
  final FirebaseService _firebase = FirebaseService();

  Future<String> createVotingEvent({
    required String organizationId,
    required String title,
    required String description,
    required String votingType,
    String privacyMode = 'ANONYMOUS',
    required String eligibilityType,
    List<String>? eligibilityDepartmentIds,
    List<String>? eligibilityUserIds,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    try {
      final callable = _firebase.functions.httpsCallable('createVotingEvent');
      final result = await callable.call({
        'organizationId': organizationId,
        'title': title,
        'description': description,
        'votingType': votingType,
        'privacyMode': privacyMode,
        'eligibilityType': eligibilityType,
        if (eligibilityDepartmentIds != null) 'eligibilityDepartmentIds': eligibilityDepartmentIds,
        if (eligibilityUserIds != null) 'eligibilityUserIds': eligibilityUserIds,
        'startAt': startAt.toUtc().toIso8601String(),
        'endAt': endAt.toUtc().toIso8601String(),
      });
      return result.data['eventId'] as String;
    } catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Future<void> updateVotingEvent({
    required String eventId,
    String? votingType,
    String? privacyMode,
    String? title,
    String? description,
    DateTime? startAt,
    DateTime? endAt,
    String? eligibilityType,
    List<String>? eligibilityDepartmentIds,
    List<String>? eligibilityUserIds,
  }) async {
    try {
      final callable = _firebase.functions.httpsCallable('updateVotingEvent');
      final payload = <String, dynamic>{
        'eventId': eventId,
        if (votingType != null) 'votingType': votingType,
        if (privacyMode != null) 'privacyMode': privacyMode,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (startAt != null) 'startAt': startAt.toUtc().toIso8601String(),
        if (endAt != null) 'endAt': endAt.toUtc().toIso8601String(),
        if (eligibilityType != null) 'eligibilityType': eligibilityType,
        if (eligibilityDepartmentIds != null) 'eligibilityDepartmentIds': eligibilityDepartmentIds,
        if (eligibilityUserIds != null) 'eligibilityUserIds': eligibilityUserIds,
      };
      await callable.call(payload);
    } catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Future<void> publishVotingEvent(String eventId) async {
    try {
      final callable = _firebase.functions.httpsCallable('publishVotingEvent');
      await callable.call({'eventId': eventId});
    } catch (e) {
      if (isRecentAuthError(e)) throw const RequiresRecentAuthException();
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Future<void> deleteVotingEvent(String eventId) async {
    try {
      final callable = _firebase.functions.httpsCallable('deleteVotingEvent');
      await callable.call({'eventId': eventId});
    } catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Future<void> cancelVotingEvent(String eventId) async {
    try {
      final callable = _firebase.functions.httpsCallable('cancelVotingEvent');
      await callable.call({'eventId': eventId});
    } catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Future<void> closeVotingEvent(String eventId) async {
    try {
      final callable = _firebase.functions.httpsCallable('closeVotingEvent');
      await callable.call({'eventId': eventId});
    } catch (e) {
      if (isRecentAuthError(e)) throw const RequiresRecentAuthException();
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Stream<List<VotingEvent>> watchOrganizationVotingEvents(
    String organizationId, {
    bool includeDrafts = false,
  }) {
    var query = _firebase.firestore
        .collection('votingEvents')
        .where('organizationId', isEqualTo: organizationId);

    if (!includeDrafts) {
      query = query.where('status', whereIn: ['SCHEDULED', 'ACTIVE', 'CLOSED', 'CANCELLED', 'ARCHIVED']);
    }

    return query
        .orderBy('startAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => VotingEvent.fromFirestore(doc)).toList());
  }

  /// One-shot fetch of non-draft events across every organization the caller
  /// belongs to, for the member-facing "My Voting Portal". Firestore's
  /// `whereIn` caps at 30 values, so membership lists longer than that are
  /// split into chunks and fetched in parallel; results are merged and
  /// re-sorted client-side. Drafts are excluded unconditionally - this is a
  /// voter-facing aggregate, and Firestore rules already hide drafts from
  /// non-admins anyway, so this just keeps admins' own drafts out of a view
  /// that's meant to show what's open to vote on, not what they're building.
  Future<List<VotingEvent>> fetchEventsAcrossOrganizations(
    List<String> organizationIds,
  ) async {
    if (organizationIds.isEmpty) return [];

    final chunks = <List<String>>[];
    for (var i = 0; i < organizationIds.length; i += 30) {
      chunks.add(organizationIds.sublist(
          i, (i + 30).clamp(0, organizationIds.length)));
    }

    final snapshots = await Future.wait(chunks.map((chunk) => _firebase
        .firestore
        .collection('votingEvents')
        .where('organizationId', whereIn: chunk)
        .orderBy('startAt', descending: true)
        .limit(200)
        .get()));

    final events = snapshots
        .expand((snap) => snap.docs.map((d) => VotingEvent.fromFirestore(d)))
        .where((e) => e.status != VotingEventStatus.draft)
        .toList()
      ..sort((a, b) => b.startAt.compareTo(a.startAt));

    return events;
  }

  Stream<VotingEvent?> watchVotingEvent(String eventId) {
    return _firebase.firestore
        .collection('votingEvents')
        .doc(eventId)
        .snapshots()
        .map((doc) => doc.exists ? VotingEvent.fromFirestore(doc) : null);
  }
}

final votingEventRepositoryProvider = Provider((ref) => VotingEventRepository());

/// Stable StreamProvider so the stream object identity is preserved across
/// parent rebuilds — prevents StreamBuilder from reconnecting and flashing a
/// loading state whenever the home screen rebuilds.
final organizationVotingEventsProvider = StreamProvider.autoDispose
    .family<List<VotingEvent>, ({String orgId, bool includeDrafts})>(
        (ref, args) {
  return ref
      .watch(votingEventRepositoryProvider)
      .watchOrganizationVotingEvents(args.orgId, includeDrafts: args.includeDrafts);
});
