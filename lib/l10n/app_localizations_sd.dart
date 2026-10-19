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
}
