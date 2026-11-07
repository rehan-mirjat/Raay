import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_router.dart';

/// Listens for raay://invite?token=... deep links on native platforms
/// (Android/iOS) and routes them into the app. Web handles the equivalent
/// https://.../invite?token=... URL directly through normal browser
/// navigation and go_router - no listener needed there.
class DeepLinkHandler {
  DeepLinkHandler(this._ref);

  final WidgetRef _ref;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  Future<void> start() async {
    if (kIsWeb) return;

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) _handle(initialUri);
    } catch (e) {
      debugPrint('DeepLinkHandler: failed to read initial link: $e');
    }

    _subscription = _appLinks.uriLinkStream.listen(
      _handle,
      onError: (e) => debugPrint('DeepLinkHandler: link stream error: $e'),
    );
  }

  void dispose() {
    _subscription?.cancel();
  }

  void _handle(Uri uri) {
    if (uri.scheme != 'raay' || uri.host != 'invite') return;
    final token = uri.queryParameters['token'];
    if (token == null || token.trim().isEmpty) return;

    // Stored so the router's redirect can send the user here once they've
    // finished signing in/verifying, in case they aren't already.
    _ref.read(pendingInviteTokenProvider.notifier).state = token;
    _ref
        .read(goRouterProvider)
        .go('/invite?token=${Uri.encodeQueryComponent(token)}');
  }
}
