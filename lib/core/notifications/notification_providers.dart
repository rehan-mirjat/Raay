import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';

class AppNotification {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? votingEventId;
  final bool read;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.votingEventId,
    required this.read,
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
    );
  }
}

/// Unread, server-written notifications for the signed-in user (currently
/// just vote reminders from remindNonVoters). Capped client-side since this
/// only drives the notification bell dropdown, not a full inbox.
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

Future<void> markNotificationRead(String notificationId) {
  return FirebaseService()
      .firestore
      .collection('notifications')
      .doc(notificationId)
      .update({'read': true});
}
