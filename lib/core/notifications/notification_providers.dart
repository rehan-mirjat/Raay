import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? votingEventId;
  final bool read;
  final DateTime? createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.votingEventId,
    required this.read,
    this.createdAt,
  });

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      type: data['type'] as String? ?? 'GENERIC',
      title: data['title'] as String? ?? 'Notification',
      message: data['message'] as String? ?? '',
      votingEventId: data['votingEventId'] as String?,
      read: data['read'] as bool? ?? false,
      createdAt: parseFirestoreDate(data['createdAt']),
    );
  }
}

/// Unread, server-written notifications for the signed-in user, used by the
/// notification bell.
final unreadNotificationsProvider =
    StreamProvider.autoDispose<List<AppNotification>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(const []);

  return FirebaseService()
      .firestore
      .collection('notifications')
      .where('userId', isEqualTo: user.uid)
      .where('read', isEqualTo: false)
      .orderBy('createdAt', descending: true)
      .limit(20)
      .snapshots()
      .map((snap) => snap.docs.map(AppNotification.fromFirestore).toList());
});

/// Full notification inbox for the signed-in user. The query remains scoped
/// to the current recipient, which is also enforced by Firestore rules.
final notificationInboxProvider =
    StreamProvider.autoDispose.family<List<AppNotification>, int>((ref, limit) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(const []);

  return FirebaseService()
      .firestore
      .collection('notifications')
      .where('userId', isEqualTo: user.uid)
      .orderBy('createdAt', descending: true)
      .limit(limit)
      .snapshots()
      .map((snap) => snap.docs.map(AppNotification.fromFirestore).toList());
});

Future<void> markNotificationRead(String notificationId) {
  return FirebaseService()
      .firestore
      .collection('notifications')
      .doc(notificationId)
      .update({'read': true});
}

/// Marks every unread notification belonging to the current Firebase user.
/// The Firestore rule independently enforces recipient ownership on each write.
Future<void> markAllUnreadNotificationsRead() async {
  final service = FirebaseService();
  final uid = service.auth.currentUser?.uid;
  if (uid == null) return;
  final collection = service.firestore.collection('notifications');
  var query = collection
      .where('userId', isEqualTo: uid)
      .where('read', isEqualTo: false)
      .orderBy('createdAt', descending: true)
      .limit(450);
  while (true) {
    final snapshot = await query.get();
    if (snapshot.docs.isEmpty) break;
    final batch = service.firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
    if (snapshot.docs.length < 450) break;
    query = query.startAfterDocument(snapshot.docs.last);
  }
}
