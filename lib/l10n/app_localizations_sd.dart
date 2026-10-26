// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Sindhi (`sd`).
class AppLocalizationsSd extends AppLocalizations {
  AppLocalizationsSd([String locale = 'sd']) : super(locale);

  @override
  String get appName => 'ڪيووريا';

  @override
  String get navHome => 'گهر';

  @override
  String get navOrganizations => 'تنظيمون';

  @override
  String get navOrgsShort => 'تنظيمون';

  @override
  String get navEvents => 'اليڪشن';

  @override
  String get navDirectory => 'ڊائريڪٽري';

  @override
  String get navDepartments => 'کاتا';

  @override
  String get navProfile => 'پروفائيل';

  @override
  String get navCalendar => 'ڪئلينڊر';

  @override
  String get navCommandCenter => 'ڪمانڊ سينٽر';

  @override
  String get actionSave => 'محفوظ ڪريو';

  @override
  String get actionCancel => 'رد ڪريو';

  @override
  String get actionDelete => 'ختم ڪريو';

  @override
  String get actionConfirm => 'تصديق ڪريو';

  @override
  String get actionBack => 'پٺتي';

  @override
  String get actionNext => 'اڳيون';

  @override
  String get actionClose => 'بند ڪريو';

  @override
  String get actionRetry => 'ٻيهر ڪوشش ڪريو';

  @override
  String get actionSignOut => 'سائن آئوٽ';

  @override
  String get authSignInTitle => 'ڀليڪار';

  @override
  String get authSignInSubtitle => 'جاري رکڻ لاءِ سائن ان ڪريو';

  @override
  String get authEmail => 'اي ميل ائڊريس';

  @override
  String get authPassword => 'پاسورڊ';

  @override
  String get authForgotPassword => 'پاسورڊ وسري ويو؟';

  @override
  String get authSignInButton => 'محفوظ طريقي سان سائن ان ڪريو';

  @override
  String get authContinueWithGoogle => 'گوگل سان جاري رکو';

  @override
  String get authCreateAccount => 'اڪائونٽ ٺاهيو';

  @override
  String get authNoAccount => 'اڪائونٽ ناهي؟';

  @override
  String get authRegisterTitle => 'اڪائونٽ ٺاهيو';

  @override
  String get authRegisterSubtitle => 'اڄ ئي ڪيووريا ۾ شامل ٿيو';

  @override
  String get authFullName => 'پورو نالو';

  @override
  String get authConfirmPassword => 'پاسورڊ جي تصديق ڪريو';

  @override
  String get voteStepSelect => 'چونڊيو';

  @override
  String get voteStepReview => 'جائزو ۽ جمع ڪرايو';

  @override
  String get voteSelectionPrompt => 'پنهنجي چونڊ ڪريو';

  @override
  String get voteReviewBallot => 'بيلٽ جو جائزو وٺو';

  @override
  String get voteReviewYourBallot => 'پنهنجي بيلٽ جو جائزو وٺو';

  @override
  String get voteYourSelection => 'توهان جي چونڊ';

  @override
  String get voteConfirmAndCast => 'تصديق ڪريو ۽ ووٽ ڏيو';

  @override
  String get voteSubmitting => 'بيلٽ جمع ڪجي رهيو آهي...';

  @override
  String get voteAnonymousExplanation =>
      'هي بيلٽ ڳجھو آهي. توهان جي چونڊ ڪڏهن به ڳڻپ ۾ توهان جي سڃاڻپ سان نه ڳنڍبي، ۽ جمع ڪرائڻ کان پوءِ تبديل نه ٿي سگهندي.';

  @override
  String get voteIdentifiableExplanation =>
      'هي هڪ سڃاڻپ وارو بيلٽ آهي. توهان جي چونڊ توهان جي اڪائونٽ خلاف رڪارڊ ڪئي ويندي ۽ جمع ڪرائڻ کان پوءِ تبديل نه ٿي سگهندي.';

  @override
  String get voteAlreadyVotedTitle => 'توهان اڳ ۾ ئي ووٽ ڏئي چڪا آهيو';

  @override
  String voteAlreadyVotedMessage(String eventTitle) {
    return '\"$eventTitle\" لاءِ توهان جو بيلٽ اڳ ۾ ئي جمع ٿي چڪو آهي ۽ ڳجھي ڳڻپ ۾ شامل ٿي چڪو آهي.';
  }

  @override
  String get voteViewReceipt => 'پنهنجي تصديقي رسيد ڏسو';

  @override
  String get voteViewResults => 'نتيجا ڏسو';

  @override
  String get voteNotOpenYet =>
      'هن اليڪشن لاءِ ووٽنگ اڃا شروع نه ٿي آهي. توهان هيٺ بيلٽ جو جائزو وٺي سگهو ٿا، پر جمع ڪرائڻ ان جي فعال ٿيڻ تائين بند آهي.';

  @override
  String get voteClosed => 'هن اليڪشن لاءِ ووٽنگ هاڻي کليل ناهي.';

  @override
  String get receiptTitle => 'ووٽ جي رسيد';

  @override
  String get receiptId => 'رسيد نمبر';

  @override
  String get receiptHash => 'رسيد هيش';

  @override
  String get receiptCopy => 'ڪاپي ڪريو';

  @override
  String get receiptReturnHome => 'گهر واپس وڃو';

  @override
  String get resultsTitle => 'اليڪشن جا نتيجا';

  @override
  String get resultsTotalVotes => 'ڪل ووٽ';

  @override
  String get resultsVoterTurnout => 'ووٽرن جي شرڪت';

  @override
  String get resultsTurnoutRate => 'شرڪت جي شرح';

  @override
  String get resultsViewDetailed => 'تفصيلي نتيجا ڏسو';

  @override
  String get myElectionsTitle => 'منهنجا اليڪشن';

  @override
  String get myElectionsSubtitle =>
      'توهان جي سڀني تنظيمن ۾ نظر ايندڙ هر اليڪشن، هڪ ئي جاءِ تي.';

  @override
  String get filterAll => 'سڀ';

  @override
  String get filterActive => 'فعال';

  @override
  String get filterUpcoming => 'ايندڙ';

  @override
  String get filterCompleted => 'مڪمل ٿيل';

  @override
  String get filterParticipated => 'شرڪت ڪئي';

  @override
  String get filterResultsAvailable => 'نتيجا موجود آهن';

  @override
  String get calendarTitle => 'اليڪشن ڪئلينڊر';

  @override
  String get calendarAddToCalendar => 'ڪئلينڊر ۾ شامل ڪريو';

  @override
  String get emptyGenericTitle => 'اڃا هتي ڪجهه ناهي';

  @override
  String get emptyGenericMessage => 'هن وقت ڏيکارڻ لاءِ ڪجهه ناهي.';

  @override
  String get errorGenericMessage =>
      'ڪجهه غلط ٿي ويو. مهرباني ڪري ٻيهر ڪوشش ڪريو.';

  @override
  String get loadingGeneric => 'لوڊ ٿي رهيو آهي...';

  @override
  String get accessibilitySettingsTitle => 'رسائي ۽ ٻولي';

  @override
  String get accessibilityLanguage => 'ٻولي';

  @override
  String get accessibilityLanguageSystem => 'سسٽم ڊفالٽ';

  @override
  String get accessibilityReducedMotion => 'حرڪت گهٽايو';

  @override
  String get accessibilityReducedMotionSubtitle =>
      'سڄي ايپ ۾ اينيميشن گهٽ ڪريو.';

  @override
  String get accessibilityHighContrast => 'هاءِ ڪنٽراسٽ';

  @override
  String get accessibilityHighContrastSubtitle =>
      'بهتر نظر اچڻ لاءِ متن ۽ بارڊر جو ڪنٽراسٽ وڌايو.';

  @override
  String get helpSupportTitle => 'مدد ۽ سهائتا';

  @override
  String get notificationsTitle => 'اطلاعون';

  @override
  String get transparencyTitle => 'اعتماد ۽ شفافيت مرڪز';

  @override
  String get observerDashboardTitle => 'مبصر ڊيش بورڊ';

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
      'All eligible members will be able to see the results, and those who have result notifications on will be notified. You can still recalculate them afterwards.';

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

  @override
  String get navPlatformOverview => 'Platform overview';

  @override
  String get navPlatformOrganizations => 'All organizations';

  @override
  String get navPlatformReports => 'User reports';

  @override
  String get navPlatformAudit => 'Audit log';

  @override
  String get resNotClosedYet =>
      'Results can be calculated once the election has closed.';

  @override
  String get orgSetSaveTitle => 'Save your branding changes?';

  @override
  String get orgSetUnsavedBody =>
      'You changed this organization\'s branding but have not saved it. Discarded changes cannot be recovered.';

  @override
  String get orgSetKeepEditing => 'Keep editing';

  @override
  String get orgSetDiscard => 'Discard';

  @override
  String get orgSetSave => 'Save';

  @override
  String get orgSetLoading => 'Loading organization…';

  @override
  String get orgSetLoadError =>
      'We could not load the organization. Check your connection and try again.';

  @override
  String get orgSetNoOrgTitle => 'No active organization';

  @override
  String get orgSetNoOrgBody =>
      'Select an organization before changing its branding.';

  @override
  String get orgSetDeniedTitle => 'Access denied';

