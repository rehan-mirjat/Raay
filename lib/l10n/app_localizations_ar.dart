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
}
