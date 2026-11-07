import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Attestation is opt-in until platform registration and staging validation.
/// Activation errors propagate to startup; enabled builds never silently downgrade.
class AppCheckService {
  static bool _activated = false;

  static void validateConfiguration(
      {required bool enabled,
      required bool emulator,
      required bool web,
      required bool release,
      required bool debugProvider,
      required String webSiteKey}) {
    if (!enabled || emulator) return;
    if (release && debugProvider) {
      throw StateError(
          'App Check debug providers are forbidden in release builds.');
    }
    if (web && webSiteKey.trim().isEmpty) {
      throw StateError(
          'APP_CHECK_WEB_SITE_KEY is required when web App Check is enabled.');
    }
  }

  static Future<void> initialize({required bool emulator}) async {
    const enabled =
        bool.fromEnvironment('APP_CHECK_ENABLED', defaultValue: false);
    const debugProvider =
        bool.fromEnvironment('APP_CHECK_DEBUG', defaultValue: false);
    const webKey = String.fromEnvironment('APP_CHECK_WEB_SITE_KEY');
    validateConfiguration(
        enabled: enabled,
        emulator: emulator,
        web: kIsWeb,
        release: kReleaseMode,
        debugProvider: debugProvider,
        webSiteKey: webKey);
    if (!enabled || emulator || _activated) return;
    if (!kIsWeb &&
        ![TargetPlatform.android, TargetPlatform.iOS, TargetPlatform.macOS]
            .contains(defaultTargetPlatform)) {
      throw UnsupportedError('App Check is not configured for this platform.');
    }
    await FirebaseAppCheck.instance.activate(
      webProvider: kIsWeb ? ReCaptchaEnterpriseProvider(webKey) : null,
      androidProvider:
          debugProvider ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: debugProvider
          ? AppleProvider.debug
          : AppleProvider.appAttestWithDeviceCheckFallback,
    );
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
    _activated = true;
  }
}
