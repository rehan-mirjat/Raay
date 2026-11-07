import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/firebase_service.dart';
import '../../../core/utils/error_utils.dart';
import '../domain/voting_event.dart';

class VotingEventRepository {
  VotingEventRepository({FirebaseFirestore? firestore}) : _injectedFirestore = firestore;
  final FirebaseFirestore? _injectedFirestore;
  FirebaseService get _firebase => FirebaseService();
  FirebaseFirestore get _firestore => _injectedFirestore ?? _firebase.firestore;

  Future<String> createVotingEvent({
    bool multiContest = false,
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
        'ballotMode': multiContest ? 'MULTI_CONTEST' : 'SINGLE',
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
    List<Map<String, dynamic>>? contests,
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
        if (contests != null) 'contests': contests,
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

  static const _visibleToMembersStatuses = ['SCHEDULED', 'ACTIVE', 'CLOSED', 'CANCELLED', 'ARCHIVED'];

  Query<Map<String, dynamic>> _organizationQuery(String organizationId, {bool includeDrafts = false, String? status}) {
    Query<Map<String, dynamic>> query = _firestore.collection('votingEvents').where('organizationId', isEqualTo: organizationId);
    if (status != null) {
      if (!includeDrafts && status == 'DRAFT') throw ArgumentError('Drafts are not member-visible.');
      query = query.where('status', isEqualTo: status);
    } else if (!includeDrafts) {
      query = query.where('status', whereIn: _visibleToMembersStatuses);
    }
    return query.orderBy('startAt', descending: true).orderBy(FieldPath.documentId, descending: true);
  }

  /// Complete live collection for aggregate/chooser callers. Interactive history
  /// uses watchOrganizationEventPage instead of silently capping this stream.
  Stream<List<VotingEvent>> watchOrganizationVotingEvents(String organizationId, {bool includeDrafts = false}) {
    return _organizationQuery(organizationId, includeDrafts: includeDrafts).snapshots()
        .map((s) => s.docs.map(VotingEvent.fromFirestore).toList());
  }

  Query<Map<String, dynamic>> _pageQuery(EventPageQuery page) {
    if (page.size < 1 || page.size > 200) throw ArgumentError('Page size must be 1–200.');
    var q = _organizationQuery(page.orgId, includeDrafts: page.includeDrafts, status: page.status);
    final after = page.after;
    if (after != null) q = q.startAfter([Timestamp(after.seconds, after.nanoseconds), after.id]);
    return q.limit(page.size + 1);
  }

  EventPage _page(QuerySnapshot<Map<String, dynamic>> snapshot, int size) {
    final docs = snapshot.docs.take(size).toList();
    final last = docs.isEmpty ? null : docs.last;
    final timestamp = last?.data()['startAt'] as Timestamp?;
    return EventPage(events: docs.map(VotingEvent.fromFirestore).toList(), hasMore: snapshot.docs.length > size,
      next: last == null || timestamp == null ? null : EventCursor(seconds: timestamp.seconds, nanoseconds: timestamp.nanoseconds, id: last.id));
  }

  Stream<EventPage> watchOrganizationEventPage(EventPageQuery query) => _pageQuery(query).snapshots().map((s) => _page(s, query.size));
  Future<EventPage> fetchOrganizationEventPage(EventPageQuery query) async => _page(await _pageQuery(query).get(), query.size);

  /// One organization per query keeps both DNF expansion and rule lookup budgets
  /// bounded. Every history page is fetched; future events cannot hide active ones
  /// behind a shared fixed limit. The voter UI already renders in 12-card batches.
  Future<List<VotingEvent>> fetchEventsAcrossOrganizations(List<String> organizationIds) async {
    final ids = organizationIds.toSet().toList();
    final events = <VotingEvent>[];
    Future<List<VotingEvent>> fetchAll(String id) async {
      final result = <VotingEvent>[];
      EventCursor? cursor;
      while (true) {
        final page = await fetchOrganizationEventPage((orgId: id, includeDrafts: false, status: null, after: cursor, size: 200));
        result.addAll(page.events);
        if (!page.hasMore) break;
        cursor = page.next;
      }
      return result;
    }
    // Avoid a request burst for users with many organization memberships.
    for (var i = 0; i < ids.length; i += 4) {
      final group = ids.skip(i).take(4);
      for (final batch in await Future.wait(group.map(fetchAll))) { events.addAll(batch); }
    }
    events.sort((a, b) { final date = b.startAt.compareTo(a.startAt); return date != 0 ? date : b.id.compareTo(a.id); });
    return events;
  }

  Stream<VotingEvent?> watchVotingEvent(String eventId) {
    return _firestore
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

class EventCursor {
  const EventCursor({required this.seconds, required this.nanoseconds, required this.id});
  final int seconds;
  final int nanoseconds;
  final String id;
  @override bool operator ==(Object other) => other is EventCursor && seconds == other.seconds && nanoseconds == other.nanoseconds && id == other.id;
  @override int get hashCode => Object.hash(seconds, nanoseconds, id);
}
class EventPage {
  const EventPage({required this.events, required this.hasMore, this.next});
  final List<VotingEvent> events;
  final bool hasMore;
  final EventCursor? next;
}
typedef EventPageQuery = ({String orgId, bool includeDrafts, String? status, EventCursor? after, int size});
final organizationEventPageProvider = StreamProvider.autoDispose.family<EventPage, EventPageQuery>((ref, query) => ref.watch(votingEventRepositoryProvider).watchOrganizationEventPage(query));
