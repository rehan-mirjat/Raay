import '../../l10n/app_localizations.dart';

/// Plain-language, localized name for an audit action code written by the
/// backend. A code this app does not know yet falls back to its words in
/// English rather than being hidden.
String auditActionText(AppLocalizations l, String raw) {
  final code = raw.trim().toUpperCase();
  if (code.isEmpty) return l.auditActUnknown;
  return switch (code) {
    'ACCEPT_INVITATION' => l.auditActAcceptInvitation,
    'ACTIVATE_VOTING_EVENT' => l.auditActActivateVotingEvent,
    'ADD_MEMBER' => l.auditActAddMember,
    'ASSIGN_DEPARTMENT' => l.auditActAssignDepartment,
    'CALCULATE_RESULTS' => l.auditActCalculateResults,
    'CANCEL_VOTING_EVENT' => l.auditActCancelVotingEvent,
    'CLOSE_VOTING_EVENT' => l.auditActCloseVotingEvent,
    'CREATE_CANDIDATE' => l.auditActCreateCandidate,
    'CREATE_DEPARTMENT' => l.auditActCreateDepartment,
    'CREATE_JOINING_CODE' => l.auditActCreateJoiningCode,
    'CREATE_ORGANIZATION' => l.auditActCreateOrganization,
    'CREATE_POLL_OPTION' => l.auditActCreatePollOption,
    'CREATE_VOTING_EVENT' => l.auditActCreateVotingEvent,
    'DECLINE_INVITATION' => l.auditActDeclineInvitation,
    'DELETE_CANDIDATE' => l.auditActDeleteCandidate,
    'DELETE_CANDIDATE_PHOTO' => l.auditActDeleteCandidatePhoto,
    'DELETE_DEPARTMENT' => l.auditActDeleteDepartment,
    'DELETE_ORGANIZATION' => l.auditActDeleteOrganization,
    'DELETE_POLL_OPTION' => l.auditActDeletePollOption,
    'DELETE_VOTING_EVENT' => l.auditActDeleteVotingEvent,
    'FINALIZE_CANDIDATE_PHOTO' => l.auditActFinalizeCandidatePhoto,
    'GRANT_OBSERVER_STATUS' => l.auditActGrantObserverStatus,
    'INVITE_MEMBER' => l.auditActInviteMember,
    'JOIN_ORGANIZATION_WITH_CODE' => l.auditActJoinOrganizationWithCode,
    'LEAVE_ORGANIZATION' => l.auditActLeaveOrganization,
    'PLAN_CHANGED' => l.auditActPlanChanged,
    'PLATFORM_ADMIN_ACCESS_GRANTED' => l.auditActPlatformAdminAccessGranted,
    'PLATFORM_ADMIN_ACCESS_REMOVED' => l.auditActPlatformAdminAccessRemoved,
    'PUBLISH_RESULTS' => l.auditActPublishResults,
    'PUBLISH_VOTING_EVENT' => l.auditActPublishVotingEvent,
    'REMIND_NON_VOTERS' => l.auditActRemindNonVoters,
    'REMOVE_DEPARTMENT' => l.auditActRemoveDepartment,
    'REMOVE_MEMBER' => l.auditActRemoveMember,
    'REVOKE_INVITATION' => l.auditActRevokeInvitation,
    'REVOKE_JOINING_CODE' => l.auditActRevokeJoiningCode,
    'REVOKE_OBSERVER_STATUS' => l.auditActRevokeObserverStatus,
    'UPDATE_CANDIDATE' => l.auditActUpdateCandidate,
    'UPDATE_DEPARTMENT' => l.auditActUpdateDepartment,
    'UPDATE_MEMBER_ROLE' => l.auditActUpdateMemberRole,
    'UPDATE_MEMBER_STATUS' => l.auditActUpdateMemberStatus,
    'UPDATE_ORGANIZATION_METADATA' => l.auditActUpdateOrganizationMetadata,
    'UPDATE_POLL_OPTION' => l.auditActUpdatePollOption,
    'UPDATE_VOTING_EVENT' => l.auditActUpdateVotingEvent,
    'ORGANIZATION_VERIFY' => l.auditActOrganizationVerify,
    'ORGANIZATION_REJECT' => l.auditActOrganizationReject,
    'ORGANIZATION_SUSPEND' => l.auditActOrganizationSuspend,
    'ORGANIZATION_REACTIVATE' => l.auditActOrganizationReactivate,
    _ => _readable(code),
  };
}

String _readable(String code) {
  final words =
      code.toLowerCase().split('_').where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return code;
  words[0] = words[0][0].toUpperCase() + words[0].substring(1);
  return words.join(' ');
}