  @override
  String get orgSetDeniedBody =>
      'Only the organization Owner can update its branding.';

  @override
  String get orgSetBackOverview => 'Overview';

  @override
  String get orgSetTitle => 'Organization branding';

  @override
  String orgSetSubtitle(String a) {
    return 'Shape how $a appears to members and voters.';
  }

  @override
  String get orgSetDetails => 'Organization details';

  @override
  String get orgSetDetailsBody =>
      'Your public name and a short introduction to your organization.';

  @override
  String get orgSetNameLabel => 'Organization name *';

  @override
  String get orgSetNameHint => 'e.g. Acme Corporation';

  @override
  String get orgSetNameShort => 'Use at least 3 characters.';

  @override
  String get orgSetDescription => 'Description';

  @override
  String get orgSetDescriptionHint =>
      'Brief summary of your organization or department...';

  @override
  String get orgSetDescriptionHelp =>
      'A short introduction shown on your organization profile.';

  @override
  String get orgSetWebsite => 'Website (optional)';

  @override
  String get orgSetWebsiteInvalid => 'Enter a valid HTTPS URL.';

  @override
  String get orgSetLogo => 'Organization logo';

  @override
  String get orgSetLogoActive => 'Logo active';

  @override
  String get orgSetLogoNone => 'No logo uploaded';

  @override
  String get orgSetLogoChange => 'Choose a different logo';

  @override
  String get orgSetLogoChoose => 'Choose logo';

  @override
  String get orgSetRemove => 'Remove';

  @override
  String get orgSetLogoHelp =>
      'PNG, JPEG or WebP · Up to 2 MB\nUse a square image for the best result.';

  @override
  String get orgSetPreviewName => 'Organization Name';

  @override
  String get orgSetPreviewDescription => 'Description will appear here...';

  @override
  String get orgSetPreviewNoWebsite => 'No website added';

  @override
  String get orgSetPreviewTitle => 'Member profile preview';

  @override
  String get orgSetPreviewBody =>
      'How your organization will appear to members.';

  @override
  String get orgSetPreviewRole => 'Member';

  @override
  String get orgSetPreviewViewEvents => 'View events';

  @override
  String get orgSetPreviewNote =>
      'Preview only. Changes appear to members and voters after you save.';

  @override
  String get orgSetNotPermTitle => 'Branding, not permissions';

  @override
  String get orgSetNotPermBody =>
      'Access control and verification are managed separately. Updating your branding won\'t change either.';

  @override
  String get orgSetDirtyTitle => 'You have unsaved changes';

  @override
  String get orgSetDirtyLogo =>
      'A new logo is selected but not uploaded yet. Save to upload and publish it.';

  @override
  String get orgSetDirtyBody =>
      'Save to publish your branding, or reset to discard your changes.';

  @override
  String get orgSetReset => 'Reset';

  @override
  String get orgSetSaving => 'Saving...';

  @override
  String get orgSetSaveBranding => 'Save branding';

  @override
  String get orgSetLogoTooBig =>
      'The logo is larger than 2 MB. Choose a smaller image.';

  @override
  String get orgSetSaved => 'Organization branding saved.';

  @override
  String get orgSetSaveFailed =>
      'Could not save branding. Check your connection and try again.';

  @override
  String get orgSetDanger => 'Danger zone';

  @override
  String get orgSetDangerBody =>
      'Deleting this organization will archive its workspace. Active elections will stop accepting ballots.';

  @override
  String get orgSetDelete => 'Delete organization';

  @override
  String get orgSetDeleteTitle => 'Delete Organization?';

  @override
  String orgSetDeleteBody(String a) {
    return 'Are you sure you want to delete \"$a\"?\n\nThis will archive the organization workspace. This action cannot be undone.';
  }

  @override
  String get orgSetKeep => 'Keep organization';

  @override
  String get orgSetDeleted => 'Organization has been deleted.';

  @override
  String get jcMaxUsesInvalid => 'Enter a maximum use count from 0 to 100,000.';

  @override
  String get jcSaveTitle => 'Save this joining code';

  @override
  String get jcShownOnce =>
      'This code is shown once. Share it only with people you want to join this organization.';

  @override
  String get jcScanHint =>
      'Or scan this with Kivora\'s \"Scan to Join\" on another device.';

  @override
  String get jcCopied => 'Copied';

  @override
  String get jcCopy => 'Copy code';

  @override
  String get jcDone => 'Done';

  @override
  String get jcRevokeTitle => 'Revoke this code?';

  @override
  String get jcCancel => 'Cancel';

  @override
  String get jcRevoke => 'Revoke code';

  @override
  String get jcRevokeNoId =>
      'This code cannot be revoked (missing identifier).';

  @override
  String get jcRevoked => 'Joining code revoked.';

  @override
  String get jcTitle => 'Joining codes';

  @override
  String get jcRefresh => 'Refresh joining codes';

  @override
  String get jcLoading => 'Loading organization…';

  @override
  String get jcOrgLoadError =>
      'We could not load this organization. Check your connection and try again.';

  @override
  String get jcNoOrgTitle => 'Select an organization';

  @override
  String get jcNoOrgBody =>
      'Choose an organization before managing joining codes.';

  @override
  String get jcAdminTitle => 'Administrator access required';

  @override
  String get jcAdminBody =>
      'Only this organization’s Owner and Admins can manage joining codes.';

  @override
  String get jcSubtitle =>
      'Create and revoke codes that let people join this organization. A valid code adds the person as a member straight away; it never grants admin or owner access.';

  @override
  String get jcStatActive => 'Active codes';

  @override
  String get jcStatExpired => 'Expired or used up';

  @override
  String get jcStatRevoked => 'Revoked';

  @override
  String get jcExisting => 'Existing codes';

  @override
  String get jcLoadError =>
      'We could not load joining codes. Check your connection and try again.';

  @override
  String get jcEmpty => 'There are no joining codes for this organization.';

  @override
  String get jcCreateTitle => 'Create a joining code';

  @override
  String get jcCreateNote =>
      'A code is shown once. It is stored as a secure hash and cannot be retrieved later.';

  @override
  String get jcCreating => 'Creating…';

  @override
  String get jcCreate => 'Create code';

  @override
  String get jcExpiresAfter => 'Expires after';

  @override
  String get jcExp24h => '24 hours';

  @override
  String get jcExp3d => '3 days';

  @override
  String get jcExp7d => '7 days';

  @override
  String get jcExp30d => '30 days';

  @override
  String get jcExp1y => '1 year';

  @override
  String get jcMaxUses => 'Maximum uses';

  @override
  String get jcMaxUsesHint => 'Use 0 for unlimited.';

  @override
  String get jcExpiryUnknown => 'Expiry unavailable';

  @override
  String jcExpires(String a) {
    return 'Expires $a';
  }

  @override
  String jcUses(String a) {
    return '$a uses';
  }

  @override
  String jcUsesOf(String a, String b) {
    return '$a of $b uses';
  }

  @override
  String get dmDeleteTitle => 'Delete Department';

  @override
  String dmDeleteBody(String a) {
    return 'Are you sure you want to delete \"$a\"?\n\nThis permanently deletes the department.';
  }

  @override
  String get dmCancel => 'Cancel';

  @override
  String get dmDeleted => 'Department deleted successfully.';

  @override
  String dmDeleteFailed(String a) {
    return 'Failed to delete: $a';
  }

  @override
  String get dmDeletePermanent => 'Delete Permanently';

  @override
  String dmAssigned(String a, String b) {
    return 'Successfully assigned $a member(s) to $b.';
  }

  @override
  String dmAssignFailed(String a) {
    return 'Failed to assign members: $a';
  }

  @override
  String get dmRemoveFrom => 'Remove from department';

  @override
  String dmRemoveBody(String a) {
    return 'Remove \"$a\" from this department?';
  }

  @override
  String get dmRemove => 'Remove';

  @override
  String dmRemoved(String a) {
    return 'Removed $a from department.';
  }

  @override
  String dmRemoveFailed(String a) {
    return 'Failed to remove member: $a';
  }

  @override
  String get dmNoOrgTitle => 'No Active Organization';

  @override
  String get dmNoOrgBody =>
      'Please select an organization context to view department members.';

  @override
  String get dmLoadingDept => 'Loading department details...';

  @override
  String get dmLoadingRoster => 'Loading department roster...';

  @override
  String get dmRosterError =>
      'We could not load the roster. Check your connection and try again.';

  @override
  String get dmBack => 'Departments';

  @override
  String dmAssignedCount(String a) {
    return '$a assigned members';
  }

  @override
  String get dmEligibleNote =>
      'Members in this department can be chosen as eligible voters for elections.';

  @override
  String get dmEdit => 'Edit details';

  @override
  String get dmDelete => 'Delete';

  @override
  String dmMembersIn(String a) {
    return 'Members in $a';
  }

  @override
  String get dmNoMembers => 'No members assigned yet';

  @override
  String get dmNoMembersBody =>
      'Choose people from the list to add them to this department. You can change it at any time.';

  @override
  String get dmAssignedHere => 'Assigned members will appear here.';

  @override
  String dmPendingNote(String a, String b) {
    return 'Pending selections are not members yet. Confirm with \"Assign $a members\" to add them to $b.';
  }

  @override
  String get dmAddMembers => 'Add members';

