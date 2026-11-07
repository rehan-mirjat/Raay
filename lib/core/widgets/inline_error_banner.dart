import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/raay_colors.dart';

/// A compact inline error message for form-level failures (wrong password,
/// failed submit, etc.) - distinct from [ErrorView], which is for a whole
/// screen/section failing to load.
class InlineErrorBanner extends StatelessWidget {
  final String message;

  const InlineErrorBanner({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: RaayColors.of(context).errorText, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: TextStyle(color: RaayColors.of(context).errorText, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
