/// Text that is safe to show to a user. Only messages our own code wrote
/// (a plain `Exception('text')`) pass through; platform, network and parsing
/// errors become [fallback] so internals never leak into the UI.
String friendlyError(Object error, {String fallback = 'Something went wrong. Please try again.'}) {
  final text = error.toString();
  if (error is Exception && text.startsWith('Exception: ')) {
    final message = text.substring('Exception: '.length).trim();
    final looksInternal = message.contains('Firebase') ||
        message.contains('firebase_') ||
        message.contains('[') ||
        message.contains('PlatformException') ||
        message.contains('SocketException') ||
        message.contains('FormatException') ||
        message.isEmpty;
    if (!looksInternal) return message;
  }
  return fallback;
}
