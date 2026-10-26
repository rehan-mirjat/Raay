import '../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_service.dart';
import '../utils/friendly_error.dart';
import '../theme/kivora_colors.dart';

/// Shows a dialog to re-prove identity (password re-entry, or a fresh Google
/// sign-in) and returns true once the server would accept a fresh
/// `auth_time`. The underlying session/app state is untouched either way -
/// this never signs the user out. Shared by every flow that can hit the
/// server's 900-second recent-authentication window (FR-10): publishing/
/// closing a voting event, etc.
Future<bool> showReauthDialog(
  BuildContext context,
  WidgetRef ref, {
  String? reason,
}) async {
  final authService = ref.read(authServiceProvider);
  final isGoogleUser = authService.currentUser?.providerData
          .any((p) => p.providerId == 'google.com') ??
      false;
  final passwordController = TextEditingController();
  bool isVerifying = false;
  String? dialogError;

  final result = await showDialog<bool>(
    context: context,
    // Can only be left via Cancel/Verify, never the barrier - a tap outside
    // while a verify call is in flight would otherwise pop the dialog and
    // the completed call would try to setState on a gone widget.
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) {
        Future<void> verify() async {
          setDialogState(() {
            isVerifying = true;
            dialogError = null;
          });
          try {
            await authService.reauthenticate(
              password: isGoogleUser ? null : passwordController.text,
            );
            if (dialogContext.mounted) Navigator.of(dialogContext).pop(true);
          } catch (e) {
            if (!dialogContext.mounted) return;
            setDialogState(() {
              isVerifying = false;
              dialogError = friendlyError(e);
            });
          }
        }

        return PopScope(
          // barrierDismissible: false blocks a tap outside, but not Android's
          // back button/gesture - block that too while a verify call is in
          // flight, for the same reason (a completed call shouldn't try to
          // act on a dialog that's already gone).
          canPop: !isVerifying,
          child: AlertDialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            scrollable: true,
            title: Text(AppLocalizations.of(context).raTitle),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reason ?? AppLocalizations.of(dialogContext).raReason),
                  const SizedBox(height: 16),
                  if (!isGoogleUser)
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      autofocus: true,
                      enabled: !isVerifying,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).raPassword),
                      onSubmitted: (_) => verify(),
                    ),
                  if (dialogError != null) ...[
                    const SizedBox(height: 8),
                    Text(dialogError!,
                        style: TextStyle(
                            color: KivoraColors.of(context).errorText)),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isVerifying
                    ? null
                    : () => Navigator.of(dialogContext).pop(false),
                child: Text(AppLocalizations.of(context).raCancel),
              ),
              ElevatedButton(
                onPressed: isVerifying ? null : verify,
                child: isVerifying
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(isGoogleUser
                        ? AppLocalizations.of(context).raGoogle
                        : AppLocalizations.of(context).raVerify),
              ),
            ],
          ),
        );
      },
    ),
  );

  passwordController.dispose();
  return result ?? false;
}
