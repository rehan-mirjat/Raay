import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kivora/core/theme/kivora_icons.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/ui_kit/kivora_button.dart';
import '../../../core/widgets/ui_kit/kivora_card.dart';
import '../../../core/widgets/ui_kit/kivora_text_field.dart';
import '../../../services/firebase_service.dart';
import '../domain/receipt_verification_outcome.dart';

typedef ReceiptVerifier = Future<void> Function(String hash);

class ReceiptVerificationScreen extends StatefulWidget {
  const ReceiptVerificationScreen({super.key, this.verifier});

  /// Replaces the network call. Throws exactly like the `verifyReceipt`
  /// callable does. Production leaves this null; tests inject it.
  final ReceiptVerifier? verifier;

  @override
  State<ReceiptVerificationScreen> createState() =>
      _ReceiptVerificationScreenState();
}

class _ReceiptVerificationScreenState extends State<ReceiptVerificationScreen> {
  final _hashController = TextEditingController();
  bool _isSearching = false;
  ReceiptVerificationOutcome? _outcome;

  @override
  void dispose() {
    _hashController.dispose();
    super.dispose();
  }

  Future<void> _callVerifier(String hash) async {
    final custom = widget.verifier;
    if (custom != null) return custom(hash);
    final response = await FirebaseService()
        .functions
        .httpsCallable('verifyReceipt')
        .call({'hash': hash});
    final data = response.data;
    if (data is! Map || data['status'] != 'success') {
      throw StateError('Unexpected verification response.');
    }
  }

  Future<void> _verifyReceipt() async {
    if (_isSearching) return;
    final hash = _hashController.text.trim();

    if (!isValidReceiptHash(hash)) {
      setState(() => _outcome = ReceiptVerificationOutcome.invalidInput);
      return;
    }

    setState(() {
      _isSearching = true;
      _outcome = null;
    });

    ReceiptVerificationOutcome outcome;
    try {
      await _callVerifier(hash);
      outcome = ReceiptVerificationOutcome.verified;
    } catch (e) {
      outcome = outcomeForVerifyError(e);
    }
    if (!mounted) return;
    setState(() {
      _isSearching = false;
      _outcome = outcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).rvfTitle),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: ResponsiveLayout.maxFormWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KivoraCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(KivoraIcons.shieldCheck,
                          size: 32, color: kc.accentText),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context).rvfHeading,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context).rvfIntro,
                        style: TextStyle(
                            fontSize: 14, color: kc.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      KivoraTextField(
                        label: AppLocalizations.of(context).rvfHashLabel,
                        controller: _hashController,
                        hint: AppLocalizations.of(context).rvfHashHint,
                        prefixIcon: KivoraIcons.lock,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (_) => _verifyReceipt(),
                      ),
                      const SizedBox(height: 16),
                      KivoraButton(
                        label: AppLocalizations.of(context).rvfVerify,
                        icon: KivoraIcons.search,
                        isLoading: _isSearching,
                        onPressed: _isSearching ? null : _verifyReceipt,
                      ),
                    ],
                  ),
                ),
                if (_outcome != null && !_isSearching) ...[
                  const SizedBox(height: 16),
                  _OutcomeCard(outcome: _outcome!, onRetry: _verifyReceipt),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  const _OutcomeCard({required this.outcome, required this.onRetry});

  final ReceiptVerificationOutcome outcome;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    late final IconData icon;
    late final Color color;
    late final String title;
    late final String body;
    var retry = false;

    switch (outcome) {
      case ReceiptVerificationOutcome.verified:
        icon = KivoraIcons.checkCircle;
        color = kc.successText;
        title = AppLocalizations.of(context).rvfOkTitle;
        body = AppLocalizations.of(context).rvfOkBody;
      case ReceiptVerificationOutcome.notFound:
        icon = KivoraIcons.alertCircle;
        color = kc.errorText;
        title = AppLocalizations.of(context).rvfNoTitle;
        body = AppLocalizations.of(context).rvfNoBody;
      case ReceiptVerificationOutcome.invalidInput:
        icon = Icons.edit_off_outlined;
        color = kc.warningText;
        title = AppLocalizations.of(context).rvfBadTitle;
        body = AppLocalizations.of(context).rvfBadBody;
      case ReceiptVerificationOutcome.rateLimited:
        icon = Icons.hourglass_top_rounded;
        color = kc.warningText;
        title = AppLocalizations.of(context).rvfRateTitle;
        body = AppLocalizations.of(context).rvfRateBody;
        retry = true;
      case ReceiptVerificationOutcome.unavailable:
        icon = Icons.cloud_off_outlined;
        color = kc.warningText;
        title = AppLocalizations.of(context).rvfDownTitle;
        body = AppLocalizations.of(context).rvfDownBody;
        retry = true;
    }

    return Semantics(
      liveRegion: true,
      child: KivoraCard(
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(color: kc.textSecondary, height: 1.5),
            ),
            if (retry) ...[
              const SizedBox(height: 16),
              KivoraButton(
                type: KivoraButtonType.secondary,
                label: AppLocalizations.of(context).rvfRetry,
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
