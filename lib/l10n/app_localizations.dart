import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_sd.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('sd'),
    Locale('ur')
  ];

  /// The application name, shown on splash/auth screens
  ///
  /// In en, this message translates to:
  /// **'Kivora'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navOrganizations.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get navOrganizations;

  /// No description provided for @navOrgsShort.
  ///
  /// In en, this message translates to:
  /// **'Orgs'**
  String get navOrgsShort;

  /// No description provided for @navEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get navEvents;

  /// No description provided for @navDirectory.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get navDirectory;

  /// No description provided for @navDepartments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get navDepartments;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navCommandCenter.
  ///
  /// In en, this message translates to:
  /// **'Command Center'**
  String get navCommandCenter;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get actionNext;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get actionSignOut;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authSignInSubtitle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In Securely'**
  String get authSignInButton;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authNoAccount;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Kivora today'**
  String get authRegisterSubtitle;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get authFullName;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPassword;

  /// No description provided for @voteStepSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get voteStepSelect;

  /// No description provided for @voteStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get voteStepReview;

  /// No description provided for @voteSelectionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Make your selection'**
  String get voteSelectionPrompt;

  /// No description provided for @voteReviewBallot.
  ///
  /// In en, this message translates to:
  /// **'Review Ballot'**
  String get voteReviewBallot;

  /// No description provided for @voteReviewYourBallot.
  ///
  /// In en, this message translates to:
  /// **'Review your ballot'**
  String get voteReviewYourBallot;

  /// No description provided for @voteYourSelection.
  ///
  /// In en, this message translates to:
  /// **'Your selection'**
  String get voteYourSelection;

  /// No description provided for @voteConfirmAndCast.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Cast Ballot'**
  String get voteConfirmAndCast;

  /// No description provided for @voteSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting Ballot...'**
  String get voteSubmitting;

  /// No description provided for @voteAnonymousExplanation.
  ///
  /// In en, this message translates to:
  /// **'This ballot is anonymous. Your selection is never linked to your identity in the tally, and cannot be changed after submission.'**
  String get voteAnonymousExplanation;

  /// No description provided for @voteIdentifiableExplanation.
  ///
  /// In en, this message translates to:
  /// **'This is an identifiable ballot. Your selection will be recorded against your account and cannot be changed after submission.'**
  String get voteIdentifiableExplanation;

  /// No description provided for @voteAlreadyVotedTitle.
  ///
  /// In en, this message translates to:
  /// **'You Have Already Voted'**
  String get voteAlreadyVotedTitle;

  /// No description provided for @voteAlreadyVotedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your ballot for \"{eventTitle}\" has already been cast and accepted into the anonymous tally.'**
  String voteAlreadyVotedMessage(String eventTitle);

  /// No description provided for @voteViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View Your Confirmation Receipt'**
  String get voteViewReceipt;

  /// No description provided for @voteViewResults.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get voteViewResults;

  /// No description provided for @voteNotOpenYet.
  ///
  /// In en, this message translates to:
  /// **'Voting has not opened yet for this election. You can review the ballot below, but submission is disabled until it becomes active.'**
  String get voteNotOpenYet;

  /// No description provided for @voteClosed.
  ///
  /// In en, this message translates to:
  /// **'Voting is no longer open for this election.'**
  String get voteClosed;

  /// No description provided for @receiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Vote Receipt'**
  String get receiptTitle;

  /// No description provided for @receiptId.
  ///
  /// In en, this message translates to:
  /// **'Receipt ID'**
  String get receiptId;

  /// No description provided for @receiptHash.
  ///
  /// In en, this message translates to:
  /// **'Receipt Hash'**
  String get receiptHash;

  /// No description provided for @receiptCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get receiptCopy;

  /// No description provided for @receiptReturnHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home Feed'**
  String get receiptReturnHome;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Election Results'**
  String get resultsTitle;

  /// No description provided for @resultsTotalVotes.
  ///
  /// In en, this message translates to:
  /// **'Total Votes'**
  String get resultsTotalVotes;

  /// No description provided for @resultsVoterTurnout.
  ///
  /// In en, this message translates to:
  /// **'Voter Turnout'**
  String get resultsVoterTurnout;

  /// No description provided for @resultsTurnoutRate.
  ///
  /// In en, this message translates to:
  /// **'Turnout Rate'**
  String get resultsTurnoutRate;

  /// No description provided for @resultsViewDetailed.
  ///
  /// In en, this message translates to:
  /// **'View Detailed Results'**
  String get resultsViewDetailed;

  /// No description provided for @myElectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Elections'**
  String get myElectionsTitle;

  /// No description provided for @myElectionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every election you can see across your organizations, in one place.'**
  String get myElectionsSubtitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @filterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get filterUpcoming;

  /// No description provided for @filterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get filterCompleted;

  /// No description provided for @filterParticipated.
  ///
  /// In en, this message translates to:
  /// **'Participated'**
  String get filterParticipated;

  /// No description provided for @filterResultsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Results available'**
  String get filterResultsAvailable;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Election Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarAddToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to calendar'**
  String get calendarAddToCalendar;

  /// No description provided for @emptyGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyGenericTitle;

  /// No description provided for @emptyGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'There\'s nothing to show right now.'**
  String get emptyGenericMessage;

  /// No description provided for @errorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGenericMessage;

  /// No description provided for @loadingGeneric.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingGeneric;

  /// No description provided for @accessibilitySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility & Language'**
  String get accessibilitySettingsTitle;

  /// No description provided for @accessibilityLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accessibilityLanguage;

  /// No description provided for @accessibilityLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get accessibilityLanguageSystem;

  /// No description provided for @accessibilityReducedMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get accessibilityReducedMotion;

  /// No description provided for @accessibilityReducedMotionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Minimize animations throughout the app.'**
  String get accessibilityReducedMotionSubtitle;

  /// No description provided for @accessibilityHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get accessibilityHighContrast;

  /// No description provided for @accessibilityHighContrastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Increase text and border contrast for better visibility.'**
  String get accessibilityHighContrastSubtitle;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportTitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @transparencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Trust & Transparency Center'**
  String get transparencyTitle;

  /// No description provided for @observerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Observer Dashboard'**
  String get observerDashboardTitle;

  /// No description provided for @voterHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'My elections'**
  String get voterHomeTitle;

  /// No description provided for @voterHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Elections you can see across your organizations.'**
  String get voterHomeSubtitle;

  /// No description provided for @voterSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by election or organization'**
  String get voterSearchHint;

  /// No description provided for @voterFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get voterFilterAll;

  /// No description provided for @voterFilterReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to vote'**
  String get voterFilterReady;

  /// No description provided for @voterFilterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get voterFilterUpcoming;

  /// No description provided for @voterFilterParticipated.
  ///
  /// In en, this message translates to:
  /// **'Participated'**
  String get voterFilterParticipated;

  /// No description provided for @voterFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get voterFilterClosed;

  /// No description provided for @voterFilterResults.
  ///
  /// In en, this message translates to:
  /// **'Results published'**
  String get voterFilterResults;

  /// No description provided for @voterSectionReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to vote'**
  String get voterSectionReady;

  /// No description provided for @voterSectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get voterSectionUpcoming;

  /// No description provided for @voterSectionParticipated.
  ///
  /// In en, this message translates to:
  /// **'Participated'**
  String get voterSectionParticipated;

  /// No description provided for @voterSectionOther.
  ///
  /// In en, this message translates to:
  /// **'Other elections'**
  String get voterSectionOther;

  /// No description provided for @voterNoElectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No elections yet'**
  String get voterNoElectionsTitle;

  /// No description provided for @voterNoElectionsBody.
  ///
  /// In en, this message translates to:
  /// **'Elections you are eligible for will appear here.'**
  String get voterNoElectionsBody;

  /// No description provided for @voterNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching elections'**
  String get voterNoMatchTitle;

  /// No description provided for @voterNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter.'**
  String get voterNoMatchBody;

  /// No description provided for @voterLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your elections.'**
  String get voterLoadError;

  /// No description provided for @voterRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get voterRetry;

  /// No description provided for @voterStatusWarning.
  ///
  /// In en, this message translates to:
  /// **'Some details could not be loaded. Actions that depend on them are hidden until they load.'**
  String get voterStatusWarning;

  /// No description provided for @voterActionVoteNow.
  ///
  /// In en, this message translates to:
  /// **'Vote now'**
  String get voterActionVoteNow;

  /// No description provided for @voterActionViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View receipt'**
  String get voterActionViewReceipt;

  /// No description provided for @voterActionViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get voterActionViewDetails;

  /// No description provided for @voterActionChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking your status...'**
  String get voterActionChecking;

  /// No description provided for @voterActionResultsPending.
  ///
  /// In en, this message translates to:
  /// **'Results pending'**
  String get voterActionResultsPending;

  /// No description provided for @voterActionViewResults.
  ///
  /// In en, this message translates to:
  /// **'View published results'**
  String get voterActionViewResults;

  /// No description provided for @voterChipParticipated.
  ///
  /// In en, this message translates to:
  /// **'Participated'**
  String get voterChipParticipated;

  /// No description provided for @voterChipNotEligible.
  ///
  /// In en, this message translates to:
  /// **'Not eligible'**
  String get voterChipNotEligible;

  /// No description provided for @voterChipChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking status'**
  String get voterChipChecking;

  /// No description provided for @voterOpens.
  ///
  /// In en, this message translates to:
  /// **'Opens {date}'**
  String voterOpens(String date);

  /// No description provided for @voterCloses.
  ///
  /// In en, this message translates to:
  /// **'Closes {date}'**
  String voterCloses(String date);

  /// No description provided for @voterClosedOn.
  ///
  /// In en, this message translates to:
  /// **'Closed {date}'**
  String voterClosedOn(String date);

  /// No description provided for @voterCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get voterCalendar;

  /// No description provided for @voterLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get voterLoadMore;

  /// No description provided for @builderLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving?'**
  String get builderLeaveTitle;

  /// No description provided for @builderLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'You have changes that have not been saved to this draft. If you leave now they will be lost.'**
  String get builderLeaveBody;

  /// No description provided for @builderStay.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get builderStay;

  /// No description provided for @builderLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave and discard changes'**
  String get builderLeave;

  /// No description provided for @navMyElections.
  ///
  /// In en, this message translates to:
  /// **'My elections'**
  String get navMyElections;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get navPeople;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get navBilling;

  /// No description provided for @navOrgSettings.
  ///
  /// In en, this message translates to:
  /// **'Organization settings'**
  String get navOrgSettings;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navObserver.
  ///
  /// In en, this message translates to:
  /// **'Observer'**
  String get navObserver;

  /// No description provided for @navPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get navPlatform;

  /// No description provided for @navCreateElection.
  ///
  /// In en, this message translates to:
  /// **'Create election'**
  String get navCreateElection;

  /// No description provided for @navMainLabel.
  ///
  /// In en, this message translates to:
  /// **'Main navigation'**
  String get navMainLabel;

  /// No description provided for @navMoreSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMoreSectionLabel;

  /// No description provided for @navPlatformSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get navPlatformSectionLabel;

  /// No description provided for @adminEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Elections'**
  String get adminEventsTitle;

  /// No description provided for @adminEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create, schedule and monitor elections for your organization.'**
  String get adminEventsSubtitle;

  /// No description provided for @adminCreateElection.
  ///
  /// In en, this message translates to:
  /// **'Create election'**
  String get adminCreateElection;

  /// No description provided for @adminCommandCenter.
  ///
  /// In en, this message translates to:
  /// **'Command center'**
  String get adminCommandCenter;

  /// No description provided for @adminSearchEvents.
  ///
  /// In en, this message translates to:
  /// **'Search elections'**
  String get adminSearchEvents;

  /// No description provided for @adminFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminFilterAll;

  /// No description provided for @adminFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get adminFilterActive;

  /// No description provided for @adminFilterScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get adminFilterScheduled;

  /// No description provided for @adminFilterDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get adminFilterDraft;

  /// No description provided for @adminFilterClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get adminFilterClosed;

  /// No description provided for @adminFilterArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get adminFilterArchived;

  /// No description provided for @adminNoEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'No elections yet'**
  String get adminNoEventsTitle;

  /// No description provided for @adminNoEventsBody.
  ///
  /// In en, this message translates to:
  /// **'Create your first election. You can save it as a draft and publish it when it is ready.'**
  String get adminNoEventsBody;

  /// No description provided for @adminNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No elections match your search or filter.'**
  String get adminNoMatch;

  /// No description provided for @adminLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your elections. Check your connection and try again.'**
  String get adminLoadError;

  /// No description provided for @adminOrgRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'No active organization'**
  String get adminOrgRequiredTitle;

  /// No description provided for @adminOrgRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Choose an organization to manage its elections.'**
  String get adminOrgRequiredBody;

  /// No description provided for @adminSuspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Organization suspended'**
  String get adminSuspendedTitle;

  /// No description provided for @adminSuspendedBody.
  ///
  /// In en, this message translates to:
  /// **'This organization is suspended, so election management is disabled.'**
  String get adminSuspendedBody;

  /// No description provided for @adminProcessing.
  ///
  /// In en, this message translates to:
  /// **'Updating election...'**
  String get adminProcessing;

  /// No description provided for @adminEventRange.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String adminEventRange(String start, String end);

  /// No description provided for @adminTypeCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate election'**
  String get adminTypeCandidate;

  /// No description provided for @adminTypeSingle.
  ///
  /// In en, this message translates to:
  /// **'Single-choice poll'**
  String get adminTypeSingle;

  /// No description provided for @adminTypeYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes/No poll'**
  String get adminTypeYesNo;

  /// No description provided for @adminActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete draft'**
  String get adminActionDelete;

  /// No description provided for @adminActionManageChoices.
  ///
  /// In en, this message translates to:
  /// **'Manage choices'**
  String get adminActionManageChoices;

  /// No description provided for @adminActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get adminActionEdit;

  /// No description provided for @adminActionPublish.
  ///
  /// In en, this message translates to:
  /// **'Review and publish'**
  String get adminActionPublish;

  /// No description provided for @adminActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel election'**
  String get adminActionCancel;

  /// No description provided for @adminActionViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get adminActionViewDetails;

  /// No description provided for @adminActionCloseEarly.
  ///
  /// In en, this message translates to:
  /// **'Close early'**
  String get adminActionCloseEarly;

  /// No description provided for @adminActionMonitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor turnout'**
  String get adminActionMonitor;

  /// No description provided for @adminActionResults.
  ///
  /// In en, this message translates to:
  /// **'View results'**
  String get adminActionResults;

  /// No description provided for @adminDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this draft?'**
  String get adminDeleteTitle;

  /// No description provided for @adminDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be permanently deleted. This cannot be undone.'**
  String adminDeleteBody(String title);

  /// No description provided for @adminCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this election?'**
  String get adminCancelTitle;

  /// No description provided for @adminCancelBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will not open for voting. Voters will no longer see it as upcoming.'**
  String adminCancelBody(String title);

  /// No description provided for @adminCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close voting now?'**
  String get adminCloseTitle;

  /// No description provided for @adminCloseBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will stop accepting votes immediately. This cannot be undone.'**
  String adminCloseBody(String title);

  /// No description provided for @adminKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get adminKeep;

  /// No description provided for @adminConfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete draft'**
  String get adminConfirmDelete;

  /// No description provided for @adminConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel election'**
  String get adminConfirmCancel;

  /// No description provided for @adminConfirmClose.
  ///
  /// In en, this message translates to:
  /// **'Close voting'**
  String get adminConfirmClose;

  /// No description provided for @adminGuideTitle1.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get adminGuideTitle1;

  /// No description provided for @adminGuideBody1.
  ///
  /// In en, this message translates to:
  /// **'Details, schedule and who can vote.'**
  String get adminGuideBody1;

  /// No description provided for @adminGuideTitle2.
  ///
  /// In en, this message translates to:
  /// **'Add choices'**
  String get adminGuideTitle2;

  /// No description provided for @adminGuideBody2.
  ///
  /// In en, this message translates to:
  /// **'Candidates or poll options.'**
  String get adminGuideBody2;

  /// No description provided for @adminGuideTitle3.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get adminGuideTitle3;

  /// No description provided for @adminGuideBody3.
  ///
  /// In en, this message translates to:
  /// **'Review, then open it to voters.'**
  String get adminGuideBody3;

  /// No description provided for @adminGuideTitle4.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get adminGuideTitle4;

  /// No description provided for @adminGuideBody4.
  ///
  /// In en, this message translates to:
  /// **'Turnout while open, results after.'**
  String get adminGuideBody4;

  /// No description provided for @builderCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create election'**
  String get builderCreateTitle;

  /// No description provided for @builderEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit election draft'**
  String get builderEditTitle;

  /// No description provided for @builderBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get builderBack;

  /// No description provided for @builderStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String builderStepOf(int current, int total);

  /// No description provided for @builderStepBasic.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get builderStepBasic;

  /// No description provided for @builderStepSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get builderStepSchedule;

  /// No description provided for @builderStepEligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get builderStepEligibility;

  /// No description provided for @builderStepChoices.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get builderStepChoices;

  /// No description provided for @builderStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get builderStepReview;

  /// No description provided for @builderStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Election setup steps'**
  String get builderStepsLabel;

  /// No description provided for @builderDraftNeeded.
  ///
  /// In en, this message translates to:
  /// **'Save the draft first. Finish the earlier steps, then continue.'**
  String get builderDraftNeeded;

  /// No description provided for @builderCreateDraftNow.
  ///
  /// In en, this message translates to:
  /// **'Save draft now'**
  String get builderCreateDraftNow;

  /// No description provided for @builderCreateDraftFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the draft. Please try again.'**
  String get builderCreateDraftFailed;

  /// No description provided for @builderStepBlocked.
  ///
  /// In en, this message translates to:
  /// **'Finish each step with its Continue button before moving ahead.'**
  String get builderStepBlocked;

  /// No description provided for @builderLoadingDraft.
  ///
  /// In en, this message translates to:
  /// **'Loading election draft...'**
  String get builderLoadingDraft;

  /// No description provided for @builderAdminsOnly.
  ///
  /// In en, this message translates to:
  /// **'Only organization admins can create or edit elections.'**
  String get builderAdminsOnly;

  /// No description provided for @builderReturnHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get builderReturnHome;

  /// No description provided for @overviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What needs attention and what is happening in your organization.'**
  String get overviewSubtitle;

  /// No description provided for @overviewRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs your attention'**
  String get overviewRequiredTitle;

  /// No description provided for @overviewFinishDrafts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 draft election is not published} other{{count} draft elections are not published}}'**
  String overviewFinishDrafts(int count);

  /// No description provided for @overviewReviewInvites.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 invitation is waiting for a response} other{{count} invitations are waiting for a response}}'**
  String overviewReviewInvites(int count);

  /// No description provided for @overviewOpenElections.
  ///
  /// In en, this message translates to:
  /// **'Open elections'**
  String get overviewOpenElections;

  /// No description provided for @overviewOpenPeople.
  ///
  /// In en, this message translates to:
  /// **'Open people'**
  String get overviewOpenPeople;

  /// No description provided for @overviewMetricMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get overviewMetricMembers;

  /// No description provided for @overviewMetricDepartments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get overviewMetricDepartments;

  /// No description provided for @overviewMetricLive.
  ///
  /// In en, this message translates to:
  /// **'Live elections'**
  String get overviewMetricLive;

  /// No description provided for @overviewMetricUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming elections'**
  String get overviewMetricUpcoming;

  /// No description provided for @overviewMetricInvites.
  ///
  /// In en, this message translates to:
  /// **'Pending invitations'**
  String get overviewMetricInvites;

  /// No description provided for @overviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get overviewUnavailable;

  /// No description provided for @overviewLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get overviewLoading;

  /// No description provided for @overviewElectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Live and upcoming elections'**
  String get overviewElectionsTitle;

  /// No description provided for @overviewViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get overviewViewAll;

  /// No description provided for @overviewNoLive.
  ///
  /// In en, this message translates to:
  /// **'No live or upcoming elections.'**
  String get overviewNoLive;

  /// No description provided for @overviewNoLiveBody.
  ///
  /// In en, this message translates to:
  /// **'Create an election to get started.'**
  String get overviewNoLiveBody;

  /// No description provided for @overviewElectionsError.
  ///
  /// In en, this message translates to:
  /// **'We could not load elections.'**
  String get overviewElectionsError;

  /// No description provided for @overviewRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get overviewRetry;

  /// No description provided for @overviewActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get overviewActivityTitle;

  /// No description provided for @overviewNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity yet.'**
  String get overviewNoActivity;

  /// No description provided for @overviewActivityError.
  ///
  /// In en, this message translates to:
  /// **'Recent activity is unavailable.'**
  String get overviewActivityError;

  /// No description provided for @overviewActivityUnknown.
  ///
  /// In en, this message translates to:
  /// **'Admin action'**
  String get overviewActivityUnknown;

  /// No description provided for @overviewShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get overviewShortcuts;

  /// No description provided for @overviewShortcutPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get overviewShortcutPeople;

  /// No description provided for @overviewShortcutDepartments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get overviewShortcutDepartments;

  /// No description provided for @overviewShortcutCodes.
  ///
  /// In en, this message translates to:
  /// **'Joining codes'**
  String get overviewShortcutCodes;

  /// No description provided for @overviewShortcutInvites.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get overviewShortcutInvites;

  /// No description provided for @overviewShortcutCommand.
  ///
  /// In en, this message translates to:
  /// **'Command center'**
  String get overviewShortcutCommand;

  /// No description provided for @overviewShortcutSettings.
  ///
  /// In en, this message translates to:
  /// **'Organization settings'**
  String get overviewShortcutSettings;

  /// No description provided for @overviewShortcutBilling.
  ///
  /// In en, this message translates to:
  /// **'Plans and billing'**
  String get overviewShortcutBilling;

  /// No description provided for @overviewAgoNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get overviewAgoNow;

  /// No description provided for @overviewAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String overviewAgoMinutes(int n);

  /// No description provided for @overviewAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String overviewAgoHours(int n);

  /// No description provided for @overviewAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{n}d ago'**
  String overviewAgoDays(int n);

  /// No description provided for @overviewAgoWeeks.
  ///
  /// In en, this message translates to:
  /// **'{n}w ago'**
  String overviewAgoWeeks(int n);

  /// No description provided for @overviewRole.
  ///
  /// In en, this message translates to:
  /// **'Your role: {role}'**
  String overviewRole(String role);

  /// No description provided for @overviewLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your organization. Please try again.'**
  String get overviewLoadError;

  /// No description provided for @orgsTitle.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get orgsTitle;

  /// No description provided for @orgsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch workspace, join another organization or create your own.'**
  String get orgsSubtitle;

  /// No description provided for @orgsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get orgsCreate;

  /// No description provided for @orgsJoin.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get orgsJoin;

  /// No description provided for @orgsScan.
  ///
  /// In en, this message translates to:
  /// **'Scan QR to join'**
  String get orgsScan;

  /// No description provided for @orgsInvitations.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get orgsInvitations;

  /// No description provided for @orgsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No organizations yet'**
  String get orgsEmptyTitle;

  /// No description provided for @orgsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Join an existing organization with a code or invitation, or create a new one to run elections.'**
  String get orgsEmptyBody;

  /// No description provided for @orgsCreateFull.
  ///
  /// In en, this message translates to:
  /// **'Create organization'**
  String get orgsCreateFull;

  /// No description provided for @orgsJoinFull.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get orgsJoinFull;

  /// No description provided for @orgsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open workspace'**
  String get orgsOpen;

  /// No description provided for @orgsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current workspace'**
  String get orgsCurrent;

  /// No description provided for @orgsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your organizations. Check your connection and try again.'**
  String get orgsLoadError;

  /// No description provided for @orgsRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get orgsRetry;

  /// No description provided for @orgsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get orgsStatusPending;

  /// No description provided for @orgsStatusSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get orgsStatusSuspended;

  /// No description provided for @orgsStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get orgsStatusRejected;

  /// No description provided for @orgsRoleLine.
  ///
  /// In en, this message translates to:
  /// **'Your role: {role}'**
  String orgsRoleLine(String role);

  /// No description provided for @peopleTitle.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get peopleTitle;

  /// No description provided for @peopleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage members, roles and invitations.'**
  String get peopleSubtitle;

  /// No description provided for @peopleAddExisting.
  ///
  /// In en, this message translates to:
  /// **'Add existing user'**
  String get peopleAddExisting;

  /// No description provided for @peopleInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite member'**
  String get peopleInvite;

  /// No description provided for @peopleSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get peopleSearchHint;

  /// No description provided for @peopleSearchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get peopleSearchClear;

  /// No description provided for @peopleFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get peopleFilterAll;

  /// No description provided for @peopleFilterManagers.
  ///
  /// In en, this message translates to:
  /// **'Owners and admins'**
  String get peopleFilterManagers;

  /// No description provided for @peopleFilterMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get peopleFilterMembers;

  /// No description provided for @peopleFilterNotActive.
  ///
  /// In en, this message translates to:
  /// **'Not active'**
  String get peopleFilterNotActive;

  /// No description provided for @peopleNoMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get peopleNoMembersTitle;

  /// No description provided for @peopleNoMembersBody.
  ///
  /// In en, this message translates to:
  /// **'Add existing users or invite people to your organization.'**
  String get peopleNoMembersBody;

  /// No description provided for @peopleNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get peopleNoMatchTitle;

  /// No description provided for @peopleNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'No one matches your search or filter.'**
  String get peopleNoMatchBody;

  /// No description provided for @peopleLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the member list. Check your connection and try again.'**
  String get peopleLoadError;

  /// No description provided for @peopleRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get peopleRetry;

  /// No description provided for @peopleRestricted.
  ///
  /// In en, this message translates to:
  /// **'Access restricted'**
  String get peopleRestricted;

  /// No description provided for @peopleRestrictedBody.
  ///
  /// In en, this message translates to:
  /// **'Only organization admins can see the member list.'**
  String get peopleRestrictedBody;

  /// No description provided for @peopleNoOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'No active organization'**
  String get peopleNoOrgTitle;

  /// No description provided for @peopleNoOrgBody.
  ///
  /// In en, this message translates to:
  /// **'Choose an organization to see its people.'**
  String get peopleNoOrgBody;

  /// No description provided for @peopleUnknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown user'**
  String get peopleUnknownUser;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{shown} of {total} people'**
  String peopleCount(int shown, int total);

  /// No description provided for @invTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending invitations'**
  String get invTitle;

  /// No description provided for @invRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh invitations'**
  String get invRefresh;

  /// No description provided for @invLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load pending invitations.'**
  String get invLoadError;

  /// No description provided for @invTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get invTryAgain;

  /// No description provided for @invNone.
  ///
  /// In en, this message translates to:
  /// **'No pending invitations.'**
  String get invNone;

  /// No description provided for @invExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get invExpired;

  /// No description provided for @invExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring soon'**
  String get invExpiringSoon;

  /// No description provided for @invExpiresDays.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Expires in 1 day} other{Expires in {n} days}}'**
  String invExpiresDays(int n);

  /// No description provided for @invExpiresHours.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Expires in 1 hour} other{Expires in {n} hours}}'**
  String invExpiresHours(int n);

  /// No description provided for @invExpiresMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Expires in 1 minute} other{Expires in {n} minutes}}'**
  String invExpiresMinutes(int n);

  /// No description provided for @invRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get invRevoke;

  /// No description provided for @invRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get invRemove;

  /// No description provided for @invKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get invKeep;

  /// No description provided for @invRevokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke this invitation?'**
  String get invRevokeTitle;

  /// No description provided for @invRevokeBody.
  ///
  /// In en, this message translates to:
  /// **'{who} will no longer be able to accept it. You can invite them again later.'**
  String invRevokeBody(String who);

  /// No description provided for @invRecipient.
  ///
  /// In en, this message translates to:
  /// **'The recipient'**
  String get invRecipient;

  /// No description provided for @invRevoked.
  ///
  /// In en, this message translates to:
  /// **'Invitation revoked.'**
  String get invRevoked;

  /// No description provided for @invRevokeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not revoke the invitation. Please try again.'**
  String get invRevokeFailed;

  /// No description provided for @invOwnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Only an owner can revoke admin invitations'**
  String get invOwnerOnly;

  /// No description provided for @deptTitle.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get deptTitle;

  /// No description provided for @deptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Group members into departments to limit who can vote in an election.'**
  String get deptSubtitle;

  /// No description provided for @deptNew.
  ///
  /// In en, this message translates to:
  /// **'New department'**
  String get deptNew;

  /// No description provided for @deptSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search departments'**
  String get deptSearchHint;

  /// No description provided for @deptSortName.
  ///
  /// In en, this message translates to:
  /// **'Name A to Z'**
  String get deptSortName;

  /// No description provided for @deptSortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name Z to A'**
  String get deptSortNameDesc;

  /// No description provided for @deptSortMembers.
  ///
  /// In en, this message translates to:
  /// **'Most members'**
  String get deptSortMembers;

  /// No description provided for @deptSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get deptSortLabel;

  /// No description provided for @deptNoOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an organization'**
  String get deptNoOrgTitle;

  /// No description provided for @deptNoOrgBody.
  ///
  /// In en, this message translates to:
  /// **'Departments belong to an organization. Choose one to see its departments.'**
  String get deptNoOrgBody;

  /// No description provided for @deptNoOrgAction.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get deptNoOrgAction;

  /// No description provided for @deptEmptyManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'No departments yet'**
  String get deptEmptyManagerTitle;

  /// No description provided for @deptEmptyManagerBody.
  ///
  /// In en, this message translates to:
  /// **'Create departments to organize members and limit who can vote.'**
  String get deptEmptyManagerBody;

  /// No description provided for @deptEmptyMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'No department assigned'**
  String get deptEmptyMemberTitle;

  /// No description provided for @deptEmptyMemberBody.
  ///
  /// In en, this message translates to:
  /// **'You are not assigned to a department in this organization.'**
  String get deptEmptyMemberBody;

  /// No description provided for @deptNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No departments match your search.'**
  String get deptNoMatch;

  /// No description provided for @deptLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load departments. Check your connection and try again.'**
  String get deptLoadError;

  /// No description provided for @deptRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get deptRetry;

  /// No description provided for @deptMembersUnknown.
  ///
  /// In en, this message translates to:
  /// **'Members: unavailable'**
  String get deptMembersUnknown;

  /// No description provided for @deptEventsNone.
  ///
  /// In en, this message translates to:
  /// **'Not used in an election yet'**
  String get deptEventsNone;

  /// No description provided for @deptManageMembers.
  ///
  /// In en, this message translates to:
  /// **'Manage members'**
  String get deptManageMembers;

  /// No description provided for @deptActions.
  ///
  /// In en, this message translates to:
  /// **'Department actions'**
  String get deptActions;

  /// No description provided for @deptEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get deptEdit;

  /// No description provided for @deptDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete department'**
  String get deptDelete;

  /// No description provided for @deptDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete department?'**
  String get deptDeleteTitle;

  /// No description provided for @deptDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be permanently deleted. Members keep their records, but the department can no longer be assigned or used for voter eligibility.'**
  String deptDeleteBody(String name);

  /// No description provided for @deptDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete department'**
  String get deptDeleteConfirm;

  /// No description provided for @deptKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get deptKeep;

  /// No description provided for @deptDeleted.
  ///
  /// In en, this message translates to:
  /// **'Department deleted.'**
  String get deptDeleted;

  /// No description provided for @deptDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the department. Please try again.'**
  String get deptDeleteFailed;

  /// No description provided for @deptCreateHint.
  ///
  /// In en, this message translates to:
  /// **'Create a group for your members'**
  String get deptCreateHint;

  /// No description provided for @deptCount.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 department} other{{n} departments}}'**
  String deptCount(int n);

  /// No description provided for @deptMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 member} other{{n} members}}'**
  String deptMemberCount(int n);

  /// No description provided for @deptUsedIn.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Used in 1 election} other{Used in {n} elections}}'**
  String deptUsedIn(int n);

  /// No description provided for @inbTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get inbTitle;

  /// No description provided for @inbSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review invitations to join an organization and choose how to respond.'**
  String get inbSubtitle;

  /// No description provided for @inbPending.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{1 pending invitation} other{{n} pending invitations}}'**
  String inbPending(int n);

  /// No description provided for @inbEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up'**
  String get inbEmptyTitle;

  /// No description provided for @inbEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Organization invitations appear here. You can accept or decline each one.'**
  String get inbEmptyBody;

  /// No description provided for @inbLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your invitations. Check your connection and try again.'**
  String get inbLoadError;

  /// No description provided for @inbRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get inbRetry;

  /// No description provided for @inbAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept invitation'**
  String get inbAccept;

  /// No description provided for @inbDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get inbDecline;

  /// No description provided for @inbAcceptExpired.
  ///
  /// In en, this message translates to:
  /// **'Invitation expired'**
  String get inbAcceptExpired;

  /// No description provided for @inbRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get inbRole;

  /// No description provided for @inbExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {date}'**
  String inbExpires(String date);

  /// No description provided for @inbExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get inbExpired;

  /// No description provided for @inbNoExpiry.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get inbNoExpiry;

  /// No description provided for @inbDefaultOrg.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get inbDefaultOrg;

  /// No description provided for @inbJoinLine.
  ///
  /// In en, this message translates to:
  /// **'Join {org} as {role}'**
  String inbJoinLine(String org, String role);

  /// No description provided for @inbAcceptNote.
  ///
  /// In en, this message translates to:
  /// **'Accepting adds {org} to your organizations. You can switch workspaces at any time.'**
  String inbAcceptNote(String org);

  /// No description provided for @inbDeclineTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline this invitation?'**
  String get inbDeclineTitle;

  /// No description provided for @inbDeclineBody.
  ///
  /// In en, this message translates to:
  /// **'You will not join {org}. An admin can invite you again later.'**
  String inbDeclineBody(String org);

  /// No description provided for @inbKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep invitation'**
  String get inbKeep;

  /// No description provided for @inbDeclineConfirm.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get inbDeclineConfirm;

  /// No description provided for @inbJoined.
  ///
  /// In en, this message translates to:
  /// **'You joined {org}.'**
  String inbJoined(String org);

  /// No description provided for @inbDeclined.
  ///
  /// In en, this message translates to:
  /// **'Invitation declined.'**
  String get inbDeclined;

  /// No description provided for @inbRespondFailed.
  ///
  /// In en, this message translates to:
  /// **'We could not complete that. Please try again.'**
  String get inbRespondFailed;

  /// No description provided for @inbHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help with an invitation? Contact Kivora support.'**
  String get inbHelp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'sd', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'sd':
      return AppLocalizationsSd();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
