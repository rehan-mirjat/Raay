import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateTally {
  final String candidateId;
  final String candidateName;
  final int voteCount;

  CandidateTally({
    required this.candidateId,
    required this.candidateName,
    required this.voteCount,
  });

  factory CandidateTally.fromMap(Map<String, dynamic> map) {
    return CandidateTally(
      candidateId: map['candidateId'] as String? ?? '',
      candidateName: map['candidateName'] as String? ?? 'Unknown',
      voteCount: (map['voteCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'candidateId': candidateId,
      'candidateName': candidateName,
      'voteCount': voteCount,
    };
  }
}

class OptionTally {
  final String optionId;
  final String title;
  final int voteCount;

  OptionTally({
    required this.optionId,
    required this.title,
    required this.voteCount,
  });

  factory OptionTally.fromMap(Map<String, dynamic> map) {
    return OptionTally(
      optionId: map['optionId'] as String? ?? '',
      title: map['title'] as String? ?? 'Option',
      voteCount: (map['voteCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'optionId': optionId,
      'title': title,
      'voteCount': voteCount,
    };
  }
}

class EventResult {
  final String eventId;
  final String organizationId;
  final int totalBallotsCast;
  final List<CandidateTally> candidateTallies;
  final List<OptionTally> optionTallies;
  final bool published;
  final DateTime calculatedAt;

  EventResult({
    required this.eventId,
    required this.organizationId,
    required this.totalBallotsCast,
    required this.candidateTallies,
    required this.optionTallies,
    required this.published,
    required this.calculatedAt,
  });

  factory EventResult.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final rawCandidates = data['candidateTallies'] as List<dynamic>? ?? [];
    final candidateList = rawCandidates
        .map((e) => CandidateTally.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    final rawOptions = data['optionTallies'] as List<dynamic>? ?? [];
    final optionList = rawOptions
        .map((e) => OptionTally.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    return EventResult(
      eventId: doc.id,
      organizationId: data['organizationId'] as String? ?? '',
      totalBallotsCast: (data['totalBallotsCast'] as num?)?.toInt() ?? 0,
      candidateTallies: candidateList,
      optionTallies: optionList,
      published: data['published'] as bool? ?? false,
      calculatedAt: (data['calculatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'organizationId': organizationId,
      'totalBallotsCast': totalBallotsCast,
      'candidateTallies': candidateTallies.map((e) => e.toMap()).toList(),
      'optionTallies': optionTallies.map((e) => e.toMap()).toList(),
      'published': published,
      'calculatedAt': Timestamp.fromDate(calculatedAt),
    };
  }
}
