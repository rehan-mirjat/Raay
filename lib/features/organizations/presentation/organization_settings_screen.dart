import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/navigation/exit_guard.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../services/firebase_service.dart';
import '../data/organization_repository.dart';
import '../domain/organization.dart';
import '../domain/organization_enums.dart';
import 'providers/organization_providers.dart';
import '../../../core/utils/friendly_error.dart';

class OrganizationSettingsScreen extends ConsumerStatefulWidget {
  const OrganizationSettingsScreen({super.key, this.logoPicker});

  /// Replaces the gallery picker (tests). Returns the chosen image bytes.
  final Future<Uint8List?> Function()? logoPicker;

  @override
  ConsumerState<OrganizationSettingsScreen> createState() => _OrganizationSettingsScreenState();
}

class _OrganizationSettingsScreenState extends ConsumerState<OrganizationSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _website = TextEditingController();
  final _logoUrl = TextEditingController();

  String? _loadedOrgId;
  bool _saving = false;

  /// True while a staged logo is being uploaded as part of Save.
  bool _uploadingLogo = false;

  /// A logo the owner picked but has not saved yet. Nothing is uploaded or
  /// published until Save; Reset and leaving discard it.
  Uint8List? _pendingLogo;

  // Exit-guard plumbing (system back, sidebar, search and workspace switching).
  late final ExitGuardNotifier _guardRegistry;
  late final ExitGuard _guard;
  Organization? _currentOrg;

  @override
  void initState() {
    super.initState();
    _guardRegistry = ref.read(exitGuardProvider.notifier);
    _guard = _confirmLeave;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _guardRegistry.register(_guard);
    });
    _name.addListener(() => setState(() {}));
    _description.addListener(() => setState(() {}));
    _website.addListener(() => setState(() {}));
    _logoUrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    final registry = _guardRegistry;
    final guard = _guard;
    Future.microtask(() => registry.unregister(guard));
    _description.dispose();
    _name.dispose();
    _website.dispose();
    _logoUrl.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges(Organization org) {
    return _name.text.trim() != org.name ||
        _description.text.trim() != org.description ||
        _website.text.trim() != (org.website ?? '') ||
        _logoUrl.text.trim() != (org.logoUrl ?? '') ||
        _pendingLogo != null;
  }

  /// Save / Discard / Stay. Returns true when it is fine to leave.
  Future<bool> _confirmLeave() async {
    final org = _currentOrg;
    if (org == null || !_hasUnsavedChanges(org) || !mounted) return true;
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save your branding changes?'),
        content: const Text(
            'You changed this organization\'s branding but have not saved it. Discarded changes cannot be recovered.'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, 'stay'),
            child: const Text('Keep editing'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48), foregroundColor: KivoraColors.of(ctx).errorText),
            onPressed: () => Navigator.pop(ctx, 'discard'),
            child: const Text('Discard'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, 'save'),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (choice == 'discard') {
      setState(() {
        _pendingLogo = null;
        _logoUrl.text = org.logoUrl ?? '';
      });
      return true;
    }
    if (choice == 'save') return _save(org.id);
    return false;
  }

  Future<void> _leaveToOverview() async {
    if (await _confirmLeave() && mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeOrganizationContextProvider);
    final isDesktop = ResponsiveLayout.isWide(context);

    final dirty = _currentOrg != null && _hasUnsavedChanges(_currentOrg!);
    return PopScope(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final router = GoRouter.of(context);
        if (await _confirmLeave() && mounted) {
          if (router.canPop()) {
            router.pop();
          } else {
            router.go('/home');
          }
        }
      },
      child: Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      body: state.when(
        skipLoadingOnReload: true,
        loading: () => const LoadingView(message: 'Loading organization…'),
        error: (_, __) => const ErrorView(
          type: ErrorViewType.generic,
          message: 'We could not load the organization. Check your connection and try again.',
        ),
        data: (active) {
          final orgContext = active.context;
          if (orgContext == null) {
            return const ErrorView(
              type: ErrorViewType.organizationRequired,
              title: 'No active organization',
              message: 'Select an organization before changing its branding.',
            );
          }
          final org = orgContext.organization;
          if (orgContext.member.role != OrganizationRole.owner) {
            return const ErrorView(
              type: ErrorViewType.accessDenied,
              title: 'Access denied',
              message: 'Only the organization Owner can update its branding.',
            );
          }

          if (_loadedOrgId != org.id) {
            _loadedOrgId = org.id;
            _name.text = org.name;
            _description.text = org.description;
            _website.text = org.website ?? '';
            _logoUrl.text = org.logoUrl ?? '';
          }

          _currentOrg = org;
          final unsaved = _hasUnsavedChanges(org);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Back Navigation Link
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                        onPressed: _leaveToOverview,
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text('Overview'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Headline & Subtitle
                    Text(
                      'Organization branding',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textPrimaryOf(context),
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Shape how ${org.name} appears to members and voters.',
                      style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14),
                    ),
                    const SizedBox(height: 28),

                    // 3. Two-Column Layout (Form & Live Preview)
                    Form(
                      key: _formKey,
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _buildDetailsCard(context),
                                      const SizedBox(height: 20),
                                      _buildLogoCard(context, org.id),
                                      const SizedBox(height: 20),
                                      _buildDangerZoneCard(context, org),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 28),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _buildLivePreviewCard(context),
                                      const SizedBox(height: 20),
                                      _buildPermissionsNoticeCard(context),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildDetailsCard(context),
                                const SizedBox(height: 20),
                                _buildLogoCard(context, org.id),
                                const SizedBox(height: 20),
                                _buildLivePreviewCard(context),
                                const SizedBox(height: 20),
                                _buildPermissionsNoticeCard(context),
                                const SizedBox(height: 20),
                                _buildDangerZoneCard(context, org),
                              ],
                            ),
                    ),

                    const SizedBox(height: 32),

                    // 4. Bottom Sticky Unsaved Changes Banner
                    if (unsaved || _saving || _uploadingLogo)
                      _buildUnsavedChangesBanner(context, org),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      ),
    );
  }

  // ===========================================================================
  // CARD 1: ORGANIZATION DETAILS
  // ===========================================================================
  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KivoraColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organization details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context)),
          ),
          const SizedBox(height: 4),
          Text(
            'Your public name and a short introduction to your organization.',
            style: TextStyle(fontSize: 13, color: KivoraColors.textSecondaryOf(context)),
          ),
          const SizedBox(height: 24),

          // Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Organization name *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context)))),
              const SizedBox(width: 8),
              Text('${_name.text.length} / 100', style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _name,
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'e.g. Acme Corporation',
              counterText: '',
            ),
            validator: (value) {
              final name = value?.trim() ?? '';
              return name.length < 3 ? 'Use at least 3 characters.' : null;
            },
          ),
          const SizedBox(height: 20),

          // Description
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Description', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context)))),
              const SizedBox(width: 8),
              Text('${_description.text.length} / 500', style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _description,
            maxLength: 500,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Brief summary of your organization or department...',
              counterText: '',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'A short introduction shown on your organization profile.',
            style: TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context)),
          ),
          const SizedBox(height: 20),

          // Website
          Text('Website (optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context))),
          const SizedBox(height: 6),
          TextFormField(
            controller: _website,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              hintText: 'https://example.org',
            ),
            validator: (value) => _validOptionalHttps(value) ? null : 'Enter a valid HTTPS URL.',
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // CARD 2: ORGANIZATION LOGO
  // ===========================================================================
  Widget _buildLogoCard(BuildContext context, String orgId) {
    final hasLogo = _pendingLogo != null || _logoUrl.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KivoraColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                'Organization logo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context)),
              ),
              Text(
                hasLogo ? 'Logo active' : 'No logo uploaded',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: hasLogo ? KivoraColors.of(context).successText : KivoraColors.textSecondaryOf(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dashed Upload Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: KivoraColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: KivoraColors.borderOf(context), width: 1.2),
            ),
            child: Row(
              children: [
                // Logo Preview Box
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: KivoraColors.borderOf(context)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: hasLogo
                      ? _logoImage(32)
                      : Center(
                          child: Icon(Icons.business_rounded, size: 32, color: KivoraColors.of(context).accentText),
                        ),
                ),
                const SizedBox(width: 20),

                // Upload & Remove Controls
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _uploadingLogo || _saving ? null : _pickLogo,
                            icon: _uploadingLogo
                                ? const SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.upload_rounded, size: 18),
                            label: Text(_pendingLogo != null ? 'Choose a different logo' : 'Choose logo'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          if (hasLogo)
                            InkWell(
                              onTap: _uploadingLogo || _saving
                                  ? null
                                  : () {
                                      setState(() {
                                        _pendingLogo = null;
                                        _logoUrl.text = '';
                                      });
                                    },
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                child: Text('Remove', style: TextStyle(fontSize: 13, color: KivoraColors.textSecondaryOf(context), fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'PNG, JPEG or WebP · Up to 5 MB\nUse a square image for the best result.',
                        style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context), height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SIDEBAR 1: LIVE MEMBER PROFILE PREVIEW
  // ===========================================================================
  Widget _buildLivePreviewCard(BuildContext context) {
    final nameStr = _name.text.trim().isEmpty ? 'Organization Name' : _name.text.trim();
    final descStr = _description.text.trim().isEmpty ? 'Description will appear here...' : _description.text.trim();
    final websiteStr = _website.text.trim().isEmpty ? 'No website added' : _website.text.trim();
    final hasLogo = _pendingLogo != null || _logoUrl.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KivoraColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Member profile preview',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context)),
          ),
          const SizedBox(height: 4),
          Text(
            'How your organization will appear to members.',
            style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
          ),
          const SizedBox(height: 20),

          // Preview Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: KivoraColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: KivoraColors.borderOf(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Logo Box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: hasLogo
                      ? _logoImage(24)
                      : Center(
                          child: Icon(Icons.business_rounded, size: 24, color: KivoraColors.of(context).accentText),
                        ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        nameStr,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Member', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: KivoraColors.of(context).accentText)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Text(
                  descStr,
                  style: TextStyle(fontSize: 13, color: KivoraColors.textSecondaryOf(context), height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(Icons.language_rounded, size: 14, color: KivoraColors.textSecondaryOf(context)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        websiteStr,
                        style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(height: 1, color: KivoraColors.borderOf(context)),
                const SizedBox(height: 16),

                // Static preview of a button, not a control.
                ExcludeSemantics(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('View events',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 14, color: KivoraColors.textSecondaryOf(context)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Preview only. Changes appear to members and voters after you save.',
                  style: TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context), height: 1.3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SIDEBAR 2: PERMISSIONS NOTICE
  // ===========================================================================
  Widget _buildPermissionsNoticeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KivoraColors.borderOf(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined, size: 20, color: KivoraColors.of(context).accentText),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Branding, not permissions',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Access control and verification are managed separately. Updating your branding won\'t change either.',
                  style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. UNSAVED CHANGES STICKY BANNER
  // ===========================================================================
  Widget _buildUnsavedChangesBanner(BuildContext context, Organization org) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KivoraColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.accentGold,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You have unsaved changes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context)),
                ),
                const SizedBox(height: 2),
                Text(
                  _pendingLogo != null
                      ? 'A new logo is selected but not uploaded yet. Save to upload and publish it.'
                      : 'Save to publish your branding, or reset to discard your changes.',
                  style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          OutlinedButton(
            onPressed: _saving || _uploadingLogo
                ? null
                : () {
                    setState(() {
                      _pendingLogo = null;
                      _name.text = org.name;
                      _description.text = org.description;
                      _website.text = org.website ?? '';
                      _logoUrl.text = org.logoUrl ?? '';
                    });
                  },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text('Reset'),
          ),
          const SizedBox(width: 12),

          FilledButton.icon(
            onPressed: _saving || _uploadingLogo ? null : () => _save(org.id),
            icon: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.check_rounded, size: 18),
            label: Text(_saving ? 'Saving...' : 'Save branding'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Picks an image and stages it. Nothing is uploaded or published until Save.
  Future<void> _pickLogo() async {
    try {
      Uint8List? bytes;
      final custom = widget.logoPicker;
      if (custom != null) {
        bytes = await custom();
      } else {
        final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 85,
        );
        bytes = image == null ? null : await image.readAsBytes();
      }
      if (bytes == null || !mounted) return;
      if (bytes.length > 5242880) {
        throw Exception('Organization logo exceeds 5MB size limit.');
      }
      if (!mounted) return;
      setState(() => _pendingLogo = bytes);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyError(error))),
        );
      }
    }
  }

  /// The staged logo if there is one, otherwise the saved one.
  Widget _logoImage(double iconSize) {
    final fallback = Center(
      child: Icon(Icons.business_rounded, size: iconSize, color: KivoraColors.of(context).accentText),
    );
    final pending = _pendingLogo;
    if (pending != null) {
      return Image.memory(pending, fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback);
    }
    return Image.network(
      FirebaseService.sanitizeStorageUrl(_logoUrl.text),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }

  bool _validOptionalHttps(String? input) {
    final value = (input ?? '').trim();
    if (value.isEmpty) return true;
    final uri = Uri.tryParse(value);
    return uri != null && uri.scheme == 'https' && uri.host.contains('.') && !uri.host.startsWith('.');
  }

  /// Uploads a staged logo (if any), then saves every field in one update.
  /// Returns true only when everything was saved.
  Future<bool> _save(String organizationId) async {
    if (!_formKey.currentState!.validate()) return false;
    setState(() => _saving = true);
    try {
      var logoUrl = _logoUrl.text.trim();
      final staged = _pendingLogo;
      if (staged != null) {
        setState(() => _uploadingLogo = true);
        logoUrl = await ref.read(organizationRepositoryProvider).uploadOrganizationLogo(
              organizationId: organizationId,
              imageBytes: staged,
            );
      }
      await FirebaseService().functions.httpsCallable('updateOrganization').call({
        'organizationId': organizationId,
        'name': _name.text.trim(),
        'description': _description.text.trim(),
        'website': _website.text.trim(),
        'logoUrl': logoUrl,
      });
      if (mounted) {
        setState(() {
          _pendingLogo = null;
          _logoUrl.text = logoUrl;
        });
      }
      ref.read(organizationRepositoryProvider).clearCache();
      ref.invalidate(activeOrganizationContextProvider);
      ref.invalidate(userOrganizationsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Organization branding saved.')),
        );
      }
      return true;
    } on FirebaseFunctionsException catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? 'Could not save branding.')));
      return false;
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendlyError(error, fallback: 'Could not save branding.'))));
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
          _uploadingLogo = false;
        });
      }
    }
  }

  Widget _buildDangerZoneCard(BuildContext context, Organization org) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: KivoraColors.of(context).errorText, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Danger zone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KivoraColors.of(context).errorText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Deleting this organization will archive its workspace. Active elections will stop accepting ballots.',
            style: TextStyle(fontSize: 13, color: KivoraColors.textSecondaryOf(context), height: 1.4),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _confirmDeleteOrganization(org),
            icon: Icon(Icons.delete_forever_rounded, color: KivoraColors.of(context).errorText, size: 18),
            label: Text('Delete organization',
                textAlign: TextAlign.center,
                style: TextStyle(color: KivoraColors.of(context).errorText, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              side: BorderSide(color: KivoraColors.of(context).errorText),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteOrganization(Organization org) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Organization?'),
        content: Text(
          'Are you sure you want to delete "${org.name}"?\n\nThis will archive the organization workspace. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep organization'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48), foregroundColor: KivoraColors.of(ctx).errorText),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete organization'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(organizationRepositoryProvider).deleteOrganization(organizationId: org.id);
        ref.read(activeOrgIdProvider.notifier).clearSelection();
        ref.invalidate(userOrganizationsProvider);
        if (!mounted) return;
        context.go('/orgs');
        messenger.showSnackBar(
          const SnackBar(content: Text('Organization has been deleted.')),
        );
      } catch (e) {
        if (!mounted) return;
        messenger.showSnackBar(
          SnackBar(
            content: Text(friendlyError(e)),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }
}