  @override
  String dmSelectPeople(String a) {
    return 'Select people to assign to $a.';
  }

  @override
  String get dmSearch => 'Search by name';

  @override
  String get dmAllMembers => 'All members';

  @override
  String get dmNoDept => 'No department';

  @override
  String get dmNoMatch => 'No members match your search.';

  @override
  String dmIn(String a) {
    return 'In $a';
  }

  @override
  String dmInFirst(String a) {
    return 'In $a';
  }

  @override
  String dmAssignedTo(String a) {
    return 'Assigned to $a';
  }

  @override
  String get dmClear => 'Clear';

  @override
  String dmPendingTo(String a) {
    return 'Pending assignment to $a';
  }

  @override
  String get dmAssigning => 'Assigning...';

  @override
  String dmAssign(String a) {
    return 'Assign $a members';
  }

  @override
  String jcRevokeBody(String a) {
    return 'Anyone who has this code will no longer be able to use it. ($a)';
  }

  @override
  String jcCodeLabel(String a) {
    return 'Code • $a';
  }

  @override
  String get statusExhausted => 'EXHAUSTED';

  @override
  String get statusExpired => 'EXPIRED';

  @override
  String get statusRevoked => 'REVOKED';

  @override
  String get dmMemberFallback => 'Member';

  @override
  String dmSelectedCount(String a) {
    return '$a selected';
  }

  @override
  String get auditActAcceptInvitation => 'Invitation accepted';

  @override
  String get auditActActivateVotingEvent => 'Election activated';

  @override
  String get auditActAddMember => 'Member added';

  @override
  String get auditActAssignDepartment => 'Department assigned';

  @override
  String get auditActCalculateResults => 'Results calculated';

  @override
  String get auditActCancelVotingEvent => 'Election cancelled';

  @override
  String get auditActCloseVotingEvent => 'Election closed';

  @override
  String get auditActCreateCandidate => 'Candidate added';

  @override
  String get auditActCreateDepartment => 'Department created';

  @override
  String get auditActCreateJoiningCode => 'Joining code created';

  @override
  String get auditActCreateOrganization => 'Organization created';

  @override
  String get auditActCreatePollOption => 'Poll option added';

  @override
  String get auditActCreateVotingEvent => 'Election created';

  @override
  String get auditActDeclineInvitation => 'Invitation declined';

  @override
  String get auditActDeleteCandidate => 'Candidate removed';

  @override
  String get auditActDeleteCandidatePhoto => 'Candidate photo removed';

  @override
  String get auditActDeleteDepartment => 'Department deleted';

  @override
  String get auditActDeleteOrganization => 'Organization deleted';

  @override
  String get auditActDeletePollOption => 'Poll option removed';

  @override
  String get auditActDeleteVotingEvent => 'Election deleted';

  @override
  String get auditActFinalizeCandidatePhoto => 'Candidate photo saved';

  @override
  String get auditActGrantObserverStatus => 'Observer access granted';

  @override
  String get auditActInviteMember => 'Member invited';

  @override
  String get auditActJoinOrganizationWithCode => 'Joined with a code';

  @override
  String get auditActLeaveOrganization => 'Left the organization';

  @override
  String get auditActPlanChanged => 'Plan changed';

  @override
  String get auditActPlatformAdminAccessGranted =>
      'Platform admin access granted';

  @override
  String get auditActPlatformAdminAccessRemoved =>
      'Platform admin access removed';

  @override
  String get auditActPublishResults => 'Results published';

  @override
  String get auditActPublishVotingEvent => 'Election published';

  @override
  String get auditActRemindNonVoters => 'Reminder sent to non-voters';

  @override
  String get auditActRemoveDepartment => 'Member removed from department';

  @override
  String get auditActRemoveMember => 'Member removed';

  @override
  String get auditActRevokeInvitation => 'Invitation revoked';

  @override
  String get auditActRevokeJoiningCode => 'Joining code revoked';

  @override
  String get auditActRevokeObserverStatus => 'Observer access removed';

  @override
  String get auditActUpdateCandidate => 'Candidate updated';

  @override
  String get auditActUpdateDepartment => 'Department updated';

  @override
  String get auditActUpdateMemberRole => 'Member role changed';

  @override
  String get auditActUpdateMemberStatus => 'Member status changed';

  @override
  String get auditActUpdateOrganizationMetadata =>
      'Organization details updated';

  @override
  String get auditActUpdatePollOption => 'Poll option updated';

  @override
  String get auditActUpdateVotingEvent => 'Election updated';

  @override
  String get auditActOrganizationVerify => 'Organization verified';

  @override
  String get auditActOrganizationReject => 'Organization rejected';

  @override
  String get auditActOrganizationSuspend => 'Organization suspended';

  @override
  String get auditActOrganizationReactivate => 'Organization reactivated';

  @override
  String get auditActUnknown => 'Admin action';

  @override
  String get auditSystem => 'System';

  @override
  String get auLoading => 'Loading organization activity…';

  @override
  String get auOrgLoadError =>
      'We could not load the organization. Check your connection and try again.';

  @override
  String get auNoOrgTitle => 'Select an organization';

  @override
  String get auNoOrgBody => 'Choose an organization to view its activity.';

  @override
  String get auDeniedTitle => 'Access denied';

  @override
  String get auDeniedBody =>
      'Only this organization’s Owner and Admins can view its audit history.';

  @override
  String get auCrumbOrg => 'Organization';

  @override
  String get auCrumbActivity => 'Activity';

  @override
  String get auTitle => 'Organization activity';

  @override
  String get auSubtitle =>
      'Review membership and invitation changes across your organization.';

  @override
  String get auLoadingHistory => 'Loading audit history…';

  @override
  String get auLoadError =>
      'We could not load organization activity. Check your connection and try again.';

  @override
  String get auSearchLong => 'Search by activity, account ID or record type';

  @override
  String get auSearchShort => 'Search activity...';

  @override
  String get auReset => 'Reset';

  @override
  String get auAllTypes => 'All record types';

  @override
  String get auFilterType => 'Filter by record type';

  @override
  String get auAllAccounts => 'All accounts';

  @override
  String auAccount(String a) {
    return 'Account $a';
  }

  @override
  String get auFilterAccount => 'Filter by account';

  @override
  String get auDateRange => 'Date range';

  @override
  String get auFilterDate => 'Filter by date range';

  @override
  String get auAllTime => 'All time';

  @override
  String get auToday => 'Today';

  @override
  String get auLast7 => 'Last 7 days';

  @override
  String get auLast30 => 'Last 30 days';

  @override
  String get auCustomRange => 'Custom date range...';

  @override
  String get auDateUnknown => 'Date unavailable';

  @override
  String get auAllRecords => 'All records';

  @override
  String get auMembers => 'Members';

  @override
  String get auInvitations => 'Invitations';

  @override
  String get auNewest => 'Newest first';

  @override
  String get auOldest => 'Oldest first';

  @override
  String get auColActivity => 'ACTIVITY';

  @override
  String get auColType => 'RECORD TYPE';

  @override
  String get auColAccount => 'ACCOUNT ID';

  @override
  String get auColTime => 'TIME';

  @override
  String get auNoMatch => 'No activity records match your criteria.';

  @override
  String get auRecordOne => '1 record';

  @override
  String auRecordMany(String a) {
    return '$a records';
  }

  @override
  String auShown(String a) {
    return '$a records shown · Repeated records retained';
  }

  @override
  String get auTimesNote => 'Dates and times as recorded';

  @override
  String get auUnavailable => 'Unavailable';

  @override
  String get auTimeUnknown => 'Time unavailable';

  @override
  String get auViewDetails => 'View details ';

  @override
  String auActorBullet(String a) {
    return '• $a';
  }

  @override
  String get auRecordedAt => 'Recorded at';

  @override
  String get auRecordType => 'Record type';

  @override
  String get auAccountId => 'Account ID';

  @override
  String get auNoActorDetail =>
      'Actor identity and change details are not provided in this record.';

  @override
  String get evGenericTitle => 'An error occurred';

  @override
  String get evGenericStatus => 'Error';

  @override
  String get evOrgTitle => 'No active organization';

  @override
  String get evOrgStatus => 'Organization required';

  @override
  String get evConnTitle => 'Connection lost';

  @override
  String get evConnStatus => 'Connection interrupted';

  @override
  String get evDeniedTitle => 'Access denied';

  @override
  String get evDeniedStatus => 'Permission required';

  @override
  String get evSessionTitle => 'Session expired';

  @override
  String get evSessionStatus => 'Sign-in required';

  @override
  String get evSaveTitle => 'Unable to save changes';

  @override
  String get evSaveStatus => 'Save unsuccessful';

  @override
  String get evServiceTitle => 'Service unavailable';

  @override
  String get evServiceStatus => 'Service interruption';

  @override
  String get evSelectOrg => 'Select organization';

  @override
  String get evRequestAccess => 'Request access';

  @override
  String get evSignIn => 'Sign in';

  @override
  String get evTryAgain => 'Try again';

  @override
  String get errRetry => 'Retry';

  @override
  String get osPending => 'pending';

  @override
  String get osVerified => 'verified';

  @override
  String get osActive => 'active';

  @override
  String get osSuspended => 'suspended';

  @override
  String get osRejected => 'rejected';

