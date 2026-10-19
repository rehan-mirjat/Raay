import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/voting_event.dart';

String _csvField(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

/// Package B3's "export of authorized aggregated reports": a CSV of the
/// events already visible to the calling admin on screen - no new data
/// fetch, no fields beyond what the admin's own events list already shows
/// (title, status, type, schedule), so this can't leak anything the admin
/// couldn't already see.
Future<void> exportEventsReportCsv(
  List<VotingEvent> events,
  String organizationName,
) async {
  final format = DateFormat('yyyy-MM-dd HH:mm');
  final rows = <String>[
    'Title,Status,Type,Privacy Mode,Start,End,Organization',
    for (final e in events)
      [
        _csvField(e.title),
        e.status.name,
        e.votingType.name,
        e.privacyMode.name,
        format.format(e.startAt),
        format.format(e.endAt),
        _csvField(organizationName),
      ].join(','),
  ];
  final csv = rows.join('\r\n');

  final file = XFile.fromData(
    Uint8List.fromList(utf8.encode(csv)),
    name: 'elections_report.csv',
    mimeType: 'text/csv',
  );
  await SharePlus.instance.share(ShareParams(
    files: [file],
    subject: 'Elections report - $organizationName',
  ));
}
