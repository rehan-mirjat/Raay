import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/auth_service.dart';
import 'widgets/auth_split_layout.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.onBackToLoginTap});

  final VoidCallback? onBackToLoginTap;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  int _cooldownSeconds = 0;
  Timer? _timer;
  String? _error;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _cooldownSeconds > 0) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref
          .read(authServiceProvider)
          .sendPasswordResetEmail(_emailController.text);
      if (mounted) {
        setState(() {
          _isSubmitted = true;
          _isLoading = false;
        });
        _startCooldown(30);
      }
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
    final isMobile = ResponsiveLayout.isCompact(context);
    final kc = KivoraColors.of(context);

    return AuthSplitLayout(
      onMobileBackTap: widget.onBackToLoginTap,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 24,
            vertical: isMobile ? 16 : 32,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 0,
              color: isMobile ? Colors.transparent : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isMobile ? BorderSide.none : BorderSide(color: kc.border),
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
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue
                                    .withValues(alpha: 0.15),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icon/app_icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      Text(
                        AppLocalizations.of(context).fpTitle,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context).fpBody,
                        style: TextStyle(
                            color: kc.textSecondary, fontSize: 13, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 20 : 28),
                      if (_isSubmitted) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppTheme.success.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: KivoraColors.of(context).successText),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context).fpSent,
                                  style: TextStyle(
                                      color:
                                          KivoraColors.of(context).successText,
                                      fontSize: 13,
                                      height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(AppLocalizations.of(context).fpEmail,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      color: kc.textPrimary,
                                      letterSpacing: 0.5)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _submit(),
                                autofillHints: const [AutofillHints.email],
                                decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(context).fpEmailHint,
                                  prefixIcon: const Icon(Icons.email_outlined,
                                      size: 20),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.email,
                              ),
                            ],
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          InlineErrorBanner(message: _error!),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: (_isLoading || _cooldownSeconds > 0)
                              ? null
                              : _submit,
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.shield_outlined, size: 18),
                          label: Text(_cooldownSeconds > 0
                              ? AppLocalizations.of(context)
                                  .fpCooldown(_cooldownSeconds.toString())
                              : AppLocalizations.of(context).fpSend),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context).authRemembered,
                                style: TextStyle(
                                    color: kc.textSecondary, fontSize: 14)),
                            TextButton(
                              style: TextButton.styleFrom(
                                  minimumSize: const Size(48, 48)),
                              onPressed: widget.onBackToLoginTap,
                              child: Text(
                                  AppLocalizations.of(context).authSignIn,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
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
