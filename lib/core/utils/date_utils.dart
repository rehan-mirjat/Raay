import 'package:cloud_firestore/cloud_firestore.dart';

/// Safely parses a dynamic Firestore date value (whether it is returned as
/// a [Timestamp], a ISO-8601 [String], or a [DateTime]) into a nullable [DateTime].
DateTime? parseFirestoreDate(dynamic raw) {
  if (raw == null) return null;
  if (raw is Timestamp) return raw.toDate();
  if (raw is DateTime) return raw;
  if (raw is String) return DateTime.tryParse(raw);
  return null;
}