  @override
  String get osArchived => 'archived';

  @override
  String get porVerify => 'Verify';

  @override
  String get porReject => 'Reject';

  @override
  String get porSuspend => 'Suspend';

  @override
  String get porReactivate => 'Reactivate';

  @override
  String porReviewTitle(String a) {
    return '$a organization?';
  }

  @override
  String get porThisOrg => 'This organization';

  @override
  String porReviewBody(String a, String b) {
    return '$a will be marked as $b.';
  }

  @override
  String porMarked(String a) {
    return 'Organization marked as $a.';
  }

  @override
  String get porUpdateFailed => 'Could not update organization.';

  @override
  String get porLoadFailed => 'Could not load organizations.';

  @override
  String get porTitle => 'All organizations';

  @override
  String get porCheckingAccess => 'Checking platform access…';

  @override
  String get porDeniedTitle => 'Access denied';

  @override
  String get porVerifyAccessFailed =>
      'Could not verify platform administrator access.';

  @override
  String get porSuperAdminsOnly =>
      'This area is available only to Platform Super Admins.';

  @override
  String get porLoading => 'Loading organizations…';

  @override
  String get porEmptyTitle => 'No organizations yet';

  @override
  String get porEmptyBody =>
      'No organizations have been registered on the platform yet.';

  @override
  String get porSearch => 'Search by name, email or city';

  @override
  String get porClearSearch => 'Clear search';

  @override
  String get porShowing100 => 'Showing the 100 most recent organizations.';

  @override
  String porNoMatch(String a) {
    return 'No organization matches \"$a\" in this view.';
  }

  @override
  String porNothingIn(String a) {
    return 'Nothing in \"$a\".';
  }

  @override
  String porRegistered(String a) {
    return 'Registered $a';
  }

  @override
  String get porArchivedNote =>
      'Deleted by its owner. No moderation actions are available.';

  @override
  String get porRejectedNote => 'Rejected. No further actions are available.';

  @override
  String get porCancel => 'Cancel';

  @override
  String get pfNeedsReview => 'Needs review';

  @override
  String get pfVerified => 'Verified';

  @override
  String get pfSuspended => 'Suspended';

  @override
  String get pfClosed => 'Archived / rejected';

  @override
  String get pfAll => 'All';

  @override
  String get paLoadFailed => 'Could not load platform data.';

  @override
  String get paLoadMoreFailed => 'Could not load more users.';

  @override
  String get paGrantTitle => 'Grant platform admin access';

  @override
  String get paEmailLabel => 'Account email address';

  @override
  String get paEmailHint => 'name@example.com';

  @override
  String get paCancel => 'Cancel';

  @override
  String get paGrant => 'Grant access';

  @override
  String paGranted(String a) {
    return 'Platform admin access granted to $a.';
  }

  @override
  String get paGrantFailed => 'Could not grant admin access.';

  @override
  String get paThisAccount => 'this account';

  @override
  String get paRevokeTitle => 'Revoke platform admin access?';

  @override
  String paRevokeBody(String a) {
    return '$a will lose Platform Super Admin privileges.';
  }

  @override
  String get paRevoke => 'Revoke';

  @override
  String get paRevoked => 'Admin access revoked.';

  @override
  String get paRevokeFailed => 'Could not revoke admin access.';

  @override
  String get paTitle => 'Accounts & access';

  @override
  String get paChecking => 'Checking platform access…';

  @override
  String get paDenied => 'Access denied';

  @override
  String get paVerifyFailed =>
      'Could not verify platform administrator access.';

  @override
  String get paOnlySuper =>
      'This area is available only to Platform Super Admins.';

  @override
  String get paLoading => 'Loading platform data…';

  @override
  String get paAccounts => 'Accounts';

  @override
  String get paGrantButton => 'Grant admin access';

  @override
  String get paLoadMore => 'Load more';

  @override
  String get paStatUsers => 'Users';

  @override
  String get paStatOrgs => 'Organizations';

  @override
  String get paStatPending => 'Pending orgs';

  @override
  String get paStatActive => 'Active orgs';

  @override
  String get paStatSuspended => 'Suspended orgs';

  @override
  String get paStatMembers => 'Members';

  @override
  String get paStatActiveMembers => 'Active members';

  @override
  String get paStatEvents => 'Voting events';

  @override
  String get paStatActiveEvents => 'Active events';

  @override
  String get paNoEmail => '(no email)';

  @override
  String get paTagAdmin => 'Platform admin';

  @override
  String get paTagUnverified => 'Unverified';

  @override
  String get paTagDisabled => 'Disabled';

  @override
  String get plOverviewTitle => 'Platform overview';

  @override
  String get plOverviewSubtitle =>
      'Organizations, reviews and recent administrator activity across Kivora.';

  @override
  String get plRefresh => 'Refresh';

  @override
  String get plPendingOne => '1 organization is waiting for review.';

  @override
  String plPendingMany(String a) {
    return '$a organizations are waiting for review.';
  }

  @override
  String get plReviewOrgs => 'Review organizations';

  @override
  String get plReportsOne => '1 open user report.';

  @override
  String plReportsMany(String a) {
    return '$a open user reports.';
  }

  @override
  String get plOpenReports => 'Open reports';

  @override
  String get plTotalsFailed => 'Platform totals could not be loaded.';

  @override
  String get plStatOrgs => 'Organizations';

  @override
  String get plStatWaiting => 'Waiting for review';

  @override
  String get plStatActive => 'Active or verified';

  @override
  String get plStatSuspended => 'Suspended';

  @override
  String get plStatAccounts => 'Accounts';

  @override
  String get plStatMemberships => 'Active memberships';

  @override
  String get plStatElections => 'Elections and polls';

  @override
  String get plStatOpenNow => 'Voting open now';

  @override
  String get plNeedsAttention => 'Needs attention';

  @override
  String get plChecksIncomplete =>
      'Some checks could not run, so this list may be incomplete.';

  @override
  String get plNothingAttention => 'Nothing needs attention right now.';

  @override
  String get plRecentActivity => 'Recent administrator activity';

  @override
  String get plViewAll => 'View all';

  @override
  String get plUnavailable => 'Unavailable';

  @override
  String get plTryAgain => 'Try again';

  @override
  String get plActivityFailed => 'The activity log could not be loaded.';

  @override
  String get plNoActivity => 'No administrator actions have been recorded yet.';

  @override
  String get plTimeUnknown => 'Time unavailable';

  @override
  String plTarget(String a) {
    return 'Target: $a';
  }

  @override
  String plBy(String a) {
    return 'By $a';
  }

  @override
  String get plAuditTitle => 'Audit log';

  @override
  String get plAuditSubtitle =>
      'Actions taken by platform administrators, newest first.';

  @override
  String get plAuditLoading => 'Loading audit log…';

  @override
  String get plAuditFailed => 'The audit log could not be loaded.';

  @override
  String get plAuditEmptyTitle => 'No entries yet';

  @override
  String get plAuditEmptyBody =>
      'Platform administrator actions will appear here once they happen.';

  @override
  String get plAuditNote =>
      'Only actions that completed are recorded here; failed attempts leave no entry.';

  @override
  String get plAuditSearch => 'Search by action, person or organization';

  @override
  String get plClearSearch => 'Clear search';

  @override
  String get plAllActions => 'All actions';

  @override
  String get plEntryOne => '1 entry';

  @override
  String plEntryMany(String a) {
    return '$a entries';
  }

  @override
  String get plNoEntryMatch => 'No entry matches the current filters.';

  @override
  String get plLoadOlder => 'Load older entries';

  @override
  String get plReportsTitle => 'User reports';

  @override
  String get plReportsSubtitle =>
      'Feedback and issues submitted from Help & support.';

  @override
  String get plReportsLoading => 'Loading reports…';

  @override
  String get plReportsFailed => 'The reports could not be loaded.';

  @override
  String get plReportsEmptyTitle => 'No reports';

  @override
  String get plReportsEmptyBody => 'Nobody has submitted a report yet.';

  @override
  String get plReportsReadOnly =>
      'Read-only for now: the platform does not yet support assigning or resolving reports, so every report stays open. There is no flagged-organization feed either.';

  @override
  String plAllCount(String a) {
    return 'All ($a)';
  }

  @override
  String get plLoadOlderReports => 'Load older reports';

  @override
  String get plNoSubject => '(No subject)';

  @override
  String plReceiptRef(String a) {
    return 'Receipt reference: $a';
  }

  @override
  String get plShowLess => 'Show less';

  @override
  String get plShowFull => 'Show full message';

  @override
  String get plCatGeneral => 'General feedback';

  @override
  String get plCatElection => 'Election issue';

  @override
  String get plCatTechnical => 'Technical problem';

  @override
  String get plCatAccount => 'Account issue';

  @override
  String get plStatusOpen => 'open';

  @override
  String get plCheckingAccess => 'Checking platform access…';

  @override
  String get plDeniedTitle => 'Access denied';

  @override
  String get plVerifyFailed =>
      'Could not verify platform administrator access.';

  @override
  String get plOnlySuper =>
      'This area is available only to Platform Super Admins.';

  @override
  String get msActive => 'active';

  @override
  String get msInactive => 'inactive';

  @override
  String get msPending => 'pending';

  @override
  String get msSuspended => 'suspended';

  @override
  String get msRemoved => 'removed';

