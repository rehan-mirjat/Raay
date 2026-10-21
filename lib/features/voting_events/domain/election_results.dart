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
  });

  final List<ResultRow> rows;
  final int total;
  final int eligible;
  final double turnout;
  final bool published;
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
  return ElectionResults(
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
    ..writeln('Eligible Voters,${results.eligible}')
    ..writeln('Turnout,${results.turnout.toStringAsFixed(1)}%')
    ..writeln()
    ..writeln('Choice / Option,Votes,Percentage');
  for (final r in results.rows) {
    b.writeln('${csvCell(r.name)},${r.votes},${r.percent.toStringAsFixed(2)}%');
  }
  return b.toString();
}
