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
      'سيتمكن جميع الأعضاء المؤهلين من رؤية النتائج، وسيتلقى إشعارًا من فعّلوا إشعارات النتائج. يمكنك إعادة احتسابها لاحقًا.';

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

  @override
  String get navPlatformOverview => 'نظرة عامة على المنصة';

  @override
  String get navPlatformOrganizations => 'جميع المؤسسات';

  @override
  String get navPlatformReports => 'بلاغات المستخدمين';

  @override
  String get navPlatformAudit => 'سجل التدقيق';

  @override
  String get resNotClosedYet => 'يمكن احتساب النتائج بعد إغلاق الانتخاب.';

  @override
  String get orgSetSaveTitle => 'حفظ تغييرات العلامة التجارية؟';

  @override
  String get orgSetUnsavedBody =>
      'لقد غيّرت العلامة التجارية لهذه المؤسسة دون حفظها. لا يمكن استرجاع التغييرات المهملة.';

  @override
  String get orgSetKeepEditing => 'متابعة التحرير';

  @override
  String get orgSetDiscard => 'تجاهل';

  @override
  String get orgSetSave => 'حفظ';

  @override
  String get orgSetLoading => 'جارٍ تحميل المؤسسة…';

  @override
  String get orgSetLoadError =>
      'تعذّر تحميل المؤسسة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get orgSetNoOrgTitle => 'لا توجد مؤسسة نشطة';

  @override
  String get orgSetNoOrgBody => 'اختر مؤسسة قبل تغيير علامتها التجارية.';

  @override
  String get orgSetDeniedTitle => 'تم رفض الوصول';

  @override
  String get orgSetDeniedBody =>
      'يمكن لمالك المؤسسة فقط تحديث علامتها التجارية.';

  @override
  String get orgSetBackOverview => 'نظرة عامة';

  @override
  String get orgSetTitle => 'العلامة التجارية للمؤسسة';

  @override
  String orgSetSubtitle(String a) {
    return 'حدّد كيف تظهر $a للأعضاء والناخبين.';
  }

  @override
  String get orgSetDetails => 'تفاصيل المؤسسة';

  @override
  String get orgSetDetailsBody => 'اسم مؤسستك العام ونبذة قصيرة عنها.';

  @override
  String get orgSetNameLabel => 'اسم المؤسسة *';

  @override
  String get orgSetNameHint => 'مثلاً شركة أكمي';

  @override
  String get orgSetNameShort => 'استخدم 3 أحرف على الأقل.';

  @override
  String get orgSetDescription => 'الوصف';

  @override
  String get orgSetDescriptionHint => 'ملخص موجز عن مؤسستك أو قسمك...';

  @override
  String get orgSetDescriptionHelp => 'نبذة قصيرة تظهر في ملف مؤسستك.';

  @override
  String get orgSetWebsite => 'الموقع الإلكتروني (اختياري)';

  @override
  String get orgSetWebsiteInvalid => 'أدخل رابط HTTPS صالحًا.';

  @override
  String get orgSetLogo => 'شعار المؤسسة';

  @override
  String get orgSetLogoActive => 'الشعار مفعّل';

  @override
  String get orgSetLogoNone => 'لم يتم رفع شعار';

  @override
  String get orgSetLogoChange => 'اختر شعارًا آخر';

  @override
  String get orgSetLogoChoose => 'اختر شعارًا';

  @override
  String get orgSetRemove => 'إزالة';

  @override
  String get orgSetLogoHelp =>
      'PNG أو JPEG أو WebP · حتى 2 ميغابايت\nاستخدم صورة مربعة للحصول على أفضل نتيجة.';

  @override
  String get orgSetPreviewName => 'اسم المؤسسة';

  @override
  String get orgSetPreviewDescription => 'سيظهر الوصف هنا...';

  @override
  String get orgSetPreviewNoWebsite => 'لم تتم إضافة موقع إلكتروني';

  @override
  String get orgSetPreviewTitle => 'معاينة ملف العضو';

  @override
  String get orgSetPreviewBody => 'كيف ستظهر مؤسستك للأعضاء.';

  @override
  String get orgSetPreviewRole => 'عضو';

  @override
  String get orgSetPreviewViewEvents => 'عرض الانتخابات';

  @override
  String get orgSetPreviewNote =>
      'معاينة فقط. تظهر التغييرات للأعضاء والناخبين بعد الحفظ.';

  @override
  String get orgSetNotPermTitle => 'العلامة التجارية، لا الصلاحيات';

  @override
  String get orgSetNotPermBody =>
      'يُدار التحكم في الوصول والتحقق بشكل منفصل. تحديث العلامة التجارية لن يغيّر أيًّا منهما.';

  @override
  String get orgSetDirtyTitle => 'لديك تغييرات غير محفوظة';

  @override
  String get orgSetDirtyLogo =>
      'تم اختيار شعار جديد لكنه لم يُرفع بعد. احفظ لرفعه ونشره.';

  @override
  String get orgSetDirtyBody =>
      'احفظ لنشر علامتك التجارية، أو أعد الضبط لتجاهل تغييراتك.';

  @override
  String get orgSetReset => 'إعادة ضبط';

  @override
  String get orgSetSaving => 'جارٍ الحفظ...';

  @override
  String get orgSetSaveBranding => 'حفظ العلامة التجارية';

  @override
  String get orgSetLogoTooBig => 'الشعار أكبر من 2 ميغابايت. اختر صورة أصغر.';

  @override
  String get orgSetSaved => 'تم حفظ العلامة التجارية للمؤسسة.';

  @override
  String get orgSetSaveFailed =>
      'تعذّر حفظ العلامة التجارية. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get orgSetDanger => 'منطقة الخطر';

  @override
  String get orgSetDangerBody =>
      'سيؤدي حذف هذه المؤسسة إلى أرشفة مساحة عملها. ستتوقف الانتخابات النشطة عن قبول الأصوات.';

  @override
  String get orgSetDelete => 'حذف المؤسسة';

  @override
  String get orgSetDeleteTitle => 'حذف المؤسسة؟';

  @override
  String orgSetDeleteBody(String a) {
    return 'هل أنت متأكد من حذف \"$a\"؟\n\nسيؤدي ذلك إلى أرشفة مساحة عمل المؤسسة. لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get orgSetKeep => 'الإبقاء على المؤسسة';

  @override
  String get orgSetDeleted => 'تم حذف المؤسسة.';

  @override
  String get jcMaxUsesInvalid => 'أدخل الحد الأقصى للاستخدام من 0 إلى 100,000.';

  @override
  String get jcSaveTitle => 'احفظ رمز الانضمام هذا';

  @override
  String get jcShownOnce =>
      'يظهر هذا الرمز مرة واحدة فقط. شاركه فقط مع من تريد انضمامهم إلى هذه المؤسسة.';

  @override
  String get jcScanHint =>
      'أو امسح هذا الرمز بخيار \"Scan to Join\" في Kivora على جهاز آخر.';

  @override
  String get jcCopied => 'تم النسخ';

  @override
  String get jcCopy => 'نسخ الرمز';

  @override
  String get jcDone => 'تم';

  @override
  String get jcRevokeTitle => 'إلغاء هذا الرمز؟';

  @override
  String get jcCancel => 'إلغاء';

  @override
  String get jcRevoke => 'إلغاء الرمز';

  @override
  String get jcRevokeNoId => 'لا يمكن إلغاء هذا الرمز (المعرّف مفقود).';

  @override
  String get jcRevoked => 'تم إلغاء رمز الانضمام.';

  @override
  String get jcTitle => 'رموز الانضمام';

  @override
  String get jcRefresh => 'تحديث رموز الانضمام';

  @override
  String get jcLoading => 'جارٍ تحميل المؤسسة…';

  @override
  String get jcOrgLoadError =>
      'تعذّر تحميل هذه المؤسسة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get jcNoOrgTitle => 'اختر مؤسسة';

  @override
  String get jcNoOrgBody => 'اختر مؤسسة قبل إدارة رموز الانضمام.';

  @override
  String get jcAdminTitle => 'يلزم صلاحية المسؤول';

  @override
  String get jcAdminBody =>
      'يمكن لمالك هذه المؤسسة ومسؤوليها فقط إدارة رموز الانضمام.';

  @override
  String get jcSubtitle =>
      'أنشئ رموزًا يمكن للناس بها الانضمام إلى هذه المؤسسة وألغِها. الرمز الصالح يضيف الشخص عضوًا فورًا؛ ولا يمنح أبدًا صلاحية مسؤول أو مالك.';

  @override
  String get jcStatActive => 'رموز نشطة';

  @override
  String get jcStatExpired => 'منتهية أو مستنفدة';

  @override
  String get jcStatRevoked => 'ملغاة';

  @override
  String get jcExisting => 'الرموز الحالية';

  @override
  String get jcLoadError =>
      'تعذّر تحميل رموز الانضمام. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get jcEmpty => 'لا توجد رموز انضمام لهذه المؤسسة.';

  @override
  String get jcCreateTitle => 'إنشاء رمز انضمام';

  @override
  String get jcCreateNote =>
      'يظهر الرمز مرة واحدة. يُخزَّن كتجزئة آمنة ولا يمكن استرجاعه لاحقًا.';

  @override
  String get jcCreating => 'جارٍ الإنشاء…';

  @override
  String get jcCreate => 'إنشاء رمز';

  @override
  String get jcExpiresAfter => 'ينتهي بعد';

  @override
  String get jcExp24h => '24 ساعة';

  @override
  String get jcExp3d => '3 أيام';

  @override
  String get jcExp7d => '7 أيام';

  @override
  String get jcExp30d => '30 يومًا';

  @override
  String get jcExp1y => 'سنة واحدة';

  @override
  String get jcMaxUses => 'الحد الأقصى للاستخدام';

  @override
  String get jcMaxUsesHint => 'استخدم 0 لعدد غير محدود.';

  @override
  String get jcExpiryUnknown => 'تاريخ الانتهاء غير متاحة';

  @override
  String jcExpires(String a) {
    return 'ينتهي في $a';
  }

  @override
  String jcUses(String a) {
    return '$a استخدام';
  }

  @override
  String jcUsesOf(String a, String b) {
    return '$a من $b استخدام';
  }

  @override
  String get dmDeleteTitle => 'حذف القسم';

  @override
  String dmDeleteBody(String a) {
    return 'هل أنت متأكد من حذف \"$a\"؟\n\nسيؤدي ذلك إلى حذف القسم نهائيًا.';
  }

  @override
  String get dmCancel => 'إلغاء';

  @override
  String get dmDeleted => 'تم حذف القسم بنجاح.';

  @override
  String dmDeleteFailed(String a) {
    return 'تعذّر الحذف: $a';
  }

  @override
  String get dmDeletePermanent => 'حذف نهائي';

  @override
  String dmAssigned(String a, String b) {
    return 'تم تعيين $a عضو/أعضاء في $b.';
  }

  @override
  String dmAssignFailed(String a) {
    return 'تعذّر تعيين الأعضاء: $a';
  }

  @override
  String get dmRemoveFrom => 'إزالة من القسم';

  @override
  String dmRemoveBody(String a) {
    return 'إزالة \"$a\" من هذا القسم؟';
  }

  @override
  String get dmRemove => 'إزالة';

  @override
  String dmRemoved(String a) {
    return 'تمت إزالة $a من القسم.';
  }

  @override
  String dmRemoveFailed(String a) {
    return 'تعذّرت إزالة العضو: $a';
  }

  @override
  String get dmNoOrgTitle => 'لا توجد مؤسسة نشطة';

  @override
  String get dmNoOrgBody => 'يرجى اختيار مؤسسة لعرض أعضاء القسم.';

  @override
  String get dmLoadingDept => 'جارٍ تحميل تفاصيل القسم...';

  @override
  String get dmLoadingRoster => 'جارٍ تحميل قائمة القسم...';

  @override
  String get dmRosterError =>
      'تعذّر تحميل القائمة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get dmBack => 'الأقسام';

  @override
  String dmAssignedCount(String a) {
    return '$a أعضاء معيّنون';
  }

  @override
  String get dmEligibleNote =>
      'يمكن اختيار أعضاء هذا القسم كناخبين مؤهلين في الانتخابات.';

  @override
  String get dmEdit => 'تعديل التفاصيل';

  @override
  String get dmDelete => 'حذف';

  @override
  String dmMembersIn(String a) {
    return 'أعضاء $a';
  }

  @override
  String get dmNoMembers => 'لم يُعيَّن أي عضو بعد';

  @override
  String get dmNoMembersBody =>
      'اختر أشخاصًا من القائمة لإضافتهم إلى هذا القسم. يمكنك التغيير في أي وقت.';

  @override
  String get dmAssignedHere => 'سيظهر الأعضاء المعيّنون هنا.';

  @override
  String dmPendingNote(String a, String b) {
    return 'التحديدات المعلّقة ليست أعضاء بعد. أكّد بـ \"تعيين $a أعضاء\" لإضافتهم إلى $b.';
  }

  @override
  String get dmAddMembers => 'إضافة أعضاء';

  @override
  String dmSelectPeople(String a) {
    return 'اختر أشخاصًا لتعيينهم في $a.';
  }

  @override
  String get dmSearch => 'ابحث بالاسم';

  @override
  String get dmAllMembers => 'جميع الأعضاء';

  @override
  String get dmNoDept => 'بلا قسم';

  @override
  String get dmNoMatch => 'لا يوجد أعضاء يطابقون بحثك.';

  @override
  String dmIn(String a) {
    return 'في $a';
  }

  @override
  String dmInFirst(String a) {
    return 'في $a';
  }

  @override
  String dmAssignedTo(String a) {
    return 'معيّن في $a';
  }

  @override
  String get dmClear => 'مسح';

  @override
  String dmPendingTo(String a) {
    return 'تعيين معلّق في $a';
  }

  @override
  String get dmAssigning => 'جارٍ التعيين...';

  @override
  String dmAssign(String a) {
    return 'تعيين $a أعضاء';
  }

  @override
  String jcRevokeBody(String a) {
    return 'لن يتمكن أي شخص يملك هذا الرمز من استخدامه بعد الآن. ($a)';
  }

  @override
  String jcCodeLabel(String a) {
    return 'الرمز • $a';
  }

  @override
  String get statusExhausted => 'مستنفد';

  @override
  String get statusExpired => 'منتهٍ';

  @override
  String get statusRevoked => 'ملغى';

  @override
  String get dmMemberFallback => 'عضو';

  @override
  String dmSelectedCount(String a) {
    return '$a محدد';
  }

  @override
  String get auditActAcceptInvitation => 'تم قبول الدعوة';

  @override
  String get auditActActivateVotingEvent => 'تم تفعيل الانتخاب';

  @override
  String get auditActAddMember => 'تمت إضافة عضو';

  @override
  String get auditActAssignDepartment => 'تم تعيين قسم';

  @override
  String get auditActCalculateResults => 'تم احتساب النتائج';

  @override
  String get auditActCancelVotingEvent => 'تم إلغاء الانتخاب';

  @override
  String get auditActCloseVotingEvent => 'تم إغلاق الانتخاب';

  @override
  String get auditActCreateCandidate => 'تمت إضافة مرشح';

  @override
  String get auditActCreateDepartment => 'تم إنشاء قسم';

  @override
  String get auditActCreateJoiningCode => 'تم إنشاء رمز انضمام';

  @override
  String get auditActCreateOrganization => 'تم إنشاء المؤسسة';

  @override
  String get auditActCreatePollOption => 'تمت إضافة خيار استطلاع';

  @override
  String get auditActCreateVotingEvent => 'تم إنشاء انتخاب';

  @override
  String get auditActDeclineInvitation => 'تم رفض الدعوة';

  @override
  String get auditActDeleteCandidate => 'تمت إزالة مرشح';

  @override
  String get auditActDeleteCandidatePhoto => 'تمت إزالة صورة مرشح';

  @override
  String get auditActDeleteDepartment => 'تم حذف قسم';

  @override
  String get auditActDeleteOrganization => 'تم حذف المؤسسة';

  @override
  String get auditActDeletePollOption => 'تمت إزالة خيار استطلاع';

  @override
  String get auditActDeleteVotingEvent => 'تم حذف الانتخاب';

  @override
  String get auditActFinalizeCandidatePhoto => 'تم حفظ صورة المرشح';

  @override
  String get auditActGrantObserverStatus => 'تم منح صلاحية مراقب';

  @override
  String get auditActInviteMember => 'تمت دعوة عضو';

  @override
  String get auditActJoinOrganizationWithCode => 'انضمام برمز';

  @override
  String get auditActLeaveOrganization => 'تمت مغادرة المؤسسة';

  @override
  String get auditActPlanChanged => 'تم تغيير الخطة';

  @override
  String get auditActPlatformAdminAccessGranted => 'تم منح صلاحية مسؤول المنصة';

  @override
  String get auditActPlatformAdminAccessRemoved => 'تم سحب صلاحية مسؤول المنصة';

  @override
  String get auditActPublishResults => 'تم نشر النتائج';

  @override
  String get auditActPublishVotingEvent => 'تم نشر الانتخاب';

  @override
  String get auditActRemindNonVoters => 'تم إرسال تذكير لمن لم يصوّتوا';

  @override
  String get auditActRemoveDepartment => 'تمت إزالة عضو من قسم';

  @override
  String get auditActRemoveMember => 'تمت إزالة عضو';

  @override
  String get auditActRevokeInvitation => 'تم إلغاء الدعوة';

  @override
  String get auditActRevokeJoiningCode => 'تم إلغاء رمز الانضمام';

  @override
  String get auditActRevokeObserverStatus => 'تم سحب صلاحية مراقب';

  @override
  String get auditActUpdateCandidate => 'تم تحديث مرشح';

  @override
  String get auditActUpdateDepartment => 'تم تحديث قسم';

  @override
  String get auditActUpdateMemberRole => 'تم تغيير دور عضو';

  @override
  String get auditActUpdateMemberStatus => 'تم تغيير حالة عضو';

  @override
  String get auditActUpdateOrganizationMetadata => 'تم تحديث بيانات المؤسسة';

  @override
  String get auditActUpdatePollOption => 'تم تحديث خيار استطلاع';

  @override
  String get auditActUpdateVotingEvent => 'تم تحديث الانتخاب';

  @override
  String get auditActOrganizationVerify => 'تم التحقق من المؤسسة';

  @override
  String get auditActOrganizationReject => 'تم رفض المؤسسة';

  @override
  String get auditActOrganizationSuspend => 'تم تعليق المؤسسة';

  @override
  String get auditActOrganizationReactivate => 'تمت إعادة تفعيل المؤسسة';

  @override
  String get auditActUnknown => 'إجراء إداري';

  @override
  String get auditSystem => 'النظام';

  @override
  String get auLoading => 'جارٍ تحميل نشاط المؤسسة…';

  @override
  String get auOrgLoadError =>
      'تعذّر تحميل المؤسسة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get auNoOrgTitle => 'اختر مؤسسة';

  @override
  String get auNoOrgBody => 'اختر مؤسسة لعرض نشاطها.';

  @override
  String get auDeniedTitle => 'تم رفض الوصول';

  @override
  String get auDeniedBody =>
      'يمكن لمالك هذه المؤسسة ومسؤوليها فقط عرض سجل التدقيق.';

  @override
  String get auCrumbOrg => 'المؤسسة';

  @override
  String get auCrumbActivity => 'النشاط';

  @override
  String get auTitle => 'نشاط المؤسسة';

  @override
  String get auSubtitle => 'راجع تغييرات العضوية والدعوات في مؤسستك.';

  @override
  String get auLoadingHistory => 'جارٍ تحميل سجل التدقيق…';

  @override
  String get auLoadError =>
      'تعذّر تحميل نشاط المؤسسة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get auSearchLong => 'ابحث بالنشاط أو معرّف الحساب أو نوع السجل';

  @override
  String get auSearchShort => 'ابحث في النشاط...';

  @override
  String get auReset => 'إعادة ضبط';

  @override
  String get auAllTypes => 'جميع أنواع السجلات';

  @override
  String get auFilterType => 'تصفية حسب نوع السجل';

  @override
  String get auAllAccounts => 'جميع الحسابات';

  @override
  String auAccount(String a) {
    return 'الحساب $a';
  }

  @override
  String get auFilterAccount => 'تصفية حسب الحساب';

  @override
  String get auDateRange => 'نطاق التاريخ';

  @override
  String get auFilterDate => 'تصفية حسب نطاق التاريخ';

  @override
  String get auAllTime => 'كل الأوقات';

  @override
  String get auToday => 'اليوم';

  @override
  String get auLast7 => 'آخر 7 أيام';

  @override
  String get auLast30 => 'آخر 30 يومًا';

  @override
  String get auCustomRange => 'نطاق تاريخ مخصص...';

  @override
  String get auDateUnknown => 'التاريخ غير متاح';

  @override
  String get auAllRecords => 'جميع السجلات';

  @override
  String get auMembers => 'الأعضاء';

  @override
  String get auInvitations => 'الدعوات';

  @override
  String get auNewest => 'الأحدث أولًا';

  @override
  String get auOldest => 'الأقدم أولًا';

  @override
  String get auColActivity => 'النشاط';

  @override
  String get auColType => 'نوع السجل';

  @override
  String get auColAccount => 'معرّف الحساب';

  @override
  String get auColTime => 'الوقت';

  @override
  String get auNoMatch => 'لا توجد سجلات نشاط تطابق معاييرك.';

  @override
  String get auRecordOne => 'سجل واحد';

  @override
  String auRecordMany(String a) {
    return '$a سجلات';
  }

  @override
  String auShown(String a) {
    return '$a سجلات معروضة · السجلات المكررة محفوظة';
  }

  @override
  String get auTimesNote => 'التواريخ والأوقات كما سُجّلت';

  @override
  String get auUnavailable => 'غير متاح';

  @override
  String get auTimeUnknown => 'الوقت غير متاح';

  @override
  String get auViewDetails => 'عرض التفاصيل ';

  @override
  String auActorBullet(String a) {
    return '• $a';
  }

  @override
  String get auRecordedAt => 'وقت التسجيل';

  @override
  String get auRecordType => 'نوع السجل';

  @override
  String get auAccountId => 'معرّف الحساب';

  @override
  String get auNoActorDetail =>
      'لا يتضمن هذا السجل هوية المنفّذ ولا تفاصيل التغيير.';

  @override
  String get evGenericTitle => 'حدث خطأ';

  @override
  String get evGenericStatus => 'خطأ';

  @override
  String get evOrgTitle => 'لا توجد مؤسسة نشطة';

  @override
  String get evOrgStatus => 'المؤسسة مطلوبة';

  @override
  String get evConnTitle => 'انقطع الاتصال';

  @override
  String get evConnStatus => 'الاتصال متقطع';

  @override
  String get evDeniedTitle => 'تم رفض الوصول';

  @override
  String get evDeniedStatus => 'الصلاحية مطلوبة';

  @override
  String get evSessionTitle => 'انتهت الجلسة';

  @override
  String get evSessionStatus => 'تسجيل الدخول مطلوب';

  @override
  String get evSaveTitle => 'تعذّر حفظ التغييرات';

  @override
  String get evSaveStatus => 'فشل الحفظ';

  @override
  String get evServiceTitle => 'الخدمة غير متاحة';

  @override
  String get evServiceStatus => 'انقطاع في الخدمة';

  @override
  String get evSelectOrg => 'اختر مؤسسة';

  @override
  String get evRequestAccess => 'طلب الوصول';

  @override
  String get evSignIn => 'تسجيل الدخول';

  @override
  String get evTryAgain => 'حاول مرة أخرى';

  @override
  String get errRetry => 'إعادة المحاولة';

  @override
  String get osPending => 'قيد المراجعة';

  @override
  String get osVerified => 'موثّقة';

  @override
  String get osActive => 'نشطة';

  @override
  String get osSuspended => 'معلّقة';

  @override
  String get osRejected => 'مرفوضة';

  @override
  String get osArchived => 'مؤرشفة';

  @override
  String get porVerify => 'توثيق';

  @override
  String get porReject => 'رفض';

  @override
  String get porSuspend => 'تعليق';

  @override
  String get porReactivate => 'إعادة تفعيل';

  @override
  String porReviewTitle(String a) {
    return '$a المؤسسة؟';
  }

  @override
  String get porThisOrg => 'هذه المؤسسة';

  @override
  String porReviewBody(String a, String b) {
    return 'سيتم تعليم $a على أنها $b.';
  }

  @override
  String porMarked(String a) {
    return 'تم تعليم المؤسسة على أنها $a.';
  }

  @override
  String get porUpdateFailed => 'تعذّر تحديث المؤسسة.';

  @override
  String get porLoadFailed => 'تعذّر تحميل المؤسسات.';

  @override
  String get porTitle => 'جميع المؤسسات';

  @override
  String get porCheckingAccess => 'جارٍ التحقق من صلاحية المنصة…';

  @override
  String get porDeniedTitle => 'تم رفض الوصول';

  @override
  String get porVerifyAccessFailed => 'تعذّر التحقق من صلاحية مسؤول المنصة.';

  @override
  String get porSuperAdminsOnly =>
      'هذا القسم متاح لمسؤولي المنصة الرئيسيين فقط.';

  @override
  String get porLoading => 'جارٍ تحميل المؤسسات…';

  @override
  String get porEmptyTitle => 'لا توجد مؤسسات بعد';

  @override
  String get porEmptyBody => 'لم تُسجَّل أي مؤسسة على المنصة بعد.';

  @override
  String get porSearch => 'ابحث بالاسم أو البريد أو المدينة';

  @override
  String get porClearSearch => 'مسح البحث';

  @override
  String get porShowing100 => 'عرض أحدث 100 مؤسسة.';

  @override
  String porNoMatch(String a) {
    return 'لا توجد مؤسسة تطابق \"$a\" في هذا العرض.';
  }

  @override
  String porNothingIn(String a) {
    return 'لا شيء في \"$a\".';
  }

  @override
  String porRegistered(String a) {
    return 'تاريخ التسجيل: $a';
  }

  @override
  String get porArchivedNote => 'حذفها مالكها. لا توجد إجراءات إشراف متاحة.';

  @override
  String get porRejectedNote => 'مرفوضة. لا توجد إجراءات أخرى متاحة.';

  @override
  String get porCancel => 'إلغاء';

  @override
  String get pfNeedsReview => 'تحتاج مراجعة';

  @override
  String get pfVerified => 'موثّقة';

  @override
  String get pfSuspended => 'معلّقة';

  @override
  String get pfClosed => 'مؤرشفة / مرفوضة';

  @override
  String get pfAll => 'الكل';

  @override
  String get paLoadFailed => 'تعذّر تحميل بيانات المنصة.';

  @override
  String get paLoadMoreFailed => 'تعذّر تحميل المزيد من المستخدمين.';

  @override
  String get paGrantTitle => 'منح صلاحية مسؤول المنصة';

  @override
  String get paEmailLabel => 'عنوان البريد الإلكتروني للحساب';

  @override
  String get paEmailHint => 'name@example.com';

  @override
  String get paCancel => 'إلغاء';

  @override
  String get paGrant => 'منح الصلاحية';

  @override
  String paGranted(String a) {
    return 'تم منح $a صلاحية مسؤول المنصة.';
  }

  @override
  String get paGrantFailed => 'تعذّر منح صلاحية المسؤول.';

  @override
  String get paThisAccount => 'هذا الحساب';

  @override
  String get paRevokeTitle => 'سحب صلاحية مسؤول المنصة؟';

  @override
  String paRevokeBody(String a) {
    return 'ستفقد $a صلاحيات مسؤول المنصة الرئيسي.';
  }

  @override
  String get paRevoke => 'سحب';

  @override
  String get paRevoked => 'تم سحب صلاحية المسؤول.';

  @override
  String get paRevokeFailed => 'تعذّر سحب صلاحية المسؤول.';

  @override
  String get paTitle => 'الحسابات والصلاحيات';

  @override
  String get paChecking => 'جارٍ التحقق من صلاحية المنصة…';

  @override
  String get paDenied => 'تم رفض الوصول';

  @override
  String get paVerifyFailed => 'تعذّر التحقق من صلاحية مسؤول المنصة.';

  @override
  String get paOnlySuper => 'هذا القسم متاح لمسؤولي المنصة الرئيسيين فقط.';

  @override
  String get paLoading => 'جارٍ تحميل بيانات المنصة…';

  @override
  String get paAccounts => 'الحسابات';

  @override
  String get paGrantButton => 'منح صلاحية المسؤول';

  @override
  String get paLoadMore => 'تحميل المزيد';

  @override
  String get paStatUsers => 'المستخدمون';

  @override
  String get paStatOrgs => 'المؤسسات';

  @override
  String get paStatPending => 'مؤسسات قيد المراجعة';

  @override
  String get paStatActive => 'مؤسسات نشطة';

  @override
  String get paStatSuspended => 'مؤسسات معلّقة';

  @override
  String get paStatMembers => 'الأعضاء';

  @override
  String get paStatActiveMembers => 'أعضاء نشطون';

  @override
  String get paStatEvents => 'انتخابات';

  @override
  String get paStatActiveEvents => 'انتخابات نشطة';

  @override
  String get paNoEmail => '(لا بريد إلكتروني)';

  @override
  String get paTagAdmin => 'مسؤول المنصة';

  @override
  String get paTagUnverified => 'غير موثّق';

  @override
  String get paTagDisabled => 'معطّل';

  @override
  String get plOverviewTitle => 'نظرة عامة على المنصة';

  @override
  String get plOverviewSubtitle =>
      'المؤسسات والمراجعات ونشاط المسؤولين الأخير عبر Kivora.';

  @override
  String get plRefresh => 'تحديث';

  @override
  String get plPendingOne => 'مؤسسة واحدة بانتظار المراجعة.';

  @override
  String plPendingMany(String a) {
    return '$a مؤسسات بانتظار المراجعة.';
  }

  @override
  String get plReviewOrgs => 'مراجعة المؤسسات';

  @override
  String get plReportsOne => 'بلاغ مستخدم مفتوح واحد.';

  @override
  String plReportsMany(String a) {
    return '$a بلاغات مستخدمين مفتوحة.';
  }

  @override
  String get plOpenReports => 'فتح البلاغات';

  @override
  String get plTotalsFailed => 'تعذّر تحميل إجماليات المنصة.';

  @override
  String get plStatOrgs => 'المؤسسات';

  @override
  String get plStatWaiting => 'بانتظار المراجعة';

  @override
  String get plStatActive => 'نشطة أو موثّقة';

  @override
  String get plStatSuspended => 'معلّقة';

  @override
  String get plStatAccounts => 'الحسابات';

  @override
  String get plStatMemberships => 'العضويات النشطة';

  @override
  String get plStatElections => 'الانتخابات والاستطلاعات';

  @override
  String get plStatOpenNow => 'التصويت مفتوح الآن';

  @override
  String get plNeedsAttention => 'تحتاج انتباهًا';

  @override
  String get plChecksIncomplete =>
      'تعذّر تشغيل بعض الفحوصات، فقد تكون هذه القائمة ناقصة.';

  @override
  String get plNothingAttention => 'لا شيء يحتاج انتباهًا الآن.';

  @override
  String get plRecentActivity => 'نشاط المسؤولين الأخير';

  @override
  String get plViewAll => 'عرض الكل';

  @override
  String get plUnavailable => 'غير متاح';

  @override
  String get plTryAgain => 'حاول مرة أخرى';

  @override
  String get plActivityFailed => 'تعذّر تحميل سجل النشاط.';

  @override
  String get plNoActivity => 'لم تُسجَّل أي إجراءات للمسؤولين بعد.';

  @override
  String get plTimeUnknown => 'الوقت غير متاح';

  @override
  String plTarget(String a) {
    return 'الهدف: $a';
  }

  @override
  String plBy(String a) {
    return 'بواسطة $a';
  }

  @override
  String get plAuditTitle => 'سجل التدقيق';

  @override
  String get plAuditSubtitle => 'إجراءات مسؤولي المنصة، الأحدث أولًا.';

  @override
  String get plAuditLoading => 'جارٍ تحميل سجل التدقيق…';

  @override
  String get plAuditFailed => 'تعذّر تحميل سجل التدقيق.';

  @override
  String get plAuditEmptyTitle => 'لا توجد إدخالات بعد';

  @override
  String get plAuditEmptyBody =>
      'ستظهر إجراءات مسؤولي المنصة هنا بمجرد حدوثها.';

  @override
  String get plAuditNote =>
      'تُسجَّل هنا الإجراءات المكتملة فقط؛ المحاولات الفاشلة لا تترك سجلًا.';

  @override
  String get plAuditSearch => 'ابحث بالإجراء أو الشخص أو المؤسسة';

  @override
  String get plClearSearch => 'مسح البحث';

  @override
  String get plAllActions => 'جميع الإجراءات';

  @override
  String get plEntryOne => 'إدخال واحد';

  @override
  String plEntryMany(String a) {
    return '$a إدخالات';
  }

  @override
  String get plNoEntryMatch => 'لا يوجد إدخال يطابق عوامل التصفية الحالية.';

  @override
  String get plLoadOlder => 'تحميل إدخالات أقدم';

  @override
  String get plReportsTitle => 'بلاغات المستخدمين';

  @override
  String get plReportsSubtitle =>
      'الملاحظات والمشكلات المرسلة من المساعدة والدعم.';

  @override
  String get plReportsLoading => 'جارٍ تحميل البلاغات…';

  @override
  String get plReportsFailed => 'تعذّر تحميل البلاغات.';

  @override
  String get plReportsEmptyTitle => 'لا توجد بلاغات';

  @override
  String get plReportsEmptyBody => 'لم يرسل أحد بلاغًا بعد.';

  @override
  String get plReportsReadOnly =>
      'للقراءة فقط حاليًا: لا تدعم المنصة بعد تعيين البلاغات أو حلّها، لذا يبقى كل بلاغ مفتوحًا. ولا توجد قائمة بالمؤسسات المُبلَّغ عنها.';

  @override
  String plAllCount(String a) {
    return 'الكل ($a)';
  }

  @override
  String get plLoadOlderReports => 'تحميل بلاغات أقدم';

  @override
  String get plNoSubject => '(بلا موضوع)';

  @override
  String plReceiptRef(String a) {
    return 'مرجع الإيصال: $a';
  }

  @override
  String get plShowLess => 'عرض أقل';

  @override
  String get plShowFull => 'عرض الرسالة كاملة';

  @override
  String get plCatGeneral => 'ملاحظات عامة';

  @override
  String get plCatElection => 'مشكلة في الانتخاب';

  @override
  String get plCatTechnical => 'مشكلة تقنية';

  @override
  String get plCatAccount => 'مشكلة في الحساب';

  @override
  String get plStatusOpen => 'مفتوح';

  @override
  String get plCheckingAccess => 'جارٍ التحقق من صلاحية المنصة…';

  @override
  String get plDeniedTitle => 'تم رفض الوصول';

  @override
  String get plVerifyFailed => 'تعذّر التحقق من صلاحية مسؤول المنصة.';

  @override
  String get plOnlySuper => 'هذا القسم متاح لمسؤولي المنصة الرئيسيين فقط.';

  @override
  String get msActive => 'نشط';

  @override
  String get msInactive => 'غير نشط';

  @override
  String get msPending => 'معلّق';

  @override
  String get msSuspended => 'موقوف';

  @override
  String get msRemoved => 'مُزال';

  @override
  String get coTypeAcademic => 'مؤسسة أكاديمية';

  @override
  String get coTypeCorporate => 'مؤسسة تجارية';

  @override
  String get coTypeNonProfit => 'منظمة غير ربحية';

  @override
  String get coTypeClub => 'نادٍ / جمعية طلابية';

  @override
  String get coTypeCommunity => 'جمعية مجتمعية';

  @override
  String get coTypeOther => 'أخرى';

  @override
  String get coCreated => 'تم إنشاء المؤسسة والتحقق منها!';

  @override
  String get coClose => 'إغلاق';

  @override
  String get coTitle => 'إنشاء مؤسسة';

  @override
  String get coSubtitle => 'امنح مجتمعك مساحة مشتركة للأشخاص والأقسام والنشاط.';

  @override
  String get coNameLabel => 'اسم المؤسسة *';

  @override
  String get coNameHint => 'مثلاً مجتمعك أو شركتك';

  @override
  String get coNameField => 'اسم المؤسسة';

  @override
  String get coNameShort => 'يجب ألا يقل الاسم عن حرفين';

  @override
  String get coNameLong => 'لا يمكن أن يتجاوز الاسم 80 حرفًا';

  @override
  String get coNameHelp =>
      'استخدم اسمًا يتعرّف عليه أعضاؤك. من 2 إلى 80 حرفًا.';

  @override
  String get coTypeLabel => 'نوع المؤسسة *';

  @override
  String get coTypeHint => 'اختر نوعًا';

  @override
  String get coCityLabel => 'المدينة (اختياري)';

  @override
  String get coCityHint => 'أدخل المدينة';

  @override
  String get coCountryLabel => 'الدولة (اختياري)';

  @override
  String get coCountryHint => 'اختر الدولة';

  @override
  String get coVerifiedTitle => 'توثيق فورية، وستكون المالك';

  @override
  String get coVerifiedBody =>
      'بما أن بريد حسابك موثّق، تُنشأ مؤسستك موثّقة مسبقًا - دون حاجة لمراجعة يدوية. أعدّ مساحة عملك وعلامتك التجارية ورموز الانضمام مباشرة بعد ذلك.';

  @override
  String get coRequired => '* أكمل الحقول المطلوبة لإنشاء مؤسستك.';

  @override
  String get coCancel => 'إلغاء';

  @override
  String get coCreate => 'إنشاء المؤسسة';

  @override
  String joJoined(String a) {
    return 'تم الانضمام إلى $a بنجاح!';
  }

  @override
  String get joClose => 'إغلاق';

  @override
  String get joTitle => 'الانضمام إلى مؤسسة برمز';

  @override
  String get joSubtitle =>
      'أدخل رمز الانضمام الذي شاركه مالك مؤسستك للعثور على مساحة عملك.';

  @override
  String get joCodeLabel => 'رمز الانضمام';

  @override
  String get joCodeHint => 'أدخل رمز الانضمام';

  @override
  String get joCodeField => 'رمز الانضمام';

  @override
  String get joCodeHelp => 'الصق الرمز كاملًا تمامًا كما وصلك.';

  @override
  String get joScan => 'امسح رمز QR بدلًا من ذلك';

  @override
  String get joNoCode => 'ليس لديك رمز؟';

  @override
  String get joNoCodeBody =>
      'اطلب رمزًا من مالك مؤسستك. إذا كان الرمز غير صالح أو منتهيًا فاطلب رمزًا جديدًا.';

  @override
  String get joReviewNote => 'ستراجع المؤسسة قبل تأكيد رغبتك في الانضمام.';

  @override
  String get joCancel => 'إلغاء';

  @override
  String get joFind => 'البحث عن المؤسسة';

  @override
  String get joConfirmTitle => 'هل هذه مؤسستك؟';

  @override
  String get joConfirmBody =>
      'أكّد أن هذه هي مساحة العمل التي تريد الانضمام إليها قبل المتابعة.';

  @override
  String get joVerified => 'موثّقة';

  @override
  String get joPending => 'التحقق معلّق';

  @override
  String get joDifferent => 'استخدم رمزًا آخر';

  @override
  String joJoin(String a) {
    return 'الانضمام إلى $a';
  }

  @override
  String get imCreatedTitle => 'تم إنشاء الدعوة';

  @override
  String imCreatedBody(String a) {
    return 'تم إنشاء دعوة لـ $a.';
  }

  @override
  String get imCreatedNote =>
      'سيراها المدعو في إشعارات Kivora بعد تسجيل الدخول، وله القبول أو الرفض من هناك.';

  @override
  String get imShareLink => 'شارك هذا الرابط المباشر مع المدعو:';

  @override
  String get imDone => 'تم';

  @override
  String get imTitle => 'دعوة عضو';

  @override
  String get imClose => 'إغلاق';

  @override
  String get imSubtitle => 'ادعُ شخصًا للانضمام إلى مساحة عملك.';

  @override
  String get imEmailLabel => 'عنوان البريد الإلكتروني للمدعو *';

  @override
  String get imEmailHint => 'voter@organization.com';

  @override
  String imOrg(String a) {
    return 'المؤسسة: $a';
  }

  @override
  String get imRole => 'صلاحية الدور';

  @override
  String get imRoleMember => 'عضو';

  @override
  String get imRoleAdmin => 'مسؤول';

  @override
  String get imCancel => 'إلغاء';

  @override
  String get imSend => 'إرسال الدعوة';

  @override
  String get aeTitle => 'إضافة عضو موجود';

  @override
  String get aeClose => 'إغلاق';

  @override
  String get aeSubtitle => 'أضف حساب Kivora موثّقًا مباشرة إلى هذه المؤسسة.';

  @override
  String get aeEmailLabel => 'عنوان البريد الإلكتروني للعضو *';

  @override
  String get aeEmailHint => 'user@example.com';

  @override
  String get aeEmailInvalid => 'أدخل عنوان بريد إلكتروني صالحًا.';

  @override
  String get aeCancel => 'إلغاء';

  @override
  String get aeAdd => 'إضافة عضو';

  @override
  String get adAssigned => 'تم تعيين العضو بنجاح.';

  @override
  String adFailed(String a) {
    return 'تعذّر تعيين العضو: $a';
  }

  @override
  String get adTitle => 'إضافة عضو إلى القسم';

  @override
  String get adClose => 'إغلاق';

  @override
  String get adSearchLabel => 'ابحث في الأعضاء النشطين';

  @override
  String get adSearchHint => 'اكتب اسمًا أو بريدًا إلكترونيًا...';

  @override
  String get adNone => 'لم يُعثر على أعضاء نشطين مؤهلين.';

  @override
  String get adUnknown => 'مستخدم غير معروف';

  @override
  String adCurrentlyIn(String a, String b) {
    return '$a • حاليًا في $b';
  }

  @override
  String adAddTo(String a) {
    return 'إضافة $a إلى هذا القسم';
  }

  @override
  String get mpCancel => 'إلغاء';

  @override
  String get mpUser => 'مستخدم';

  @override
  String get mpNone => 'لا شيء';

  @override
  String get mpRole => 'الدور';

  @override
  String get mpStatus => 'الحالة';

  @override
  String get mpDepartment => 'القسم';

  @override
  String get mpObserver => 'صلاحية المراقب';

  @override
  String get mpGranted => 'ممنوحة';

  @override
  String get mpPromote => 'ترقية إلى مسؤول';

  @override
  String get mpPromoted => 'تمت الترقية إلى مسؤول بنجاح.';

  @override
  String get mpDemote => 'خفض إلى عضو';

  @override
  String get mpDemoted => 'تم الخفض إلى عضو بنجاح.';

  @override
  String get mpGrantObserver => 'منح صلاحية المراقب';

  @override
  String get mpGrantedDone => 'تم منح صلاحية المراقب.';

  @override
  String get mpRevokeObserver => 'سحب صلاحية المراقب';

  @override
  String get mpRevokedDone => 'تم سحب صلاحية المراقب.';

  @override
  String get mpDeactivate => 'تعطيل العضو';

  @override
  String get mpDeactivated => 'تم تعطيل العضو بنجاح.';

  @override
  String get mpReactivate => 'إعادة تفعيل العضو';

  @override
  String get mpReactivated => 'تمت إعادة تفعيل العضو بنجاح.';

  @override
  String get mpRemove => 'إزالة العضو';

  @override
  String mpRemoveTitle(String a) {
    return 'إزالة $a؟';
  }

  @override
  String get mpRemoveBody => 'سيفقدون الوصول إلى هذه المؤسسة فورًا.';

  @override
  String get mpRemoved => 'تمت إزالة العضو من المؤسسة.';

  @override
  String get mpClose => 'إغلاق';

  @override
  String get imOrgLabel => 'المؤسسة';

  @override
  String get vtCandidate => 'انتخاب مرشحين';

  @override
  String get vtSingleChoice => 'استطلاع اختيار واحد';

  @override
  String get vtYesNo => 'استطلاع نعم/لا';

  @override
  String get etAll => 'جميع الأعضاء النشطين';

  @override
  String get etMembers => 'أعضاء محددون';

  @override
  String get etDepartments => 'أقسام محددة';

  @override
  String get ccLoadError =>
      'تعذّر تحميل مركز القيادة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get ccNoOrgTitle => 'لا توجد مؤسسة نشطة';

  @override
  String get ccNoOrgBody => 'اختر مؤسسة لعرض مركز القيادة الخاص بها.';

  @override
  String get ccAdminTitle => 'يلزم صلاحية المسؤول';

  @override
  String get ccAdminBody =>
      'مركز قيادة الانتخابات متاح لمالكي المؤسسة ومسؤوليها.';

  @override
  String get ccElectionsError =>
      'تعذّر تحميل الانتخابات. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get ccTitle => 'مركز قيادة الانتخابات';

  @override
  String get ccSearch => 'بحث';

  @override
  String get ccFilterDate => 'تصفية حسب نطاق التاريخ';

  @override
  String get ccCreate => 'إنشاء انتخاب';

  @override
  String get ccSuspended =>
      'هذه المؤسسة معلّقة. إدارة الانتخابات معطّلة حتى إعادتها.';

  @override
  String get ccActiveTitle => 'مراقبة الانتخابات النشطة';

  @override
  String get ccActiveNone => 'لا توجد انتخابات نشطة حاليًا.';

  @override
  String get ccUpcomingTitle => 'جدول الانتخابات القادمة';

  @override
  String get ccUpcomingNone => 'لا توجد انتخابات مجدولة.';

  @override
  String get ccAlerts => 'التنبيهات';

  @override
  String ccNoVoters(String a) {
    return 'لم يُحدَّد ناخبون مؤهلون لـ \"$a\".';
  }

  @override
  String get ccTasks => 'المهام الإدارية المعلّقة';

  @override
  String get ccTasksNone => 'لا مهام معلّقة. كل شيء مكتمل.';

  @override
  String ccDraft(String a) {
    return '\"$a\" ما زال مسودة ويحتاج مراجعة قبل النشر.';
  }

  @override
  String get ccInviteOne => 'دعوة واحدة بانتظار الرد.';

  @override
  String ccInviteMany(String a) {
    return '$a دعوات بانتظار الرد.';
  }

  @override
  String get ccMembership => 'العضوية والدعوات';

  @override
  String get ccTotalMembers => 'إجمالي الأعضاء';

  @override
  String get ccPendingInvites => 'دعوات معلّقة';

  @override
  String get ccRecent => 'النشاط الإداري الأخير';

  @override
  String get ccExport => 'تصدير التقرير (CSV)';

  @override
  String get ccStatTotal => 'إجمالي الانتخابات';

  @override
  String get ccStatActive => 'نشطة';

  @override
  String get ccStatScheduled => 'مجدولة';

  @override
  String get ccStatClosed => 'مغلقة';

  @override
  String get ccStatMembers => 'الأعضاء';

  @override
  String get ccStatMembersSub => 'جميع أعضاء المؤسسة';

  @override
  String get ccNoActivity => 'لا يوجد نشاط حديث.';

  @override
  String get ccMonitor => 'مراقبة';

  @override
  String get ccTurnoutUnknown => 'نسبة المشاركة المباشرة غير متاحة';

  @override
  String ccTurnout(String a, String b, String c) {
    return 'صوّت $a من $b ($c%)';
  }

  @override
  String get biTemplateTitle => 'اختر قالب الانتخاب';

  @override
  String get biTemplateBody => 'اختر قالبًا جاهزًا لتسريع إنشاء الانتخاب.';

  @override
  String get biT1Name => 'انتخاب المجلس التنفيذي';

  @override
  String get biT1Sub => 'انتخاب مرشحين • اقتراع سري';

  @override
  String get biT1Title => 'انتخاب المجلس التنفيذي';

  @override
  String get biT1Desc =>
      'انتخاب سنوي لاختيار ممثلي المجلس التنفيذي. الاقتراع سري تمامًا.';

  @override
  String get biT2Name => 'التصويت على سياسة / قرار';

  @override
  String get biT2Sub => 'استطلاع نعم/لا • اقتراع سري';

  @override
  String get biT2Title => 'قرار سياسة المؤسسة';

  @override
  String get biT2Desc =>
      'صوّت على التعديل المقترح للائحة المؤسسة. يرجى مراجعة المستندات المرفقة قبل التصويت.';

  @override
  String get biT3Name => 'استطلاع رأي المجتمع';

  @override
  String get biT3Sub => 'استطلاع اختيار واحد • معرّف الهوية';

  @override
  String get biT3Title => 'استبيان آراء المجتمع';

  @override
  String get biT3Desc =>
      'استبيان قصير لجمع آراء المجتمع حول المبادرات القادمة.';

  @override
  String get biLocked =>
      'لم يعد الانتخاب مسودة. لا يمكن تغيير المعلومات الأساسية.';

  @override
  String get biTitle => 'تفاصيل الانتخاب';

  @override
  String get biSubtitle => 'قدّم المعلومات الأساسية عن انتخابك.';

  @override
  String get biUseTemplate => 'استخدام قالب';

  @override
  String get biTitleLabel => 'عنوان الانتخاب *';

  @override
  String get biTitleHint => 'مثلاً اختيار الفريق السنوي';

  @override
  String get biTitleInvalid => 'يجب أن يتراوح العنوان بين 3 و100 حرف.';

  @override
  String get biDescLabel => 'الوصف *';

  @override
  String get biDescHint => 'صف الغرض والسياق والتفاصيل المهمة لهذا الانتخاب...';

  @override
  String get biDescRequired => 'الوصف مطلوب.';

  @override
  String get biDescLong => 'لا يمكن أن يتجاوز الوصف 500 حرف.';

  @override
  String get biVotingType => 'نوع التصويت';

  @override
  String get biTypeCandidate => 'انتخاب مرشحين';

  @override
  String get biTypeCandidateSub => 'يختار الناخبون مرشحًا واحدًا من القائمة.';

  @override
  String get biTypeSingle => 'استطلاع اختيار واحد';

  @override
  String get biTypeSingleSub => 'يختار الناخبون خيارًا واحدًا من القائمة.';

  @override
  String get biTypeYesNo => 'استطلاع نعم/لا';

  @override
  String get biTypeYesNoSub => 'يوافق الناخبون على مقترح أو يرفضونه.';

  @override
  String get biPrivacy => 'خصوصية الاقتراع';

  @override
  String get biAnonymous => 'سري';

  @override
  String get biIdentifiable => 'معرّف الهوية';

  @override
  String get biAnonymousNote => 'تُخزَّن هوية الناخب منفصلة عن الاقتراع.';

  @override
  String get biIdentifiableNote =>
      'يرتبط كل اقتراع بحساب الناخب. سيرى الناخبون هذا التنبيه قبل التأكيد.';

  @override
  String get biNext => 'التالي: الجدول';

  @override
  String get elLocked =>
      'لم يعد الانتخاب مسودة. لا يمكن تغيير إعدادات الأهلية.';

  @override
  String get elTitle => 'أهلية الناخبين';

  @override
  String get elWho => 'من يستطيع التصويت؟';

  @override
  String get elAll => 'جميع الأعضاء النشطين';

  @override
  String get elDepts => 'أقسام محددة';

  @override
  String get elMembers => 'أعضاء محددون';

  @override
  String get elBack => 'رجوع';

  @override
  String get elCreateDraft => 'إنشاء مسودة والمتابعة';

  @override
  String get elNext => 'التالي: الخيارات';

  @override
  String get elListError => 'تعذّر تحميل هذه القائمة. ارجع وحاول مرة أخرى.';

  @override
  String get elNoDepts => 'لم يُعثر على أقسام في هذه المؤسسة.';

  @override
  String get elNoMembers => 'لم يُعثر على أعضاء نشطين.';

  @override
  String elSelected(String a, String b) {
    return '$a محدد من $b أعضاء نشطين';
  }

  @override
  String get elCsv => 'استيراد جماعي من CSV';

  @override
  String get rvPublishTitle => 'نشر هذا الانتخاب؟';

  @override
  String get rvPublishBody =>
      'سيراه الأعضاء المؤهلون وفق الجدول. بعد النشر لا يمكنك تغيير تفاصيله أو جدوله أو أهليته.';

  @override
  String get rvKeepEditing => 'متابعة التحرير';

  @override
  String get rvPublish => 'نشر';

  @override
  String get rvPublished => 'تم نشر الانتخاب.';

  @override
  String get rvReauth =>
      'لأسباب أمنية، يتطلب نشر الانتخاب أن تكون قد سجّلت الدخول خلال آخر 15 دقيقة. يرجى التحقق من هويتك للمتابعة.';

  @override
  String get rvPublishFailed => 'تعذّر نشر الانتخاب. حاول مرة أخرى.';

  @override
  String get rvChoicesError => 'تعذّر تحميل الخيارات. ارجع وحاول مرة أخرى.';

  @override
  String get rvCheckTitle => 'تم تحديد العنوان';

  @override
  String get rvCheckDesc => 'تمت إضافة الوصف';

  @override
  String get rvCheckSchedule => 'تمت جدولة فترة التصويت';

  @override
  String get rvCheckPrivacyId => 'تم تحديد وضع الخصوصية (معرّف الهوية)';

  @override
  String get rvCheckPrivacyAnon => 'تم تحديد وضع الخصوصية (سري)';

  @override
  String rvCheckChoices(String a) {
    return 'تم تحديد المرشحين/الخيارات ($a)';
  }

  @override
  String rvCheckEligibility(String a) {
    return 'قواعد الأهلية صالحة ($a)';
  }

  @override
  String get rvTitle => 'المراجعة والنشر';

  @override
  String get rvChecklist => 'قائمة إعداد الانتخاب';

  @override
  String get rvTitleLabel => 'العنوان';

  @override
  String get rvStart => 'البداية';

  @override
  String get rvEnd => 'النهاية';

  @override
  String get rvChoices => 'الخيارات';

  @override
  String rvItems(String a) {
    return 'تم تحديد $a عناصر';
  }

  @override
  String get rvIncomplete => 'أكمل كل عناصر القائمة المطلوبة أعلاه قبل النشر.';

  @override
  String get rvBack => 'رجوع';

  @override
  String get rvPublishButton => 'نشر الانتخاب';

  @override
  String get rvOptional => ' (اختياري)';

  @override
  String get scRequired => 'وقت البداية والنهاية مطلوبان.';

  @override
  String get scPast => 'لا يمكن أن يكون وقت البداية في الماضي.';

  @override
  String get scShort => 'يجب ألا تقل فترة التصويت عن 5 دقائق.';

  @override
  String get scLocked => 'لم يعد الانتخاب مسودة. لا يمكن تغيير الجدول.';

  @override
  String get scTitle => 'جدول التصويت';

  @override
  String scZoneNote(String a) {
    return 'تُدخَل الأوقات بتوقيت منطقتك: $a. تُقيَّم جميع الأوقات بأمان وفق ساعة الخادم.';
  }

  @override
  String get scStartTime => 'وقت البداية';

  @override
  String get scNotSet => 'غير محدد';

  @override
  String get scEndTime => 'وقت النهاية';

  @override
  String get scBack => 'رجوع';

  @override
  String get scNext => 'التالي: الأهلية';

  @override
  String get obTitle => 'لوحة المراقب';

  @override
  String get obTransparency => 'مركز الثقة والشفافية';

  @override
  String get obLoadError =>
      'تعذّر تحميل هذا العرض. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get obNoOrgTitle => 'لا توجد مؤسسة نشطة';

  @override
  String get obNoOrgBody => 'اختر مؤسسة لعرض لوحة المراقب.';

  @override
  String get obAccessTitle => 'يلزم صلاحية المراقب';

  @override
  String get obAccessBody =>
      'هذه اللوحة متاحة فقط للأعضاء الذين منحهم مسؤول المؤسسة صلاحية المراقب.';

  @override
  String get obNoElectionsTitle => 'لا توجد انتخابات بعد';

  @override
  String get obNoElectionsBody => 'لا توجد انتخابات منشورة في هذه المؤسسة بعد.';

  @override
  String obNote(String a) {
    return 'لديك صلاحية مراقب للقراءة فقط في $a. ترى إجماليات المؤسسة فقط، ولا ترى الأصوات الفردية أو هويات الناخبين أو تفاصيل الأقسام.';
  }

  @override
  String get obActive => 'الانتخابات النشطة';

  @override
  String get obTimeline => 'الجدول الزمني للانتخابات';

  @override
  String get obTurnoutUnknown => 'إجمالي المشاركة غير متاح';

  @override
  String obTurnout(String a, String b, String c) {
    return '$a من $b ناخبين مؤهلين ($c%)';
  }

  @override
  String vpWelcomeNamed(String a) {
    return 'مرحبًا بعودتك، $a';
  }

  @override
  String get vpWelcome => 'مرحبًا بعودتك';

  @override
  String get vpReadyOne => 'انتخاب واحد مفتوح لتصويتك.';

  @override
  String vpReadyMany(String a) {
    return '$a انتخابات مفتوحة لتصويتك.';
  }

  @override
  String get vpAllCaughtUp => 'لا شيء بانتظار تصويتك. أنت على اطلاع بكل شيء.';

  @override
  String get vpYourWorkspace => 'مساحة التصويت الخاصة بك';

  @override
  String get vpOpenFirst => 'الانتقال إلى اقتراعي';

  @override
  String get gsHome => 'الرئيسية';

  @override
  String get gsHomeSub => 'لوحة التحكم';

  @override
  String get gsOrgs => 'المؤسسات';

  @override
  String get gsOrgsSub => 'مساحات عملك';

  @override
  String get gsEvents => 'الانتخابات';

  @override
  String get gsEventsSub => 'إدارة أحداث التصويت';

  @override
  String get gsMembers => 'دليل الأعضاء';

  @override
  String get gsMembersSub => 'تصفّح أعضاء المؤسسة';

  @override
  String get gsDepts => 'الأقسام';

  @override
  String get gsDeptsSub => 'إدارة الأقسام';

  @override
  String get gsAccount => 'إعدادات الحساب';

  @override
  String get gsAccountSub => 'الملف الشخصي والأمان';

  @override
  String get gsAudit => 'سجل التدقيق';

  @override
  String get gsAuditSub => 'نشاط المؤسسة';

  @override
  String get gsInvites => 'الدعوات';

  @override
  String get gsInvitesSub => 'دعوات المؤسسات المعلّقة';

  @override
  String get gsOrganization => 'المؤسسة';

  @override
  String gsVotingEvent(String a) {
    return 'حدث تصويت · $a';
  }

  @override
  String get gsSearchLabel => 'بحث';

  @override
  String get gsSearchHint => 'ابحث في الانتخابات والأعضاء والمؤسسات…';

  @override
  String get gsEsc => 'ESC';

  @override
  String gsNoResults(String a) {
    return 'لا نتائج لـ \"$a\"';
  }

  @override
  String get authTagline => 'تصويت آمن للمؤسسات';

  @override
  String aiWelcome(String a) {
    return 'مرحبًا بك في $a!';
  }

  @override
  String get aiTheOrg => 'المؤسسة';

  @override
  String get alBadge => 'تصويت يراعي الخصوصية';

  @override
  String get alHeadline => 'صوتك،\nاختيارك.';

  @override
  String get alSub => 'تصويت إلكتروني آمن وشفاف\nوحديث للمؤسسات.';

  @override
  String get alP1 => 'تصويت مرخّص من الخادم';

  @override
  String get alP1b => 'تُتحقق الأصوات وتُسجَّل عبر خدمات خلفية موثوقة.';

  @override
  String get alP2 => 'اقتراع يراعي الخصوصية';

  @override
  String get alP2b => 'تُفصل الأصوات السرية عن سجلات المشاركة.';

  @override
  String get alP3 => 'إيصالات مشاركة واضحة';

  @override
  String get alP3b => 'أكّد مشاركتك دون كشف اختيارك.';

  @override
  String get alCopy => 'Kivora © 2026';

  @override
  String get alPlatforms => 'Android • ويب';

  @override
  String get osTitle => 'تبديل المؤسسة';

  @override
  String get osBody => 'اختر مساحة العمل التي تريد العمل فيها.';

  @override
  String get osLoadError => 'تعذّر تحميل مؤسساتك.';

  @override
  String get osRetry => 'حاول مرة أخرى';

  @override
  String get osNone => 'لم يُعثر على مؤسسات منضمّ إليها.';

  @override
  String get osJoin => 'الانضمام إلى مؤسسة برمز';

  @override
  String get osCreate => 'إنشاء مؤسسة جديدة';

  @override
  String get osInvites => 'عرض الدعوات';

  @override
  String get osRetry2 => 'إعادة المحاولة';

  @override
  String get osSelect => 'اختر المؤسسة';

  @override
  String get osCurrentLabel => 'المؤسسة الحالية';

  @override
  String get osCurrent => 'المؤسسة الحالية';

  @override
  String get osSwitchTo => 'التبديل إلى هذه المؤسسة';

  @override
  String get aiMissing => 'رابط الدعوة هذا مفقود أو غير صالح.';

  @override
  String get aiInvited => 'تمت دعوتك';

  @override
  String get aiInvitedBody =>
      'اقبل للانضمام إلى هذه المؤسسة بالبريد الإلكتروني الذي سجّلت به الدخول.';

  @override
  String get aiNotNow => 'ليس الآن';

  @override
  String get aiAccept => 'قبول الدعوة';

  @override
  String get aiAccepting => 'جارٍ قبول الدعوة…';

  @override
  String get aiJoinedBody => 'لقد انضممت بنجاح. يمكنك البدء بالاستكشاف فورًا.';

  @override
  String get aiContinue => 'متابعة';

  @override
  String get aiFailedTitle => 'تعذّر قبول هذه الدعوة';

  @override
  String get aiFailedBody => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get aiHome => 'الانتقال إلى الرئيسية';

  @override
  String get shCalendar => 'تقويم الانتخابات';

  @override
  String get shLight => 'التبديل إلى الوضع الفاتح';

  @override
  String get shDark => 'التبديل إلى الوضع الداكن';

  @override
  String get shSearch => 'بحث';

  @override
  String get shNotifications => 'الإشعارات';

  @override
  String get shMarkRead => 'تعليم الكل كمقروء';

  @override
  String get shNoNotifications => 'لا إشعارات جديدة';

  @override
  String get shOrganization => 'المؤسسة';

  @override
  String shInvitedTo(String a) {
    return 'دعوة للانضمام إلى $a';
  }

  @override
  String shRoleAction(String a) {
    return 'الدور: $a • مطلوب إجراء';
  }

  @override
  String get shViewAll => 'عرض كل الإشعارات';

  @override
  String get shAccountMenu => 'قائمة الحساب';

  @override
  String shAccountRole(String a) {
    return 'حساب $a';
  }

  @override
  String get shAccountUser => 'حساب مستخدم';

  @override
  String get shAccountSettings => 'إعدادات الحساب';

  @override
  String get shHelp => 'المساعدة والدعم';

  @override
  String get shBilling => 'الخطط والفوترة';

  @override
  String get shTrust => 'الثقة والشفافية';

  @override
  String get shPlatformAdmin => 'مسؤول المنصة';

  @override
  String get shOrganizations => 'المؤسسات';

  @override
  String get shLogout => 'تسجيل الخروج';

  @override
  String get hsThanks => 'شكرًا على ملاحظاتك! لقد استلمنا رسالتك.';

  @override
  String get hsFailed =>
      'تعذّر إرسال الملاحظات. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get hsTitle => 'المساعدة والدعم';

  @override
  String get hsFaq => 'الأسئلة الشائعة';

  @override
  String get hsQ1 => 'كيف أدلي بصوتي؟';

  @override
  String get hsA1 =>
      'يمكنك التصويت باختيار انتخاب نشط من لوحة مؤسستك واتباع التعليمات على الشاشة.';

  @override
  String get hsQ2 => 'هل أصواتي سرية؟';

  @override
  String get hsA2 =>
      'في الانتخاب السري لا يُربط اختيارك بحسابك أبدًا - يستطيع النظام تأكيد أنك صوّتت دون تسجيل ما اخترته. تُوسم الانتخابات المعرّفة بوضوح قبل التصويت. راجع مركز الثقة والشفافية لتفاصيل ما يثبته إيصالك وما لا يثبته.';

  @override
  String get hsQ3 => 'كيف أغيّر معلومات ملفي الشخصي؟';

  @override
  String get hsA3 =>
      'انتقل إلى صفحة إعدادات الحساب من قائمة الملف الشخصي أعلى اليمين لتحديث بياناتك.';

  @override
  String get hsGuidance => 'المساعدة والإرشاد';

  @override
  String get hsVerify => 'التحقق من إيصال';

  @override
  String get hsVerifyBody =>
      'تحقق من تسجيل إيصال الاقتراع. هذا لا يكشف أبدًا كيف صوّت أحد.';

  @override
  String get hsTrust => 'الثقة والشفافية';

  @override
  String get hsTrustBody => 'كيف تحمي Kivora خصوصية الاقتراع وما الذي يُسجَّل.';

  @override
  String get hsSend => 'إرسال ملاحظات أو التواصل مع الدعم';

  @override
  String get hsCategory => 'الفئة';

  @override
  String get hsSubject => 'الموضوع';

  @override
  String get hsSubjectHint => 'ما موضوع هذا الطلب؟';

  @override
  String get hsSubjectField => 'الموضوع';

  @override
  String get hsReceipt => 'معرّف الإيصال (اختياري)';

  @override
  String get hsReceiptHint => 'الصق معرّف الإيصال إن كان متعلقًا بتصويت محدد';

  @override
  String get hsReceiptNote =>
      'لا تذكر اختيارك هنا أبدًا - الإيصال يؤكد تسجيل صوتك ولا يكشف ما اخترته.';

  @override
  String get hsMessage => 'الرسالة';

  @override
  String get hsMessageHint => 'يرجى وصف مشكلتك أو مشاركة ملاحظاتك...';

  @override
  String get hsMessageField => 'الرسالة';

  @override
  String get hsSending => 'جارٍ الإرسال...';

  @override
  String get hsSendButton => 'إرسال الرسالة';

  @override
  String get rvfTitle => 'التحقق العام من الإيصال';

  @override
  String get rvfHeading => 'التحقق من إيصال الاقتراع';

  @override
  String get rvfIntro =>
      'أدخل تجزئة الإيصال للتأكد من أن الخادم سجّله. يتحقق هذا من وجود إيصال مطابق فقط. لا يكشف كيف صوّت أحد، ولا يثبت بشكل مستقل الإدراج في الفرز النهائي.';

  @override
  String get rvfHashLabel => 'تجزئة الإيصال';

  @override
  String get rvfHashHint => 'تجزئة من 64 حرفًا (أحرف a-f وأرقام)';

  @override
  String get rvfVerify => 'التحقق من الإيصال';

  @override
  String get rvfOkTitle => 'تم التحقق من الإيصال';

  @override
  String get rvfOkBody =>
      'عُثر على إيصال مطابق، أي أن الخادم سجّل هذا الاقتراع. هذا لا يثبت بشكل مستقل الإدراج في الفرز النهائي.';

  @override
  String get rvfNoTitle => 'لا يوجد إيصال مطابق';

  @override
  String get rvfNoBody =>
      'الخدمة تعمل ولا يوجد إيصال بهذه التجزئة. تأكد من نسخ التجزئة كاملة من إيصالك.';

  @override
  String get rvfBadTitle => 'هذه ليست تجزئة إيصال صالحة';

  @override
  String get rvfBadBody =>
      'تجزئة الإيصال مكوّنة من 64 حرفًا بالضبط: أرقام 0-9 وأحرف a-f. لم يُرسَل شيء إلى الخادم.';

  @override
  String get rvfRateTitle => 'عمليات بحث كثيرة';

  @override
  String get rvfRateBody => 'يرجى الانتظار دقيقة قبل المحاولة مرة أخرى.';

  @override
  String get rvfDownTitle => 'التحقق غير متاح الآن';

  @override
  String get rvfDownBody =>
      'تعذّر الوصول إلى خدمة التحقق، لذا لا يمكننا القول إن كان إيصالك موجودًا. هذه ليست نتيجة \"غير موجود\". تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get rvfRetry => 'حاول مرة أخرى';

  @override
  String get rgDoneTitle => 'تم التسجيل بنجاح';

  @override
  String get rgDoneBody =>
      'تم إنشاء هويتك في Kivora بأمان. يمكنك الآن تسجيل الدخول ببياناتك.';

  @override
  String get rgReturn => 'العودة إلى تسجيل الدخول';

  @override
  String get rgFirstLabel => 'الاسم الأول';

  @override
  String get rgFirstHint => 'الأول';

  @override
  String get rgFirstField => 'الاسم الأول';

  @override
  String get rgLastLabel => 'اسم العائلة';

  @override
  String get rgLastHint => 'الأخير';

  @override
  String get rgLastField => 'اسم العائلة';

  @override
  String get rgEmailLabel => 'عنوان البريد الإلكتروني';

  @override
  String get rgEmailHint => 'user@email.com';

  @override
  String get rgPassword => 'كلمة المرور';

  @override
  String get rgConfirm => 'تأكيد كلمة المرور';

  @override
  String get evYourEmail => 'عنوان بريدك الإلكتروني';

  @override
  String get evOk => 'تم التحقق من البريد الإلكتروني بنجاح!';

  @override
  String get evNot =>
      'لم يتم التحقق من البريد بعد. تحقق من صندوق الوارد وانقر على رابط التحقق.';

  @override
  String evCheckFailed(String a) {
    return 'تعذّر التحقق من حالة التوثيق: $a';
  }

  @override
  String get evResent => 'تم إرسال بريد تحقق جديد. تحقق من صندوق الوارد.';

  @override
  String evResendFailed(String a) {
    return 'تعذّر إعادة إرسال البريد: $a';
  }

  @override
  String get evTitle => 'التحقق من البريد الإلكتروني';

  @override
  String get evSignOut => 'تسجيل الخروج';

  @override
  String get evHeading => 'تحقق من عنوان بريدك الإلكتروني';

  @override
  String evSent(String a) {
    return 'أرسلنا رابط التحقق إلى:\n$a';
  }

  @override
  String get evClick => 'انقر على الرابط في بريدك لفتح كامل صلاحيات المنصة.';

  @override
  String evCooldown(String a) {
    return 'إعادة إرسال البريد خلال $a ث';
  }

  @override
  String get evResend => 'إعادة إرسال بريد التحقق';

  @override
  String get evSwitch => 'تسجيل الخروج / استخدام حساب آخر';

  @override
  String get fpTitle => 'نسيت كلمة المرور؟';

  @override
  String get fpBody =>
      'أدخل عنوان البريد المرتبط بحسابك لتلقي تعليمات إعادة تعيين كلمة المرور.';

  @override
  String get fpSent =>
      'إذا كان هناك حساب بهذا البريد، فقد أُرسل رابط إعادة تعيين كلمة المرور. تحقق من صندوق الوارد.';

  @override
  String get fpEmail => 'عنوان البريد الإلكتروني';

  @override
  String get fpEmailHint => 'user@email.com';

  @override
  String fpCooldown(String a) {
    return 'إعادة إرسال الرابط خلال $a ث';
  }

  @override
  String get fpSend => 'إرسال رابط إعادة التعيين';

  @override
  String get plOpenFailed => 'تعذّر فتح صفحة الدفع.';

  @override
  String get plReauth =>
      'لأسباب أمنية، سجّل الخروج ثم الدخول مجددًا وحاول مرة أخرى.';

  @override
  String get plGeneric => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get plBack => 'رجوع';

  @override
  String get plTitle => 'الخطط والفوترة';

  @override
  String get plNoOrg => 'اختر مؤسسة لعرض خطتها.';

  @override
  String plIntro(String a) {
    return 'تنطبق الخطط على $a. لا يدفع الناخبون أبدًا ولا يُمنعون من التصويت. لا تظهر الإعلانات أبدًا في شاشات الاقتراع أو الإيصال أو التحقق أو الإدارة.';
  }

  @override
  String get plOwnerOnly => 'يمكن لمالك المؤسسة فقط تغيير الخطة.';

  @override
  String get plSoon => 'الترقية عبر الإنترنت قريبًا';

  @override
  String get plOpening => 'جارٍ الفتح…';

  @override
  String get plUpgrade => 'الترقية إلى Pro';

  @override
  String get plManage => 'إدارة الاشتراك أو إلغاؤه';

  @override
  String get plContact => 'التواصل مع المبيعات';

  @override
  String get plCurrent => 'الحالية';

  @override
  String get spLogo => 'شعار Kivora';

  @override
  String get spTag => 'تصويت إلكتروني للمؤسسات متعدد المستأجرين';

  @override
  String get spBadge => 'مرخّص من الخادم ومعزول لكل مستأجر';

  @override
  String get spInit => 'جارٍ تهيئة جلسة آمنة...';

  @override
  String get spErrTitle => 'خطأ في الاتصال';

  @override
  String get spErrBody => 'تعذّر الاتصال بخدمات Kivora.';

  @override
  String get spRetry => 'إعادة محاولة الاتصال';

  @override
  String get sclProfile => 'أكمل ملف المؤسسة';

  @override
  String get sclMembers => 'أضف أعضاء';

  @override
  String get sclDepts => 'أعدّ الأقسام';

  @override
  String get sclFirst => 'أنشئ أول حدث تصويت لك';

  @override
  String get sclTitle => 'جهّز مؤسستك';

  @override
  String get sclDismiss => 'تجاهل';

  @override
  String sclProgress(String a, String b) {
    return 'اكتمل $a من $b';
  }
}
