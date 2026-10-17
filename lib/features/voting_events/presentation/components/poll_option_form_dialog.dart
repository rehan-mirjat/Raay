import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/inline_error_banner.dart';
import '../../data/poll_option_repository.dart';
import '../../domain/poll_option.dart';

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
  ConsumerState<PollOptionFormDialog> createState() => _PollOptionFormDialogState();
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
        // sortOrder is left unset: the server appends it after the current
        // highest sortOrder so new options reliably land at the end.
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
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return AlertDialog(
      title: Text(widget.existingOption == null ? 'Add Option' : 'Edit Option'),
      content: SizedBox(
        width: (screenWidth - 80).clamp(240.0, 400.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _labelCtrl,
                  decoration: const InputDecoration(labelText: 'Label *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Label is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: 'Description (Optional)'),
                  maxLines: 3,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  InlineErrorBanner(message: _error!),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (!_isLoading)
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'),
        ),
      ],
    );
  }
}
