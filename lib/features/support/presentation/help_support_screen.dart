import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_service.dart';
import '../../onboarding/providers/onboarding_providers.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user != null) {
        await FirebaseService().firestore.collection('userReports').add({
          'userId': user.uid,
          'userEmail': user.email ?? '',
          'subject': _subjectController.text.trim(),
          'message': _messageController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'open',
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback! We have received your message.'),
            backgroundColor: AppTheme.success,
          ),
        );
        _subjectController.clear();
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send feedback: $e'),
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
                Text(
                  'Help & Support',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryNavy,
                      ),
                ),
                const SizedBox(height: 20),
                
                // FAQ Section
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryNavy,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFaqItem(
                  question: 'How do I cast my vote?',
                  answer: 'You can cast your vote by selecting an active election from your organization dashboard and following the on-screen instructions.',
                ),
                _buildFaqItem(
                  question: 'Are my votes anonymous?',
                  answer: 'Yes, Kivora uses cryptographic receipts to ensure that all votes are completely anonymous and tamper-evident.',
                ),
                _buildFaqItem(
                  question: 'How can I change my profile information?',
                  answer: 'Navigate to the Account Settings page from the top-right profile dropdown menu to update your personal details.',
                ),
                
                const SizedBox(height: 32),
                
                // Getting Started
                const Text(
                  'Help & Guidance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryNavy,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.route_outlined, color: AppTheme.primaryBlue),
                  title: const Text('Restart Product Tour', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Replay the introductory walkthrough of the application features.'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {
                    ref.read(onboardingProvider.notifier).restartTour();
                    context.go('/home');
                  },
                ),
                const SizedBox(height: 32),
                
                // Feedback Form
                const Text(
                  'Send Feedback or Contact Support',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryNavy,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'SUBJECT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryNavy,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _subjectController,
                            decoration: const InputDecoration(
                              hintText: 'What is this regarding?',
                            ),
                            validator: (value) => Validators.required(value, 'Subject'),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'MESSAGE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.secondaryNavy,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _messageController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText: 'Please describe your issue or share your feedback...',
                            ),
                            validator: (value) => Validators.required(value, 'Message'),
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _submitFeedback,
                              icon: _isSubmitting 
                                  ? const SizedBox(
                                      width: 16, height: 16, 
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                    )
                                  : const Icon(Icons.send_rounded, size: 18),
                              label: Text(_isSubmitting ? 'Sending...' : 'Send Message'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none), // removes the top/bottom line when expanded
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.secondaryNavy),
        ),
        iconColor: AppTheme.primaryBlue,
        collapsedIconColor: AppTheme.textSecondary,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: const TextStyle(color: AppTheme.textSecondary, height: 1.5, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
