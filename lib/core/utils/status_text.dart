import '../../l10n/app_localizations.dart';

/// Localized word for an organization status ("pending", "verified", ...).
/// An unknown status is returned as it came.
String orgStatusText(AppLocalizations l, String status) => switch (status.toLowerCase()) {
      'pending' => l.osPending,
      'verified' => l.osVerified,
      'active' => l.osActive,
      'suspended' => l.osSuspended,
      'rejected' => l.osRejected,
      'archived' => l.osArchived,
      _ => status,
    };
