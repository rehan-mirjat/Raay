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
  /// **'Create account'**
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
  /// **'Profile'**
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

  /// No description provided for @ballotTitle.
  ///
  /// In en, this message translates to:
  /// **'Your ballot'**
  String get ballotTitle;

  /// No description provided for @ballotSelectFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose an option before continuing.'**
  String get ballotSelectFirst;

  /// No description provided for @ballotLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load this ballot. Check your connection and try again.'**
  String get ballotLoadError;

  /// No description provided for @ballotRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get ballotRetry;

  /// No description provided for @ballotNotFound.
  ///
  /// In en, this message translates to:
  /// **'This election could not be found.'**
  String get ballotNotFound;

  /// No description provided for @ballotSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in to vote.'**
  String get ballotSignIn;

  /// No description provided for @ballotNoCandidates.
  ///
  /// In en, this message translates to:
  /// **'No candidates have been added to this election.'**
  String get ballotNoCandidates;

  /// No description provided for @ballotNoOptions.
  ///
  /// In en, this message translates to:
  /// **'No options have been added to this election.'**
  String get ballotNoOptions;

  /// No description provided for @ballotOptionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the choices. Try again.'**
  String get ballotOptionsLoadError;

  /// No description provided for @ballotYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get ballotYes;

  /// No description provided for @ballotYesDesc.
  ///
  /// In en, this message translates to:
  /// **'In favor of this proposal'**
  String get ballotYesDesc;

  /// No description provided for @ballotNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get ballotNo;

  /// No description provided for @ballotNoDesc.
  ///
  /// In en, this message translates to:
  /// **'Opposed to this proposal'**
  String get ballotNoDesc;

  /// No description provided for @ballotOfficial.
  ///
  /// In en, this message translates to:
  /// **'Official ballot'**
  String get ballotOfficial;

  /// No description provided for @ballotFinality.
  ///
  /// In en, this message translates to:
  /// **'Your vote is final. After you confirm, you cannot change it or vote again.'**
  String get ballotFinality;

  /// No description provided for @ballotTimeDays.
  ///
  /// In en, this message translates to:
  /// **'{n}d left'**
  String ballotTimeDays(int n);

  /// No description provided for @ballotTimeHours.
  ///
  /// In en, this message translates to:
  /// **'{n}h left'**
  String ballotTimeHours(int n);

  /// No description provided for @ballotTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n}m left'**
  String ballotTimeMinutes(int n);

  /// No description provided for @ballotTimeSoon.
  ///
  /// In en, this message translates to:
  /// **'Closing soon'**
  String get ballotTimeSoon;

  /// No description provided for @ballotTimeClosed.
  ///
  /// In en, this message translates to:
  /// **'Voting closed'**
  String get ballotTimeClosed;

  /// No description provided for @ballotCandidate.
  ///
  /// In en, this message translates to:
  /// **'{name}, candidate'**
  String ballotCandidate(String name);

  /// No description provided for @ballotOption.
  ///
  /// In en, this message translates to:
  /// **'{name}, option'**
  String ballotOption(String name);

  /// No description provided for @ballotSelectedSuffix.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get ballotSelectedSuffix;

  /// No description provided for @ballotReceiptMissing.
  ///
  /// In en, this message translates to:
  /// **'We could not find your receipt yet. Try again in a moment.'**
  String get ballotReceiptMissing;

  /// No description provided for @ballotYourChoice.
  ///
  /// In en, this message translates to:
  /// **'Your choice'**
  String get ballotYourChoice;

  /// No description provided for @ballotStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}: {label}'**
  String ballotStepsLabel(int current, int total, String label);

  /// No description provided for @receiptSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your ballot was recorded'**
  String get receiptSuccess;

  /// No description provided for @receiptSecrecy.
  ///
  /// In en, this message translates to:
  /// **'This receipt confirms that your ballot was accepted. It does not reveal or encode what you chose, and it cannot prove your choice to anyone.'**
  String get receiptSecrecy;

  /// No description provided for @receiptKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep your receipt ID. You can use it later to check that your ballot was recorded.'**
  String get receiptKeep;

  /// No description provided for @receiptDetails.
  ///
  /// In en, this message translates to:
  /// **'Receipt details'**
  String get receiptDetails;

  /// No description provided for @receiptTime.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get receiptTime;

  /// No description provided for @receiptTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get receiptTechnical;

  /// No description provided for @receiptHashLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification hash (SHA-256)'**
  String get receiptHashLabel;

  /// No description provided for @receiptCopyLabel.
  ///
  /// In en, this message translates to:
  /// **'Copy {label}'**
  String receiptCopyLabel(String label);

  /// No description provided for @receiptCopied.
  ///
  /// In en, this message translates to:
  /// **'{label} copied'**
  String receiptCopied(String label);

  /// No description provided for @receiptVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify a receipt'**
  String get receiptVerify;

  /// No description provided for @receiptClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get receiptClose;

  /// No description provided for @evBack.
  ///
  /// In en, this message translates to:
  /// **'Back to elections'**
  String get evBack;

  /// No description provided for @evLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load this election. Check your connection and try again.'**
  String get evLoadError;

  /// No description provided for @evRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get evRetry;

  /// No description provided for @evNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Election not found'**
  String get evNotFoundTitle;

  /// No description provided for @evNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'This election does not exist or was removed.'**
  String get evNotFoundBody;

  /// No description provided for @evSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get evSignInTitle;

  /// No description provided for @evSignInBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view this election.'**
  String get evSignInBody;

  /// No description provided for @evStatusLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not check whether you have voted. Try again before voting.'**
  String get evStatusLoadError;

  /// No description provided for @evVotedTitle.
  ///
  /// In en, this message translates to:
  /// **'You voted in this election'**
  String get evVotedTitle;

  /// No description provided for @evVotedBody.
  ///
  /// In en, this message translates to:
  /// **'Your participation was recorded.'**
  String get evVotedBody;

  /// No description provided for @evVotedNote.
  ///
  /// In en, this message translates to:
  /// **'Each member can vote once, so voting again is not possible. Keep your receipt ID to check later that your ballot was recorded.'**
  String get evVotedNote;

  /// No description provided for @evViewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View your receipt'**
  String get evViewReceipt;

  /// No description provided for @evReceiptMissing.
  ///
  /// In en, this message translates to:
  /// **'We could not find your receipt yet. Try again in a moment.'**
  String get evReceiptMissing;

  /// No description provided for @evProceed.
  ///
  /// In en, this message translates to:
  /// **'Go to ballot'**
  String get evProceed;

  /// No description provided for @evNotAccepting.
  ///
  /// In en, this message translates to:
  /// **'This election is {status} and is not accepting votes.'**
  String evNotAccepting(String status);

  /// No description provided for @evResultsPublishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Results are published'**
  String get evResultsPublishedTitle;

  /// No description provided for @evResultsPublishedBody.
  ///
  /// In en, this message translates to:
  /// **'Voting closed {date}.'**
  String evResultsPublishedBody(String date);

  /// No description provided for @evResultsPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Results are not published yet'**
  String get evResultsPendingTitle;

  /// No description provided for @evResultsPendingBody.
  ///
  /// In en, this message translates to:
  /// **'Voting closed {date}. Results appear here once the organization publishes them.'**
  String evResultsPendingBody(String date);

  /// No description provided for @evResultsUnknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Results status unavailable'**
  String get evResultsUnknownTitle;

  /// No description provided for @evResultsUnknownBody.
  ///
  /// In en, this message translates to:
  /// **'We could not check whether results are published.'**
  String get evResultsUnknownBody;

  /// No description provided for @evViewResults.
  ///
  /// In en, this message translates to:
  /// **'View results'**
  String get evViewResults;

  /// No description provided for @evDetails.
  ///
  /// In en, this message translates to:
  /// **'Election details'**
  String get evDetails;

  /// No description provided for @evType.
  ///
  /// In en, this message translates to:
  /// **'Voting type'**
  String get evType;

  /// No description provided for @evWho.
  ///
  /// In en, this message translates to:
  /// **'Who can vote'**
  String get evWho;

  /// No description provided for @evOpens.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get evOpens;

  /// No description provided for @evOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get evOpened;

  /// No description provided for @evCloses.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get evCloses;

  /// No description provided for @evClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get evClosed;

  /// No description provided for @evIdentifiableTitle.
  ///
  /// In en, this message translates to:
  /// **'Identifiable ballot.'**
  String get evIdentifiableTitle;

  /// No description provided for @evIdentifiableBody.
  ///
  /// In en, this message translates to:
  /// **'Votes in this election are recorded together with the voter\'s identity.'**
  String get evIdentifiableBody;

  /// No description provided for @evMonitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor turnout'**
  String get evMonitor;

  /// No description provided for @evEditBuilder.
  ///
  /// In en, this message translates to:
  /// **'Edit in builder'**
  String get evEditBuilder;

  /// No description provided for @evChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking your status'**
  String get evChecking;

  /// No description provided for @resTitle.
  ///
  /// In en, this message translates to:
  /// **'Election results'**
  String get resTitle;

  /// No description provided for @resBack.
  ///
  /// In en, this message translates to:
  /// **'Back to election'**
  String get resBack;

  /// No description provided for @resPublished.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get resPublished;

  /// No description provided for @resNotPublished.
  ///
  /// In en, this message translates to:
  /// **'Not published'**
  String get resNotPublished;

  /// No description provided for @resSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Counted by the server after voting closed.'**
  String get resSubtitle;

  /// No description provided for @resAdminOnly.
  ///
  /// In en, this message translates to:
  /// **'Only organization admins can see these results until they are published.'**
  String get resAdminOnly;

  /// No description provided for @resFootnote.
  ///
  /// In en, this message translates to:
  /// **'Percentages are of ballots counted. Members can see results only after an admin publishes them.'**
  String get resFootnote;

  /// No description provided for @resNotAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Results are not available'**
  String get resNotAvailableTitle;

  /// No description provided for @resNotAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'Results appear here after the organization publishes them.'**
  String get resNotAvailableBody;

  /// No description provided for @resLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'We could not load the results'**
  String get resLoadErrorTitle;

  /// No description provided for @resLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get resLoadErrorBody;

  /// No description provided for @resRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get resRetry;

  /// No description provided for @resNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No results yet'**
  String get resNoneTitle;

  /// No description provided for @resNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Results have not been calculated yet.'**
  String get resNoneBody;

  /// No description provided for @resNoBallots.
  ///
  /// In en, this message translates to:
  /// **'No ballots were recorded for this election.'**
  String get resNoBallots;

  /// No description provided for @resBallots.
  ///
  /// In en, this message translates to:
  /// **'Ballots counted'**
  String get resBallots;

  /// No description provided for @resEligible.
  ///
  /// In en, this message translates to:
  /// **'Eligible voters'**
  String get resEligible;

  /// No description provided for @resTurnout.
  ///
  /// In en, this message translates to:
  /// **'Turnout'**
  String get resTurnout;

  /// No description provided for @resSplit.
  ///
  /// In en, this message translates to:
  /// **'Vote split'**
  String get resSplit;

  /// No description provided for @resTie.
  ///
  /// In en, this message translates to:
  /// **'It\'s a tie'**
  String get resTie;

  /// No description provided for @resTieBody.
  ///
  /// In en, this message translates to:
  /// **'{names} each received {votes, plural, =1{1 vote} other{{votes} votes}} ({percent}%).'**
  String resTieBody(String names, int votes, String percent);

  /// No description provided for @resWins.
  ///
  /// In en, this message translates to:
  /// **'{name} wins'**
  String resWins(String name);

  /// No description provided for @resWinsBody.
  ///
  /// In en, this message translates to:
  /// **'{votes, plural, =1{1 vote} other{{votes} votes}} ({percent}%).'**
  String resWinsBody(int votes, String percent);

  /// No description provided for @resVotes.
  ///
  /// In en, this message translates to:
  /// **'{votes, plural, =1{1 vote} other{{votes} votes}}'**
  String resVotes(int votes);

  /// No description provided for @resRecalculate.
  ///
  /// In en, this message translates to:
  /// **'Recalculate results'**
  String get resRecalculate;

  /// No description provided for @resWorking.
  ///
  /// In en, this message translates to:
  /// **'Working...'**
  String get resWorking;

  /// No description provided for @resPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish results to members'**
  String get resPublish;

  /// No description provided for @resCalculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate results'**
  String get resCalculate;

  /// No description provided for @resExport.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get resExport;

  /// No description provided for @resExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export results (CSV)'**
  String get resExportTitle;

  /// No description provided for @resCopyCsv.
  ///
  /// In en, this message translates to:
  /// **'Copy CSV'**
  String get resCopyCsv;

  /// No description provided for @resCsvCopied.
  ///
  /// In en, this message translates to:
  /// **'CSV copied'**
  String get resCsvCopied;

  /// No description provided for @resClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get resClose;

  /// No description provided for @resActionFailed.
  ///
  /// In en, this message translates to:
  /// **'That did not work. Please try again.'**
  String get resActionFailed;

  /// No description provided for @resPublishConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish these results?'**
  String get resPublishConfirmTitle;

  /// No description provided for @resPublishConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All eligible members will be able to see the results, and those who have result notifications on will be notified. You can still recalculate them afterwards.'**
  String get resPublishConfirmBody;

  /// No description provided for @resPublishConfirm.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get resPublishConfirm;

  /// No description provided for @resCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get resCancel;

  /// No description provided for @resEventFallback.
  ///
  /// In en, this message translates to:
  /// **'Election'**
  String get resEventFallback;

  /// No description provided for @monTitle.
  ///
  /// In en, this message translates to:
  /// **'Live turnout'**
  String get monTitle;

  /// No description provided for @monBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get monBack;

  /// No description provided for @monLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get monLive;

  /// No description provided for @monUpdated.
  ///
  /// In en, this message translates to:
  /// **'Live · updated {s}s ago'**
  String monUpdated(int s);

  /// No description provided for @monRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get monRefresh;

  /// No description provided for @monClosesIn.
  ///
  /// In en, this message translates to:
  /// **'Closes in {when}'**
  String monClosesIn(String when);

  /// No description provided for @monRemainDaysHours.
  ///
  /// In en, this message translates to:
  /// **'{d, plural, =1{1 day} other{{d} days}} {h, plural, =1{1 hour} other{{h} hours}}'**
  String monRemainDaysHours(int d, int h);

  /// No description provided for @monRemainHoursMin.
  ///
  /// In en, this message translates to:
  /// **'{h, plural, =1{1 hour} other{{h} hours}} {m} min'**
  String monRemainHoursMin(int h, int m);

  /// No description provided for @monRemainMin.
  ///
  /// In en, this message translates to:
  /// **'{m} min'**
  String monRemainMin(int m);

  /// No description provided for @monPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Counts only. No voter identities or ballot selections are shown here. Results stay hidden until the election is closed and published.'**
  String get monPrivacy;

  /// No description provided for @monLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load turnout. Check your connection and try again.'**
  String get monLoadError;

  /// No description provided for @monRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get monRetry;

  /// No description provided for @monRefreshIssue.
  ///
  /// In en, this message translates to:
  /// **'The latest refresh failed. Showing the last numbers we loaded.'**
  String get monRefreshIssue;

  /// No description provided for @monTurnoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Eligible members who participated'**
  String get monTurnoutLabel;

  /// No description provided for @monOfEligible.
  ///
  /// In en, this message translates to:
  /// **'{voted} of {eligible}'**
  String monOfEligible(int voted, int eligible);

  /// No description provided for @monEligible.
  ///
  /// In en, this message translates to:
  /// **'Eligible'**
  String get monEligible;

  /// No description provided for @monEligibleCap.
  ///
  /// In en, this message translates to:
  /// **'All active members'**
  String get monEligibleCap;

  /// No description provided for @monVoted.
  ///
  /// In en, this message translates to:
  /// **'Voted'**
  String get monVoted;

  /// No description provided for @monVotedCap.
  ///
  /// In en, this message translates to:
  /// **'Ballots submitted'**
  String get monVotedCap;

  /// No description provided for @monNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get monNotYet;

  /// No description provided for @monNotYetCap.
  ///
  /// In en, this message translates to:
  /// **'Members remaining'**
  String get monNotYetCap;

  /// No description provided for @monChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Participation over time'**
  String get monChartTitle;

  /// No description provided for @monChartSub.
  ///
  /// In en, this message translates to:
  /// **'Cumulative participation since the election opened'**
  String get monChartSub;

  /// No description provided for @monChartNone.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet to chart participation over time.'**
  String get monChartNone;

  /// No description provided for @monChartTotal.
  ///
  /// In en, this message translates to:
  /// **'{n} voted'**
  String monChartTotal(int n);

  /// No description provided for @monChartStart.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get monChartStart;

  /// No description provided for @monChartNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get monChartNow;

  /// No description provided for @monDeptTitle.
  ///
  /// In en, this message translates to:
  /// **'Turnout by department'**
  String get monDeptTitle;

  /// No description provided for @monDeptNone.
  ///
  /// In en, this message translates to:
  /// **'No department data for this election.'**
  String get monDeptNone;

  /// No description provided for @monDeptNote.
  ///
  /// In en, this message translates to:
  /// **'Groups with fewer than 5 eligible members are combined to protect privacy.'**
  String get monDeptNote;

  /// No description provided for @monDeptRow.
  ///
  /// In en, this message translates to:
  /// **'{participated} of {eligible} · {percent}%'**
  String monDeptRow(int participated, int eligible, String percent);

  /// No description provided for @monDeptFallback.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get monDeptFallback;

  /// No description provided for @monDetails.
  ///
  /// In en, this message translates to:
  /// **'Election details'**
  String get monDetails;

  /// No description provided for @monWindow.
  ///
  /// In en, this message translates to:
  /// **'Voting window'**
  String get monWindow;

  /// No description provided for @monBallotType.
  ///
  /// In en, this message translates to:
  /// **'Ballot type'**
  String get monBallotType;

  /// No description provided for @monAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get monAnonymous;

  /// No description provided for @monIdentifiable.
  ///
  /// In en, this message translates to:
  /// **'Identifiable'**
  String get monIdentifiable;

  /// No description provided for @monEligibility.
  ///
  /// In en, this message translates to:
  /// **'Who can vote'**
  String get monEligibility;

  /// No description provided for @monVotingType.
  ///
  /// In en, this message translates to:
  /// **'Voting type'**
  String get monVotingType;

  /// No description provided for @monBoostTitle.
  ///
  /// In en, this message translates to:
  /// **'Boost turnout'**
  String get monBoostTitle;

  /// No description provided for @monBoostBody.
  ///
  /// In en, this message translates to:
  /// **'Remind members who have not voted. Reminders go to non-voters automatically; you will not see who has or has not voted.'**
  String get monBoostBody;

  /// No description provided for @monRemind.
  ///
  /// In en, this message translates to:
  /// **'Remind non-voters'**
  String get monRemind;

  /// No description provided for @monSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get monSending;

  /// No description provided for @monRemindNone.
  ///
  /// In en, this message translates to:
  /// **'Everyone eligible has already voted.'**
  String get monRemindNone;

  /// No description provided for @monRemindDone.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =1{Reminder sent to 1 non-voter.} other{Reminder sent to {n} non-voters.}}'**
  String monRemindDone(int n);

  /// No description provided for @monRemindFailed.
  ///
  /// In en, this message translates to:
  /// **'We could not send reminders. Please try again.'**
  String get monRemindFailed;

  /// No description provided for @monPrivateNote.
  ///
  /// In en, this message translates to:
  /// **'Participation stays private'**
  String get monPrivateNote;

  /// No description provided for @monCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close voting early'**
  String get monCloseTitle;

  /// No description provided for @monCloseNote.
  ///
  /// In en, this message translates to:
  /// **'Closing is final. You may need to sign in again if your last sign-in was over 15 minutes ago. Results stay hidden until you calculate and publish them.'**
  String get monCloseNote;

  /// No description provided for @monCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close voting now'**
  String get monCloseButton;

  /// No description provided for @monCloseDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Close voting now?'**
  String get monCloseDialogTitle;

  /// No description provided for @monCloseDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Closing is final. Members will no longer be able to vote, and this cannot be undone. Results stay hidden until you calculate and publish them.'**
  String get monCloseDialogBody;

  /// No description provided for @monCloseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close voting'**
  String get monCloseConfirm;

  /// No description provided for @monCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get monCancel;

  /// No description provided for @monClosed.
  ///
  /// In en, this message translates to:
  /// **'Voting closed.'**
  String get monClosed;

  /// No description provided for @monCloseFailed.
  ///
  /// In en, this message translates to:
  /// **'We could not close voting. Please try again.'**
  String get monCloseFailed;

  /// No description provided for @monReauth.
  ///
  /// In en, this message translates to:
  /// **'For security, closing an election requires you to have signed in within the last 15 minutes. Please verify your identity to continue.'**
  String get monReauth;

  /// No description provided for @calTitle.
  ///
  /// In en, this message translates to:
  /// **'Election calendar'**
  String get calTitle;

  /// No description provided for @calAgendaView.
  ///
  /// In en, this message translates to:
  /// **'Agenda view'**
  String get calAgendaView;

  /// No description provided for @calCalendarView.
  ///
  /// In en, this message translates to:
  /// **'Calendar view'**
  String get calCalendarView;

  /// No description provided for @calLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the calendar. Check your connection and try again.'**
  String get calLoadError;

  /// No description provided for @calRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get calRetry;

  /// No description provided for @calAllOrgs.
  ///
  /// In en, this message translates to:
  /// **'All organizations'**
  String get calAllOrgs;

  /// No description provided for @calMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calMonth;

  /// No description provided for @calWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get calWeek;

  /// No description provided for @calNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No elections to show'**
  String get calNoneTitle;

  /// No description provided for @calNoneBody.
  ///
  /// In en, this message translates to:
  /// **'There are no elections in your organizations yet.'**
  String get calNoneBody;

  /// No description provided for @calNoDayTitle.
  ///
  /// In en, this message translates to:
  /// **'No elections on this day'**
  String get calNoDayTitle;

  /// No description provided for @calNoDayBody.
  ///
  /// In en, this message translates to:
  /// **'Pick another date to see what is scheduled.'**
  String get calNoDayBody;

  /// No description provided for @calCount.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, =0{No elections} =1{1 election} other{{n} elections}}'**
  String calCount(int n);

  /// No description provided for @calDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get calDetails;

  /// No description provided for @calAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to calendar'**
  String get calAdd;

  /// No description provided for @calRange.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String calRange(String start, String end);

  /// No description provided for @authOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get authOr;

  /// No description provided for @authNewUser.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get authNewUser;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authHaveAccount;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authRemembered.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get authRemembered;

  /// No description provided for @authShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePassword;

  /// No description provided for @authUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authUnexpectedError;

  /// No description provided for @authMfaUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This account\'s second sign-in step is not supported by this app yet. Please contact support.'**
  String get authMfaUnsupported;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get statusActive;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULED'**
  String get statusScheduled;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'CLOSED'**
  String get statusClosed;

  /// No description provided for @statusArchived.
  ///
  /// In en, this message translates to:
  /// **'ARCHIVED'**
  String get statusArchived;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'CANCELLED'**
  String get statusCancelled;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'DRAFT'**
  String get statusDraft;

  /// No description provided for @statusUnknown.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN'**
  String get statusUnknown;

  /// No description provided for @privacyAnonymous.
  ///
  /// In en, this message translates to:
  /// **'ANONYMOUS'**
  String get privacyAnonymous;

  /// No description provided for @privacyIdentifiable.
  ///
  /// In en, this message translates to:
  /// **'IDENTIFIABLE'**
  String get privacyIdentifiable;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'OWNER'**
  String get roleOwner;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'ADMIN'**
  String get roleAdmin;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'MEMBER'**
  String get roleMember;

  /// No description provided for @navJoiningCodes.
  ///
  /// In en, this message translates to:
  /// **'Joining codes'**
  String get navJoiningCodes;

  /// No description provided for @navPlatformAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts & access'**
  String get navPlatformAccounts;

  /// No description provided for @navInvitations.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get navInvitations;

  /// No description provided for @acctTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get acctTitle;

  /// No description provided for @acctTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get acctTabProfile;

  /// No description provided for @acctTabSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & Settings'**
  String get acctTabSecurity;

  /// No description provided for @acctTabNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get acctTabNotifications;

  /// No description provided for @acctTabPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get acctTabPreferences;

  /// No description provided for @acctTabAccounts.
  ///
  /// In en, this message translates to:
  /// **'Connected Accounts'**
  String get acctTabAccounts;

  /// No description provided for @acctTabSecurityShort.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get acctTabSecurityShort;

  /// No description provided for @acctTabNotificationsShort.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get acctTabNotificationsShort;

  /// No description provided for @acctTabPreferencesShort.
  ///
  /// In en, this message translates to:
  /// **'Prefs'**
  String get acctTabPreferencesShort;

  /// No description provided for @acctTabAccountsShort.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get acctTabAccountsShort;

  /// No description provided for @acctLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading user profile...'**
  String get acctLoading;

  /// No description provided for @acctLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load your profile. Check your connection and try again.'**
  String get acctLoadError;

  /// No description provided for @acctNotFound.
  ///
  /// In en, this message translates to:
  /// **'User profile not found.'**
  String get acctNotFound;

  /// No description provided for @acctPhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully.'**
  String get acctPhotoUpdated;

  /// No description provided for @acctPhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload the photo. Please try again.'**
  String get acctPhotoFailed;

  /// No description provided for @acctProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get acctProfileUpdated;

  /// No description provided for @acctVerified.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get acctVerified;

  /// No description provided for @acctUnverified.
  ///
  /// In en, this message translates to:
  /// **'UNVERIFIED'**
  String get acctUnverified;

  /// No description provided for @acctMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String acctMemberSince(String date);

  /// No description provided for @acctPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get acctPersonalInfo;

  /// No description provided for @acctFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get acctFirstName;

  /// No description provided for @acctLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get acctLastName;

  /// No description provided for @acctFirstNameField.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get acctFirstNameField;

  /// No description provided for @acctLastNameField.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get acctLastNameField;

  /// No description provided for @acctPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (Optional)'**
  String get acctPhone;

  /// No description provided for @acctSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get acctSaveChanges;

  /// No description provided for @acctAuthMethod.
  ///
  /// In en, this message translates to:
  /// **'Authentication Method'**
  String get acctAuthMethod;

  /// No description provided for @acctGoogleNote.
  ///
  /// In en, this message translates to:
  /// **'Your account is connected to Google. Password changes are managed through your Google account.'**
  String get acctGoogleNote;

  /// No description provided for @acct2fa.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get acct2fa;

  /// No description provided for @acct2faBody.
  ///
  /// In en, this message translates to:
  /// **'Protect your account by requiring an additional authentication step.'**
  String get acct2faBody;

  /// No description provided for @acctSetupAuth.
  ///
  /// In en, this message translates to:
  /// **'Setup Authenticator App'**
  String get acctSetupAuth;

  /// No description provided for @acctSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get acctSignOut;

  /// No description provided for @acctAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get acctAppearance;

  /// No description provided for @acctAppearanceBody.
  ///
  /// In en, this message translates to:
  /// **'Choose how Kivora looks on this device.'**
  String get acctAppearanceBody;

  /// No description provided for @acctThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get acctThemeLight;

  /// No description provided for @acctThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get acctThemeDark;

  /// No description provided for @acctThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get acctThemeSystem;

  /// No description provided for @acctLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get acctLanguage;

  /// No description provided for @acctLanguageNote.
  ///
  /// In en, this message translates to:
  /// **'Urdu, Sindhi, and Arabic translations are machine-assisted and have not yet been reviewed by a native speaker - please report anything that reads incorrectly.'**
  String get acctLanguageNote;

  /// No description provided for @acctSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get acctSystemDefault;

  /// No description provided for @acctAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get acctAccessibility;

  /// No description provided for @acctReduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get acctReduceMotion;

  /// No description provided for @acctReduceMotionBody.
  ///
  /// In en, this message translates to:
  /// **'Minimize animations throughout the app.'**
  String get acctReduceMotionBody;

  /// No description provided for @acctHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High contrast'**
  String get acctHighContrast;

  /// No description provided for @acctHighContrastBody.
  ///
  /// In en, this message translates to:
  /// **'Increase text and border contrast for better visibility.'**
  String get acctHighContrastBody;

  /// No description provided for @acctTextSizeNote.
  ///
  /// In en, this message translates to:
  /// **'Text size follows your device\'s own accessibility settings. Candidate/option selections on the ballot screen are already labeled for screen readers.'**
  String get acctTextSizeNote;

  /// No description provided for @acctNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get acctNotifications;

  /// No description provided for @acctNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Choose which notifications you want to receive. These apply to the notification bell and reminder emails.'**
  String get acctNotificationsBody;

  /// No description provided for @acctVoteReminders.
  ///
  /// In en, this message translates to:
  /// **'Vote reminders'**
  String get acctVoteReminders;

  /// No description provided for @acctVoteRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'Get notified when an active election is about to close and you haven\'t voted.'**
  String get acctVoteRemindersBody;

  /// No description provided for @acctResultsPublished.
  ///
  /// In en, this message translates to:
  /// **'Results published'**
  String get acctResultsPublished;

  /// No description provided for @acctResultsPublishedBody.
  ///
  /// In en, this message translates to:
  /// **'Get notified when results are published for an election you were eligible to vote in.'**
  String get acctResultsPublishedBody;

  /// No description provided for @acctInvitationAlerts.
  ///
  /// In en, this message translates to:
  /// **'Organization invitations'**
  String get acctInvitationAlerts;

  /// No description provided for @acctInvitationAlertsBody.
  ///
  /// In en, this message translates to:
  /// **'Show pending organization invitations in the notification bell.'**
  String get acctInvitationAlertsBody;

  /// No description provided for @acctConnectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Connected Accounts'**
  String get acctConnectedTitle;

  /// No description provided for @acctConnectedBody.
  ///
  /// In en, this message translates to:
  /// **'Sign-in methods linked to your Kivora account. You must keep at least one connected.'**
  String get acctConnectedBody;

  /// No description provided for @acctEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Email & Password'**
  String get acctEmailPassword;

  /// No description provided for @acctGoogleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your Google account.'**
  String get acctGoogleSignIn;

  /// No description provided for @acctConnectedBadge.
  ///
  /// In en, this message translates to:
  /// **'CONNECTED'**
  String get acctConnectedBadge;

  /// No description provided for @acctConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get acctConnect;

  /// No description provided for @acctDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get acctDisconnect;

  /// No description provided for @acctDisconnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect {name}?'**
  String acctDisconnectTitle(String name);

  /// No description provided for @acctDisconnectBody.
  ///
  /// In en, this message translates to:
  /// **'You will no longer be able to sign in to Kivora using {name}.'**
  String acctDisconnectBody(String name);

  /// No description provided for @acctCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get acctCancel;

  /// No description provided for @acctGoogleConnected.
  ///
  /// In en, this message translates to:
  /// **'Google account connected.'**
  String get acctGoogleConnected;

  /// No description provided for @acctChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get acctChangePassword;

  /// No description provided for @acctCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'CURRENT PASSWORD'**
  String get acctCurrentPassword;

  /// No description provided for @acctNewPassword.
  ///
  /// In en, this message translates to:
  /// **'NEW PASSWORD'**
  String get acctNewPassword;

  /// No description provided for @acctConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM NEW PASSWORD'**
  String get acctConfirmPassword;

  /// No description provided for @acctUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get acctUpdatePassword;

  /// No description provided for @acctPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully!'**
  String get acctPasswordUpdated;

  /// No description provided for @navPlatformOverview.
  ///
  /// In en, this message translates to:
  /// **'Platform overview'**
  String get navPlatformOverview;

  /// No description provided for @navPlatformOrganizations.
  ///
  /// In en, this message translates to:
  /// **'All organizations'**
  String get navPlatformOrganizations;

  /// No description provided for @navPlatformReports.
  ///
  /// In en, this message translates to:
  /// **'User reports'**
  String get navPlatformReports;

  /// No description provided for @navPlatformAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get navPlatformAudit;

  /// No description provided for @resNotClosedYet.
  ///
  /// In en, this message translates to:
  /// **'Results can be calculated once the election has closed.'**
  String get resNotClosedYet;

  /// No description provided for @orgSetSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your branding changes?'**
  String get orgSetSaveTitle;

  /// No description provided for @orgSetUnsavedBody.
  ///
  /// In en, this message translates to:
  /// **'You changed this organization\'s branding but have not saved it. Discarded changes cannot be recovered.'**
  String get orgSetUnsavedBody;

  /// No description provided for @orgSetKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get orgSetKeepEditing;

  /// No description provided for @orgSetDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get orgSetDiscard;

  /// No description provided for @orgSetSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get orgSetSave;

  /// No description provided for @orgSetLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading organization…'**
  String get orgSetLoading;

  /// No description provided for @orgSetLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the organization. Check your connection and try again.'**
  String get orgSetLoadError;

  /// No description provided for @orgSetNoOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'No active organization'**
  String get orgSetNoOrgTitle;

  /// No description provided for @orgSetNoOrgBody.
  ///
  /// In en, this message translates to:
  /// **'Select an organization before changing its branding.'**
  String get orgSetNoOrgBody;

  /// No description provided for @orgSetDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get orgSetDeniedTitle;

  /// No description provided for @orgSetDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Only the organization Owner can update its branding.'**
  String get orgSetDeniedBody;

  /// No description provided for @orgSetBackOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get orgSetBackOverview;

  /// No description provided for @orgSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Organization branding'**
  String get orgSetTitle;

  /// No description provided for @orgSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shape how {a} appears to members and voters.'**
  String orgSetSubtitle(String a);

  /// No description provided for @orgSetDetails.
  ///
  /// In en, this message translates to:
  /// **'Organization details'**
  String get orgSetDetails;

  /// No description provided for @orgSetDetailsBody.
  ///
  /// In en, this message translates to:
  /// **'Your public name and a short introduction to your organization.'**
  String get orgSetDetailsBody;

  /// No description provided for @orgSetNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Organization name *'**
  String get orgSetNameLabel;

  /// No description provided for @orgSetNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Acme Corporation'**
  String get orgSetNameHint;

  /// No description provided for @orgSetNameShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 3 characters.'**
  String get orgSetNameShort;

  /// No description provided for @orgSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get orgSetDescription;

  /// No description provided for @orgSetDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of your organization or department...'**
  String get orgSetDescriptionHint;

  /// No description provided for @orgSetDescriptionHelp.
  ///
  /// In en, this message translates to:
  /// **'A short introduction shown on your organization profile.'**
  String get orgSetDescriptionHelp;

  /// No description provided for @orgSetWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website (optional)'**
  String get orgSetWebsite;

  /// No description provided for @orgSetWebsiteInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid HTTPS URL.'**
  String get orgSetWebsiteInvalid;

  /// No description provided for @orgSetLogo.
  ///
  /// In en, this message translates to:
  /// **'Organization logo'**
  String get orgSetLogo;

  /// No description provided for @orgSetLogoActive.
  ///
  /// In en, this message translates to:
  /// **'Logo active'**
  String get orgSetLogoActive;

  /// No description provided for @orgSetLogoNone.
  ///
  /// In en, this message translates to:
  /// **'No logo uploaded'**
  String get orgSetLogoNone;

  /// No description provided for @orgSetLogoChange.
  ///
  /// In en, this message translates to:
  /// **'Choose a different logo'**
  String get orgSetLogoChange;

  /// No description provided for @orgSetLogoChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose logo'**
  String get orgSetLogoChoose;

  /// No description provided for @orgSetRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get orgSetRemove;

  /// No description provided for @orgSetLogoHelp.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPEG or WebP · Up to 2 MB\nUse a square image for the best result.'**
  String get orgSetLogoHelp;

  /// No description provided for @orgSetPreviewName.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get orgSetPreviewName;

  /// No description provided for @orgSetPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Description will appear here...'**
  String get orgSetPreviewDescription;

  /// No description provided for @orgSetPreviewNoWebsite.
  ///
  /// In en, this message translates to:
  /// **'No website added'**
  String get orgSetPreviewNoWebsite;

  /// No description provided for @orgSetPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Member profile preview'**
  String get orgSetPreviewTitle;

  /// No description provided for @orgSetPreviewBody.
  ///
  /// In en, this message translates to:
  /// **'How your organization will appear to members.'**
  String get orgSetPreviewBody;

  /// No description provided for @orgSetPreviewRole.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get orgSetPreviewRole;

  /// No description provided for @orgSetPreviewViewEvents.
  ///
  /// In en, this message translates to:
  /// **'View events'**
  String get orgSetPreviewViewEvents;

  /// No description provided for @orgSetPreviewNote.
  ///
  /// In en, this message translates to:
  /// **'Preview only. Changes appear to members and voters after you save.'**
  String get orgSetPreviewNote;

  /// No description provided for @orgSetNotPermTitle.
  ///
  /// In en, this message translates to:
  /// **'Branding, not permissions'**
  String get orgSetNotPermTitle;

  /// No description provided for @orgSetNotPermBody.
  ///
  /// In en, this message translates to:
  /// **'Access control and verification are managed separately. Updating your branding won\'t change either.'**
  String get orgSetNotPermBody;

  /// No description provided for @orgSetDirtyTitle.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes'**
  String get orgSetDirtyTitle;

  /// No description provided for @orgSetDirtyLogo.
  ///
  /// In en, this message translates to:
  /// **'A new logo is selected but not uploaded yet. Save to upload and publish it.'**
  String get orgSetDirtyLogo;

  /// No description provided for @orgSetDirtyBody.
  ///
  /// In en, this message translates to:
  /// **'Save to publish your branding, or reset to discard your changes.'**
  String get orgSetDirtyBody;

  /// No description provided for @orgSetReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get orgSetReset;

  /// No description provided for @orgSetSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get orgSetSaving;

  /// No description provided for @orgSetSaveBranding.
  ///
  /// In en, this message translates to:
  /// **'Save branding'**
  String get orgSetSaveBranding;

  /// No description provided for @orgSetLogoTooBig.
  ///
  /// In en, this message translates to:
  /// **'The logo is larger than 2 MB. Choose a smaller image.'**
  String get orgSetLogoTooBig;

  /// No description provided for @orgSetSaved.
  ///
  /// In en, this message translates to:
  /// **'Organization branding saved.'**
  String get orgSetSaved;

  /// No description provided for @orgSetSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save branding. Check your connection and try again.'**
  String get orgSetSaveFailed;

  /// No description provided for @orgSetDanger.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get orgSetDanger;

  /// No description provided for @orgSetDangerBody.
  ///
  /// In en, this message translates to:
  /// **'Deleting this organization will archive its workspace. Active elections will stop accepting ballots.'**
  String get orgSetDangerBody;

  /// No description provided for @orgSetDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete organization'**
  String get orgSetDelete;

  /// No description provided for @orgSetDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Organization?'**
  String get orgSetDeleteTitle;

  /// No description provided for @orgSetDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{a}\"?\n\nThis will archive the organization workspace. This action cannot be undone.'**
  String orgSetDeleteBody(String a);

  /// No description provided for @orgSetKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep organization'**
  String get orgSetKeep;

  /// No description provided for @orgSetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Organization has been deleted.'**
  String get orgSetDeleted;

  /// No description provided for @jcMaxUsesInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a maximum use count from 0 to 100,000.'**
  String get jcMaxUsesInvalid;

  /// No description provided for @jcSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save this joining code'**
  String get jcSaveTitle;

  /// No description provided for @jcShownOnce.
  ///
  /// In en, this message translates to:
  /// **'This code is shown once. Share it only with people you want to join this organization.'**
  String get jcShownOnce;

  /// No description provided for @jcScanHint.
  ///
  /// In en, this message translates to:
  /// **'Or scan this with Kivora\'s \"Scan to Join\" on another device.'**
  String get jcScanHint;

  /// No description provided for @jcCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get jcCopied;

  /// No description provided for @jcCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get jcCopy;

  /// No description provided for @jcDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get jcDone;

  /// No description provided for @jcRevokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke this code?'**
  String get jcRevokeTitle;

  /// No description provided for @jcCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get jcCancel;

  /// No description provided for @jcRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke code'**
  String get jcRevoke;

  /// No description provided for @jcRevokeNoId.
  ///
  /// In en, this message translates to:
  /// **'This code cannot be revoked (missing identifier).'**
  String get jcRevokeNoId;

  /// No description provided for @jcRevoked.
  ///
  /// In en, this message translates to:
  /// **'Joining code revoked.'**
  String get jcRevoked;

  /// No description provided for @jcTitle.
  ///
  /// In en, this message translates to:
  /// **'Joining codes'**
  String get jcTitle;

  /// No description provided for @jcRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh joining codes'**
  String get jcRefresh;

  /// No description provided for @jcLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading organization…'**
  String get jcLoading;

  /// No description provided for @jcOrgLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load this organization. Check your connection and try again.'**
  String get jcOrgLoadError;

  /// No description provided for @jcNoOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'Select an organization'**
  String get jcNoOrgTitle;

  /// No description provided for @jcNoOrgBody.
  ///
  /// In en, this message translates to:
  /// **'Choose an organization before managing joining codes.'**
  String get jcNoOrgBody;

  /// No description provided for @jcAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Administrator access required'**
  String get jcAdminTitle;

  /// No description provided for @jcAdminBody.
  ///
  /// In en, this message translates to:
  /// **'Only this organization’s Owner and Admins can manage joining codes.'**
  String get jcAdminBody;

  /// No description provided for @jcSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and revoke codes that let people join this organization. A valid code adds the person as a member straight away; it never grants admin or owner access.'**
  String get jcSubtitle;

  /// No description provided for @jcStatActive.
  ///
  /// In en, this message translates to:
  /// **'Active codes'**
  String get jcStatActive;

  /// No description provided for @jcStatExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired or used up'**
  String get jcStatExpired;

  /// No description provided for @jcStatRevoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get jcStatRevoked;

  /// No description provided for @jcExisting.
  ///
  /// In en, this message translates to:
  /// **'Existing codes'**
  String get jcExisting;

  /// No description provided for @jcLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load joining codes. Check your connection and try again.'**
  String get jcLoadError;

  /// No description provided for @jcEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no joining codes for this organization.'**
  String get jcEmpty;

  /// No description provided for @jcCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a joining code'**
  String get jcCreateTitle;

  /// No description provided for @jcCreateNote.
  ///
  /// In en, this message translates to:
  /// **'A code is shown once. It is stored as a secure hash and cannot be retrieved later.'**
  String get jcCreateNote;

  /// No description provided for @jcCreating.
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get jcCreating;

  /// No description provided for @jcCreate.
  ///
  /// In en, this message translates to:
  /// **'Create code'**
  String get jcCreate;

  /// No description provided for @jcExpiresAfter.
  ///
  /// In en, this message translates to:
  /// **'Expires after'**
  String get jcExpiresAfter;

  /// No description provided for @jcExp24h.
  ///
  /// In en, this message translates to:
  /// **'24 hours'**
  String get jcExp24h;

  /// No description provided for @jcExp3d.
  ///
  /// In en, this message translates to:
  /// **'3 days'**
  String get jcExp3d;

  /// No description provided for @jcExp7d.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get jcExp7d;

  /// No description provided for @jcExp30d.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get jcExp30d;

  /// No description provided for @jcExp1y.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get jcExp1y;

  /// No description provided for @jcMaxUses.
  ///
  /// In en, this message translates to:
  /// **'Maximum uses'**
  String get jcMaxUses;

  /// No description provided for @jcMaxUsesHint.
  ///
  /// In en, this message translates to:
  /// **'Use 0 for unlimited.'**
  String get jcMaxUsesHint;

  /// No description provided for @jcExpiryUnknown.
  ///
  /// In en, this message translates to:
  /// **'Expiry unavailable'**
  String get jcExpiryUnknown;

  /// No description provided for @jcExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires {a}'**
  String jcExpires(String a);

  /// No description provided for @jcUses.
  ///
  /// In en, this message translates to:
  /// **'{a} uses'**
  String jcUses(String a);

  /// No description provided for @jcUsesOf.
  ///
  /// In en, this message translates to:
  /// **'{a} of {b} uses'**
  String jcUsesOf(String a, String b);

  /// No description provided for @dmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Department'**
  String get dmDeleteTitle;

  /// No description provided for @dmDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{a}\"?\n\nThis permanently deletes the department.'**
  String dmDeleteBody(String a);

  /// No description provided for @dmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dmCancel;

  /// No description provided for @dmDeleted.
  ///
  /// In en, this message translates to:
  /// **'Department deleted successfully.'**
  String get dmDeleted;

  /// No description provided for @dmDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {a}'**
  String dmDeleteFailed(String a);

  /// No description provided for @dmDeletePermanent.
  ///
  /// In en, this message translates to:
  /// **'Delete Permanently'**
  String get dmDeletePermanent;

  /// No description provided for @dmAssigned.
  ///
  /// In en, this message translates to:
  /// **'Successfully assigned {a} member(s) to {b}.'**
  String dmAssigned(String a, String b);

  /// No description provided for @dmAssignFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to assign members: {a}'**
  String dmAssignFailed(String a);

  /// No description provided for @dmRemoveFrom.
  ///
  /// In en, this message translates to:
  /// **'Remove from department'**
  String get dmRemoveFrom;

  /// No description provided for @dmRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{a}\" from this department?'**
  String dmRemoveBody(String a);

  /// No description provided for @dmRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get dmRemove;

  /// No description provided for @dmRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed {a} from department.'**
  String dmRemoved(String a);

  /// No description provided for @dmRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove member: {a}'**
  String dmRemoveFailed(String a);

  /// No description provided for @dmNoOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'No Active Organization'**
  String get dmNoOrgTitle;

  /// No description provided for @dmNoOrgBody.
  ///
  /// In en, this message translates to:
  /// **'Please select an organization context to view department members.'**
  String get dmNoOrgBody;

  /// No description provided for @dmLoadingDept.
  ///
  /// In en, this message translates to:
  /// **'Loading department details...'**
  String get dmLoadingDept;

  /// No description provided for @dmLoadingRoster.
  ///
  /// In en, this message translates to:
  /// **'Loading department roster...'**
  String get dmLoadingRoster;

  /// No description provided for @dmRosterError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the roster. Check your connection and try again.'**
  String get dmRosterError;

  /// No description provided for @dmBack.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get dmBack;

  /// No description provided for @dmAssignedCount.
  ///
  /// In en, this message translates to:
  /// **'{a} assigned members'**
  String dmAssignedCount(String a);

  /// No description provided for @dmEligibleNote.
  ///
  /// In en, this message translates to:
  /// **'Members in this department can be chosen as eligible voters for elections.'**
  String get dmEligibleNote;

  /// No description provided for @dmEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get dmEdit;

  /// No description provided for @dmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dmDelete;

  /// No description provided for @dmMembersIn.
  ///
  /// In en, this message translates to:
  /// **'Members in {a}'**
  String dmMembersIn(String a);

  /// No description provided for @dmNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No members assigned yet'**
  String get dmNoMembers;

  /// No description provided for @dmNoMembersBody.
  ///
  /// In en, this message translates to:
  /// **'Choose people from the list to add them to this department. You can change it at any time.'**
  String get dmNoMembersBody;

  /// No description provided for @dmAssignedHere.
  ///
  /// In en, this message translates to:
  /// **'Assigned members will appear here.'**
  String get dmAssignedHere;

  /// No description provided for @dmPendingNote.
  ///
  /// In en, this message translates to:
  /// **'Pending selections are not members yet. Confirm with \"Assign {a} members\" to add them to {b}.'**
  String dmPendingNote(String a, String b);

  /// No description provided for @dmAddMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get dmAddMembers;

  /// No description provided for @dmSelectPeople.
  ///
  /// In en, this message translates to:
  /// **'Select people to assign to {a}.'**
  String dmSelectPeople(String a);

  /// No description provided for @dmSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get dmSearch;

  /// No description provided for @dmAllMembers.
  ///
  /// In en, this message translates to:
  /// **'All members'**
  String get dmAllMembers;

  /// No description provided for @dmNoDept.
  ///
  /// In en, this message translates to:
  /// **'No department'**
  String get dmNoDept;

  /// No description provided for @dmNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No members match your search.'**
  String get dmNoMatch;

  /// No description provided for @dmIn.
  ///
  /// In en, this message translates to:
  /// **'In {a}'**
  String dmIn(String a);

  /// No description provided for @dmInFirst.
  ///
  /// In en, this message translates to:
  /// **'In {a}'**
  String dmInFirst(String a);

  /// No description provided for @dmAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to {a}'**
  String dmAssignedTo(String a);

  /// No description provided for @dmClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get dmClear;

  /// No description provided for @dmPendingTo.
  ///
  /// In en, this message translates to:
  /// **'Pending assignment to {a}'**
  String dmPendingTo(String a);

  /// No description provided for @dmAssigning.
  ///
  /// In en, this message translates to:
  /// **'Assigning...'**
  String get dmAssigning;

  /// No description provided for @dmAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign {a} members'**
  String dmAssign(String a);

  /// No description provided for @jcRevokeBody.
  ///
  /// In en, this message translates to:
  /// **'Anyone who has this code will no longer be able to use it. ({a})'**
  String jcRevokeBody(String a);

  /// No description provided for @jcCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code • {a}'**
  String jcCodeLabel(String a);

  /// No description provided for @statusExhausted.
  ///
  /// In en, this message translates to:
  /// **'EXHAUSTED'**
  String get statusExhausted;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'EXPIRED'**
  String get statusExpired;

  /// No description provided for @statusRevoked.
  ///
  /// In en, this message translates to:
  /// **'REVOKED'**
  String get statusRevoked;

  /// No description provided for @dmMemberFallback.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get dmMemberFallback;

  /// No description provided for @dmSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{a} selected'**
  String dmSelectedCount(String a);
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
