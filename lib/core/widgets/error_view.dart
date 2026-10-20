import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../core/theme/kivora_colors.dart';

enum ErrorViewType {
  organizationRequired,
  connectionLost,
  accessDenied,
  sessionExpired,
  saveUnsuccessful,
  serviceUnavailable,
  generic,
}

class ErrorView extends StatelessWidget {
  final ErrorViewType type;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final String? primaryActionLabel;
  final IconData? primaryActionIcon;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionLabel;

  const ErrorView({
    super.key,
    this.type = ErrorViewType.generic,
    this.title,
    required this.message,
    this.onRetry,
    this.primaryActionLabel,
    this.primaryActionIcon,
    this.onSecondaryAction,
    this.secondaryActionLabel,
  });

  @override
  Widget build(BuildContext context) {
    String effectiveTitle = title ?? 'An Error Occurred';
    String statusLabel = 'Error';
    IconData statusIcon = Icons.error_outline_rounded;
    Color statusColor = AppTheme.error;

    switch (type) {
      case ErrorViewType.organizationRequired:
        effectiveTitle = title ?? 'No active organization';
        statusLabel = 'Organization required';
        statusIcon = Icons.domain_outlined;
        statusColor = AppTheme.primaryBlue;
        break;
      case ErrorViewType.connectionLost:
        effectiveTitle = title ?? 'Connection lost';
        statusLabel = 'Connection interrupted';
        statusIcon = Icons.wifi_off_rounded;
        statusColor = AppTheme.accentGold;
        break;
      case ErrorViewType.accessDenied:
        effectiveTitle = title ?? 'Access denied';
        statusLabel = 'Permission required';
        statusIcon = Icons.lock_outline_rounded;
        statusColor = AppTheme.accentGold;
        break;
      case ErrorViewType.sessionExpired:
        effectiveTitle = title ?? 'Session expired';
        statusLabel = 'Sign-in required';
        statusIcon = Icons.schedule_rounded;
        statusColor = AppTheme.accentGold;
        break;
      case ErrorViewType.saveUnsuccessful:
        effectiveTitle = title ?? 'Unable to save changes';
        statusLabel = 'Save unsuccessful';
        statusIcon = Icons.error_outline_rounded;
        statusColor = AppTheme.error;
        break;
      case ErrorViewType.serviceUnavailable:
        effectiveTitle = title ?? 'Service unavailable';
        statusLabel = 'Service interruption';
        statusIcon = Icons.cloud_off_rounded;
        statusColor = AppTheme.error;
        break;
      case ErrorViewType.generic:
        break;
    }

    final String defaultPrimaryLabel = switch (type) {
      ErrorViewType.organizationRequired => 'Select organization',
      ErrorViewType.connectionLost => 'Retry',
      ErrorViewType.accessDenied => 'Request access',
      ErrorViewType.sessionExpired => 'Sign in',
      ErrorViewType.saveUnsuccessful => 'Retry',
      ErrorViewType.serviceUnavailable => 'Try again',
      ErrorViewType.generic => 'Try Again',
    };

    final IconData defaultPrimaryIcon = switch (type) {
      ErrorViewType.organizationRequired => Icons.expand_more_rounded,
      ErrorViewType.connectionLost => Icons.refresh_rounded,
      ErrorViewType.accessDenied => Icons.pan_tool_alt_rounded,
      ErrorViewType.sessionExpired => Icons.login_rounded,
      ErrorViewType.saveUnsuccessful => Icons.refresh_rounded,
      ErrorViewType.serviceUnavailable => Icons.refresh_rounded,
      ErrorViewType.generic => Icons.refresh_rounded,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Container(
            decoration: BoxDecoration(
              color: KivoraColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: KivoraColors.borderOf(context),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              statusIcon,
                              color: statusColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        effectiveTitle,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: KivoraColors.textSecondaryOf(context),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onRetry != null || onSecondaryAction != null) ...[
                  Divider(height: 1, color: KivoraColors.borderOf(context)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: KivoraColors.surfaceOf(context),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (onSecondaryAction != null && secondaryActionLabel != null) ...[
                          OutlinedButton(
                            onPressed: onSecondaryAction,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: KivoraColors.textSecondaryOf(context),
                              side: BorderSide(color: KivoraColors.borderOf(context)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: Text(secondaryActionLabel!),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (onRetry != null)
                          FilledButton.icon(
                            onPressed: onRetry,
                            icon: Icon(primaryActionIcon ?? defaultPrimaryIcon, size: 18),
                            label: Text(primaryActionLabel ?? defaultPrimaryLabel),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
