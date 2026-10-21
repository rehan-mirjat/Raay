import 'package:flutter/material.dart';
import '../../../core/utils/friendly_error.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/theme/kivora_icons.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../data/organization_repository.dart';
import 'providers/organization_providers.dart';

class JoinOrganizationScreen extends ConsumerStatefulWidget {
  const JoinOrganizationScreen({
    super.key,
    this.onJoined,
    this.onCancelTap,
    this.initialCode,
  });

  final Function(String organizationId, String organizationName)? onJoined;
  final VoidCallback? onCancelTap;

  /// Pre-fills the code field and auto-submits, for arrival from the
  /// "Scan to Join" QR flow.
  final String? initialCode;

  @override
  ConsumerState<JoinOrganizationScreen> createState() => _JoinOrganizationScreenState();
}

class _OrgPreview {
  const _OrgPreview({
    required this.organizationId,
    required this.organizationName,
    required this.logoUrl,
    required this.verified,
  });
  final String organizationId;
  final String organizationName;
  final String? logoUrl;
  final bool verified;
}

class _JoinOrganizationScreenState extends ConsumerState<JoinOrganizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  _OrgPreview? _preview;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(() {
      setState(() {});
    });
    if (widget.initialCode != null && widget.initialCode!.isNotEmpty) {
      _codeController.text = widget.initialCode!.toUpperCase();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _findOrganization();
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _findOrganization() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(organizationRepositoryProvider);
      final result = await repo
          .previewJoiningCode(_codeController.text.trim().toUpperCase());

      if (mounted) {
        setState(() {
          _isLoading = false;
          _preview = _OrgPreview(
            organizationId: result.organizationId,
            organizationName: result.organizationName,
            logoUrl: result.logoUrl,
            verified: result.verified,
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _isLoading = false;
        });
      }
    }
  }

  void _backToCodeEntry() {
    setState(() {
      _preview = null;
      _error = null;
    });
  }

  Future<void> _confirmJoin() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(organizationRepositoryProvider);
      final activeOrg = ref.read(activeOrgIdProvider.notifier);
      final result = await repo
          .joinOrganizationWithCode(_codeController.text.trim().toUpperCase());

      ref.invalidate(userMembershipsProvider);
      ref.invalidate(userOrganizationsProvider);
      ref.invalidate(activeOrganizationContextProvider);

      await activeOrg.selectOrganization(result.organizationId);

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully joined ${result.organizationName}!'),
            backgroundColor: AppTheme.success,
          ),
        );
        if (widget.onJoined != null) {
          widget.onJoined!(result.organizationId, result.organizationName);
        } else {
          context.go('/orgs');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _isLoading = false;
        });
      }
    }
  }

  void _handleCancel() {
    if (widget.onCancelTap != null) {
      widget.onCancelTap!();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      context.go('/orgs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // On the confirmation step, back should return to code entry (the
      // screen already exposes that as an explicit button) rather than
      // exit the whole flow and lose the already-resolved preview.
      canPop: _preview == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _backToCodeEntry();
      },
      child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              decoration: BoxDecoration(
                color: KivoraColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KivoraColors.borderOf(context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(28),
              child: _preview == null
                  ? _buildCodeEntryForm()
                  : _buildConfirmationCard(_preview!),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildCodeEntryForm() {
    final canSubmit = _codeController.text.trim().isNotEmpty && !_isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.key_outlined,
                  size: 24,
                  color: AppTheme.primaryBlue,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: KivoraColors.textSecondaryOf(context)),
                tooltip: 'Close',
                onPressed: _handleCancel,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            'Join organization with code',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: KivoraColors.textPrimaryOf(context),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the joining code shared by your organization\'s owner to find your workspace.',
            style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 24),

          Text(
            'JOINING CODE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: KivoraColors.textPrimaryOf(context),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _findOrganization(),
            decoration: const InputDecoration(
              hintText: 'Enter your joining code',
            ),
            validator: (v) => Validators.required(v, 'Joining Code'),
          ),
          const SizedBox(height: 6),
          Text(
            'Paste the complete code exactly as it was shared with you.',
            style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => context.go('/orgs/join/scan'),
            icon: const Icon(KivoraIcons.qrCode, size: 18),
            label: const Text('Scan QR code instead'),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
          const SizedBox(height: 8),

          // Info Callout Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Don\'t have a code?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: KivoraColors.textPrimaryOf(context)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ask your organization\'s owner for one. If a code is invalid or expired, request a new code.',
                        style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context), height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'You\'ll review the organization before confirming that you want to join.',
            style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
          ),

          if (_error != null) ...[
            const SizedBox(height: 16),
            InlineErrorBanner(message: _error!),
          ],

          const SizedBox(height: 28),

          Wrap(
            alignment: WrapAlignment.end,
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton(
                onPressed: _handleCancel,
                style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: canSubmit ? _findOrganization : null,
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                child: _isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Find organization'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationCard(_OrgPreview preview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.domain_verification_outlined,
                size: 24,
                color: AppTheme.primaryBlue,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, color: KivoraColors.textSecondaryOf(context)),
              tooltip: 'Close',
              onPressed: _handleCancel,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Is this your organization?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: KivoraColors.textPrimaryOf(context),
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Confirm this is the workspace you want to join before continuing.',
          style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: KivoraColors.backgroundOf(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KivoraColors.borderOf(context)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.12),
                backgroundImage: preview.logoUrl != null
                    ? NetworkImage(preview.logoUrl!)
                    : null,
                child: preview.logoUrl == null
                    ? const Icon(Icons.business_outlined,
                        color: AppTheme.primaryBlue)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview.organizationName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: KivoraColors.textPrimaryOf(context)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          preview.verified
                              ? Icons.verified_rounded
                              : Icons.schedule_rounded,
                          size: 14,
                          color: preview.verified
                              ? AppTheme.success
                              : KivoraColors.textSecondaryOf(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          preview.verified ? 'Verified' : 'Pending verification',
                          style: TextStyle(
                              fontSize: 12,
                              color: preview.verified
                                  ? AppTheme.success
                                  : KivoraColors.textSecondaryOf(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (_error != null) ...[
          const SizedBox(height: 16),
          InlineErrorBanner(message: _error!),
        ],

        const SizedBox(height: 28),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: _isLoading ? null : _backToCodeEntry,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Use a different code'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _isLoading ? null : _confirmJoin,
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              child: _isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Text('Join ${preview.organizationName}'),
            ),
          ],
        ),
      ],
    );
  }
}
