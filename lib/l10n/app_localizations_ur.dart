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
}
