import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shown when signing in throws [FirebaseAuthMultiFactorException] - the
/// account has a TOTP second factor enrolled. Prompts for the current code
/// from the user's authenticator app and resolves sign-in with it. Returns
/// the completed [UserCredential], or null if the user cancelled.
Future<UserCredential?> showTotpChallengeDialog(
  BuildContext context,
  MultiFactorResolver resolver,
) async {
  final hint = resolver.hints.where((h) => h.factorId == 'totp').firstOrNull;
  if (hint == null) {
    // No TOTP factor among the hints - this account's second factor isn't
    // one this app issues a challenge for (e.g. phone), so there is nothing
    // to resolve here.
    return null;
  }

  final codeController = TextEditingController();
  bool isVerifying = false;
  String? dialogError;

  final credential = await showDialog<UserCredential>(
    context: context,
    // Can only be left via Cancel/Verify, never the barrier - a tap outside
    // while a verify call is in flight would otherwise pop the dialog and
    // the completed call would try to setState on a gone widget.
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) {
        Future<void> verify() async {
          final code = codeController.text.trim();
          if (code.length != 6) {
            setDialogState(() => dialogError = 'Enter the 6-digit code from your app.');
            return;
          }
          setDialogState(() {
            isVerifying = true;
            dialogError = null;
          });
          try {
            final assertion = await TotpMultiFactorGenerator.getAssertionForSignIn(
              hint.uid,
              code,
            );
            final result = await resolver.resolveSignIn(assertion);
            if (dialogContext.mounted) Navigator.of(dialogContext).pop(result);
          } on FirebaseAuthException catch (e) {
            if (!dialogContext.mounted) return;
            setDialogState(() {
              isVerifying = false;
              dialogError = e.code == 'invalid-verification-code'
                  ? 'That code is incorrect or expired. Try the latest code from your app.'
                  : (e.message ?? 'Could not verify that code.');
            });
          } catch (_) {
            if (!dialogContext.mounted) return;
            setDialogState(() {
              isVerifying = false;
              dialogError = 'Could not verify that code.';
            });
          }
        }

        return PopScope(
          canPop: !isVerifying,
          child: AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          scrollable: true,
          title: const Text('Two-factor verification'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter the 6-digit code from your authenticator app to finish signing in.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeController,
                  autofocus: true,
                  enabled: !isVerifying,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Verification code',
                    counterText: '',
                  ),
                  onSubmitted: (_) => verify(),
                ),
                if (dialogError != null) ...[
                  const SizedBox(height: 8),
                  Text(dialogError!,
                      style: const TextStyle(color: AppTheme.error)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isVerifying
                  ? null
                  : () => Navigator.of(dialogContext).pop(null),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isVerifying ? null : verify,
              child: isVerifying
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Verify'),
            ),
          ],
          ),
        );
      },
    ),
  );

  codeController.dispose();
  return credential;
}
