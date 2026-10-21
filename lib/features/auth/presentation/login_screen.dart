import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../../../core/widgets/totp_challenge_dialog.dart';
import '../../../core/widgets/ui_kit/kivora_button.dart';
import '../../../core/widgets/ui_kit/kivora_text_field.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/auth_service.dart';
import 'email_verification_screen.dart';
import 'widgets/auth_split_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
    this.onRegisterTap,
    this.onForgotPasswordTap,
    this.onAuthenticated,
  });

  final VoidCallback? onRegisterTap;
  final VoidCallback? onForgotPasswordTap;
  final VoidCallback? onAuthenticated;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  bool _obscurePassword = true;
  bool _requiresEmailVerification = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _requiresEmailVerification = false;
    });

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        // Enforce Email Verification Gate
        if (!authService.isEmailVerified) {
          setState(() {
            _requiresEmailVerification = true;
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
          if (widget.onAuthenticated != null) {
            widget.onAuthenticated!();
          }
        }
      }
    } on FirebaseAuthMultiFactorException catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;

      final hasTotpHint = e.resolver.hints.any((h) => h.factorId == 'totp');
      if (!hasTotpHint) {
        setState(() => _error = AppLocalizations.of(context).authMfaUnsupported);
        return;
      }

      final credential = await showTotpChallengeDialog(context, e.resolver);
      if (!mounted || credential?.user == null) return;

      // getIdToken only refreshes claims/token, not the cached emailVerified
      // flag - reload() is what every other sign-in path in this app uses
      // (see auth_service.dart) to get a fresh value before gating on it.
      await credential!.user!.reload();
      if (!mounted) return;
      final isVerified = ref.read(authServiceProvider).isEmailVerified;
      setState(() => _requiresEmailVerification = !isVerified);
      if (isVerified) widget.onAuthenticated?.call();
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _error = mapFirebaseAuthError(e);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context).authUnexpectedError;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _googleSignIn() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final cred = await authService.signInWithGoogle();

      if (!mounted) return;
      setState(() => _isLoading = false);
      // cred == null means the user cancelled: stay on the screen silently.
      if (cred != null) widget.onAuthenticated?.call();
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _error = mapFirebaseAuthError(e);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context).authUnexpectedError;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_requiresEmailVerification) {
      return EmailVerificationScreen(
        onVerified: () {
          setState(() => _requiresEmailVerification = false);
          if (widget.onAuthenticated != null) {
            widget.onAuthenticated!();
          }
        },
        onSignOut: () {
          setState(() {
            _requiresEmailVerification = false;
            _passwordController.clear();
          });
        },
      );
    }

    final isMobile = ResponsiveLayout.isCompact(context);
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);

    return AuthSplitLayout(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 16 : 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: isMobile ? 0 : 2,
              color: isMobile ? Colors.transparent : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                side: isMobile
                    ? BorderSide.none
                    : BorderSide(color: kc.border),
              ),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(
                              0), // Removed padding to let the icon fill the space
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(
                                18), // Match standard app icon squircle
                          ),
                          clipBehavior: Clip
                              .antiAlias, // Ensure image conforms to the shape
                          child: Image.asset(
                            'assets/icon/app_icon.png', // Switched to the main square icon for the card logo
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      Text(
                        l10n.authSignInTitle,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.authSignInSubtitle,
                        style: TextStyle(color: kc.textSecondary, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 20 : 28),
                      AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            KivoraTextField(
                              label: l10n.authEmail,
                              controller: _emailController,
                              hint: 'user@email.com',
                              prefixIcon: KivoraIcons.mail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              validator: Validators.email,
                            ),
                            const SizedBox(height: 16),
                            KivoraTextField(
                              label: l10n.authPassword,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              autofillHints: const [AutofillHints.password],
                              hint: '••••••••',
                              prefixIcon: KivoraIcons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _obscurePassword
                                        ? KivoraIcons.eyeOff
                                        : KivoraIcons.eye,
                                    size: 20),
                                tooltip: _obscurePassword
                                    ? l10n.authShowPassword
                                    : l10n.authHidePassword,
                                onPressed: () => setState(() =>
                                    _obscurePassword = !_obscurePassword),
                              ),
                              validator: Validators.password,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onForgotPasswordTap,
                          style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                          child: Text(l10n.authForgotPassword,
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        InlineErrorBanner(message: _error!),
                      ],
                      SizedBox(height: isMobile ? 20 : 24),
                      KivoraButton(
                        onPressed: _submit,
                        isLoading: _isLoading,
                        icon: KivoraIcons.shieldCheck,
                        label: l10n.authSignInButton,
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(l10n.authOr,
                                style: TextStyle(
                                    color: kc.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      KivoraButton(
                        type: KivoraButtonType.secondary,
                        onPressed: _isLoading ? null : _googleSignIn,
                        icon: null,
                        label: l10n.authContinueWithGoogle,
                      ),
                      SizedBox(height: isMobile ? 20 : 28),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(l10n.authNewUser,
                                style: TextStyle(color: kc.textSecondary, fontSize: 14)),
                            TextButton(
                              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                              onPressed: widget.onRegisterTap,
                              child: Text(l10n.authCreateAccount,
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
