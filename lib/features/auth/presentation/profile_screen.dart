import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/theme/kivora_icons.dart';
import '../../../core/theme/accessibility_providers.dart';
import '../../../core/theme/locale_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/totp_enroll_dialog.dart';
import '../../../core/widgets/ui_kit/kivora_button.dart';
import '../../../core/widgets/ui_kit/kivora_card.dart';
import '../../../core/widgets/ui_kit/kivora_text_field.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_service.dart';
import '../../../l10n/app_localizations.dart';
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
  late int _selectedIndex;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSaving = false;
  String? _error;
  String? _successMessage;

  bool _isUploadingPhoto = false;
  String? _uploadedPhotoUrl;
  bool _isSavingPrefs = false;
  bool _isLinkingAccount = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  /// Only messages our own service layer wrote (plain `Exception: text`) reach
  /// the user; anything else (platform/network errors) becomes a generic line.
  String _friendly(Object e) {
    final text = e.toString();
    if (e is Exception &&
        text.startsWith('Exception: ') &&
        !text.contains('Firebase')) {
      return text.substring('Exception: '.length);
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateControllers(AppUser user) {
    if (_firstNameController.text.isEmpty && user.firstName.isNotEmpty) {
      _firstNameController.text = user.firstName;
    }
    if (_lastNameController.text.isEmpty && user.lastName.isNotEmpty) {
      _lastNameController.text = user.lastName;
    }
    if (_phoneController.text.isEmpty && user.phoneNumber != null) {
      _phoneController.text = user.phoneNumber!;
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() => _isUploadingPhoto = true);

      final bytes = await image.readAsBytes();
      final url = await ref.read(userRepositoryProvider).uploadProfilePhoto(
            uid: widget.uid,
            imageBytes: bytes,
            fileExtension: image.name.split(".").last,
          );

      setState(() {
        _uploadedPhotoUrl = url;
        _isUploadingPhoto = false;
        _successMessage = AppLocalizations.of(context).acctPhotoUpdated;
        _error = null;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _successMessage = null);
      });
    } catch (e) {
      setState(() {
        _error = AppLocalizations.of(context).acctPhotoFailed;
        _isUploadingPhoto = false;
      });
    }
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
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
          );

      setState(() {
        _successMessage = AppLocalizations.of(context).acctProfileUpdated;
      });
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _successMessage = null);
      });
    } catch (e) {
      setState(() {
        _error = _friendly(e);
      });
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider(widget.uid));
    final kc = KivoraColors.of(context);

    return Scaffold(
      backgroundColor: kc.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    AppLocalizations.of(context).acctTitle,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: kc.textPrimary),
                  ),
                ),
                const SizedBox(height: 20),
                userAsync.when(
                  loading: () => LoadingView(
                      message: AppLocalizations.of(context).acctLoading),
                  error: (err, stack) => ErrorView(
                    type: ErrorViewType.generic,
                    message: AppLocalizations.of(context).acctLoadError,
                    onRetry: () =>
                        ref.invalidate(userProfileProvider(widget.uid)),
                  ),
                  data: (user) {
                    if (user == null) {
                      return ErrorView(
                          type: ErrorViewType.generic,
                          message: AppLocalizations.of(context).acctNotFound);
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
                            child: _buildSelectedView(context, user),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMobileSectionCards(context),
                        const SizedBox(height: 20),
                        _buildSelectedView(context, user),
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

  Widget _buildSelectedView(BuildContext context, AppUser user) {
    return switch (_selectedIndex) {
      0 => _buildProfileView(context, user),
      1 => _buildSecurityView(context, user),
      2 => _buildNotificationsView(context, user),
      3 => _buildPreferencesView(context),
      4 => _buildConnectedAccountsView(context),
      _ => _buildProfileView(context, user),
    };
  }

  static const _tabIcons = [
    KivoraIcons.user,
    KivoraIcons.lock,
    KivoraIcons.bell,
    KivoraIcons.settings,
    KivoraIcons.link,
  ];

  String _tabTitle(AppLocalizations l, int i) => switch (i) {
        0 => l.acctTabProfile,
        1 => l.acctTabSecurity,
        2 => l.acctTabNotifications,
        3 => l.acctTabPreferences,
        _ => l.acctTabAccounts,
      };

  String _tabShort(AppLocalizations l, int i) => switch (i) {
        0 => l.acctTabProfile,
        1 => l.acctTabSecurityShort,
        2 => l.acctTabNotificationsShort,
        3 => l.acctTabPreferencesShort,
        _ => l.acctTabAccountsShort,
      };

  Widget _buildSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _tabIcons.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _buildSidebarItem(
            icon: _tabIcons[i],
            title: _tabTitle(AppLocalizations.of(context), i),
            isSelected: _selectedIndex == i,
            onTap: () => setState(() => _selectedIndex = i),
          ),
        ],
      ],
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected
        ? KivoraColors.of(context).accentText
        : KivoraColors.textPrimaryOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
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
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileSectionCards(BuildContext context) {
    // One compact, scrollable row instead of five stacked cards that pushed
    // the actual settings below the fold.
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabIcons.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => Center(
          child: ChoiceChip(
            avatar: Icon(_tabIcons[i], size: 18),
            label: Text(_tabShort(AppLocalizations.of(context), i)),
            selected: _selectedIndex == i,
            showCheckmark: false,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onSelected: (_) => setState(() => _selectedIndex = i),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, AppUser user) {
    final authUser = ref.watch(authServiceProvider).currentUser;
    final photoUrl = _uploadedPhotoUrl ?? user.photoUrl ?? authUser?.photoURL;
    final isEmailVerified = authUser?.emailVerified ?? false;
    final dateFormat = DateFormat('MMMM d, yyyy');

    final sanitizedPhotoUrl = FirebaseService.sanitizeStorageUrl(photoUrl);
    final kc = KivoraColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Profile Avatar Header Card
        KivoraCard(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor:
                        AppTheme.primaryBlue.withValues(alpha: 0.15),
                    backgroundImage: sanitizedPhotoUrl.isNotEmpty
                        ? NetworkImage(sanitizedPhotoUrl)
                        : null,
                    child: sanitizedPhotoUrl.isEmpty
                        ? Text(
                            user.firstName.isNotEmpty
                                ? user.firstName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: KivoraColors.of(context).accentText,
                            ),
                          )
                        : null,
                  ),
                  PositionedDirectional(
                    bottom: 0,
                    end: 0,
                    child: InkWell(
                      onTap: _isUploadingPhoto ? null : _pickAndUploadImage,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
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
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kc.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: kc.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StatusBadge(
                          label: isEmailVerified
                              ? AppLocalizations.of(context).acctVerified
                              : AppLocalizations.of(context).acctUnverified,
                          backgroundColor: (isEmailVerified
                                  ? kc.successText
                                  : kc.warningText)
                              .withValues(alpha: kc.isDark ? 0.16 : 0.10),
                          textColor:
                              isEmailVerified ? kc.successText : kc.warningText,
                          icon: isEmailVerified
                              ? Icons.verified_outlined
                              : Icons.info_outline_rounded,
                        ),
                        StatusBadge(
                          label: user.status.toUpperCase(),
                          backgroundColor: (user.status == 'active'
                                  ? kc.accentText
                                  : kc.warningText)
                              .withValues(alpha: kc.isDark ? 0.16 : 0.10),
                          textColor: user.status == 'active'
                              ? kc.accentText
                              : kc.warningText,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppLocalizations.of(context)
                          .acctMemberSince(dateFormat.format(user.createdAt)),
                      style: TextStyle(
                        fontSize: 12,
                        color: kc.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                Icon(KivoraIcons.checkCircle,
                    color: KivoraColors.of(context).successText, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _successMessage!,
                    style: TextStyle(
                      color: KivoraColors.of(context).successText,
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
                Icon(KivoraIcons.alertCircle,
                    color: KivoraColors.of(context).errorText, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: KivoraColors.of(context).errorText,
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

        KivoraCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context).acctPersonalInfo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kc.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmall = constraints.maxWidth < 400;
                    if (isSmall) {
                      return Column(
                        children: [
                          KivoraTextField(
                            label: AppLocalizations.of(context).acctFirstName,
                            controller: _firstNameController,
                            validator: (v) => Validators.required(
                                v,
                                AppLocalizations.of(context)
                                    .acctFirstNameField),
                          ),
                          const SizedBox(height: 16),
                          KivoraTextField(
                            label: AppLocalizations.of(context).acctLastName,
                            controller: _lastNameController,
                            validator: (v) => Validators.required(v,
                                AppLocalizations.of(context).acctLastNameField),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: KivoraTextField(
                            label: AppLocalizations.of(context).acctFirstName,
                            controller: _firstNameController,
                            validator: (v) => Validators.required(
                                v,
                                AppLocalizations.of(context)
                                    .acctFirstNameField),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: KivoraTextField(
                            label: AppLocalizations.of(context).acctLastName,
                            controller: _lastNameController,
                            validator: (v) => Validators.required(v,
                                AppLocalizations.of(context).acctLastNameField),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                KivoraTextField(
                  label: AppLocalizations.of(context).acctPhone,
                  controller: _phoneController,
                  hint: '+1 234 567 8900',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: KivoraButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    isLoading: _isSaving,
                    label: AppLocalizations.of(context).acctSaveChanges,
                    isExpanded: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityView(BuildContext context, AppUser user) {
    final kc = KivoraColors.of(context);
    final isGoogleAuth = ref
        .watch(authServiceProvider)
        .currentUser
        ?.providerData
        .any((info) => info.providerId == 'google.com');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isGoogleAuth == true) ...[
          KivoraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).acctAuthMethod,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kc.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).acctGoogleNote,
                  style: TextStyle(
                    fontSize: 14,
                    color: kc.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ] else ...[
          const ChangePasswordSection(),
          const SizedBox(height: 16),
        ],
        KivoraCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).acct2fa,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kc.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).acct2faBody,
                style: TextStyle(
                  fontSize: 14,
                  color: kc.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              KivoraButton(
                type: KivoraButtonType.secondary,
                icon: KivoraIcons.shieldCheck,
                label: AppLocalizations.of(context).acctSetupAuth,
                onPressed: () {
                  showTotpEnrollDialog(context, ref);
                },
                isExpanded: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        KivoraButton(
          type: KivoraButtonType.destructive,
          label: AppLocalizations.of(context).acctSignOut,
          icon: KivoraIcons.logIn,
          onPressed: () async {
            await ref.read(authServiceProvider).signOut();
            if (widget.onSignOut != null) widget.onSignOut!();
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesView(BuildContext context) {
    final kc = KivoraColors.of(context);
    final currentMode = ref.watch(themeModeProvider);

    Widget modeOption(ThemeMode mode, IconData icon, String label) {
      final isSelected = currentMode == mode;
      return Expanded(
        child: InkWell(
          onTap: () => ref.read(themeModeProvider.notifier).setMode(mode),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlue : kc.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(icon,
                    size: 22,
                    color:
                        isSelected ? AppTheme.primaryBlue : kc.textSecondary),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppTheme.primaryBlue : kc.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentLocale = ref.watch(localeProvider);
    final reducedMotion = ref.watch(reducedMotionProvider);
    final highContrast = ref.watch(highContrastProvider);

    final languages = [
      (code: null, label: AppLocalizations.of(context).acctSystemDefault),
      (code: 'en', label: 'English'),
      (code: 'ur', label: 'اردو (Urdu)'),
      (code: 'sd', label: 'سنڌي (Sindhi)'),
      (code: 'ar', label: 'العربية (Arabic)'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KivoraCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).acctAppearance,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kc.textPrimary)),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context).acctAppearanceBody,
                  style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              const SizedBox(height: 20),
              Row(
                children: [
                  modeOption(ThemeMode.light, Icons.light_mode_outlined,
                      AppLocalizations.of(context).acctThemeLight),
                  const SizedBox(width: 12),
                  modeOption(ThemeMode.dark, Icons.dark_mode_outlined,
                      AppLocalizations.of(context).acctThemeDark),
                  const SizedBox(width: 12),
                  modeOption(ThemeMode.system, Icons.brightness_auto_outlined,
                      AppLocalizations.of(context).acctThemeSystem),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        KivoraCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).acctLanguage,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kc.textPrimary)),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context).acctLanguageNote,
                  style: TextStyle(
                      fontSize: 12, color: kc.textSecondary, height: 1.4)),
              const SizedBox(height: 16),
              ...languages.map((lang) {
                final isSelected = currentLocale?.languageCode == lang.code;
                return ListTile(
                  onTap: () => ref
                      .read(localeProvider.notifier)
                      .setLocale(lang.code == null ? null : Locale(lang.code!)),
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? AppTheme.primaryBlue : kc.textSecondary,
                  ),
                  title: Text(lang.label,
                      style: TextStyle(
                          color: kc.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        KivoraCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).acctAccessibility,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kc.textPrimary)),
              const SizedBox(height: 16),
              SwitchListTile(
                value: reducedMotion,
                onChanged: (v) =>
                    ref.read(reducedMotionProvider.notifier).setEnabled(v),
                title: Text(AppLocalizations.of(context).acctReduceMotion,
                    style: TextStyle(color: kc.textPrimary)),
                subtitle: Text(
                    AppLocalizations.of(context).acctReduceMotionBody,
                    style: TextStyle(fontSize: 12, color: kc.textSecondary)),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: highContrast,
                onChanged: (v) =>
                    ref.read(highContrastProvider.notifier).setEnabled(v),
                title: Text(AppLocalizations.of(context).acctHighContrast,
                    style: TextStyle(color: kc.textPrimary)),
                subtitle: Text(
                    AppLocalizations.of(context).acctHighContrastBody,
                    style: TextStyle(fontSize: 12, color: kc.textSecondary)),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 4),
              Text(AppLocalizations.of(context).acctTextSizeNote,
                  style: TextStyle(
                      fontSize: 12, color: kc.textSecondary, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _updateNotificationPreference(
      Map<String, bool> current, String key, bool value) async {
    final updated = {...current, key: value};
    setState(() => _isSavingPrefs = true);
    try {
      await ref
          .read(userRepositoryProvider)
          .updateNotificationPreferences(preferences: updated);
    } catch (e) {
      if (mounted) {
        setState(() => _error = _friendly(e));
      }
    } finally {
      if (mounted) setState(() => _isSavingPrefs = false);
    }
  }

  Widget _buildNotificationsView(BuildContext context, AppUser user) {
    final kc = KivoraColors.of(context);
    final prefs = user.notificationPreferences;

    Widget toggle(String key, String title, String subtitle) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: kc.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(fontSize: 12, color: kc.textSecondary)),
                ],
              ),
            ),
            Switch(
              value: prefs[key] ?? true,
              onChanged: _isSavingPrefs
                  ? null
                  : (value) => _updateNotificationPreference(prefs, key, value),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_error != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
            ),
            child: Text(_error!,
                style: TextStyle(
                    color: KivoraColors.of(context).errorText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          const SizedBox(height: 16),
        ],
        KivoraCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).acctNotifications,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kc.textPrimary)),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context).acctNotificationsBody,
                  style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              const SizedBox(height: 12),
              Divider(color: kc.border),
              toggle(
                  'voteReminders',
                  AppLocalizations.of(context).acctVoteReminders,
                  AppLocalizations.of(context).acctVoteRemindersBody),
              Divider(color: kc.border, height: 1),
              toggle(
                  'eventUpdates',
                  AppLocalizations.of(context).acctResultsPublished,
                  AppLocalizations.of(context).acctResultsPublishedBody),
              Divider(color: kc.border, height: 1),
              toggle(
                  'invitationAlerts',
                  AppLocalizations.of(context).acctInvitationAlerts,
                  AppLocalizations.of(context).acctInvitationAlertsBody),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedAccountsView(BuildContext context) {
    final kc = KivoraColors.of(context);
    final authUser = ref.watch(authServiceProvider).currentUser;
    final providers =
        authUser?.providerData.map((p) => p.providerId).toSet() ?? {};
    final hasPassword = providers.contains('password');
    final hasGoogle = providers.contains('google.com');
    final canUnlink = providers.length > 1;

    Future<void> linkGoogle() async {
      setState(() => _isLinkingAccount = true);
      try {
        await ref.read(authServiceProvider).linkGoogleAccount();
        if (mounted) {
          setState(() => _successMessage =
              AppLocalizations.of(context).acctGoogleConnected);
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _successMessage = null);
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _error = _friendly(e));
        }
      } finally {
        if (mounted) setState(() => _isLinkingAccount = false);
      }
    }

    Future<void> unlink(String providerId, String label) async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(context).acctDisconnectTitle(label)),
          content: Text(AppLocalizations.of(context).acctDisconnectBody(label)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(AppLocalizations.of(context).acctCancel)),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(AppLocalizations.of(context).acctDisconnect,
                  style: TextStyle(color: KivoraColors.of(context).errorText)),
            ),
          ],
        ),
      );
      if (confirm != true) return;

      setState(() => _isLinkingAccount = true);
      try {
        await ref.read(authServiceProvider).unlinkProvider(providerId);
        if (mounted) {
          setState(() => _successMessage = '$label disconnected.');
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _successMessage = null);
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => _error = _friendly(e));
        }
      } finally {
        if (mounted) setState(() => _isLinkingAccount = false);
      }
    }

    Widget accountRow({
      required IconData icon,
      required String title,
      required String subtitle,
      required bool isConnected,
      VoidCallback? onConnect,
      VoidCallback? onDisconnect,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: kc.accentText, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: kc.textPrimary)),
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style:
                              TextStyle(fontSize: 14, color: kc.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 54),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (isConnected)
                    StatusBadge(
                      label: AppLocalizations.of(context).acctConnectedBadge,
                      backgroundColor: kc.successText
                          .withValues(alpha: kc.isDark ? 0.16 : 0.10),
                      textColor: kc.successText,
                      icon: Icons.check_circle_outline,
                    )
                  else if (onConnect != null)
                    KivoraButton(
                      type: KivoraButtonType.secondary,
                      label: AppLocalizations.of(context).acctConnect,
                      isExpanded: false,
                      isLoading: _isLinkingAccount,
                      onPressed: _isLinkingAccount ? null : onConnect,
                    ),
                  if (isConnected && onDisconnect != null)
                    TextButton(
                      style:
                          TextButton.styleFrom(minimumSize: const Size(48, 48)),
                      onPressed: _isLinkingAccount ? null : onDisconnect,
                      child: Text(AppLocalizations.of(context).acctDisconnect,
                          style: TextStyle(color: kc.errorText)),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_successMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
            ),
            child: Text(_successMessage!,
                style: TextStyle(
                    color: KivoraColors.of(context).successText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
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
            child: Text(_error!,
                style: TextStyle(
                    color: KivoraColors.of(context).errorText,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          const SizedBox(height: 16),
        ],
        KivoraCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).acctConnectedTitle,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kc.textPrimary)),
              const SizedBox(height: 6),
              Text(AppLocalizations.of(context).acctConnectedBody,
                  style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              const SizedBox(height: 8),
              Divider(color: kc.border),
              accountRow(
                icon: KivoraIcons.mail,
                title: AppLocalizations.of(context).acctEmailPassword,
                subtitle: authUser?.email ?? '',
                isConnected: hasPassword,
                onDisconnect: hasPassword && canUnlink
                    ? () => unlink('password',
                        AppLocalizations.of(context).acctEmailPassword)
                    : null,
              ),
              Divider(color: kc.border, height: 1),
              accountRow(
                icon: KivoraIcons.google,
                title: 'Google',
                subtitle: hasGoogle
                    ? authUser?.email ?? ''
                    : AppLocalizations.of(context).acctGoogleSignIn,
                isConnected: hasGoogle,
                onConnect: hasGoogle ? null : linkGoogle,
                onDisconnect: hasGoogle && canUnlink
                    ? () => unlink('google.com', 'Google')
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
