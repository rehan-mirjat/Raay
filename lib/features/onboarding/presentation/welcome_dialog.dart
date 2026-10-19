import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../providers/onboarding_providers.dart';

class WelcomeDialog extends ConsumerWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Welcome to Kivora',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: KivoraColors.textPrimaryOf(context),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Manage your organization, members, and secure voting events in one place.',
                style: TextStyle(
                  fontSize: 15,
                  color: KivoraColors.textSecondaryOf(context),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Take a quick tour'),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ref.read(onboardingProvider.notifier).completeTour();
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: KivoraColors.textSecondaryOf(context),
                  ),
                  child: Text('Skip for now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
