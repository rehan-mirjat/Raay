import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/vote_receipt.dart';

class VoteReceiptScreen extends ConsumerWidget {
  const VoteReceiptScreen({
    super.key,
    required this.receipt,
    this.eventTitle,
  });

  final VoteReceipt receipt;
  final String? eventTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.receiptTitle),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close',
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Success Banner Icon
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.success,
                    child: Icon(Icons.check, size: 48, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Ballot Successfully Cast!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                if (eventTitle != null && eventTitle!.isNotEmpty) ...[
                  Text(
                    eventTitle!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],

                // Non-revealing Secrecy Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppTheme.primaryBlue, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This digital receipt confirms your participation and ballot acceptance without revealing or encoding your selected choice.',
                          style: TextStyle(fontSize: 13, height: 1.4, color: KivoraColors.textPrimaryOf(context)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Receipt Data Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: KivoraColors.borderOf(context)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECEIPT DETAILS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textSecondaryOf(context),
                            letterSpacing: 1.1,
                          ),
                        ),
                        const Divider(height: 24),

                        // Receipt ID
                        _buildDetailTile(
                          context,
                          label: l10n.receiptId,
                          value: receipt.receiptId,
                          copyable: true,
                        ),
                        const SizedBox(height: 16),

                        // Verification Hash
                        _buildDetailTile(
                          context,
                          label: 'Verification Hash (SHA-256)',
                          value: receipt.receiptHash,
                          copyable: true,
                          isCode: true,
                        ),
                        const SizedBox(height: 16),

                        // Timestamp
                        _buildDetailTile(
                          context,
                          label: 'Submission Timestamp',
                          value: dateFormat.format(receipt.votedAt.toLocal()),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Return to Home Action
                ElevatedButton.icon(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home),
                  label: Text(l10n.receiptReturnHome),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required String label,
    required String value,
    bool copyable = false,
    bool isCode = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context), fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: SelectableText(
                value,
                style: TextStyle(
                  fontSize: isCode ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: isCode ? 'monospace' : null,
                  color: KivoraColors.textPrimaryOf(context),
                ),
              ),
            ),
            if (copyable) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.copy, size: 18, color: AppTheme.primaryBlue),
                tooltip: 'Copy $label',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$label copied to clipboard!')),
                  );
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
