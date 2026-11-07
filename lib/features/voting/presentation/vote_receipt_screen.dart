import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/vote_receipt.dart';

/// Shown right after a ballot is accepted. No ads here (ballot, receipt and
/// verification screens never show them).
class VoteReceiptScreen extends StatelessWidget {
  const VoteReceiptScreen({
    super.key,
    required this.receipt,
    this.eventTitle,
  });

  final VoteReceipt receipt;
  final String? eventTitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = RaayColors.of(context);
    final locale = Localizations.localeOf(context).toString();
    String time;
    try {
      time = DateFormat.yMMMd(locale).add_jm().format(receipt.votedAt.toLocal());
    } catch (_) {
      time = DateFormat.yMMMd('en').add_jm().format(receipt.votedAt.toLocal());
    }
    time = '$time ${receipt.votedAt.toLocal().timeZoneName}';

    return Scaffold(
      backgroundColor: kc.background,
      appBar: AppBar(
        backgroundColor: kc.background,
        title: Text(l10n.receiptTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.receiptClose,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: ResponsiveLayout.pagePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxBallotWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kc.successText.withValues(alpha: kc.isDark ? 0.16 : 0.08),
                      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                      border: Border.all(color: kc.successText.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_rounded, size: 56, color: kc.successText),
                        const SizedBox(height: 12),
                        Text(l10n.receiptSuccess,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                        if (eventTitle != null && eventTitle!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(eventTitle!,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kc.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _Note(icon: Icons.shield_outlined, text: l10n.receiptSecrecy),
                const SizedBox(height: 12),
                _Note(icon: Icons.bookmark_border_rounded, text: l10n.receiptKeep),
                const SizedBox(height: 16),
                Material(
                  color: kc.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                    side: BorderSide(color: kc.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(l10n.receiptDetails,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                      ),
                      const SizedBox(height: 16),
                      DetailTile(label: l10n.receiptId, value: receipt.receiptId, copyable: true),
                      const SizedBox(height: 16),
                      DetailTile(label: l10n.receiptTime, value: time),
                      const SizedBox(height: 8),
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: const EdgeInsets.only(bottom: 8),
                          title: Text(l10n.receiptTechnical,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kc.textPrimary)),
                          children: [
                            DetailTile(
                              label: l10n.receiptHashLabel,
                              value: receipt.receiptHash,
                              copyable: true,
                              isCode: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home_rounded),
                  label: Text(l10n.receiptReturnHome),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () => context.go('/receipt-verify'),
                  icon: const Icon(Icons.verified_outlined),
                  label: Text(l10n.receiptVerify),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        border: Border.all(color: kc.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kc.accentText, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14, height: 1.4, color: kc.textPrimary))),
        ],
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  const DetailTile({
    super.key,
    required this.label,
    required this.value,
    this.copyable = false,
    this.isCode = false,
  });

  final String label;
  final String value;
  final bool copyable;
  final bool isCode;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: kc.textSecondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectableText(
                value,
                style: TextStyle(
                  fontSize: isCode ? 13 : 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: isCode ? 'monospace' : null,
                  color: kc.textPrimary,
                ),
              ),
            ),
            if (copyable)
              IconButton(
                icon: Icon(Icons.copy, size: 20, color: kc.accentText),
                tooltip: l10n.receiptCopyLabel(label),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l10n.receiptCopied(label))));
                },
              ),
          ],
        ),
      ],
    );
  }
}
