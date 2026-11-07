import '../../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raay/core/theme/app_theme.dart';
import 'package:raay/core/theme/raay_icons.dart';
import 'package:raay/core/widgets/ui_kit/raay_button.dart';
import 'package:raay/core/widgets/ui_kit/raay_text_field.dart';

import '../../../../core/theme/raay_colors.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../data/poll_option_repository.dart';
import '../../domain/poll_option.dart';
import '../../../../core/utils/friendly_error.dart';

class PollOptionFormDialog extends ConsumerStatefulWidget {
  final String orgId;
  final String eventId;
  final PollOption? existingOption;

  const PollOptionFormDialog({
    super.key,
    required this.orgId,
    required this.eventId,
    this.existingOption,
  });

  @override
  ConsumerState<PollOptionFormDialog> createState() =>
      _PollOptionFormDialogState();
}

class _PollOptionFormDialogState extends ConsumerState<PollOptionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelCtrl;
  late TextEditingController _descCtrl;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: widget.existingOption?.label);
    _descCtrl = TextEditingController(text: widget.existingOption?.description);
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(pollOptionRepositoryProvider);
      if (widget.existingOption == null) {
        await repo.createPollOption(
          organizationId: widget.orgId,
          votingEventId: widget.eventId,
          label: _labelCtrl.text.trim(),
          description: _descCtrl.text.trim(),
        );
      } else {
        await repo.updatePollOption(
          optionId: widget.existingOption!.id,
          label: _labelCtrl.text.trim(),
          description: _descCtrl.text.trim(),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final kc = RaayColors.of(context);

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(RaayIcons.listChecks,
                                color: RaayColors.of(context).accentText,
                                size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.existingOption == null
                                ? AppLocalizations.of(context).pfAddTitle
                                : AppLocalizations.of(context).pfEditTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kc.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(RaayIcons.x, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RaayTextField(
                    controller: _labelCtrl,
                    label: AppLocalizations.of(context).pfLabel,
                    hint: AppLocalizations.of(context).pfLabelHint,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? AppLocalizations.of(context).pfLabelRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  RaayTextField(
                    controller: _descCtrl,
                    label: AppLocalizations.of(context).pfDesc,
                    hint: AppLocalizations.of(context).pfDescHint,
                    maxLines: 3,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    InlineErrorBanner(message: _error!),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: RaayButton(
                          type: RaayButtonType.secondary,
                          label: AppLocalizations.of(context).pfCancel,
                          onPressed:
                              _isLoading ? null : () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RaayButton(
                          label: widget.existingOption == null
                              ? AppLocalizations.of(context).pfAdd
                              : AppLocalizations.of(context).pfSave,
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),
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
