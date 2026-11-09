import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/vote_receipt.dart';

/// Shown right after a ballot is accepted. No ads here (ballot, receipt and
/// verification screens never show them).
class VoteReceiptScreen extends StatefulWidget {
  const VoteReceiptScreen({
    super.key,
    required this.receipt,
    this.eventTitle,
  });

  final VoteReceipt receipt;
  final String? eventTitle;

  @override
  State<VoteReceiptScreen> createState() => _VoteReceiptScreenState();
}

class _VoteReceiptScreenState extends State<VoteReceiptScreen> {
  bool _showQr = false;

  void _shareReceipt() {
    SharePlus.instance.share(ShareParams(
      text:
          'Raay Official Ballot Receipt\nEvent: ${widget.eventTitle ?? "Election"}\nReceipt ID: ${widget.receipt.receiptId}\nVerification Hash: ${widget.receipt.receiptHash}',
      subject: 'Vote Receipt: ${widget.receipt.receiptId}',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = RaayColors.of(context);
    final locale = Localizations.localeOf(context).toString();
    String time;
    try {
      time = DateFormat.yMMMd(locale)
          .add_jm()
          .format(widget.receipt.votedAt.toLocal());
    } catch (_) {
      time =
          DateFormat.yMMMd('en').add_jm().format(widget.receipt.votedAt.toLocal());
    }
    time = '$time ${widget.receipt.votedAt.toLocal().timeZoneName}';

    return Scaffold(
      backgroundColor: kc.background,
      appBar: AppBar(
        backgroundColor: kc.background,
        title: Text(l10n.receiptTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share receipt',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: _shareReceipt,
          ),
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
            constraints:
                const BoxConstraints(maxWidth: ResponsiveLayout.maxBallotWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kc.successText
                          .withValues(alpha: kc.isDark ? 0.16 : 0.08),
                      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                      border:
                          Border.all(color: kc.successText.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 56, color: kc.successText),
                        const SizedBox(height: 12),
                        Text(l10n.receiptSuccess,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: kc.textPrimary)),
                        if (widget.eventTitle != null &&
                            widget.eventTitle!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(widget.eventTitle!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kc.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _Note(icon: Icons.shield_outlined, text: l10n.receiptSecrecy),
                const SizedBox(height: 12),
                _Note(
                    icon: Icons.bookmark_border_rounded, text: l10n.receiptKeep),
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
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Semantics(
                              header: true,
                              child: Text(l10n.receiptDetails,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: kc.textPrimary)),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact),
                              onPressed: () => setState(() => _showQr = !_showQr),
                              icon: Icon(
                                  _showQr
                                      ? Icons.visibility_off_outlined
                                      : Icons.qr_code_2_rounded,
                                  size: 18),
                              label: Text(_showQr ? 'Hide QR' : 'Show QR'),
                            ),
                          ],
                        ),
                        if (_showQr)
                          Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusInput),
                                border: Border.all(color: kc.border),
                              ),
                              child: QrImageView(
                                data: widget.receipt.receiptHash,
                                size: 140,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        DetailTile(
                            label: l10n.receiptId,
                            value: widget.receipt.receiptId,
                            copyable: true),
                        const SizedBox(height: 16),
                        DetailTile(label: l10n.receiptTime, value: time),
                        const SizedBox(height: 8),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(bottom: 8),
                            title: Text(l10n.receiptTechnical,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: kc.textPrimary)),
                            children: [
                              DetailTile(
                                label: l10n.receiptHashLabel,
                                value: widget.receipt.receiptHash,
                                copyable: true,
                                isCode: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: _shareReceipt,
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Share Receipt'),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home_rounded),
                  label: Text(l10n.receiptReturnHome),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
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
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 14, height: 1.4, color: kc.textPrimary))),
        ],
      ),
    );
  }
}

class DetailTile extends StatefulWidget {
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
  State<DetailTile> createState() => _DetailTileState();
}

class _DetailTileState extends State<DetailTile> {
  bool _copied = false;
  Timer? _timer;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.value));
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.receiptCopied(widget.label))));
    setState(() => _copied = true);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: TextStyle(
                fontSize: 14,
                color: kc.textSecondary,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectableText(
                widget.value,
                style: TextStyle(
                  fontSize: widget.isCode ? 13 : 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: widget.isCode ? 'monospace' : null,
                  color: kc.textPrimary,
                ),
              ),
            ),
            if (widget.copyable)
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _copied
                      ? Icon(Icons.check_circle_rounded,
                          key: const ValueKey('copied'),
                          size: 20,
                          color: kc.successText)
                      : Icon(Icons.copy,
                          key: const ValueKey('copy'),
                          size: 20,
                          color: kc.accentText),
                ),
                tooltip: l10n.receiptCopyLabel(widget.label),
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: _copy,
              ),
          ],
        ),
      ],
    );
  }
}
