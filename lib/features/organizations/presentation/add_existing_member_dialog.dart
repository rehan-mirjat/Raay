import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kivora/core/theme/app_theme.dart';
import 'package:kivora/core/theme/kivora_colors.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_text_field.dart';

import '../../../core/widgets/inline_error_banner.dart';
import '../data/organization_repository.dart';
import '../../../core/utils/friendly_error.dart';

class AddExistingMemberDialog extends ConsumerStatefulWidget {
  const AddExistingMemberDialog({
    super.key,
    required this.organizationId,
  });

  final String organizationId;

  @override
  ConsumerState<AddExistingMemberDialog> createState() =>
      _AddExistingMemberDialogState();
}

class _AddExistingMemberDialogState
    extends ConsumerState<AddExistingMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      await ref.read(organizationRepositoryProvider).addMember(
            organizationId: widget.organizationId,
            email: _emailController.text.trim(),
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = friendlyError(error);
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: kc.surface,
      child: SizedBox(
        width: (screenWidth - 80).clamp(280.0, 480.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(KivoraIcons.userPlus,
                            color: KivoraColors.of(context).accentText,
                            size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            AppLocalizations.of(context).aeTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kc.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: AppLocalizations.of(context).aeClose,
                        constraints:
                            const BoxConstraints(minWidth: 48, minHeight: 48),
                        icon: const Icon(KivoraIcons.x, size: 20),
                        onPressed:
                            _isSubmitting ? null : () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context).aeSubtitle,
                    style: TextStyle(fontSize: 13, color: kc.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  KivoraTextField(
                    controller: _emailController,
                    label: AppLocalizations.of(context).aeEmailLabel,
                    hint: AppLocalizations.of(context).aeEmailHint,
                    prefixIcon: KivoraIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty ||
                          !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                              .hasMatch(email)) {
                        return AppLocalizations.of(context).aeEmailInvalid;
                      }
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    InlineErrorBanner(message: _error!),
                  ],
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        onPressed:
                            _isSubmitting ? null : () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context).aeCancel),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        onPressed: _isSubmitting ? null : _submit,
                        icon: _isSubmitting
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(KivoraIcons.userCheck, size: 18),
                        label: Text(AppLocalizations.of(context).aeAdd),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
