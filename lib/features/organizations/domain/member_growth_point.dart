import 'package:cloud_firestore/cloud_firestore.dart';

/// A single day's active-member count, as written by the
/// snapshotMemberGrowth Cloud Function.
class MemberGrowthPoint {
  const MemberGrowthPoint({required this.date, required this.memberCount});

  final DateTime date;
  final int memberCount;

  factory MemberGrowthPoint.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final dateStr = data['date'] as String? ?? doc.id;
    return MemberGrowthPoint(
      date: DateTime.tryParse(dateStr) ?? DateTime.now(),
      memberCount: (data['memberCount'] as num?)?.toInt() ?? 0,
    );
  }
}
