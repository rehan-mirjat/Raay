import '../../l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/raay_colors.dart';
import '../../services/auth_service.dart';
import 'reauth_dialog.dart';

/// Walks the signed-in user through enrolling a TOTP (authenticator app)
/// second factor, and returns true once enrollment succeeds. Mirrors the
/// steps Firebase Auth's MultiFactor API requires: a fresh session (forcing
/// re-authentication if the last sign-in is more than 5 minutes old, which
/// the API itself enforces), a generated secret, then a verification code
/// from the app to prove the secret was actually captured before the
/// server commits the factor.
Future<bool> showTotpEnrollDialog(BuildContext context, WidgetRef ref) async {
  final authService = ref.read(authServiceProvider);
  final user = authService.currentUser;
  if (user == null) return false;

  MultiFactorSession session;
  try {
    session = await user.multiFactor.getSession();
  } on FirebaseAuthException catch (e) {
    if (e.code != 'requires-recent-login') rethrow;
    if (!context.mounted) return false;
    final reauthed = await showReauthDialog(
      context,
      ref,
      reason: AppLocalizations.of(context).teReason,
    );
    if (!reauthed || !context.mounted) return false;
    session = await user.multiFactor.getSession();
  }

  TotpSecret secret;
  String qrCodeUrl;
  try {
    secret = await TotpMultiFactorGenerator.generateSecret(session);
    qrCodeUrl = await secret.generateQrCodeUrl(
      accountName: user.email ?? user.uid,
      issuer: 'Raay',
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).teStartFailed)));
    }
    return false;
  }

  if (!context.mounted) return false;

  final codeController = TextEditingController();
  bool isVerifying = false;
  String? dialogError;

  final result = await showDialog<bool>(
    context: context,
    // Verification is multi-step and stateful (secret + code), so this
    // dialog can only be left via Cancel/Enable, never the barrier - a tap
    // outside while a verify call is in flight would otherwise pop the
    // dialog and the completed call would try to setState on a gone widget.
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) {
        Future<void> confirm() async {
          final code = codeController.text.trim();
          if (code.length != 6) {
            setDialogState(
                () => dialogError = AppLocalizations.of(context).teEnter6);
            return;
          }
          setDialogState(() {
            isVerifying = true;
            dialogError = null;
          });
          try {
            final assertion =
                await TotpMultiFactorGenerator.getAssertionForEnrollment(
                    secret, code);
            await user.multiFactor.enroll(
              assertion,
              displayName: 'Authenticator app',
            );
            if (dialogContext.mounted) Navigator.of(dialogContext).pop(true);
          } on FirebaseAuthException catch (e) {
            if (!dialogContext.mounted) return;
            setDialogState(() {
              isVerifying = false;
              dialogError = e.code == 'invalid-verification-code'
                  ? AppLocalizations.of(context).teBadCode
                  : (e.message ?? AppLocalizations.of(context).teVerifyFailed);
            });
          } catch (_) {
            if (!dialogContext.mounted) return;
            setDialogState(() {
              isVerifying = false;
              dialogError = AppLocalizations.of(context).teVerifyFailed;
            });
          }
        }

        return PopScope(
          canPop: !isVerifying,
          child: AlertDialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            title: Text(AppLocalizations.of(context).teTitle),
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).teStep1,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: RaayColors.borderOf(context)),
                        ),
                        child: QrImageView(
                          data: qrCodeUrl,
                          version: QrVersions.auto,
                          size: 180,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context).teManual,
                      style: TextStyle(
                          fontSize: 12,
                          color: RaayColors.textSecondaryOf(context)),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      secret.secretKey,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).teStep2,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: codeController,
                      autofocus: true,
                      enabled: !isVerifying,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).teCode,
                        counterText: '',
                      ),
                      onSubmitted: (_) => confirm(),
                    ),
                    if (dialogError != null) ...[
                      const SizedBox(height: 8),
                      Text(dialogError!,
                          style: TextStyle(
                              color: RaayColors.of(context).errorText)),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isVerifying
                    ? null
                    : () => Navigator.of(dialogContext).pop(false),
                child: Text(AppLocalizations.of(context).teCancel),
              ),
              ElevatedButton(
                onPressed: isVerifying ? null : confirm,
                child: isVerifying
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(AppLocalizations.of(context).teEnable),
              ),
            ],
          ),
        );
      },
    ),
  );

  codeController.dispose();
  return result ?? false;
}
