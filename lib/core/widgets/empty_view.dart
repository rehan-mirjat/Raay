import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../core/theme/raay_colors.dart';

class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyView({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: RaayColors.of(context).accentText,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: RaayColors.textPrimaryOf(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14,
                  color: RaayColors.textSecondaryOf(context),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