  @override
  String get coTypeAcademic => 'Academic Institution';

  @override
  String get coTypeCorporate => 'Corporate Enterprise';

  @override
  String get coTypeNonProfit => 'Non-Profit Organization';

  @override
  String get coTypeClub => 'Club / Student Society';

  @override
  String get coTypeCommunity => 'Community Association';

  @override
  String get coTypeOther => 'Other';

  @override
  String get coCreated => 'Organization created and verified!';

  @override
  String get coClose => 'Close';

  @override
  String get coTitle => 'Create an organization';

  @override
  String get coSubtitle =>
      'Give your community a shared space for people, departments and activity.';

  @override
  String get coNameLabel => 'ORGANIZATION NAME *';

  @override
  String get coNameHint => 'e.g. Your community or company';

  @override
  String get coNameField => 'Organization Name';

  @override
  String get coNameShort => 'Name must be at least 2 characters';

  @override
  String get coNameLong => 'Name cannot exceed 80 characters';

  @override
  String get coNameHelp =>
      'Use a name your members will recognize. 2–80 characters.';

  @override
  String get coTypeLabel => 'ORGANIZATION TYPE *';

  @override
  String get coTypeHint => 'Select a type';

  @override
  String get coCityLabel => 'CITY (OPTIONAL)';

  @override
  String get coCityHint => 'Enter city';

  @override
  String get coCountryLabel => 'COUNTRY (OPTIONAL)';

  @override
  String get coCountryHint => 'Select country';

  @override
  String get coVerifiedTitle => 'Verified instantly, you\'ll be the owner';

  @override
  String get coVerifiedBody =>
      'Since your account email is verified, your organization is created already verified - no manual review needed. Set up your workspace, branding and joining codes right after.';

  @override
  String get coRequired =>
      '* Complete the required fields to create your organization.';

  @override
  String get coCancel => 'Cancel';

  @override
  String get coCreate => 'Create organization';

  @override
  String joJoined(String a) {
    return 'Successfully joined $a!';
  }

  @override
  String get joClose => 'Close';

  @override
  String get joTitle => 'Join organization with code';

  @override
  String get joSubtitle =>
      'Enter the joining code shared by your organization\'s owner to find your workspace.';

  @override
  String get joCodeLabel => 'JOINING CODE';

  @override
  String get joCodeHint => 'Enter your joining code';

  @override
  String get joCodeField => 'Joining Code';

  @override
  String get joCodeHelp =>
      'Paste the complete code exactly as it was shared with you.';

  @override
  String get joScan => 'Scan QR code instead';

  @override
  String get joNoCode => 'Don\'t have a code?';

  @override
  String get joNoCodeBody =>
      'Ask your organization\'s owner for one. If a code is invalid or expired, request a new code.';

  @override
  String get joReviewNote =>
      'You\'ll review the organization before confirming that you want to join.';

  @override
  String get joCancel => 'Cancel';

  @override
  String get joFind => 'Find organization';

  @override
  String get joConfirmTitle => 'Is this your organization?';

  @override
  String get joConfirmBody =>
      'Confirm this is the workspace you want to join before continuing.';

  @override
  String get joVerified => 'Verified';

  @override
  String get joPending => 'Pending verification';

  @override
  String get joDifferent => 'Use a different code';

  @override
  String joJoin(String a) {
    return 'Join $a';
  }

  @override
  String get imCreatedTitle => 'Invitation Created';

  @override
  String imCreatedBody(String a) {
    return 'An invitation was created for $a.';
  }

  @override
  String get imCreatedNote =>
      'The invitee will see it in Kivora Notifications after logging in. They can accept or decline there.';

  @override
  String get imShareLink => 'Share this direct link with the invitee:';

  @override
  String get imDone => 'Done';

  @override
  String get imTitle => 'Invite Member';

  @override
  String get imClose => 'Close';

  @override
  String get imSubtitle => 'Invite someone to join your workspace.';

  @override
  String get imEmailLabel => 'Recipient Email Address *';

  @override
  String get imEmailHint => 'voter@organization.com';

  @override
  String imOrg(String a) {
    return 'Organization: $a';
  }

  @override
  String get imRole => 'Role Permission';

  @override
  String get imRoleMember => 'Member';

  @override
  String get imRoleAdmin => 'Admin';

  @override
  String get imCancel => 'Cancel';

  @override
  String get imSend => 'Send invitation';

  @override
  String get aeTitle => 'Add existing member';

  @override
  String get aeClose => 'Close';

  @override
  String get aeSubtitle =>
      'Add a verified Kivora account directly to this organization.';

  @override
  String get aeEmailLabel => 'Member Email Address *';

  @override
  String get aeEmailHint => 'user@example.com';

  @override
  String get aeEmailInvalid => 'Enter a valid email address.';

  @override
  String get aeCancel => 'Cancel';

  @override
  String get aeAdd => 'Add member';

  @override
  String get adAssigned => 'Member assigned successfully.';

  @override
  String adFailed(String a) {
    return 'Failed to assign member: $a';
  }

  @override
  String get adTitle => 'Add Member to Department';

  @override
  String get adClose => 'Close';

  @override
  String get adSearchLabel => 'Search Active Members';

  @override
  String get adSearchHint => 'Type a name or email...';

  @override
  String get adNone => 'No eligible active members found.';

  @override
  String get adUnknown => 'Unknown User';

  @override
  String adCurrentlyIn(String a, String b) {
    return '$a • currently in $b';
  }

  @override
  String adAddTo(String a) {
    return 'Add $a to this department';
  }

  @override
  String get mpCancel => 'Cancel';

  @override
  String get mpUser => 'User';

  @override
  String get mpNone => 'None';

  @override
  String get mpRole => 'Role';

  @override
  String get mpStatus => 'Status';

  @override
  String get mpDepartment => 'Department';

  @override
  String get mpObserver => 'Observer Access';

  @override
  String get mpGranted => 'Granted';

  @override
  String get mpPromote => 'Promote to Admin';

  @override
  String get mpPromoted => 'Promoted to Admin successfully.';

  @override
  String get mpDemote => 'Demote to Member';

  @override
  String get mpDemoted => 'Demoted to Member successfully.';

  @override
  String get mpGrantObserver => 'Grant Observer Access';

  @override
  String get mpGrantedDone => 'Granted observer access.';

  @override
  String get mpRevokeObserver => 'Revoke Observer Access';

  @override
  String get mpRevokedDone => 'Revoked observer access.';

  @override
  String get mpDeactivate => 'Deactivate Member';

  @override
  String get mpDeactivated => 'Deactivated member successfully.';

  @override
  String get mpReactivate => 'Reactivate Member';

  @override
  String get mpReactivated => 'Reactivated member successfully.';

  @override
  String get mpRemove => 'Remove Member';

  @override
  String mpRemoveTitle(String a) {
    return 'Remove $a?';
  }

  @override
  String get mpRemoveBody =>
      'They will lose access to this organization immediately.';

  @override
  String get mpRemoved => 'Member removed from organization.';

  @override
  String get mpClose => 'Close';

  @override
  String get imOrgLabel => 'Organization';

  @override
  String get vtCandidate => 'Candidate election';

  @override
  String get vtSingleChoice => 'Single-choice poll';

  @override
  String get vtYesNo => 'Yes/No poll';

  @override
  String get etAll => 'All active members';

  @override
  String get etMembers => 'Selected members';

  @override
  String get etDepartments => 'Selected departments';

  @override
  String get ccLoadError =>
      'We could not load the command center. Check your connection and try again.';

  @override
  String get ccNoOrgTitle => 'No active organization';

  @override
  String get ccNoOrgBody =>
      'Select an organization to view its command center.';

  @override
  String get ccAdminTitle => 'Administrator access required';

  @override
  String get ccAdminBody =>
      'The election command center is available to organization owners and admins.';

  @override
  String get ccElectionsError =>
      'We could not load elections. Check your connection and try again.';

  @override
  String get ccTitle => 'Election Command Center';

  @override
  String get ccSearch => 'Search';

  @override
  String get ccFilterDate => 'Filter by date range';

  @override
  String get ccCreate => 'Create election';

  @override
  String get ccSuspended =>
      'This organization is suspended. Election management is disabled until it is reinstated.';

  @override
  String get ccActiveTitle => 'Active Election Monitoring';

  @override
  String get ccActiveNone => 'No elections are currently active.';

  @override
  String get ccUpcomingTitle => 'Upcoming Election Schedule';

  @override
  String get ccUpcomingNone => 'No elections are scheduled.';

  @override
  String get ccAlerts => 'Alerts';

  @override
  String ccNoVoters(String a) {
    return '\"$a\" has no eligible voters configured.';
  }

  @override
  String get ccTasks => 'Pending Administrative Tasks';

  @override
  String get ccTasksNone => 'No pending tasks. You\'re all caught up.';

  @override
  String ccDraft(String a) {
    return '\"$a\" is still a draft and needs review before publishing.';
  }

  @override
  String get ccInviteOne => '1 invitation is awaiting a response.';

  @override
  String ccInviteMany(String a) {
    return '$a invitations are awaiting a response.';
  }

  @override
  String get ccMembership => 'Membership & Invitations';

  @override
  String get ccTotalMembers => 'Total members';

  @override
  String get ccPendingInvites => 'Pending invitations';

