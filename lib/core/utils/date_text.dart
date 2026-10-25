import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// "Oct 22, 2026 · 09:30" in the app language. Falls back to the English
/// pattern if date symbols for the locale are not loaded.
String formatDateTimeText(BuildContext context, DateTime value) {
  final local = value.toLocal();
  try {
    final locale = Localizations.localeOf(context).toString();
    return '${DateFormat.yMMMd(locale).format(local)} · ${DateFormat.Hm(locale).format(local)}';
  } catch (_) {
    return DateFormat('MMM d, yyyy · HH:mm').format(local);
  }
}

/// "Oct 22, 2026" in the app language, with the same fallback.
String formatDateText(BuildContext context, DateTime value) {
  final local = value.toLocal();
  try {
    return DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(local);
  } catch (_) {
    return DateFormat('MMM d, yyyy').format(local);
  }
}
