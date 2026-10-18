import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../data/organization_repository.dart';
import 'providers/organization_providers.dart';

class JoinOrganizationScreen extends ConsumerStatefulWidget {
  const JoinOrganizationScreen({
    super.key,
    this.onJoined,
    this.onCancelTap,
  });

  final Function(String organizationId, String organizationName)? onJoined;
  final VoidCallback? onCancelTap;

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
          _error = e.toString().replaceAll('Exception: ', '');
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
          _error = e.toString().replaceAll('Exception: ', '');
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
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderLight),
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
                  color: AppTheme.surfaceBlue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.key_outlined,
                  size: 24,
                  color: AppTheme.primaryBlue,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
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
                  color: AppTheme.secondaryNavy,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter the joining code shared by your organization\'s owner to find your workspace.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 24),

          const Text(
            'JOINING CODE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryNavy,
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
          const Text(
            'Paste the complete code exactly as it was shared with you.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),

          // Info Callout Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Don\'t have a code?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.secondaryNavy),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Ask your organization\'s owner for one. If a code is invalid or expired, request a new code.',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'You\'ll review the organization before confirming that you want to join.',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
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
                onPressed: _handleCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: canSubmit ? _findOrganization : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
                color: AppTheme.surfaceBlue,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.domain_verification_outlined,
                size: 24,
                color: AppTheme.primaryBlue,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
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
                color: AppTheme.secondaryNavy,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Confirm this is the workspace you want to join before continuing.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.surfaceBlue,
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.secondaryNavy),
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
                              : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          preview.verified ? 'Verified' : 'Pending verification',
                          style: TextStyle(
                              fontSize: 12,
                              color: preview.verified
                                  ? AppTheme.success
                                  : AppTheme.textSecondary),
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
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
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
