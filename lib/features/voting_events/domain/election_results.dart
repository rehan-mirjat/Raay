/// One choice's tally.
class ResultRow {
  const ResultRow({required this.name, required this.votes, required this.percent});
  final String name;
  final int votes;
  final double percent;
}

class ElectionResults {
  const ElectionResults({
    required this.rows,
    required this.total,
    required this.eligible,
    required this.turnout,
    required this.published,
    this.contests = const [],
    this.abstentionCount = 0,
    int? validVotes,
    this.quorumPercent,
    this.quorumMet,
  }) : validVotes = validVotes ?? total;

  final int abstentionCount;
  final int validVotes;
  final int? quorumPercent;
  final bool? quorumMet;
  Outcome? get outcome => quorumMet == false ? null : outcomeFor(rows, validVotes);

  final List<ContestResult> contests;
  final List<ResultRow> rows;
  final int total;
  final int eligible;
  final double turnout;
  final bool published;
}

class ContestResult {
  const ContestResult({required this.id, required this.title, required this.results});
  final String id;
  final String title;
  final ElectionResults results;
}

num? _num(Object? v) => v is num ? v : null;

/// Parses an `eventResults/{id}` document. Missing numbers become 0 and
/// percentages are clamped to 0..100; nothing here throws on odd data.
ElectionResults parseElectionResults(Map<String, dynamic> data) {
  final rawRows = (data['tallies'] as List<dynamic>?) ?? (data['choices'] as List<dynamic>?) ?? const [];
  final rows = rawRows.whereType<Map>().map((row) {
    final v = Map<String, dynamic>.from(row);
    final name = (v['name'] ?? v['label'])?.toString();
    return ResultRow(
      name: (name == null || name.trim().isEmpty) ? '—' : name,
      votes: _num(v['votes'] ?? v['voteCount'])?.toInt() ?? 0,
      percent: (_num(v['percent'])?.toDouble() ?? 0).clamp(0, 100).toDouble(),
    );
  }).toList();
  final rawContests = data['contests'];
  final contests = (rawContests is List ? rawContests : const []).whereType<Map>().map((raw) {
    final item = Map<String, dynamic>.from(raw);
    return ContestResult(id: item['contestId']?.toString() ?? '', title: item['title']?.toString() ?? '', results: parseElectionResults({
      ...item, 'quorumMet': data['quorumMet'], 'quorumPercent': data['quorumPercent'], 'contests': const [], 'eligibleCount': data['eligibleCount'], 'turnoutPercent': data['turnoutPercent'], 'published': data['published'],
    }));
  }).toList();
  return ElectionResults(
    contests: contests,
    abstentionCount: _num(data['abstentionCount'])?.toInt() ?? 0,
    validVotes: _num(data['validVotes'])?.toInt(),
    quorumPercent: _num(data['quorumPercent'])?.toInt(),
    quorumMet: data['quorumMet'] is bool ? data['quorumMet'] as bool : null,
    rows: rows,
    total: _num(data['totalVotes'])?.toInt() ?? 0,
    eligible: _num(data['eligibleCount'] ?? data['eligibleVoterCount'])?.toInt() ?? 0,
    turnout: (_num(data['turnoutPercent'])?.toDouble() ?? 0).clamp(0, 100).toDouble(),
    published: data['published'] == true,
  );
}

class Outcome {
  const Outcome({required this.leaders, required this.votes, required this.percent});
  final List<ResultRow> leaders;
  final int votes;
  final double percent;
  bool get isTie => leaders.length > 1;
}

/// Leader(s) by votes, or null when nothing was counted.
Outcome? outcomeFor(List<ResultRow> rows, int total) {
  if (total <= 0 || rows.isEmpty) return null;
  final maxVotes = rows.map((r) => r.votes).reduce((a, b) => a > b ? a : b);
  if (maxVotes <= 0) return null;
  final leaders = rows.where((r) => r.votes == maxVotes).toList();
  return Outcome(leaders: leaders, votes: maxVotes, percent: leaders.first.percent);
}

/// Spreadsheet apps run cells that start with = + - @ (or tab/CR) as formulas.
/// Prefix those with an apostrophe so admin-entered names can't execute.
String csvCell(String value) {
  var v = value;
  if (v.isNotEmpty && '=+-@\t\r'.contains(v[0])) v = "'$v";
  return '"${v.replaceAll('"', '""')}"';
}

String resultsCsv({
  required String title,
  required ElectionResults results,
}) {
  final b = StringBuffer()
    ..writeln('Election Title,${csvCell(title)}')
    ..writeln('Ballots Counted,${results.total}')
    ..writeln('Valid Choice Ballots,${results.validVotes}')
    ..writeln('Abstentions,${results.abstentionCount}')
    ..writeln('Quorum Percent,${results.quorumPercent ?? 'Disabled'}')
    ..writeln('Quorum Met,${results.quorumMet ?? 'Not required'}')
    ..writeln('Percentage Basis,Valid choice ballots excluding abstentions')
    ..writeln('Eligible Voters,${results.eligible}')
    ..writeln('Turnout,${results.turnout.toStringAsFixed(1)}%')
    ..writeln()
    ..writeln(results.contests.isEmpty ? 'Choice / Option,Votes,Percentage' : 'Contest,Choice / Option,Votes,Percentage');
  for (final r in results.rows) {
    b.writeln('${csvCell(r.name)},${r.votes},${r.percent.toStringAsFixed(2)}%');
  }
  for (final contest in results.contests) {
    for (final row in contest.results.rows) {
      b.writeln('${csvCell(contest.title)},${csvCell(row.name)},${row.votes},${row.percent.toStringAsFixed(2)}%');
    }
  }
  return b.toString();
}