  @override
  String get ccRecent => 'Recent Administrative Activity';

  @override
  String get ccExport => 'Export report (CSV)';

  @override
  String get ccStatTotal => 'Total Elections';

  @override
  String get ccStatActive => 'Active';

  @override
  String get ccStatScheduled => 'Scheduled';

  @override
  String get ccStatClosed => 'Closed';

  @override
  String get ccStatMembers => 'Members';

  @override
  String get ccStatMembersSub => 'All organization members';

  @override
  String get ccNoActivity => 'No recent activity.';

  @override
  String get ccMonitor => 'Monitor';

  @override
  String get ccTurnoutUnknown => 'Live turnout unavailable';

  @override
  String ccTurnout(String a, String b, String c) {
    return '$a of $b voted ($c%)';
  }

  @override
  String get biTemplateTitle => 'Select Election Template';

  @override
  String get biTemplateBody =>
      'Choose a pre-configured template to speed up your election creation.';

  @override
  String get biT1Name => 'Executive / Board Election';

  @override
  String get biT1Sub => 'Candidate Election • Anonymous Ballot';

  @override
  String get biT1Title => 'Executive Board Election';

  @override
  String get biT1Desc =>
      'Annual election to select executive board representatives. Ballots are strictly anonymous.';

  @override
  String get biT2Name => 'Policy / Resolution Vote';

  @override
  String get biT2Sub => 'Yes/No Poll • Anonymous Ballot';

  @override
  String get biT2Title => 'Organization Policy Resolution';

  @override
  String get biT2Desc =>
      'Vote on the proposed amendment to organization bylaws. Please review the attached documentation before voting.';

  @override
  String get biT3Name => 'Community Opinion Poll';

  @override
  String get biT3Sub => 'Single-Choice Poll • Identifiable';

  @override
  String get biT3Title => 'Community Feedback Survey';

  @override
  String get biT3Desc =>
      'Short survey to collect community sentiment on upcoming initiatives.';

  @override
  String get biLocked =>
      'Event is no longer a DRAFT. Basic info is strictly immutable.';

  @override
  String get biTitle => 'Election details';

  @override
  String get biSubtitle => 'Provide the basic information about your election.';

  @override
  String get biUseTemplate => 'Use template';

  @override
  String get biTitleLabel => 'Event Title *';

  @override
  String get biTitleHint => 'e.g. Annual Team Selection';

  @override
  String get biTitleInvalid => 'Title must be 3-100 characters.';

  @override
  String get biDescLabel => 'Description *';

  @override
  String get biDescHint =>
      'Describe the purpose, context and important details about this event...';

  @override
  String get biDescRequired => 'Description is required.';

  @override
  String get biDescLong => 'Description cannot exceed 500 characters.';

  @override
  String get biVotingType => 'Voting Type';

  @override
  String get biTypeCandidate => 'Candidate Election';

  @override
  String get biTypeCandidateSub => 'Voters select one candidate from a roster.';

  @override
  String get biTypeSingle => 'Single-Choice Poll';

  @override
  String get biTypeSingleSub => 'Voters select one option from a list.';

  @override
  String get biTypeYesNo => 'Yes/No Poll';

  @override
  String get biTypeYesNoSub => 'Voters approve or reject a proposal.';

  @override
  String get biPrivacy => 'Ballot privacy';

  @override
  String get biAnonymous => 'Anonymous';

  @override
  String get biIdentifiable => 'Identifiable';

  @override
  String get biAnonymousNote =>
      'Voter identity is stored separately from the ballot.';

  @override
  String get biIdentifiableNote =>
      'Each ballot is associated with the voter’s account. Voters will see this notice before confirming.';

  @override
  String get biNext => 'Next: Schedule';

  @override
  String get elLocked =>
      'Event is no longer a DRAFT. Eligibility configuration is strictly immutable.';

  @override
  String get elTitle => 'Voter Eligibility';

  @override
  String get elWho => 'Who can vote?';

  @override
  String get elAll => 'All Active Members';

  @override
  String get elDepts => 'Selected Departments';

  @override
  String get elMembers => 'Selected Members';

  @override
  String get elBack => 'Back';

  @override
  String get elCreateDraft => 'Create Draft & Continue';

  @override
  String get elNext => 'Next: Choices';

  @override
  String get elListError =>
      'We could not load this list. Go back and try again.';

  @override
  String get elNoDepts => 'No departments found in this organization.';

  @override
  String get elNoMembers => 'No active members found.';

  @override
  String elSelected(String a, String b) {
    return '$a selected of $b active members';
  }

  @override
  String get elCsv => 'CSV Bulk Import';

  @override
  String get rvPublishTitle => 'Publish this election?';

  @override
  String get rvPublishBody =>
      'Eligible members will see it according to the schedule. After publishing you can no longer change its details, schedule or eligibility.';

  @override
  String get rvKeepEditing => 'Keep editing';

  @override
  String get rvPublish => 'Publish';

  @override
  String get rvPublished => 'Election published.';

  @override
  String get rvReauth =>
      'For security, publishing an election requires you to have signed in within the last 15 minutes. Please verify your identity to continue.';

  @override
  String get rvPublishFailed =>
      'We could not publish the election. Please try again.';

  @override
  String get rvChoicesError =>
      'We could not load the choices. Go back and try again.';

  @override
  String get rvCheckTitle => 'Title configured';

  @override
  String get rvCheckDesc => 'Description added';

  @override
  String get rvCheckSchedule => 'Voting window scheduled';

  @override
  String get rvCheckPrivacyId => 'Privacy mode set (Identifiable)';

  @override
  String get rvCheckPrivacyAnon => 'Privacy mode set (Anonymous)';

  @override
  String rvCheckChoices(String a) {
    return 'Candidates/options configured ($a)';
  }

  @override
  String rvCheckEligibility(String a) {
    return 'Eligibility rules valid ($a)';
  }

  @override
  String get rvTitle => 'Review & Publish';

  @override
  String get rvChecklist => 'ELECTION SETUP CHECKLIST';

  @override
  String get rvTitleLabel => 'Title';

  @override
  String get rvStart => 'Start At';

  @override
  String get rvEnd => 'End At';

  @override
  String get rvChoices => 'Choices';

  @override
  String rvItems(String a) {
    return '$a items configured';
  }

  @override
  String get rvIncomplete =>
      'Complete every required checklist item above before publishing.';

  @override
  String get rvBack => 'Back';

  @override
  String get rvPublishButton => 'Publish election';

  @override
  String get rvOptional => ' (optional)';

  @override
  String get scRequired => 'Start and End times are required.';

  @override
  String get scPast => 'Start time cannot be in the past.';

  @override
  String get scShort => 'Voting window must be at least 5 minutes.';

  @override
  String get scLocked =>
      'Event is no longer a DRAFT. Schedule is strictly immutable.';

  @override
  String get scTitle => 'Voting Schedule';

  @override
  String scZoneNote(String a) {
    return 'Times are entered in your time zone: $a. All times are evaluated securely against the server clock.';
  }

  @override
  String get scStartTime => 'Start Time';

  @override
  String get scNotSet => 'Not set';

  @override
  String get scEndTime => 'End Time';

  @override
  String get scBack => 'Back';

  @override
  String get scNext => 'Next: Eligibility';

  @override
  String get obTitle => 'Observer Dashboard';

  @override
  String get obTransparency => 'Trust & Transparency Center';

  @override
  String get obLoadError =>
      'We could not load this view. Check your connection and try again.';

  @override
  String get obNoOrgTitle => 'No active organization';

  @override
  String get obNoOrgBody =>
      'Select an organization to view its observer dashboard.';

  @override
  String get obAccessTitle => 'Observer access required';

  @override
  String get obAccessBody =>
      'This dashboard is only available to members granted observer access by an organization admin.';

  @override
  String get obNoElectionsTitle => 'No elections yet';

  @override
  String get obNoElectionsBody =>
      'There are no published elections in this organization yet.';

  @override
  String obNote(String a) {
    return 'You have read-only Observer access to $a. You see organization-wide aggregates only, never individual ballots, voter identities, or per-department breakdowns.';
  }

  @override
  String get obActive => 'Active Elections';

  @override
  String get obTimeline => 'Election Timeline';

  @override
  String get obTurnoutUnknown => 'Aggregate turnout unavailable';

  @override
  String obTurnout(String a, String b, String c) {
    return '$a of $b eligible voters ($c%)';
  }

  @override
  String vpWelcomeNamed(String a) {
    return 'Welcome back, $a';
  }

  @override
  String get vpWelcome => 'Welcome back';

  @override
  String get vpReadyOne => '1 election is open for your vote.';

  @override
  String vpReadyMany(String a) {
    return '$a elections are open for your vote.';
  }

  @override
  String get vpAllCaughtUp =>
      'You are all caught up. Nothing is waiting for your vote.';

  @override
  String get vpYourWorkspace => 'Your voting workspace';

  @override
  String get vpOpenFirst => 'Go to my ballot';

  @override
  String get gsHome => 'Home';

  @override
  String get gsHomeSub => 'Dashboard';

  @override
  String get gsOrgs => 'Organizations';

  @override
  String get gsOrgsSub => 'Your workspaces';

  @override
  String get gsEvents => 'Events';

  @override
  String get gsEventsSub => 'Manage voting events';

