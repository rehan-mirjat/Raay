import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_service.dart';

class SupportRepository {
  SupportRepository(
      {required User? Function() currentUser, FirebaseFirestore? firestore})
      : _currentUser = currentUser,
        _firestore = firestore;
  final User? Function() _currentUser;
  final FirebaseFirestore? _firestore;
  FirebaseFirestore get _db => _firestore ?? FirebaseService().firestore;

  Future<String> submit(
      {required String category,
      required String subject,
      required String message,
      String receiptReference = ''}) async {
    final user = _currentUser();
    if (user == null) throw StateError('An active session is required.');
    if (subject.trim().isEmpty ||
        subject.trim().length > 200 ||
        message.trim().isEmpty ||
        message.trim().length > 5000 ||
        receiptReference.trim().length > 200) {
      throw ArgumentError('Invalid support report.');
    }
    final doc = await _db.collection('userReports').add({
      'userId': user.uid,
      'userEmail': user.email ?? '',
      'category': category,
      'subject': subject.trim(),
      'message': message.trim(),
      if (receiptReference.trim().isNotEmpty)
        'receiptReference': receiptReference.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'open',
    });
    return doc.id;
  }

  Stream<List<Map<String, dynamic>>> watchMine(int limit) {
    final user = _currentUser();
    if (user == null) return Stream.value(const []);
    return _db
        .collection('userReports')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((d) => {...d.data(), 'id': d.id}).toList());
  }
}

final supportRepositoryProvider = Provider((ref) => SupportRepository(
      currentUser: () => ref.read(authServiceProvider).currentUser,
    ));
final mySupportReportsProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, int>((ref, limit) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  if (user == null) return Stream.value(const []);
  return ref.watch(supportRepositoryProvider).watchMine(limit);
});
