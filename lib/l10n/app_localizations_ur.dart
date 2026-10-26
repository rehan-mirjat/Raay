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

  @override
  String get vtCandidate => 'امیدواروں کا انتخاب';

  @override
  String get vtSingleChoice => 'واحد انتخاب کی رائے شماری';

  @override
  String get vtYesNo => 'ہاں/نہیں رائے شماری';

  @override
  String get etAll => 'تمام فعال اراکین';

  @override
  String get etMembers => 'منتخب اراکین';

  @override
  String get etDepartments => 'منتخب شعبے';

  @override
  String get ccLoadError =>
      'ہم کمانڈ سینٹر لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get ccNoOrgTitle => 'کوئی فعال تنظیم نہیں';

  @override
  String get ccNoOrgBody => 'کمانڈ سینٹر دیکھنے کے لیے ایک تنظیم منتخب کریں۔';

  @override
  String get ccAdminTitle => 'منتظم کی رسائی درکار ہے';

  @override
  String get ccAdminBody =>
      'انتخابی کمانڈ سینٹر تنظیم کے مالکان اور منتظمین کے لیے ہے۔';

  @override
  String get ccElectionsError =>
      'ہم انتخابات لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get ccTitle => 'انتخابی کمانڈ سینٹر';

  @override
  String get ccSearch => 'تلاش';

  @override
  String get ccFilterDate => 'تاریخ کی حد سے فلٹر کریں';

  @override
  String get ccCreate => 'انتخاب بنائیں';

  @override
  String get ccSuspended =>
      'یہ تنظیم معطل ہے۔ بحال ہونے تک انتخابات کا انتظام بند ہے۔';

  @override
  String get ccActiveTitle => 'فعال انتخابات کی نگرانی';

  @override
  String get ccActiveNone => 'اس وقت کوئی انتخاب فعال نہیں۔';

  @override
  String get ccUpcomingTitle => 'آنے والے انتخابات کا شیڈول';

  @override
  String get ccUpcomingNone => 'کوئی انتخاب شیڈول نہیں۔';

  @override
  String get ccAlerts => 'الرٹس';

  @override
  String ccNoVoters(String a) {
    return '\"$a\" کے لیے کوئی اہل ووٹر مقرر نہیں۔';
  }

  @override
  String get ccTasks => 'زیر التوا انتظامی کام';

  @override
  String get ccTasksNone => 'کوئی زیر التوا کام نہیں۔ سب کچھ مکمل ہے۔';

  @override
  String ccDraft(String a) {
    return '\"$a\" ابھی مسودہ ہے اور شائع کرنے سے پہلے جائزے کی ضرورت ہے۔';
  }

  @override
  String get ccInviteOne => '1 دعوت جواب کی منتظر ہے۔';

  @override
  String ccInviteMany(String a) {
    return '$a دعوتیں جواب کی منتظر ہیں۔';
  }

  @override
  String get ccMembership => 'رکنیت اور دعوتیں';

  @override
  String get ccTotalMembers => 'کل اراکین';

  @override
  String get ccPendingInvites => 'زیر التوا دعوتیں';

  @override
  String get ccRecent => 'حالیہ انتظامی سرگرمی';

  @override
  String get ccExport => 'رپورٹ ایکسپورٹ کریں (CSV)';

  @override
  String get ccStatTotal => 'کل انتخابات';

  @override
  String get ccStatActive => 'فعال';

  @override
  String get ccStatScheduled => 'شیڈول';

  @override
  String get ccStatClosed => 'بند';

  @override
  String get ccStatMembers => 'اراکین';

  @override
  String get ccStatMembersSub => 'تنظیم کے تمام اراکین';

  @override
  String get ccNoActivity => 'کوئی حالیہ سرگرمی نہیں۔';

  @override
  String get ccMonitor => 'نگرانی';

  @override
  String get ccTurnoutUnknown => 'براہِ راست شرکت کی شرح دستیاب نہیں';

  @override
  String ccTurnout(String a, String b, String c) {
    return '$b میں سے $a نے ووٹ دیا ($c%)';
  }

  @override
  String get biTemplateTitle => 'انتخاب کا سانچہ منتخب کریں';

  @override
  String get biTemplateBody =>
      'انتخاب بنانا تیز کرنے کے لیے پہلے سے تیار سانچہ منتخب کریں۔';

  @override
  String get biT1Name => 'ایگزیکٹو / بورڈ کا انتخاب';

  @override
  String get biT1Sub => 'امیدواروں کا انتخاب • گمنام بیلٹ';

  @override
  String get biT1Title => 'ایگزیکٹو بورڈ کا انتخاب';

  @override
  String get biT1Desc =>
      'ایگزیکٹو بورڈ کے نمائندے منتخب کرنے کا سالانہ انتخاب۔ بیلٹ مکمل طور پر گمنام ہیں۔';

  @override
  String get biT2Name => 'پالیسی / قرارداد پر ووٹ';

  @override
  String get biT2Sub => 'ہاں/نہیں رائے شماری • گمنام بیلٹ';

  @override
  String get biT2Title => 'تنظیم کی پالیسی کی قرارداد';

  @override
  String get biT2Desc =>
      'تنظیم کے ضوابط میں مجوزہ ترمیم پر ووٹ دیں۔ ووٹ دینے سے پہلے منسلک دستاویزات کا جائزہ لیں۔';

  @override
  String get biT3Name => 'کمیونٹی کی رائے شماری';

  @override
  String get biT3Sub => 'واحد انتخاب کی رائے شماری • شناخت کے ساتھ';

  @override
  String get biT3Title => 'کمیونٹی کی رائے کا سروے';

  @override
  String get biT3Desc =>
      'آنے والے اقدامات پر کمیونٹی کی رائے جمع کرنے کا مختصر سروے۔';

  @override
  String get biLocked =>
      'انتخاب اب مسودہ نہیں رہا۔ بنیادی معلومات تبدیل نہیں ہو سکتیں۔';

  @override
  String get biTitle => 'انتخاب کی تفصیلات';

  @override
  String get biSubtitle => 'اپنے انتخاب کی بنیادی معلومات فراہم کریں۔';

  @override
  String get biUseTemplate => 'سانچہ استعمال کریں';

  @override
  String get biTitleLabel => 'انتخاب کا عنوان *';

  @override
  String get biTitleHint => 'مثلاً سالانہ ٹیم کا انتخاب';

  @override
  String get biTitleInvalid => 'عنوان 3 سے 100 حروف کا ہونا چاہیے۔';

  @override
  String get biDescLabel => 'تفصیل *';

  @override
  String get biDescHint =>
      'اس انتخاب کا مقصد، پس منظر اور اہم تفصیلات بیان کریں...';

  @override
  String get biDescRequired => 'تفصیل ضروری ہے۔';

  @override
  String get biDescLong => 'تفصیل 500 حروف سے زیادہ نہیں ہو سکتی۔';

  @override
  String get biVotingType => 'ووٹنگ کی قسم';

  @override
  String get biTypeCandidate => 'امیدواروں کا انتخاب';

  @override
  String get biTypeCandidateSub =>
      'ووٹر فہرست میں سے ایک امیدوار منتخب کرتے ہیں۔';

  @override
  String get biTypeSingle => 'واحد انتخاب کی رائے شماری';

  @override
  String get biTypeSingleSub => 'ووٹر فہرست میں سے ایک آپشن منتخب کرتے ہیں۔';

  @override
  String get biTypeYesNo => 'ہاں/نہیں رائے شماری';

  @override
  String get biTypeYesNoSub => 'ووٹر کسی تجویز کو منظور یا مسترد کرتے ہیں۔';

  @override
  String get biPrivacy => 'بیلٹ کی رازداری';

  @override
  String get biAnonymous => 'گمنام';

  @override
  String get biIdentifiable => 'شناخت کے ساتھ';

  @override
  String get biAnonymousNote => 'ووٹر کی شناخت بیلٹ سے الگ رکھی جاتی ہے۔';

  @override
  String get biIdentifiableNote =>
      'ہر بیلٹ ووٹر کے اکاؤنٹ سے منسلک ہوتا ہے۔ ووٹر تصدیق سے پہلے یہ نوٹس دیکھیں گے۔';

  @override
  String get biNext => 'اگلا: شیڈول';

  @override
  String get elLocked =>
      'انتخاب اب مسودہ نہیں رہا۔ اہلیت کی ترتیب تبدیل نہیں ہو سکتی۔';

  @override
  String get elTitle => 'ووٹر کی اہلیت';

  @override
  String get elWho => 'کون ووٹ دے سکتا ہے؟';

  @override
  String get elAll => 'تمام فعال اراکین';

  @override
  String get elDepts => 'منتخب شعبے';

  @override
  String get elMembers => 'منتخب اراکین';

  @override
  String get elBack => 'واپس';

  @override
  String get elCreateDraft => 'مسودہ بنائیں اور جاری رکھیں';

  @override
  String get elNext => 'اگلا: انتخابات کے آپشن';

  @override
  String get elListError =>
      'ہم یہ فہرست لوڈ نہیں کر سکے۔ واپس جا کر دوبارہ کوشش کریں۔';

  @override
  String get elNoDepts => 'اس تنظیم میں کوئی شعبہ نہیں ملا۔';

  @override
  String get elNoMembers => 'کوئی فعال رکن نہیں ملا۔';

  @override
  String elSelected(String a, String b) {
    return '$b فعال اراکین میں سے $a منتخب';
  }

  @override
  String get elCsv => 'CSV سے بڑی تعداد میں درآمد';

  @override
  String get rvPublishTitle => 'یہ انتخاب شائع کریں؟';

  @override
  String get rvPublishBody =>
      'اہل اراکین اسے شیڈول کے مطابق دیکھیں گے۔ شائع کرنے کے بعد آپ اس کی تفصیلات، شیڈول یا اہلیت نہیں بدل سکیں گے۔';

  @override
  String get rvKeepEditing => 'ترمیم جاری رکھیں';

  @override
  String get rvPublish => 'شائع کریں';

  @override
  String get rvPublished => 'انتخاب شائع ہو گیا۔';

  @override
  String get rvReauth =>
      'سیکیورٹی کے لیے، انتخاب شائع کرنے کے لیے آپ کا پچھلے 15 منٹ میں سائن اِن ہونا ضروری ہے۔ جاری رکھنے کے لیے اپنی شناخت کی تصدیق کریں۔';

  @override
  String get rvPublishFailed => 'ہم انتخاب شائع نہیں کر سکے۔ دوبارہ کوشش کریں۔';

  @override
  String get rvChoicesError =>
      'ہم آپشنز لوڈ نہیں کر سکے۔ واپس جا کر دوبارہ کوشش کریں۔';

  @override
  String get rvCheckTitle => 'عنوان مقرر ہے';

  @override
  String get rvCheckDesc => 'تفصیل شامل ہے';

  @override
  String get rvCheckSchedule => 'ووٹنگ کا وقت مقرر ہے';

  @override
  String get rvCheckPrivacyId => 'رازداری کا طریقہ مقرر (شناخت کے ساتھ)';

  @override
  String get rvCheckPrivacyAnon => 'رازداری کا طریقہ مقرر (گمنام)';

  @override
  String rvCheckChoices(String a) {
    return 'امیدوار/آپشنز مقرر ($a)';
  }

  @override
  String rvCheckEligibility(String a) {
    return 'اہلیت کے اصول درست ($a)';
  }

  @override
  String get rvTitle => 'جائزہ اور اشاعت';

  @override
  String get rvChecklist => 'انتخاب کی تیاری کی فہرست';

  @override
  String get rvTitleLabel => 'عنوان';

  @override
  String get rvStart => 'آغاز';

  @override
  String get rvEnd => 'اختتام';

  @override
  String get rvChoices => 'آپشنز';

  @override
  String rvItems(String a) {
    return '$a آئٹم مقرر';
  }

  @override
  String get rvIncomplete =>
      'شائع کرنے سے پہلے اوپر کی فہرست کے تمام ضروری آئٹم مکمل کریں۔';

  @override
  String get rvBack => 'واپس';

  @override
  String get rvPublishButton => 'انتخاب شائع کریں';

  @override
  String get rvOptional => ' (اختیاری)';

  @override
  String get scRequired => 'آغاز اور اختتام کا وقت ضروری ہے۔';

  @override
  String get scPast => 'آغاز کا وقت ماضی میں نہیں ہو سکتا۔';

  @override
  String get scShort => 'ووٹنگ کی مدت کم از کم 5 منٹ ہونی چاہیے۔';

  @override
  String get scLocked => 'انتخاب اب مسودہ نہیں رہا۔ شیڈول تبدیل نہیں ہو سکتا۔';

  @override
  String get scTitle => 'ووٹنگ کا شیڈول';

  @override
  String scZoneNote(String a) {
    return 'اوقات آپ کے ٹائم زون میں درج ہوتے ہیں: $a۔ تمام اوقات کی جانچ محفوظ طریقے سے سرور کی گھڑی کے مطابق ہوتی ہے۔';
  }

  @override
  String get scStartTime => 'آغاز کا وقت';

  @override
  String get scNotSet => 'مقرر نہیں';

  @override
  String get scEndTime => 'اختتام کا وقت';

  @override
  String get scBack => 'واپس';

  @override
  String get scNext => 'اگلا: اہلیت';

  @override
  String get obTitle => 'مبصر ڈیش بورڈ';

  @override
  String get obTransparency => 'اعتماد اور شفافیت کا مرکز';

  @override
  String get obLoadError =>
      'ہم یہ منظر لوڈ نہیں کر سکے۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get obNoOrgTitle => 'کوئی فعال تنظیم نہیں';

  @override
  String get obNoOrgBody => 'مبصر ڈیش بورڈ دیکھنے کے لیے ایک تنظیم منتخب کریں۔';

  @override
  String get obAccessTitle => 'مبصر کی رسائی درکار ہے';

  @override
  String get obAccessBody =>
      'یہ ڈیش بورڈ صرف ان اراکین کے لیے ہے جنہیں تنظیم کے منتظم نے مبصر کی رسائی دی ہو۔';

  @override
  String get obNoElectionsTitle => 'ابھی کوئی انتخاب نہیں';

  @override
  String get obNoElectionsBody =>
      'اس تنظیم میں ابھی کوئی شائع شدہ انتخاب نہیں۔';

  @override
  String obNote(String a) {
    return 'آپ کو $a تک صرف پڑھنے والی مبصر رسائی حاصل ہے۔ آپ صرف تنظیم بھر کے مجموعی اعداد دیکھتے ہیں، انفرادی بیلٹ، ووٹرز کی شناخت یا شعبہ وار تفصیل کبھی نہیں۔';
  }

  @override
  String get obActive => 'فعال انتخابات';

  @override
  String get obTimeline => 'انتخابات کا ٹائم لائن';

  @override
  String get obTurnoutUnknown => 'مجموعی شرکت کی شرح دستیاب نہیں';

  @override
  String obTurnout(String a, String b, String c) {
    return '$b اہل ووٹرز میں سے $a ($c%)';
  }

  @override
  String vpWelcomeNamed(String a) {
    return 'خوش آمدید، $a';
  }

  @override
  String get vpWelcome => 'خوش آمدید';

  @override
  String get vpReadyOne => '1 انتخاب آپ کے ووٹ کے لیے کھلا ہے۔';

  @override
  String vpReadyMany(String a) {
    return '$a انتخابات آپ کے ووٹ کے لیے کھلے ہیں۔';
  }

  @override
  String get vpAllCaughtUp =>
      'سب کچھ مکمل ہے۔ آپ کے ووٹ کا کوئی انتظار نہیں کر رہا۔';

  @override
  String get vpYourWorkspace => 'آپ کی ووٹنگ ورک اسپیس';

  @override
  String get vpOpenFirst => 'میرے بیلٹ پر جائیں';

  @override
  String get gsHome => 'ہوم';

  @override
  String get gsHomeSub => 'ڈیش بورڈ';

  @override
  String get gsOrgs => 'تنظیمیں';

  @override
  String get gsOrgsSub => 'آپ کی ورک اسپیسز';

  @override
  String get gsEvents => 'انتخابات';

  @override
  String get gsEventsSub => 'ووٹنگ کے انتخابات سنبھالیں';

  @override
  String get gsMembers => 'اراکین کی ڈائریکٹری';

  @override
  String get gsMembersSub => 'تنظیم کے اراکین دیکھیں';

  @override
  String get gsDepts => 'شعبہ جات';

  @override
  String get gsDeptsSub => 'شعبے سنبھالیں';

  @override
  String get gsAccount => 'اکاؤنٹ کی ترتیبات';

  @override
  String get gsAccountSub => 'پروفائل اور سیکیورٹی';

  @override
  String get gsAudit => 'آڈٹ لاگ';

  @override
  String get gsAuditSub => 'تنظیم کی سرگرمی';

  @override
  String get gsInvites => 'دعوت نامے';

  @override
  String get gsInvitesSub => 'زیر التوا تنظیمی دعوتیں';

  @override
  String get gsOrganization => 'تنظیم';

  @override
  String gsVotingEvent(String a) {
    return 'ووٹنگ کا انتخاب · $a';
  }

  @override
  String get gsSearchLabel => 'تلاش';

  @override
  String get gsSearchHint => 'انتخابات، اراکین، تنظیمیں تلاش کریں…';

  @override
  String get gsEsc => 'ESC';

  @override
  String gsNoResults(String a) {
    return '\"$a\" کے لیے کوئی نتیجہ نہیں';
  }

  @override
  String get authTagline => 'تنظیموں کے لیے محفوظ ووٹنگ';

  @override
  String aiWelcome(String a) {
    return '$a میں خوش آمدید!';
  }

  @override
  String get aiTheOrg => 'تنظیم';

  @override
  String get alBadge => 'رازداری کا خیال رکھنے والی ووٹنگ';

  @override
  String get alHeadline => 'آپ کی آواز،\nآپ کا انتخاب۔';

  @override
  String get alSub => 'تنظیموں کے لیے محفوظ، شفاف اور جدید\nای ووٹنگ۔';

  @override
  String get alP1 => 'سرور سے مجاز ووٹنگ';

  @override
  String get alP1b =>
      'بیلٹ کی تصدیق اور ریکارڈنگ قابلِ اعتماد بیک اینڈ سروسز کرتی ہیں۔';

  @override
  String get alP2 => 'رازداری کا خیال رکھنے والے بیلٹ';

  @override
  String get alP2b => 'گمنام بیلٹ شرکت کے ریکارڈ سے الگ رکھے جاتے ہیں۔';

  @override
  String get alP3 => 'شرکت کی واضح رسیدیں';

  @override
  String get alP3b => 'اپنے انتخاب کو ظاہر کیے بغیر شرکت کی تصدیق کریں۔';

  @override
  String get alCopy => 'Kivora © 2026';

  @override
  String get alPlatforms => 'Android • ویب';

  @override
  String get osTitle => 'تنظیم تبدیل کریں';

  @override
  String get osBody => 'وہ ورک اسپیس منتخب کریں جس میں آپ کام کرنا چاہتے ہیں۔';

  @override
  String get osLoadError => 'آپ کی تنظیمیں لوڈ نہیں ہو سکیں۔';

  @override
  String get osRetry => 'دوبارہ کوشش کریں';

  @override
  String get osNone => 'کوئی شامل کردہ تنظیم نہیں ملی۔';

  @override
  String get osJoin => 'کوڈ سے تنظیم میں شامل ہوں';

  @override
  String get osCreate => 'نئی تنظیم بنائیں';

  @override
  String get osInvites => 'دعوت نامے دیکھیں';

  @override
  String get osRetry2 => 'دوبارہ کوشش';

  @override
  String get osSelect => 'تنظیم منتخب کریں';

  @override
  String get osCurrentLabel => 'موجودہ تنظیم';

  @override
  String get osCurrent => 'موجودہ تنظیم';

  @override
  String get osSwitchTo => 'اس تنظیم پر جائیں';

  @override
  String get aiMissing => 'یہ دعوتی لنک غائب یا خراب ہے۔';

  @override
  String get aiInvited => 'آپ کو مدعو کیا گیا ہے';

  @override
  String get aiInvitedBody =>
      'جس ای میل سے آپ سائن اِن ہیں اسی سے اس تنظیم میں شامل ہونے کے لیے قبول کریں۔';

  @override
  String get aiNotNow => 'ابھی نہیں';

  @override
  String get aiAccept => 'دعوت قبول کریں';

  @override
  String get aiAccepting => 'دعوت قبول ہو رہی ہے…';

  @override
  String get aiJoinedBody =>
      'آپ کامیابی سے شامل ہو گئے۔ آپ فوراً دیکھنا شروع کر سکتے ہیں۔';

  @override
  String get aiContinue => 'جاری رکھیں';

  @override
  String get aiFailedTitle => 'یہ دعوت قبول نہیں ہو سکی';

  @override
  String get aiFailedBody => 'کچھ غلط ہو گیا۔ دوبارہ کوشش کریں۔';

  @override
  String get aiHome => 'ہوم پر جائیں';

  @override
  String get shCalendar => 'انتخابی کیلنڈر';

  @override
  String get shLight => 'روشن موڈ پر جائیں';

  @override
  String get shDark => 'گہرے موڈ پر جائیں';

  @override
  String get shSearch => 'تلاش';

  @override
  String get shNotifications => 'اطلاعات';

  @override
  String get shMarkRead => 'سب پڑھا ہوا نشان زد کریں';

  @override
  String get shNoNotifications => 'کوئی نئی اطلاع نہیں';

  @override
  String get shOrganization => 'تنظیم';

  @override
  String shInvitedTo(String a) {
    return '$a میں شامل ہونے کی دعوت';
  }

  @override
  String shRoleAction(String a) {
    return 'کردار: $a • کارروائی درکار';
  }

  @override
  String get shViewAll => 'تمام اطلاعات دیکھیں';

  @override
  String get shAccountMenu => 'اکاؤنٹ مینو';

  @override
  String shAccountRole(String a) {
    return 'اکاؤنٹ $a';
  }

  @override
  String get shAccountUser => 'اکاؤنٹ صارف';

  @override
  String get shAccountSettings => 'اکاؤنٹ کی ترتیبات';

  @override
  String get shHelp => 'مدد اور معاونت';

  @override
  String get shBilling => 'پلانز اور بلنگ';

  @override
  String get shTrust => 'اعتماد اور شفافیت';

  @override
  String get shPlatformAdmin => 'پلیٹ فارم ایڈمن';

  @override
  String get shOrganizations => 'تنظیمیں';

  @override
  String get shLogout => 'لاگ آؤٹ';

  @override
  String get hsThanks => 'آپ کی رائے کا شکریہ! ہمیں آپ کا پیغام مل گیا ہے۔';

  @override
  String get hsFailed =>
      'رائے نہیں بھیجی جا سکی۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get hsTitle => 'مدد اور معاونت';

  @override
  String get hsFaq => 'اکثر پوچھے جانے والے سوالات';

  @override
  String get hsQ1 => 'میں اپنا ووٹ کیسے دوں؟';

  @override
  String get hsA1 =>
      'اپنی تنظیم کے ڈیش بورڈ سے کوئی فعال انتخاب منتخب کریں اور اسکرین کی ہدایات پر عمل کریں۔';

  @override
  String get hsQ2 => 'کیا میرا ووٹ گمنام ہے؟';

  @override
  String get hsA2 =>
      'گمنام انتخاب میں آپ کا انتخاب کبھی آپ کے اکاؤنٹ سے نہیں جوڑا جاتا - نظام یہ تصدیق کر سکتا ہے کہ آپ نے ووٹ دیا بغیر یہ ریکارڈ کیے کہ آپ نے کیا چنا۔ شناخت والے انتخابات ووٹ سے پہلے واضح طور پر نشان زد ہوتے ہیں۔ آپ کی رسید کیا ثابت کرتی ہے اور کیا نہیں، اس کی تفصیل کے لیے اعتماد اور شفافیت کا مرکز دیکھیں۔';

  @override
  String get hsQ3 => 'میں اپنی پروفائل کی معلومات کیسے بدلوں؟';

  @override
  String get hsA3 =>
      'اپنی ذاتی تفصیلات اپ ڈیٹ کرنے کے لیے اوپر دائیں پروفائل مینو سے اکاؤنٹ کی ترتیبات کے صفحے پر جائیں۔';

  @override
  String get hsGuidance => 'مدد اور رہنمائی';

  @override
  String get hsVerify => 'رسید کی تصدیق کریں';

  @override
  String get hsVerifyBody =>
      'جانچیں کہ بیلٹ کی رسید ریکارڈ ہوئی۔ اس سے کبھی ظاہر نہیں ہوتا کہ کسی نے کیسے ووٹ دیا۔';

  @override
  String get hsTrust => 'اعتماد اور شفافیت';

  @override
  String get hsTrustBody =>
      'Kivora بیلٹ کی رازداری کیسے محفوظ رکھتا ہے اور کیا ریکارڈ ہوتا ہے۔';

  @override
  String get hsSend => 'رائے بھیجیں یا معاونت سے رابطہ کریں';

  @override
  String get hsCategory => 'زمرہ';

  @override
  String get hsSubject => 'موضوع';

  @override
  String get hsSubjectHint => 'یہ کس بارے میں ہے؟';

  @override
  String get hsSubjectField => 'موضوع';

  @override
  String get hsReceipt => 'رسید کی آئی ڈی (اختیاری)';

  @override
  String get hsReceiptHint =>
      'اگر یہ کسی خاص ووٹ سے متعلق ہے تو رسید کی آئی ڈی چسپاں کریں';

  @override
  String get hsReceiptNote =>
      'یہاں اپنا بیلٹ کا انتخاب کبھی نہ لکھیں - رسید صرف تصدیق کرتی ہے کہ آپ کا ووٹ ریکارڈ ہوا، یہ ظاہر نہیں کرتی کہ آپ نے کیا چنا۔';

  @override
  String get hsMessage => 'پیغام';

  @override
  String get hsMessageHint => 'اپنا مسئلہ بیان کریں یا اپنی رائے دیں...';

  @override
  String get hsMessageField => 'پیغام';

  @override
  String get hsSending => 'بھیجا جا رہا ہے...';

  @override
  String get hsSendButton => 'پیغام بھیجیں';

  @override
  String get rvfTitle => 'عوامی رسید کی تصدیق';

  @override
  String get rvfHeading => 'بیلٹ کی رسید کی تصدیق کریں';

  @override
  String get rvfIntro =>
      'اپنی رسید کا ہیش درج کریں تاکہ تصدیق ہو سکے کہ سرور نے اسے ریکارڈ کیا۔ یہ صرف جانچتا ہے کہ مماثل رسید موجود ہے۔ اس سے ظاہر نہیں ہوتا کہ کسی نے کیسے ووٹ دیا، اور یہ حتمی گنتی میں شمولیت کا آزادانہ ثبوت نہیں۔';

  @override
  String get rvfHashLabel => 'رسید کا ہیش';

  @override
  String get rvfHashHint => '64 حروف کا ہیش (حروف a-f اور ہندسے)';

  @override
  String get rvfVerify => 'رسید کی تصدیق کریں';

  @override
  String get rvfOkTitle => 'رسید کی تصدیق ہو گئی';

  @override
  String get rvfOkBody =>
      'مماثل رسید ملی، یعنی سرور نے یہ بیلٹ ریکارڈ کیا۔ یہ حتمی گنتی میں شمولیت کا آزادانہ ثبوت نہیں۔';

  @override
  String get rvfNoTitle => 'کوئی مماثل رسید نہیں';

  @override
  String get rvfNoBody =>
      'سروس کام کر رہی ہے اور اس ہیش کی کوئی رسید نہیں۔ جانچیں کہ آپ نے اپنی رسید سے پورا ہیش کاپی کیا ہے۔';

  @override
  String get rvfBadTitle => 'یہ درست رسید کا ہیش نہیں';

  @override
  String get rvfBadBody =>
      'رسید کا ہیش بالکل 64 حروف کا ہوتا ہے: ہندسے 0-9 اور حروف a-f۔ سرور کو کچھ نہیں بھیجا گیا۔';

  @override
  String get rvfRateTitle => 'بہت زیادہ تلاشیں';

  @override
  String get rvfRateBody => 'دوبارہ کوشش سے پہلے ایک منٹ انتظار کریں۔';

  @override
  String get rvfDownTitle => 'تصدیق ابھی دستیاب نہیں';

  @override
  String get rvfDownBody =>
      'ہم تصدیقی سروس تک نہیں پہنچ سکے، اس لیے نہیں بتا سکتے کہ آپ کی رسید موجود ہے یا نہیں۔ یہ \"نہیں ملی\" کا نتیجہ نہیں۔ اپنا کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get rvfRetry => 'دوبارہ کوشش کریں';

  @override
  String get rgDoneTitle => 'رجسٹریشن کامیاب';

  @override
  String get rgDoneBody =>
      'آپ کی Kivora شناخت محفوظ طریقے سے بن گئی ہے۔ اب آپ اپنی معلومات سے سائن اِن کر سکتے ہیں۔';

  @override
  String get rgReturn => 'لاگ اِن پر واپس جائیں';

  @override
  String get rgFirstLabel => 'پہلا نام';

  @override
  String get rgFirstHint => 'پہلا';

  @override
  String get rgFirstField => 'پہلا نام';

  @override
  String get rgLastLabel => 'آخری نام';

  @override
  String get rgLastHint => 'آخری';

  @override
  String get rgLastField => 'آخری نام';

  @override
  String get rgEmailLabel => 'ای میل ایڈریس';

  @override
  String get rgEmailHint => 'user@email.com';

  @override
  String get rgPassword => 'پاس ورڈ';

  @override
  String get rgConfirm => 'پاس ورڈ کی تصدیق کریں';

  @override
  String get evYourEmail => 'آپ کا ای میل ایڈریس';

  @override
  String get evOk => 'ای میل کی تصدیق کامیاب!';

  @override
  String get evNot =>
      'ای میل کی تصدیق ابھی نہیں ہوئی۔ اپنا ان باکس دیکھیں اور تصدیقی لنک پر کلک کریں۔';

  @override
  String evCheckFailed(String a) {
    return 'تصدیق کی حالت جانچی نہیں جا سکی: $a';
  }

  @override
  String get evResent =>
      'نئی تصدیقی ای میل بھیج دی گئی ہے۔ اپنا ان باکس دیکھیں۔';

  @override
  String evResendFailed(String a) {
    return 'ای میل دوبارہ نہیں بھیجی جا سکی: $a';
  }

  @override
  String get evTitle => 'ای میل کی تصدیق';

  @override
  String get evSignOut => 'سائن آؤٹ';

  @override
  String get evHeading => 'اپنے ای میل ایڈریس کی تصدیق کریں';

  @override
  String evSent(String a) {
    return 'ہم نے تصدیقی لنک بھیجا ہے:\n$a';
  }

  @override
  String get evClick =>
      'مکمل رسائی کھولنے کے لیے اپنی ای میل میں لنک پر کلک کریں۔';

  @override
  String evCooldown(String a) {
    return '$a سیکنڈ میں ای میل دوبارہ بھیجیں';
  }

  @override
  String get evResend => 'تصدیقی ای میل دوبارہ بھیجیں';

  @override
  String get evSwitch => 'سائن آؤٹ / دوسرا اکاؤنٹ استعمال کریں';

  @override
  String get fpTitle => 'پاس ورڈ بھول گئے؟';

  @override
  String get fpBody =>
      'پاس ورڈ ری سیٹ کرنے کی ہدایات پانے کے لیے اپنے اکاؤنٹ سے منسلک ای میل ایڈریس درج کریں۔';

  @override
  String get fpSent =>
      'اگر اس ای میل کا اکاؤنٹ موجود ہے تو پاس ورڈ ری سیٹ کا لنک بھیج دیا گیا ہے۔ اپنا ان باکس دیکھیں۔';

  @override
  String get fpEmail => 'ای میل ایڈریس';

  @override
  String get fpEmailHint => 'user@email.com';

  @override
  String fpCooldown(String a) {
    return '$a سیکنڈ میں لنک دوبارہ بھیجیں';
  }

  @override
  String get fpSend => 'ری سیٹ لنک بھیجیں';

  @override
  String get plOpenFailed => 'ادائیگی کا صفحہ نہیں کھل سکا۔';

  @override
  String get plReauth =>
      'سیکیورٹی کے لیے سائن آؤٹ کر کے دوبارہ سائن اِن کریں، پھر کوشش کریں۔';

  @override
  String get plGeneric => 'کچھ غلط ہو گیا۔ دوبارہ کوشش کریں۔';

  @override
  String get plBack => 'واپس';

  @override
  String get plTitle => 'پلانز اور بلنگ';

  @override
  String get plNoOrg => 'اس کا پلان دیکھنے کے لیے ایک تنظیم منتخب کریں۔';

  @override
  String plIntro(String a) {
    return 'پلانز $a پر لاگو ہوتے ہیں۔ ووٹرز کبھی ادائیگی نہیں کرتے اور انہیں ووٹ دینے سے کبھی نہیں روکا جاتا۔ اشتہارات بیلٹ، رسید، تصدیق یا ایڈمن اسکرینز پر کبھی نہیں آتے۔';
  }

  @override
  String get plOwnerOnly => 'صرف تنظیم کا مالک پلان بدل سکتا ہے۔';

  @override
  String get plSoon => 'آن لائن اپ گریڈ جلد آ رہا ہے';

  @override
  String get plOpening => 'کھل رہا ہے…';

  @override
  String get plUpgrade => 'پرو میں اپ گریڈ کریں';

  @override
  String get plManage => 'سبسکرپشن سنبھالیں یا منسوخ کریں';

  @override
  String get plContact => 'سیلز سے رابطہ کریں';

  @override
  String get plCurrent => 'موجودہ';

  @override
  String get spLogo => 'Kivora کا لوگو';

  @override
  String get spTag => 'انٹرپرائز ملٹی ٹیننٹ ای ووٹنگ';

  @override
  String get spBadge => 'سرور سے مجاز اور ٹیننٹ سے الگ';

  @override
  String get spInit => 'محفوظ سیشن شروع ہو رہا ہے...';

  @override
  String get spErrTitle => 'کنکشن میں خرابی';

  @override
  String get spErrBody => 'Kivora کی سروسز سے رابطہ نہیں ہو سکا۔';

  @override
  String get spRetry => 'کنکشن دوبارہ آزمائیں';

  @override
  String get sclProfile => 'تنظیم کی پروفائل مکمل کریں';

  @override
  String get sclMembers => 'اراکین شامل کریں';

  @override
  String get sclDepts => 'شعبے ترتیب دیں';

  @override
  String get sclFirst => 'اپنا پہلا ووٹنگ انتخاب بنائیں';

  @override
  String get sclTitle => 'اپنی تنظیم تیار کریں';

  @override
  String get sclDismiss => 'بند کریں';

  @override
  String sclProgress(String a, String b) {
    return '$b میں سے $a مکمل';
  }

  @override
  String get trS1Title => 'انتخاب کا دورانیہ';

  @override
  String get trS1P1 =>
      'ہر انتخاب ایک مقررہ ترتیب سے گزرتا ہے، جسے ایپ نہیں بلکہ سرور نافذ کرتا ہے: مسودہ ← شیڈول ← فعال ← بند ← آرکائیو۔';

  @override
  String get trS1P2 =>
      'کوئی انتخاب فعال حالت کے علاوہ ووٹ قبول نہیں کر سکتا، اور یہ سرور طے کرتا ہے - آپ کے ڈیوائس کی گھڑی نہیں - کہ یہ وقت کب کھلے گا اور کب بند ہوگا۔';

  @override
  String get trS1P3 =>
      'مسودہ انتخابات تنظیم کے اپنے مالکان اور منتظمین کے سوا کسی کو نظر نہیں آتے۔';

  @override
  String get trS2Title => 'ووٹر کی اہلیت';

  @override
  String get trS2P1 =>
      'ہر انتخاب میں اہلیت کا ایک اصول ہوتا ہے: تنظیم کا ہر فعال رکن، شعبوں کی ایک مخصوص فہرست، یا اراکین کی ایک مخصوص فہرست۔';

  @override
  String get trS2P2 =>
      'جب آپ بیلٹ جمع کرتے ہیں تو سرور اہلیت کو دوبارہ جانچتا ہے۔ ایپ پہلے جو دکھاتی ہے (جیسے \"ابھی ووٹ دیں\" کا بٹن) وہ سہولت ہے - وہ کبھی اصل اجازت کی جانچ نہیں ہوتی۔';

  @override
  String get trS3Title => 'ووٹ کیسے پراسیس ہوتا ہے';

  @override
  String get trS3P1 =>
      'بیلٹ ڈالنا ایک واحد اٹامک سرور-سائیڈ ٹرانزیکشن ہے: یہ تصدیق کرتی ہے کہ آپ کا سیشن منسوخ نہیں ہوا، آپ اہل ہیں اور پہلے ووٹ نہیں دیا، اور آپ کا انتخاب ریکارڈ کرتی ہے - یا تو سب کچھ یا کچھ نہیں۔';

  @override
  String get trS3P2 =>
      'دہرائی گئی جمع کاری (مثلاً نیٹ ورک کی خرابی کے بعد دوبارہ بھیجی گئی درخواست) سرور مسترد کر دیتا ہے اور دو بار نہیں گنتا، کیونکہ کسی انتخاب میں ہر ووٹر کے شرکت کے ریکارڈ کی ایک مقررہ، پہلے سے معلوم آئی ڈی ہوتی ہے جو صرف ایک بار بن سکتی ہے۔';

  @override
  String get trS4Title => 'گمنام بمقابلہ شناخت والی ووٹنگ';

  @override
  String get trS4P1 =>
      'گمنام انتخابات: آپ کا بیلٹ بغیر کسی ایسے خانے کے محفوظ ہوتا ہے جو اسے آپ کے اکاؤنٹ سے جوڑے۔ نظام یہ تصدیق کر سکتا ہے کہ آپ نے شرکت کی (دوہری ووٹنگ روکنے کے لیے) بغیر یہ ریکارڈ کیے کہ آپ نے کیا چنا۔';

  @override
  String get trS4P2 =>
      'شناخت والے انتخابات: آپ کا انتخاب آپ کے اکاؤنٹ کے ساتھ ریکارڈ ہوتا ہے۔ یہ طریقہ ان انتظامی صورتوں کے لیے ہے جہاں منسوب ووٹ درکار ہوں (مثلاً بعض رسمی قراردادیں) اور ووٹ سے پہلے واضح طور پر نشان زد ہوتا ہے۔';

  @override
  String get trS4P3 =>
      'انتخاب کا رازداری کا طریقہ اس کے بنتے وقت طے ہو جاتا ہے اور آپ کے کوئی انتخاب چننے سے پہلے آپ کو دکھایا جاتا ہے۔';

  @override
  String get trS5Title => 'ووٹ کی رسیدیں';

  @override
  String get trS5P1 =>
      'ووٹ دینے کے بعد آپ کو ایک رسید ملتی ہے: رسید کی آئی ڈی اور ایک کرپٹوگرافک ہیش جو آپ کے بیلٹ کے ریکارڈ سے اسی لمحے بنتا ہے جب وہ ریکارڈ ہوتا ہے۔';

  @override
  String get trS5P2 =>
      'رسید تصدیق کرتی ہے کہ آپ کا بیلٹ قبول ہوا اور نظام کے ریکارڈ میں موجود ہے۔ یہ آپ کے انتخاب کی نقل نہیں، اور گمنام انتخاب میں کوئی بھی - بشمول Kivora کے منتظمین - اسے یہ جاننے کے لیے استعمال نہیں کر سکتا کہ آپ نے کیا چنا۔';

  @override
  String get trS6Title => 'رسید کی تصدیق کیا ثابت کرتی ہے اور کیا نہیں';

  @override
  String get trS6P1 =>
      'رسید کی تصدیق صرف یہ ثابت کرتی ہے کہ اس رسید سے مماثل بیلٹ لیجر میں موجود ہے۔ اس کی حد بس یہی ہے۔';

  @override
  String get trS6P2 =>
      'یہ ثابت نہیں کرتی کہ وہ بیلٹ کس نے ڈالا، کون سا انتخاب چنا گیا، عمل میں کہیں اور کوئی مسئلہ نہیں ہوا، اور نہ ہی یہاں بیان سے آگے مکمل گنتی کا آزادانہ کرپٹوگرافک آڈٹ فراہم کرتی ہے۔ اسے ریکارڈ کی موجودگی کی جانچ سمجھیں، انتخابی سالمیت کا باقاعدہ ثبوت نہیں۔';

  @override
  String get trS7Title => 'نتائج کب دستیاب ہوتے ہیں';

  @override
  String get trS7P1 =>
      'انتخاب بند ہونے کے بعد نتائج شمار ہوتے ہیں، اور عام اراکین کو صرف تب نظر آتے ہیں جب تنظیم کا منتظم انہیں واضح طور پر شائع کرے۔';

  @override
  String get trS7P2 =>
      'تنظیم کے مالکان اور منتظمین شائع کرنے سے پہلے شمار شدہ نتائج دیکھ سکتے ہیں تاکہ ترتیب کے مسائل پکڑے جا سکیں - یہ معمول کے کام کا حصہ ہے، چھپی ہوئی گنتی کا ثبوت نہیں۔';

  @override
  String get trS8Title => 'انتظامی جوابدہی';

  @override
  String get trS8P1 =>
      'حساس انتظامی کارروائیاں - انتخاب شائع یا بند کرنا، کسی رکن کا کردار بدلنا، مبصر کی رسائی دینا، اور ایسی دیگر کارروائیاں - تنظیم کے آڈٹ لاگ میں لکھی جاتی ہیں جو اس تنظیم کے مالکان اور منتظمین کو نظر آتا ہے۔';

  @override
  String get trS8P2 =>
      'یہ تنظیم کی اپنی نگرانی کے لیے ایک آپریشنل لاگ ہے، کوئی عوامی، چھیڑ چھاڑ سے محفوظ لیجر نہیں - نیچے \"معلوم حدود\" دیکھیں۔';

  @override
  String get trS9Title => 'رازداری اور ڈیٹا کا انتظام';

  @override
  String get trS9P1 =>
      'ہر تنظیم کا ڈیٹا سرور کی سطح پر دوسری تنظیموں سے الگ ہے؛ ایک تنظیم کی رکنیت کبھی دوسری کے انتخابات، اراکین یا نتائج تک رسائی نہیں دیتی۔';

  @override
  String get trS9P2 =>
      'مبصرین (ایک محدود، منتظم کی دی ہوئی صلاحیت) فعال انتخابات اور شائع شدہ نتائج کے لیے صرف تنظیم بھر کی مجموعی شرکت کے اعداد دیکھتے ہیں - انفرادی بیلٹ، ووٹرز کی شناخت یا چھوٹے گروہوں کی ایسی تفصیل کبھی نہیں جو ظاہر کر دے کہ کسی خاص شخص یا چھوٹے گروہ نے کیسے ووٹ دیا۔';

  @override
  String get trS9P3 =>
      'مفت پلان پر موبائل ایپ کے صارفین کو براؤزنگ اسکرینز (ہوم، تنظیمیں، کیلنڈر، شائع شدہ نتائج) پر بینر اشتہارات نظر آ سکتے ہیں۔ اشتہارات تیسرے فریق کا اشتہاری نیٹ ورک دکھاتا ہے جو آپ کی رضامندی کے انتخاب کے مطابق ڈیوائس کی شناختیں جمع کر سکتا ہے۔ اشتہارات بیلٹ، رسید، رسید کی تصدیق، شفافیت یا ایڈمن اسکرینز پر کبھی نہیں آتے، اور اشتہاری نیٹ ورک کو آپ کا ووٹ، آپ کا انتخاب یا آپ کی رسید کبھی نہیں ملتی۔';

  @override
  String get trS10Title => 'معلوم حدود';

  @override
  String get trS10P1 =>
      'آڈٹ لاگز عام ڈیٹا بیس ریکارڈ ہیں، کرپٹوگرافک طور پر چھیڑ چھاڑ ظاہر کرنے والا لیجر نہیں - وہ آپریشنل تاریخ بتاتے ہیں، بعد میں تبدیلی کے خلاف ریاضیاتی ثبوت نہیں۔';

  @override
  String get trS10P2 =>
      'Kivora کو کسی قومی یا تیسرے فریق کی انتخابی معیارات کی تنظیم نے آزادانہ طور پر مصدقہ نہیں کیا، اور رسید کی تصدیق مکمل گنتی کے آزادانہ کرپٹوگرافک آڈٹ کا متبادل نہیں۔';

  @override
  String get trS10P3 =>
      'کچھ انٹرفیس زبانیں مشین کی مدد سے ترجمہ کی گئی ہیں اور مقامی بولنے والے کے جائزے کی منتظر ہیں - دیکھیں ترتیبات ← ترجیحات ← زبان۔';

  @override
  String get trTitle => 'اعتماد اور شفافیت کا مرکز';

  @override
  String get trHeading => 'Kivora کے انتخابات کیسے کام کرتے ہیں';

  @override
  String get trIntro =>
      'ہر انتخاب کے پیچھے حقیقت میں کیا ہوتا ہے، اس کی سادہ زبان میں وضاحت، جو اصل نفاذ کے مطابق لکھی گئی ہے - اس کی صاف حدود سمیت۔';

  @override
  String get trVerify => 'رسید کی تصدیق کریں';

  @override
  String get lcF1T => 'تنظیم کا انتظام';

  @override
  String get lcF1B =>
      'اراکین، کردار، شعبے، دعوتیں اور شمولیت کے کوڈ ایک ہی جگہ سنبھالیں۔';

  @override
  String get lcF2T => 'انتخابات اور رائے شماریاں';

  @override
  String get lcF2B =>
      'امیدواروں کے انتخابات، واحد انتخاب اور ہاں/نہیں رائے شماریاں ایک مقررہ دورانیے کے ساتھ چلائیں: مسودہ، شیڈول، فعال، بند، آرکائیو۔';

  @override
  String get lcF3T => 'گمنام یا شناخت کے ساتھ';

  @override
  String get lcF3B =>
      'ووٹ بناتے وقت رازداری کا طریقہ چنیں۔ یہ اراکین کو بیلٹ پر، انتخاب کرنے سے پہلے دکھایا جاتا ہے۔';

  @override
  String get lcF4T => 'اہلیت آپ کے اختیار میں';

  @override
  String get lcF4B =>
      'ووٹ تمام فعال اراکین، منتخب شعبوں یا منتخب اراکین کے لیے کھولیں۔ بیلٹ جمع ہوتے وقت سرور اسے دوبارہ جانچتا ہے۔';

  @override
  String get lcF5T => 'قابلِ جائزہ تاریخ';

  @override
  String get lcF5B =>
      'مالکان اور منتظمین اہم انتظامی اور انتخابی کارروائیوں کا سرور-سائیڈ ریکارڈ دیکھ سکتے ہیں۔';

  @override
  String get lcF6T => 'رسید کی تصدیق';

  @override
  String get lcF6B =>
      'ووٹ کے بعد آپ کو رسید ملتی ہے۔ کوئی بھی، بغیر اکاؤنٹ کے، جانچ سکتا ہے کہ رسید موجود ہے۔';

  @override
  String get lcS1T => 'اپنی تنظیم بنائیں';

  @override
  String get lcS1B =>
      'سائن اَپ کریں، پھر تنظیم بنائیں اور اپنے لوگوں کو مدعو کریں۔';

  @override
  String get lcS2T => 'ووٹ ترتیب دیں';

  @override
  String get lcS2B => 'سوال، شیڈول، آپشنز، اہلیت اور رازداری کا طریقہ چنیں۔';

  @override
  String get lcS3T => 'اراکین شریک ہوں';

  @override
  String get lcS3B =>
      'ووٹ کھلا ہونے کے دوران اہل اراکین کو بیلٹ تک آسان راستہ ملتا ہے۔';

  @override
  String get lcS4T => 'نتیجہ دیکھیں';

  @override
  String get lcS4B =>
      'ووٹ بند ہونے کے بعد نتائج شمار ہوتے ہیں اور منتظم کے شائع کرنے پر اراکین کو نظر آتے ہیں۔';

  @override
  String get lcO1T => 'تعلیمی ادارے';

  @override
  String get lcO1B => 'شعبے، کونسلیں اور کمیٹیاں۔';

  @override
  String get lcO2T => 'کارپوریٹ ٹیمیں';

  @override
  String get lcO2B => 'اندرونی رائے شماریاں اور انتخابات۔';

  @override
  String get lcO3T => 'غیر منافع بخش ادارے';

  @override
  String get lcO3B => 'بورڈ، رضاکار اور اراکین۔';

  @override
  String get lcO4T => 'کلب اور سوسائٹیاں';

  @override
  String get lcO4B => 'طلبہ کی سوسائٹیاں اور کلب۔';

  @override
  String get lcO5T => 'کمیونٹی ایسوسی ایشنز';

  @override
  String get lcO5B => 'مشترکہ مقامی فیصلے۔';

  @override
  String get lcT1T => 'دو مرحلہ سائن اِن';

  @override
  String get lcT1B => 'حساس انتظامی کارروائیوں کے لیے دو مرحلہ تصدیق ضروری ہے۔';

  @override
  String get lcT2T => 'رازداری آپ کا انتخاب';

  @override
  String get lcT2B =>
      'گمنام ووٹنگ میں آپ کا انتخاب بغیر کسی ایسے خانے کے محفوظ ہوتا ہے جو اسے آپ کے اکاؤنٹ سے جوڑے۔';

  @override
  String get lcT3T => 'سرور سے جانچے گئے اصول';

  @override
  String get lcT3B =>
      'اہلیت، وقت اور دوہرے ووٹ کی جانچ سرور کرتا ہے، ایپ نہیں۔';

  @override
  String get lcY1T => 'دو مرحلہ تصدیق';

  @override
  String get lcY1B =>
      'حساس انتظامی کارروائیوں کے لیے حالیہ سائن اِن اور دو مرحلہ تصدیق ضروری ہے۔';

  @override
  String get lcY2T => 'رازداری آپ کا انتخاب';

  @override
  String get lcY2B =>
      'جب فیصلہ تقاضا کرے تو گمنام ووٹنگ آن کریں۔ طریقہ بیلٹ پر نظر آتا ہے۔';

  @override
  String get lcY3T => 'فیصلہ سرور کرتا ہے';

  @override
  String get lcY3B =>
      'ووٹنگ کا وقت، اہلیت اور فی شخص ایک ووٹ جمع کراتے وقت سرور پر جانچے جاتے ہیں۔';

  @override
  String get lcY4T => 'قابلِ جائزہ ریکارڈ';

  @override
  String get lcY4B =>
      'اہم انتظامی کارروائیاں ریکارڈ ہوتی ہیں تاکہ مالکان اور منتظمین انہیں دیکھ سکیں۔';

  @override
  String get lcQ1T => 'ہم Kivora کس لیے استعمال کر سکتے ہیں؟';

  @override
  String get lcQ1B =>
      'امیدواروں کے انتخابات، واحد انتخاب اور ہاں/نہیں رائے شماریاں آپ کی تنظیم کے لیے، جیسے نمائندوں کا انتخاب، کمیٹی کے فیصلے اور اراکین کے سوالات۔';

  @override
  String get lcQ2T => 'کون ووٹ دے سکتا ہے؟';

  @override
  String get lcQ2B =>
      'منتظم ہر ووٹ کے لیے اہلیت کا ایک اصول طے کرتا ہے: تمام فعال اراکین، منتخب شعبے، یا منتخب اراکین۔ بیلٹ جمع کرتے وقت سرور اسے دوبارہ جانچتا ہے۔';

  @override
  String get lcQ3T => 'کیا بیلٹ گمنام ہو سکتا ہے؟';

  @override
  String get lcQ3B =>
      'جی ہاں، یہ اختیاری ہے۔ گمنام ووٹ میں آپ کا انتخاب بغیر کسی ایسے خانے کے محفوظ ہوتا ہے جو اسے آپ کے اکاؤنٹ سے جوڑے، جبکہ الگ شرکت کا ریکارڈ دوہری ووٹنگ روکتا ہے۔ طریقہ ووٹ بنتے وقت طے ہوتا ہے اور انتخاب سے پہلے دکھایا جاتا ہے۔';

  @override
  String get lcQ4T => 'میں اپنی ووٹ کی رسید کیسے جانچوں؟';

  @override
  String get lcQ4B =>
      '\"رسید کی تصدیق کریں\" کھولیں، اپنی رسید کا ہیش چسپاں کریں اور جانچیں۔ رسید تصدیق کرتی ہے کہ اس رسید والا بیلٹ موجود ہے۔ یہ آپ کا انتخاب، ووٹر، یا باقی عمل کے بارے میں کچھ ظاہر نہیں کرتی۔';

  @override
  String get lcQ5T => 'تاریخ کیا دکھاتی ہے؟';

  @override
  String get lcQ5B =>
      'مالکان اور منتظمین اپنی تنظیم کے اہم انتظامی اور انتخابی کارروائیوں کا سرور-سائیڈ ریکارڈ دیکھ سکتے ہیں۔';

  @override
  String get lcQ6T => 'اراکین نتائج کب دیکھ سکتے ہیں؟';

  @override
  String get lcQ6B =>
      'ووٹ بند ہونے کے بعد نتائج شمار ہوتے ہیں۔ عام اراکین انہیں تب دیکھتے ہیں جب تنظیم کا منتظم شائع کرے۔';

  @override
  String get ldCandA => 'امیدوار الف';

  @override
  String get ldCandB => 'امیدوار ب';

  @override
  String get ldCandC => 'امیدوار ج';

  @override
  String get ldNavFeatures => 'خصوصیات';

  @override
  String get ldNavHow => 'یہ کیسے کام کرتا ہے';

  @override
  String get ldNavOrgs => 'تنظیمیں';

  @override
  String get ldNavSecurity => 'سیکیورٹی اور رازداری';

  @override
  String get ldNavTransparency => 'شفافیت';

  @override
  String get ldBrandTop => 'Kivora، اوپر واپس';

  @override
  String get ldToLight => 'روشن تھیم پر جائیں';

  @override
  String get ldToDark => 'گہری تھیم پر جائیں';

  @override
  String get ldSignIn => 'سائن اِن';

  @override
  String get ldGetStarted => 'شروع کریں';

  @override
  String get ldMenu => 'مینو';

  @override
  String get ldCloseMenu => 'مینو بند کریں';

  @override
  String get ldVerify => 'رسید کی تصدیق کریں';

  @override
  String get ldHeroBadge => 'Kivora · محفوظ ای ووٹنگ اور رائے شماری';

  @override
  String get ldHeroTitle => 'اپنی تنظیم کے لیے منصفانہ انتخابات کروائیں۔';

  @override
  String get ldHeroBody =>
      'اپنے اراکین کے لیے انتخابات اور رائے شماریاں کروائیں، گمنام یا شناخت والی ووٹنگ میں سے چنیں، اور اہلیت، وقت اور فی شخص ایک ووٹ سرور سے نافذ کروائیں۔';

  @override
  String get ldHaveCode => 'شمولیت کا کوڈ یا دعوت ہے؟  ';

  @override
  String get ldCreateToJoin => 'شامل ہونے کے لیے اکاؤنٹ بنائیں';

  @override
  String get ldFeaturesEyebrow => 'اجتماعی فیصلوں کے لیے بنایا گیا';

  @override
  String get ldFeaturesTitle =>
      'ووٹ دینے اور یہ طے کرنے کی ایک ہی جگہ کہ کون دے سکتا ہے۔';

  @override
  String get ldFeaturesBody =>
      'نمائندے چننے سے لے کر ہاں/نہیں کا سوال طے کرنے تک، ہر ووٹ کا ایک واضح ٹھکانہ ہے۔';

  @override
  String get ldHowTitle => 'ترتیب سے نتیجے تک ایک واضح راستہ۔';

  @override
  String get ldHowBody => 'منتظمین اور اراکین دونوں کے لیے شرکت آسان بنائیں۔';

  @override
  String get ldStart => 'Kivora کے ساتھ شروع کریں';

  @override
  String get ldOrgsEyebrow => 'ہر قسم کی تنظیم کے لیے';

  @override
  String get ldOrgsTitle => 'آپ کی کمیونٹی، نمائندگی کے ساتھ۔';

  @override
  String get ldOrgsBody =>
      'Kivora کی تنظیمیں ان میں سے ایک قسم کی ہوتی ہیں، پھر شریک لوگوں کے مطابق ڈھالی جاتی ہیں۔';

  @override
  String get ldSecTitle => 'اعتماد ہر قدم میں شامل۔';

  @override
  String get ldSecBody =>
      'اہم اصول سرور پر چلتے ہیں، اور ووٹنگ کا طریقہ اراکین کو انتخاب سے پہلے نظر آتا ہے۔';

  @override
  String get ldExplore => 'شفافیت دیکھیں';

  @override
  String get ldPartRecord => 'شرکت کا ریکارڈ';

  @override
  String get ldPartBody =>
      'ریکارڈ کرتا ہے کہ ایک اہل رکن نے ووٹ دیا، تاکہ کوئی دو بار ووٹ نہ دے سکے۔ گمنام ووٹ میں یہ انتخاب نہیں رکھتا۔';

  @override
  String get ldBallotRecord => 'بیلٹ کا ریکارڈ';

  @override
  String get ldBallotBody =>
      'انتخاب رکھتا ہے۔ گمنام ووٹ میں اس میں کوئی ایسا خانہ نہیں جو اسے ووٹر کے اکاؤنٹ سے جوڑے۔';

  @override
  String get ldAnonEyebrow => 'گمنام ووٹنگ';

  @override
  String get ldAnonTitle => 'شرکت ریکارڈ ہوتی ہے۔ بیلٹ الگ رہتے ہیں۔';

  @override
  String get ldAnonBody =>
      'دو الگ ریکارڈ Kivora کو دوہری ووٹنگ روکنے دیتے ہیں اور گمنام انتخاب کو گمنام رکھتے ہیں۔';

  @override
  String get ldReceiptTitle => 'بغیر اکاؤنٹ کے رسید جانچیں۔';

  @override
  String get ldReceiptBody =>
      'رسید کا ہیش چسپاں کر کے تصدیق کریں کہ اس رسید والا بیلٹ موجود ہے۔ یہ کسی انتخاب یا ووٹر کو ظاہر نہیں کرتا، اور یہ ریکارڈ کی موجودگی کی جانچ ہے، پورے عمل کا باقاعدہ ثبوت نہیں۔';

  @override
  String get ldFaqEyebrow => 'اکثر پوچھے جانے والے سوالات';

  @override
  String get ldFaqTitle => 'اچھے فیصلے واضح جوابات سے شروع ہوتے ہیں۔';

  @override
  String get ldCtaTitle => 'اپنے اگلے فیصلے کو اہم بنائیں۔';

  @override
  String get ldCtaBody =>
      'ہر رکن کو اپنی بات پہنچانے کا واضح اور محفوظ طریقہ دیں۔';

  @override
  String get ldFooterTag => 'تنظیموں کے لیے محفوظ ای ووٹنگ اور رائے شماری۔';

  @override
  String get ldFooterProduct => 'پروڈکٹ';

  @override
  String get ldFooterTrust => 'اعتماد';

  @override
  String get ldFooterAccount => 'اکاؤنٹ';

  @override
  String get ldFooterCreate => 'اکاؤنٹ بنائیں';

  @override
  String get ldFooterFaq => 'سوالات';

  @override
  String get ldCopyright => '© 2026 Sonryan۔ جملہ حقوق محفوظ ہیں۔';

  @override
  String get ldBackTop => 'اوپر واپس';

  @override
  String get ldIllus => 'مثال، حقیقی انتخاب نہیں';

  @override
  String get ldSample => 'نمونہ بیلٹ';

  @override
  String get ldChoose => 'ایک امیدوار منتخب کریں۔';

  @override
  String get ldSampleCands => 'نمونہ امیدوار';

  @override
  String get ldAnonBallot => 'گمنام بیلٹ';

  @override
  String get ldSubmit => 'ووٹ جمع کریں';

  @override
  String get ldTry => 'کوئی امیدوار چن کر دیکھیں۔ یہ صرف پیش منظر ہے۔';

  @override
  String ldPicked(String a) {
    return 'آپ نے اس پیش منظر میں $a چنا۔ کچھ جمع نہیں ہوا۔';
  }

  @override
  String get ldHelpTitle => 'مزید مدد چاہیے؟';

  @override
  String get ldHelpBody =>
      'رسائی یا اہلیت کے سوالات کے لیے اپنی تنظیم کے منتظم سے پوچھیں۔ انتخابات شروع سے آخر تک کیسے کام کرتے ہیں، یہ دیکھنے کے لیے شفافیت کا مرکز پڑھیں۔';

  @override
  String get ldHelpOpen => 'شفافیت کا مرکز کھولیں';

  @override
  String get obSkip => 'چھوڑیں';

  @override
  String get obYourOrg => 'آپ کی تنظیم';

  @override
  String get obCreate => 'تنظیم بنائیں';

  @override
  String get obCreateSub => 'اپنی کمیونٹی کے لیے ایک جگہ شروع کریں';

  @override
  String get obJoin => 'تنظیم میں شامل ہوں';

  @override
  String get obJoinSub => 'اپنا کوڈ یا دعوت استعمال کریں';

  @override
  String get obInviteNote => 'دعوت آپ کو سیدھا اندر لے آتی ہے۔';

  @override
  String get obTag1 => 'آپ کی کمیونٹی، جڑی ہوئی';

  @override
  String get obTitle1 => 'تنظیم بنائیں یا\nشامل ہوں';

  @override
  String get obBody1 =>
      'اپنے لوگوں کو اکٹھا کریں۔ اپنے انتخابات اور رائے شماریوں کے لیے ایک گھر بنائیں، یا دعوتی کوڈ سے شامل ہوں۔';

  @override
  String get obCallout1 => 'مشترکہ فیصلوں کے لیے ایک گھر';

  @override
  String get obCallout1b =>
      'اپنے اراکین، انتخابات اور رائے شماریاں ایک تنظیم میں جوڑیں۔';

  @override
  String get obNext => 'اگلا';

  @override
  String get obExample => 'نمونہ بیلٹ';

  @override
  String get obStudent => 'طلبہ کونسل 2026';

  @override
  String get obPresident => 'صدر · ایک امیدوار منتخب کریں';

  @override
  String get obAlex => 'ایلکس مورگن';

  @override
  String get obJordan => 'جارڈن لی';

  @override
  String get obReview => 'ووٹ کا جائزہ لیں';

  @override
  String get obTag2 => 'ہر آواز اہم ہے';

  @override
  String get obTitle2 => 'اعتماد کے ساتھ ووٹ دیں';

  @override
  String get obBody2 =>
      'انتخابات اور رائے شماریوں میں اپنی آواز کو اہم بنائیں۔ اپنے آپشنز دیکھیں، منتخب کریں، اور ووٹ جمع کریں۔';

  @override
  String get obCallout2 => 'آپ کا انتخاب نجی رہتا ہے';

  @override
  String get obCallout2b =>
      'نجی بیلٹ آپ کے انتخاب کی حفاظت کرتے ہیں اور عمل کو جوابدہ رکھتے ہیں۔';

  @override
  String get obControls => 'تنظیم کے کنٹرول';

  @override
  String get obCodes => 'شمولیت کے کوڈ';

  @override
  String get obCodesSub => 'بنائیں اور منسوخ کریں';

  @override
  String get obLog => 'سرگرمی کا لاگ';

  @override
  String get obLogAdded => 'رکن شامل ہوا';

  @override
  String get obLogElection => 'انتخاب بنایا گیا';

  @override
  String get obTag3 => 'واضح اصول۔ واضح ریکارڈ۔';

  @override
  String get obTitle3 => 'کنٹرول اپنے ہاتھ میں رکھیں';

  @override
  String get obBody3 =>
      'اپنی تنظیم کے لیے واضح اصول طے کریں۔ شمولیت کے کوڈ سنبھالیں اور اہم کارروائیاں سرگرمی کے لاگ میں دیکھیں۔';

  @override
  String get obCallout3 => 'نجی انتخاب۔ جوابدہ کارروائیاں۔';

  @override
  String get obCallout3b =>
      'اہلیت کے اصول طے کرتے ہیں کہ کون شریک ہو سکتا ہے۔ سرگرمی کے لاگ انتظامی کارروائیوں کو ریکارڈ رکھتے ہیں۔';

  @override
  String get obContinue => 'جاری رکھیں';

  @override
  String get obComm => 'آپ کی کمیونٹی';

  @override
  String get obCommSub => 'فیصلے کے لیے مشترکہ جگہ';

  @override
  String get obElections => 'انتخابات';

  @override
  String get obPolls => 'رائے شماریاں';

  @override
  String get obTag4 => 'بہتر فیصلے، ساتھ مل کر۔';

  @override
  String get obTitle4 => 'اپنی تنظیم کو\nآواز دیں۔';

  @override
  String get obBody4 =>
      'اپنے انتخابات اور رائے شماریوں کے لیے گھر بنائیں۔ اپنے اراکین کو شامل کریں، اور Kivora کے ساتھ مل کر آگے بڑھیں۔';

  @override
  String get obGetStarted => 'شروع کریں';

  @override
  String get obHaveAccount => 'میرا اکاؤنٹ پہلے سے ہے';

  @override
  String obPage(String a) {
    return '$a / 3';
  }

  @override
  String get obBack => 'واپس';

  @override
  String get cfAdd => 'امیدوار شامل کریں';

  @override
  String get cfEdit => 'امیدوار میں ترمیم کریں';

  @override
  String get cfClose => 'بند کریں';

  @override
  String get cfPhotoSem => 'امیدوار کی تصویر منتخب کریں';

  @override
  String get cfPhoto => 'تصویر منتخب کریں (JPEG، اختیاری)';

  @override
  String get cfPhotoChange => 'دوسری تصویر منتخب کریں';

  @override
  String get cfName => 'پورا نام *';

  @override
  String get cfNameHint => 'مثلاً ڈاکٹر سارہ جینکنز';

  @override
  String get cfNameShort => 'امیدوار کا نام درج کریں (کم از کم 2 حروف)۔';

  @override
  String get cf100 => '100 حروف یا کم استعمال کریں۔';

  @override
  String get cfParty => 'پارٹی / وابستگی (اختیاری)';

  @override
  String get cfPartyHint => 'مثلاً ترقی پسند اتحاد';

  @override
  String get cfBio => 'امیدوار کا تعارف / وژن (اختیاری)';

  @override
  String get cfBioHint => 'تجربے اور مقاصد کا مختصر خلاصہ...';

  @override
  String get cf1000 => '1,000 حروف یا کم استعمال کریں۔';

  @override
  String get cfCancel => 'منسوخ کریں';

  @override
  String get cfSave => 'تبدیلیاں محفوظ کریں';

  @override
  String get clRemoveTitle => 'اس امیدوار کو ہٹائیں؟';

  @override
  String clRemoveBody(String a) {
    return '$a کو اس انتخاب سے ہٹا دیا جائے گا۔ جب تک انتخاب مسودہ ہے آپ انہیں دوبارہ شامل کر سکتے ہیں۔';
  }

  @override
  String get clKeep => 'امیدوار رکھیں';

  @override
  String get clRemove => 'ہٹائیں';

  @override
  String get clRemoveFailed =>
      'امیدوار کو ہٹایا نہیں جا سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get clLocked =>
      'یہ انتخاب اب مسودہ نہیں رہا، اس لیے اس کے امیدوار تبدیل نہیں ہو سکتے۔';

  @override
  String get clLoadError => 'ہم امیدوار لوڈ نہیں کر سکے۔';

  @override
  String get clRetry => 'دوبارہ کوشش کریں';

  @override
  String clNeedOne(String a) {
    return 'شائع کرنے کے لیے کم از کم 1 مزید امیدوار شامل کریں (کم از کم $a)۔';
  }

  @override
  String clNeedMany(String a, String b) {
    return 'شائع کرنے کے لیے کم از کم $a مزید امیدوار شامل کریں (کم از کم $b)۔';
  }

  @override
  String clCount(String a) {
    return '$a امیدوار شامل ہو گئے۔';
  }

  @override
  String get clNone => 'ابھی کوئی امیدوار شامل نہیں۔';

  @override
  String get clIndependent => 'آزاد / کوئی وابستگی نہیں';

  @override
  String clEdit(String a) {
    return '$a میں ترمیم کریں';
  }

  @override
  String clRemoveName(String a) {
    return '$a کو ہٹائیں';
  }

  @override
  String get clAdd => 'امیدوار شامل کریں';

  @override
  String get pfAddTitle => 'رائے شماری کا آپشن شامل کریں';

  @override
  String get pfEditTitle => 'رائے شماری کا آپشن ترمیم کریں';

  @override
  String get pfLabel => 'آپشن کا نام *';

  @override
  String get pfLabelHint => 'مثلاً تجویز الف منظور کریں';

  @override
  String get pfLabelRequired => 'نام ضروری ہے';

  @override
  String get pfDesc => 'آپشن کی تفصیل (اختیاری)';

  @override
  String get pfDescHint => 'ووٹرز کے لیے مزید تفصیلات دیں...';

  @override
  String get pfCancel => 'منسوخ کریں';

  @override
  String get pfAdd => 'آپشن شامل کریں';

  @override
  String get pfSave => 'تبدیلیاں محفوظ کریں';

  @override
  String get plsAdd => 'آپشن شامل کریں';

  @override
  String get plsLoadError => 'ہم آپشنز لوڈ نہیں کر سکے۔';

  @override
  String get plsRetry => 'دوبارہ کوشش کریں';

  @override
  String plsNone(String a) {
    return 'ابھی کوئی آپشن شامل نہیں۔ شائع کرنے کے لیے کم از کم $a شامل کریں۔';
  }

  @override
  String get plsDeleteTitle => 'آپشن حذف کریں؟';

  @override
  String plsDeleteBody(String a) {
    return 'کیا آپ واقعی $a کو حذف کرنا چاہتے ہیں؟';
  }

  @override
  String get plsCancel => 'منسوخ کریں';

  @override
  String get plsDelete => 'حذف کریں';

  @override
  String get plsRemoveFailed => 'آپشن کو ہٹایا نہیں جا سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get chRoster => 'امیدواروں کی فہرست';

  @override
  String get chYesNo => 'ہاں/نہیں کے آپشنز';

  @override
  String get chPoll => 'رائے شماری کے آپشنز';

  @override
  String get chBack => 'واپس';

  @override
  String get chNext => 'اگلا: جائزہ';

  @override
  String get chYes => 'ہاں';

  @override
  String get chNo => 'نہیں';

  @override
  String get chSystem => 'نظام کا بنایا ہوا آپشن';

  @override
  String get ciTitle => 'ووٹرز کی بڑی تعداد درآمد کریں';

  @override
  String get ciBody =>
      'نیچے CSV ڈیٹا یا ای میل ایڈریسز کی فہرست چسپاں کریں۔ ای میلز خودکار طور پر تنظیم کے فعال اراکین سے جانچی جائیں گی۔';

  @override
  String get ciLabel => 'CSV مواد / ای میل فہرست';

  @override
  String get ciHint =>
      'john@example.com, jane@organization.org\nmark@company.com';

  @override
  String get ciParse => 'پڑھیں اور جانچیں';

  @override
  String get ciResults => 'جانچ کے نتائج';

  @override
  String ciMatched(String a) {
    return '$a اراکین مل گئے اور اہل ہیں';
  }

  @override
  String ciUnmatched(String a) {
    return '$a ای میلز ورک اسپیس کی ڈائریکٹری میں نہیں ملیں';
  }

  @override
  String get ciReedit => 'فہرست دوبارہ ایڈٹ کریں';

  @override
  String ciApply(String a) {
    return 'انتخاب لاگو کریں ($a)';
  }

  @override
  String get cdCreated => 'شعبہ کامیابی سے بن گیا۔';

  @override
  String get cdUpdated => 'شعبہ کامیابی سے اپ ڈیٹ ہو گیا۔';

  @override
  String get cdEditTitle => 'شعبے میں ترمیم کریں';

  @override
  String get cdCreateTitle => 'شعبہ بنائیں';

  @override
  String get cdName => 'شعبے کا نام *';

  @override
  String get cdNameHint => 'مثلاً کمپیوٹر سائنس';

  @override
  String get cdNameField => 'شعبے کا نام';

  @override
  String get cdNameShort => 'نام کم از کم 2 حروف کا ہونا چاہیے';

  @override
  String get cdNameLong => 'نام 50 حروف سے زیادہ نہیں ہو سکتا';

  @override
  String get cdDesc => 'تفصیل (اختیاری)';

  @override
  String get cdDescHint => 'شعبے کا مختصر خلاصہ...';

  @override
  String get cdCancel => 'منسوخ کریں';

  @override
  String get cdUpdate => 'اپ ڈیٹ کریں';

  @override
  String get cdCreate => 'بنائیں';
}
