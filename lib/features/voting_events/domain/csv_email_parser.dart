/// Extracts email addresses from pasted CSV text without splitting commas that
/// occur inside quoted fields.
///
/// If a header row contains an `email` column, only that column is inspected.
/// Otherwise all cells are inspected, which keeps support for a pasted email
/// list and simple one-column CSV files.
class CsvEmailParser {
  static final RegExp _emailPattern = RegExp(
    r'''^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$''',
  );

  const CsvEmailParser();

  List<String> parse(String input) {
    final rows = _parseRows(input.replaceFirst('\ufeff', ''));
    if (rows.isEmpty) return const [];

    var emailColumn = -1;
    final firstRow = rows.first
        .map((cell) => cell.trim().toLowerCase().replaceAll('\ufeff', ''))
        .toList();
    for (var index = 0; index < firstRow.length; index++) {
      if (firstRow[index] == 'email' || firstRow[index] == 'e-mail') {
        emailColumn = index;
        break;
      }
    }

    final startRow = emailColumn == -1 ? 0 : 1;
    final emails = <String>{};
    for (final row in rows.skip(startRow)) {
      final cells = emailColumn == -1
          ? row
          : (emailColumn < row.length ? [row[emailColumn]] : const <String>[]);
      for (final cell in cells) {
        final email = cell.trim().toLowerCase();
        if (_emailPattern.hasMatch(email)) emails.add(email);
      }
    }
    return emails.toList(growable: false);
  }

  List<List<String>> _parseRows(String input) {
    final rows = <List<String>>[];
    var row = <String>[];
    final cell = StringBuffer();
    var quoted = false;

    for (var index = 0; index < input.length; index++) {
      final character = input[index];
      if (character == '"') {
        if (quoted && index + 1 < input.length && input[index + 1] == '"') {
          cell.write('"');
          index++;
        } else {
          quoted = !quoted;
        }
      } else if (!quoted &&
          (character == ',' ||
              character == ';' ||
              character == '\n' ||
              character == '\r')) {
        row.add(cell.toString());
        cell.clear();
        if (character == '\n' || character == '\r') {
          if (row.any((value) => value.trim().isNotEmpty)) rows.add(row);
          row = <String>[];
          if (character == '\r' &&
              index + 1 < input.length &&
              input[index + 1] == '\n') {
            index++;
          }
        }
      } else {
        cell.write(character);
      }
    }

    row.add(cell.toString());
    if (row.any((value) => value.trim().isNotEmpty)) rows.add(row);
    return rows;
  }
}
