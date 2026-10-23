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
  String get voterHomeTitle => 'انتخاباتي';

  @override
  String get voterHomeSubtitle => 'الانتخابات التي يمكنك رؤيتها في مؤسساتك.';

  @override
  String get voterSearchHint => 'ابحث باسم الانتخاب أو المؤسسة';

  @override
  String get voterFilterAll => 'الكل';

  @override
  String get voterFilterReady => 'جاهز للتصويت';

  @override
  String get voterFilterUpcoming => 'القادمة';

  @override
  String get voterFilterParticipated => 'شاركت';

  @override
  String get voterFilterClosed => 'المغلقة';

  @override
  String get voterFilterResults => 'النتائج المنشورة';

  @override
  String get voterSectionReady => 'جاهز للتصويت';

  @override
  String get voterSectionUpcoming => 'القادمة';

  @override
  String get voterSectionParticipated => 'شاركت';

  @override
  String get voterSectionOther => 'انتخابات أخرى';

  @override
  String get voterNoElectionsTitle => 'لا توجد انتخابات بعد';

  @override
  String get voterNoElectionsBody =>
      'ستظهر هنا الانتخابات التي تحق لك المشاركة فيها.';

  @override
  String get voterNoMatchTitle => 'لا توجد انتخابات مطابقة';

  @override
  String get voterNoMatchBody => 'جرّب بحثًا أو عامل تصفية مختلفًا.';

  @override
  String get voterLoadError => 'تعذّر تحميل انتخاباتك.';

  @override
  String get voterRetry => 'حاول مرة أخرى';

  @override
  String get voterStatusWarning =>
      'تعذّر تحميل بعض التفاصيل. الإجراءات التي تعتمد عليها مخفية حتى يتم تحميلها.';

  @override
  String get voterActionVoteNow => 'صوّت الآن';

  @override
  String get voterActionViewReceipt => 'عرض الإيصال';

  @override
  String get voterActionViewDetails => 'عرض التفاصيل';

  @override
  String get voterActionChecking => 'جارٍ التحقق من حالتك...';

  @override
  String get voterActionResultsPending => 'النتائج قيد الانتظار';

  @override
  String get voterActionViewResults => 'عرض النتائج المنشورة';

  @override
  String get voterChipParticipated => 'شاركت';

  @override
  String get voterChipNotEligible => 'غير مؤهل';

  @override
  String get voterChipChecking => 'جارٍ التحقق من الحالة';

  @override
  String voterOpens(String date) {
    return 'يفتح $date';
  }

  @override
  String voterCloses(String date) {
    return 'يُغلق $date';
  }

  @override
  String voterClosedOn(String date) {
    return 'أُغلق $date';
  }

  @override
  String get voterCalendar => 'التقويم';

  @override
  String get voterLoadMore => 'عرض المزيد';

  @override
  String get builderLeaveTitle => 'المغادرة دون حفظ؟';

  @override
  String get builderLeaveBody =>
      'لديك تغييرات لم تُحفظ في هذه المسودة. إذا غادرت الآن فستفقدها.';

  @override
  String get builderStay => 'متابعة التعديل';

  @override
  String get builderLeave => 'المغادرة وتجاهل التغييرات';

  @override
  String get navMyElections => 'انتخاباتي';

  @override
  String get navOverview => 'نظرة عامة';

  @override
  String get navPeople => 'الأشخاص';

  @override
  String get navActivity => 'النشاط';

  @override
  String get navBilling => 'الفوترة';

  @override
  String get navOrgSettings => 'إعدادات المؤسسة';

  @override
  String get navAccount => 'الملف الشخصي';

  @override
  String get navHelp => 'المساعدة';

  @override
  String get navMore => 'المزيد';

  @override
  String get navObserver => 'مراقب';

  @override
  String get navPlatform => 'المنصة';

  @override
  String get navCreateElection => 'إنشاء انتخاب';

  @override
  String get navMainLabel => 'التنقل الرئيسي';

  @override
  String get navMoreSectionLabel => 'المزيد';

  @override
  String get navPlatformSectionLabel => 'المنصة';

  @override
  String get adminEventsTitle => 'الانتخابات';

  @override
  String get adminEventsSubtitle =>
      'أنشئ الانتخابات لمؤسستك وحدّد مواعيدها وراقبها.';

  @override
  String get adminCreateElection => 'إنشاء انتخاب';

  @override
  String get adminCommandCenter => 'مركز القيادة';

  @override
  String get adminSearchEvents => 'البحث في الانتخابات';

  @override
  String get adminFilterAll => 'الكل';

  @override
  String get adminFilterActive => 'نشطة';

  @override
  String get adminFilterScheduled => 'مجدولة';

  @override
  String get adminFilterDraft => 'مسودة';

  @override
  String get adminFilterClosed => 'مغلقة';

  @override
  String get adminFilterArchived => 'مؤرشفة';

  @override
  String get adminNoEventsTitle => 'لا توجد انتخابات بعد';

  @override
  String get adminNoEventsBody =>
      'أنشئ أول انتخاب. يمكنك حفظه كمسودة ونشره عندما يصبح جاهزًا.';

  @override
  String get adminNoMatch => 'لا توجد انتخابات تطابق بحثك أو عامل التصفية.';

  @override
  String get adminLoadError =>
      'تعذّر تحميل انتخاباتك. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get adminOrgRequiredTitle => 'لا توجد مؤسسة نشطة';

  @override
  String get adminOrgRequiredBody => 'اختر مؤسسة لإدارة انتخاباتها.';

  @override
  String get adminSuspendedTitle => 'المؤسسة موقوفة';

  @override
  String get adminSuspendedBody =>
      'هذه المؤسسة موقوفة، لذلك تم تعطيل إدارة الانتخابات.';

  @override
  String get adminProcessing => 'جارٍ تحديث الانتخاب...';

  @override
  String adminEventRange(String start, String end) {
    return 'من $start إلى $end';
  }

  @override
  String get adminTypeCandidate => 'انتخاب مرشحين';

  @override
  String get adminTypeSingle => 'استطلاع باختيار واحد';

  @override
  String get adminTypeYesNo => 'استطلاع نعم/لا';

  @override
  String get adminActionDelete => 'حذف المسودة';

  @override
  String get adminActionManageChoices => 'إدارة الخيارات';

  @override
  String get adminActionEdit => 'تعديل التفاصيل';

  @override
  String get adminActionPublish => 'مراجعة ونشر';

  @override
  String get adminActionCancel => 'إلغاء الانتخاب';

  @override
  String get adminActionViewDetails => 'عرض التفاصيل';

  @override
  String get adminActionCloseEarly => 'إغلاق مبكر';

  @override
  String get adminActionMonitor => 'متابعة نسبة المشاركة';

  @override
  String get adminActionResults => 'عرض النتائج';

  @override
  String get adminDeleteTitle => 'حذف هذه المسودة؟';

  @override
  String adminDeleteBody(String title) {
    return 'سيتم حذف \"$title\" نهائيًا. لا يمكن التراجع عن ذلك.';
  }

  @override
  String get adminCancelTitle => 'إلغاء هذا الانتخاب؟';

  @override
  String adminCancelBody(String title) {
    return 'لن يُفتح \"$title\" للتصويت. ولن يراه الناخبون كانتخاب قادم.';
  }

  @override
  String get adminCloseTitle => 'إغلاق التصويت الآن؟';

  @override
  String adminCloseBody(String title) {
    return 'سيتوقف \"$title\" عن قبول الأصوات فورًا. لا يمكن التراجع عن ذلك.';
  }

  @override
  String get adminKeep => 'إبقاؤه';

  @override
  String get adminConfirmDelete => 'حذف المسودة';

  @override
  String get adminConfirmCancel => 'إلغاء الانتخاب';

  @override
  String get adminConfirmClose => 'إغلاق التصويت';

  @override
  String get adminGuideTitle1 => 'الإعداد';

  @override
  String get adminGuideBody1 => 'التفاصيل والجدول ومن يحق له التصويت.';

  @override
  String get adminGuideTitle2 => 'إضافة الخيارات';

  @override
  String get adminGuideBody2 => 'المرشحون أو خيارات الاستطلاع.';

  @override
  String get adminGuideTitle3 => 'النشر';

  @override
  String get adminGuideBody3 => 'راجع ثم افتحه للناخبين.';

  @override
  String get adminGuideTitle4 => 'المتابعة';

  @override
  String get adminGuideBody4 => 'نسبة المشاركة أثناء التصويت، والنتائج بعده.';

  @override
  String get builderCreateTitle => 'إنشاء انتخاب';

  @override
  String get builderEditTitle => 'تعديل مسودة الانتخاب';

  @override
  String get builderBack => 'رجوع';

  @override
  String builderStepOf(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get builderStepBasic => 'التفاصيل';

  @override
  String get builderStepSchedule => 'الجدول';

  @override
  String get builderStepEligibility => 'الأهلية';

  @override
  String get builderStepChoices => 'الخيارات';

  @override
  String get builderStepReview => 'المراجعة';

  @override
  String get builderStepsLabel => 'خطوات إعداد الانتخاب';

  @override
  String get builderDraftNeeded =>
      'احفظ المسودة أولًا. أكمل الخطوات السابقة ثم تابع.';

  @override
  String get builderCreateDraftNow => 'حفظ المسودة الآن';

  @override
  String get builderCreateDraftFailed =>
      'تعذّر حفظ المسودة. يُرجى المحاولة مرة أخرى.';

  @override
  String get builderStepBlocked =>
      'أكمل كل خطوة بزر «متابعة» الخاص بها قبل المتابعة.';

  @override
  String get builderLoadingDraft => 'جارٍ تحميل مسودة الانتخاب...';

  @override
  String get builderAdminsOnly =>
      'يمكن لمسؤولي المؤسسة فقط إنشاء الانتخابات أو تعديلها.';

  @override
  String get builderReturnHome => 'العودة إلى الرئيسية';

  @override
  String get overviewSubtitle => 'ما يحتاج إلى انتباه وما يحدث في مؤسستك.';

  @override
  String get overviewRequiredTitle => 'يحتاج إلى انتباهك';

  @override
  String overviewFinishDrafts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count انتخابات في المسودة لم تُنشر',
      one: 'انتخاب واحد في المسودة لم يُنشر',
    );
    return '$_temp0';
  }

  @override
  String overviewReviewInvites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دعوات بانتظار الرد',
      one: 'دعوة واحدة بانتظار الرد',
    );
    return '$_temp0';
  }

  @override
  String get overviewOpenElections => 'فتح الانتخابات';

  @override
  String get overviewOpenPeople => 'فتح الأشخاص';

  @override
  String get overviewMetricMembers => 'الأعضاء';

  @override
  String get overviewMetricDepartments => 'الأقسام';

  @override
  String get overviewMetricLive => 'الانتخابات الجارية';

  @override
  String get overviewMetricUpcoming => 'الانتخابات القادمة';

  @override
  String get overviewMetricInvites => 'الدعوات المعلقة';

  @override
  String get overviewUnavailable => 'غير متاح';

  @override
  String get overviewLoading => 'جارٍ التحميل';

  @override
  String get overviewElectionsTitle => 'الانتخابات الجارية والقادمة';

  @override
  String get overviewViewAll => 'عرض الكل';

  @override
  String get overviewNoLive => 'لا توجد انتخابات جارية أو قادمة.';

  @override
  String get overviewNoLiveBody => 'أنشئ انتخابًا للبدء.';

  @override
  String get overviewElectionsError => 'تعذّر تحميل الانتخابات.';

  @override
  String get overviewRetry => 'حاول مرة أخرى';

  @override
  String get overviewActivityTitle => 'النشاط الأخير';

  @override
  String get overviewNoActivity => 'لا يوجد نشاط حديث بعد.';

  @override
  String get overviewActivityError => 'النشاط الأخير غير متاح.';

  @override
  String get overviewActivityUnknown => 'إجراء إداري';

  @override
  String get overviewShortcuts => 'اختصارات';

  @override
  String get overviewShortcutPeople => 'الأشخاص';

  @override
  String get overviewShortcutDepartments => 'الأقسام';

  @override
  String get overviewShortcutCodes => 'رموز الانضمام';

  @override
  String get overviewShortcutInvites => 'الدعوات';

  @override
  String get overviewShortcutCommand => 'مركز القيادة';

  @override
  String get overviewShortcutSettings => 'إعدادات المؤسسة';

  @override
  String get overviewShortcutBilling => 'الخطط والفوترة';

  @override
  String get overviewAgoNow => 'الآن';

  @override
  String overviewAgoMinutes(int n) {
    return 'قبل $n دقيقة';
  }

  @override
  String overviewAgoHours(int n) {
    return 'قبل $n ساعة';
  }

  @override
  String overviewAgoDays(int n) {
    return 'قبل $n يوم';
  }

  @override
  String overviewAgoWeeks(int n) {
    return 'قبل $n أسبوع';
  }

  @override
  String overviewRole(String role) {
    return 'دورك: $role';
  }

  @override
  String get overviewLoadError =>
      'تعذّر تحميل مؤسستك. يُرجى المحاولة مرة أخرى.';

  @override
  String get orgsTitle => 'المؤسسات';

  @override
  String get orgsSubtitle =>
      'بدّل مساحة العمل أو انضم إلى مؤسسة أخرى أو أنشئ مؤسستك.';

  @override
  String get orgsCreate => 'إنشاء';

  @override
  String get orgsJoin => 'الانضمام برمز';

  @override
  String get orgsScan => 'مسح رمز QR للانضمام';

  @override
  String get orgsInvitations => 'الدعوات';

  @override
  String get orgsEmptyTitle => 'لا توجد مؤسسات بعد';

  @override
  String get orgsEmptyBody =>
      'انضم إلى مؤسسة موجودة برمز أو دعوة، أو أنشئ مؤسسة جديدة لإجراء الانتخابات.';

  @override
  String get orgsCreateFull => 'إنشاء مؤسسة';

  @override
  String get orgsJoinFull => 'الانضمام برمز';

  @override
  String get orgsOpen => 'فتح مساحة العمل';

  @override
  String get orgsCurrent => 'مساحة العمل الحالية';

  @override
  String get orgsLoadError =>
      'تعذّر تحميل مؤسساتك. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get orgsRetry => 'حاول مرة أخرى';

  @override
  String get orgsStatusPending => 'قيد المراجعة';

  @override
  String get orgsStatusSuspended => 'موقوفة';

  @override
  String get orgsStatusRejected => 'مرفوضة';

  @override
  String orgsRoleLine(String role) {
    return 'دورك: $role';
  }

  @override
  String get peopleTitle => 'الأشخاص';

  @override
  String get peopleSubtitle => 'أدر الأعضاء والأدوار والدعوات.';

  @override
  String get peopleAddExisting => 'إضافة مستخدم موجود';

  @override
  String get peopleInvite => 'دعوة عضو';

  @override
  String get peopleSearchHint => 'ابحث بالاسم أو البريد الإلكتروني';

  @override
  String get peopleSearchClear => 'مسح البحث';

  @override
  String get peopleFilterAll => 'الكل';

  @override
  String get peopleFilterManagers => 'المالكون والمسؤولون';

  @override
  String get peopleFilterMembers => 'الأعضاء';

  @override
  String get peopleFilterNotActive => 'غير نشطين';

  @override
  String get peopleNoMembersTitle => 'لا يوجد أعضاء بعد';

  @override
  String get peopleNoMembersBody =>
      'أضف مستخدمين موجودين أو ادعُ أشخاصًا إلى مؤسستك.';

  @override
  String get peopleNoMatchTitle => 'لا توجد نتائج مطابقة';

  @override
  String get peopleNoMatchBody => 'لا أحد يطابق بحثك أو عامل التصفية.';

  @override
  String get peopleLoadError =>
      'تعذّر تحميل قائمة الأعضاء. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get peopleRetry => 'حاول مرة أخرى';

  @override
  String get peopleRestricted => 'الوصول مقيّد';

  @override
  String get peopleRestrictedBody =>
      'يمكن لمسؤولي المؤسسة فقط رؤية قائمة الأعضاء.';

  @override
  String get peopleNoOrgTitle => 'لا توجد مؤسسة نشطة';

  @override
  String get peopleNoOrgBody => 'اختر مؤسسة لعرض أشخاصها.';

  @override
  String get peopleUnknownUser => 'مستخدم غير معروف';

  @override
  String peopleCount(int shown, int total) {
    return '$shown من $total أشخاص';
  }

  @override
  String get invTitle => 'الدعوات المعلقة';

  @override
  String get invRefresh => 'تحديث الدعوات';

  @override
  String get invLoadError => 'تعذّر تحميل الدعوات المعلقة.';

  @override
  String get invTryAgain => 'حاول مرة أخرى';

  @override
  String get invNone => 'لا توجد دعوات معلقة.';

  @override
  String get invExpired => 'منتهية';

  @override
  String get invExpiringSoon => 'تنتهي قريبًا';

  @override
  String invExpiresDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'تنتهي خلال $n أيام',
      one: 'تنتهي خلال يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String invExpiresHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'تنتهي خلال $n ساعات',
      one: 'تنتهي خلال ساعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String invExpiresMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'تنتهي خلال $n دقائق',
      one: 'تنتهي خلال دقيقة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get invRevoke => 'إلغاء';

  @override
  String get invRemove => 'إزالة';

  @override
  String get invKeep => 'إبقاؤها';

  @override
  String get invRevokeTitle => 'إلغاء هذه الدعوة؟';

  @override
  String invRevokeBody(String who) {
    return 'لن يتمكن $who من قبولها بعد الآن. يمكنك دعوته مرة أخرى لاحقًا.';
  }

  @override
  String get invRecipient => 'المستلم';

  @override
  String get invRevoked => 'تم إلغاء الدعوة.';

  @override
  String get invRevokeFailed => 'تعذّر إلغاء الدعوة. يُرجى المحاولة مرة أخرى.';

  @override
  String get invOwnerOnly => 'يمكن للمالك فقط إلغاء دعوات المسؤولين';

  @override
  String get deptTitle => 'الأقسام';

  @override
  String get deptSubtitle =>
      'قسّم الأعضاء إلى أقسام لتحديد من يحق له التصويت في الانتخاب.';

  @override
  String get deptNew => 'قسم جديد';

  @override
  String get deptSearchHint => 'البحث في الأقسام';

  @override
  String get deptSortName => 'الاسم من الألف إلى الياء';

  @override
  String get deptSortNameDesc => 'الاسم من الياء إلى الألف';

  @override
  String get deptSortMembers => 'الأكثر أعضاء';

  @override
  String get deptSortLabel => 'الترتيب';

  @override
  String get deptNoOrgTitle => 'اختر مؤسسة';

  @override
  String get deptNoOrgBody => 'الأقسام تتبع مؤسسة. اختر مؤسسة لعرض أقسامها.';

  @override
  String get deptNoOrgAction => 'الذهاب إلى الرئيسية';

  @override
  String get deptEmptyManagerTitle => 'لا توجد أقسام بعد';

  @override
  String get deptEmptyManagerBody =>
      'أنشئ أقسامًا لتنظيم الأعضاء وتحديد من يحق له التصويت.';

  @override
  String get deptEmptyMemberTitle => 'لم يتم تعيين قسم';

  @override
  String get deptEmptyMemberBody => 'لم يتم تعيينك في أي قسم في هذه المؤسسة.';

  @override
  String get deptNoMatch => 'لا توجد أقسام تطابق بحثك.';

  @override
  String get deptLoadError =>
      'تعذّر تحميل الأقسام. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get deptRetry => 'حاول مرة أخرى';

  @override
  String get deptMembersUnknown => 'الأعضاء: غير متاح';

  @override
  String get deptEventsNone => 'لم يُستخدم في أي انتخاب بعد';

  @override
  String get deptManageMembers => 'إدارة الأعضاء';

  @override
  String get deptActions => 'إجراءات القسم';

  @override
  String get deptEdit => 'تعديل التفاصيل';

  @override
  String get deptDelete => 'حذف القسم';

  @override
  String get deptDeleteTitle => 'حذف القسم؟';

  @override
  String deptDeleteBody(String name) {
    return 'سيتم حذف \"$name\" نهائيًا. يحتفظ الأعضاء بسجلاتهم، لكن لن يمكن تعيين هذا القسم أو استخدامه لأهلية الناخبين بعد الآن.';
  }

  @override
  String get deptDeleteConfirm => 'حذف القسم';

  @override
  String get deptKeep => 'إبقاؤه';

  @override
  String get deptDeleted => 'تم حذف القسم.';

  @override
  String get deptDeleteFailed => 'تعذّر حذف القسم. يُرجى المحاولة مرة أخرى.';

  @override
  String get deptCreateHint => 'أنشئ مجموعة لأعضائك';

  @override
  String deptCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n أقسام',
      one: 'قسم واحد',
    );
    return '$_temp0';
  }

  @override
  String deptMemberCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n أعضاء',
      one: 'عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String deptUsedIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'استُخدم في $n انتخابات',
      one: 'استُخدم في انتخاب واحد',
    );
    return '$_temp0';
  }

  @override
  String get inbTitle => 'الدعوات';

  @override
  String get inbSubtitle =>
      'راجع دعوات الانضمام إلى مؤسسة واختر كيف تريد الرد.';

  @override
  String inbPending(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n دعوات معلقة',
      one: 'دعوة معلقة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get inbEmptyTitle => 'لا شيء بانتظارك';

  @override
  String get inbEmptyBody =>
      'تظهر دعوات المؤسسات هنا. يمكنك قبول كل دعوة أو رفضها.';

  @override
  String get inbLoadError =>
      'تعذّر تحميل دعواتك. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get inbRetry => 'حاول مرة أخرى';

  @override
  String get inbAccept => 'قبول الدعوة';

  @override
  String get inbDecline => 'رفض';

  @override
  String get inbAcceptExpired => 'انتهت صلاحية الدعوة';

  @override
  String get inbRole => 'الدور';

  @override
  String inbExpires(String date) {
    return 'تنتهي في $date';
  }

  @override
  String get inbExpired => 'منتهية';

  @override
  String get inbNoExpiry => 'بلا انتهاء';

  @override
  String get inbDefaultOrg => 'المؤسسة';

  @override
  String inbJoinLine(String org, String role) {
    return 'الانضمام إلى $org بصفة $role';
  }

  @override
  String inbAcceptNote(String org) {
    return 'سيؤدي القبول إلى إضافة $org إلى مؤسساتك. يمكنك تبديل مساحات العمل في أي وقت.';
  }

  @override
  String get inbDeclineTitle => 'رفض هذه الدعوة؟';

  @override
  String inbDeclineBody(String org) {
    return 'لن تنضم إلى $org. يمكن للمسؤول دعوتك مرة أخرى لاحقًا.';
  }

  @override
  String get inbKeep => 'إبقاء الدعوة';

  @override
  String get inbDeclineConfirm => 'رفض';

  @override
  String inbJoined(String org) {
    return 'لقد انضممت إلى $org.';
  }

  @override
  String get inbDeclined => 'تم رفض الدعوة.';

  @override
  String get inbRespondFailed => 'تعذّر إكمال ذلك. يُرجى المحاولة مرة أخرى.';

  @override
  String get inbHelp => 'تحتاج إلى مساعدة بشأن دعوة؟ تواصل مع دعم Kivora.';

  @override
  String get ballotTitle => 'بطاقة اقتراعك';

  @override
  String get ballotSelectFirst => 'اختر خيارًا قبل المتابعة.';

  @override
  String get ballotLoadError =>
      'تعذّر تحميل بطاقة الاقتراع. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get ballotRetry => 'حاول مرة أخرى';

  @override
  String get ballotNotFound => 'تعذّر العثور على هذا الانتخاب.';

  @override
  String get ballotSignIn => 'سجّل الدخول للتصويت.';

  @override
  String get ballotNoCandidates => 'لم تتم إضافة مرشحين إلى هذا الانتخاب.';

  @override
  String get ballotNoOptions => 'لم تتم إضافة خيارات إلى هذا الانتخاب.';

  @override
  String get ballotOptionsLoadError => 'تعذّر تحميل الخيارات. حاول مرة أخرى.';

  @override
  String get ballotYes => 'نعم';

  @override
  String get ballotYesDesc => 'مؤيد لهذا المقترح';

  @override
  String get ballotNo => 'لا';

  @override
  String get ballotNoDesc => 'معارض لهذا المقترح';

  @override
  String get ballotOfficial => 'بطاقة اقتراع رسمية';

  @override
  String get ballotFinality =>
      'صوتك نهائي. بعد التأكيد لا يمكنك تغييره أو التصويت مرة أخرى.';

  @override
  String ballotTimeDays(int n) {
    return 'باقي $n يوم';
  }

  @override
  String ballotTimeHours(int n) {
    return 'باقي $n ساعة';
  }

  @override
  String ballotTimeMinutes(int n) {
    return 'باقي $n دقيقة';
  }

  @override
  String get ballotTimeSoon => 'يُغلق قريبًا';

  @override
  String get ballotTimeClosed => 'أُغلق التصويت';

  @override
  String ballotCandidate(String name) {
    return '$name، مرشح';
  }

  @override
  String ballotOption(String name) {
    return '$name، خيار';
  }

  @override
  String get ballotSelectedSuffix => 'محدد';

  @override
  String get ballotReceiptMissing =>
      'لم نعثر على إيصالك بعد. حاول مرة أخرى بعد قليل.';

  @override
  String get ballotYourChoice => 'اختيارك';

  @override
  String ballotStepsLabel(int current, int total, String label) {
    return '$current من $total: $label';
  }

  @override
  String get receiptSuccess => 'تم تسجيل بطاقة اقتراعك';

  @override
  String get receiptSecrecy =>
      'يؤكد هذا الإيصال أنه تم قبول بطاقة اقتراعك. لا يكشف ما اخترته ولا يتضمنه، ولا يمكنه إثبات اختيارك لأي شخص.';

  @override
  String get receiptKeep =>
      'احتفظ برقم الإيصال. يمكنك استخدامه لاحقًا للتحقق من تسجيل بطاقة اقتراعك.';

  @override
  String get receiptDetails => 'تفاصيل الإيصال';

  @override
  String get receiptTime => 'وقت التقديم';

  @override
  String get receiptTechnical => 'التفاصيل التقنية';

  @override
  String get receiptHashLabel => 'بصمة التحقق (SHA-256)';

  @override
  String receiptCopyLabel(String label) {
    return 'نسخ $label';
  }

  @override
  String receiptCopied(String label) {
    return 'تم نسخ $label';
  }

  @override
  String get receiptVerify => 'التحقق من إيصال';

  @override
  String get receiptClose => 'إغلاق';

  @override
  String get evBack => 'العودة إلى الانتخابات';

  @override
  String get evLoadError =>
      'تعذّر تحميل هذا الانتخاب. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get evRetry => 'حاول مرة أخرى';

  @override
  String get evNotFoundTitle => 'الانتخاب غير موجود';

  @override
  String get evNotFoundBody => 'هذا الانتخاب غير موجود أو تمت إزالته.';

  @override
  String get evSignInTitle => 'تسجيل الدخول مطلوب';

  @override
  String get evSignInBody => 'سجّل الدخول لعرض هذا الانتخاب.';

  @override
  String get evStatusLoadError =>
      'تعذّر التحقق مما إذا كنت قد صوّتت. حاول مرة أخرى قبل التصويت.';

  @override
  String get evVotedTitle => 'لقد صوّتت في هذا الانتخاب';

  @override
  String get evVotedBody => 'تم تسجيل مشاركتك.';

  @override
  String get evVotedNote =>
      'يمكن لكل عضو التصويت مرة واحدة، لذا لا يمكن التصويت مجددًا. احتفظ برقم الإيصال للتحقق لاحقًا من تسجيل بطاقة اقتراعك.';

  @override
  String get evViewReceipt => 'عرض إيصالك';

  @override
  String get evReceiptMissing =>
      'لم نعثر على إيصالك بعد. حاول مرة أخرى بعد قليل.';

  @override
  String get evProceed => 'الانتقال إلى بطاقة الاقتراع';

  @override
  String evNotAccepting(String status) {
    return 'هذا الانتخاب $status ولا يقبل الأصوات.';
  }

  @override
  String get evResultsPublishedTitle => 'النتائج منشورة';

  @override
  String evResultsPublishedBody(String date) {
    return 'أُغلق التصويت $date.';
  }

  @override
  String get evResultsPendingTitle => 'لم تُنشر النتائج بعد';

  @override
  String evResultsPendingBody(String date) {
    return 'أُغلق التصويت $date. ستظهر النتائج هنا عندما تنشرها المؤسسة.';
  }

  @override
  String get evResultsUnknownTitle => 'حالة النتائج غير متاحة';

  @override
  String get evResultsUnknownBody =>
      'تعذّر التحقق مما إذا كانت النتائج منشورة.';

  @override
  String get evViewResults => 'عرض النتائج';

  @override
  String get evDetails => 'تفاصيل الانتخاب';

  @override
  String get evType => 'نوع التصويت';

  @override
  String get evWho => 'من يحق له التصويت';

  @override
  String get evOpens => 'يفتح';

  @override
  String get evOpened => 'فُتح';

  @override
  String get evCloses => 'يُغلق';

  @override
  String get evClosed => 'أُغلق';

  @override
  String get evIdentifiableTitle => 'بطاقة اقتراع معروفة الهوية.';

  @override
  String get evIdentifiableBody =>
      'تُسجَّل الأصوات في هذا الانتخاب مع هوية الناخب.';

  @override
  String get evMonitor => 'متابعة نسبة المشاركة';

  @override
  String get evEditBuilder => 'التعديل في المنشئ';

  @override
  String get evChecking => 'جارٍ التحقق من حالتك';

  @override
  String get resTitle => 'نتائج الانتخاب';

  @override
  String get resBack => 'العودة إلى الانتخاب';

  @override
  String get resPublished => 'منشورة';

  @override
  String get resNotPublished => 'غير منشورة';

  @override
  String get resSubtitle => 'احتسبها الخادم بعد إغلاق التصويت.';

  @override
  String get resAdminOnly =>
      'لا يمكن لغير مسؤولي المؤسسة رؤية هذه النتائج قبل نشرها.';

  @override
  String get resFootnote =>
      'النسب محسوبة من بطاقات الاقتراع المحتسبة. لا يرى الأعضاء النتائج إلا بعد أن ينشرها المسؤول.';

  @override
  String get resNotAvailableTitle => 'النتائج غير متاحة';

  @override
  String get resNotAvailableBody => 'تظهر النتائج هنا بعد أن تنشرها المؤسسة.';

  @override
  String get resLoadErrorTitle => 'تعذّر تحميل النتائج';

  @override
  String get resLoadErrorBody => 'تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get resRetry => 'حاول مرة أخرى';

  @override
  String get resNoneTitle => 'لا توجد نتائج بعد';

  @override
  String get resNoneBody => 'لم تُحتسب النتائج بعد.';

  @override
  String get resNoBallots => 'لم تُسجَّل أي بطاقات اقتراع في هذا الانتخاب.';

  @override
  String get resBallots => 'بطاقات الاقتراع المحتسبة';

  @override
  String get resEligible => 'الناخبون المؤهلون';

  @override
  String get resTurnout => 'نسبة المشاركة';

  @override
  String get resSplit => 'توزيع الأصوات';

  @override
  String get resTie => 'تعادل';

  @override
  String resTieBody(String names, int votes, String percent) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes أصوات',
      one: 'صوت واحد',
    );
    return 'حصل كل من $names على $_temp0 ($percent%).';
  }

  @override
  String resWins(String name) {
    return 'فاز $name';
  }

  @override
  String resWinsBody(int votes, String percent) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes أصوات',
      one: 'صوت واحد',
    );
    return '$_temp0 ($percent%).';
  }

  @override
  String resVotes(int votes) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes أصوات',
      one: 'صوت واحد',
    );
    return '$_temp0';
  }

  @override
  String get resRecalculate => 'إعادة احتساب النتائج';

  @override
  String get resWorking => 'جارٍ العمل...';

  @override
  String get resPublish => 'نشر النتائج للأعضاء';

  @override
  String get resCalculate => 'احتساب النتائج';

  @override
  String get resExport => 'تصدير CSV';

  @override
  String get resExportTitle => 'تصدير النتائج (CSV)';

  @override
  String get resCopyCsv => 'نسخ CSV';

  @override
  String get resCsvCopied => 'تم نسخ CSV';

  @override
  String get resClose => 'إغلاق';

  @override
  String get resActionFailed => 'لم تنجح العملية. يُرجى المحاولة مرة أخرى.';

  @override
  String get resPublishConfirmTitle => 'نشر هذه النتائج؟';

  @override
  String get resPublishConfirmBody =>
      'سيتمكن جميع الأعضاء المؤهلين من رؤية النتائج. يمكنك إعادة احتسابها لاحقًا.';

  @override
  String get resPublishConfirm => 'نشر';

  @override
  String get resCancel => 'إلغاء';

  @override
  String get resEventFallback => 'الانتخاب';

  @override
  String get monTitle => 'نسبة المشاركة المباشرة';

  @override
  String get monBack => 'رجوع';

  @override
  String get monLive => 'مباشر';

  @override
  String monUpdated(int s) {
    return 'مباشر · تم التحديث قبل $s ث';
  }

  @override
  String get monRefresh => 'تحديث';

  @override
  String monClosesIn(String when) {
    return 'يُغلق خلال $when';
  }

  @override
  String monRemainDaysHours(int d, int h) {
    String _temp0 = intl.Intl.pluralLogic(
      d,
      locale: localeName,
      other: '$d أيام',
      one: 'يوم',
    );
    String _temp1 = intl.Intl.pluralLogic(
      h,
      locale: localeName,
      other: '$h ساعات',
      one: 'ساعة',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String monRemainHoursMin(int h, int m) {
    String _temp0 = intl.Intl.pluralLogic(
      h,
      locale: localeName,
      other: '$h ساعات',
      one: 'ساعة',
    );
    return '$_temp0 $m د';
  }

  @override
  String monRemainMin(int m) {
    return '$m د';
  }

  @override
  String get monPrivacy =>
      'أعداد فقط. لا تُعرض هنا هويات الناخبين ولا اختياراتهم. تبقى النتائج مخفية حتى يُغلق الانتخاب وتُنشر النتائج.';

  @override
  String get monLoadError =>
      'تعذّر تحميل نسبة المشاركة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get monRetry => 'حاول مرة أخرى';

  @override
  String get monRefreshIssue =>
      'فشل آخر تحديث. تُعرض آخر الأرقام التي تم تحميلها.';

  @override
  String get monTurnoutLabel => 'الأعضاء المؤهلون الذين شاركوا';

  @override
  String monOfEligible(int voted, int eligible) {
    return '$voted من $eligible';
  }

  @override
  String get monEligible => 'المؤهلون';

  @override
  String get monEligibleCap => 'جميع الأعضاء النشطين';

  @override
  String get monVoted => 'صوّتوا';

  @override
  String get monVotedCap => 'بطاقات الاقتراع المقدّمة';

  @override
  String get monNotYet => 'لم يصوّتوا بعد';

  @override
  String get monNotYetCap => 'الأعضاء المتبقون';

  @override
  String get monChartTitle => 'المشاركة عبر الزمن';

  @override
  String get monChartSub => 'المشاركة التراكمية منذ فتح الانتخاب';

  @override
  String get monChartNone =>
      'لا توجد بيانات كافية بعد لرسم المشاركة عبر الزمن.';

  @override
  String monChartTotal(int n) {
    return 'صوّت $n';
  }

  @override
  String get monChartStart => 'فُتح';

  @override
  String get monChartNow => 'الآن';

  @override
  String get monDeptTitle => 'المشاركة حسب القسم';

  @override
  String get monDeptNone => 'لا توجد بيانات أقسام لهذا الانتخاب.';

  @override
  String get monDeptNote =>
      'تُدمج المجموعات التي تضم أقل من 5 أعضاء مؤهلين لحماية الخصوصية.';

  @override
  String monDeptRow(int participated, int eligible, String percent) {
    return '$participated من $eligible · $percent%';
  }

  @override
  String get monDeptFallback => 'القسم';

  @override
  String get monDetails => 'تفاصيل الانتخاب';

  @override
  String get monWindow => 'فترة التصويت';

  @override
  String get monBallotType => 'نوع بطاقة الاقتراع';

  @override
  String get monAnonymous => 'مجهولة الهوية';

  @override
  String get monIdentifiable => 'معروفة الهوية';

  @override
  String get monEligibility => 'من يحق له التصويت';

  @override
  String get monVotingType => 'نوع التصويت';

  @override
  String get monBoostTitle => 'زيادة المشاركة';

  @override
  String get monBoostBody =>
      'ذكّر الأعضاء الذين لم يصوّتوا. تُرسل التذكيرات تلقائيًا إلى من لم يصوّت؛ ولن ترى من صوّت ومن لم يصوّت.';

  @override
  String get monRemind => 'تذكير من لم يصوّت';

  @override
  String get monSending => 'جارٍ الإرسال...';

  @override
  String get monRemindNone => 'صوّت جميع المؤهلين بالفعل.';

  @override
  String monRemindDone(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'تم إرسال تذكير إلى $n ناخبين لم يصوّتوا.',
      one: 'تم إرسال تذكير إلى ناخب واحد لم يصوّت.',
    );
    return '$_temp0';
  }

  @override
  String get monRemindFailed =>
      'تعذّر إرسال التذكيرات. يُرجى المحاولة مرة أخرى.';

  @override
  String get monPrivateNote => 'تبقى المشاركة خاصة';

  @override
  String get monCloseTitle => 'إغلاق التصويت مبكرًا';

  @override
  String get monCloseNote =>
      'الإغلاق نهائي. قد تحتاج إلى تسجيل الدخول مرة أخرى إذا مرّ على آخر تسجيل دخول أكثر من 15 دقيقة. تبقى النتائج مخفية حتى تحتسبها وتنشرها.';

  @override
  String get monCloseButton => 'إغلاق التصويت الآن';

  @override
  String get monCloseDialogTitle => 'إغلاق التصويت الآن؟';

  @override
  String get monCloseDialogBody =>
      'الإغلاق نهائي. لن يتمكن الأعضاء من التصويت بعد الآن، ولا يمكن التراجع عن ذلك. تبقى النتائج مخفية حتى تحتسبها وتنشرها.';

  @override
  String get monCloseConfirm => 'إغلاق التصويت';

  @override
  String get monCancel => 'إلغاء';

  @override
  String get monClosed => 'تم إغلاق التصويت.';

  @override
  String get monCloseFailed => 'تعذّر إغلاق التصويت. يُرجى المحاولة مرة أخرى.';

  @override
  String get monReauth =>
      'للأمان، يتطلب إغلاق الانتخاب أن تكون قد سجّلت الدخول خلال آخر 15 دقيقة. يُرجى التحقق من هويتك للمتابعة.';

  @override
  String get calTitle => 'تقويم الانتخابات';

  @override
  String get calAgendaView => 'عرض القائمة';

  @override
  String get calCalendarView => 'عرض التقويم';

  @override
  String get calLoadError =>
      'تعذّر تحميل التقويم. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get calRetry => 'حاول مرة أخرى';

  @override
  String get calAllOrgs => 'جميع المؤسسات';

  @override
  String get calMonth => 'شهر';

  @override
  String get calWeek => 'أسبوع';

  @override
  String get calNoneTitle => 'لا توجد انتخابات للعرض';

  @override
  String get calNoneBody => 'لا توجد انتخابات في مؤسساتك بعد.';

  @override
  String get calNoDayTitle => 'لا توجد انتخابات في هذا اليوم';

  @override
  String get calNoDayBody => 'اختر تاريخًا آخر لمعرفة ما هو مجدول.';

  @override
  String calCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n انتخابات',
      one: 'انتخاب واحد',
      zero: 'لا توجد انتخابات',
    );
    return '$_temp0';
  }

  @override
  String get calDetails => 'التفاصيل';

  @override
  String get calAdd => 'إضافة إلى التقويم';

  @override
  String calRange(String start, String end) {
    return 'من $start إلى $end';
  }

  @override
  String get authOr => 'أو';

  @override
  String get authNewUser => 'جديد هنا؟';

  @override
  String get authHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authSignIn => 'تسجيل الدخول';

  @override
  String get authRemembered => 'تذكرت كلمة المرور؟';

  @override
  String get authShowPassword => 'إظهار كلمة المرور';

  @override
  String get authHidePassword => 'إخفاء كلمة المرور';

  @override
  String get authUnexpectedError => 'حدث خطأ ما. يُرجى المحاولة مرة أخرى.';

  @override
  String get authMfaUnsupported =>
      'خطوة تسجيل الدخول الثانية لهذا الحساب غير مدعومة في هذا التطبيق بعد. يُرجى التواصل مع الدعم.';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusScheduled => 'مجدول';

  @override
  String get statusClosed => 'مغلق';

  @override
  String get statusArchived => 'مؤرشف';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get statusDraft => 'مسودة';

  @override
  String get statusUnknown => 'غير معروف';

  @override
  String get privacyAnonymous => 'مجهولة الهوية';

  @override
  String get privacyIdentifiable => 'معروفة الهوية';

  @override
  String get roleOwner => 'مالك';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get roleMember => 'عضو';

  @override
  String get navJoiningCodes => 'رموز الانضمام';

  @override
  String get navPlatformAccounts => 'الحسابات والصلاحيات';

  @override
  String get navInvitations => 'الدعوات';

  @override
  String get acctTitle => 'إعدادات الحساب';

  @override
  String get acctTabProfile => 'الملف الشخصي';

  @override
  String get acctTabSecurity => 'الأمان والإعدادات';

  @override
  String get acctTabNotifications => 'الإشعارات';

  @override
  String get acctTabPreferences => 'التفضيلات';

  @override
  String get acctTabAccounts => 'الحسابات المرتبطة';

  @override
  String get acctTabSecurityShort => 'الأمان';

  @override
  String get acctTabNotificationsShort => 'التنبيهات';

  @override
  String get acctTabPreferencesShort => 'التفضيلات';

  @override
  String get acctTabAccountsShort => 'الحسابات';

  @override
  String get acctLoading => 'جارٍ تحميل الملف الشخصي...';

  @override
  String get acctLoadError =>
      'تعذّر تحميل ملفك الشخصي. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get acctNotFound => 'لم يتم العثور على الملف الشخصي.';

  @override
  String get acctPhotoUpdated => 'تم تحديث صورة الملف الشخصي بنجاح.';

  @override
  String get acctPhotoFailed => 'تعذّر رفع الصورة. حاول مرة أخرى.';

  @override
  String get acctProfileUpdated => 'تم تحديث الملف الشخصي بنجاح.';

  @override
  String get acctVerified => 'موثّق';

  @override
  String get acctUnverified => 'غير موثّق';

  @override
  String acctMemberSince(String date) {
    return 'عضو منذ $date';
  }

  @override
  String get acctPersonalInfo => 'المعلومات الشخصية';

  @override
  String get acctFirstName => 'الاسم الأول';

  @override
  String get acctLastName => 'اسم العائلة';

  @override
  String get acctFirstNameField => 'الاسم الأول';

  @override
  String get acctLastNameField => 'اسم العائلة';

  @override
  String get acctPhone => 'رقم الهاتف (اختياري)';

  @override
  String get acctSaveChanges => 'حفظ التغييرات';

  @override
  String get acctAuthMethod => 'طريقة المصادقة';

  @override
  String get acctGoogleNote =>
      'حسابك مرتبط بـ Google. تتم إدارة تغيير كلمة المرور من خلال حساب Google الخاص بك.';

  @override
  String get acct2fa => 'المصادقة الثنائية';

  @override
  String get acct2faBody => 'احمِ حسابك بطلب خطوة مصادقة إضافية.';

  @override
  String get acctSetupAuth => 'إعداد تطبيق المصادقة';

  @override
  String get acctSignOut => 'تسجيل الخروج';

  @override
  String get acctAppearance => 'المظهر';

  @override
  String get acctAppearanceBody => 'اختر مظهر Kivora على هذا الجهاز.';

  @override
  String get acctThemeLight => 'فاتح';

  @override
  String get acctThemeDark => 'داكن';

  @override
  String get acctThemeSystem => 'النظام';

  @override
  String get acctLanguage => 'اللغة';

  @override
  String get acctLanguageNote =>
      'ترجمات الأردية والسندية والعربية بمساعدة الآلة ولم يراجعها بعد متحدث أصلي. يرجى الإبلاغ عن أي شيء يبدو غير صحيح.';

  @override
  String get acctSystemDefault => 'افتراضي النظام';

  @override
  String get acctAccessibility => 'إمكانية الوصول';

  @override
  String get acctReduceMotion => 'تقليل الحركة';

  @override
  String get acctReduceMotionBody => 'تقليل الرسوم المتحركة في التطبيق.';

  @override
  String get acctHighContrast => 'تباين عالٍ';

  @override
  String get acctHighContrastBody => 'زيادة تباين النص والحدود لرؤية أفضل.';

  @override
  String get acctTextSizeNote =>
      'يتبع حجم النص إعدادات إمكانية الوصول في جهازك. اختيارات المرشحين/الخيارات في شاشة الاقتراع مُسمّاة بالفعل لقارئات الشاشة.';

  @override
  String get acctNotifications => 'الإشعارات';

  @override
  String get acctNotificationsBody =>
      'اختر الإشعارات التي تريد استلامها. تنطبق على جرس الإشعارات ورسائل التذكير الإلكترونية.';

  @override
  String get acctVoteReminders => 'تذكيرات التصويت';

  @override
  String get acctVoteRemindersBody =>
      'احصل على إشعار عندما يوشك انتخاب نشط على الإغلاق ولم تصوّت بعد.';

  @override
  String get acctResultsPublished => 'نشر النتائج';

  @override
  String get acctResultsPublishedBody =>
      'احصل على إشعار عند نشر نتائج انتخاب كنت مؤهلاً للتصويت فيه.';

  @override
  String get acctInvitationAlerts => 'دعوات المؤسسات';

  @override
  String get acctInvitationAlertsBody =>
      'إظهار دعوات المؤسسات المعلّقة في جرس الإشعارات.';

  @override
  String get acctConnectedTitle => 'الحسابات المرتبطة';

  @override
  String get acctConnectedBody =>
      'طرق تسجيل الدخول المرتبطة بحسابك في Kivora. يجب إبقاء طريقة واحدة على الأقل.';

  @override
  String get acctEmailPassword => 'البريد الإلكتروني وكلمة المرور';

  @override
  String get acctGoogleSignIn => 'سجّل الدخول بحساب Google الخاص بك.';

  @override
  String get acctConnectedBadge => 'مرتبط';

  @override
  String get acctConnect => 'ربط';

  @override
  String get acctDisconnect => 'إلغاء الربط';

  @override
  String acctDisconnectTitle(String name) {
    return 'إلغاء ربط $name؟';
  }

  @override
  String acctDisconnectBody(String name) {
    return 'لن تتمكن من تسجيل الدخول إلى Kivora باستخدام $name.';
  }

  @override
  String get acctCancel => 'إلغاء';

  @override
  String get acctGoogleConnected => 'تم ربط حساب Google.';

  @override
  String get acctChangePassword => 'تغيير كلمة المرور';

  @override
  String get acctCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get acctNewPassword => 'كلمة المرور الجديدة';

  @override
  String get acctConfirmPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get acctUpdatePassword => 'تحديث كلمة المرور';

  @override
  String get acctPasswordUpdated => 'تم تحديث كلمة المرور بنجاح!';
}
