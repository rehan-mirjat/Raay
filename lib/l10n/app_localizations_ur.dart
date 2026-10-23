// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'کیوورا';

  @override
  String get navHome => 'ہوم';

  @override
  String get navOrganizations => 'تنظیمیں';

  @override
  String get navOrgsShort => 'تنظیمیں';

  @override
  String get navEvents => 'انتخابات';

  @override
  String get navDirectory => 'ڈائریکٹری';

  @override
  String get navDepartments => 'شعبہ جات';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get navCalendar => 'کیلنڈر';

  @override
  String get navCommandCenter => 'کمانڈ سینٹر';

  @override
  String get actionSave => 'محفوظ کریں';

  @override
  String get actionCancel => 'منسوخ کریں';

  @override
  String get actionDelete => 'حذف کریں';

  @override
  String get actionConfirm => 'تصدیق کریں';

  @override
  String get actionBack => 'واپس';

  @override
  String get actionNext => 'اگلا';

  @override
  String get actionClose => 'بند کریں';

  @override
  String get actionRetry => 'دوبارہ کوشش کریں';

  @override
  String get actionSignOut => 'سائن آؤٹ';

  @override
  String get authSignInTitle => 'خوش آمدید';

  @override
  String get authSignInSubtitle => 'جاری رکھنے کے لیے سائن ان کریں';

  @override
  String get authEmail => 'ای میل ایڈریس';

  @override
  String get authPassword => 'پاس ورڈ';

  @override
  String get authForgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get authSignInButton => 'محفوظ طریقے سے سائن ان کریں';

  @override
  String get authContinueWithGoogle => 'گوگل کے ساتھ جاری رکھیں';

  @override
  String get authCreateAccount => 'اکاؤنٹ بنائیں';

  @override
  String get authNoAccount => 'اکاؤنٹ نہیں ہے؟';

  @override
  String get authRegisterTitle => 'اکاؤنٹ بنائیں';

  @override
  String get authRegisterSubtitle => 'آج ہی کیوورا میں شامل ہوں';

  @override
  String get authFullName => 'پورا نام';

  @override
  String get authConfirmPassword => 'پاس ورڈ کی تصدیق کریں';

  @override
  String get voteStepSelect => 'انتخاب کریں';

  @override
  String get voteStepReview => 'جائزہ اور جمع کرائیں';

  @override
  String get voteSelectionPrompt => 'اپنا انتخاب کریں';

  @override
  String get voteReviewBallot => 'بیلٹ کا جائزہ لیں';

  @override
  String get voteReviewYourBallot => 'اپنے بیلٹ کا جائزہ لیں';

  @override
  String get voteYourSelection => 'آپ کا انتخاب';

  @override
  String get voteConfirmAndCast => 'تصدیق کریں اور ووٹ ڈالیں';

  @override
  String get voteSubmitting => 'بیلٹ جمع کیا جا رہا ہے...';

  @override
  String get voteAnonymousExplanation =>
      'یہ بیلٹ خفیہ ہے۔ آپ کا انتخاب کبھی بھی گنتی میں آپ کی شناخت سے منسلک نہیں کیا جائے گا، اور جمع کرانے کے بعد تبدیل نہیں کیا جا سکتا۔';

  @override
  String get voteIdentifiableExplanation =>
      'یہ ایک قابل شناخت بیلٹ ہے۔ آپ کا انتخاب آپ کے اکاؤنٹ کے خلاف ریکارڈ کیا جائے گا اور جمع کرانے کے بعد تبدیل نہیں کیا جا سکتا۔';

  @override
  String get voteAlreadyVotedTitle => 'آپ پہلے ہی ووٹ ڈال چکے ہیں';

  @override
  String voteAlreadyVotedMessage(String eventTitle) {
    return '\"$eventTitle\" کے لیے آپ کا بیلٹ پہلے ہی جمع کرایا جا چکا ہے اور خفیہ گنتی میں شامل کر لیا گیا ہے۔';
  }

  @override
  String get voteViewReceipt => 'اپنی تصدیقی رسید دیکھیں';

  @override
  String get voteViewResults => 'نتائج دیکھیں';

  @override
  String get voteNotOpenYet =>
      'اس انتخاب کے لیے ووٹنگ ابھی شروع نہیں ہوئی۔ آپ نیچے بیلٹ کا جائزہ لے سکتے ہیں، لیکن یہ فعال ہونے تک جمع کرانا غیر فعال ہے۔';

  @override
  String get voteClosed => 'اس انتخاب کے لیے ووٹنگ اب کھلی نہیں ہے۔';

  @override
  String get receiptTitle => 'ووٹ کی رسید';

  @override
  String get receiptId => 'رسید نمبر';

  @override
  String get receiptHash => 'رسید ہیش';

  @override
  String get receiptCopy => 'کاپی کریں';

  @override
  String get receiptReturnHome => 'ہوم فیڈ پر واپس جائیں';

  @override
  String get resultsTitle => 'انتخابی نتائج';

  @override
  String get resultsTotalVotes => 'کل ووٹ';

  @override
  String get resultsVoterTurnout => 'ووٹر ٹرن آؤٹ';

  @override
  String get resultsTurnoutRate => 'ٹرن آؤٹ کی شرح';

  @override
  String get resultsViewDetailed => 'تفصیلی نتائج دیکھیں';

  @override
  String get myElectionsTitle => 'میرے انتخابات';

  @override
  String get myElectionsSubtitle =>
      'آپ کی تمام تنظیموں میں نظر آنے والے تمام انتخابات، ایک ہی جگہ پر۔';

  @override
  String get filterAll => 'تمام';

  @override
  String get filterActive => 'فعال';

  @override
  String get filterUpcoming => 'آئندہ';

  @override
  String get filterCompleted => 'مکمل شدہ';

  @override
  String get filterParticipated => 'شرکت کی';

  @override
  String get filterResultsAvailable => 'نتائج دستیاب ہیں';

  @override
  String get calendarTitle => 'انتخابی کیلنڈر';

  @override
  String get calendarAddToCalendar => 'کیلنڈر میں شامل کریں';

  @override
  String get emptyGenericTitle => 'ابھی یہاں کچھ نہیں ہے';

  @override
  String get emptyGenericMessage => 'فی الحال دکھانے کے لیے کچھ نہیں ہے۔';

  @override
  String get errorGenericMessage =>
      'کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get loadingGeneric => 'لوڈ ہو رہا ہے...';

  @override
  String get accessibilitySettingsTitle => 'رسائی اور زبان';

  @override
  String get accessibilityLanguage => 'زبان';

  @override
  String get accessibilityLanguageSystem => 'سسٹم ڈیفالٹ';

  @override
  String get accessibilityReducedMotion => 'حرکت کم کریں';

  @override
  String get accessibilityReducedMotionSubtitle =>
      'پوری ایپ میں اینیمیشنز کو کم سے کم کریں۔';

  @override
  String get accessibilityHighContrast => 'ہائی کنٹراسٹ';

  @override
  String get accessibilityHighContrastSubtitle =>
      'بہتر مرئیت کے لیے متن اور بارڈر کا کنٹراسٹ بڑھائیں۔';

  @override
  String get helpSupportTitle => 'مدد اور معاونت';

  @override
  String get notificationsTitle => 'اطلاعات';

  @override
  String get transparencyTitle => 'اعتماد اور شفافیت مرکز';

  @override
  String get observerDashboardTitle => 'مبصر ڈیش بورڈ';

  @override
  String get voterHomeTitle => 'میرے انتخابات';

  @override
  String get voterHomeSubtitle =>
      'آپ کی تنظیموں میں وہ انتخابات جو آپ دیکھ سکتے ہیں۔';

  @override
  String get voterSearchHint => 'انتخاب یا تنظیم کے نام سے تلاش کریں';

  @override
  String get voterFilterAll => 'سب';

  @override
  String get voterFilterReady => 'ووٹ دینے کے لیے تیار';

  @override
  String get voterFilterUpcoming => 'آنے والے';

  @override
  String get voterFilterParticipated => 'حصہ لیا';

  @override
  String get voterFilterClosed => 'بند';

  @override
  String get voterFilterResults => 'نتائج شائع شدہ';

  @override
  String get voterSectionReady => 'ووٹ دینے کے لیے تیار';

  @override
  String get voterSectionUpcoming => 'آنے والے';

  @override
  String get voterSectionParticipated => 'حصہ لیا';

  @override
  String get voterSectionOther => 'دیگر انتخابات';

  @override
  String get voterNoElectionsTitle => 'ابھی کوئی انتخاب نہیں';

  @override
  String get voterNoElectionsBody =>
      'جن انتخابات کے لیے آپ اہل ہیں وہ یہاں نظر آئیں گے۔';

  @override
  String get voterNoMatchTitle => 'کوئی مطابقت رکھنے والا انتخاب نہیں';

  @override
  String get voterNoMatchBody => 'کوئی اور تلاش یا فلٹر آزمائیں۔';

  @override
  String get voterLoadError => 'ہم آپ کے انتخابات لوڈ نہیں کر سکے۔';

  @override
  String get voterRetry => 'دوبارہ کوشش کریں';

  @override
  String get voterStatusWarning =>
      'کچھ تفصیلات لوڈ نہیں ہو سکیں۔ ان پر منحصر اقدامات لوڈ ہونے تک چھپے رہیں گے۔';

  @override
  String get voterActionVoteNow => 'ابھی ووٹ دیں';

  @override
  String get voterActionViewReceipt => 'رسید دیکھیں';

  @override
  String get voterActionViewDetails => 'تفصیلات دیکھیں';

  @override
  String get voterActionChecking => 'آپ کی صورتحال جانچی جا رہی ہے...';

  @override
  String get voterActionResultsPending => 'نتائج کا انتظار';

  @override
  String get voterActionViewResults => 'شائع شدہ نتائج دیکھیں';

  @override
  String get voterChipParticipated => 'حصہ لیا';

  @override
  String get voterChipNotEligible => 'اہل نہیں';

  @override
  String get voterChipChecking => 'صورتحال جانچی جا رہی ہے';

  @override
  String voterOpens(String date) {
    return '$date کو کھلے گا';
  }

  @override
  String voterCloses(String date) {
    return '$date کو بند ہوگا';
  }

  @override
  String voterClosedOn(String date) {
    return '$date کو بند ہوا';
  }

  @override
  String get voterCalendar => 'کیلنڈر';

  @override
  String get voterLoadMore => 'مزید دکھائیں';

  @override
  String get builderLeaveTitle => 'بغیر محفوظ کیے چھوڑ دیں؟';

  @override
  String get builderLeaveBody =>
      'آپ کی کچھ تبدیلیاں اس مسودے میں محفوظ نہیں ہوئیں۔ ابھی چھوڑنے پر وہ ضائع ہو جائیں گی۔';

  @override
  String get builderStay => 'ترمیم جاری رکھیں';

  @override
  String get builderLeave => 'چھوڑیں اور تبدیلیاں ضائع کریں';

  @override
  String get navMyElections => 'میرے انتخابات';

  @override
  String get navOverview => 'جائزہ';

  @override
  String get navPeople => 'افراد';

  @override
  String get navActivity => 'سرگرمی';

  @override
  String get navBilling => 'بلنگ';

  @override
  String get navOrgSettings => 'تنظیم کی ترتیبات';

  @override
  String get navAccount => 'اکاؤنٹ';

  @override
  String get navHelp => 'مدد';

  @override
  String get navMore => 'مزید';

  @override
  String get navObserver => 'مبصر';

  @override
  String get navPlatform => 'پلیٹ فارم';

  @override
  String get navCreateElection => 'انتخاب بنائیں';

  @override
  String get navMainLabel => 'مرکزی نیویگیشن';

  @override
  String get navMoreSectionLabel => 'مزید';

  @override
  String get navPlatformSectionLabel => 'پلیٹ فارم';

  @override
  String get adminEventsTitle => 'انتخابات';

  @override
  String get adminEventsSubtitle =>
      'اپنی تنظیم کے لیے انتخابات بنائیں، شیڈول کریں اور نگرانی کریں۔';

  @override
  String get adminCreateElection => 'انتخاب بنائیں';

  @override
  String get adminCommandCenter => 'کمانڈ سینٹر';

  @override
  String get adminSearchEvents => 'انتخابات تلاش کریں';

  @override
  String get adminFilterAll => 'سب';

  @override
  String get adminFilterActive => 'فعال';

  @override
  String get adminFilterScheduled => 'شیڈول شدہ';

  @override
  String get adminFilterDraft => 'مسودہ';

  @override
  String get adminFilterClosed => 'بند';

  @override
  String get adminFilterArchived => 'محفوظ شدہ';

  @override
  String get adminNoEventsTitle => 'ابھی کوئی انتخاب نہیں';

  @override
  String get adminNoEventsBody =>
      'اپنا پہلا انتخاب بنائیں۔ آپ اسے مسودے کے طور پر محفوظ کر کے تیار ہونے پر شائع کر سکتے ہیں۔';

  @override
  String get adminNoMatch =>
      'آپ کی تلاش یا فلٹر سے کوئی انتخاب مطابقت نہیں رکھتا۔';

  @override
  String get adminLoadError =>
      'ہم آپ کے انتخابات لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get adminOrgRequiredTitle => 'کوئی فعال تنظیم نہیں';

  @override
  String get adminOrgRequiredBody =>
      'انتخابات کا انتظام کرنے کے لیے کوئی تنظیم منتخب کریں۔';

  @override
  String get adminSuspendedTitle => 'تنظیم معطل ہے';

  @override
  String get adminSuspendedBody =>
      'یہ تنظیم معطل ہے، اس لیے انتخابات کا انتظام بند ہے۔';

  @override
  String get adminProcessing => 'انتخاب اپ ڈیٹ ہو رہا ہے...';

  @override
  String adminEventRange(String start, String end) {
    return '$start سے $end تک';
  }

  @override
  String get adminTypeCandidate => 'امیدواروں کا انتخاب';

  @override
  String get adminTypeSingle => 'ایک انتخابی رائے شماری';

  @override
  String get adminTypeYesNo => 'ہاں/نہیں رائے شماری';

  @override
  String get adminActionDelete => 'مسودہ حذف کریں';

  @override
  String get adminActionManageChoices => 'انتخابات کا نظم کریں';

  @override
  String get adminActionEdit => 'تفصیلات میں ترمیم';

  @override
  String get adminActionPublish => 'جائزہ لیں اور شائع کریں';

  @override
  String get adminActionCancel => 'انتخاب منسوخ کریں';

  @override
  String get adminActionViewDetails => 'تفصیلات دیکھیں';

  @override
  String get adminActionCloseEarly => 'جلد بند کریں';

  @override
  String get adminActionMonitor => 'ووٹنگ کی شرح کی نگرانی';

  @override
  String get adminActionResults => 'نتائج دیکھیں';

  @override
  String get adminDeleteTitle => 'یہ مسودہ حذف کریں؟';

  @override
  String adminDeleteBody(String title) {
    return '\"$title\" ہمیشہ کے لیے حذف ہو جائے گا۔ اسے واپس نہیں کیا جا سکتا۔';
  }

  @override
  String get adminCancelTitle => 'یہ انتخاب منسوخ کریں؟';

  @override
  String adminCancelBody(String title) {
    return '\"$title\" ووٹنگ کے لیے نہیں کھلے گا۔ ووٹرز اسے آنے والے انتخاب کے طور پر نہیں دیکھیں گے۔';
  }

  @override
  String get adminCloseTitle => 'ابھی ووٹنگ بند کریں؟';

  @override
  String adminCloseBody(String title) {
    return '\"$title\" فوراً ووٹ قبول کرنا بند کر دے گا۔ اسے واپس نہیں کیا جا سکتا۔';
  }

  @override
  String get adminKeep => 'رہنے دیں';

  @override
  String get adminConfirmDelete => 'مسودہ حذف کریں';

  @override
  String get adminConfirmCancel => 'انتخاب منسوخ کریں';

  @override
  String get adminConfirmClose => 'ووٹنگ بند کریں';

  @override
  String get adminGuideTitle1 => 'ترتیب دیں';

  @override
  String get adminGuideBody1 => 'تفصیلات، شیڈول اور ووٹ دینے کے اہل افراد۔';

  @override
  String get adminGuideTitle2 => 'انتخابات شامل کریں';

  @override
  String get adminGuideBody2 => 'امیدوار یا رائے شماری کے آپشنز۔';

  @override
  String get adminGuideTitle3 => 'شائع کریں';

  @override
  String get adminGuideBody3 => 'جائزہ لیں، پھر ووٹرز کے لیے کھولیں۔';

  @override
  String get adminGuideTitle4 => 'نگرانی کریں';

  @override
  String get adminGuideBody4 => 'ووٹنگ کے دوران شرکت کی شرح، بعد میں نتائج۔';

  @override
  String get builderCreateTitle => 'انتخاب بنائیں';

  @override
  String get builderEditTitle => 'انتخاب کے مسودے میں ترمیم';

  @override
  String get builderBack => 'واپس';

  @override
  String builderStepOf(int current, int total) {
    return 'مرحلہ $current از $total';
  }

  @override
  String get builderStepBasic => 'تفصیلات';

  @override
  String get builderStepSchedule => 'شیڈول';

  @override
  String get builderStepEligibility => 'اہلیت';

  @override
  String get builderStepChoices => 'انتخابات';

  @override
  String get builderStepReview => 'جائزہ';

  @override
  String get builderStepsLabel => 'انتخاب کی ترتیب کے مراحل';

  @override
  String get builderDraftNeeded =>
      'پہلے مسودہ محفوظ کریں۔ پچھلے مراحل مکمل کریں، پھر آگے بڑھیں۔';

  @override
  String get builderCreateDraftNow => 'مسودہ ابھی محفوظ کریں';

  @override
  String get builderCreateDraftFailed =>
      'مسودہ محفوظ نہیں ہو سکا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get builderStepBlocked =>
      'آگے بڑھنے سے پہلے ہر مرحلہ اس کے ’جاری رکھیں‘ بٹن سے مکمل کریں۔';

  @override
  String get builderLoadingDraft => 'انتخاب کا مسودہ لوڈ ہو رہا ہے...';

  @override
  String get builderAdminsOnly =>
      'صرف تنظیم کے منتظمین انتخابات بنا یا ان میں ترمیم کر سکتے ہیں۔';

  @override
  String get builderReturnHome => 'ہوم پر واپس';

  @override
  String get overviewSubtitle =>
      'آپ کی تنظیم میں کیا توجہ چاہتا ہے اور کیا ہو رہا ہے۔';

  @override
  String get overviewRequiredTitle => 'آپ کی توجہ درکار ہے';

  @override
  String overviewFinishDrafts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مسودہ انتخابات شائع نہیں ہوئے',
      one: '1 مسودہ انتخاب شائع نہیں ہوا',
    );
    return '$_temp0';
  }

  @override
  String overviewReviewInvites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دعوتیں جواب کی منتظر ہیں',
      one: '1 دعوت جواب کی منتظر ہے',
    );
    return '$_temp0';
  }

  @override
  String get overviewOpenElections => 'انتخابات کھولیں';

  @override
  String get overviewOpenPeople => 'افراد کھولیں';

  @override
  String get overviewMetricMembers => 'اراکین';

  @override
  String get overviewMetricDepartments => 'شعبے';

  @override
  String get overviewMetricLive => 'جاری انتخابات';

  @override
  String get overviewMetricUpcoming => 'آنے والے انتخابات';

  @override
  String get overviewMetricInvites => 'زیر التوا دعوتیں';

  @override
  String get overviewUnavailable => 'دستیاب نہیں';

  @override
  String get overviewLoading => 'لوڈ ہو رہا ہے';

  @override
  String get overviewElectionsTitle => 'جاری اور آنے والے انتخابات';

  @override
  String get overviewViewAll => 'سب دیکھیں';

  @override
  String get overviewNoLive => 'کوئی جاری یا آنے والا انتخاب نہیں۔';

  @override
  String get overviewNoLiveBody => 'شروع کرنے کے لیے ایک انتخاب بنائیں۔';

  @override
  String get overviewElectionsError => 'ہم انتخابات لوڈ نہیں کر سکے۔';

  @override
  String get overviewRetry => 'دوبارہ کوشش کریں';

  @override
  String get overviewActivityTitle => 'حالیہ سرگرمی';

  @override
  String get overviewNoActivity => 'ابھی کوئی حالیہ سرگرمی نہیں۔';

  @override
  String get overviewActivityError => 'حالیہ سرگرمی دستیاب نہیں۔';

  @override
  String get overviewActivityUnknown => 'منتظم کی کارروائی';

  @override
  String get overviewShortcuts => 'شارٹ کٹس';

  @override
  String get overviewShortcutPeople => 'افراد';

  @override
  String get overviewShortcutDepartments => 'شعبے';

  @override
  String get overviewShortcutCodes => 'شمولیت کے کوڈ';

  @override
  String get overviewShortcutInvites => 'دعوتیں';

  @override
  String get overviewShortcutCommand => 'کمانڈ سینٹر';

  @override
  String get overviewShortcutSettings => 'تنظیم کی ترتیبات';

  @override
  String get overviewShortcutBilling => 'پلانز اور بلنگ';

  @override
  String get overviewAgoNow => 'ابھی ابھی';

  @override
  String overviewAgoMinutes(int n) {
    return '$n منٹ پہلے';
  }

  @override
  String overviewAgoHours(int n) {
    return '$n گھنٹے پہلے';
  }

  @override
  String overviewAgoDays(int n) {
    return '$n دن پہلے';
  }

  @override
  String overviewAgoWeeks(int n) {
    return '$n ہفتے پہلے';
  }

  @override
  String overviewRole(String role) {
    return 'آپ کا کردار: $role';
  }

  @override
  String get overviewLoadError =>
      'ہم آپ کی تنظیم لوڈ نہیں کر سکے۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get orgsTitle => 'تنظیمیں';

  @override
  String get orgsSubtitle =>
      'ورک اسپیس تبدیل کریں، کسی اور تنظیم میں شامل ہوں یا اپنی تنظیم بنائیں۔';

  @override
  String get orgsCreate => 'بنائیں';

  @override
  String get orgsJoin => 'کوڈ سے شامل ہوں';

  @override
  String get orgsScan => 'شامل ہونے کے لیے QR اسکین کریں';

  @override
  String get orgsInvitations => 'دعوتیں';

  @override
  String get orgsEmptyTitle => 'ابھی کوئی تنظیم نہیں';

  @override
  String get orgsEmptyBody =>
      'کوڈ یا دعوت کے ذریعے کسی موجودہ تنظیم میں شامل ہوں، یا انتخابات چلانے کے لیے نئی تنظیم بنائیں۔';

  @override
  String get orgsCreateFull => 'تنظیم بنائیں';

  @override
  String get orgsJoinFull => 'کوڈ سے شامل ہوں';

  @override
  String get orgsOpen => 'ورک اسپیس کھولیں';

  @override
  String get orgsCurrent => 'موجودہ ورک اسپیس';

  @override
  String get orgsLoadError =>
      'ہم آپ کی تنظیمیں لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get orgsRetry => 'دوبارہ کوشش کریں';

  @override
  String get orgsStatusPending => 'جائزہ زیر التوا';

  @override
  String get orgsStatusSuspended => 'معطل';

  @override
  String get orgsStatusRejected => 'مسترد';

  @override
  String orgsRoleLine(String role) {
    return 'آپ کا کردار: $role';
  }

  @override
  String get peopleTitle => 'افراد';

  @override
  String get peopleSubtitle => 'اراکین، کردار اور دعوتوں کا نظم کریں۔';

  @override
  String get peopleAddExisting => 'موجودہ صارف شامل کریں';

  @override
  String get peopleInvite => 'رکن کو مدعو کریں';

  @override
  String get peopleSearchHint => 'نام یا ای میل سے تلاش کریں';

  @override
  String get peopleSearchClear => 'تلاش صاف کریں';

  @override
  String get peopleFilterAll => 'سب';

  @override
  String get peopleFilterManagers => 'مالکان اور منتظمین';

  @override
  String get peopleFilterMembers => 'اراکین';

  @override
  String get peopleFilterNotActive => 'غیر فعال';

  @override
  String get peopleNoMembersTitle => 'ابھی کوئی رکن نہیں';

  @override
  String get peopleNoMembersBody =>
      'موجودہ صارفین کو شامل کریں یا لوگوں کو اپنی تنظیم میں مدعو کریں۔';

  @override
  String get peopleNoMatchTitle => 'کوئی مطابقت نہیں';

  @override
  String get peopleNoMatchBody =>
      'آپ کی تلاش یا فلٹر سے کوئی مطابقت نہیں رکھتا۔';

  @override
  String get peopleLoadError =>
      'ہم اراکین کی فہرست لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get peopleRetry => 'دوبارہ کوشش کریں';

  @override
  String get peopleRestricted => 'رسائی محدود ہے';

  @override
  String get peopleRestrictedBody =>
      'اراکین کی فہرست صرف تنظیم کے منتظمین دیکھ سکتے ہیں۔';

  @override
  String get peopleNoOrgTitle => 'کوئی فعال تنظیم نہیں';

  @override
  String get peopleNoOrgBody => 'افراد دیکھنے کے لیے کوئی تنظیم منتخب کریں۔';

  @override
  String get peopleUnknownUser => 'نامعلوم صارف';

  @override
  String peopleCount(int shown, int total) {
    return '$total میں سے $shown افراد';
  }

  @override
  String get invTitle => 'زیر التوا دعوتیں';

  @override
  String get invRefresh => 'دعوتیں تازہ کریں';

  @override
  String get invLoadError => 'ہم زیر التوا دعوتیں لوڈ نہیں کر سکے۔';

  @override
  String get invTryAgain => 'دوبارہ کوشش کریں';

  @override
  String get invNone => 'کوئی زیر التوا دعوت نہیں۔';

  @override
  String get invExpired => 'میعاد ختم';

  @override
  String get invExpiringSoon => 'جلد ختم ہونے والی';

  @override
  String invExpiresDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n دنوں میں ختم ہوگی',
      one: '1 دن میں ختم ہوگی',
    );
    return '$_temp0';
  }

  @override
  String invExpiresHours(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n گھنٹوں میں ختم ہوگی',
      one: '1 گھنٹے میں ختم ہوگی',
    );
    return '$_temp0';
  }

  @override
  String invExpiresMinutes(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n منٹ میں ختم ہوگی',
      one: '1 منٹ میں ختم ہوگی',
    );
    return '$_temp0';
  }

  @override
  String get invRevoke => 'منسوخ کریں';

  @override
  String get invRemove => 'ہٹائیں';

  @override
  String get invKeep => 'رہنے دیں';

  @override
  String get invRevokeTitle => 'یہ دعوت منسوخ کریں؟';

  @override
  String invRevokeBody(String who) {
    return '$who اب اسے قبول نہیں کر سکیں گے۔ آپ انہیں بعد میں دوبارہ مدعو کر سکتے ہیں۔';
  }

  @override
  String get invRecipient => 'وصول کنندہ';

  @override
  String get invRevoked => 'دعوت منسوخ کر دی گئی۔';

  @override
  String get invRevokeFailed =>
      'دعوت منسوخ نہیں ہو سکی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get invOwnerOnly => 'منتظم کی دعوتیں صرف مالک منسوخ کر سکتا ہے';

  @override
  String get deptTitle => 'شعبے';

  @override
  String get deptSubtitle =>
      'اراکین کو شعبوں میں گروپ کریں تاکہ انتخاب میں ووٹ دینے والوں کو محدود کیا جا سکے۔';

  @override
  String get deptNew => 'نیا شعبہ';

  @override
  String get deptSearchHint => 'شعبے تلاش کریں';

  @override
  String get deptSortName => 'نام الف سے یے';

  @override
  String get deptSortNameDesc => 'نام یے سے الف';

  @override
  String get deptSortMembers => 'سب سے زیادہ اراکین';

  @override
  String get deptSortLabel => 'ترتیب';

  @override
  String get deptNoOrgTitle => 'کوئی تنظیم منتخب کریں';

  @override
  String get deptNoOrgBody =>
      'شعبے کسی تنظیم سے تعلق رکھتے ہیں۔ اس کے شعبے دیکھنے کے لیے ایک تنظیم منتخب کریں۔';

  @override
  String get deptNoOrgAction => 'ہوم پر جائیں';

  @override
  String get deptEmptyManagerTitle => 'ابھی کوئی شعبہ نہیں';

  @override
  String get deptEmptyManagerBody =>
      'اراکین کو منظم کرنے اور ووٹ دینے والوں کو محدود کرنے کے لیے شعبے بنائیں۔';

  @override
  String get deptEmptyMemberTitle => 'کوئی شعبہ تفویض نہیں';

  @override
  String get deptEmptyMemberBody =>
      'آپ کو اس تنظیم میں کسی شعبے میں مقرر نہیں کیا گیا۔';

  @override
  String get deptNoMatch => 'آپ کی تلاش سے کوئی شعبہ مطابقت نہیں رکھتا۔';

  @override
  String get deptLoadError =>
      'ہم شعبے لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get deptRetry => 'دوبارہ کوشش کریں';

  @override
  String get deptMembersUnknown => 'اراکین: دستیاب نہیں';

  @override
  String get deptEventsNone => 'ابھی کسی انتخاب میں استعمال نہیں ہوا';

  @override
  String get deptManageMembers => 'اراکین کا نظم کریں';

  @override
  String get deptActions => 'شعبے کے اقدامات';

  @override
  String get deptEdit => 'تفصیلات میں ترمیم';

  @override
  String get deptDelete => 'شعبہ حذف کریں';

  @override
  String get deptDeleteTitle => 'شعبہ حذف کریں؟';

  @override
  String deptDeleteBody(String name) {
    return '\"$name\" ہمیشہ کے لیے حذف ہو جائے گا۔ اراکین کا ریکارڈ برقرار رہے گا، لیکن یہ شعبہ اب تفویض یا ووٹر کی اہلیت کے لیے استعمال نہیں ہو سکے گا۔';
  }

  @override
  String get deptDeleteConfirm => 'شعبہ حذف کریں';

  @override
  String get deptKeep => 'رہنے دیں';

  @override
  String get deptDeleted => 'شعبہ حذف کر دیا گیا۔';

  @override
  String get deptDeleteFailed =>
      'شعبہ حذف نہیں ہو سکا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get deptCreateHint => 'اپنے اراکین کے لیے ایک گروپ بنائیں';

  @override
  String deptCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n شعبے',
      one: '1 شعبہ',
    );
    return '$_temp0';
  }

  @override
  String deptMemberCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n اراکین',
      one: '1 رکن',
    );
    return '$_temp0';
  }

  @override
  String deptUsedIn(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n انتخابات میں استعمال ہوا',
      one: '1 انتخاب میں استعمال ہوا',
    );
    return '$_temp0';
  }

  @override
  String get inbTitle => 'دعوتیں';

  @override
  String get inbSubtitle =>
      'کسی تنظیم میں شمولیت کی دعوتوں کا جائزہ لیں اور جواب کا انتخاب کریں۔';

  @override
  String inbPending(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n زیر التوا دعوتیں',
      one: '1 زیر التوا دعوت',
    );
    return '$_temp0';
  }

  @override
  String get inbEmptyTitle => 'سب کچھ دیکھ لیا گیا';

  @override
  String get inbEmptyBody =>
      'تنظیم کی دعوتیں یہاں نظر آئیں گی۔ آپ ہر ایک کو قبول یا مسترد کر سکتے ہیں۔';

  @override
  String get inbLoadError =>
      'ہم آپ کی دعوتیں لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get inbRetry => 'دوبارہ کوشش کریں';

  @override
  String get inbAccept => 'دعوت قبول کریں';

  @override
  String get inbDecline => 'مسترد کریں';

  @override
  String get inbAcceptExpired => 'دعوت کی میعاد ختم';

  @override
  String get inbRole => 'کردار';

  @override
  String inbExpires(String date) {
    return '$date کو ختم ہوگی';
  }

  @override
  String get inbExpired => 'میعاد ختم';

  @override
  String get inbNoExpiry => 'کوئی میعاد نہیں';

  @override
  String get inbDefaultOrg => 'تنظیم';

  @override
  String inbJoinLine(String org, String role) {
    return '$org میں $role کے طور پر شامل ہوں';
  }

  @override
  String inbAcceptNote(String org) {
    return 'قبول کرنے سے $org آپ کی تنظیموں میں شامل ہو جائے گی۔ آپ کسی بھی وقت ورک اسپیس تبدیل کر سکتے ہیں۔';
  }

  @override
  String get inbDeclineTitle => 'یہ دعوت مسترد کریں؟';

  @override
  String inbDeclineBody(String org) {
    return 'آپ $org میں شامل نہیں ہوں گے۔ منتظم آپ کو بعد میں دوبارہ مدعو کر سکتا ہے۔';
  }

  @override
  String get inbKeep => 'دعوت رہنے دیں';

  @override
  String get inbDeclineConfirm => 'مسترد کریں';

  @override
  String inbJoined(String org) {
    return 'آپ $org میں شامل ہو گئے۔';
  }

  @override
  String get inbDeclined => 'دعوت مسترد کر دی گئی۔';

  @override
  String get inbRespondFailed =>
      'ہم یہ مکمل نہیں کر سکے۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get inbHelp =>
      'دعوت کے بارے میں مدد چاہیے؟ Kivora سپورٹ سے رابطہ کریں۔';

  @override
  String get ballotTitle => 'آپ کا بیلٹ';

  @override
  String get ballotSelectFirst => 'آگے بڑھنے سے پہلے کوئی آپشن منتخب کریں۔';

  @override
  String get ballotLoadError =>
      'ہم یہ بیلٹ لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get ballotRetry => 'دوبارہ کوشش کریں';

  @override
  String get ballotNotFound => 'یہ انتخاب نہیں ملا۔';

  @override
  String get ballotSignIn => 'ووٹ دینے کے لیے سائن اِن کریں۔';

  @override
  String get ballotNoCandidates =>
      'اس انتخاب میں ابھی کوئی امیدوار شامل نہیں کیا گیا۔';

  @override
  String get ballotNoOptions =>
      'اس انتخاب میں ابھی کوئی آپشن شامل نہیں کیا گیا۔';

  @override
  String get ballotOptionsLoadError =>
      'ہم آپشنز لوڈ نہیں کر سکے۔ دوبارہ کوشش کریں۔';

  @override
  String get ballotYes => 'ہاں';

  @override
  String get ballotYesDesc => 'اس تجویز کے حق میں';

  @override
  String get ballotNo => 'نہیں';

  @override
  String get ballotNoDesc => 'اس تجویز کی مخالفت میں';

  @override
  String get ballotOfficial => 'سرکاری بیلٹ';

  @override
  String get ballotFinality =>
      'آپ کا ووٹ حتمی ہے۔ تصدیق کے بعد آپ اسے تبدیل نہیں کر سکتے اور نہ دوبارہ ووٹ دے سکتے ہیں۔';

  @override
  String ballotTimeDays(int n) {
    return '$n دن باقی';
  }

  @override
  String ballotTimeHours(int n) {
    return '$n گھنٹے باقی';
  }

  @override
  String ballotTimeMinutes(int n) {
    return '$n منٹ باقی';
  }

  @override
  String get ballotTimeSoon => 'جلد بند ہوگا';

  @override
  String get ballotTimeClosed => 'ووٹنگ بند';

  @override
  String ballotCandidate(String name) {
    return '$name، امیدوار';
  }

  @override
  String ballotOption(String name) {
    return '$name، آپشن';
  }

  @override
  String get ballotSelectedSuffix => 'منتخب';

  @override
  String get ballotReceiptMissing =>
      'ہمیں آپ کی رسید ابھی نہیں ملی۔ تھوڑی دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get ballotYourChoice => 'آپ کا انتخاب';

  @override
  String ballotStepsLabel(int current, int total, String label) {
    return '$total میں سے $current: $label';
  }

  @override
  String get receiptSuccess => 'آپ کا بیلٹ درج ہو گیا';

  @override
  String get receiptSecrecy =>
      'یہ رسید تصدیق کرتی ہے کہ آپ کا بیلٹ قبول ہوا۔ یہ ظاہر نہیں کرتی اور نہ ہی اس میں شامل ہے کہ آپ نے کیا چنا، اور یہ کسی کو آپ کا انتخاب ثابت نہیں کر سکتی۔';

  @override
  String get receiptKeep =>
      'اپنی رسید کی آئی ڈی محفوظ رکھیں۔ آپ بعد میں اس سے جانچ سکتے ہیں کہ آپ کا بیلٹ درج ہوا۔';

  @override
  String get receiptDetails => 'رسید کی تفصیلات';

  @override
  String get receiptTime => 'جمع کرایا گیا';

  @override
  String get receiptTechnical => 'تکنیکی تفصیلات';

  @override
  String get receiptHashLabel => 'تصدیقی ہیش (SHA-256)';

  @override
  String receiptCopyLabel(String label) {
    return '$label کاپی کریں';
  }

  @override
  String receiptCopied(String label) {
    return '$label کاپی ہو گیا';
  }

  @override
  String get receiptVerify => 'رسید کی تصدیق کریں';

  @override
  String get receiptClose => 'بند کریں';

  @override
  String get evBack => 'انتخابات پر واپس';

  @override
  String get evLoadError =>
      'ہم یہ انتخاب لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get evRetry => 'دوبارہ کوشش کریں';

  @override
  String get evNotFoundTitle => 'انتخاب نہیں ملا';

  @override
  String get evNotFoundBody => 'یہ انتخاب موجود نہیں یا ہٹا دیا گیا ہے۔';

  @override
  String get evSignInTitle => 'سائن اِن ضروری ہے';

  @override
  String get evSignInBody => 'یہ انتخاب دیکھنے کے لیے سائن اِن کریں۔';

  @override
  String get evStatusLoadError =>
      'ہم جانچ نہیں سکے کہ آپ ووٹ دے چکے ہیں یا نہیں۔ ووٹ دینے سے پہلے دوبارہ کوشش کریں۔';

  @override
  String get evVotedTitle => 'آپ نے اس انتخاب میں ووٹ دیا';

  @override
  String get evVotedBody => 'آپ کی شرکت درج کر لی گئی۔';

  @override
  String get evVotedNote =>
      'ہر رکن ایک ہی بار ووٹ دے سکتا ہے، اس لیے دوبارہ ووٹ دینا ممکن نہیں۔ بعد میں جانچنے کے لیے اپنی رسید کی آئی ڈی محفوظ رکھیں۔';

  @override
  String get evViewReceipt => 'اپنی رسید دیکھیں';

  @override
  String get evReceiptMissing =>
      'ہمیں آپ کی رسید ابھی نہیں ملی۔ تھوڑی دیر بعد دوبارہ کوشش کریں۔';

  @override
  String get evProceed => 'بیلٹ پر جائیں';

  @override
  String evNotAccepting(String status) {
    return 'یہ انتخاب $status ہے اور ووٹ قبول نہیں کر رہا۔';
  }

  @override
  String get evResultsPublishedTitle => 'نتائج شائع ہو چکے ہیں';

  @override
  String evResultsPublishedBody(String date) {
    return 'ووٹنگ $date کو بند ہوئی۔';
  }

  @override
  String get evResultsPendingTitle => 'نتائج ابھی شائع نہیں ہوئے';

  @override
  String evResultsPendingBody(String date) {
    return 'ووٹنگ $date کو بند ہوئی۔ تنظیم کے شائع کرنے پر نتائج یہاں نظر آئیں گے۔';
  }

  @override
  String get evResultsUnknownTitle => 'نتائج کی صورتحال دستیاب نہیں';

  @override
  String get evResultsUnknownBody =>
      'ہم یہ جانچ نہیں سکے کہ نتائج شائع ہوئے ہیں یا نہیں۔';

  @override
  String get evViewResults => 'نتائج دیکھیں';

  @override
  String get evDetails => 'انتخاب کی تفصیلات';

  @override
  String get evType => 'ووٹنگ کی قسم';

  @override
  String get evWho => 'کون ووٹ دے سکتا ہے';

  @override
  String get evOpens => 'کھلتا ہے';

  @override
  String get evOpened => 'کھلا';

  @override
  String get evCloses => 'بند ہوتا ہے';

  @override
  String get evClosed => 'بند ہوا';

  @override
  String get evIdentifiableTitle => 'شناخت ظاہر کرنے والا بیلٹ۔';

  @override
  String get evIdentifiableBody =>
      'اس انتخاب میں ووٹ ووٹر کی شناخت کے ساتھ درج کیے جاتے ہیں۔';

  @override
  String get evMonitor => 'ووٹنگ کی شرح کی نگرانی';

  @override
  String get evEditBuilder => 'بلڈر میں ترمیم کریں';

  @override
  String get evChecking => 'آپ کی صورتحال جانچی جا رہی ہے';

  @override
  String get resTitle => 'انتخابی نتائج';

  @override
  String get resBack => 'انتخاب پر واپس';

  @override
  String get resPublished => 'شائع شدہ';

  @override
  String get resNotPublished => 'شائع نہیں ہوا';

  @override
  String get resSubtitle => 'ووٹنگ بند ہونے کے بعد سرور نے شمار کیا۔';

  @override
  String get resAdminOnly =>
      'شائع ہونے تک یہ نتائج صرف تنظیم کے منتظمین دیکھ سکتے ہیں۔';

  @override
  String get resFootnote =>
      'فیصد شمار کیے گئے بیلٹس کے ہیں۔ اراکین نتائج منتظم کے شائع کرنے کے بعد ہی دیکھ سکتے ہیں۔';

  @override
  String get resNotAvailableTitle => 'نتائج دستیاب نہیں';

  @override
  String get resNotAvailableBody =>
      'تنظیم کے شائع کرنے کے بعد نتائج یہاں نظر آئیں گے۔';

  @override
  String get resLoadErrorTitle => 'ہم نتائج لوڈ نہیں کر سکے';

  @override
  String get resLoadErrorBody => 'اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get resRetry => 'دوبارہ کوشش کریں';

  @override
  String get resNoneTitle => 'ابھی کوئی نتائج نہیں';

  @override
  String get resNoneBody => 'نتائج ابھی شمار نہیں ہوئے۔';

  @override
  String get resNoBallots => 'اس انتخاب میں کوئی بیلٹ درج نہیں ہوا۔';

  @override
  String get resBallots => 'شمار کیے گئے بیلٹس';

  @override
  String get resEligible => 'اہل ووٹرز';

  @override
  String get resTurnout => 'شرکت کی شرح';

  @override
  String get resSplit => 'ووٹوں کی تقسیم';

  @override
  String get resTie => 'مقابلہ برابر رہا';

  @override
  String resTieBody(String names, int votes, String percent) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes ووٹ',
      one: '1 ووٹ',
    );
    return '$names میں سے ہر ایک کو $_temp0 ملے ($percent%)۔';
  }

  @override
  String resWins(String name) {
    return '$name جیت گئے';
  }

  @override
  String resWinsBody(int votes, String percent) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes ووٹ',
      one: '1 ووٹ',
    );
    return '$_temp0 ($percent%)۔';
  }

  @override
  String resVotes(int votes) {
    String _temp0 = intl.Intl.pluralLogic(
      votes,
      locale: localeName,
      other: '$votes ووٹ',
      one: '1 ووٹ',
    );
    return '$_temp0';
  }

  @override
  String get resRecalculate => 'نتائج دوبارہ شمار کریں';

  @override
  String get resWorking => 'کام جاری ہے...';

  @override
  String get resPublish => 'اراکین کے لیے نتائج شائع کریں';

  @override
  String get resCalculate => 'نتائج شمار کریں';

  @override
  String get resExport => 'CSV برآمد کریں';

  @override
  String get resExportTitle => 'نتائج برآمد کریں (CSV)';

  @override
  String get resCopyCsv => 'CSV کاپی کریں';

  @override
  String get resCsvCopied => 'CSV کاپی ہو گیا';

  @override
  String get resClose => 'بند کریں';

  @override
  String get resActionFailed => 'یہ کام نہیں ہوا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get resPublishConfirmTitle => 'یہ نتائج شائع کریں؟';

  @override
  String get resPublishConfirmBody =>
      'تمام اہل اراکین نتائج دیکھ سکیں گے۔ آپ بعد میں بھی انہیں دوبارہ شمار کر سکتے ہیں۔';

  @override
  String get resPublishConfirm => 'شائع کریں';

  @override
  String get resCancel => 'منسوخ کریں';

  @override
  String get resEventFallback => 'انتخاب';

  @override
  String get monTitle => 'ووٹنگ کی براہ راست شرح';

  @override
  String get monBack => 'واپس';

  @override
  String get monLive => 'براہ راست';

  @override
  String monUpdated(int s) {
    return 'براہ راست · $s سیکنڈ پہلے اپ ڈیٹ ہوا';
  }

  @override
  String get monRefresh => 'تازہ کریں';

  @override
  String monClosesIn(String when) {
    return '$when میں بند ہوگا';
  }

  @override
  String monRemainDaysHours(int d, int h) {
    String _temp0 = intl.Intl.pluralLogic(
      d,
      locale: localeName,
      other: '$d دن',
      one: '1 دن',
    );
    String _temp1 = intl.Intl.pluralLogic(
      h,
      locale: localeName,
      other: '$h گھنٹے',
      one: '1 گھنٹہ',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String monRemainHoursMin(int h, int m) {
    String _temp0 = intl.Intl.pluralLogic(
      h,
      locale: localeName,
      other: '$h گھنٹے',
      one: '1 گھنٹہ',
    );
    return '$_temp0 $m منٹ';
  }

  @override
  String monRemainMin(int m) {
    return '$m منٹ';
  }

  @override
  String get monPrivacy =>
      'صرف گنتی۔ یہاں ووٹرز کی شناخت یا بیلٹ کے انتخابات نہیں دکھائے جاتے۔ انتخاب بند اور نتائج شائع ہونے تک نتائج چھپے رہتے ہیں۔';

  @override
  String get monLoadError =>
      'ہم شرکت کی شرح لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get monRetry => 'دوبارہ کوشش کریں';

  @override
  String get monRefreshIssue =>
      'تازہ ترین ریفریش ناکام رہا۔ آخری لوڈ شدہ اعداد دکھائے جا رہے ہیں۔';

  @override
  String get monTurnoutLabel => 'حصہ لینے والے اہل اراکین';

  @override
  String monOfEligible(int voted, int eligible) {
    return '$eligible میں سے $voted';
  }

  @override
  String get monEligible => 'اہل';

  @override
  String get monEligibleCap => 'تمام فعال اراکین';

  @override
  String get monVoted => 'ووٹ دیا';

  @override
  String get monVotedCap => 'جمع کرائے گئے بیلٹس';

  @override
  String get monNotYet => 'ابھی نہیں';

  @override
  String get monNotYetCap => 'باقی اراکین';

  @override
  String get monChartTitle => 'وقت کے ساتھ شرکت';

  @override
  String get monChartSub => 'انتخاب کھلنے کے بعد سے مجموعی شرکت';

  @override
  String get monChartNone =>
      'وقت کے ساتھ شرکت کا چارٹ بنانے کے لیے ابھی کافی ڈیٹا نہیں۔';

  @override
  String monChartTotal(int n) {
    return '$n نے ووٹ دیا';
  }

  @override
  String get monChartStart => 'کھلا';

  @override
  String get monChartNow => 'اب';

  @override
  String get monDeptTitle => 'شعبے کے لحاظ سے شرکت';

  @override
  String get monDeptNone => 'اس انتخاب کے لیے شعبے کا ڈیٹا دستیاب نہیں۔';

  @override
  String get monDeptNote =>
      'رازداری کے تحفظ کے لیے 5 سے کم اہل اراکین والے گروپس ملا دیے جاتے ہیں۔';

  @override
  String monDeptRow(int participated, int eligible, String percent) {
    return '$eligible میں سے $participated · $percent%';
  }

  @override
  String get monDeptFallback => 'شعبہ';

  @override
  String get monDetails => 'انتخاب کی تفصیلات';

  @override
  String get monWindow => 'ووٹنگ کا وقت';

  @override
  String get monBallotType => 'بیلٹ کی قسم';

  @override
  String get monAnonymous => 'گمنام';

  @override
  String get monIdentifiable => 'شناخت ظاہر';

  @override
  String get monEligibility => 'کون ووٹ دے سکتا ہے';

  @override
  String get monVotingType => 'ووٹنگ کی قسم';

  @override
  String get monBoostTitle => 'شرکت بڑھائیں';

  @override
  String get monBoostBody =>
      'ان اراکین کو یاد دلائیں جنہوں نے ووٹ نہیں دیا۔ یاد دہانیاں خود بخود ووٹ نہ دینے والوں کو جاتی ہیں؛ آپ نہیں دیکھیں گے کہ کس نے ووٹ دیا یا نہیں۔';

  @override
  String get monRemind => 'ووٹ نہ دینے والوں کو یاد دلائیں';

  @override
  String get monSending => 'بھیجا جا رہا ہے...';

  @override
  String get monRemindNone => 'تمام اہل افراد پہلے ہی ووٹ دے چکے ہیں۔';

  @override
  String monRemindDone(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ووٹ نہ دینے والوں کو یاد دہانی بھیج دی گئی۔',
      one: '1 ووٹ نہ دینے والے کو یاد دہانی بھیج دی گئی۔',
    );
    return '$_temp0';
  }

  @override
  String get monRemindFailed =>
      'ہم یاد دہانیاں نہیں بھیج سکے۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get monPrivateNote => 'شرکت رازدار رہتی ہے';

  @override
  String get monCloseTitle => 'ووٹنگ جلد بند کریں';

  @override
  String get monCloseNote =>
      'بند کرنا حتمی ہے۔ اگر آپ کا آخری سائن اِن 15 منٹ سے پرانا ہو تو دوبارہ سائن اِن کرنا پڑ سکتا ہے۔ نتائج شمار اور شائع کرنے تک چھپے رہتے ہیں۔';

  @override
  String get monCloseButton => 'ابھی ووٹنگ بند کریں';

  @override
  String get monCloseDialogTitle => 'ابھی ووٹنگ بند کریں؟';

  @override
  String get monCloseDialogBody =>
      'بند کرنا حتمی ہے۔ اراکین مزید ووٹ نہیں دے سکیں گے اور اسے واپس نہیں کیا جا سکتا۔ نتائج شمار اور شائع کرنے تک چھپے رہتے ہیں۔';

  @override
  String get monCloseConfirm => 'ووٹنگ بند کریں';

  @override
  String get monCancel => 'منسوخ کریں';

  @override
  String get monClosed => 'ووٹنگ بند ہو گئی۔';

  @override
  String get monCloseFailed =>
      'ہم ووٹنگ بند نہیں کر سکے۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get monReauth =>
      'سلامتی کے لیے، انتخاب بند کرنے کے لیے ضروری ہے کہ آپ نے پچھلے 15 منٹ میں سائن اِن کیا ہو۔ جاری رکھنے کے لیے اپنی شناخت کی تصدیق کریں۔';

  @override
  String get calTitle => 'انتخابات کا کیلنڈر';

  @override
  String get calAgendaView => 'فہرست کا منظر';

  @override
  String get calCalendarView => 'کیلنڈر کا منظر';

  @override
  String get calLoadError =>
      'ہم کیلنڈر لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔';

  @override
  String get calRetry => 'دوبارہ کوشش کریں';

  @override
  String get calAllOrgs => 'تمام تنظیمیں';

  @override
  String get calMonth => 'مہینہ';

  @override
  String get calWeek => 'ہفتہ';

  @override
  String get calNoneTitle => 'دکھانے کے لیے کوئی انتخاب نہیں';

  @override
  String get calNoneBody => 'آپ کی تنظیموں میں ابھی کوئی انتخاب نہیں۔';

  @override
  String get calNoDayTitle => 'اس دن کوئی انتخاب نہیں';

  @override
  String get calNoDayBody => 'شیڈول دیکھنے کے لیے کوئی اور تاریخ چنیں۔';

  @override
  String calCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n انتخابات',
      one: '1 انتخاب',
      zero: 'کوئی انتخاب نہیں',
    );
    return '$_temp0';
  }

  @override
  String get calDetails => 'تفصیلات';

  @override
  String get calAdd => 'کیلنڈر میں شامل کریں';

  @override
  String calRange(String start, String end) {
    return '$start سے $end تک';
  }

  @override
  String get authOr => 'یا';

  @override
  String get authNewUser => 'نئے ہیں؟';

  @override
  String get authHaveAccount => 'پہلے سے اکاؤنٹ ہے؟';

  @override
  String get authSignIn => 'سائن اِن کریں';

  @override
  String get authRemembered => 'اپنا پاس ورڈ یاد آ گیا؟';

  @override
  String get authShowPassword => 'پاس ورڈ دکھائیں';

  @override
  String get authHidePassword => 'پاس ورڈ چھپائیں';

  @override
  String get authUnexpectedError =>
      'کچھ غلط ہو گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get authMfaUnsupported =>
      'اس اکاؤنٹ کا دوسرا سائن اِن مرحلہ ابھی اس ایپ میں تعاون یافتہ نہیں۔ براہ کرم سپورٹ سے رابطہ کریں۔';

  @override
  String get statusActive => 'فعال';

  @override
  String get statusScheduled => 'شیڈول شدہ';

  @override
  String get statusClosed => 'بند';

  @override
  String get statusArchived => 'محفوظ شدہ';

  @override
  String get statusCancelled => 'منسوخ';

  @override
  String get statusDraft => 'مسودہ';

  @override
  String get statusUnknown => 'نامعلوم';

  @override
  String get privacyAnonymous => 'گمنام';

  @override
  String get privacyIdentifiable => 'شناخت ظاہر';

  @override
  String get roleOwner => 'مالک';

  @override
  String get roleAdmin => 'منتظم';

  @override
  String get roleMember => 'رکن';

  @override
  String get navJoiningCodes => 'شمولیت کے کوڈ';

  @override
  String get navPlatformAccounts => 'اکاؤنٹس اور رسائی';
}
