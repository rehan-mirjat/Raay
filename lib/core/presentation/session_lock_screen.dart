import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../session/session_lock_provider.dart';
import '../theme/app_theme.dart';
import '../../core/theme/kivora_colors.dart';
import '../widgets/inline_error_banner.dart';
import '../../services/auth_service.dart';
import '../widgets/totp_challenge_dialog.dart';
import '../utils/friendly_error.dart';

/// The lock screen mounted where it is used: from MaterialApp.builder, which
/// sits ABOVE the app's Navigator. Nothing there provides an Overlay or a
/// Navigator, but the password field needs an Overlay (text selection handles,
/// toolbar) and the MFA challenge needs a Navigator to show its dialog. Without
/// them, focusing the field crashed with "Null check operator used on a null
/// value" in Overlay.of. A private single-route Navigator supplies both.
Widget sessionLockGate() => Navigator(
      onGenerateRoute: (_) => PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const SessionLockScreen(),
      ),
    );

/// Full-screen gate shown when the app was backgrounded or closed for
/// longer than [sessionIdleTimeout]. Blocks all app content until the
/// signed-in user re-proves their identity (or explicitly signs out),
/// reusing the same reauthenticate() flow already used for sensitive
/// server actions elsewhere in the app.
class SessionLockScreen extends ConsumerStatefulWidget {
  const SessionLockScreen({super.key});

  @override
  ConsumerState<SessionLockScreen> createState() => _SessionLockScreenState();
}

class _SessionLockScreenState extends ConsumerState<SessionLockScreen> {
  final _passwordController = TextEditingController();
  bool _isVerifying = false;
  bool _isSigningOut = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!_isGoogleUser && _passwordController.text.isEmpty) {
      setState(() => _error = 'Enter your password to continue.');
      return;
    }
    setState(() {
      _isVerifying = true;
      _error = null;
    });
    try {
      final authService = ref.read(authServiceProvider);
      await authService.reauthenticate(password: _passwordController.text);
      if (mounted) {
        ref.read(sessionLockProvider.notifier).unlock();
      }
    } on MfaRequiredException catch (e) {
      final credential = mounted
          ? await showTotpChallengeDialog(context, e.resolver)
          : null;
      if (!mounted) return;
      if (credential != null) {
        ref.read(sessionLockProvider.notifier).unlock();
      } else {
        setState(() => _isVerifying = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _isVerifying = false;
        });
      }
    }
  }

  Future<void> _signOutInstead() async {
    setState(() => _isSigningOut = true);
    await ref.read(authServiceProvider).signOut();
    // signOut() clears the Firebase session; the router's own redirect
    // will take it from here once authStateChangesProvider updates. Unlock
    // so this screen doesn't linger on top of the login screen.
    if (mounted) {
      ref.read(sessionLockProvider.notifier).unlock();
    }
  }

  bool get _isGoogleUser =>
      ref.read(authServiceProvider).currentUser?.providerData
          .any((p) => p.providerId == 'google.com') ??
      false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authServiceProvider).currentUser;
    final isGoogleUser = _isGoogleUser;
    final busy = _isVerifying || _isSigningOut;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.25)),
                    ),
                    child: Icon(Icons.lock_outline_rounded,
                        size: 32, color: KivoraColors.of(context).accentText),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome back',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For your security, please verify it\'s you to continue'
                    '${user?.email != null ? ' as ${user!.email}' : ''}.',
                    style: TextStyle(
                        fontSize: 14, color: KivoraColors.textSecondaryOf(context), height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  if (!isGoogleUser) ...[
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      autofocus: true,
                      enabled: !busy,
                      decoration: const InputDecoration(labelText: 'Password'),
                      onSubmitted: (_) => _verify(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_error != null) ...[
                    InlineErrorBanner(message: _error!),
                    const SizedBox(height: 16),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: busy ? null : _verify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isVerifying
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(isGoogleUser ? 'Verify with Google' : 'Verify'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: busy ? null : _signOutInstead,
                    child: _isSigningOut
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Sign out instead'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
