import 'dart:convert';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import '../../domain/voting_event.dart';

String _icsDate(DateTime dt) {
  final utc = dt.toUtc();
  String pad(int n, [int width = 2]) => n.toString().padLeft(width, '0');
  return '${utc.year}${pad(utc.month)}${pad(utc.day)}T'
      '${pad(utc.hour)}${pad(utc.minute)}${pad(utc.second)}Z';
}

String _escapeIcsText(String text) {
  return text
      .replaceAll('\\', '\\\\')
      .replaceAll(';', '\\;')
      .replaceAll(',', '\\,')
      .replaceAll('\r\n', '\\n')
      .replaceAll('\n', '\\n')
      // A bare CR would end the line and let a title inject extra properties.
      .replaceAll('\r', '');
}

/// Builds a minimal, standards-compliant VEVENT for an election's voting
/// window (RFC 5545) - good enough for Google/Outlook/Apple Calendar import.
String buildVotingEventIcs(VotingEvent event, String organizationName) {
  final uid = '${event.id}@raay';
  final now = _icsDate(DateTime.now());
  return [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//raay//Election Calendar//EN',
    'CALSCALE:GREGORIAN',
    'BEGIN:VEVENT',
    'UID:$uid',
    'DTSTAMP:$now',
    'DTSTART:${_icsDate(event.startAt)}',
    'DTEND:${_icsDate(event.endAt)}',
    'SUMMARY:${_escapeIcsText(event.title)}',
    'DESCRIPTION:${_escapeIcsText('${event.description}\\n\\nOrganization: $organizationName')}',
    'END:VEVENT',
    'END:VCALENDAR',
  ].join('\r\n');
}

/// Package A2's explicit "add to personal calendar" export/action - hands the
/// generated .ics file to the OS share sheet so the user picks their own
/// calendar app, rather than silently writing to one on their behalf.
Future<void> exportVotingEventToCalendar(
  VotingEvent event,
  String organizationName,
) async {
  final ics = buildVotingEventIcs(event, organizationName);
  final file = XFile.fromData(
    Uint8List.fromList(utf8.encode(ics)),
    name: 'election.ics',
    mimeType: 'text/calendar',
  );
  await SharePlus.instance.share(ShareParams(
    files: [file],
    subject: event.title,
  ));
}
