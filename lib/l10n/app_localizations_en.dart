// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kivora';

  @override
  String get navHome => 'Home';

  @override
  String get navOrganizations => 'Organizations';

  @override
  String get navOrgsShort => 'Orgs';

  @override
  String get navEvents => 'Events';

  @override
  String get navDirectory => 'Directory';

  @override
  String get navDepartments => 'Departments';

  @override
  String get navProfile => 'Profile';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navCommandCenter => 'Command Center';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionBack => 'Back';

  @override
  String get actionNext => 'Next';

  @override
  String get actionClose => 'Close';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionSignOut => 'Sign Out';

  @override
  String get authSignInTitle => 'Welcome Back';

  @override
  String get authSignInSubtitle => 'Sign in to continue';

  @override
  String get authEmail => 'Email address';

  @override
  String get authPassword => 'Password';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authSignInButton => 'Sign In Securely';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authRegisterSubtitle => 'Join Kivora today';

  @override
  String get authFullName => 'Full name';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get voteStepSelect => 'Select';

  @override
  String get voteStepReview => 'Review & Submit';

  @override
  String get voteSelectionPrompt => 'Make your selection';

  @override
  String get voteReviewBallot => 'Review Ballot';

  @override
  String get voteReviewYourBallot => 'Review your ballot';

  @override
  String get voteYourSelection => 'Your selection';

  @override
  String get voteConfirmAndCast => 'Confirm & Cast Ballot';

  @override
  String get voteSubmitting => 'Submitting Ballot...';

  @override
  String get voteAnonymousExplanation =>
      'This ballot is anonymous. Your selection is never linked to your identity in the tally, and cannot be changed after submission.';

  @override
  String get voteIdentifiableExplanation =>
      'This is an identifiable ballot. Your selection will be recorded against your account and cannot be changed after submission.';

  @override
  String get voteAlreadyVotedTitle => 'You Have Already Voted';

  @override
  String voteAlreadyVotedMessage(String eventTitle) {
    return 'Your ballot for \"$eventTitle\" has already been cast and accepted into the anonymous tally.';
  }

  @override
  String get voteViewReceipt => 'View Your Confirmation Receipt';

  @override
  String get voteViewResults => 'View Results';

  @override
  String get voteNotOpenYet =>
      'Voting has not opened yet for this election. You can review the ballot below, but submission is disabled until it becomes active.';

  @override
  String get voteClosed => 'Voting is no longer open for this election.';

  @override
  String get receiptTitle => 'Vote Receipt';

  @override
  String get receiptId => 'Receipt ID';

  @override
  String get receiptHash => 'Receipt Hash';

  @override
  String get receiptCopy => 'Copy';

  @override
  String get receiptReturnHome => 'Return to Home Feed';

  @override
  String get resultsTitle => 'Election Results';

  @override
  String get resultsTotalVotes => 'Total Votes';

  @override
  String get resultsVoterTurnout => 'Voter Turnout';

  @override
  String get resultsTurnoutRate => 'Turnout Rate';

  @override
  String get resultsViewDetailed => 'View Detailed Results';

  @override
  String get myElectionsTitle => 'My Elections';

  @override
  String get myElectionsSubtitle =>
      'Every election you can see across your organizations, in one place.';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterUpcoming => 'Upcoming';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get filterParticipated => 'Participated';

  @override
  String get filterResultsAvailable => 'Results available';

  @override
  String get calendarTitle => 'Election Calendar';

  @override
  String get calendarAddToCalendar => 'Add to calendar';

  @override
  String get emptyGenericTitle => 'Nothing here yet';

  @override
  String get emptyGenericMessage => 'There\'s nothing to show right now.';

  @override
  String get errorGenericMessage => 'Something went wrong. Please try again.';

  @override
  String get loadingGeneric => 'Loading...';

  @override
  String get accessibilitySettingsTitle => 'Accessibility & Language';

  @override
  String get accessibilityLanguage => 'Language';

  @override
  String get accessibilityLanguageSystem => 'System default';

  @override
  String get accessibilityReducedMotion => 'Reduce motion';

  @override
  String get accessibilityReducedMotionSubtitle =>
      'Minimize animations throughout the app.';

  @override
  String get accessibilityHighContrast => 'High contrast';

  @override
  String get accessibilityHighContrastSubtitle =>
      'Increase text and border contrast for better visibility.';

  @override
  String get helpSupportTitle => 'Help & Support';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get transparencyTitle => 'Trust & Transparency Center';

  @override
  String get observerDashboardTitle => 'Observer Dashboard';

  @override
  String get voterHomeTitle => 'My elections';

  @override
  String get voterHomeSubtitle =>
      'Elections you can see across your organizations.';

  @override
  String get voterSearchHint => 'Search by election or organization';

  @override
  String get voterFilterAll => 'All';

  @override
  String get voterFilterReady => 'Ready to vote';

  @override
  String get voterFilterUpcoming => 'Upcoming';

  @override
  String get voterFilterParticipated => 'Participated';

  @override
  String get voterFilterClosed => 'Closed';

  @override
  String get voterFilterResults => 'Results published';

  @override
  String get voterSectionReady => 'Ready to vote';

  @override
  String get voterSectionUpcoming => 'Upcoming';

  @override
  String get voterSectionParticipated => 'Participated';

  @override
  String get voterSectionOther => 'Other elections';

  @override
  String get voterNoElectionsTitle => 'No elections yet';

  @override
  String get voterNoElectionsBody =>
      'Elections you are eligible for will appear here.';

  @override
  String get voterNoMatchTitle => 'No matching elections';

  @override
  String get voterNoMatchBody => 'Try a different search or filter.';

  @override
  String get voterLoadError => 'We could not load your elections.';

  @override
  String get voterRetry => 'Try again';

  @override
  String get voterStatusWarning =>
      'Some details could not be loaded. Actions that depend on them are hidden until they load.';

  @override
  String get voterActionVoteNow => 'Vote now';

  @override
  String get voterActionViewReceipt => 'View receipt';

  @override
  String get voterActionViewDetails => 'View details';

  @override
  String get voterActionChecking => 'Checking your status...';

  @override
  String get voterActionResultsPending => 'Results pending';

  @override
  String get voterActionViewResults => 'View published results';

  @override
  String get voterChipParticipated => 'Participated';

  @override
  String get voterChipNotEligible => 'Not eligible';

  @override
  String get voterChipChecking => 'Checking status';

  @override
  String voterOpens(String date) {
    return 'Opens $date';
  }

  @override
  String voterCloses(String date) {
    return 'Closes $date';
  }

  @override
  String voterClosedOn(String date) {
    return 'Closed $date';
  }

  @override
  String get voterCalendar => 'Calendar';

  @override
  String get voterLoadMore => 'Show more';

  @override
  String get builderLeaveTitle => 'Leave without saving?';

  @override
  String get builderLeaveBody =>
      'You have changes that have not been saved to this draft. If you leave now they will be lost.';

  @override
  String get builderStay => 'Keep editing';

  @override
  String get builderLeave => 'Leave and discard changes';

  @override
  String get navMyElections => 'My elections';

  @override
  String get navOverview => 'Overview';

  @override
  String get navPeople => 'People';

  @override
  String get navActivity => 'Activity';

  @override
  String get navBilling => 'Billing';

  @override
  String get navOrgSettings => 'Organization settings';

  @override
  String get navAccount => 'Profile';

  @override
  String get navHelp => 'Help';

  @override
  String get navMore => 'More';

  @override
  String get navObserver => 'Observer';

  @override
  String get navPlatform => 'Platform';

  @override
  String get navCreateElection => 'Create election';

  @override
  String get navMainLabel => 'Main navigation';

  @override
  String get navMoreSectionLabel => 'More';

  @override
  String get navPlatformSectionLabel => 'Platform';

  @override
  String get adminEventsTitle => 'Elections';

  @override
  String get adminEventsSubtitle =>
      'Create, schedule and monitor elections for your organization.';

  @override
  String get adminCreateElection => 'Create election';

  @override
  String get adminCommandCenter => 'Command center';

  @override
  String get adminSearchEvents => 'Search elections';

  @override
  String get adminFilterAll => 'All';

  @override
  String get adminFilterActive => 'Active';

  @override
  String get adminFilterScheduled => 'Scheduled';

  @override
  String get adminFilterDraft => 'Draft';

  @override
  String get adminFilterClosed => 'Closed';

  @override
  String get adminFilterArchived => 'Archived';

  @override
  String get adminNoEventsTitle => 'No elections yet';

  @override
  String get adminNoEventsBody =>
      'Create your first election. You can save it as a draft and publish it when it is ready.';

  @override
  String get adminNoMatch => 'No elections match your search or filter.';

  @override
  String get adminLoadError =>
      'We could not load your elections. Check your connection and try again.';

  @override
  String get adminOrgRequiredTitle => 'No active organization';

  @override
  String get adminOrgRequiredBody =>
      'Choose an organization to manage its elections.';

  @override
  String get adminSuspendedTitle => 'Organization suspended';

  @override
  String get adminSuspendedBody =>
      'This organization is suspended, so election management is disabled.';

  @override
  String get adminProcessing => 'Updating election...';

  @override
  String adminEventRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String get adminTypeCandidate => 'Candidate election';

  @override
  String get adminTypeSingle => 'Single-choice poll';

  @override
  String get adminTypeYesNo => 'Yes/No poll';

  @override
  String get adminActionDelete => 'Delete draft';

  @override
  String get adminActionManageChoices => 'Manage choices';

  @override
  String get adminActionEdit => 'Edit details';

  @override
  String get adminActionPublish => 'Review and publish';

  @override
  String get adminActionCancel => 'Cancel election';

  @override
  String get adminActionViewDetails => 'View details';

  @override
  String get adminActionCloseEarly => 'Close early';

  @override
  String get adminActionMonitor => 'Monitor turnout';

  @override
  String get adminActionResults => 'View results';

  @override
  String get adminDeleteTitle => 'Delete this draft?';

  @override
  String adminDeleteBody(String title) {
    return '\"$title\" will be permanently deleted. This cannot be undone.';
  }

  @override
  String get adminCancelTitle => 'Cancel this election?';

  @override
  String adminCancelBody(String title) {
    return '\"$title\" will not open for voting. Voters will no longer see it as upcoming.';
  }

  @override
  String get adminCloseTitle => 'Close voting now?';

  @override
  String adminCloseBody(String title) {
    return '\"$title\" will stop accepting votes immediately. This cannot be undone.';
  }

  @override
  String get adminKeep => 'Keep it';

  @override
  String get adminConfirmDelete => 'Delete draft';

  @override
  String get adminConfirmCancel => 'Cancel election';

  @override
  String get adminConfirmClose => 'Close voting';

  @override
  String get adminGuideTitle1 => 'Set up';

  @override
  String get adminGuideBody1 => 'Details, schedule and who can vote.';

  @override
  String get adminGuideTitle2 => 'Add choices';

  @override
  String get adminGuideBody2 => 'Candidates or poll options.';

  @override
  String get adminGuideTitle3 => 'Publish';

  @override
  String get adminGuideBody3 => 'Review, then open it to voters.';

  @override
  String get adminGuideTitle4 => 'Monitor';

  @override
  String get adminGuideBody4 => 'Turnout while open, results after.';

  @override
  String get builderCreateTitle => 'Create election';

  @override
  String get builderEditTitle => 'Edit election draft';

  @override
  String get builderBack => 'Back';

  @override
  String builderStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get builderStepBasic => 'Details';

  @override
  String get builderStepSchedule => 'Schedule';

  @override
  String get builderStepEligibility => 'Eligibility';

  @override
  String get builderStepChoices => 'Choices';

  @override
  String get builderStepReview => 'Review';

  @override
  String get builderStepsLabel => 'Election setup steps';

  @override
  String get builderDraftNeeded =>
      'Save the draft first. Finish the earlier steps, then continue.';

  @override
  String get builderCreateDraftNow => 'Save draft now';

  @override
  String get builderCreateDraftFailed =>
      'Could not save the draft. Please try again.';

  @override
  String get builderStepBlocked =>
      'Finish each step with its Continue button before moving ahead.';

  @override
  String get builderLoadingDraft => 'Loading election draft...';

  @override
  String get builderAdminsOnly =>
      'Only organization admins can create or edit elections.';

  @override
  String get builderReturnHome => 'Back to home';

  @override
  String get overviewSubtitle =>
      'What needs attention and what is happening in your organization.';

  @override
  String get overviewRequiredTitle => 'Needs your attention';

  @override
  String overviewFinishDrafts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count draft elections are not published',
      one: '1 draft election is not published',
    );
    return '$_temp0';
  }

  @override
  String overviewReviewInvites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invitations are waiting for a response',
      one: '1 invitation is waiting for a response',
    );
    return '$_temp0';
  }

  @override
  String get overviewOpenElections => 'Open elections';

  @override
  String get overviewOpenPeople => 'Open people';

  @override
  String get overviewMetricMembers => 'Members';

  @override
  String get overviewMetricDepartments => 'Departments';

  @override
  String get overviewMetricLive => 'Live elections';

  @override
  String get overviewMetricUpcoming => 'Upcoming elections';

  @override
  String get overviewMetricInvites => 'Pending invitations';

  @override
  String get overviewUnavailable => 'Unavailable';

  @override
  String get overviewLoading => 'Loading';

  @override
  String get overviewElectionsTitle => 'Live and upcoming elections';

  @override
  String get overviewViewAll => 'View all';

  @override
  String get overviewNoLive => 'No live or upcoming elections.';

  @override
  String get overviewNoLiveBody => 'Create an election to get started.';

  @override
  String get overviewElectionsError => 'We could not load elections.';

  @override
  String get overviewRetry => 'Try again';

  @override
  String get overviewActivityTitle => 'Recent activity';

  @override
  String get overviewNoActivity => 'No recent activity yet.';

  @override
  String get overviewActivityError => 'Recent activity is unavailable.';

  @override
  String get overviewActivityUnknown => 'Admin action';

  @override
  String get overviewShortcuts => 'Shortcuts';

  @override
  String get overviewShortcutPeople => 'People';

  @override
  String get overviewShortcutDepartments => 'Departments';

  @override
  String get overviewShortcutCodes => 'Joining codes';

  @override
  String get overviewShortcutInvites => 'Invitations';

  @override
  String get overviewShortcutCommand => 'Command center';

  @override
  String get overviewShortcutSettings => 'Organization settings';

  @override
  String get overviewShortcutBilling => 'Plans and billing';

  @override
  String get overviewAgoNow => 'Just now';

  @override
  String overviewAgoMinutes(int n) {
    return '${n}m ago';
  }

  @override
  String overviewAgoHours(int n) {
    return '${n}h ago';
  }

  @override
  String overviewAgoDays(int n) {
    return '${n}d ago';
  }

  @override
  String overviewAgoWeeks(int n) {
    return '${n}w ago';
  }

  @override
  String overviewRole(String role) {
    return 'Your role: $role';
  }

  @override
  String get overviewLoadError =>
      'We could not load your organization. Please try again.';

  @override
  String get orgsTitle => 'Organizations';

  @override
  String get orgsSubtitle =>
      'Switch workspace, join another organization or create your own.';

  @override
  String get orgsCreate => 'Create';

  @override
  String get orgsJoin => 'Join with code';

  @override
  String get orgsScan => 'Scan QR to join';

  @override
  String get orgsInvitations => 'Invitations';

  @override
  String get orgsEmptyTitle => 'No organizations yet';

  @override
  String get orgsEmptyBody =>
      'Join an existing organization with a code or invitation, or create a new one to run elections.';

  @override
  String get orgsCreateFull => 'Create organization';

  @override
  String get orgsJoinFull => 'Join with code';

  @override
  String get orgsOpen => 'Open workspace';

  @override
  String get orgsCurrent => 'Current workspace';

  @override
  String get orgsLoadError =>
      'We could not load your organizations. Check your connection and try again.';

  @override
  String get orgsRetry => 'Try again';

  @override
  String get orgsStatusPending => 'Pending review';

  @override
  String get orgsStatusSuspended => 'Suspended';

  @override
  String get orgsStatusRejected => 'Rejected';

  @override
  String orgsRoleLine(String role) {
    return 'Your role: $role';
  }

  @override
  String get peopleTitle => 'People';

  @override
  String get peopleSubtitle => 'Manage members, roles and invitations.';

  @override
  String get peopleAddExisting => 'Add existing user';

  @override
  String get peopleInvite => 'Invite member';

  @override
  String get peopleSearchHint => 'Search by name or email';

  @override
  String get peopleSearchClear => 'Clear search';

  @override
  String get peopleFilterAll => 'All';

  @override
  String get peopleFilterManagers => 'Owners and admins';

  @override
  String get peopleFilterMembers => 'Members';

  @override
  String get peopleFilterNotActive => 'Not active';

  @override
  String get peopleNoMembersTitle => 'No members yet';

  @override
  String get peopleNoMembersBody =>
      'Add existing users or invite people to your organization.';

  @override
  String get peopleNoMatchTitle => 'No matches';

  @override
  String get peopleNoMatchBody => 'No one matches your search or filter.';

  @override
  String get peopleLoadError =>
      'We could not load the member list. Check your connection and try again.';

  @override
  String get peopleRetry => 'Try again';

  @override
  String get peopleRestricted => 'Access restricted';

  @override
  String get peopleRestrictedBody =>
      'Only organization admins can see the member list.';

  @override
  String get peopleNoOrgTitle => 'No active organization';

  @override
  String get peopleNoOrgBody => 'Choose an organization to see its people.';

  @override
  String get peopleUnknownUser => 'Unknown user';

  @override
  String peopleCount(int shown, int total) {
    return '$shown of $total people';
  }

  @override
  String get invTitle => 'Pending invitations';

  @override
  String get invRefresh => 'Refresh invitations';

  @override
  String get invLoadError => 'We could not load pending invitations.';

  @override
  String get invTryAgain => 'Try again';

  @override
  String get invNone => 'No pending invitations.';

  @override
  String get invExpired => 'Expired';

  @override
  String get invExpiringSoon => 'Expiring soon';

  @override
  String invExpiresDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Expires in $n days',
      one: 'Expires in 1 day',
    );
    return '$_temp0';
  }

  @override
  String invExpiresHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Expires in $n hours',
      one: 'Expires in 1 hour',
    );
    return '$_temp0';
  }

  @override
  String invExpiresMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Expires in $n minutes',
      one: 'Expires in 1 minute',
    );
    return '$_temp0';
  }

  @override
  String get invRevoke => 'Revoke';

  @override
  String get invRemove => 'Remove';

  @override
  String get invKeep => 'Keep it';

  @override
  String get invRevokeTitle => 'Revoke this invitation?';

  @override
  String invRevokeBody(String who) {
    return '$who will no longer be able to accept it. You can invite them again later.';
  }

  @override
  String get invRecipient => 'The recipient';

  @override
  String get invRevoked => 'Invitation revoked.';

  @override
  String get invRevokeFailed =>
      'Could not revoke the invitation. Please try again.';

  @override
  String get invOwnerOnly => 'Only an owner can revoke admin invitations';

  @override
  String get deptTitle => 'Departments';

  @override
  String get deptSubtitle =>
      'Group members into departments to limit who can vote in an election.';

  @override
  String get deptNew => 'New department';

  @override
  String get deptSearchHint => 'Search departments';

  @override
  String get deptSortName => 'Name A to Z';

  @override
  String get deptSortNameDesc => 'Name Z to A';

  @override
  String get deptSortMembers => 'Most members';

  @override
  String get deptSortLabel => 'Sort';

  @override
  String get deptNoOrgTitle => 'Choose an organization';

  @override
  String get deptNoOrgBody =>
      'Departments belong to an organization. Choose one to see its departments.';

  @override
  String get deptNoOrgAction => 'Go to home';

  @override
  String get deptEmptyManagerTitle => 'No departments yet';

  @override
  String get deptEmptyManagerBody =>
      'Create departments to organize members and limit who can vote.';

  @override
  String get deptEmptyMemberTitle => 'No department assigned';

  @override
  String get deptEmptyMemberBody =>
      'You are not assigned to a department in this organization.';

  @override
  String get deptNoMatch => 'No departments match your search.';

  @override
  String get deptLoadError =>
      'We could not load departments. Check your connection and try again.';

  @override
  String get deptRetry => 'Try again';

  @override
  String get deptMembersUnknown => 'Members: unavailable';

  @override
  String get deptEventsNone => 'Not used in an election yet';

  @override
  String get deptManageMembers => 'Manage members';

  @override
  String get deptActions => 'Department actions';

  @override
  String get deptEdit => 'Edit details';

  @override
  String get deptDelete => 'Delete department';

  @override
  String get deptDeleteTitle => 'Delete department?';

  @override
  String deptDeleteBody(String name) {
    return '\"$name\" will be permanently deleted. Members keep their records, but the department can no longer be assigned or used for voter eligibility.';
  }

  @override
  String get deptDeleteConfirm => 'Delete department';

  @override
  String get deptKeep => 'Keep it';

  @override
  String get deptDeleted => 'Department deleted.';

  @override
  String get deptDeleteFailed =>
      'Could not delete the department. Please try again.';

  @override
  String get deptCreateHint => 'Create a group for your members';

  @override
  String deptCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n departments',
      one: '1 department',
    );
    return '$_temp0';
  }

  @override
  String deptMemberCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String deptUsedIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Used in $n elections',
      one: 'Used in 1 election',
    );
    return '$_temp0';
  }

  @override
  String get inbTitle => 'Invitations';

  @override
  String get inbSubtitle =>
      'Review invitations to join an organization and choose how to respond.';

  @override
  String inbPending(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pending invitations',
      one: '1 pending invitation',
    );
    return '$_temp0';
  }

  @override
  String get inbEmptyTitle => 'You are all caught up';

  @override
  String get inbEmptyBody =>
      'Organization invitations appear here. You can accept or decline each one.';

  @override
  String get inbLoadError =>
      'We could not load your invitations. Check your connection and try again.';

  @override
  String get inbRetry => 'Try again';

  @override
  String get inbAccept => 'Accept invitation';

  @override
  String get inbDecline => 'Decline';

  @override
  String get inbAcceptExpired => 'Invitation expired';

  @override
  String get inbRole => 'Role';

  @override
  String inbExpires(String date) {
    return 'Expires $date';
  }

  @override
  String get inbExpired => 'Expired';

  @override
  String get inbNoExpiry => 'No expiry';

  @override
  String get inbDefaultOrg => 'Organization';

  @override
  String inbJoinLine(String org, String role) {
    return 'Join $org as $role';
  }

  @override
  String inbAcceptNote(String org) {
    return 'Accepting adds $org to your organizations. You can switch workspaces at any time.';
  }

  @override
  String get inbDeclineTitle => 'Decline this invitation?';

  @override
  String inbDeclineBody(String org) {
    return 'You will not join $org. An admin can invite you again later.';
  }

  @override
  String get inbKeep => 'Keep invitation';

  @override
  String get inbDeclineConfirm => 'Decline';

  @override
  String inbJoined(String org) {
    return 'You joined $org.';
  }

  @override
  String get inbDeclined => 'Invitation declined.';

  @override
  String get inbRespondFailed =>
      'We could not complete that. Please try again.';

  @override
  String get inbHelp => 'Need help with an invitation? Contact Kivora support.';

  @override
  String get ballotTitle => 'Your ballot';

  @override
  String get ballotSelectFirst => 'Choose an option before continuing.';

  @override
  String get ballotLoadError =>
      'We could not load this ballot. Check your connection and try again.';

  @override
  String get ballotRetry => 'Try again';

  @override
  String get ballotNotFound => 'This election could not be found.';

  @override
  String get ballotSignIn => 'Sign in to vote.';

  @override
  String get ballotNoCandidates =>
      'No candidates have been added to this election.';

  @override
  String get ballotNoOptions => 'No options have been added to this election.';

  @override
  String get ballotOptionsLoadError =>
      'We could not load the choices. Try again.';

  @override
  String get ballotYes => 'Yes';

  @override
  String get ballotYesDesc => 'In favor of this proposal';

  @override
  String get ballotNo => 'No';

  @override
  String get ballotNoDesc => 'Opposed to this proposal';

  @override
  String get ballotOfficial => 'Official ballot';

  @override
  String get ballotFinality =>
      'Your vote is final. After you confirm, you cannot change it or vote again.';

  @override
  String ballotTimeDays(int n) {
    return '${n}d left';
  }

  @override
  String ballotTimeHours(int n) {
    return '${n}h left';
  }

  @override
  String ballotTimeMinutes(int n) {
    return '${n}m left';
  }

  @override
  String get ballotTimeSoon => 'Closing soon';

  @override
  String get ballotTimeClosed => 'Voting closed';

  @override
  String ballotCandidate(String name) {
    return '$name, candidate';
  }

  @override
  String ballotOption(String name) {
    return '$name, option';
  }

  @override
  String get ballotSelectedSuffix => 'selected';

  @override
  String get ballotReceiptMissing =>
      'We could not find your receipt yet. Try again in a moment.';

  @override
  String get ballotYourChoice => 'Your choice';

  @override
  String ballotStepsLabel(int current, int total, String label) {
    return '$current of $total: $label';
  }

  @override
  String get receiptSuccess => 'Your ballot was recorded';

  @override
  String get receiptSecrecy =>
      'This receipt confirms that your ballot was accepted. It does not reveal or encode what you chose, and it cannot prove your choice to anyone.';

  @override
  String get receiptKeep =>
      'Keep your receipt ID. You can use it later to check that your ballot was recorded.';

  @override
  String get receiptDetails => 'Receipt details';

  @override
  String get receiptTime => 'Submitted';

  @override
  String get receiptTechnical => 'Technical details';

  @override
  String get receiptHashLabel => 'Verification hash (SHA-256)';

  @override
  String receiptCopyLabel(String label) {
    return 'Copy $label';
  }

  @override
  String receiptCopied(String label) {
    return '$label copied';
  }

  @override
  String get receiptVerify => 'Verify a receipt';

  @override
  String get receiptClose => 'Close';

  @override
  String get evBack => 'Back to elections';

  @override
  String get evLoadError =>
      'We could not load this election. Check your connection and try again.';

  @override
  String get evRetry => 'Try again';

  @override
  String get evNotFoundTitle => 'Election not found';

  @override
  String get evNotFoundBody => 'This election does not exist or was removed.';

  @override
  String get evSignInTitle => 'Sign in required';

  @override
  String get evSignInBody => 'Sign in to view this election.';

  @override
  String get evStatusLoadError =>
      'We could not check whether you have voted. Try again before voting.';

  @override
  String get evVotedTitle => 'You voted in this election';

  @override
  String get evVotedBody => 'Your participation was recorded.';

  @override
  String get evVotedNote =>
      'Each member can vote once, so voting again is not possible. Keep your receipt ID to check later that your ballot was recorded.';

  @override
  String get evViewReceipt => 'View your receipt';

  @override
  String get evReceiptMissing =>
      'We could not find your receipt yet. Try again in a moment.';

  @override
  String get evProceed => 'Go to ballot';

  @override
  String evNotAccepting(String status) {
    return 'This election is $status and is not accepting votes.';
  }

  @override
  String get evResultsPublishedTitle => 'Results are published';

  @override
  String evResultsPublishedBody(String date) {
    return 'Voting closed $date.';
  }

  @override
  String get evResultsPendingTitle => 'Results are not published yet';

  @override
  String evResultsPendingBody(String date) {
    return 'Voting closed $date. Results appear here once the organization publishes them.';
  }

  @override
  String get evResultsUnknownTitle => 'Results status unavailable';

  @override
  String get evResultsUnknownBody =>
      'We could not check whether results are published.';

  @override
  String get evViewResults => 'View results';

  @override
  String get evDetails => 'Election details';

  @override
  String get evType => 'Voting type';

  @override
  String get evWho => 'Who can vote';

  @override
  String get evOpens => 'Opens';

  @override
  String get evOpened => 'Opened';

  @override
  String get evCloses => 'Closes';

  @override
  String get evClosed => 'Closed';

  @override
  String get evIdentifiableTitle => 'Identifiable ballot.';

  @override
  String get evIdentifiableBody =>
      'Votes in this election are recorded together with the voter\'s identity.';

  @override
  String get evMonitor => 'Monitor turnout';

  @override
  String get evEditBuilder => 'Edit in builder';

  @override
  String get evChecking => 'Checking your status';

  @override
  String get resTitle => 'Election results';

  @override
  String get resBack => 'Back to election';

  @override
  String get resPublished => 'Published';

  @override
  String get resNotPublished => 'Not published';

  @override
  String get resSubtitle => 'Counted by the server after voting closed.';

  @override
  String get resAdminOnly =>
      'Only organization admins can see these results until they are published.';

  @override
  String get resFootnote =>
      'Percentages are of ballots counted. Members can see results only after an admin publishes them.';

  @override
  String get resNotAvailableTitle => 'Results are not available';

  @override
  String get resNotAvailableBody =>
      'Results appear here after the organization publishes them.';

  @override
  String get resLoadErrorTitle => 'We could not load the results';

  @override
  String get resLoadErrorBody => 'Check your connection and try again.';

  @override
  String get resRetry => 'Try again';

  @override
  String get resNoneTitle => 'No results yet';

  @override
  String get resNoneBody => 'Results have not been calculated yet.';

  @override
  String get resNoBallots => 'No ballots were recorded for this election.';

  @override
  String get resBallots => 'Ballots counted';

  @override
  String get resEligible => 'Eligible voters';

  @override
  String get resTurnout => 'Turnout';

  @override
  String get resSplit => 'Vote split';

  @override
  String get resTie => 'It\'s a tie';

  @override
  String resTieBody(String names, int votes, String percent) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes votes',
      one: '1 vote',
    );
    return '$names each received $_temp0 ($percent%).';
  }

  @override
  String resWins(String name) {
    return '$name wins';
  }

  @override
  String resWinsBody(int votes, String percent) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes votes',
      one: '1 vote',
    );
    return '$_temp0 ($percent%).';
  }

  @override
  String resVotes(int votes) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes votes',
      one: '1 vote',
    );
    return '$_temp0';
  }

  @override
  String get resRecalculate => 'Recalculate results';

  @override
  String get resWorking => 'Working...';

  @override
  String get resPublish => 'Publish results to members';

  @override
  String get resCalculate => 'Calculate results';

  @override
  String get resExport => 'Export CSV';

  @override
  String get resExportTitle => 'Export results (CSV)';

  @override
  String get resCopyCsv => 'Copy CSV';

  @override
  String get resCsvCopied => 'CSV copied';

  @override
  String get resClose => 'Close';

  @override
  String get resActionFailed => 'That did not work. Please try again.';

  @override
  String get resPublishConfirmTitle => 'Publish these results?';

  @override
  String get resPublishConfirmBody =>
      'All eligible members will be able to see the results. You can still recalculate them afterwards.';

  @override
  String get resPublishConfirm => 'Publish';

  @override
  String get resCancel => 'Cancel';

  @override
  String get resEventFallback => 'Election';

  @override
  String get monTitle => 'Live turnout';

  @override
  String get monBack => 'Back';

  @override
  String get monLive => 'Live';

  @override
  String monUpdated(int s) {
    return 'Live · updated ${s}s ago';
  }

  @override
  String get monRefresh => 'Refresh';

  @override
  String monClosesIn(String when) {
    return 'Closes in $when';
  }

  @override
  String monRemainDaysHours(int d, int h) {
    String _temp0 = intl.Intl.pluralLogic(
      d,
      locale: localeName,
      other: '$d days',
      one: '1 day',
    );
    String _temp1 = intl.Intl.pluralLogic(
      h,
      locale: localeName,
      other: '$h hours',
      one: '1 hour',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String monRemainHoursMin(int h, int m) {
    String _temp0 = intl.Intl.pluralLogic(
      h,
      locale: localeName,
      other: '$h hours',
      one: '1 hour',
    );
    return '$_temp0 $m min';
  }

  @override
  String monRemainMin(int m) {
    return '$m min';
  }

  @override
  String get monPrivacy =>
      'Counts only. No voter identities or ballot selections are shown here. Results stay hidden until the election is closed and published.';

  @override
  String get monLoadError =>
      'We could not load turnout. Check your connection and try again.';

  @override
  String get monRetry => 'Try again';

  @override
  String get monRefreshIssue =>
      'The latest refresh failed. Showing the last numbers we loaded.';

  @override
  String get monTurnoutLabel => 'Eligible members who participated';

  @override
  String monOfEligible(int voted, int eligible) {
    return '$voted of $eligible';
  }

  @override
  String get monEligible => 'Eligible';

  @override
  String get monEligibleCap => 'All active members';

  @override
  String get monVoted => 'Voted';

  @override
  String get monVotedCap => 'Ballots submitted';

  @override
  String get monNotYet => 'Not yet';

  @override
  String get monNotYetCap => 'Members remaining';

  @override
  String get monChartTitle => 'Participation over time';

  @override
  String get monChartSub =>
      'Cumulative participation since the election opened';

  @override
  String get monChartNone =>
      'Not enough data yet to chart participation over time.';

  @override
  String monChartTotal(int n) {
    return '$n voted';
  }

  @override
  String get monChartStart => 'Opened';

  @override
  String get monChartNow => 'Now';

  @override
  String get monDeptTitle => 'Turnout by department';

  @override
  String get monDeptNone => 'No department data for this election.';

  @override
  String get monDeptNote =>
      'Groups with fewer than 5 eligible members are combined to protect privacy.';

  @override
  String monDeptRow(int participated, int eligible, String percent) {
    return '$participated of $eligible · $percent%';
  }

  @override
  String get monDeptFallback => 'Department';

  @override
  String get monDetails => 'Election details';

  @override
  String get monWindow => 'Voting window';

  @override
  String get monBallotType => 'Ballot type';

  @override
  String get monAnonymous => 'Anonymous';

  @override
  String get monIdentifiable => 'Identifiable';

  @override
  String get monEligibility => 'Who can vote';

  @override
  String get monVotingType => 'Voting type';

  @override
  String get monBoostTitle => 'Boost turnout';

  @override
  String get monBoostBody =>
      'Remind members who have not voted. Reminders go to non-voters automatically; you will not see who has or has not voted.';

  @override
  String get monRemind => 'Remind non-voters';

  @override
  String get monSending => 'Sending...';

  @override
  String get monRemindNone => 'Everyone eligible has already voted.';

  @override
  String monRemindDone(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Reminder sent to $n non-voters.',
      one: 'Reminder sent to 1 non-voter.',
    );
    return '$_temp0';
  }

  @override
  String get monRemindFailed =>
      'We could not send reminders. Please try again.';

  @override
  String get monPrivateNote => 'Participation stays private';

  @override
  String get monCloseTitle => 'Close voting early';

  @override
  String get monCloseNote =>
      'Closing is final. You may need to sign in again if your last sign-in was over 15 minutes ago. Results stay hidden until you calculate and publish them.';

  @override
  String get monCloseButton => 'Close voting now';

  @override
  String get monCloseDialogTitle => 'Close voting now?';

  @override
  String get monCloseDialogBody =>
      'Closing is final. Members will no longer be able to vote, and this cannot be undone. Results stay hidden until you calculate and publish them.';

  @override
  String get monCloseConfirm => 'Close voting';

  @override
  String get monCancel => 'Cancel';

  @override
  String get monClosed => 'Voting closed.';

  @override
  String get monCloseFailed => 'We could not close voting. Please try again.';

  @override
  String get monReauth =>
      'For security, closing an election requires you to have signed in within the last 15 minutes. Please verify your identity to continue.';

  @override
  String get calTitle => 'Election calendar';

  @override
  String get calAgendaView => 'Agenda view';

  @override
  String get calCalendarView => 'Calendar view';

  @override
  String get calLoadError =>
      'We could not load the calendar. Check your connection and try again.';

  @override
  String get calRetry => 'Try again';

  @override
  String get calAllOrgs => 'All organizations';

  @override
  String get calMonth => 'Month';

  @override
  String get calWeek => 'Week';

  @override
  String get calNoneTitle => 'No elections to show';

  @override
  String get calNoneBody => 'There are no elections in your organizations yet.';

  @override
  String get calNoDayTitle => 'No elections on this day';

  @override
  String get calNoDayBody => 'Pick another date to see what is scheduled.';

  @override
  String calCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n elections',
      one: '1 election',
      zero: 'No elections',
    );
    return '$_temp0';
  }

  @override
  String get calDetails => 'Details';

  @override
  String get calAdd => 'Add to calendar';

  @override
  String calRange(String start, String end) {
    return '$start to $end';
  }

  @override
  String get authOr => 'OR';

  @override
  String get authNewUser => 'New here?';

  @override
  String get authHaveAccount => 'Already have an account?';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authRemembered => 'Remember your password?';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authUnexpectedError => 'Something went wrong. Please try again.';

  @override
  String get authMfaUnsupported =>
      'This account\'s second sign-in step is not supported by this app yet. Please contact support.';

  @override
  String get statusActive => 'ACTIVE';

  @override
  String get statusScheduled => 'SCHEDULED';

  @override
  String get statusClosed => 'CLOSED';

  @override
  String get statusArchived => 'ARCHIVED';

  @override
  String get statusCancelled => 'CANCELLED';

  @override
  String get statusDraft => 'DRAFT';

  @override
  String get statusUnknown => 'UNKNOWN';

  @override
  String get privacyAnonymous => 'ANONYMOUS';

  @override
  String get privacyIdentifiable => 'IDENTIFIABLE';

  @override
  String get roleOwner => 'OWNER';

  @override
  String get roleAdmin => 'ADMIN';

  @override
  String get roleMember => 'MEMBER';

  @override
  String get navJoiningCodes => 'Joining codes';

  @override
  String get navPlatformAccounts => 'Accounts & access';

  @override
  String get navInvitations => 'Invitations';

  @override
  String get acctTitle => 'Account Settings';

  @override
  String get acctTabProfile => 'Profile';

  @override
  String get acctTabSecurity => 'Security & Settings';

  @override
  String get acctTabNotifications => 'Notifications';

  @override
  String get acctTabPreferences => 'Preferences';

  @override
  String get acctTabAccounts => 'Connected Accounts';

  @override
  String get acctTabSecurityShort => 'Security';

  @override
  String get acctTabNotificationsShort => 'Alerts';

  @override
  String get acctTabPreferencesShort => 'Prefs';

  @override
  String get acctTabAccountsShort => 'Accounts';

  @override
  String get acctLoading => 'Loading user profile...';

  @override
  String get acctLoadError =>
      'We could not load your profile. Check your connection and try again.';

  @override
  String get acctNotFound => 'User profile not found.';

  @override
  String get acctPhotoUpdated => 'Profile photo updated successfully.';

  @override
  String get acctPhotoFailed => 'Could not upload the photo. Please try again.';

  @override
  String get acctProfileUpdated => 'Profile updated successfully.';

  @override
  String get acctVerified => 'VERIFIED';

  @override
  String get acctUnverified => 'UNVERIFIED';

  @override
  String acctMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get acctPersonalInfo => 'Personal Information';

  @override
  String get acctFirstName => 'First Name';

  @override
  String get acctLastName => 'Last Name';

  @override
  String get acctFirstNameField => 'First name';

  @override
  String get acctLastNameField => 'Last name';

  @override
  String get acctPhone => 'Phone Number (Optional)';

  @override
  String get acctSaveChanges => 'Save Changes';

  @override
  String get acctAuthMethod => 'Authentication Method';

  @override
  String get acctGoogleNote =>
      'Your account is connected to Google. Password changes are managed through your Google account.';

  @override
  String get acct2fa => 'Two-Factor Authentication';

  @override
  String get acct2faBody =>
      'Protect your account by requiring an additional authentication step.';

  @override
  String get acctSetupAuth => 'Setup Authenticator App';

  @override
  String get acctSignOut => 'Sign Out';

  @override
  String get acctAppearance => 'Appearance';

  @override
  String get acctAppearanceBody => 'Choose how Kivora looks on this device.';

  @override
  String get acctThemeLight => 'Light';

  @override
  String get acctThemeDark => 'Dark';

  @override
  String get acctThemeSystem => 'System';

  @override
  String get acctLanguage => 'Language';

  @override
  String get acctLanguageNote =>
      'Urdu, Sindhi, and Arabic translations are machine-assisted and have not yet been reviewed by a native speaker - please report anything that reads incorrectly.';

  @override
  String get acctSystemDefault => 'System default';

  @override
  String get acctAccessibility => 'Accessibility';

  @override
  String get acctReduceMotion => 'Reduce motion';

  @override
  String get acctReduceMotionBody => 'Minimize animations throughout the app.';

  @override
  String get acctHighContrast => 'High contrast';

  @override
  String get acctHighContrastBody =>
      'Increase text and border contrast for better visibility.';

  @override
  String get acctTextSizeNote =>
      'Text size follows your device\'s own accessibility settings. Candidate/option selections on the ballot screen are already labeled for screen readers.';

  @override
  String get acctNotifications => 'Notifications';

  @override
  String get acctNotificationsBody =>
      'Choose which notifications you want to receive. These apply to the notification bell and reminder emails.';

  @override
  String get acctVoteReminders => 'Vote reminders';

  @override
  String get acctVoteRemindersBody =>
      'Get notified when an active election is about to close and you haven\'t voted.';

  @override
  String get acctResultsPublished => 'Results published';

  @override
  String get acctResultsPublishedBody =>
      'Get notified when results are published for an election you were eligible to vote in.';

  @override
  String get acctInvitationAlerts => 'Organization invitations';

  @override
  String get acctInvitationAlertsBody =>
      'Show pending organization invitations in the notification bell.';

  @override
  String get acctConnectedTitle => 'Connected Accounts';

  @override
  String get acctConnectedBody =>
      'Sign-in methods linked to your Kivora account. You must keep at least one connected.';

  @override
  String get acctEmailPassword => 'Email & Password';

  @override
  String get acctGoogleSignIn => 'Sign in with your Google account.';

  @override
  String get acctConnectedBadge => 'CONNECTED';

  @override
  String get acctConnect => 'Connect';

  @override
  String get acctDisconnect => 'Disconnect';

  @override
  String acctDisconnectTitle(String name) {
    return 'Disconnect $name?';
  }

  @override
  String acctDisconnectBody(String name) {
    return 'You will no longer be able to sign in to Kivora using $name.';
  }

  @override
  String get acctCancel => 'Cancel';

  @override
  String get acctGoogleConnected => 'Google account connected.';

  @override
  String get acctChangePassword => 'Change Password';

  @override
  String get acctCurrentPassword => 'CURRENT PASSWORD';

  @override
  String get acctNewPassword => 'NEW PASSWORD';

  @override
  String get acctConfirmPassword => 'CONFIRM NEW PASSWORD';

  @override
  String get acctUpdatePassword => 'Update Password';

  @override
  String get acctPasswordUpdated => 'Password updated successfully!';
}
