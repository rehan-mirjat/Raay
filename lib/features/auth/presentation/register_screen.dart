import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/google_g_logo.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../../../services/auth_service.dart';
import 'widgets/auth_split_layout.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen(
      {super.key, this.onBackToLoginTap, this.onAuthenticated});

  final VoidCallback? onBackToLoginTap;

  /// Called after a successful Google sign-in / sign-up (user is already signed in).
  final VoidCallback? onAuthenticated;

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
          _error = e.toString().replaceAll('Exception: ', '');
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
      // The user is now signed in, so send them onward, NOT back to login.
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
          _error = e.toString().replaceAll('Exception: ', '');
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
                const Icon(Icons.check_circle,
                    color: AppTheme.success, size: 64),
                const SizedBox(height: 24),
                Text(
                  'Registration Successful',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Kivora identity has been securely generated. You may now sign in using your credentials.',
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
                  child: const Text('Return to Login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                        'Join Kivora',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create your platform identity to vote securely.',
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
                                final firstName = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('FIRST NAME',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                            color: kc.textPrimary,
                                            letterSpacing: 0.5)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _firstNameController,
                                      textInputAction: TextInputAction.next,
                                      autofillHints: const [
                                        AutofillHints.givenName
                                      ],
                                      decoration: const InputDecoration(
                                          hintText: 'First',
                                          prefixIcon: Icon(Icons.person_outline,
                                              size: 20)),
                                      validator: (v) =>
                                          Validators.required(v, 'First Name'),
                                    ),
                                  ],
                                );
                                final lastName = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('LAST NAME',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                            color: kc.textPrimary,
                                            letterSpacing: 0.5)),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _lastNameController,
                                      textInputAction: TextInputAction.next,
                                      autofillHints: const [
                                        AutofillHints.familyName
                                      ],
                                      decoration: const InputDecoration(
                                          hintText: 'Last',
                                          prefixIcon: Icon(Icons.person_outline,
                                              size: 20)),
                                      validator: (v) =>
                                          Validators.required(v, 'Last Name'),
                                    ),
                                  ],
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
                            Text('EMAIL ADDRESS',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: kc.textPrimary,
                                    letterSpacing: 0.5)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              decoration: const InputDecoration(
                                  hintText: 'user@email.com',
                                  prefixIcon:
                                      Icon(Icons.email_outlined, size: 20)),
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                            ),
                            const SizedBox(height: 16),
                            Text('PASSWORD',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: kc.textPrimary,
                                    letterSpacing: 0.5)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon:
                                    const Icon(Icons.lock_outline, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20),
                                  tooltip: _obscurePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: Validators.password,
                            ),
                            const SizedBox(height: 16),
                            Text('CONFIRM PASSWORD',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: kc.textPrimary,
                                    letterSpacing: 0.5)),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                prefixIcon:
                                    const Icon(Icons.lock_outline, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20),
                                  tooltip: _obscureConfirmPassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () => setState(() =>
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword),
                                ),
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
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submit,
                        icon: _isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.shield_outlined, size: 18),
                        label: Text(_isLoading
                            ? 'Creating Identity...'
                            : 'Create Identity Securely'),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('OR',
                                style: TextStyle(
                                    color: kc.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _googleSignIn,
                        icon: const GoogleGLogo(size: 18),
                        label: const Text('Continue with Google'),
                      ),
                      SizedBox(height: isMobile ? 20 : 28),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  color: kc.textSecondary, fontSize: 13),
                            ),
                            GestureDetector(
                              onTap: widget.onBackToLoginTap,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
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
