import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/reauth_dialog.dart';
import '../../../core/widgets/totp_enroll_dialog.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_service.dart'; // Needed for sanitizeStorageUrl
import '../data/user_repository.dart';
import '../domain/app_user.dart';
import 'widgets/change_password_section.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen(
      {super.key, required this.uid, this.initialTab = 0, this.onSignOut});

  final String uid;
  final int initialTab;
  final VoidCallback? onSignOut;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  late int _selectedIndex;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  bool _initialized = false;
  bool _isMfaBusy = false;
  String? _error;
  String? _successMessage;
  String? _uploadedPhotoUrl;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _selectedIndex = widget.initialTab;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _enableTwoFactor() async {
    setState(() => _isMfaBusy = true);
    final messenger = ScaffoldMessenger.of(context);
    final enabled = await showTotpEnrollDialog(context, ref);
    if (!mounted) return;
    setState(() => _isMfaBusy = false);
    if (enabled) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Two-factor authentication is now enabled.')));
    }
  }

  Future<void> _disableTwoFactor(MultiFactorInfo factor) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Turn off two-factor authentication?'),
        content: const Text(
            'Your account will no longer require a code from your authenticator app to sign in.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Turn off'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isMfaBusy = true);
    try {
      final authUser = ref.read(authServiceProvider).currentUser;
      if (authUser == null) return;
      try {
        await authUser.multiFactor.unenroll(multiFactorInfo: factor);
      } on FirebaseAuthException catch (e) {
        if (e.code != 'requires-recent-login') rethrow;
        if (!mounted) return;
        final reauthed = await showReauthDialog(
          context,
          ref,
          reason:
              'Turning off two-factor authentication requires you to have signed '
              'in recently. Please verify your identity to continue.',
        );
        if (!reauthed) return;
        await authUser.multiFactor.unenroll(multiFactorInfo: factor);
      }
      if (mounted) {
        messenger.showSnackBar(const SnackBar(
            content: Text('Two-factor authentication is now disabled.')));
      }
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Could not disable two-factor authentication.')));
    } finally {
      if (mounted) setState(() => _isMfaBusy = false);
    }
  }

  void _populateControllers(AppUser user) {
    if (!_initialized && !_isEditing) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _phoneNumberController.text = user.phoneNumber ?? '';
      _initialized = true;
    }
  }

  Future<void> _pickAndUploadImage() async {
    setState(() {
      _isUploadingPhoto = true;
      _error = null;
    });

    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (file != null) {
        final extension = _imageExtension(file.mimeType, file.name);
        if (extension == null) {
          throw Exception('Choose a JPEG, PNG, or WebP image.');
        }
        final bytes = await file.readAsBytes();
        final photoUrl =
            await ref.read(userRepositoryProvider).uploadProfilePhoto(
                  uid: widget.uid,
                  imageBytes: bytes,
                  fileExtension: extension,
                );
        ref.invalidate(userProfileProvider(widget.uid));
        if (mounted) {
          setState(() {
            _uploadedPhotoUrl = photoUrl;
            _successMessage = 'Profile photo updated!';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error =
              'Failed to upload image: ${e.toString().replaceAll('Exception: ', '')}';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  String? _imageExtension(String? mimeType, String name) {
    final mime = mimeType?.toLowerCase();
    final lowerName = name.toLowerCase();
    if (mime == 'image/jpeg' ||
        mime == 'image/jpg' ||
        lowerName.endsWith('.jpg') ||
        lowerName.endsWith('.jpeg')) {
      return 'jpg';
    }
    if (mime == 'image/png' || lowerName.endsWith('.png')) return 'png';
    if (mime == 'image/webp' || lowerName.endsWith('.webp')) return 'webp';
    return null;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = null;
      _successMessage = null;
    });

    try {
      await ref.read(userRepositoryProvider).updateProfile(
            uid: widget.uid,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            phoneNumber: _phoneNumberController.text,
          );

      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
          _successMessage = 'Profile updated successfully!';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to update profile: ${e.toString()}';
          _isSaving = false;
        });
      }
    }
  }

  void _confirmDeleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.error),
            SizedBox(width: 8),
            Text('Delete Account?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to permanently delete your account?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone. Your user profile will be permanently deleted and you will lose access to all associated organizations.',
              style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(authServiceProvider).deleteAccount();
      } catch (e) {
        if (mounted) {
          setState(() {
            _error = 'Failed to delete account: $e';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider(widget.uid));

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryNavy,
                      ),
                ),
                const SizedBox(height: 20),
                userAsync.when(
                  loading: () =>
                      const LoadingView(message: 'Loading user profile...'),
                  error: (err, stack) => ErrorView(
                    type: ErrorViewType.generic,
                    message: 'Error loading profile: $err',
                    onRetry: () =>
                        ref.invalidate(userProfileProvider(widget.uid)),
                  ),
                  data: (user) {
                    if (user == null) {
                      return const ErrorView(
                          type: ErrorViewType.generic,
                          message: 'User profile not found.');
                    }

                    _populateControllers(user);

                    final isDesktop = ResponsiveLayout.isWide(context);

                    if (isDesktop) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 240,
                            child: _buildSidebar(context),
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            child: _selectedIndex == 0
                                ? _buildProfileView(context, user)
                                : _buildSecurityView(context, user),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMobileTabs(context),
                        const SizedBox(height: 24),
                        _selectedIndex == 0
                            ? _buildProfileView(context, user)
                            : _buildSecurityView(context, user),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSidebarItem(
          icon: Icons.person_outline_rounded,
          title: 'Profile',
          isSelected: _selectedIndex == 0,
          onTap: () => setState(() => _selectedIndex = 0),
        ),
        const SizedBox(height: 8),
        _buildSidebarItem(
          icon: Icons.security_outlined,
          title: 'Security & Settings',
          isSelected: _selectedIndex == 1,
          onTap: () => setState(() => _selectedIndex = 1),
        ),
      ],
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? AppTheme.primaryBlue : AppTheme.secondaryNavy;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTabs(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMobileTabItem(
              title: 'Profile',
              isSelected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),
          ),
          Container(width: 1, height: 24, color: AppTheme.borderLight),
          Expanded(
            child: _buildMobileTabItem(
              title: 'Security',
              isSelected: _selectedIndex == 1,
              onTap: () => setState(() => _selectedIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, AppUser user) {
    final authUser = ref.watch(authServiceProvider).currentUser;
    final photoUrl = _uploadedPhotoUrl ?? user.photoUrl ?? authUser?.photoURL;
    // Live Auth state, not the Firestore `emailVerified` field - that field is only
    // ever written once at registration and never updated again, so it goes stale
    // the moment a user actually verifies their email after signing up.
    final isEmailVerified = authUser?.emailVerified ?? false;
    final dateFormat = DateFormat('MMMM d, yyyy');

    final sanitizedPhotoUrl = FirebaseService.sanitizeStorageUrl(photoUrl);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Profile Avatar Header Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: AppTheme.surfaceBlue,
                      backgroundImage: sanitizedPhotoUrl.isNotEmpty
                          ? NetworkImage(sanitizedPhotoUrl)
                          : null,
                      child: sanitizedPhotoUrl.isEmpty
                          ? Text(
                              user.firstName.isNotEmpty
                                  ? user.firstName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _isUploadingPhoto ? null : _pickAndUploadImage,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: _isUploadingPhoto
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  size: 14,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryNavy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isEmailVerified
                                  ? AppTheme.success.withValues(alpha: 0.12)
                                  : AppTheme.warning.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isEmailVerified ? 'VERIFIED' : 'UNVERIFIED',
                              style: TextStyle(
                                color: isEmailVerified
                                    ? AppTheme.success
                                    : AppTheme.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: user.status == 'active'
                                  ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                                  : AppTheme.warning.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.status.toUpperCase(),
                              style: TextStyle(
                                color: user.status == 'active'
                                    ? AppTheme.primaryBlue
                                    : AppTheme.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Member since ${dateFormat.format(user.createdAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (_successMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    color: AppTheme.success, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _successMessage!,
                    style: const TextStyle(
                      color: AppTheme.success,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (_error != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppTheme.error, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: AppTheme.error, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Personal Information Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryNavy,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Manage your basic profile information.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isEditing)
                        OutlinedButton.icon(
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                          ),
                          onPressed: () => setState(() => _isEditing = true),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('FIRST NAME',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: AppTheme.secondaryNavy,
                                    letterSpacing: 0.5)),
                            const SizedBox(height: 6),
                            _isEditing
                                ? TextFormField(
                                    controller: _firstNameController,
                                    decoration: const InputDecoration(
                                        hintText: 'First Name'),
                                    validator: (v) =>
                                        Validators.required(v, 'First Name'),
                                  )
                                : Text(user.firstName,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('LAST NAME',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: AppTheme.secondaryNavy,
                                    letterSpacing: 0.5)),
                            const SizedBox(height: 6),
                            _isEditing
                                ? TextFormField(
                                    controller: _lastNameController,
                                    decoration: const InputDecoration(
                                        hintText: 'Last Name'),
                                    validator: (v) =>
                                        Validators.required(v, 'Last Name'),
                                  )
                                : Text(user.lastName,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('EMAIL ADDRESS',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: AppTheme.secondaryNavy,
                              letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      Text(user.email,
                          style: const TextStyle(
                              fontSize: 15, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PHONE NUMBER',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: AppTheme.secondaryNavy,
                              letterSpacing: 0.5)),
                      const SizedBox(height: 6),
                      _isEditing
                          ? TextFormField(
                              controller: _phoneNumberController,
                              decoration: const InputDecoration(
                                  hintText: '+1 (555) 000-0000'),
                              keyboardType: TextInputType.phone,
                            )
                          : Text(
                              user.phoneNumber?.isNotEmpty == true
                                  ? user.phoneNumber!
                                  : 'Not provided',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: user.phoneNumber?.isNotEmpty == true
                                      ? AppTheme.secondaryNavy
                                      : AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500)),
                    ],
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                              _firstNameController.text = user.firstName;
                              _lastNameController.text = user.lastName;
                              _phoneNumberController.text =
                                  user.phoneNumber ?? '';
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Text('Save Changes'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityView(BuildContext context, AppUser user) {
    final authUser = ref.watch(authServiceProvider).currentUser;
    final hasPasswordProvider =
        authUser?.providerData.any((info) => info.providerId == 'password') ??
            false;
    final hasGoogleProvider =
        authUser?.providerData.any((info) => info.providerId == 'google.com') ??
            false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          color: AppTheme.surfaceBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppTheme.primaryBlue.withValues(alpha: 0.2),
              width: 1.2,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: AppTheme.primaryBlue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Account Security',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryNavy,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Your Kivora account controls access to your organizations and voting administration features.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppTheme.secondaryNavy,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Voting choices and cryptographic ballot receipts are NOT displayed or editable from your profile to maintain absolute secrecy.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Security Section
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Security',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryNavy,
                  ),
                ),
                const SizedBox(height: 20),

                const Text('AUTHENTICATION METHOD',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: AppTheme.secondaryNavy,
                        letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text(
                  hasGoogleProvider && hasPasswordProvider
                      ? 'Email/Password + Google'
                      : hasGoogleProvider
                          ? 'Google Sign-In'
                          : 'Email & Password',
                  style: const TextStyle(fontSize: 15),
                ),

                const SizedBox(height: 20),

                // Password Management
                const Text('PASSWORD',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: AppTheme.secondaryNavy,
                        letterSpacing: 0.5)),
                const SizedBox(height: 8),
                if (hasPasswordProvider)
                  const ChangePasswordSection()
                else
                  const Text('Managed securely through Google Sign-In.',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),

                const SizedBox(height: 24),
                const Divider(height: 1),
                const SizedBox(height: 24),

                // Two-Factor Authentication
                const Text('TWO-FACTOR AUTHENTICATION (2FA)',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: AppTheme.secondaryNavy,
                        letterSpacing: 0.5)),
                const SizedBox(height: 12),
                if (authUser != null && hasPasswordProvider)
                  FutureBuilder<List<MultiFactorInfo>>(
                    future: authUser.multiFactor.getEnrolledFactors(),
                    builder: (context, snapshot) {
                      final factors = snapshot.data ?? const [];
                      final is2FAEnabled = factors.isNotEmpty;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  is2FAEnabled ? 'Enabled' : 'Disabled',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: is2FAEnabled
                                          ? AppTheme.success
                                          : AppTheme.textSecondary),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Require a code from an authenticator app when signing in.',
                                  style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          if (snapshot.connectionState ==
                              ConnectionState.waiting || _isMfaBusy)
                            const SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            Switch(
                              value: is2FAEnabled,
                              onChanged: (value) => value
                                  ? _enableTwoFactor()
                                  : _disableTwoFactor(factors.first),
                            ),
                        ],
                      );
                    },
                  )
                else
                  Text(
                    hasPasswordProvider
                        ? 'Sign in required to manage two-factor authentication.'
                        : 'Two-factor authentication is available for accounts signed in with a password.',
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Danger Zone
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Danger Zone',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.error),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Permanently delete your user account and profile data.',
                  style: TextStyle(
                      fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete_forever_rounded, size: 16),
                  label: const Text('Delete Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 38),
                  ),
                  onPressed: () => _confirmDeleteAccount(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
