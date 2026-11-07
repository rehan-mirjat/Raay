import 'dart:io' show Platform;
import 'dart:ui' show PlatformDispatcher;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/accessibility_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/locale_provider.dart';
import 'core/theme/theme_provider.dart';
import 'l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/deep_link/deep_link_handler.dart';
import 'core/presentation/session_lock_screen.dart';
import 'core/presentation/splash_screen.dart';
import 'core/theme/raay_colors.dart';
import 'core/session/session_lock_provider.dart';
import 'features/organizations/presentation/providers/organization_providers.dart';
import 'features/onboarding/providers/onboarding_providers.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/firebase_service.dart';
import 'services/app_check_service.dart';
import 'core/updates/app_update_gate.dart';

import 'core/theme/fallback_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fix Flutter Web debug assertion when Google Fonts finish downloading during frame microtasks
  if (kIsWeb) {
    GoogleFonts.config.allowRuntimeFetching = true;
  }

  // Linux Desktop is not officially supported by firebase_core native plugins natively in this project.
  if (!kIsWeb && Platform.isLinux) {
    runApp(const UnsupportedPlatformApp());
    return;
  }

  String? initError;
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    }
    await FirebaseService.initialize();
    await AppCheckService.initialize(emulator: FirebaseService.isEmulatorMode);
    await _initCrashlytics();
  } catch (e) {
    debugPrint('Startup failed: $e');
    initError = 'Raay could not start. Check your connection and try again.';
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: SecureEVotingApp(initializationError: initError),
  ));
}

/// firebase_crashlytics has no web implementation, so crash reporting is
/// Android/iOS/macOS only. Routes both Flutter framework errors and
/// otherwise-uncaught Dart errors to Crashlytics; safe to call more than
/// once (e.g. after a successful retry) since it only overwrites the
/// handlers with themselves.
Future<void> _initCrashlytics() async {
  if (kIsWeb) return;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

class SecureEVotingApp extends ConsumerStatefulWidget {
  final String? initializationError;

  const SecureEVotingApp({super.key, this.initializationError});

  @override
  ConsumerState<SecureEVotingApp> createState() => _SecureEVotingAppState();
}

class _SecureEVotingAppState extends ConsumerState<SecureEVotingApp>
    with WidgetsBindingObserver {
  String? _initError;
  bool _isRetrying = false;
  DeepLinkHandler? _deepLinkHandler;

  @override
  void initState() {
    super.initState();
    _initError = widget.initializationError;
    WidgetsBinding.instance.addObserver(this);
    if (_initError == null) {
      _deepLinkHandler = DeepLinkHandler(ref)..start();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deepLinkHandler?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // `inactive` is often just a brief transient (e.g. a system dialog or
    // notification shade on iOS) - only paused/detached mean the app has
    // actually left the foreground, which is what "closed" means here.
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.read(sessionLockProvider.notifier).recordBackgrounded();
      case AppLifecycleState.resumed:
        ref.read(sessionLockProvider.notifier).checkOnResume();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  Future<void> _retryInitialization() async {
    setState(() {
      _isRetrying = true;
      _initError = null;
    });

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      await FirebaseService.initialize();
      await AppCheckService.initialize(emulator: FirebaseService.isEmulatorMode);
      await _initCrashlytics();
      _deepLinkHandler ??= DeepLinkHandler(ref)..start();
      setState(() {
        _isRetrying = false;
      });
    } catch (e) {
      setState(() {
        debugPrint('Retry failed: $e');
        _initError = 'Raay could not start. Check your connection and try again.';
        _isRetrying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null || _isRetrying) {
      return MaterialApp(
        title: 'Raay',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: SplashScreen(
          errorMessage: _initError,
          onRetry: _retryInitialization,
        ),
      );
    }

    final goRouter = ref.watch(goRouterProvider);
    final brandColors = ref
        .watch(activeOrganizationContextProvider)
        .valueOrNull
        ?.context
        ?.organization
        .brandColors;

    final isLocked = ref.watch(sessionLockProvider);
    final hasSignedInUser = ref.watch(authStateChangesProvider).valueOrNull != null;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final reducedMotion = ref.watch(reducedMotionProvider);
    final highContrast = ref.watch(highContrastProvider);

    var lightTheme = AppTheme.withOrganizationBranding(AppTheme.lightTheme, brandColors);
    var darkTheme = AppTheme.withOrganizationBranding(AppTheme.darkTheme, brandColors);
    if (highContrast) {
      lightTheme = AppTheme.withHighContrast(lightTheme);
      darkTheme = AppTheme.withHighContrast(darkTheme);
    }

    return MaterialApp.router(
      title: 'Raay',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        const FallbackMaterialLocalizationDelegate(),
        const FallbackCupertinoLocalizationDelegate(),
        const FallbackWidgetsLocalizationDelegate(),
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: goRouter,
      builder: (context, child) {
        // The app was backgrounded/closed past the idle timeout - block all
        // content behind a re-authentication gate until it's cleared. Only
        // applies when someone is actually signed in; an already-signed-out
        // user just sees the normal /login redirect.
        Widget content = isLocked && hasSignedInUser
            ? sessionLockGate()
            : (child ?? const SizedBox.shrink());

        // Package C3: "Reduce motion" is a user preference layered on top of
        // the OS-level signal MediaQuery already carries, since that signal
        // isn't exposed on every platform this app targets.
        if (reducedMotion) {
          final mq = MediaQuery.of(context);
          content = MediaQuery(
            data: mq.copyWith(disableAnimations: true),
            child: content,
          );
        }
        return ColoredBox(color: RaayColors.backgroundOf(context),
            child: AppUpdateGate(child: content));
      },
    );
  }
}

class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raay',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Linux Desktop is not supported for Firebase in this project.\n\nPlease run the app using Flutter Web (Chrome) or an Android/iOS Emulator.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade800, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
