import '../../../l10n/app_localizations.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../../../services/auth_service.dart';

String _friendlyAuthError(Object e) => e is FirebaseAuthException
    ? mapFirebaseAuthError(e)
    : 'Something went wrong. Please try again.';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key, this.onVerified, this.onSignOut});

  final VoidCallback? onVerified;
  final VoidCallback? onSignOut;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _isChecking = false;
  bool _isResending = false;
  int _cooldownSeconds = 0;
  Timer? _timer;
  String? _message;
  String? _error;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown([int seconds = 30]) {
    setState(() => _cooldownSeconds = seconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_cooldownSeconds > 1) {
          setState(() => _cooldownSeconds--);
        } else {
          _timer?.cancel();
          setState(() => _cooldownSeconds = 0);
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _checkStatus() async {
    setState(() {
      _isChecking = true;
      _message = null;
      _error = null;
    });

    try {
      final isVerified =
          await ref.read(authServiceProvider).checkEmailVerified();
      if (mounted) {
        if (isVerified) {
          setState(() {
            _message = AppLocalizations.of(context).evOk;
            _isChecking = false;
          });
          if (widget.onVerified != null) {
            widget.onVerified!();
          }
        } else {
          setState(() {
            _error = AppLocalizations.of(context).evNot;
            _isChecking = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)
              .evCheckFailed((_friendlyAuthError(e)).toString());
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _resendEmail() async {
    if (_cooldownSeconds > 0) return;

    setState(() {
      _isResending = true;
      _message = null;
      _error = null;
    });

    try {
      await ref.read(authServiceProvider).sendEmailVerification();
      if (mounted) {
        setState(() {
          _message = AppLocalizations.of(context).evResent;
          _isResending = false;
        });
        _startCooldown(30);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context)
              .evResendFailed((_friendlyAuthError(e)).toString());
          _isResending = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    await ref.read(authServiceProvider).signOut();
    if (widget.onSignOut != null) {
      widget.onSignOut!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = ref.watch(authServiceProvider).currentUser?.email ??
        AppLocalizations.of(context).evYourEmail;
    final kc = KivoraColors.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).evTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: AppLocalizations.of(context).evSignOut,
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.mark_email_unread_outlined,
                  size: 72,
                  color: kc.accentText,
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context).evHeading,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kc.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context).evSent(userEmail.toString()),
                  style: TextStyle(
                    color: kc.textSecondary,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).evClick,
                  style: TextStyle(
                    color: kc.textSecondary,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (_message != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppTheme.success.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: kc.successText),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(_message!,
                              style: TextStyle(color: kc.successText)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_error != null) ...[
                  InlineErrorBanner(message: _error!),
                  const SizedBox(height: 16),
                ],
                ElevatedButton.icon(
                  onPressed: _isChecking ? null : _checkStatus,
                  icon: _isChecking
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: const Text("I've Verified My Email"),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: (_isResending || _cooldownSeconds > 0)
                      ? null
                      : _resendEmail,
                  icon: _isResending
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_outlined),
                  label: Text(_cooldownSeconds > 0
                      ? AppLocalizations.of(context)
                          .evCooldown(_cooldownSeconds.toString())
                      : AppLocalizations.of(context).evResend),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: _signOut,
                  child: Text(AppLocalizations.of(context).evSwitch),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
