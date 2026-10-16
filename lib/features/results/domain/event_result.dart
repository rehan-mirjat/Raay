import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateTally {
  final String candidateId;
  final String candidateName;
  final int voteCount;
  final double percent;

  CandidateTally({
    required this.candidateId,
    required this.candidateName,
    required this.voteCount,
    required this.percent,
  });

  factory CandidateTally.fromMap(Map<String, dynamic> map) {
    return CandidateTally(
      candidateId: map['choiceId'] as String? ?? '',
      candidateName: map['name'] as String? ?? 'Unknown',
      voteCount: (map['votes'] as num?)?.toInt() ?? 0,
      percent: (map['percent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'choiceId': candidateId,
      'choiceType': 'CANDIDATE',
      'name': candidateName,
      'votes': voteCount,
      'percent': percent,
    };
  }
}

class OptionTally {
  final String optionId;
  final String title;
  final int voteCount;
  final double percent;

  OptionTally({
    required this.optionId,
    required this.title,
    required this.voteCount,
    required this.percent,
  });

  factory OptionTally.fromMap(Map<String, dynamic> map) {
    return OptionTally(
      optionId: map['choiceId'] as String? ?? '',
      title: map['name'] as String? ?? 'Option',
      voteCount: (map['votes'] as num?)?.toInt() ?? 0,
      percent: (map['percent'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'choiceId': optionId,
      'choiceType': 'POLL_OPTION',
      'name': title,
      'votes': voteCount,
      'percent': percent,
    };
  }
}

class EventResult {
  final String eventId;
  final String organizationId;
  final int totalVotes;
  final int eligibleCount;
  final int participationCount;
  final double turnoutPercent;
  final List<CandidateTally> candidateTallies;
  final List<OptionTally> optionTallies;
  final bool published;
  final DateTime calculatedAt;

  EventResult({
    required this.eventId,
    required this.organizationId,
    required this.totalVotes,
    required this.eligibleCount,
    required this.participationCount,
    required this.turnoutPercent,
    required this.candidateTallies,
    required this.optionTallies,
    required this.published,
    required this.calculatedAt,
  });

  factory EventResult.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    final rawTallies = data['tallies'] as List<dynamic>? ?? [];
    
    final candidateList = <CandidateTally>[];
    final optionList = <OptionTally>[];

    for (final t in rawTallies) {
      if (t is Map) {
        final map = Map<String, dynamic>.from(t);
        final choiceType = map['choiceType'] as String?;
        if (choiceType == 'CANDIDATE') {
          candidateList.add(CandidateTally.fromMap(map));
        } else if (choiceType == 'POLL_OPTION') {
          optionList.add(OptionTally.fromMap(map));
        }
      }
    }

    return EventResult(
      eventId: doc.id,
      organizationId: data['organizationId'] as String? ?? '',
      totalVotes: (data['totalVotes'] as num?)?.toInt() ?? 0,
      eligibleCount: (data['eligibleCount'] as num?)?.toInt() ?? 0,
      participationCount: (data['participationCount'] as num?)?.toInt() ?? 0,
      turnoutPercent: (data['turnoutPercent'] as num?)?.toDouble() ?? 0.0,
      candidateTallies: candidateList,
      optionTallies: optionList,
      published: data['published'] as bool? ?? false,
      calculatedAt: (data['calculatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    final tallies = [
      ...candidateTallies.map((e) => e.toMap()),
      ...optionTallies.map((e) => e.toMap()),
    ];

    return {
      'organizationId': organizationId,
      'totalVotes': totalVotes,
      'eligibleCount': eligibleCount,
      'participationCount': participationCount,
      'turnoutPercent': turnoutPercent,
      'tallies': tallies,
      'published': published,
      'calculatedAt': Timestamp.fromDate(calculatedAt),
    };
  }
}
