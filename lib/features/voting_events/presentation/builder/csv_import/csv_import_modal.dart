import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import '../../../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/raay_colors.dart';
import '../../../../../core/theme/raay_icons.dart';
import '../../../../../core/widgets/ui_kit/raay_button.dart';
import '../../../../../core/widgets/ui_kit/raay_text_field.dart';
import '../../../domain/csv_email_parser.dart';

class CsvImportModal extends StatefulWidget {
  final List<Map<String, dynamic>> organizationMembers;

  const CsvImportModal({
    super.key,
    required this.organizationMembers,
  });

  @override
  State<CsvImportModal> createState() => _CsvImportModalState();
}

class _CsvImportModalState extends State<CsvImportModal> {
  final TextEditingController _csvController = TextEditingController();
  List<String> _matchedUserIds = [];
  List<String> _unmatchedEmails = [];
  bool _hasParsed = false;
  bool _isPickingFile = false;
  String? _fileError;

  Future<void> _pickCsvFile() async {
    setState(() {
      _isPickingFile = true;
      _fileError = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv'],
        allowMultiple: false,
        withData: true,
      );
      if (result == null || result.files.isEmpty || !mounted) return;
      final file = result.files.single;
      final bytes = file.bytes;
      if (bytes == null) {
        throw const FormatException('Could not read this file.');
      }
      if (bytes.length > 2 * 1024 * 1024) {
        throw const FormatException('CSV file must be 2 MB or smaller.');
      }
      final content = utf8.decode(bytes, allowMalformed: false);
      _csvController.text = content;
      setState(() {
        _hasParsed = false;
        _fileError = null;
      });
    } on FormatException catch (error) {
      if (mounted) setState(() => _fileError = error.message);
    } catch (_) {
      if (mounted) setState(() => _fileError = 'Unable to open this CSV file.');
    } finally {
      if (mounted) setState(() => _isPickingFile = false);
    }
  }

  void _parseCsv() {
    final text = _csvController.text.trim();
    if (text.isEmpty) return;

    final emailSet = const CsvEmailParser().parse(text).toSet();

    final matchedUids = <String>[];
    final unmatched = <String>[];

    for (var email in emailSet) {
      final member = widget.organizationMembers.firstWhere(
        (m) => (m['email'] as String? ?? '').toLowerCase() == email,
        orElse: () => {},
      );

      if (member.isNotEmpty && member['userId'] != null) {
        matchedUids.add(member['userId'] as String);
      } else {
        unmatched.add(email);
      }
    }

    setState(() {
      _matchedUserIds = matchedUids;
      _unmatchedEmails = unmatched;
      _hasParsed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: kc.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(RaayIcons.fileSpreadsheet,
                            color: RaayColors.of(context).accentText,
                            size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context).ciTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                    icon: const Icon(RaayIcons.x, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).ciBody,
                style: TextStyle(
                    fontSize: 13, color: kc.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OutlinedButton.icon(
                  onPressed: _isPickingFile ? null : _pickCsvFile,
                  icon: _isPickingFile
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_file_rounded),
                  label: Text(AppLocalizations.of(context).ciChooseFile),
                ),
              ),
              if (_fileError != null) ...[
                const SizedBox(height: 8),
                Text(_fileError!,
                    style:
                        TextStyle(color: RaayColors.of(context).errorText)),
              ],
              const SizedBox(height: 8),
              RaayTextField(
                controller: _csvController,
                label: AppLocalizations.of(context).ciLabel,
                hint: AppLocalizations.of(context).ciHint,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              if (!_hasParsed)
                RaayButton(
                  label: AppLocalizations.of(context).ciParse,
                  icon: RaayIcons.check,
                  onPressed: _parseCsv,
                )
              else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).ciResults,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kc.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(RaayIcons.checkCircle2,
                              color: RaayColors.of(context).successText,
                              size: 16),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)
                                .ciMatched(_matchedUserIds.length.toString()),
                            style: TextStyle(
                              fontSize: 13,
                              color: kc.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (_unmatchedEmails.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(RaayIcons.alertTriangle,
                                color: RaayColors.of(context).warningText,
                                size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context).ciUnmatched(
                                    _unmatchedEmails.length.toString()),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: kc.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: RaayButton(
                        type: RaayButtonType.secondary,
                        label: AppLocalizations.of(context).ciReedit,
                        onPressed: () => setState(() => _hasParsed = false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RaayButton(
                        label: AppLocalizations.of(context)
                            .ciApply(_matchedUserIds.length.toString()),
                        icon: RaayIcons.userCheck,
                        onPressed: _matchedUserIds.isEmpty
                            ? null
                            : () => Navigator.pop(context, _matchedUserIds),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
