import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/inline_error_banner.dart';
import '../data/department_repository.dart';
import '../domain/department.dart';
import '../../../core/utils/friendly_error.dart';

class CreateEditDepartmentDialog extends ConsumerStatefulWidget {
  const CreateEditDepartmentDialog({
    super.key,
    required this.organizationId,
    this.departmentToEdit,
  });

  final String organizationId;
  final Department? departmentToEdit;

  @override
  ConsumerState<CreateEditDepartmentDialog> createState() =>
      _CreateEditDepartmentDialogState();
}

class _CreateEditDepartmentDialogState
    extends ConsumerState<CreateEditDepartmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.departmentToEdit?.name ?? '');
    _descController =
        TextEditingController(text: widget.departmentToEdit?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(departmentRepositoryProvider);

      if (widget.departmentToEdit == null) {
        await repo.createDepartment(
          organizationId: widget.organizationId,
          name: _nameController.text,
          description: _descController.text,
        );
      } else {
        await repo.updateDepartment(
          departmentId: widget.departmentToEdit!.id,
          name: _nameController.text,
          description: _descController.text,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.departmentToEdit == null
                ? AppLocalizations.of(context).cdCreated
                : AppLocalizations.of(context).cdUpdated),
            backgroundColor: AppTheme.success,
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.departmentToEdit != null;

    return AlertDialog(
      title: Text(isEditing
          ? AppLocalizations.of(context).cdEditTitle
          : AppLocalizations.of(context).cdCreateTitle),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).cdName,
                    hintText: AppLocalizations.of(context).cdNameHint,
                  ),
                  validator: (v) {
                    final req = Validators.required(
                        v, AppLocalizations.of(context).cdNameField);
                    if (req != null) return req;
                    if (v!.trim().length < 2) {
                      return AppLocalizations.of(context).cdNameShort;
                    }
                    if (v.trim().length > 50) {
                      return AppLocalizations.of(context).cdNameLong;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).cdDesc,
                    hintText: AppLocalizations.of(context).cdDescHint,
                  ),
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).cdCancel),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Text(isEditing
                  ? AppLocalizations.of(context).cdUpdate
                  : AppLocalizations.of(context).cdCreate),
        ),
      ],
    );
  }
}
