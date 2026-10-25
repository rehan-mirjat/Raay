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

/// Localized organization role ("owner", "admin", "member").
String memberRoleText(AppLocalizations l, String role) => switch (role.toLowerCase()) {
      'owner' => l.roleOwner,
      'admin' => l.roleAdmin,
      'member' => l.roleMember,
      _ => role,
    };

/// Localized membership status ("active", "inactive", ...).
String memberStatusText(AppLocalizations l, String status) => switch (status.toLowerCase()) {
      'active' => l.msActive,
      'inactive' => l.msInactive,
      'pending' => l.msPending,
      'suspended' => l.msSuspended,
      'removed' => l.msRemoved,
      _ => status,
    };
