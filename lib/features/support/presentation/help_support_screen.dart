import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../platform/domain/platform_report.dart' show reportCategoryText;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../core/utils/validators.dart';
import '../support_repository.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

const _kReportCategories = [
  'General feedback',
  'Election issue',
  'Technical problem',
  'Account issue',
];

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _receiptRefController = TextEditingController();
  String _category = _kReportCategories.first;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _receiptRefController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      await ref.read(supportRepositoryProvider).submit(
        category: _category, subject: _subjectController.text,
        message: _messageController.text,
        receiptReference: _category == 'Election issue' ? _receiptRefController.text : '',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).hsThanks),
            backgroundColor: AppTheme.success,
          ),
        );
        _subjectController.clear();
        _messageController.clear();
        _receiptRefController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).hsFailed),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: AlignmentDirectional.centerEnd,
                  child: OutlinedButton.icon(icon: const Icon(Icons.receipt_long_outlined),
                    onPressed: () => context.go('/help/reports'),
                    label: Text(AppLocalizations.of(context).supportMyReports))),
                Text(
                  AppLocalizations.of(context).hsTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: RaayColors.textPrimaryOf(context),
                      ),
                ),
                const SizedBox(height: 20),

                // FAQ Section
                Text(
                  AppLocalizations.of(context).hsFaq,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RaayColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFaqItem(
                  question: AppLocalizations.of(context).hsQ1,
                  answer: AppLocalizations.of(context).hsA1,
                ),
                _buildFaqItem(
                  question: AppLocalizations.of(context).hsQ2,
                  answer: AppLocalizations.of(context).hsA2,
                ),
                _buildFaqItem(
                  question: AppLocalizations.of(context).hsQ3,
                  answer: AppLocalizations.of(context).hsA3,
                ),

                const SizedBox(height: 32),

                // Getting Started
                Text(
                  AppLocalizations.of(context).hsGuidance,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RaayColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  minTileHeight: 56,
                  leading: Icon(Icons.verified_outlined,
                      color: RaayColors.of(context).accentText),
                  title: Text(AppLocalizations.of(context).hsVerify,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(AppLocalizations.of(context).hsVerifyBody),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.go('/receipt-verify'),
                ),
                ListTile(
                  minTileHeight: 56,
                  leading: Icon(Icons.policy_outlined,
                      color: RaayColors.of(context).accentText),
                  title: Text(AppLocalizations.of(context).hsTrust,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(AppLocalizations.of(context).hsTrustBody),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.go('/transparency'),
                ),
                const SizedBox(height: 32),

                // Feedback Form
                Text(
                  AppLocalizations.of(context).hsSend,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: RaayColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: RaayColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RaayColors.borderOf(context)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppLocalizations.of(context).hsCategory,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: RaayColors.textPrimaryOf(context),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: _category,
                            items: _kReportCategories
                                .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(reportCategoryText(
                                        AppLocalizations.of(context), c))))
                                .toList(),
                            onChanged: _isSubmitting ? null : (v) =>
                                setState(() => _category = v ?? _category),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context).hsSubject,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: RaayColors.textPrimaryOf(context),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _subjectController,
                            enabled: !_isSubmitting, maxLength: 200,
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context).hsSubjectHint,
                            ),
                            validator: (value) => Validators.required(value,
                                AppLocalizations.of(context).hsSubjectField),
                          ),
                          if (_category == 'Election issue') ...[
                            const SizedBox(height: 20),
                            Text(
                              AppLocalizations.of(context).hsReceipt,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: RaayColors.textPrimaryOf(context),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _receiptRefController,
                              enabled: !_isSubmitting, maxLength: 200,
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context).hsReceiptHint,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context).hsReceiptNote,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: RaayColors.textSecondaryOf(context)),
                            ),
                          ],
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context).hsMessage,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: RaayColors.textPrimaryOf(context),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _messageController,
                            enabled: !_isSubmitting, maxLength: 5000,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context).hsMessageHint,
                            ),
                            validator: (value) => Validators.required(value,
                                AppLocalizations.of(context).hsMessageField),
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _submitFeedback,
                              icon: _isSubmitting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : const Icon(Icons.send_rounded, size: 18),
                              label: Text(_isSubmitting
                                  ? AppLocalizations.of(context).hsSending
                                  : AppLocalizations.of(context).hsSendButton),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: RaayColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RaayColors.borderOf(context)),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(
            side: BorderSide.none), // removes the top/bottom line when expanded
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(
          question,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: RaayColors.textPrimaryOf(context)),
        ),
        iconColor: RaayColors.of(context).accentText,
        collapsedIconColor: RaayColors.textSecondaryOf(context),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                  color: RaayColors.textSecondaryOf(context),
                  height: 1.5,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