  @override
  String get gsMembers => 'Members directory';

  @override
  String get gsMembersSub => 'Browse org members';

  @override
  String get gsDepts => 'Departments';

  @override
  String get gsDeptsSub => 'Manage departments';

  @override
  String get gsAccount => 'Account settings';

  @override
  String get gsAccountSub => 'Profile & security';

  @override
  String get gsAudit => 'Audit log';

  @override
  String get gsAuditSub => 'Organization activity';

  @override
  String get gsInvites => 'Invitations';

  @override
  String get gsInvitesSub => 'Pending org invitations';

  @override
  String get gsOrganization => 'Organization';

  @override
  String gsVotingEvent(String a) {
    return 'Voting event · $a';
  }

  @override
  String get gsSearchLabel => 'Search';

  @override
  String get gsSearchHint => 'Search events, members, organizations…';

  @override
  String get gsEsc => 'ESC';

  @override
  String gsNoResults(String a) {
    return 'No results for \"$a\"';
  }

  @override
  String get authTagline => 'Secure voting for organizations';

  @override
  String aiWelcome(String a) {
    return 'Welcome to $a!';
  }

  @override
  String get aiTheOrg => 'the organization';

  @override
  String get alBadge => 'PRIVACY-AWARE VOTING';

  @override
  String get alHeadline => 'Your Voice,\nYour Choice.';

  @override
  String get alSub =>
      'Secure, transparent and modern\ne-voting for organizations.';

  @override
  String get alP1 => 'Server-authorized voting';

  @override
  String get alP1b =>
      'Ballots are validated and recorded by trusted backend services.';

  @override
  String get alP2 => 'Privacy-aware ballots';

  @override
  String get alP2b =>
      'Anonymous ballots are separated from participation records.';

  @override
  String get alP3 => 'Clear participation receipts';

  @override
  String get alP3b => 'Confirm participation without revealing your selection.';

  @override
  String get alCopy => 'Kivora © 2026';

  @override
  String get alPlatforms => 'Android • Web';

  @override
  String get osTitle => 'Switch organization';

  @override
  String get osBody => 'Choose the workspace you want to work in.';

  @override
  String get osLoadError => 'Could not load your organizations.';

  @override
  String get osRetry => 'Try again';

  @override
  String get osNone => 'No joined organizations found.';

  @override
  String get osJoin => 'Join organization with code';

  @override
  String get osCreate => 'Create new organization';

  @override
  String get osInvites => 'View invitations';

  @override
  String get osRetry2 => 'Retry';

  @override
  String get osSelect => 'Select Organization';

  @override
  String get osCurrentLabel => 'CURRENT ORGANIZATION';

  @override
  String get osCurrent => 'Current organization';

  @override
  String get osSwitchTo => 'Switch to this organization';

  @override
  String get aiMissing => 'This invitation link is missing or malformed.';

  @override
  String get aiInvited => 'You\'ve been invited';

  @override
  String get aiInvitedBody =>
      'Accept to join this organization with the email address you\'re signed in with.';

  @override
  String get aiNotNow => 'Not now';

  @override
  String get aiAccept => 'Accept invitation';

  @override
  String get aiAccepting => 'Accepting invitation…';

  @override
  String get aiJoinedBody =>
      'You\'ve successfully joined. You can start exploring right away.';

  @override
  String get aiContinue => 'Continue';

  @override
  String get aiFailedTitle => 'Couldn\'t accept this invitation';

  @override
  String get aiFailedBody => 'Something went wrong. Please try again.';

  @override
  String get aiHome => 'Go to home';

  @override
  String get shCalendar => 'Election Calendar';

  @override
  String get shLight => 'Switch to light mode';

  @override
  String get shDark => 'Switch to dark mode';

  @override
  String get shSearch => 'Search';

  @override
  String get shNotifications => 'Notifications';

  @override
  String get shMarkRead => 'Mark all read';

  @override
  String get shNoNotifications => 'No new notifications';

  @override
  String get shOrganization => 'Organization';

  @override
  String shInvitedTo(String a) {
    return 'Invited to join $a';
  }

  @override
  String shRoleAction(String a) {
    return 'Role: $a • Action required';
  }

  @override
  String get shViewAll => 'View all notifications';

  @override
  String get shAccountMenu => 'Account menu';

  @override
  String shAccountRole(String a) {
    return 'Account $a';
  }

  @override
  String get shAccountUser => 'Account user';

  @override
  String get shAccountSettings => 'Account settings';

  @override
  String get shHelp => 'Help & support';

  @override
  String get shBilling => 'Plans & Billing';

  @override
  String get shTrust => 'Trust & Transparency';

  @override
  String get shPlatformAdmin => 'Platform admin';

  @override
  String get shOrganizations => 'Organizations';

  @override
  String get shLogout => 'Log out';

  @override
  String get hsThanks =>
      'Thank you for your feedback! We have received your message.';

  @override
  String get hsFailed =>
      'Failed to send feedback. Please check your connection and try again.';

  @override
  String get hsTitle => 'Help & Support';

  @override
  String get hsFaq => 'Frequently Asked Questions';

  @override
  String get hsQ1 => 'How do I cast my vote?';

  @override
  String get hsA1 =>
      'You can cast your vote by selecting an active election from your organization dashboard and following the on-screen instructions.';

  @override
  String get hsQ2 => 'Are my votes anonymous?';

  @override
  String get hsA2 =>
      'In an anonymous election, your ballot choice is never linked to your account - the system can confirm you voted without recording what you chose. Identifiable elections are clearly labeled before you vote. See the Trust & Transparency Center for full detail on what your receipt does and doesn\'t prove.';

  @override
  String get hsQ3 => 'How can I change my profile information?';

  @override
  String get hsA3 =>
      'Navigate to the Account Settings page from the top-right profile dropdown menu to update your personal details.';

  @override
  String get hsGuidance => 'Help & Guidance';

  @override
  String get hsVerify => 'Verify a receipt';

  @override
  String get hsVerifyBody =>
      'Check that a ballot receipt was recorded. This never shows how anyone voted.';

  @override
  String get hsTrust => 'Trust & transparency';

  @override
  String get hsTrustBody =>
      'How Kivora protects ballot privacy and what is recorded.';

  @override
  String get hsSend => 'Send Feedback or Contact Support';

  @override
  String get hsCategory => 'CATEGORY';

  @override
  String get hsSubject => 'SUBJECT';

  @override
  String get hsSubjectHint => 'What is this regarding?';

  @override
  String get hsSubjectField => 'Subject';

  @override
  String get hsReceipt => 'RECEIPT ID (OPTIONAL)';

  @override
  String get hsReceiptHint =>
      'Paste a receipt ID if this relates to a specific vote';

  @override
  String get hsReceiptNote =>
      'Never include your ballot choice here - a receipt confirms your vote was recorded, it does not reveal what you selected.';

  @override
  String get hsMessage => 'MESSAGE';

  @override
  String get hsMessageHint =>
      'Please describe your issue or share your feedback...';

  @override
  String get hsMessageField => 'Message';

  @override
  String get hsSending => 'Sending...';

  @override
  String get hsSendButton => 'Send Message';

  @override
  String get rvfTitle => 'Public Receipt Verification';

  @override
  String get rvfHeading => 'Verify ballot receipt';

  @override
  String get rvfIntro =>
      'Enter the receipt hash from your receipt to confirm the server recorded it. This checks that a matching receipt exists. It does not show how anyone voted, and it does not independently prove inclusion in the final tally.';

  @override
  String get rvfHashLabel => 'Receipt hash';

  @override
  String get rvfHashHint => '64-character hash (letters a-f and digits)';

  @override
  String get rvfVerify => 'Verify receipt';

  @override
  String get rvfOkTitle => 'Receipt verified';

  @override
  String get rvfOkBody =>
      'A matching receipt was found, so the server recorded this ballot. This does not independently prove inclusion in the final tally.';

  @override
  String get rvfNoTitle => 'No matching receipt';

  @override
  String get rvfNoBody =>
      'The service is working and has no receipt with this hash. Check that you copied the whole hash from your receipt.';

  @override
  String get rvfBadTitle => 'That is not a valid receipt hash';

  @override
  String get rvfBadBody =>
      'A receipt hash is exactly 64 characters: digits 0-9 and letters a-f. Nothing was sent to the server.';

  @override
  String get rvfRateTitle => 'Too many lookups';

  @override
  String get rvfRateBody => 'Please wait a minute before trying again.';

  @override
  String get rvfDownTitle => 'Verification is unavailable right now';

  @override
  String get rvfDownBody =>
      'We could not reach the verification service, so we cannot say whether your receipt exists. This is not a \"not found\" result. Check your connection and try again.';

  @override
  String get rvfRetry => 'Try again';

  @override
  String get rgDoneTitle => 'Registration Successful';

  @override
  String get rgDoneBody =>
      'Your Kivora identity has been securely generated. You may now sign in using your credentials.';

  @override
  String get rgReturn => 'Return to Login';

  @override
  String get rgFirstLabel => 'First name';

  @override
  String get rgFirstHint => 'First';

  @override
  String get rgFirstField => 'First Name';

  @override
  String get rgLastLabel => 'Last name';

  @override
  String get rgLastHint => 'Last';

  @override
  String get rgLastField => 'Last Name';

