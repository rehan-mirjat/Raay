import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../../core/theme/raay_colors.dart';

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
    // Falls back to English where no localizations are mounted (plain test apps).
    final l = Localizations.of<AppLocalizations>(context, AppLocalizations);
    String effectiveTitle = title ?? l?.evGenericTitle ?? 'An error occurred';
    String statusLabel = l?.evGenericStatus ?? 'Error';
    IconData statusIcon = Icons.error_outline_rounded;
    Color statusColor = AppTheme.error;

    switch (type) {
      case ErrorViewType.organizationRequired:
        effectiveTitle = title ?? (l?.evOrgTitle ?? 'No active organization');
        statusLabel = (l?.evOrgStatus ?? 'Organization required');
        statusIcon = Icons.domain_outlined;
        statusColor = AppTheme.primaryBlue;
        break;
      case ErrorViewType.connectionLost:
        effectiveTitle = title ?? (l?.evConnTitle ?? 'Connection lost');
        statusLabel = (l?.evConnStatus ?? 'Connection interrupted');
        statusIcon = Icons.wifi_off_rounded;
        statusColor = AppTheme.accentGold;
        break;
      case ErrorViewType.accessDenied:
        effectiveTitle = title ?? (l?.evDeniedTitle ?? 'Access denied');
        statusLabel = (l?.evDeniedStatus ?? 'Permission required');
        statusIcon = Icons.lock_outline_rounded;
        statusColor = AppTheme.accentGold;
        break;
      case ErrorViewType.sessionExpired:
        effectiveTitle = title ?? (l?.evSessionTitle ?? 'Session expired');
        statusLabel = (l?.evSessionStatus ?? 'Sign-in required');
        statusIcon = Icons.schedule_rounded;
        statusColor = AppTheme.accentGold;
        break;
      case ErrorViewType.saveUnsuccessful:
        effectiveTitle = title ?? (l?.evSaveTitle ?? 'Unable to save changes');
        statusLabel = (l?.evSaveStatus ?? 'Save unsuccessful');
        statusIcon = Icons.error_outline_rounded;
        statusColor = AppTheme.error;
        break;
      case ErrorViewType.serviceUnavailable:
        effectiveTitle = title ?? (l?.evServiceTitle ?? 'Service unavailable');
        statusLabel = (l?.evServiceStatus ?? 'Service interruption');
        statusIcon = Icons.cloud_off_rounded;
        statusColor = AppTheme.error;
        break;
      case ErrorViewType.generic:
        break;
    }

    final String defaultPrimaryLabel = switch (type) {
      ErrorViewType.organizationRequired =>
        (l?.evSelectOrg ?? 'Select organization'),
      ErrorViewType.connectionLost => (l?.errRetry ?? 'Retry'),
      ErrorViewType.accessDenied => (l?.evRequestAccess ?? 'Request access'),
      ErrorViewType.sessionExpired => (l?.evSignIn ?? 'Sign in'),
      ErrorViewType.saveUnsuccessful => (l?.errRetry ?? 'Retry'),
      ErrorViewType.serviceUnavailable => (l?.evTryAgain ?? 'Try again'),
      ErrorViewType.generic => (l?.evTryAgain ?? 'Try again'),
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
              color: RaayColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: RaayColors.borderOf(context),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
                          Expanded(
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
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
                          color: RaayColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: RaayColors.textSecondaryOf(context),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onRetry != null || onSecondaryAction != null) ...[
                  Divider(height: 1, color: RaayColors.borderOf(context)),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: RaayColors.surfaceOf(context),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16)),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        if (onSecondaryAction != null &&
                            secondaryActionLabel != null)
                          OutlinedButton(
                            onPressed: onSecondaryAction,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(48, 48),
                              foregroundColor:
                                  RaayColors.textSecondaryOf(context),
                              side: BorderSide(
                                  color: RaayColors.borderOf(context)),
                            ),
                            child: Text(secondaryActionLabel!),
                          ),
                        if (onRetry != null)
                          FilledButton.icon(
                            onPressed: onRetry,
                            icon: Icon(primaryActionIcon ?? defaultPrimaryIcon,
                                size: 18),
                            label:
                                Text(primaryActionLabel ?? defaultPrimaryLabel),
                            style: FilledButton.styleFrom(
                                minimumSize: const Size(48, 48)),
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
