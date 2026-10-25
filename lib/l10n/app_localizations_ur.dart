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
  String get navAccount => 'پروفائل';

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
      'تمام اہل اراکین نتائج دیکھ سکیں گے، اور جنہوں نے نتائج کی اطلاعات آن رکھی ہیں انہیں اطلاع بھی ملے گی۔ آپ بعد میں بھی انہیں دوبارہ شمار کر سکتے ہیں۔';

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

  @override
  String get navInvitations => 'دعوت نامے';

  @override
  String get acctTitle => 'اکاؤنٹ کی ترتیبات';

  @override
  String get acctTabProfile => 'پروفائل';

  @override
  String get acctTabSecurity => 'سیکیورٹی اور ترتیبات';

  @override
  String get acctTabNotifications => 'اطلاعات';

  @override
  String get acctTabPreferences => 'ترجیحات';

  @override
  String get acctTabAccounts => 'منسلک اکاؤنٹس';

  @override
  String get acctTabSecurityShort => 'سیکیورٹی';

  @override
  String get acctTabNotificationsShort => 'الرٹس';

  @override
  String get acctTabPreferencesShort => 'ترجیحات';

  @override
  String get acctTabAccountsShort => 'اکاؤنٹس';

  @override
  String get acctLoading => 'پروفائل لوڈ ہو رہی ہے...';

  @override
  String get acctLoadError =>
      'ہم آپ کی پروفائل لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get acctNotFound => 'پروفائل نہیں ملی۔';

  @override
  String get acctPhotoUpdated => 'پروفائل کی تصویر کامیابی سے اپ ڈیٹ ہو گئی۔';

  @override
  String get acctPhotoFailed => 'تصویر اپ لوڈ نہیں ہو سکی۔ دوبارہ کوشش کریں۔';

  @override
  String get acctProfileUpdated => 'پروفائل کامیابی سے اپ ڈیٹ ہو گئی۔';

  @override
  String get acctVerified => 'تصدیق شدہ';

  @override
  String get acctUnverified => 'غیر تصدیق شدہ';

  @override
  String acctMemberSince(String date) {
    return 'رکنیت کی تاریخ: $date';
  }

  @override
  String get acctPersonalInfo => 'ذاتی معلومات';

  @override
  String get acctFirstName => 'پہلا نام';

  @override
  String get acctLastName => 'آخری نام';

  @override
  String get acctFirstNameField => 'پہلا نام';

  @override
  String get acctLastNameField => 'آخری نام';

  @override
  String get acctPhone => 'فون نمبر (اختیاری)';

  @override
  String get acctSaveChanges => 'تبدیلیاں محفوظ کریں';

  @override
  String get acctAuthMethod => 'تصدیق کا طریقہ';

  @override
  String get acctGoogleNote =>
      'آپ کا اکاؤنٹ گوگل سے منسلک ہے۔ پاس ورڈ کی تبدیلی آپ کے گوگل اکاؤنٹ سے ہوتی ہے۔';

  @override
  String get acct2fa => 'دو مرحلہ تصدیق';

  @override
  String get acct2faBody =>
      'ایک اضافی تصدیقی مرحلہ لگا کر اپنے اکاؤنٹ کو محفوظ رکھیں۔';

  @override
  String get acctSetupAuth => 'آتھنٹیکیٹر ایپ سیٹ اپ کریں';

  @override
  String get acctSignOut => 'سائن آؤٹ';

  @override
  String get acctAppearance => 'ظاہری شکل';

  @override
  String get acctAppearanceBody =>
      'منتخب کریں کہ اس ڈیوائس پر Kivora کیسا دکھائی دے۔';

  @override
  String get acctThemeLight => 'روشن';

  @override
  String get acctThemeDark => 'گہرا';

  @override
  String get acctThemeSystem => 'سسٹم';

  @override
  String get acctLanguage => 'زبان';

  @override
  String get acctLanguageNote =>
      'اردو، سندھی اور عربی ترجمے مشین کی مدد سے بنے ہیں اور ابھی کسی مقامی بولنے والے نے ان کا جائزہ نہیں لیا۔ جو بھی غلط لگے اس کی اطلاع دیں۔';

  @override
  String get acctSystemDefault => 'سسٹم ڈیفالٹ';

  @override
  String get acctAccessibility => 'رسائی';

  @override
  String get acctReduceMotion => 'حرکت کم کریں';

  @override
  String get acctReduceMotionBody => 'پوری ایپ میں اینیمیشنز کم کریں۔';

  @override
  String get acctHighContrast => 'زیادہ تضاد';

  @override
  String get acctHighContrastBody =>
      'بہتر نظر آنے کے لیے متن اور کناروں کا تضاد بڑھائیں۔';

  @override
  String get acctTextSizeNote =>
      'متن کا سائز آپ کے ڈیوائس کی رسائی کی ترتیبات کے مطابق ہے۔ بیلٹ اسکرین پر امیدوار/آپشن کے انتخاب پہلے ہی اسکرین ریڈر کے لیے لیبل شدہ ہیں۔';

  @override
  String get acctNotifications => 'اطلاعات';

  @override
  String get acctNotificationsBody =>
      'منتخب کریں کہ آپ کون سی اطلاعات وصول کرنا چاہتے ہیں۔ یہ نوٹیفکیشن بیل اور یاد دہانی ای میلز پر لاگو ہوتی ہیں۔';

  @override
  String get acctVoteReminders => 'ووٹ کی یاد دہانی';

  @override
  String get acctVoteRemindersBody =>
      'جب کوئی فعال انتخاب بند ہونے والا ہو اور آپ نے ووٹ نہ دیا ہو تو اطلاع پائیں۔';

  @override
  String get acctResultsPublished => 'نتائج شائع ہو گئے';

  @override
  String get acctResultsPublishedBody =>
      'جس انتخاب میں آپ ووٹ دینے کے اہل تھے اس کے نتائج شائع ہونے پر اطلاع پائیں۔';

  @override
  String get acctInvitationAlerts => 'تنظیم کے دعوت نامے';

  @override
  String get acctInvitationAlertsBody =>
      'زیر التوا تنظیمی دعوت نامے نوٹیفکیشن بیل میں دکھائیں۔';

  @override
  String get acctConnectedTitle => 'منسلک اکاؤنٹس';

  @override
  String get acctConnectedBody =>
      'آپ کے Kivora اکاؤنٹ سے منسلک سائن اِن کے طریقے۔ کم از کم ایک منسلک رہنا لازمی ہے۔';

  @override
  String get acctEmailPassword => 'ای میل اور پاس ورڈ';

  @override
  String get acctGoogleSignIn => 'اپنے گوگل اکاؤنٹ سے سائن اِن کریں۔';

  @override
  String get acctConnectedBadge => 'منسلک';

  @override
  String get acctConnect => 'منسلک کریں';

  @override
  String get acctDisconnect => 'منقطع کریں';

  @override
  String acctDisconnectTitle(String name) {
    return '$name کو منقطع کریں؟';
  }

  @override
  String acctDisconnectBody(String name) {
    return 'آپ $name کے ذریعے Kivora میں سائن اِن نہیں کر سکیں گے۔';
  }

  @override
  String get acctCancel => 'منسوخ کریں';

  @override
  String get acctGoogleConnected => 'گوگل اکاؤنٹ منسلک ہو گیا۔';

  @override
  String get acctChangePassword => 'پاس ورڈ تبدیل کریں';

  @override
  String get acctCurrentPassword => 'موجودہ پاس ورڈ';

  @override
  String get acctNewPassword => 'نیا پاس ورڈ';

  @override
  String get acctConfirmPassword => 'نئے پاس ورڈ کی تصدیق کریں';

  @override
  String get acctUpdatePassword => 'پاس ورڈ اپ ڈیٹ کریں';

  @override
  String get acctPasswordUpdated => 'پاس ورڈ کامیابی سے اپ ڈیٹ ہو گیا!';

  @override
  String get navPlatformOverview => 'نظرِ پلیٹ فارم';

  @override
  String get navPlatformOrganizations => 'تمام تنظیمیں';

  @override
  String get navPlatformReports => 'صارف رپورٹس';

  @override
  String get navPlatformAudit => 'آڈٹ لاگ';

  @override
  String get resNotClosedYet =>
      'انتخاب بند ہونے کے بعد ہی نتائج شمار کیے جا سکتے ہیں۔';

  @override
  String get orgSetSaveTitle => 'اپنی برانڈنگ کی تبدیلیاں محفوظ کریں؟';

  @override
  String get orgSetUnsavedBody =>
      'آپ نے اس تنظیم کی برانڈنگ بدلی ہے مگر محفوظ نہیں کی۔ رد کی گئی تبدیلیاں واپس نہیں آ سکتیں۔';

  @override
  String get orgSetKeepEditing => 'ترمیم جاری رکھیں';

  @override
  String get orgSetDiscard => 'رد کریں';

  @override
  String get orgSetSave => 'محفوظ کریں';

  @override
  String get orgSetLoading => 'تنظیم لوڈ ہو رہی ہے…';

  @override
  String get orgSetLoadError =>
      'ہم تنظیم لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get orgSetNoOrgTitle => 'کوئی فعال تنظیم نہیں';

  @override
  String get orgSetNoOrgBody => 'برانڈنگ بدلنے سے پہلے ایک تنظیم منتخب کریں۔';

  @override
  String get orgSetDeniedTitle => 'رسائی نہیں دی گئی';

  @override
  String get orgSetDeniedBody =>
      'صرف تنظیم کا مالک اس کی برانڈنگ اپ ڈیٹ کر سکتا ہے۔';

  @override
  String get orgSetBackOverview => 'جائزہ';

  @override
  String get orgSetTitle => 'تنظیم کی برانڈنگ';

  @override
  String orgSetSubtitle(String a) {
    return 'طے کریں کہ $a اراکین اور ووٹرز کو کیسی دکھائی دے۔';
  }

  @override
  String get orgSetDetails => 'تنظیم کی تفصیلات';

  @override
  String get orgSetDetailsBody => 'آپ کی تنظیم کا عوامی نام اور مختصر تعارف۔';

  @override
  String get orgSetNameLabel => 'تنظیم کا نام *';

  @override
  String get orgSetNameHint => 'مثلاً ایکمی کارپوریشن';

  @override
  String get orgSetNameShort => 'کم از کم 3 حروف استعمال کریں۔';

  @override
  String get orgSetDescription => 'تفصیل';

  @override
  String get orgSetDescriptionHint => 'اپنی تنظیم یا شعبے کا مختصر خلاصہ...';

  @override
  String get orgSetDescriptionHelp =>
      'مختصر تعارف جو آپ کی تنظیم کی پروفائل پر دکھایا جاتا ہے۔';

  @override
  String get orgSetWebsite => 'ویب سائٹ (اختیاری)';

  @override
  String get orgSetWebsiteInvalid => 'درست HTTPS ویب ایڈریس درج کریں۔';

  @override
  String get orgSetLogo => 'تنظیم کا لوگو';

  @override
  String get orgSetLogoActive => 'لوگو لگا ہوا ہے';

  @override
  String get orgSetLogoNone => 'کوئی لوگو اپ لوڈ نہیں ہوا';

  @override
  String get orgSetLogoChange => 'دوسرا لوگو منتخب کریں';

  @override
  String get orgSetLogoChoose => 'لوگو منتخب کریں';

  @override
  String get orgSetRemove => 'ہٹائیں';

  @override
  String get orgSetLogoHelp =>
      'PNG، JPEG یا WebP · زیادہ سے زیادہ 2 MB\nبہترین نتیجے کے لیے چوکور تصویر استعمال کریں۔';

  @override
  String get orgSetPreviewName => 'تنظیم کا نام';

  @override
  String get orgSetPreviewDescription => 'تفصیل یہاں دکھائی دے گی...';

  @override
  String get orgSetPreviewNoWebsite => 'کوئی ویب سائٹ شامل نہیں کی گئی';

  @override
  String get orgSetPreviewTitle => 'رکن کی پروفائل کا پیش منظر';

  @override
  String get orgSetPreviewBody => 'آپ کی تنظیم اراکین کو کیسی دکھائی دے گی۔';

  @override
  String get orgSetPreviewRole => 'رکن';

  @override
  String get orgSetPreviewViewEvents => 'انتخابات دیکھیں';

  @override
  String get orgSetPreviewNote =>
      'صرف پیش منظر۔ محفوظ کرنے کے بعد تبدیلیاں اراکین اور ووٹرز کو نظر آئیں گی۔';

  @override
  String get orgSetNotPermTitle => 'برانڈنگ، اجازتیں نہیں';

  @override
  String get orgSetNotPermBody =>
      'رسائی کا کنٹرول اور تصدیق الگ سے سنبھالی جاتی ہے۔ برانڈنگ بدلنے سے ان میں کوئی تبدیلی نہیں آئے گی۔';

  @override
  String get orgSetDirtyTitle => 'آپ کی تبدیلیاں محفوظ نہیں ہوئیں';

  @override
  String get orgSetDirtyLogo =>
      'نیا لوگو منتخب ہوا ہے مگر ابھی اپ لوڈ نہیں ہوا۔ اپ لوڈ اور شائع کرنے کے لیے محفوظ کریں۔';

  @override
  String get orgSetDirtyBody =>
      'برانڈنگ شائع کرنے کے لیے محفوظ کریں، یا تبدیلیاں رد کرنے کے لیے ری سیٹ کریں۔';

  @override
  String get orgSetReset => 'ری سیٹ';

  @override
  String get orgSetSaving => 'محفوظ ہو رہا ہے...';

  @override
  String get orgSetSaveBranding => 'برانڈنگ محفوظ کریں';

  @override
  String get orgSetLogoTooBig => 'لوگو 2 MB سے بڑا ہے۔ چھوٹی تصویر منتخب کریں۔';

  @override
  String get orgSetSaved => 'تنظیم کی برانڈنگ محفوظ ہو گئی۔';

  @override
  String get orgSetSaveFailed =>
      'برانڈنگ محفوظ نہیں ہو سکی۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get orgSetDanger => 'خطرناک حصہ';

  @override
  String get orgSetDangerBody =>
      'اس تنظیم کو حذف کرنے سے اس کی ورک اسپیس آرکائیو ہو جائے گی۔ فعال انتخابات ووٹ لینا بند کر دیں گے۔';

  @override
  String get orgSetDelete => 'تنظیم حذف کریں';

  @override
  String get orgSetDeleteTitle => 'تنظیم حذف کریں؟';

  @override
  String orgSetDeleteBody(String a) {
    return 'کیا آپ واقعی \"$a\" کو حذف کرنا چاہتے ہیں؟\n\nاس سے تنظیم کی ورک اسپیس آرکائیو ہو جائے گی۔ یہ عمل واپس نہیں ہو سکتا۔';
  }

  @override
  String get orgSetKeep => 'تنظیم رکھیں';

  @override
  String get orgSetDeleted => 'تنظیم حذف کر دی گئی ہے۔';

  @override
  String get jcMaxUsesInvalid =>
      'زیادہ سے زیادہ استعمال کی تعداد 0 سے 100,000 کے درمیان درج کریں۔';

  @override
  String get jcSaveTitle => 'یہ شمولیت کا کوڈ محفوظ کر لیں';

  @override
  String get jcShownOnce =>
      'یہ کوڈ صرف ایک بار دکھایا جاتا ہے۔ اسے صرف انہی لوگوں کو دیں جنہیں آپ اس تنظیم میں شامل کرنا چاہتے ہیں۔';

  @override
  String get jcScanHint =>
      'یا کسی دوسرے ڈیوائس پر Kivora کے \"Scan to Join\" سے اسے اسکین کریں۔';

  @override
  String get jcCopied => 'کاپی ہو گیا';

  @override
  String get jcCopy => 'کوڈ کاپی کریں';

  @override
  String get jcDone => 'مکمل';

  @override
  String get jcRevokeTitle => 'یہ کوڈ منسوخ کریں؟';

  @override
  String get jcCancel => 'منسوخ کریں';

  @override
  String get jcRevoke => 'کوڈ منسوخ کریں';

  @override
  String get jcRevokeNoId => 'یہ کوڈ منسوخ نہیں ہو سکتا (شناخت موجود نہیں)۔';

  @override
  String get jcRevoked => 'شمولیت کا کوڈ منسوخ کر دیا گیا۔';

  @override
  String get jcTitle => 'شمولیت کے کوڈ';

  @override
  String get jcRefresh => 'شمولیت کے کوڈ تازہ کریں';

  @override
  String get jcLoading => 'تنظیم لوڈ ہو رہی ہے…';

  @override
  String get jcOrgLoadError =>
      'ہم یہ تنظیم لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get jcNoOrgTitle => 'تنظیم منتخب کریں';

  @override
  String get jcNoOrgBody =>
      'شمولیت کے کوڈ سنبھالنے سے پہلے ایک تنظیم منتخب کریں۔';

  @override
  String get jcAdminTitle => 'منتظم کی رسائی درکار ہے';

  @override
  String get jcAdminBody =>
      'صرف اس تنظیم کا مالک اور منتظمین شمولیت کے کوڈ سنبھال سکتے ہیں۔';

  @override
  String get jcSubtitle =>
      'ایسے کوڈ بنائیں اور منسوخ کریں جن سے لوگ اس تنظیم میں شامل ہو سکیں۔ درست کوڈ سے شخص فوراً رکن بن جاتا ہے؛ اس سے کبھی منتظم یا مالک کی رسائی نہیں ملتی۔';

  @override
  String get jcStatActive => 'فعال کوڈ';

  @override
  String get jcStatExpired => 'میعاد ختم یا استعمال مکمل';

  @override
  String get jcStatRevoked => 'منسوخ';

  @override
  String get jcExisting => 'موجودہ کوڈ';

  @override
  String get jcLoadError =>
      'ہم شمولیت کے کوڈ لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get jcEmpty => 'اس تنظیم کے لیے کوئی شمولیت کا کوڈ نہیں ہے۔';

  @override
  String get jcCreateTitle => 'شمولیت کا کوڈ بنائیں';

  @override
  String get jcCreateNote =>
      'کوڈ صرف ایک بار دکھایا جاتا ہے۔ وہ محفوظ ہیش کی صورت میں رکھا جاتا ہے اور بعد میں دوبارہ حاصل نہیں ہو سکتا۔';

  @override
  String get jcCreating => 'بن رہا ہے…';

  @override
  String get jcCreate => 'کوڈ بنائیں';

  @override
  String get jcExpiresAfter => 'میعاد ختم ہو گی';

  @override
  String get jcExp24h => '24 گھنٹے';

  @override
  String get jcExp3d => '3 دن';

  @override
  String get jcExp7d => '7 دن';

  @override
  String get jcExp30d => '30 دن';

  @override
  String get jcExp1y => '1 سال';

  @override
  String get jcMaxUses => 'زیادہ سے زیادہ استعمال';

  @override
  String get jcMaxUsesHint => 'لامحدود کے لیے 0 لکھیں۔';

  @override
  String get jcExpiryUnknown => 'میعاد معلوم نہیں';

  @override
  String jcExpires(String a) {
    return 'میعاد ختم: $a';
  }

  @override
  String jcUses(String a) {
    return '$a استعمال';
  }

  @override
  String jcUsesOf(String a, String b) {
    return '$b میں سے $a استعمال';
  }

  @override
  String get dmDeleteTitle => 'شعبہ حذف کریں';

  @override
  String dmDeleteBody(String a) {
    return 'کیا آپ واقعی \"$a\" کو حذف کرنا چاہتے ہیں؟\n\nاس سے شعبہ مستقل طور پر حذف ہو جائے گا۔';
  }

  @override
  String get dmCancel => 'منسوخ کریں';

  @override
  String get dmDeleted => 'شعبہ کامیابی سے حذف ہو گیا۔';

  @override
  String dmDeleteFailed(String a) {
    return 'حذف نہیں ہو سکا: $a';
  }

  @override
  String get dmDeletePermanent => 'مستقل طور پر حذف کریں';

  @override
  String dmAssigned(String a, String b) {
    return '$a رکن/اراکین کو $b میں شامل کر دیا گیا۔';
  }

  @override
  String dmAssignFailed(String a) {
    return 'اراکین کو شامل نہیں کیا جا سکا: $a';
  }

  @override
  String get dmRemoveFrom => 'شعبے سے ہٹائیں';

  @override
  String dmRemoveBody(String a) {
    return '\"$a\" کو اس شعبے سے ہٹائیں؟';
  }

  @override
  String get dmRemove => 'ہٹائیں';

  @override
  String dmRemoved(String a) {
    return '$a کو شعبے سے ہٹا دیا گیا۔';
  }

  @override
  String dmRemoveFailed(String a) {
    return 'رکن کو ہٹایا نہیں جا سکا: $a';
  }

  @override
  String get dmNoOrgTitle => 'کوئی فعال تنظیم نہیں';

  @override
  String get dmNoOrgBody =>
      'شعبے کے اراکین دیکھنے کے لیے ایک تنظیم منتخب کریں۔';

  @override
  String get dmLoadingDept => 'شعبے کی تفصیلات لوڈ ہو رہی ہیں...';

  @override
  String get dmLoadingRoster => 'شعبے کی فہرست لوڈ ہو رہی ہے...';

  @override
  String get dmRosterError =>
      'ہم فہرست لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get dmBack => 'شعبہ جات';

  @override
  String dmAssignedCount(String a) {
    return '$a شامل اراکین';
  }

  @override
  String get dmEligibleNote =>
      'اس شعبے کے اراکین کو انتخابات کے اہل ووٹرز کے طور پر منتخب کیا جا سکتا ہے۔';

  @override
  String get dmEdit => 'تفصیلات میں ترمیم';

  @override
  String get dmDelete => 'حذف کریں';

  @override
  String dmMembersIn(String a) {
    return '$a کے اراکین';
  }

  @override
  String get dmNoMembers => 'ابھی کوئی رکن شامل نہیں';

  @override
  String get dmNoMembersBody =>
      'فہرست سے لوگوں کو منتخب کر کے اس شعبے میں شامل کریں۔ آپ اسے کسی بھی وقت بدل سکتے ہیں۔';

  @override
  String get dmAssignedHere => 'شامل اراکین یہاں دکھائی دیں گے۔';

  @override
  String dmPendingNote(String a, String b) {
    return 'زیر التوا انتخاب ابھی اراکین نہیں بنے۔ انہیں $b میں شامل کرنے کے لیے \"$a اراکین شامل کریں\" سے تصدیق کریں۔';
  }

  @override
  String get dmAddMembers => 'اراکین شامل کریں';

  @override
  String dmSelectPeople(String a) {
    return '$a میں شامل کرنے کے لیے لوگوں کو منتخب کریں۔';
  }

  @override
  String get dmSearch => 'نام سے تلاش کریں';

  @override
  String get dmAllMembers => 'تمام اراکین';

  @override
  String get dmNoDept => 'کوئی شعبہ نہیں';

  @override
  String get dmNoMatch => 'آپ کی تلاش سے کوئی رکن نہیں ملا۔';

  @override
  String dmIn(String a) {
    return '$a میں';
  }

  @override
  String dmInFirst(String a) {
    return '$a میں';
  }

  @override
  String dmAssignedTo(String a) {
    return '$a میں شامل';
  }

  @override
  String get dmClear => 'صاف کریں';

  @override
  String dmPendingTo(String a) {
    return '$a میں شمولیت زیر التوا';
  }

  @override
  String get dmAssigning => 'شامل کیا جا رہا ہے...';

  @override
  String dmAssign(String a) {
    return '$a اراکین شامل کریں';
  }

  @override
  String jcRevokeBody(String a) {
    return 'جس کے پاس بھی یہ کوڈ ہے وہ اب اسے استعمال نہیں کر سکے گا۔ ($a)';
  }

  @override
  String jcCodeLabel(String a) {
    return 'کوڈ • $a';
  }

  @override
  String get statusExhausted => 'ختم';

  @override
  String get statusExpired => 'میعاد ختم';

  @override
  String get statusRevoked => 'منسوخ';

  @override
  String get dmMemberFallback => 'رکن';

  @override
  String dmSelectedCount(String a) {
    return '$a منتخب';
  }

  @override
  String get auditActAcceptInvitation => 'دعوت قبول کی گئی';

  @override
  String get auditActActivateVotingEvent => 'انتخاب فعال کیا گیا';

  @override
  String get auditActAddMember => 'رکن شامل کیا گیا';

  @override
  String get auditActAssignDepartment => 'شعبہ تفویض کیا گیا';

  @override
  String get auditActCalculateResults => 'نتائج شمار کیے گئے';

  @override
  String get auditActCancelVotingEvent => 'انتخاب منسوخ کیا گیا';

  @override
  String get auditActCloseVotingEvent => 'انتخاب بند کیا گیا';

  @override
  String get auditActCreateCandidate => 'امیدوار شامل کیا گیا';

  @override
  String get auditActCreateDepartment => 'شعبہ بنایا گیا';

  @override
  String get auditActCreateJoiningCode => 'شمولیت کا کوڈ بنایا گیا';

  @override
  String get auditActCreateOrganization => 'تنظیم بنائی گئی';

  @override
  String get auditActCreatePollOption => 'رائے شماری کا آپشن شامل کیا گیا';

  @override
  String get auditActCreateVotingEvent => 'انتخاب بنایا گیا';

  @override
  String get auditActDeclineInvitation => 'دعوت مسترد کی گئی';

  @override
  String get auditActDeleteCandidate => 'امیدوار ہٹایا گیا';

  @override
  String get auditActDeleteCandidatePhoto => 'امیدوار کی تصویر ہٹائی گئی';

  @override
  String get auditActDeleteDepartment => 'شعبہ حذف کیا گیا';

  @override
  String get auditActDeleteOrganization => 'تنظیم حذف کی گئی';

  @override
  String get auditActDeletePollOption => 'رائے شماری کا آپشن ہٹایا گیا';

  @override
  String get auditActDeleteVotingEvent => 'انتخاب حذف کیا گیا';

  @override
  String get auditActFinalizeCandidatePhoto => 'امیدوار کی تصویر محفوظ ہوئی';

  @override
  String get auditActGrantObserverStatus => 'مبصر کی رسائی دی گئی';

  @override
  String get auditActInviteMember => 'رکن کو مدعو کیا گیا';

  @override
  String get auditActJoinOrganizationWithCode => 'کوڈ کے ذریعے شمولیت';

  @override
  String get auditActLeaveOrganization => 'تنظیم چھوڑ دی گئی';

  @override
  String get auditActPlanChanged => 'پلان بدلا گیا';

  @override
  String get auditActPlatformAdminAccessGranted =>
      'پلیٹ فارم ایڈمن کی رسائی دی گئی';

  @override
  String get auditActPlatformAdminAccessRemoved =>
      'پلیٹ فارم ایڈمن کی رسائی ہٹائی گئی';

  @override
  String get auditActPublishResults => 'نتائج شائع کیے گئے';

  @override
  String get auditActPublishVotingEvent => 'انتخاب شائع کیا گیا';

  @override
  String get auditActRemindNonVoters =>
      'ووٹ نہ دینے والوں کو یاد دہانی بھیجی گئی';

  @override
  String get auditActRemoveDepartment => 'رکن کو شعبے سے ہٹایا گیا';

  @override
  String get auditActRemoveMember => 'رکن کو ہٹایا گیا';

  @override
  String get auditActRevokeInvitation => 'دعوت منسوخ کی گئی';

  @override
  String get auditActRevokeJoiningCode => 'شمولیت کا کوڈ منسوخ کیا گیا';

  @override
  String get auditActRevokeObserverStatus => 'مبصر کی رسائی ہٹائی گئی';

  @override
  String get auditActUpdateCandidate => 'امیدوار اپ ڈیٹ کیا گیا';

  @override
  String get auditActUpdateDepartment => 'شعبہ اپ ڈیٹ کیا گیا';

  @override
  String get auditActUpdateMemberRole => 'رکن کا کردار بدلا گیا';

  @override
  String get auditActUpdateMemberStatus => 'رکن کی حیثیت بدلی گئی';

  @override
  String get auditActUpdateOrganizationMetadata =>
      'تنظیم کی تفصیلات اپ ڈیٹ ہوئیں';

  @override
  String get auditActUpdatePollOption => 'رائے شماری کا آپشن اپ ڈیٹ ہوا';

  @override
  String get auditActUpdateVotingEvent => 'انتخاب اپ ڈیٹ کیا گیا';

  @override
  String get auditActOrganizationVerify => 'تنظیم کی تصدیق ہو گئی';

  @override
  String get auditActOrganizationReject => 'تنظیم مسترد کی گئی';

  @override
  String get auditActOrganizationSuspend => 'تنظیم معطل کی گئی';

  @override
  String get auditActOrganizationReactivate => 'تنظیم دوبارہ فعال کی گئی';

  @override
  String get auditActUnknown => 'منتظم کی کارروائی';

  @override
  String get auditSystem => 'سسٹم';

  @override
  String get auLoading => 'تنظیم کی سرگرمی لوڈ ہو رہی ہے…';

  @override
  String get auOrgLoadError =>
      'ہم تنظیم لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get auNoOrgTitle => 'تنظیم منتخب کریں';

  @override
  String get auNoOrgBody => 'اس کی سرگرمی دیکھنے کے لیے ایک تنظیم منتخب کریں۔';

  @override
  String get auDeniedTitle => 'رسائی نہیں دی گئی';

  @override
  String get auDeniedBody =>
      'صرف اس تنظیم کا مالک اور منتظمین اس کی آڈٹ ہسٹری دیکھ سکتے ہیں۔';

  @override
  String get auCrumbOrg => 'تنظیم';

  @override
  String get auCrumbActivity => 'سرگرمی';

  @override
  String get auTitle => 'تنظیم کی سرگرمی';

  @override
  String get auSubtitle =>
      'اپنی تنظیم میں رکنیت اور دعوتوں کی تبدیلیاں دیکھیں۔';

  @override
  String get auLoadingHistory => 'آڈٹ ہسٹری لوڈ ہو رہی ہے…';

  @override
  String get auLoadError =>
      'ہم تنظیم کی سرگرمی لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get auSearchLong =>
      'سرگرمی، اکاؤنٹ آئی ڈی یا ریکارڈ کی قسم سے تلاش کریں';

  @override
  String get auSearchShort => 'سرگرمی تلاش کریں...';

  @override
  String get auReset => 'ری سیٹ';

  @override
  String get auAllTypes => 'ریکارڈ کی تمام اقسام';

  @override
  String get auFilterType => 'ریکارڈ کی قسم سے فلٹر کریں';

  @override
  String get auAllAccounts => 'تمام اکاؤنٹس';

  @override
  String auAccount(String a) {
    return 'اکاؤنٹ $a';
  }

  @override
  String get auFilterAccount => 'اکاؤنٹ سے فلٹر کریں';

  @override
  String get auDateRange => 'تاریخ کی حد';

  @override
  String get auFilterDate => 'تاریخ کی حد سے فلٹر کریں';

  @override
  String get auAllTime => 'تمام وقت';

  @override
  String get auToday => 'آج';

  @override
  String get auLast7 => 'پچھلے 7 دن';

  @override
  String get auLast30 => 'پچھلے 30 دن';

  @override
  String get auCustomRange => 'اپنی تاریخ کی حد...';

  @override
  String get auDateUnknown => 'تاریخ دستیاب نہیں';

  @override
  String get auAllRecords => 'تمام ریکارڈ';

  @override
  String get auMembers => 'اراکین';

  @override
  String get auInvitations => 'دعوت نامے';

  @override
  String get auNewest => 'نئے پہلے';

  @override
  String get auOldest => 'پرانے پہلے';

  @override
  String get auColActivity => 'سرگرمی';

  @override
  String get auColType => 'ریکارڈ کی قسم';

  @override
  String get auColAccount => 'اکاؤنٹ آئی ڈی';

  @override
  String get auColTime => 'وقت';

  @override
  String get auNoMatch => 'آپ کے معیار سے کوئی سرگرمی کا ریکارڈ نہیں ملا۔';

  @override
  String get auRecordOne => '1 ریکارڈ';

  @override
  String auRecordMany(String a) {
    return '$a ریکارڈ';
  }

  @override
  String auShown(String a) {
    return '$a ریکارڈ دکھائے گئے · دہرائے گئے ریکارڈ بھی محفوظ ہیں';
  }

  @override
  String get auTimesNote => 'تاریخیں اور اوقات جیسے ریکارڈ ہوئے';

  @override
  String get auUnavailable => 'دستیاب نہیں';

  @override
  String get auTimeUnknown => 'وقت دستیاب نہیں';

  @override
  String get auViewDetails => 'تفصیل دیکھیں ';

  @override
  String auActorBullet(String a) {
    return '• $a';
  }

  @override
  String get auRecordedAt => 'ریکارڈ کا وقت';

  @override
  String get auRecordType => 'ریکارڈ کی قسم';

  @override
  String get auAccountId => 'اکاؤنٹ آئی ڈی';

  @override
  String get auNoActorDetail =>
      'اس ریکارڈ میں کارروائی کرنے والے کی شناخت اور تبدیلی کی تفصیل شامل نہیں۔';

  @override
  String get evGenericTitle => 'ایک خرابی پیش آئی';

  @override
  String get evGenericStatus => 'خرابی';

  @override
  String get evOrgTitle => 'کوئی فعال تنظیم نہیں';

  @override
  String get evOrgStatus => 'تنظیم درکار ہے';

  @override
  String get evConnTitle => 'کنکشن منقطع ہو گیا';

  @override
  String get evConnStatus => 'کنکشن میں رکاوٹ';

  @override
  String get evDeniedTitle => 'رسائی نہیں دی گئی';

  @override
  String get evDeniedStatus => 'اجازت درکار ہے';

  @override
  String get evSessionTitle => 'سیشن ختم ہو گیا';

  @override
  String get evSessionStatus => 'سائن اِن ضروری ہے';

  @override
  String get evSaveTitle => 'تبدیلیاں محفوظ نہیں ہو سکیں';

  @override
  String get evSaveStatus => 'محفوظ کرنا ناکام';

  @override
  String get evServiceTitle => 'سروس دستیاب نہیں';

  @override
  String get evServiceStatus => 'سروس میں خلل';

  @override
  String get evSelectOrg => 'تنظیم منتخب کریں';

  @override
  String get evRequestAccess => 'رسائی کی درخواست کریں';

  @override
  String get evSignIn => 'سائن اِن کریں';

  @override
  String get evTryAgain => 'دوبارہ کوشش کریں';

  @override
  String get errRetry => 'دوبارہ کوشش';

  @override
  String get osPending => 'زیر جائزہ';

  @override
  String get osVerified => 'تصدیق شدہ';

  @override
  String get osActive => 'فعال';

  @override
  String get osSuspended => 'معطل';

  @override
  String get osRejected => 'مسترد';

  @override
  String get osArchived => 'آرکائیو شدہ';

  @override
  String get porVerify => 'تصدیق کریں';

  @override
  String get porReject => 'مسترد کریں';

  @override
  String get porSuspend => 'معطل کریں';

  @override
  String get porReactivate => 'دوبارہ فعال کریں';

  @override
  String porReviewTitle(String a) {
    return 'تنظیم کو $a کریں؟';
  }

  @override
  String get porThisOrg => 'یہ تنظیم';

  @override
  String porReviewBody(String a, String b) {
    return '$a کو $b نشان زد کیا جائے گا۔';
  }

  @override
  String porMarked(String a) {
    return 'تنظیم کو $a نشان زد کر دیا گیا۔';
  }

  @override
  String get porUpdateFailed => 'تنظیم اپ ڈیٹ نہیں ہو سکی۔';

  @override
  String get porLoadFailed => 'تنظیمیں لوڈ نہیں ہو سکیں۔';

  @override
  String get porTitle => 'تمام تنظیمیں';

  @override
  String get porCheckingAccess => 'پلیٹ فارم کی رسائی چیک ہو رہی ہے…';

  @override
  String get porDeniedTitle => 'رسائی نہیں دی گئی';

  @override
  String get porVerifyAccessFailed =>
      'پلیٹ فارم منتظم کی رسائی کی تصدیق نہیں ہو سکی۔';

  @override
  String get porSuperAdminsOnly => 'یہ حصہ صرف پلیٹ فارم سپر ایڈمنز کے لیے ہے۔';

  @override
  String get porLoading => 'تنظیمیں لوڈ ہو رہی ہیں…';

  @override
  String get porEmptyTitle => 'ابھی کوئی تنظیم نہیں';

  @override
  String get porEmptyBody => 'پلیٹ فارم پر ابھی کوئی تنظیم رجسٹر نہیں ہوئی۔';

  @override
  String get porSearch => 'نام، ای میل یا شہر سے تلاش کریں';

  @override
  String get porClearSearch => 'تلاش صاف کریں';

  @override
  String get porShowing100 => '100 تازہ ترین تنظیمیں دکھائی جا رہی ہیں۔';

  @override
  String porNoMatch(String a) {
    return 'اس منظر میں \"$a\" سے کوئی تنظیم نہیں ملی۔';
  }

  @override
  String porNothingIn(String a) {
    return '\"$a\" میں کچھ نہیں۔';
  }

  @override
  String porRegistered(String a) {
    return 'رجسٹریشن: $a';
  }

  @override
  String get porArchivedNote =>
      'اس کے مالک نے حذف کر دی۔ کوئی نگرانی کی کارروائی دستیاب نہیں۔';

  @override
  String get porRejectedNote => 'مسترد۔ مزید کوئی کارروائی دستیاب نہیں۔';

  @override
  String get porCancel => 'منسوخ کریں';

  @override
  String get pfNeedsReview => 'جائزہ درکار';

  @override
  String get pfVerified => 'تصدیق شدہ';

  @override
  String get pfSuspended => 'معطل';

  @override
  String get pfClosed => 'آرکائیو / مسترد';

  @override
  String get pfAll => 'سب';

  @override
  String get paLoadFailed => 'پلیٹ فارم کا ڈیٹا لوڈ نہیں ہو سکا۔';

  @override
  String get paLoadMoreFailed => 'مزید صارفین لوڈ نہیں ہو سکے۔';

  @override
  String get paGrantTitle => 'پلیٹ فارم ایڈمن کی رسائی دیں';

  @override
  String get paEmailLabel => 'اکاؤنٹ کا ای میل ایڈریس';

  @override
  String get paEmailHint => 'name@example.com';

  @override
  String get paCancel => 'منسوخ کریں';

  @override
  String get paGrant => 'رسائی دیں';

  @override
  String paGranted(String a) {
    return '$a کو پلیٹ فارم ایڈمن کی رسائی دے دی گئی۔';
  }

  @override
  String get paGrantFailed => 'ایڈمن کی رسائی نہیں دی جا سکی۔';

  @override
  String get paThisAccount => 'یہ اکاؤنٹ';

  @override
  String get paRevokeTitle => 'پلیٹ فارم ایڈمن کی رسائی واپس لیں؟';

  @override
  String paRevokeBody(String a) {
    return '$a سے پلیٹ فارم سپر ایڈمن کے اختیارات ختم ہو جائیں گے۔';
  }

  @override
  String get paRevoke => 'واپس لیں';

  @override
  String get paRevoked => 'ایڈمن کی رسائی واپس لے لی گئی۔';

  @override
  String get paRevokeFailed => 'ایڈمن کی رسائی واپس نہیں لی جا سکی۔';

  @override
  String get paTitle => 'اکاؤنٹس اور رسائی';

  @override
  String get paChecking => 'پلیٹ فارم کی رسائی چیک ہو رہی ہے…';

  @override
  String get paDenied => 'رسائی نہیں دی گئی';

  @override
  String get paVerifyFailed => 'پلیٹ فارم منتظم کی رسائی کی تصدیق نہیں ہو سکی۔';

  @override
  String get paOnlySuper => 'یہ حصہ صرف پلیٹ فارم سپر ایڈمنز کے لیے ہے۔';

  @override
  String get paLoading => 'پلیٹ فارم کا ڈیٹا لوڈ ہو رہا ہے…';

  @override
  String get paAccounts => 'اکاؤنٹس';

  @override
  String get paGrantButton => 'ایڈمن کی رسائی دیں';

  @override
  String get paLoadMore => 'مزید لوڈ کریں';

  @override
  String get paStatUsers => 'صارفین';

  @override
  String get paStatOrgs => 'تنظیمیں';

  @override
  String get paStatPending => 'زیر جائزہ تنظیمیں';

  @override
  String get paStatActive => 'فعال تنظیمیں';

  @override
  String get paStatSuspended => 'معطل تنظیمیں';

  @override
  String get paStatMembers => 'اراکین';

  @override
  String get paStatActiveMembers => 'فعال اراکین';

  @override
  String get paStatEvents => 'انتخابات';

  @override
  String get paStatActiveEvents => 'فعال انتخابات';

  @override
  String get paNoEmail => '(ای میل نہیں)';

  @override
  String get paTagAdmin => 'پلیٹ فارم ایڈمن';

  @override
  String get paTagUnverified => 'غیر تصدیق شدہ';

  @override
  String get paTagDisabled => 'غیر فعال';

  @override
  String get plOverviewTitle => 'پلیٹ فارم کا جائزہ';

  @override
  String get plOverviewSubtitle =>
      'Kivora بھر کی تنظیمیں، جائزے اور منتظمین کی حالیہ سرگرمی۔';

  @override
  String get plRefresh => 'تازہ کریں';

  @override
  String get plPendingOne => '1 تنظیم جائزے کی منتظر ہے۔';

  @override
  String plPendingMany(String a) {
    return '$a تنظیمیں جائزے کی منتظر ہیں۔';
  }

  @override
  String get plReviewOrgs => 'تنظیموں کا جائزہ لیں';

  @override
  String get plReportsOne => '1 کھلی صارف رپورٹ۔';

  @override
  String plReportsMany(String a) {
    return '$a کھلی صارف رپورٹیں۔';
  }

  @override
  String get plOpenReports => 'رپورٹس کھولیں';

  @override
  String get plTotalsFailed => 'پلیٹ فارم کے مجموعے لوڈ نہیں ہو سکے۔';

  @override
  String get plStatOrgs => 'تنظیمیں';

  @override
  String get plStatWaiting => 'جائزے کی منتظر';

  @override
  String get plStatActive => 'فعال یا تصدیق شدہ';

  @override
  String get plStatSuspended => 'معطل';

  @override
  String get plStatAccounts => 'اکاؤنٹس';

  @override
  String get plStatMemberships => 'فعال رکنیتیں';

  @override
  String get plStatElections => 'انتخابات اور رائے شماریاں';

  @override
  String get plStatOpenNow => 'ووٹنگ ابھی کھلی ہے';

  @override
  String get plNeedsAttention => 'توجہ درکار';

  @override
  String get plChecksIncomplete =>
      'کچھ جانچ نہیں ہو سکی، اس لیے یہ فہرست نامکمل ہو سکتی ہے۔';

  @override
  String get plNothingAttention => 'اس وقت کسی چیز پر توجہ درکار نہیں۔';

  @override
  String get plRecentActivity => 'منتظمین کی حالیہ سرگرمی';

  @override
  String get plViewAll => 'سب دیکھیں';

  @override
  String get plUnavailable => 'دستیاب نہیں';

  @override
  String get plTryAgain => 'دوبارہ کوشش کریں';

  @override
  String get plActivityFailed => 'سرگرمی کا لاگ لوڈ نہیں ہو سکا۔';

  @override
  String get plNoActivity =>
      'ابھی تک منتظمین کی کوئی کارروائی ریکارڈ نہیں ہوئی۔';

  @override
  String get plTimeUnknown => 'وقت دستیاب نہیں';

  @override
  String plTarget(String a) {
    return 'ہدف: $a';
  }

  @override
  String plBy(String a) {
    return 'بذریعہ $a';
  }

  @override
  String get plAuditTitle => 'آڈٹ لاگ';

  @override
  String get plAuditSubtitle => 'پلیٹ فارم منتظمین کی کارروائیاں، نئی پہلے۔';

  @override
  String get plAuditLoading => 'آڈٹ لاگ لوڈ ہو رہا ہے…';

  @override
  String get plAuditFailed => 'آڈٹ لاگ لوڈ نہیں ہو سکا۔';

  @override
  String get plAuditEmptyTitle => 'ابھی کوئی اندراج نہیں';

  @override
  String get plAuditEmptyBody =>
      'پلیٹ فارم منتظمین کی کارروائیاں ہوتے ہی یہاں دکھائی دیں گی۔';

  @override
  String get plAuditNote =>
      'یہاں صرف مکمل ہونے والی کارروائیاں ریکارڈ ہوتی ہیں؛ ناکام کوششوں کا کوئی اندراج نہیں بنتا۔';

  @override
  String get plAuditSearch => 'کارروائی، شخص یا تنظیم سے تلاش کریں';

  @override
  String get plClearSearch => 'تلاش صاف کریں';

  @override
  String get plAllActions => 'تمام کارروائیاں';

  @override
  String get plEntryOne => '1 اندراج';

  @override
  String plEntryMany(String a) {
    return '$a اندراجات';
  }

  @override
  String get plNoEntryMatch => 'موجودہ فلٹرز سے کوئی اندراج نہیں ملا۔';

  @override
  String get plLoadOlder => 'پرانے اندراجات لوڈ کریں';

  @override
  String get plReportsTitle => 'صارف رپورٹس';

  @override
  String get plReportsSubtitle => 'مدد اور معاونت سے بھیجی گئی آراء اور مسائل۔';

  @override
  String get plReportsLoading => 'رپورٹس لوڈ ہو رہی ہیں…';

  @override
  String get plReportsFailed => 'رپورٹس لوڈ نہیں ہو سکیں۔';

  @override
  String get plReportsEmptyTitle => 'کوئی رپورٹ نہیں';

  @override
  String get plReportsEmptyBody => 'ابھی کسی نے رپورٹ نہیں بھیجی۔';

  @override
  String get plReportsReadOnly =>
      'فی الحال صرف پڑھنے کے لیے: پلیٹ فارم ابھی رپورٹس تفویض یا حل کرنے کی سہولت نہیں دیتا، اس لیے ہر رپورٹ کھلی رہتی ہے۔ نشان زد تنظیموں کی کوئی فہرست بھی نہیں۔';

  @override
  String plAllCount(String a) {
    return 'تمام ($a)';
  }

  @override
  String get plLoadOlderReports => 'پرانی رپورٹس لوڈ کریں';

  @override
  String get plNoSubject => '(کوئی موضوع نہیں)';

  @override
  String plReceiptRef(String a) {
    return 'رسید کا حوالہ: $a';
  }

  @override
  String get plShowLess => 'کم دکھائیں';

  @override
  String get plShowFull => 'پورا پیغام دکھائیں';

  @override
  String get plCatGeneral => 'عمومی رائے';

  @override
  String get plCatElection => 'انتخاب کا مسئلہ';

  @override
  String get plCatTechnical => 'تکنیکی مسئلہ';

  @override
  String get plCatAccount => 'اکاؤنٹ کا مسئلہ';

  @override
  String get plStatusOpen => 'کھلی';

  @override
  String get plCheckingAccess => 'پلیٹ فارم کی رسائی چیک ہو رہی ہے…';

  @override
  String get plDeniedTitle => 'رسائی نہیں دی گئی';

  @override
  String get plVerifyFailed => 'پلیٹ فارم منتظم کی رسائی کی تصدیق نہیں ہو سکی۔';

  @override
  String get plOnlySuper => 'یہ حصہ صرف پلیٹ فارم سپر ایڈمنز کے لیے ہے۔';

  @override
  String get msActive => 'فعال';

  @override
  String get msInactive => 'غیر فعال';

  @override
  String get msPending => 'زیر التوا';

  @override
  String get msSuspended => 'معطل';

  @override
  String get msRemoved => 'ہٹایا گیا';

  @override
  String get coTypeAcademic => 'تعلیمی ادارہ';

  @override
  String get coTypeCorporate => 'کارپوریٹ ادارہ';

  @override
  String get coTypeNonProfit => 'غیر منافع بخش تنظیم';

  @override
  String get coTypeClub => 'کلب / طلبہ سوسائٹی';

  @override
  String get coTypeCommunity => 'کمیونٹی ایسوسی ایشن';

  @override
  String get coTypeOther => 'دیگر';

  @override
  String get coCreated => 'تنظیم بن گئی اور تصدیق ہو گئی!';

  @override
  String get coClose => 'بند کریں';

  @override
  String get coTitle => 'تنظیم بنائیں';

  @override
  String get coSubtitle =>
      'اپنی کمیونٹی کو لوگوں، شعبوں اور سرگرمیوں کے لیے مشترکہ جگہ دیں۔';

  @override
  String get coNameLabel => 'تنظیم کا نام *';

  @override
  String get coNameHint => 'مثلاً آپ کی کمیونٹی یا کمپنی';

  @override
  String get coNameField => 'تنظیم کا نام';

  @override
  String get coNameShort => 'نام کم از کم 2 حروف کا ہونا چاہیے';

  @override
  String get coNameLong => 'نام 80 حروف سے زیادہ نہیں ہو سکتا';

  @override
  String get coNameHelp =>
      'ایسا نام رکھیں جسے آپ کے اراکین پہچانیں۔ 2 سے 80 حروف۔';

  @override
  String get coTypeLabel => 'تنظیم کی قسم *';

  @override
  String get coTypeHint => 'قسم منتخب کریں';

  @override
  String get coCityLabel => 'شہر (اختیاری)';

  @override
  String get coCityHint => 'شہر درج کریں';

  @override
  String get coCountryLabel => 'ملک (اختیاری)';

  @override
  String get coCountryHint => 'ملک منتخب کریں';

  @override
  String get coVerifiedTitle => 'فوراً تصدیق، آپ مالک ہوں گے';

  @override
  String get coVerifiedBody =>
      'چونکہ آپ کے اکاؤنٹ کا ای میل تصدیق شدہ ہے، آپ کی تنظیم پہلے سے تصدیق شدہ بنتی ہے - دستی جائزے کی ضرورت نہیں۔ اس کے فوراً بعد اپنی ورک اسپیس، برانڈنگ اور شمولیت کے کوڈ ترتیب دیں۔';

  @override
  String get coRequired => '* تنظیم بنانے کے لیے ضروری خانے مکمل کریں۔';

  @override
  String get coCancel => 'منسوخ کریں';

  @override
  String get coCreate => 'تنظیم بنائیں';

  @override
  String joJoined(String a) {
    return '$a میں کامیابی سے شامل ہو گئے!';
  }

  @override
  String get joClose => 'بند کریں';

  @override
  String get joTitle => 'کوڈ سے تنظیم میں شامل ہوں';

  @override
  String get joSubtitle =>
      'اپنی ورک اسپیس تلاش کرنے کے لیے تنظیم کے مالک کا دیا ہوا شمولیت کا کوڈ درج کریں۔';

  @override
  String get joCodeLabel => 'شمولیت کا کوڈ';

  @override
  String get joCodeHint => 'اپنا شمولیت کا کوڈ درج کریں';

  @override
  String get joCodeField => 'شمولیت کا کوڈ';

  @override
  String get joCodeHelp =>
      'پورا کوڈ بالکل ویسے ہی چسپاں کریں جیسے آپ کو دیا گیا۔';

  @override
  String get joScan => 'اس کی جگہ QR کوڈ اسکین کریں';

  @override
  String get joNoCode => 'کوڈ نہیں ہے؟';

  @override
  String get joNoCodeBody =>
      'اپنی تنظیم کے مالک سے مانگیں۔ اگر کوڈ غلط یا ختم ہو چکا ہو تو نیا کوڈ مانگیں۔';

  @override
  String get joReviewNote =>
      'شمولیت کی تصدیق سے پہلے آپ تنظیم کا جائزہ لیں گے۔';

  @override
  String get joCancel => 'منسوخ کریں';

  @override
  String get joFind => 'تنظیم تلاش کریں';

  @override
  String get joConfirmTitle => 'کیا یہ آپ کی تنظیم ہے؟';

  @override
  String get joConfirmBody =>
      'جاری رکھنے سے پہلے تصدیق کریں کہ یہی وہ ورک اسپیس ہے جس میں آپ شامل ہونا چاہتے ہیں۔';

  @override
  String get joVerified => 'تصدیق شدہ';

  @override
  String get joPending => 'تصدیق زیر التوا';

  @override
  String get joDifferent => 'دوسرا کوڈ استعمال کریں';

  @override
  String joJoin(String a) {
    return '$a میں شامل ہوں';
  }

  @override
  String get imCreatedTitle => 'دعوت بن گئی';

  @override
  String imCreatedBody(String a) {
    return '$a کے لیے دعوت بنائی گئی۔';
  }

  @override
  String get imCreatedNote =>
      'مدعو شخص لاگ اِن کے بعد Kivora کی اطلاعات میں اسے دیکھے گا۔ وہیں سے قبول یا مسترد کر سکتا ہے۔';

  @override
  String get imShareLink => 'یہ براہِ راست لنک مدعو شخص کو بھیجیں:';

  @override
  String get imDone => 'مکمل';

  @override
  String get imTitle => 'رکن کو مدعو کریں';

  @override
  String get imClose => 'بند کریں';

  @override
  String get imSubtitle => 'کسی کو اپنی ورک اسپیس میں شامل ہونے کی دعوت دیں۔';

  @override
  String get imEmailLabel => 'وصول کنندہ کا ای میل ایڈریس *';

  @override
  String get imEmailHint => 'voter@organization.com';

  @override
  String imOrg(String a) {
    return 'تنظیم: $a';
  }

  @override
  String get imRole => 'کردار کی اجازت';

  @override
  String get imRoleMember => 'رکن';

  @override
  String get imRoleAdmin => 'منتظم';

  @override
  String get imCancel => 'منسوخ کریں';

  @override
  String get imSend => 'دعوت بھیجیں';

  @override
  String get aeTitle => 'موجودہ رکن شامل کریں';

  @override
  String get aeClose => 'بند کریں';

  @override
  String get aeSubtitle =>
      'ایک تصدیق شدہ Kivora اکاؤنٹ کو براہِ راست اس تنظیم میں شامل کریں۔';

  @override
  String get aeEmailLabel => 'رکن کا ای میل ایڈریس *';

  @override
  String get aeEmailHint => 'user@example.com';

  @override
  String get aeEmailInvalid => 'درست ای میل ایڈریس درج کریں۔';

  @override
  String get aeCancel => 'منسوخ کریں';

  @override
  String get aeAdd => 'رکن شامل کریں';

  @override
  String get adAssigned => 'رکن کامیابی سے شامل ہو گیا۔';

  @override
  String adFailed(String a) {
    return 'رکن کو شامل نہیں کیا جا سکا: $a';
  }

  @override
  String get adTitle => 'شعبے میں رکن شامل کریں';

  @override
  String get adClose => 'بند کریں';

  @override
  String get adSearchLabel => 'فعال اراکین تلاش کریں';

  @override
  String get adSearchHint => 'نام یا ای میل لکھیں...';

  @override
  String get adNone => 'کوئی اہل فعال رکن نہیں ملا۔';

  @override
  String get adUnknown => 'نامعلوم صارف';

  @override
  String adCurrentlyIn(String a, String b) {
    return '$a • اس وقت $b میں';
  }

  @override
  String adAddTo(String a) {
    return '$a کو اس شعبے میں شامل کریں';
  }

  @override
  String get mpCancel => 'منسوخ کریں';

  @override
  String get mpUser => 'صارف';

  @override
  String get mpNone => 'کوئی نہیں';

  @override
  String get mpRole => 'کردار';

  @override
  String get mpStatus => 'حیثیت';

  @override
  String get mpDepartment => 'شعبہ';

  @override
  String get mpObserver => 'مبصر کی رسائی';

  @override
  String get mpGranted => 'دی گئی';

  @override
  String get mpPromote => 'منتظم بنائیں';

  @override
  String get mpPromoted => 'کامیابی سے منتظم بنا دیا گیا۔';

  @override
  String get mpDemote => 'رکن کے درجے پر لائیں';

  @override
  String get mpDemoted => 'کامیابی سے رکن کے درجے پر لایا گیا۔';

  @override
  String get mpGrantObserver => 'مبصر کی رسائی دیں';

  @override
  String get mpGrantedDone => 'مبصر کی رسائی دے دی گئی۔';

  @override
  String get mpRevokeObserver => 'مبصر کی رسائی واپس لیں';

  @override
  String get mpRevokedDone => 'مبصر کی رسائی واپس لے لی گئی۔';

  @override
  String get mpDeactivate => 'رکن کو غیر فعال کریں';

  @override
  String get mpDeactivated => 'رکن کامیابی سے غیر فعال ہو گیا۔';

  @override
  String get mpReactivate => 'رکن کو دوبارہ فعال کریں';

  @override
  String get mpReactivated => 'رکن دوبارہ فعال ہو گیا۔';

  @override
  String get mpRemove => 'رکن کو ہٹائیں';

  @override
  String mpRemoveTitle(String a) {
    return '$a کو ہٹائیں؟';
  }

  @override
  String get mpRemoveBody => 'وہ اس تنظیم تک رسائی فوراً کھو دیں گے۔';

  @override
  String get mpRemoved => 'رکن کو تنظیم سے ہٹا دیا گیا۔';

  @override
  String get mpClose => 'بند کریں';

  @override
  String get imOrgLabel => 'تنظیم';
}
