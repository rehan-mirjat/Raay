import '../../../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/kivora_colors.dart';
import '../../../../../core/theme/kivora_icons.dart';
import '../../../../../core/widgets/ui_kit/kivora_button.dart';
import '../../../../../core/widgets/ui_kit/kivora_text_field.dart';

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

  void _parseCsv() {
    final text = _csvController.text.trim();
    if (text.isEmpty) return;

    // Split by newlines, commas, or semicolons
    final lines = text.split(RegExp(r'[\r\n,;]+'));
    final emailSet = <String>{};

    for (var line in lines) {
      final cleaned = line.trim().toLowerCase();
      // Basic email regex match or simple string cleanup
      if (cleaned.contains('@') && cleaned.contains('.')) {
        // Strip quotes or extra text if any
        final match = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')
            .stringMatch(cleaned);
        if (match != null) {
          emailSet.add(match.toLowerCase());
        }
      }
    }

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
    final kc = KivoraColors.of(context);

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
                        child: Icon(KivoraIcons.fileSpreadsheet,
                            color: KivoraColors.of(context).accentText,
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
                    icon: const Icon(KivoraIcons.x, size: 20),
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
              KivoraTextField(
                controller: _csvController,
                label: AppLocalizations.of(context).ciLabel,
                hint: AppLocalizations.of(context).ciHint,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              if (!_hasParsed)
                KivoraButton(
                  label: AppLocalizations.of(context).ciParse,
                  icon: KivoraIcons.check,
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
                          Icon(KivoraIcons.checkCircle2,
                              color: KivoraColors.of(context).successText,
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
                            Icon(KivoraIcons.alertTriangle,
                                color: KivoraColors.of(context).warningText,
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
                      child: KivoraButton(
                        type: KivoraButtonType.secondary,
                        label: AppLocalizations.of(context).ciReedit,
                        onPressed: () => setState(() => _hasParsed = false),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KivoraButton(
                        label: AppLocalizations.of(context)
                            .ciApply(_matchedUserIds.length.toString()),
                        icon: KivoraIcons.userCheck,
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