  @override
  String get rgEmailLabel => 'Email address';

  @override
  String get rgEmailHint => 'user@email.com';

  @override
  String get rgPassword => 'Password';

  @override
  String get rgConfirm => 'Confirm Password';

  @override
  String get evYourEmail => 'your email address';

  @override
  String get evOk => 'Email verified successfully!';

  @override
  String get evNot =>
      'Email is not verified yet. Please check your inbox and click the verification link.';

  @override
  String evCheckFailed(String a) {
    return 'Could not check verification status: $a';
  }

  @override
  String get evResent =>
      'A new verification email has been sent. Please check your inbox.';

  @override
  String evResendFailed(String a) {
    return 'Failed to resend email: $a';
  }

  @override
  String get evTitle => 'Verify Email';

  @override
  String get evSignOut => 'Sign Out';

  @override
  String get evHeading => 'Verify Your Email Address';

  @override
  String evSent(String a) {
    return 'We have sent a verification link to:\n$a';
  }

  @override
  String get evClick =>
      'Please click the link in your email to unlock complete platform access.';

  @override
  String evCooldown(String a) {
    return 'Resend Email in ${a}s';
  }

  @override
  String get evResend => 'Resend Verification Email';

  @override
  String get evSwitch => 'Sign Out / Use Different Account';

  @override
  String get fpTitle => 'Forgot Password?';

  @override
  String get fpBody =>
      'Enter the email address associated with your account to receive instructions to reset your password.';

  @override
  String get fpSent =>
      'If an account exists for this email address, a password reset link has been sent. Please check your inbox.';

  @override
  String get fpEmail => 'EMAIL ADDRESS';

  @override
  String get fpEmailHint => 'user@email.com';

  @override
  String fpCooldown(String a) {
    return 'Resend Link in ${a}s';
  }

  @override
  String get fpSend => 'Send Reset Link';

  @override
  String get plOpenFailed => 'Could not open the payment page.';

  @override
  String get plReauth =>
      'For security, please sign out and sign back in, then try again.';

  @override
  String get plGeneric => 'Something went wrong. Please try again.';

  @override
  String get plBack => 'Back';

  @override
  String get plTitle => 'Plans & Billing';

  @override
  String get plNoOrg => 'Select an organization to see its plan.';

  @override
  String plIntro(String a) {
    return 'Plans apply to $a. Voters never pay and are never blocked from voting. Ads never appear on ballot, receipt, verification or admin screens.';
  }

  @override
  String get plOwnerOnly => 'Only the organization owner can change the plan.';

  @override
  String get plSoon => 'Online upgrade coming soon';

  @override
  String get plOpening => 'Opening…';

  @override
  String get plUpgrade => 'Upgrade to Pro';

  @override
  String get plManage => 'Manage or cancel subscription';

  @override
  String get plContact => 'Contact sales';

  @override
  String get plCurrent => 'CURRENT';

  @override
  String get spLogo => 'Kivora Logo';

  @override
  String get spTag => 'Enterprise Multi-Tenant E-Voting';

  @override
  String get spBadge => 'Server-Authorized & Tenant-Isolated';

  @override
  String get spInit => 'Initializing secure session...';

  @override
  String get spErrTitle => 'Connection Error';

  @override
  String get spErrBody => 'Failed to connect to Kivora services.';

  @override
  String get spRetry => 'Retry Connection';

  @override
  String get sclProfile => 'Complete organization profile';

  @override
  String get sclMembers => 'Add members';

  @override
  String get sclDepts => 'Set up departments';

  @override
  String get sclFirst => 'Create your first voting event';

  @override
  String get sclTitle => 'Get your organization ready';

  @override
  String get sclDismiss => 'Dismiss';

  @override
  String sclProgress(String a, String b) {
    return '$a of $b completed';
  }

  @override
  String get trS1Title => 'Election Lifecycle';

  @override
  String get trS1P1 =>
      'Every election moves through a fixed sequence of states, enforced by the server, not the app: Draft → Scheduled → Active → Closed → Archived.';

  @override
  String get trS1P2 =>
      'An election cannot accept ballots outside the Active state, and the server - not your device\'s clock - decides when that window opens and closes.';

  @override
  String get trS1P3 =>
      'Draft elections are never visible to anyone except the organization\'s own owners and admins.';

  @override
  String get trS2Title => 'Voter Eligibility';

  @override
  String get trS2P1 =>
      'Each election is configured with one eligibility rule: every active member of the organization, a specific list of departments, or a specific list of members.';

  @override
  String get trS2P2 =>
      'Eligibility is re-checked by the server at the moment you submit a ballot. What the app shows you beforehand (such as a \"Vote Now\" button) is a convenience - it is never the actual authorization check.';

  @override
  String get trS3Title => 'How a Vote Is Processed';

  @override
  String get trS3P1 =>
      'Casting a ballot runs as a single atomic server-side transaction: it verifies your session hasn\'t been revoked, confirms you\'re eligible and haven\'t already voted, and records your choice - all or nothing.';

  @override
  String get trS3P2 =>
      'A duplicate submission (for example, from a retried request after a network error) is rejected by the server rather than counted twice, because each voter\'s participation record for a given election has a fixed, predictable ID that can only be created once.';

  @override
  String get trS4Title => 'Anonymous vs. Identifiable Voting';

  @override
  String get trS4P1 =>
      'Anonymous elections: your ballot choice is stored without any field linking it back to your account. The system can confirm you participated (to prevent double-voting) without recording what you chose.';

  @override
  String get trS4P2 =>
      'Identifiable elections: your choice is recorded against your account. This mode exists for governance contexts that require attributable votes (for example, certain formal resolutions) and is clearly labeled before you vote.';

  @override
  String get trS4P3 =>
      'An election\'s privacy mode is fixed when it\'s created and shown to you before you ever select a choice.';

  @override
  String get trS5Title => 'Vote Receipts';

  @override
  String get trS5P1 =>
      'After voting, you receive a receipt: a receipt ID and a cryptographic hash generated from your ballot record at the moment it was recorded.';

  @override
  String get trS5P2 =>
      'The receipt confirms your ballot was accepted and exists in the system\'s records. It is not a copy of your ballot choice, and in an anonymous election it cannot be used by anyone - including Kivora administrators - to determine what you selected.';

  @override
  String get trS6Title => 'What Receipt Verification Does and Does Not Prove';

  @override
  String get trS6P1 =>
      'Verifying a receipt confirms that a ballot matching that receipt exists in the ledger. That is the full extent of what it proves.';

  @override
  String get trS6P2 =>
      'It does NOT prove who cast that ballot, what choice was selected, that no other issue occurred elsewhere in the process, or provide independent cryptographic audit of the full tally beyond what is described here. Treat it as a record-existence check, not a formal proof of election integrity.';

  @override
  String get trS7Title => 'When Results Become Available';

  @override
  String get trS7P1 =>
      'Results are calculated after an election closes, and are only visible to ordinary members once an organization admin explicitly publishes them.';

  @override
  String get trS7P2 =>
      'Organization owners and admins may review computed results before publishing, in order to catch configuration problems - this is a normal part of the workflow, not evidence of hidden tallies.';

  @override
  String get trS8Title => 'Administrative Accountability';

  @override
  String get trS8P1 =>
      'Sensitive administrative actions - publishing or closing an election, changing a member\'s role, granting Observer access, and similar actions - are written to an organization-scoped audit log, visible to that organization\'s owners and admins.';

  @override
  String get trS8P2 =>
      'This is an operational log for the organization\'s own oversight, not a public, tamper-proof ledger - see \"Known Limitations\" below.';

  @override
  String get trS9Title => 'Privacy & Data Handling';

  @override
  String get trS9P1 =>
      'Each organization\'s data is isolated from every other organization at the server level; membership in one organization never grants visibility into another\'s elections, members, or results.';

  @override
  String get trS9P2 =>
      'Observers (a limited, admin-granted capability) see only organization-wide aggregate turnout numbers for active elections and published results - never individual ballots, voter identities, or small-group breakdowns that could reveal how a specific person or small group voted.';

  @override
  String get trS9P3 =>
      'On the Free plan, mobile app users may see banner ads on browsing screens (home, organizations, calendar, published results). Ads are served by a third-party ad network that may collect device identifiers according to your consent choices. Ads never appear on the ballot, receipt, receipt-verification, transparency or admin screens, and ad networks never receive your vote, your choice, or your receipt.';

  @override
  String get trS10Title => 'Known Limitations';

  @override
  String get trS10P1 =>
      'Audit logs are ordinary database records, not a cryptographically tamper-evident ledger - they describe operational history, not mathematical proof against retroactive modification.';

  @override
  String get trS10P2 =>
      'Kivora is not independently certified by any national or third-party election-standards body, and receipt verification is not a substitute for an independent cryptographic audit of the full tally.';

  @override
  String get trS10P3 =>
      'Some interface languages are provided via machine-assisted translation pending native-speaker review - see Settings → Preferences → Language.';

  @override
  String get trTitle => 'Trust & Transparency Center';

  @override
  String get trHeading => 'How Kivora elections work';

  @override
  String get trIntro =>
      'A plain-language explanation of what actually happens behind every election, written to match the real implementation - including its honest limitations.';

  @override
  String get trVerify => 'Verify a receipt';
}
