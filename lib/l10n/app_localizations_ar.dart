// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'كيفورا';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navOrganizations => 'المؤسسات';

  @override
  String get navOrgsShort => 'المؤسسات';

  @override
  String get navEvents => 'الانتخابات';

  @override
  String get navDirectory => 'الدليل';

  @override
  String get navDepartments => 'الأقسام';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get navCalendar => 'التقويم';

  @override
  String get navCommandCenter => 'مركز القيادة';

  @override
  String get actionSave => 'حفظ';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionDelete => 'حذف';

  @override
  String get actionConfirm => 'تأكيد';

  @override
  String get actionBack => 'رجوع';

  @override
  String get actionNext => 'التالي';

  @override
  String get actionClose => 'إغلاق';

  @override
  String get actionRetry => 'إعادة المحاولة';

  @override
  String get actionSignOut => 'تسجيل الخروج';

  @override
  String get authSignInTitle => 'مرحبًا بعودتك';

  @override
  String get authSignInSubtitle => 'سجّل الدخول للمتابعة';

  @override
  String get authEmail => 'البريد الإلكتروني';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authForgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get authSignInButton => 'تسجيل الدخول بأمان';

  @override
  String get authContinueWithGoogle => 'المتابعة باستخدام جوجل';

  @override
  String get authCreateAccount => 'إنشاء حساب';

  @override
  String get authNoAccount => 'ليس لديك حساب؟';

  @override
  String get authRegisterTitle => 'إنشاء حساب';

  @override
  String get authRegisterSubtitle => 'انضم إلى كيفورا اليوم';

  @override
  String get authFullName => 'الاسم الكامل';

  @override
  String get authConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get voteStepSelect => 'اختيار';

  @override
  String get voteStepReview => 'مراجعة وإرسال';

  @override
  String get voteSelectionPrompt => 'قم باختيارك';

  @override
  String get voteReviewBallot => 'مراجعة ورقة الاقتراع';

  @override
  String get voteReviewYourBallot => 'راجع ورقة اقتراعك';

  @override
  String get voteYourSelection => 'اختيارك';

  @override
  String get voteConfirmAndCast => 'تأكيد وإرسال الصوت';

  @override
  String get voteSubmitting => 'جارٍ إرسال ورقة الاقتراع...';

  @override
  String get voteAnonymousExplanation =>
      'ورقة الاقتراع هذه مجهولة الهوية. لن يتم ربط اختيارك بهويتك أبدًا في الفرز، ولا يمكن تغييره بعد الإرسال.';

  @override
  String get voteIdentifiableExplanation =>
      'هذه ورقة اقتراع قابلة للتعريف. سيتم تسجيل اختيارك مرتبطًا بحسابك ولا يمكن تغييره بعد الإرسال.';

  @override
  String get voteAlreadyVotedTitle => 'لقد قمت بالتصويت بالفعل';

  @override
  String voteAlreadyVotedMessage(String eventTitle) {
    return 'تم بالفعل إرسال ورقة اقتراعك لـ \"$eventTitle\" وقبولها في الفرز المجهول.';
  }

  @override
  String get voteViewReceipt => 'عرض إيصال التأكيد الخاص بك';

  @override
  String get voteViewResults => 'عرض النتائج';

  @override
  String get voteNotOpenYet =>
      'لم يفتح التصويت بعد لهذا الانتخاب. يمكنك مراجعة ورقة الاقتراع أدناه، لكن الإرسال معطل حتى يصبح نشطًا.';

  @override
  String get voteClosed => 'التصويت لم يعد مفتوحًا لهذا الانتخاب.';

  @override
  String get receiptTitle => 'إيصال التصويت';

  @override
  String get receiptId => 'رقم الإيصال';

  @override
  String get receiptHash => 'تجزئة الإيصال';

  @override
  String get receiptCopy => 'نسخ';

  @override
  String get receiptReturnHome => 'العودة إلى الصفحة الرئيسية';

  @override
  String get resultsTitle => 'نتائج الانتخابات';

  @override
  String get resultsTotalVotes => 'إجمالي الأصوات';

  @override
  String get resultsVoterTurnout => 'نسبة إقبال الناخبين';

  @override
  String get resultsTurnoutRate => 'معدل الإقبال';

  @override
  String get resultsViewDetailed => 'عرض النتائج التفصيلية';

  @override
  String get myElectionsTitle => 'انتخاباتي';

  @override
  String get myElectionsSubtitle =>
      'كل انتخاب يمكنك رؤيته عبر مؤسساتك، في مكان واحد.';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterActive => 'نشط';

  @override
  String get filterUpcoming => 'قادم';

  @override
  String get filterCompleted => 'مكتمل';

  @override
  String get filterParticipated => 'شاركت فيه';

  @override
  String get filterResultsAvailable => 'النتائج متاحة';

  @override
  String get calendarTitle => 'تقويم الانتخابات';

  @override
  String get calendarAddToCalendar => 'إضافة إلى التقويم';

  @override
  String get emptyGenericTitle => 'لا يوجد شيء هنا بعد';

  @override
  String get emptyGenericMessage => 'لا يوجد شيء لعرضه الآن.';

  @override
  String get errorGenericMessage => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get loadingGeneric => 'جارٍ التحميل...';

  @override
  String get accessibilitySettingsTitle => 'إمكانية الوصول واللغة';

  @override
  String get accessibilityLanguage => 'اللغة';

  @override
  String get accessibilityLanguageSystem => 'افتراضي النظام';

  @override
  String get accessibilityReducedMotion => 'تقليل الحركة';

  @override
  String get accessibilityReducedMotionSubtitle =>
      'تقليل الرسوم المتحركة في جميع أنحاء التطبيق.';

  @override
  String get accessibilityHighContrast => 'تباين عالٍ';

  @override
  String get accessibilityHighContrastSubtitle =>
      'زيادة تباين النص والحدود لرؤية أفضل.';

  @override
  String get helpSupportTitle => 'المساعدة والدعم';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get transparencyTitle => 'مركز الثقة والشفافية';

  @override
  String get observerDashboardTitle => 'لوحة معلومات المراقب';

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
  String get navAccount => 'Account';

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
}
