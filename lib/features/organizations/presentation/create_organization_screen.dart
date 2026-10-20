import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../data/organization_repository.dart';
import 'providers/organization_providers.dart';

class CreateOrganizationScreen extends ConsumerStatefulWidget {
  const CreateOrganizationScreen({
    super.key,
    this.onOrganizationCreated,
    this.onCancelTap,
  });

  final Function(String organizationId)? onOrganizationCreated;
  final VoidCallback? onCancelTap;

  @override
  ConsumerState<CreateOrganizationScreen> createState() => _CreateOrganizationScreenState();
}

class _CreateOrganizationScreenState extends ConsumerState<CreateOrganizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _websiteController = TextEditingController();

  String _selectedType = 'academic';
  bool _isLoading = false;
  String? _error;

  final List<DropdownMenuItem<String>> _typeOptions = const [
    DropdownMenuItem(value: 'academic', child: Text('Academic Institution')),
    DropdownMenuItem(value: 'corporate', child: Text('Corporate Enterprise')),
    DropdownMenuItem(value: 'nonProfit', child: Text('Non-Profit Organization')),
    DropdownMenuItem(value: 'club', child: Text('Club / Student Society')),
    DropdownMenuItem(value: 'community', child: Text('Community Association')),
    DropdownMenuItem(value: 'other', child: Text('Other')),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(organizationRepositoryProvider);
      final activeOrg = ref.read(activeOrgIdProvider.notifier);
      final website = _websiteController.text.trim();
      final country = _countryController.text.trim();
      final city = _cityController.text.trim();
      final orgId = await repo.createOrganization(
        name: _nameController.text.trim(),
        type: _selectedType,
        description: _descriptionController.text.trim(),
        country: country.isNotEmpty ? country : null,
        city: city.isNotEmpty ? city : null,
        website: website.isNotEmpty ? website : null,
      );

      ref.invalidate(userMembershipsProvider);
      ref.invalidate(userOrganizationsProvider);

      await activeOrg.selectOrganization(orgId);

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Organization created and verified!'),
            backgroundColor: AppTheme.success,
          ),
        );
        if (widget.onOrganizationCreated != null) {
          widget.onOrganizationCreated!(orgId);
        } else {
          context.go('/orgs');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
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
    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
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
              child: Form(
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
                            Icons.business_outlined,
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
                      'Create an organization',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textPrimaryOf(context),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Give your community a shared space for people, departments and activity.',
                      style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'ORGANIZATION NAME *',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Your community or company',
                      ),
                      validator: (v) {
                        final req = Validators.required(v, 'Organization Name');
                        if (req != null) return req;
                        if (v!.trim().length < 2) return 'Name must be at least 2 characters';
                        if (v.trim().length > 80) return 'Name cannot exceed 80 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Use a name your members will recognize. 2–80 characters.',
                      style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                    ),
                    const SizedBox(height: 18),

                    Text(
                      'ORGANIZATION TYPE *',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        hintText: 'Select a type',
                      ),
                      items: _typeOptions,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CITY (OPTIONAL)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textPrimaryOf(context),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _cityController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'Enter city',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'COUNTRY (OPTIONAL)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textPrimaryOf(context),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _countryController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                  hintText: 'Select country',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Owner Callout Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: AppTheme.primaryBlue, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Verified instantly, you\'ll be the owner',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: KivoraColors.textPrimaryOf(context)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Since your account email is verified, your organization is created already verified - no manual review needed. Set up your workspace, branding and joining codes right after.',
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
                      '* Complete the required fields to create your organization.',
                      style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
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
                          onPressed: _isLoading ? null : _submit,
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
                              : const Text('Create organization'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
