import 'package:flutter/material.dart';
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
      backgroundColor: Colors.transparent,
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
                        child: const Icon(KivoraIcons.shieldCheck, size: 32, color: AppTheme.primaryBlue),
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
                        'Enter your SHA-256 receipt hash below to confirm it was received by the server. This tool verifies existence only, maintaining absolute ballot secrecy.',
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
                          const Icon(KivoraIcons.checkCircle, size: 48, color: AppTheme.success),
                          const SizedBox(height: 16),
                          const Text(
                            'Receipt Verified',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.success),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A matching receipt was found. This confirms your ballot was recorded, but does not independently prove inclusion in the final tally.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kc.textSecondary),
                          ),
                        ],
                      ),
                    )
                  else
                    KivoraCard(
                      child: Column(
                        children: [
                          const Icon(KivoraIcons.alertCircle, size: 48, color: AppTheme.error),
                          const SizedBox(height: 16),
                          const Text(
                            'Receipt Not Found',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.error),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We could not find a matching ballot receipt. Please ensure the hash was copied correctly.',
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
}
