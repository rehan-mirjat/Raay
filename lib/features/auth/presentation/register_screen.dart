import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../../../core/widgets/ui_kit/raay_button.dart';
import '../../../core/widgets/ui_kit/raay_text_field.dart';
import 'package:raay/core/theme/raay_icons.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/auth_service.dart';
import 'widgets/auth_split_layout.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, this.onBackToLoginTap});

  final VoidCallback? onBackToLoginTap;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSuccess = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(authServiceProvider).register(
            email: _emailController.text,
            password: _passwordController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
          );

      // Immediately sign out to prevent auto-login bypass of verification/profile fetching
      await ref.read(authServiceProvider).signOut();

      if (mounted) {
        setState(() {
          _isSuccess = true;
          _isLoading = false;
        });
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
    if (_isSuccess) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle,
                    color: RaayColors.of(context).successText, size: 64),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context).rgDoneTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).rgDoneBody,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (widget.onBackToLoginTap != null) {
                      widget.onBackToLoginTap!();
                    } else {
                      setState(() {
                        _isSuccess = false;
                        _firstNameController.clear();
                        _lastNameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                      });
                    }
                  },
                  child: Text(AppLocalizations.of(context).rgReturn),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isMobile = ResponsiveLayout.isCompact(context);
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);

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
              elevation: isMobile ? 0 : 2,
              color: isMobile ? Colors.transparent : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
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
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/icon/app_icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      Text(
                        l10n.authRegisterTitle,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.authRegisterSubtitle,
                        style: TextStyle(color: kc.textSecondary, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 20 : 28),
                      AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final firstName = RaayTextField(
                                  label:
                                      AppLocalizations.of(context).rgFirstLabel,
                                  controller: _firstNameController,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.givenName
                                  ],
                                  hint:
                                      AppLocalizations.of(context).rgFirstHint,
                                  prefixIcon: RaayIcons.user,
                                  validator: (v) => Validators.required(
                                      v,
                                      AppLocalizations.of(context)
                                          .rgFirstField),
                                );
                                final lastName = RaayTextField(
                                  label:
                                      AppLocalizations.of(context).rgLastLabel,
                                  controller: _lastNameController,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [
                                    AutofillHints.familyName
                                  ],
                                  hint: AppLocalizations.of(context).rgLastHint,
                                  prefixIcon: RaayIcons.user,
                                  validator: (v) => Validators.required(v,
                                      AppLocalizations.of(context).rgLastField),
                                );
                                if (constraints.maxWidth < 400) {
                                  return Column(children: [
                                    firstName,
                                    const SizedBox(height: 14),
                                    lastName
                                  ]);
                                }
                                return Row(children: [
                                  Expanded(child: firstName),
                                  const SizedBox(width: 12),
                                  Expanded(child: lastName)
                                ]);
                              },
                            ),
                            const SizedBox(height: 16),
                            RaayTextField(
                              label: AppLocalizations.of(context).rgEmailLabel,
                              controller: _emailController,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              hint: AppLocalizations.of(context).rgEmailHint,
                              prefixIcon: RaayIcons.mail,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: 16),
                            RaayTextField(
                              label: AppLocalizations.of(context).rgPassword,
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              hint: '••••••••',
                              prefixIcon: RaayIcons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _obscurePassword
                                        ? RaayIcons.eyeOff
                                        : RaayIcons.eye,
                                    size: 20),
                                tooltip: _obscurePassword
                                    ? AppLocalizations.of(context)
                                        .authShowPassword
                                    : AppLocalizations.of(context)
                                        .authHidePassword,
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                              validator: Validators.password,
                            ),
                            const SizedBox(height: 16),
                            RaayTextField(
                              label: AppLocalizations.of(context).rgConfirm,
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              autofillHints: const [AutofillHints.newPassword],
                              hint: '••••••••',
                              prefixIcon: RaayIcons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _obscureConfirmPassword
                                        ? RaayIcons.eyeOff
                                        : RaayIcons.eye,
                                    size: 20),
                                tooltip: _obscureConfirmPassword
                                    ? AppLocalizations.of(context)
                                        .authShowPassword
                                    : AppLocalizations.of(context)
                                        .authHidePassword,
                                onPressed: () => setState(() =>
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword),
                              ),
                              validator: (v) => Validators.confirmPassword(
                                  v, _passwordController.text),
                            ),
                          ],
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 18),
                        InlineErrorBanner(message: _error!),
                      ],
                      SizedBox(height: isMobile ? 20 : 28),
                      RaayButton(
                        onPressed: _submit,
                        isLoading: _isLoading,
                        icon: RaayIcons.userPlus,
                        label: l10n.authCreateAccount,
                      ),
                      SizedBox(height: isMobile ? 20 : 28),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(l10n.authHaveAccount,
                                style: TextStyle(
                                    color: kc.textSecondary, fontSize: 14)),
                            TextButton(
                              style: TextButton.styleFrom(
                                  minimumSize: const Size(48, 48)),
                              onPressed: widget.onBackToLoginTap,
                              child: Text(l10n.authSignIn,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
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
