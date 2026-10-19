import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:kivora/core/theme/kivora_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/ui_kit/kivora_button.dart';
import '../../../core/widgets/ui_kit/kivora_card.dart';
import '../../../core/widgets/ui_kit/kivora_text_field.dart';
import '../../../services/firebase_service.dart';

class ReceiptVerificationScreen extends StatefulWidget {
  const ReceiptVerificationScreen({super.key});

  @override
  State<ReceiptVerificationScreen> createState() => _ReceiptVerificationScreenState();
}

class _ReceiptVerificationScreenState extends State<ReceiptVerificationScreen> {
  final _hashController = TextEditingController();
  bool _isSearching = false;
  Map<String, dynamic>? _foundReceipt;
  bool _searched = false;

  Future<void> _verifyReceipt() async {
    final hash = _hashController.text.trim();
    if (hash.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searched = true;
      _foundReceipt = null;
    });

    try {
      final response = await FirebaseService()
          .functions
          .httpsCallable('verifyReceipt')
          .call({'hash': hash});

      if (response.data['status'] == 'success') {
        setState(() {
          _foundReceipt = response.data as Map<String, dynamic>;
        });
      }
    } catch (_) {
      // Ignored - will show "Not Found" state
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: kc.background,
      appBar: AppBar(
        title: const Text('Public Receipt Verification'),
        backgroundColor: kc.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 40 : 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KivoraCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(KivoraIcons.shieldCheck, size: 32, color: AppTheme.primaryBlue),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Verify Ballot Receipt',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your SHA-256 cryptographic receipt hash below to confirm your ballot was permanently recorded in the ledger. For your privacy, this tool does not reveal your identity or your vote choice.',
                        style: TextStyle(fontSize: 14, color: kc.textSecondary, height: 1.5),
                      ),
                      const SizedBox(height: 32),
                      KivoraTextField(
                        label: 'RECEIPT HASH',
                        controller: _hashController,
                        hint: 'Enter your 64-character SHA-256 hash',
                        prefixIcon: KivoraIcons.lock,
                      ),
                      const SizedBox(height: 24),
                      KivoraButton(
                        label: 'Verify Receipt',
                        icon: KivoraIcons.search,
                        isLoading: _isSearching,
                        onPressed: _verifyReceipt,
                      ),
                    ],
                  ),
                ),
                
                if (_searched && !_isSearching) ...[
                  const SizedBox(height: 24),
                  if (_foundReceipt != null)
                    KivoraCard(
                      child: Column(
                        children: [
                          Icon(KivoraIcons.checkCircle, size: 48, color: AppTheme.success),
                          const SizedBox(height: 16),
                          Text(
                            'Receipt Verified',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.success),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This ballot is permanently recorded in the ledger.',
                            style: TextStyle(color: kc.textSecondary),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          _buildDetailRow('Timestamp', _foundReceipt!['votedAt'] != null ? DateTime.parse(_foundReceipt!['votedAt']).toLocal().toString() : 'Unknown', kc),
                          const SizedBox(height: 12),
                          _buildDetailRow('Privacy Mode', _foundReceipt!['privacyMode'] ?? 'Anonymous', kc),
                          const SizedBox(height: 12),
                          _buildDetailRow('Event ID', _foundReceipt!['votingEventId'] ?? 'Unknown', kc),
                        ],
                      ),
                    )
                  else
                    KivoraCard(
                      child: Column(
                        children: [
                          Icon(KivoraIcons.alertCircle, size: 48, color: AppTheme.error),
                          const SizedBox(height: 16),
                          Text(
                            'Receipt Not Found',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.error),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We could not find a matching ballot receipt in the ledger. Please ensure the hash was copied correctly.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kc.textSecondary),
                          ),
                        ],
                      ),
                    ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, KivoraColors kc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: kc.textPrimary, fontSize: 13)),
        ),
        Expanded(
          child: Text(value, style: TextStyle(color: kc.textSecondary, fontSize: 13)),
        ),
      ],
    );
  }
}
