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

  /// No description provided for @auditActAcceptInvitation.
  ///
  /// In en, this message translates to:
  /// **'Invitation accepted'**
  String get auditActAcceptInvitation;

  /// No description provided for @auditActActivateVotingEvent.
  ///
  /// In en, this message translates to:
  /// **'Election activated'**
  String get auditActActivateVotingEvent;

  /// No description provided for @auditActAddMember.
  ///
  /// In en, this message translates to:
  /// **'Member added'**
  String get auditActAddMember;

  /// No description provided for @auditActAssignDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department assigned'**
  String get auditActAssignDepartment;

  /// No description provided for @auditActCalculateResults.
  ///
  /// In en, this message translates to:
  /// **'Results calculated'**
  String get auditActCalculateResults;

  /// No description provided for @auditActCancelVotingEvent.
  ///
  /// In en, this message translates to:
  /// **'Election cancelled'**
  String get auditActCancelVotingEvent;

  /// No description provided for @auditActCloseVotingEvent.
  ///
  /// In en, this message translates to:
  /// **'Election closed'**
  String get auditActCloseVotingEvent;

  /// No description provided for @auditActCreateCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate added'**
  String get auditActCreateCandidate;

  /// No description provided for @auditActCreateDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department created'**
  String get auditActCreateDepartment;

  /// No description provided for @auditActCreateJoiningCode.
  ///
  /// In en, this message translates to:
  /// **'Joining code created'**
  String get auditActCreateJoiningCode;

  /// No description provided for @auditActCreateOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization created'**
  String get auditActCreateOrganization;

  /// No description provided for @auditActCreatePollOption.
  ///
  /// In en, this message translates to:
  /// **'Poll option added'**
  String get auditActCreatePollOption;

  /// No description provided for @auditActCreateVotingEvent.
  ///
  /// In en, this message translates to:
  /// **'Election created'**
  String get auditActCreateVotingEvent;

  /// No description provided for @auditActDeclineInvitation.
  ///
  /// In en, this message translates to:
  /// **'Invitation declined'**
  String get auditActDeclineInvitation;

  /// No description provided for @auditActDeleteCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate removed'**
  String get auditActDeleteCandidate;

  /// No description provided for @auditActDeleteCandidatePhoto.
  ///
  /// In en, this message translates to:
  /// **'Candidate photo removed'**
  String get auditActDeleteCandidatePhoto;

  /// No description provided for @auditActDeleteDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department deleted'**
  String get auditActDeleteDepartment;

  /// No description provided for @auditActDeleteOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization deleted'**
  String get auditActDeleteOrganization;

  /// No description provided for @auditActDeletePollOption.
  ///
  /// In en, this message translates to:
  /// **'Poll option removed'**
  String get auditActDeletePollOption;

  /// No description provided for @auditActDeleteVotingEvent.
  ///
  /// In en, this message translates to:
  /// **'Election deleted'**
  String get auditActDeleteVotingEvent;

  /// No description provided for @auditActFinalizeCandidatePhoto.
  ///
  /// In en, this message translates to:
  /// **'Candidate photo saved'**
  String get auditActFinalizeCandidatePhoto;

  /// No description provided for @auditActGrantObserverStatus.
  ///
  /// In en, this message translates to:
  /// **'Observer access granted'**
  String get auditActGrantObserverStatus;

  /// No description provided for @auditActInviteMember.
  ///
  /// In en, this message translates to:
  /// **'Member invited'**
  String get auditActInviteMember;

  /// No description provided for @auditActJoinOrganizationWithCode.
  ///
  /// In en, this message translates to:
  /// **'Joined with a code'**
  String get auditActJoinOrganizationWithCode;

  /// No description provided for @auditActLeaveOrganization.
  ///
  /// In en, this message translates to:
  /// **'Left the organization'**
  String get auditActLeaveOrganization;

  /// No description provided for @auditActPlanChanged.
  ///
  /// In en, this message translates to:
  /// **'Plan changed'**
  String get auditActPlanChanged;

  /// No description provided for @auditActPlatformAdminAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'Platform admin access granted'**
  String get auditActPlatformAdminAccessGranted;

  /// No description provided for @auditActPlatformAdminAccessRemoved.
  ///
  /// In en, this message translates to:
  /// **'Platform admin access removed'**
  String get auditActPlatformAdminAccessRemoved;

  /// No description provided for @auditActPublishResults.
  ///
  /// In en, this message translates to:
  /// **'Results published'**
  String get auditActPublishResults;

  /// No description provided for @auditActPublishVotingEvent.
  ///
  /// In en, this message translates to:
  /// **'Election published'**
  String get auditActPublishVotingEvent;

  /// No description provided for @auditActRemindNonVoters.
  ///
  /// In en, this message translates to:
  /// **'Reminder sent to non-voters'**
  String get auditActRemindNonVoters;

  /// No description provided for @auditActRemoveDepartment.
  ///
  /// In en, this message translates to:
  /// **'Member removed from department'**
  String get auditActRemoveDepartment;

  /// No description provided for @auditActRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Member removed'**
  String get auditActRemoveMember;

  /// No description provided for @auditActRevokeInvitation.
  ///
  /// In en, this message translates to:
  /// **'Invitation revoked'**
  String get auditActRevokeInvitation;

  /// No description provided for @auditActRevokeJoiningCode.
  ///
  /// In en, this message translates to:
  /// **'Joining code revoked'**
  String get auditActRevokeJoiningCode;

  /// No description provided for @auditActRevokeObserverStatus.
  ///
  /// In en, this message translates to:
  /// **'Observer access removed'**
  String get auditActRevokeObserverStatus;

  /// No description provided for @auditActUpdateCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate updated'**
  String get auditActUpdateCandidate;

  /// No description provided for @auditActUpdateDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department updated'**
  String get auditActUpdateDepartment;

  /// No description provided for @auditActUpdateMemberRole.
  ///
  /// In en, this message translates to:
  /// **'Member role changed'**
  String get auditActUpdateMemberRole;

  /// No description provided for @auditActUpdateMemberStatus.
  ///
  /// In en, this message translates to:
  /// **'Member status changed'**
  String get auditActUpdateMemberStatus;

  /// No description provided for @auditActUpdateOrganizationMetadata.
  ///
  /// In en, this message translates to:
  /// **'Organization details updated'**
  String get auditActUpdateOrganizationMetadata;

  /// No description provided for @auditActUpdatePollOption.
  ///
  /// In en, this message translates to:
  /// **'Poll option updated'**
  String get auditActUpdatePollOption;

  /// No description provided for @auditActUpdateVotingEvent.
  ///
  /// In en, this message translates to:
  /// **'Election updated'**
  String get auditActUpdateVotingEvent;

  /// No description provided for @auditActOrganizationVerify.
  ///
  /// In en, this message translates to:
  /// **'Organization verified'**
  String get auditActOrganizationVerify;

  /// No description provided for @auditActOrganizationReject.
  ///
  /// In en, this message translates to:
  /// **'Organization rejected'**
  String get auditActOrganizationReject;

  /// No description provided for @auditActOrganizationSuspend.
  ///
  /// In en, this message translates to:
  /// **'Organization suspended'**
  String get auditActOrganizationSuspend;

  /// No description provided for @auditActOrganizationReactivate.
  ///
  /// In en, this message translates to:
  /// **'Organization reactivated'**
  String get auditActOrganizationReactivate;

  /// No description provided for @auditActUnknown.
  ///
  /// In en, this message translates to:
  /// **'Admin action'**
  String get auditActUnknown;

  /// No description provided for @auditSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get auditSystem;

  /// No description provided for @auLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading organization activity…'**
  String get auLoading;

  /// No description provided for @auOrgLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the organization. Check your connection and try again.'**
  String get auOrgLoadError;

  /// No description provided for @auNoOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'Select an organization'**
  String get auNoOrgTitle;

  /// No description provided for @auNoOrgBody.
  ///
  /// In en, this message translates to:
  /// **'Choose an organization to view its activity.'**
  String get auNoOrgBody;

  /// No description provided for @auDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get auDeniedTitle;

  /// No description provided for @auDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Only this organization’s Owner and Admins can view its audit history.'**
  String get auDeniedBody;

  /// No description provided for @auCrumbOrg.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get auCrumbOrg;

  /// No description provided for @auCrumbActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get auCrumbActivity;

  /// No description provided for @auTitle.
  ///
  /// In en, this message translates to:
  /// **'Organization activity'**
  String get auTitle;

  /// No description provided for @auSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review membership and invitation changes across your organization.'**
  String get auSubtitle;

  /// No description provided for @auLoadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Loading audit history…'**
  String get auLoadingHistory;

  /// No description provided for @auLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load organization activity. Check your connection and try again.'**
  String get auLoadError;

  /// No description provided for @auSearchLong.
  ///
  /// In en, this message translates to:
  /// **'Search by activity, account ID or record type'**
  String get auSearchLong;

  /// No description provided for @auSearchShort.
  ///
  /// In en, this message translates to:
  /// **'Search activity...'**
  String get auSearchShort;

  /// No description provided for @auReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get auReset;

  /// No description provided for @auAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All record types'**
  String get auAllTypes;

  /// No description provided for @auFilterType.
  ///
  /// In en, this message translates to:
  /// **'Filter by record type'**
  String get auFilterType;

  /// No description provided for @auAllAccounts.
  ///
  /// In en, this message translates to:
  /// **'All accounts'**
  String get auAllAccounts;

  /// No description provided for @auAccount.
  ///
  /// In en, this message translates to:
  /// **'Account {a}'**
  String auAccount(String a);

  /// No description provided for @auFilterAccount.
  ///
  /// In en, this message translates to:
  /// **'Filter by account'**
  String get auFilterAccount;

  /// No description provided for @auDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get auDateRange;

  /// No description provided for @auFilterDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date range'**
  String get auFilterDate;

  /// No description provided for @auAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get auAllTime;

  /// No description provided for @auToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get auToday;

  /// No description provided for @auLast7.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get auLast7;

  /// No description provided for @auLast30.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get auLast30;

  /// No description provided for @auCustomRange.
  ///
  /// In en, this message translates to:
  /// **'Custom date range...'**
  String get auCustomRange;

  /// No description provided for @auDateUnknown.
  ///
  /// In en, this message translates to:
  /// **'Date unavailable'**
  String get auDateUnknown;

  /// No description provided for @auAllRecords.
  ///
  /// In en, this message translates to:
  /// **'All records'**
  String get auAllRecords;

  /// No description provided for @auMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get auMembers;

  /// No description provided for @auInvitations.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get auInvitations;

  /// No description provided for @auNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get auNewest;

  /// No description provided for @auOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get auOldest;

  /// No description provided for @auColActivity.
  ///
  /// In en, this message translates to:
  /// **'ACTIVITY'**
  String get auColActivity;

  /// No description provided for @auColType.
  ///
  /// In en, this message translates to:
  /// **'RECORD TYPE'**
  String get auColType;

  /// No description provided for @auColAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT ID'**
  String get auColAccount;

  /// No description provided for @auColTime.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get auColTime;

  /// No description provided for @auNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No activity records match your criteria.'**
  String get auNoMatch;

  /// No description provided for @auRecordOne.
  ///
  /// In en, this message translates to:
  /// **'1 record'**
  String get auRecordOne;

  /// No description provided for @auRecordMany.
  ///
  /// In en, this message translates to:
  /// **'{a} records'**
  String auRecordMany(String a);

  /// No description provided for @auShown.
  ///
  /// In en, this message translates to:
  /// **'{a} records shown · Repeated records retained'**
  String auShown(String a);

  /// No description provided for @auTimesNote.
  ///
  /// In en, this message translates to:
  /// **'Dates and times as recorded'**
  String get auTimesNote;

  /// No description provided for @auUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get auUnavailable;

  /// No description provided for @auTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Time unavailable'**
  String get auTimeUnknown;

  /// No description provided for @auViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details '**
  String get auViewDetails;

  /// No description provided for @auActorBullet.
  ///
  /// In en, this message translates to:
  /// **'• {a}'**
  String auActorBullet(String a);

  /// No description provided for @auRecordedAt.
  ///
  /// In en, this message translates to:
  /// **'Recorded at'**
  String get auRecordedAt;

  /// No description provided for @auRecordType.
  ///
  /// In en, this message translates to:
  /// **'Record type'**
  String get auRecordType;

  /// No description provided for @auAccountId.
  ///
  /// In en, this message translates to:
  /// **'Account ID'**
  String get auAccountId;

  /// No description provided for @auNoActorDetail.
  ///
  /// In en, this message translates to:
  /// **'Actor identity and change details are not provided in this record.'**
  String get auNoActorDetail;

  /// No description provided for @evGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get evGenericTitle;

  /// No description provided for @evGenericStatus.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get evGenericStatus;

  /// No description provided for @evOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'No active organization'**
  String get evOrgTitle;

  /// No description provided for @evOrgStatus.
  ///
  /// In en, this message translates to:
  /// **'Organization required'**
  String get evOrgStatus;

  /// No description provided for @evConnTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get evConnTitle;

  /// No description provided for @evConnStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection interrupted'**
  String get evConnStatus;

  /// No description provided for @evDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get evDeniedTitle;

  /// No description provided for @evDeniedStatus.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get evDeniedStatus;

  /// No description provided for @evSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get evSessionTitle;

  /// No description provided for @evSessionStatus.
  ///
  /// In en, this message translates to:
  /// **'Sign-in required'**
  String get evSessionStatus;

  /// No description provided for @evSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to save changes'**
  String get evSaveTitle;

  /// No description provided for @evSaveStatus.
  ///
  /// In en, this message translates to:
  /// **'Save unsuccessful'**
  String get evSaveStatus;

  /// No description provided for @evServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get evServiceTitle;

  /// No description provided for @evServiceStatus.
  ///
  /// In en, this message translates to:
  /// **'Service interruption'**
  String get evServiceStatus;

  /// No description provided for @evSelectOrg.
  ///
  /// In en, this message translates to:
  /// **'Select organization'**
  String get evSelectOrg;

  /// No description provided for @evRequestAccess.
  ///
  /// In en, this message translates to:
  /// **'Request access'**
  String get evRequestAccess;

  /// No description provided for @evSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get evSignIn;

  /// No description provided for @evTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get evTryAgain;

  /// No description provided for @errRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get errRetry;

  /// No description provided for @osPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get osPending;

  /// No description provided for @osVerified.
  ///
  /// In en, this message translates to:
  /// **'verified'**
  String get osVerified;

  /// No description provided for @osActive.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get osActive;

  /// No description provided for @osSuspended.
  ///
  /// In en, this message translates to:
  /// **'suspended'**
  String get osSuspended;

  /// No description provided for @osRejected.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get osRejected;

  /// No description provided for @osArchived.
  ///
  /// In en, this message translates to:
  /// **'archived'**
  String get osArchived;

  /// No description provided for @porVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get porVerify;

  /// No description provided for @porReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get porReject;

  /// No description provided for @porSuspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get porSuspend;

  /// No description provided for @porReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get porReactivate;

  /// No description provided for @porReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'{a} organization?'**
  String porReviewTitle(String a);

  /// No description provided for @porThisOrg.
  ///
  /// In en, this message translates to:
  /// **'This organization'**
  String get porThisOrg;

  /// No description provided for @porReviewBody.
  ///
  /// In en, this message translates to:
  /// **'{a} will be marked as {b}.'**
  String porReviewBody(String a, String b);

  /// No description provided for @porMarked.
  ///
  /// In en, this message translates to:
  /// **'Organization marked as {a}.'**
  String porMarked(String a);

  /// No description provided for @porUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update organization.'**
  String get porUpdateFailed;

  /// No description provided for @porLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load organizations.'**
  String get porLoadFailed;

  /// No description provided for @porTitle.
  ///
  /// In en, this message translates to:
  /// **'All organizations'**
  String get porTitle;

  /// No description provided for @porCheckingAccess.
  ///
  /// In en, this message translates to:
  /// **'Checking platform access…'**
  String get porCheckingAccess;

  /// No description provided for @porDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get porDeniedTitle;

  /// No description provided for @porVerifyAccessFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify platform administrator access.'**
  String get porVerifyAccessFailed;

  /// No description provided for @porSuperAdminsOnly.
  ///
  /// In en, this message translates to:
  /// **'This area is available only to Platform Super Admins.'**
  String get porSuperAdminsOnly;

  /// No description provided for @porLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading organizations…'**
  String get porLoading;

  /// No description provided for @porEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No organizations yet'**
  String get porEmptyTitle;

  /// No description provided for @porEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'No organizations have been registered on the platform yet.'**
  String get porEmptyBody;

  /// No description provided for @porSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email or city'**
  String get porSearch;

  /// No description provided for @porClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get porClearSearch;

  /// No description provided for @porShowing100.
  ///
  /// In en, this message translates to:
  /// **'Showing the 100 most recent organizations.'**
  String get porShowing100;

  /// No description provided for @porNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No organization matches \"{a}\" in this view.'**
  String porNoMatch(String a);

  /// No description provided for @porNothingIn.
  ///
  /// In en, this message translates to:
  /// **'Nothing in \"{a}\".'**
  String porNothingIn(String a);

  /// No description provided for @porRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered {a}'**
  String porRegistered(String a);

  /// No description provided for @porArchivedNote.
  ///
  /// In en, this message translates to:
  /// **'Deleted by its owner. No moderation actions are available.'**
  String get porArchivedNote;

  /// No description provided for @porRejectedNote.
  ///
  /// In en, this message translates to:
  /// **'Rejected. No further actions are available.'**
  String get porRejectedNote;

  /// No description provided for @porCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get porCancel;

  /// No description provided for @pfNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get pfNeedsReview;

  /// No description provided for @pfVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get pfVerified;

  /// No description provided for @pfSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get pfSuspended;

  /// No description provided for @pfClosed.
  ///
  /// In en, this message translates to:
  /// **'Archived / rejected'**
  String get pfClosed;

  /// No description provided for @pfAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get pfAll;

  /// No description provided for @paLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load platform data.'**
  String get paLoadFailed;

  /// No description provided for @paLoadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load more users.'**
  String get paLoadMoreFailed;

  /// No description provided for @paGrantTitle.
  ///
  /// In en, this message translates to:
  /// **'Grant platform admin access'**
  String get paGrantTitle;

  /// No description provided for @paEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Account email address'**
  String get paEmailLabel;

  /// No description provided for @paEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get paEmailHint;

  /// No description provided for @paCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get paCancel;

  /// No description provided for @paGrant.
  ///
  /// In en, this message translates to:
  /// **'Grant access'**
  String get paGrant;

  /// No description provided for @paGranted.
  ///
  /// In en, this message translates to:
  /// **'Platform admin access granted to {a}.'**
  String paGranted(String a);

  /// No description provided for @paGrantFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not grant admin access.'**
  String get paGrantFailed;

  /// No description provided for @paThisAccount.
  ///
  /// In en, this message translates to:
  /// **'this account'**
  String get paThisAccount;

  /// No description provided for @paRevokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke platform admin access?'**
  String get paRevokeTitle;

  /// No description provided for @paRevokeBody.
  ///
  /// In en, this message translates to:
  /// **'{a} will lose Platform Super Admin privileges.'**
  String paRevokeBody(String a);

  /// No description provided for @paRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get paRevoke;

  /// No description provided for @paRevoked.
  ///
  /// In en, this message translates to:
  /// **'Admin access revoked.'**
  String get paRevoked;

  /// No description provided for @paRevokeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not revoke admin access.'**
  String get paRevokeFailed;

  /// No description provided for @paTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts & access'**
  String get paTitle;

  /// No description provided for @paChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking platform access…'**
  String get paChecking;

  /// No description provided for @paDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get paDenied;

  /// No description provided for @paVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify platform administrator access.'**
  String get paVerifyFailed;

  /// No description provided for @paOnlySuper.
  ///
  /// In en, this message translates to:
  /// **'This area is available only to Platform Super Admins.'**
  String get paOnlySuper;

  /// No description provided for @paLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading platform data…'**
  String get paLoading;

  /// No description provided for @paAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get paAccounts;

  /// No description provided for @paGrantButton.
  ///
  /// In en, this message translates to:
  /// **'Grant admin access'**
  String get paGrantButton;

  /// No description provided for @paLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get paLoadMore;

  /// No description provided for @paStatUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get paStatUsers;

  /// No description provided for @paStatOrgs.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get paStatOrgs;

  /// No description provided for @paStatPending.
  ///
  /// In en, this message translates to:
  /// **'Pending orgs'**
  String get paStatPending;

  /// No description provided for @paStatActive.
  ///
  /// In en, this message translates to:
  /// **'Active orgs'**
  String get paStatActive;

  /// No description provided for @paStatSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended orgs'**
  String get paStatSuspended;

  /// No description provided for @paStatMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get paStatMembers;

  /// No description provided for @paStatActiveMembers.
  ///
  /// In en, this message translates to:
  /// **'Active members'**
  String get paStatActiveMembers;

  /// No description provided for @paStatEvents.
  ///
  /// In en, this message translates to:
  /// **'Voting events'**
  String get paStatEvents;

  /// No description provided for @paStatActiveEvents.
  ///
  /// In en, this message translates to:
  /// **'Active events'**
  String get paStatActiveEvents;

  /// No description provided for @paNoEmail.
  ///
  /// In en, this message translates to:
  /// **'(no email)'**
  String get paNoEmail;

  /// No description provided for @paTagAdmin.
  ///
  /// In en, this message translates to:
  /// **'Platform admin'**
  String get paTagAdmin;

  /// No description provided for @paTagUnverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get paTagUnverified;

  /// No description provided for @paTagDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get paTagDisabled;

  /// No description provided for @plOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform overview'**
  String get plOverviewTitle;

  /// No description provided for @plOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organizations, reviews and recent administrator activity across Kivora.'**
  String get plOverviewSubtitle;

  /// No description provided for @plRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get plRefresh;

  /// No description provided for @plPendingOne.
  ///
  /// In en, this message translates to:
  /// **'1 organization is waiting for review.'**
  String get plPendingOne;

  /// No description provided for @plPendingMany.
  ///
  /// In en, this message translates to:
  /// **'{a} organizations are waiting for review.'**
  String plPendingMany(String a);

  /// No description provided for @plReviewOrgs.
  ///
  /// In en, this message translates to:
  /// **'Review organizations'**
  String get plReviewOrgs;

  /// No description provided for @plReportsOne.
  ///
  /// In en, this message translates to:
  /// **'1 open user report.'**
  String get plReportsOne;

  /// No description provided for @plReportsMany.
  ///
  /// In en, this message translates to:
  /// **'{a} open user reports.'**
  String plReportsMany(String a);

  /// No description provided for @plOpenReports.
  ///
  /// In en, this message translates to:
  /// **'Open reports'**
  String get plOpenReports;

  /// No description provided for @plTotalsFailed.
  ///
  /// In en, this message translates to:
  /// **'Platform totals could not be loaded.'**
  String get plTotalsFailed;

  /// No description provided for @plStatOrgs.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get plStatOrgs;

  /// No description provided for @plStatWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for review'**
  String get plStatWaiting;

  /// No description provided for @plStatActive.
  ///
  /// In en, this message translates to:
  /// **'Active or verified'**
  String get plStatActive;

  /// No description provided for @plStatSuspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get plStatSuspended;

  /// No description provided for @plStatAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get plStatAccounts;

  /// No description provided for @plStatMemberships.
  ///
  /// In en, this message translates to:
  /// **'Active memberships'**
  String get plStatMemberships;

  /// No description provided for @plStatElections.
  ///
  /// In en, this message translates to:
  /// **'Elections and polls'**
  String get plStatElections;

  /// No description provided for @plStatOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Voting open now'**
  String get plStatOpenNow;

  /// No description provided for @plNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get plNeedsAttention;

  /// No description provided for @plChecksIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Some checks could not run, so this list may be incomplete.'**
  String get plChecksIncomplete;

  /// No description provided for @plNothingAttention.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs attention right now.'**
  String get plNothingAttention;

  /// No description provided for @plRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent administrator activity'**
  String get plRecentActivity;

  /// No description provided for @plViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get plViewAll;

  /// No description provided for @plUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get plUnavailable;

  /// No description provided for @plTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get plTryAgain;

  /// No description provided for @plActivityFailed.
  ///
  /// In en, this message translates to:
  /// **'The activity log could not be loaded.'**
  String get plActivityFailed;

  /// No description provided for @plNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No administrator actions have been recorded yet.'**
  String get plNoActivity;

  /// No description provided for @plTimeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Time unavailable'**
  String get plTimeUnknown;

  /// No description provided for @plTarget.
  ///
  /// In en, this message translates to:
  /// **'Target: {a}'**
  String plTarget(String a);

  /// No description provided for @plBy.
  ///
  /// In en, this message translates to:
  /// **'By {a}'**
  String plBy(String a);

  /// No description provided for @plAuditTitle.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get plAuditTitle;

  /// No description provided for @plAuditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Actions taken by platform administrators, newest first.'**
  String get plAuditSubtitle;

  /// No description provided for @plAuditLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading audit log…'**
  String get plAuditLoading;

  /// No description provided for @plAuditFailed.
  ///
  /// In en, this message translates to:
  /// **'The audit log could not be loaded.'**
  String get plAuditFailed;

  /// No description provided for @plAuditEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get plAuditEmptyTitle;

  /// No description provided for @plAuditEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Platform administrator actions will appear here once they happen.'**
  String get plAuditEmptyBody;

  /// No description provided for @plAuditNote.
  ///
  /// In en, this message translates to:
  /// **'Only actions that completed are recorded here; failed attempts leave no entry.'**
  String get plAuditNote;

  /// No description provided for @plAuditSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by action, person or organization'**
  String get plAuditSearch;

  /// No description provided for @plClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get plClearSearch;

  /// No description provided for @plAllActions.
  ///
  /// In en, this message translates to:
  /// **'All actions'**
  String get plAllActions;

  /// No description provided for @plEntryOne.
  ///
  /// In en, this message translates to:
  /// **'1 entry'**
  String get plEntryOne;

  /// No description provided for @plEntryMany.
  ///
  /// In en, this message translates to:
  /// **'{a} entries'**
  String plEntryMany(String a);

  /// No description provided for @plNoEntryMatch.
  ///
  /// In en, this message translates to:
  /// **'No entry matches the current filters.'**
  String get plNoEntryMatch;

  /// No description provided for @plLoadOlder.
  ///
  /// In en, this message translates to:
  /// **'Load older entries'**
  String get plLoadOlder;

  /// No description provided for @plReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'User reports'**
  String get plReportsTitle;

  /// No description provided for @plReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback and issues submitted from Help & support.'**
  String get plReportsSubtitle;

  /// No description provided for @plReportsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading reports…'**
  String get plReportsLoading;

  /// No description provided for @plReportsFailed.
  ///
  /// In en, this message translates to:
  /// **'The reports could not be loaded.'**
  String get plReportsFailed;

  /// No description provided for @plReportsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reports'**
  String get plReportsEmptyTitle;

  /// No description provided for @plReportsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Nobody has submitted a report yet.'**
  String get plReportsEmptyBody;

  /// No description provided for @plReportsReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Read-only for now: the platform does not yet support assigning or resolving reports, so every report stays open. There is no flagged-organization feed either.'**
  String get plReportsReadOnly;

  /// No description provided for @plAllCount.
  ///
  /// In en, this message translates to:
  /// **'All ({a})'**
  String plAllCount(String a);

  /// No description provided for @plLoadOlderReports.
  ///
  /// In en, this message translates to:
  /// **'Load older reports'**
  String get plLoadOlderReports;

  /// No description provided for @plNoSubject.
  ///
  /// In en, this message translates to:
  /// **'(No subject)'**
  String get plNoSubject;

  /// No description provided for @plReceiptRef.
  ///
  /// In en, this message translates to:
  /// **'Receipt reference: {a}'**
  String plReceiptRef(String a);

  /// No description provided for @plShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get plShowLess;

  /// No description provided for @plShowFull.
  ///
  /// In en, this message translates to:
  /// **'Show full message'**
  String get plShowFull;

  /// No description provided for @plCatGeneral.
  ///
  /// In en, this message translates to:
  /// **'General feedback'**
  String get plCatGeneral;

  /// No description provided for @plCatElection.
  ///
  /// In en, this message translates to:
  /// **'Election issue'**
  String get plCatElection;

  /// No description provided for @plCatTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical problem'**
  String get plCatTechnical;

  /// No description provided for @plCatAccount.
  ///
  /// In en, this message translates to:
  /// **'Account issue'**
  String get plCatAccount;

  /// No description provided for @plStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get plStatusOpen;

  /// No description provided for @plCheckingAccess.
  ///
  /// In en, this message translates to:
  /// **'Checking platform access…'**
  String get plCheckingAccess;

  /// No description provided for @plDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get plDeniedTitle;

  /// No description provided for @plVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify platform administrator access.'**
  String get plVerifyFailed;

  /// No description provided for @plOnlySuper.
  ///
  /// In en, this message translates to:
  /// **'This area is available only to Platform Super Admins.'**
  String get plOnlySuper;

  /// No description provided for @msActive.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get msActive;

  /// No description provided for @msInactive.
  ///
  /// In en, this message translates to:
  /// **'inactive'**
  String get msInactive;

  /// No description provided for @msPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get msPending;

  /// No description provided for @msSuspended.
  ///
  /// In en, this message translates to:
  /// **'suspended'**
  String get msSuspended;

  /// No description provided for @msRemoved.
  ///
  /// In en, this message translates to:
  /// **'removed'**
  String get msRemoved;

  /// No description provided for @coTypeAcademic.
  ///
  /// In en, this message translates to:
  /// **'Academic Institution'**
  String get coTypeAcademic;

  /// No description provided for @coTypeCorporate.
  ///
  /// In en, this message translates to:
  /// **'Corporate Enterprise'**
  String get coTypeCorporate;

  /// No description provided for @coTypeNonProfit.
  ///
  /// In en, this message translates to:
  /// **'Non-Profit Organization'**
  String get coTypeNonProfit;

  /// No description provided for @coTypeClub.
  ///
  /// In en, this message translates to:
  /// **'Club / Student Society'**
  String get coTypeClub;

  /// No description provided for @coTypeCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community Association'**
  String get coTypeCommunity;

  /// No description provided for @coTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get coTypeOther;

  /// No description provided for @coCreated.
  ///
  /// In en, this message translates to:
  /// **'Organization created and verified!'**
  String get coCreated;

  /// No description provided for @coClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get coClose;

  /// No description provided for @coTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an organization'**
  String get coTitle;

  /// No description provided for @coSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give your community a shared space for people, departments and activity.'**
  String get coSubtitle;

  /// No description provided for @coNameLabel.
  ///
  /// In en, this message translates to:
  /// **'ORGANIZATION NAME *'**
  String get coNameLabel;

  /// No description provided for @coNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Your community or company'**
  String get coNameHint;

  /// No description provided for @coNameField.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get coNameField;

  /// No description provided for @coNameShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get coNameShort;

  /// No description provided for @coNameLong.
  ///
  /// In en, this message translates to:
  /// **'Name cannot exceed 80 characters'**
  String get coNameLong;

  /// No description provided for @coNameHelp.
  ///
  /// In en, this message translates to:
  /// **'Use a name your members will recognize. 2–80 characters.'**
  String get coNameHelp;

  /// No description provided for @coTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'ORGANIZATION TYPE *'**
  String get coTypeLabel;

  /// No description provided for @coTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select a type'**
  String get coTypeHint;

  /// No description provided for @coCityLabel.
  ///
  /// In en, this message translates to:
  /// **'CITY (OPTIONAL)'**
  String get coCityLabel;

  /// No description provided for @coCityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city'**
  String get coCityHint;

  /// No description provided for @coCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'COUNTRY (OPTIONAL)'**
  String get coCountryLabel;

  /// No description provided for @coCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get coCountryHint;

  /// No description provided for @coVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified instantly, you\'ll be the owner'**
  String get coVerifiedTitle;

  /// No description provided for @coVerifiedBody.
  ///
  /// In en, this message translates to:
  /// **'Since your account email is verified, your organization is created already verified - no manual review needed. Set up your workspace, branding and joining codes right after.'**
  String get coVerifiedBody;

  /// No description provided for @coRequired.
  ///
  /// In en, this message translates to:
  /// **'* Complete the required fields to create your organization.'**
  String get coRequired;

  /// No description provided for @coCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get coCancel;

  /// No description provided for @coCreate.
  ///
  /// In en, this message translates to:
  /// **'Create organization'**
  String get coCreate;

  /// No description provided for @joJoined.
  ///
  /// In en, this message translates to:
  /// **'Successfully joined {a}!'**
  String joJoined(String a);

  /// No description provided for @joClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get joClose;

  /// No description provided for @joTitle.
  ///
  /// In en, this message translates to:
  /// **'Join organization with code'**
  String get joTitle;

  /// No description provided for @joSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the joining code shared by your organization\'s owner to find your workspace.'**
  String get joSubtitle;

  /// No description provided for @joCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'JOINING CODE'**
  String get joCodeLabel;

  /// No description provided for @joCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your joining code'**
  String get joCodeHint;

  /// No description provided for @joCodeField.
  ///
  /// In en, this message translates to:
  /// **'Joining Code'**
  String get joCodeField;

  /// No description provided for @joCodeHelp.
  ///
  /// In en, this message translates to:
  /// **'Paste the complete code exactly as it was shared with you.'**
  String get joCodeHelp;

  /// No description provided for @joScan.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code instead'**
  String get joScan;

  /// No description provided for @joNoCode.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a code?'**
  String get joNoCode;

  /// No description provided for @joNoCodeBody.
  ///
  /// In en, this message translates to:
  /// **'Ask your organization\'s owner for one. If a code is invalid or expired, request a new code.'**
  String get joNoCodeBody;

  /// No description provided for @joReviewNote.
  ///
  /// In en, this message translates to:
  /// **'You\'ll review the organization before confirming that you want to join.'**
  String get joReviewNote;

  /// No description provided for @joCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get joCancel;

  /// No description provided for @joFind.
  ///
  /// In en, this message translates to:
  /// **'Find organization'**
  String get joFind;

  /// No description provided for @joConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Is this your organization?'**
  String get joConfirmTitle;

  /// No description provided for @joConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm this is the workspace you want to join before continuing.'**
  String get joConfirmBody;

  /// No description provided for @joVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get joVerified;

  /// No description provided for @joPending.
  ///
  /// In en, this message translates to:
  /// **'Pending verification'**
  String get joPending;

  /// No description provided for @joDifferent.
  ///
  /// In en, this message translates to:
  /// **'Use a different code'**
  String get joDifferent;

  /// No description provided for @joJoin.
  ///
  /// In en, this message translates to:
  /// **'Join {a}'**
  String joJoin(String a);

  /// No description provided for @imCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitation Created'**
  String get imCreatedTitle;

  /// No description provided for @imCreatedBody.
  ///
  /// In en, this message translates to:
  /// **'An invitation was created for {a}.'**
  String imCreatedBody(String a);

  /// No description provided for @imCreatedNote.
  ///
  /// In en, this message translates to:
  /// **'The invitee will see it in Kivora Notifications after logging in. They can accept or decline there.'**
  String get imCreatedNote;

  /// No description provided for @imShareLink.
  ///
  /// In en, this message translates to:
  /// **'Share this direct link with the invitee:'**
  String get imShareLink;

  /// No description provided for @imDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get imDone;

  /// No description provided for @imTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite Member'**
  String get imTitle;

  /// No description provided for @imClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get imClose;

  /// No description provided for @imSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite someone to join your workspace.'**
  String get imSubtitle;

  /// No description provided for @imEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient Email Address *'**
  String get imEmailLabel;

  /// No description provided for @imEmailHint.
  ///
  /// In en, this message translates to:
  /// **'voter@organization.com'**
  String get imEmailHint;

  /// No description provided for @imOrg.
  ///
  /// In en, this message translates to:
  /// **'Organization: {a}'**
  String imOrg(String a);

  /// No description provided for @imRole.
  ///
  /// In en, this message translates to:
  /// **'Role Permission'**
  String get imRole;

  /// No description provided for @imRoleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get imRoleMember;

  /// No description provided for @imRoleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get imRoleAdmin;

  /// No description provided for @imCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get imCancel;

  /// No description provided for @imSend.
  ///
  /// In en, this message translates to:
  /// **'Send invitation'**
  String get imSend;

  /// No description provided for @aeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add existing member'**
  String get aeTitle;

  /// No description provided for @aeClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get aeClose;

  /// No description provided for @aeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a verified Kivora account directly to this organization.'**
  String get aeSubtitle;

  /// No description provided for @aeEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Member Email Address *'**
  String get aeEmailLabel;

  /// No description provided for @aeEmailHint.
  ///
  /// In en, this message translates to:
  /// **'user@example.com'**
  String get aeEmailHint;

  /// No description provided for @aeEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get aeEmailInvalid;

  /// No description provided for @aeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get aeCancel;

  /// No description provided for @aeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get aeAdd;

  /// No description provided for @adAssigned.
  ///
  /// In en, this message translates to:
  /// **'Member assigned successfully.'**
  String get adAssigned;

  /// No description provided for @adFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to assign member: {a}'**
  String adFailed(String a);

  /// No description provided for @adTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Member to Department'**
  String get adTitle;

  /// No description provided for @adClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get adClose;

  /// No description provided for @adSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search Active Members'**
  String get adSearchLabel;

  /// No description provided for @adSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Type a name or email...'**
  String get adSearchHint;

  /// No description provided for @adNone.
  ///
  /// In en, this message translates to:
  /// **'No eligible active members found.'**
  String get adNone;

  /// No description provided for @adUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get adUnknown;

  /// No description provided for @adCurrentlyIn.
  ///
  /// In en, this message translates to:
  /// **'{a} • currently in {b}'**
  String adCurrentlyIn(String a, String b);

  /// No description provided for @adAddTo.
  ///
  /// In en, this message translates to:
  /// **'Add {a} to this department'**
  String adAddTo(String a);

  /// No description provided for @mpCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get mpCancel;

  /// No description provided for @mpUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get mpUser;

  /// No description provided for @mpNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get mpNone;

  /// No description provided for @mpRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get mpRole;

  /// No description provided for @mpStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get mpStatus;

  /// No description provided for @mpDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get mpDepartment;

  /// No description provided for @mpObserver.
  ///
  /// In en, this message translates to:
  /// **'Observer Access'**
  String get mpObserver;

  /// No description provided for @mpGranted.
  ///
  /// In en, this message translates to:
  /// **'Granted'**
  String get mpGranted;

  /// No description provided for @mpPromote.
  ///
  /// In en, this message translates to:
  /// **'Promote to Admin'**
  String get mpPromote;

  /// No description provided for @mpPromoted.
  ///
  /// In en, this message translates to:
  /// **'Promoted to Admin successfully.'**
  String get mpPromoted;

  /// No description provided for @mpDemote.
  ///
  /// In en, this message translates to:
  /// **'Demote to Member'**
  String get mpDemote;

  /// No description provided for @mpDemoted.
  ///
  /// In en, this message translates to:
  /// **'Demoted to Member successfully.'**
  String get mpDemoted;

  /// No description provided for @mpGrantObserver.
  ///
  /// In en, this message translates to:
  /// **'Grant Observer Access'**
  String get mpGrantObserver;

  /// No description provided for @mpGrantedDone.
  ///
  /// In en, this message translates to:
  /// **'Granted observer access.'**
  String get mpGrantedDone;

  /// No description provided for @mpRevokeObserver.
  ///
  /// In en, this message translates to:
  /// **'Revoke Observer Access'**
  String get mpRevokeObserver;

  /// No description provided for @mpRevokedDone.
  ///
  /// In en, this message translates to:
  /// **'Revoked observer access.'**
  String get mpRevokedDone;

  /// No description provided for @mpDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Member'**
  String get mpDeactivate;

  /// No description provided for @mpDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Deactivated member successfully.'**
  String get mpDeactivated;

  /// No description provided for @mpReactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate Member'**
  String get mpReactivate;

  /// No description provided for @mpReactivated.
  ///
  /// In en, this message translates to:
  /// **'Reactivated member successfully.'**
  String get mpReactivated;

  /// No description provided for @mpRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get mpRemove;

  /// No description provided for @mpRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {a}?'**
  String mpRemoveTitle(String a);

  /// No description provided for @mpRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'They will lose access to this organization immediately.'**
  String get mpRemoveBody;

  /// No description provided for @mpRemoved.
  ///
  /// In en, this message translates to:
  /// **'Member removed from organization.'**
  String get mpRemoved;

  /// No description provided for @mpClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get mpClose;

  /// No description provided for @imOrgLabel.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get imOrgLabel;

  /// No description provided for @vtCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate election'**
  String get vtCandidate;

  /// No description provided for @vtSingleChoice.
  ///
  /// In en, this message translates to:
  /// **'Single-choice poll'**
  String get vtSingleChoice;

  /// No description provided for @vtYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes/No poll'**
  String get vtYesNo;

  /// No description provided for @etAll.
  ///
  /// In en, this message translates to:
  /// **'All active members'**
  String get etAll;

  /// No description provided for @etMembers.
  ///
  /// In en, this message translates to:
  /// **'Selected members'**
  String get etMembers;

  /// No description provided for @etDepartments.
  ///
  /// In en, this message translates to:
  /// **'Selected departments'**
  String get etDepartments;

  /// No description provided for @ccLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the command center. Check your connection and try again.'**
  String get ccLoadError;

  /// No description provided for @ccNoOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'No active organization'**
  String get ccNoOrgTitle;

  /// No description provided for @ccNoOrgBody.
  ///
  /// In en, this message translates to:
  /// **'Select an organization to view its command center.'**
  String get ccNoOrgBody;

  /// No description provided for @ccAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Administrator access required'**
  String get ccAdminTitle;

  /// No description provided for @ccAdminBody.
  ///
  /// In en, this message translates to:
  /// **'The election command center is available to organization owners and admins.'**
  String get ccAdminBody;

  /// No description provided for @ccElectionsError.
  ///
  /// In en, this message translates to:
  /// **'We could not load elections. Check your connection and try again.'**
  String get ccElectionsError;

  /// No description provided for @ccTitle.
  ///
  /// In en, this message translates to:
  /// **'Election Command Center'**
  String get ccTitle;

  /// No description provided for @ccSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get ccSearch;

  /// No description provided for @ccFilterDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date range'**
  String get ccFilterDate;

  /// No description provided for @ccCreate.
  ///
  /// In en, this message translates to:
  /// **'Create election'**
  String get ccCreate;

  /// No description provided for @ccSuspended.
  ///
  /// In en, this message translates to:
  /// **'This organization is suspended. Election management is disabled until it is reinstated.'**
  String get ccSuspended;

  /// No description provided for @ccActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Election Monitoring'**
  String get ccActiveTitle;

  /// No description provided for @ccActiveNone.
  ///
  /// In en, this message translates to:
  /// **'No elections are currently active.'**
  String get ccActiveNone;

  /// No description provided for @ccUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Election Schedule'**
  String get ccUpcomingTitle;

  /// No description provided for @ccUpcomingNone.
  ///
  /// In en, this message translates to:
  /// **'No elections are scheduled.'**
  String get ccUpcomingNone;

  /// No description provided for @ccAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get ccAlerts;

  /// No description provided for @ccNoVoters.
  ///
  /// In en, this message translates to:
  /// **'\"{a}\" has no eligible voters configured.'**
  String ccNoVoters(String a);

  /// No description provided for @ccTasks.
  ///
  /// In en, this message translates to:
  /// **'Pending Administrative Tasks'**
  String get ccTasks;

  /// No description provided for @ccTasksNone.
  ///
  /// In en, this message translates to:
  /// **'No pending tasks. You\'re all caught up.'**
  String get ccTasksNone;

  /// No description provided for @ccDraft.
  ///
  /// In en, this message translates to:
  /// **'\"{a}\" is still a draft and needs review before publishing.'**
  String ccDraft(String a);

  /// No description provided for @ccInviteOne.
  ///
  /// In en, this message translates to:
  /// **'1 invitation is awaiting a response.'**
  String get ccInviteOne;

  /// No description provided for @ccInviteMany.
  ///
  /// In en, this message translates to:
  /// **'{a} invitations are awaiting a response.'**
  String ccInviteMany(String a);

  /// No description provided for @ccMembership.
  ///
  /// In en, this message translates to:
  /// **'Membership & Invitations'**
  String get ccMembership;

  /// No description provided for @ccTotalMembers.
  ///
  /// In en, this message translates to:
  /// **'Total members'**
  String get ccTotalMembers;

  /// No description provided for @ccPendingInvites.
  ///
  /// In en, this message translates to:
  /// **'Pending invitations'**
  String get ccPendingInvites;

  /// No description provided for @ccRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent Administrative Activity'**
  String get ccRecent;

  /// No description provided for @ccExport.
  ///
  /// In en, this message translates to:
  /// **'Export report (CSV)'**
  String get ccExport;

  /// No description provided for @ccStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Elections'**
  String get ccStatTotal;

  /// No description provided for @ccStatActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ccStatActive;

  /// No description provided for @ccStatScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get ccStatScheduled;

  /// No description provided for @ccStatClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get ccStatClosed;

  /// No description provided for @ccStatMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get ccStatMembers;

  /// No description provided for @ccStatMembersSub.
  ///
  /// In en, this message translates to:
  /// **'All organization members'**
  String get ccStatMembersSub;

  /// No description provided for @ccNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity.'**
  String get ccNoActivity;

  /// No description provided for @ccMonitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get ccMonitor;

  /// No description provided for @ccTurnoutUnknown.
  ///
  /// In en, this message translates to:
  /// **'Live turnout unavailable'**
  String get ccTurnoutUnknown;

  /// No description provided for @ccTurnout.
  ///
  /// In en, this message translates to:
  /// **'{a} of {b} voted ({c}%)'**
  String ccTurnout(String a, String b, String c);

  /// No description provided for @biTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Election Template'**
  String get biTemplateTitle;

  /// No description provided for @biTemplateBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a pre-configured template to speed up your election creation.'**
  String get biTemplateBody;

  /// No description provided for @biT1Name.
  ///
  /// In en, this message translates to:
  /// **'Executive / Board Election'**
  String get biT1Name;

  /// No description provided for @biT1Sub.
  ///
  /// In en, this message translates to:
  /// **'Candidate Election • Anonymous Ballot'**
  String get biT1Sub;

  /// No description provided for @biT1Title.
  ///
  /// In en, this message translates to:
  /// **'Executive Board Election'**
  String get biT1Title;

  /// No description provided for @biT1Desc.
  ///
  /// In en, this message translates to:
  /// **'Annual election to select executive board representatives. Ballots are strictly anonymous.'**
  String get biT1Desc;

  /// No description provided for @biT2Name.
  ///
  /// In en, this message translates to:
  /// **'Policy / Resolution Vote'**
  String get biT2Name;

  /// No description provided for @biT2Sub.
  ///
  /// In en, this message translates to:
  /// **'Yes/No Poll • Anonymous Ballot'**
  String get biT2Sub;

  /// No description provided for @biT2Title.
  ///
  /// In en, this message translates to:
  /// **'Organization Policy Resolution'**
  String get biT2Title;

  /// No description provided for @biT2Desc.
  ///
  /// In en, this message translates to:
  /// **'Vote on the proposed amendment to organization bylaws. Please review the attached documentation before voting.'**
  String get biT2Desc;

  /// No description provided for @biT3Name.
  ///
  /// In en, this message translates to:
  /// **'Community Opinion Poll'**
  String get biT3Name;

  /// No description provided for @biT3Sub.
  ///
  /// In en, this message translates to:
  /// **'Single-Choice Poll • Identifiable'**
  String get biT3Sub;

  /// No description provided for @biT3Title.
  ///
  /// In en, this message translates to:
  /// **'Community Feedback Survey'**
  String get biT3Title;

  /// No description provided for @biT3Desc.
  ///
  /// In en, this message translates to:
  /// **'Short survey to collect community sentiment on upcoming initiatives.'**
  String get biT3Desc;

  /// No description provided for @biLocked.
  ///
  /// In en, this message translates to:
  /// **'Event is no longer a DRAFT. Basic info is strictly immutable.'**
  String get biLocked;

  /// No description provided for @biTitle.
  ///
  /// In en, this message translates to:
  /// **'Election details'**
  String get biTitle;

  /// No description provided for @biSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Provide the basic information about your election.'**
  String get biSubtitle;

  /// No description provided for @biUseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use template'**
  String get biUseTemplate;

  /// No description provided for @biTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Event Title *'**
  String get biTitleLabel;

  /// No description provided for @biTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Annual Team Selection'**
  String get biTitleHint;

  /// No description provided for @biTitleInvalid.
  ///
  /// In en, this message translates to:
  /// **'Title must be 3-100 characters.'**
  String get biTitleInvalid;

  /// No description provided for @biDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get biDescLabel;

  /// No description provided for @biDescHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the purpose, context and important details about this event...'**
  String get biDescHint;

  /// No description provided for @biDescRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required.'**
  String get biDescRequired;

  /// No description provided for @biDescLong.
  ///
  /// In en, this message translates to:
  /// **'Description cannot exceed 500 characters.'**
  String get biDescLong;

  /// No description provided for @biVotingType.
  ///
  /// In en, this message translates to:
  /// **'Voting Type'**
  String get biVotingType;

  /// No description provided for @biTypeCandidate.
  ///
  /// In en, this message translates to:
  /// **'Candidate Election'**
  String get biTypeCandidate;

  /// No description provided for @biTypeCandidateSub.
  ///
  /// In en, this message translates to:
  /// **'Voters select one candidate from a roster.'**
  String get biTypeCandidateSub;

  /// No description provided for @biTypeSingle.
  ///
  /// In en, this message translates to:
  /// **'Single-Choice Poll'**
  String get biTypeSingle;

  /// No description provided for @biTypeSingleSub.
  ///
  /// In en, this message translates to:
  /// **'Voters select one option from a list.'**
  String get biTypeSingleSub;

  /// No description provided for @biTypeYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes/No Poll'**
  String get biTypeYesNo;

  /// No description provided for @biTypeYesNoSub.
  ///
  /// In en, this message translates to:
  /// **'Voters approve or reject a proposal.'**
  String get biTypeYesNoSub;

  /// No description provided for @biPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Ballot privacy'**
  String get biPrivacy;

  /// No description provided for @biAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get biAnonymous;

  /// No description provided for @biIdentifiable.
  ///
  /// In en, this message translates to:
  /// **'Identifiable'**
  String get biIdentifiable;

  /// No description provided for @biAnonymousNote.
  ///
  /// In en, this message translates to:
  /// **'Voter identity is stored separately from the ballot.'**
  String get biAnonymousNote;

  /// No description provided for @biIdentifiableNote.
  ///
  /// In en, this message translates to:
  /// **'Each ballot is associated with the voter’s account. Voters will see this notice before confirming.'**
  String get biIdentifiableNote;

  /// No description provided for @biNext.
  ///
  /// In en, this message translates to:
  /// **'Next: Schedule'**
  String get biNext;

  /// No description provided for @elLocked.
  ///
  /// In en, this message translates to:
  /// **'Event is no longer a DRAFT. Eligibility configuration is strictly immutable.'**
  String get elLocked;

  /// No description provided for @elTitle.
  ///
  /// In en, this message translates to:
  /// **'Voter Eligibility'**
  String get elTitle;

  /// No description provided for @elWho.
  ///
  /// In en, this message translates to:
  /// **'Who can vote?'**
  String get elWho;

  /// No description provided for @elAll.
  ///
  /// In en, this message translates to:
  /// **'All Active Members'**
  String get elAll;

  /// No description provided for @elDepts.
  ///
  /// In en, this message translates to:
  /// **'Selected Departments'**
  String get elDepts;

  /// No description provided for @elMembers.
  ///
  /// In en, this message translates to:
  /// **'Selected Members'**
  String get elMembers;

  /// No description provided for @elBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get elBack;

  /// No description provided for @elCreateDraft.
  ///
  /// In en, this message translates to:
  /// **'Create Draft & Continue'**
  String get elCreateDraft;

  /// No description provided for @elNext.
  ///
  /// In en, this message translates to:
  /// **'Next: Choices'**
  String get elNext;

  /// No description provided for @elListError.
  ///
  /// In en, this message translates to:
  /// **'We could not load this list. Go back and try again.'**
  String get elListError;

  /// No description provided for @elNoDepts.
  ///
  /// In en, this message translates to:
  /// **'No departments found in this organization.'**
  String get elNoDepts;

  /// No description provided for @elNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No active members found.'**
  String get elNoMembers;

  /// No description provided for @elSelected.
  ///
  /// In en, this message translates to:
  /// **'{a} selected of {b} active members'**
  String elSelected(String a, String b);

  /// No description provided for @elCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV Bulk Import'**
  String get elCsv;

  /// No description provided for @rvPublishTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish this election?'**
  String get rvPublishTitle;

  /// No description provided for @rvPublishBody.
  ///
  /// In en, this message translates to:
  /// **'Eligible members will see it according to the schedule. After publishing you can no longer change its details, schedule or eligibility.'**
  String get rvPublishBody;

  /// No description provided for @rvKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get rvKeepEditing;

  /// No description provided for @rvPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get rvPublish;

  /// No description provided for @rvPublished.
  ///
  /// In en, this message translates to:
  /// **'Election published.'**
  String get rvPublished;

  /// No description provided for @rvReauth.
  ///
  /// In en, this message translates to:
  /// **'For security, publishing an election requires you to have signed in within the last 15 minutes. Please verify your identity to continue.'**
  String get rvReauth;

  /// No description provided for @rvPublishFailed.
  ///
  /// In en, this message translates to:
  /// **'We could not publish the election. Please try again.'**
  String get rvPublishFailed;

  /// No description provided for @rvChoicesError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the choices. Go back and try again.'**
  String get rvChoicesError;

  /// No description provided for @rvCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Title configured'**
  String get rvCheckTitle;

  /// No description provided for @rvCheckDesc.
  ///
  /// In en, this message translates to:
  /// **'Description added'**
  String get rvCheckDesc;

  /// No description provided for @rvCheckSchedule.
  ///
  /// In en, this message translates to:
  /// **'Voting window scheduled'**
  String get rvCheckSchedule;

  /// No description provided for @rvCheckPrivacyId.
  ///
  /// In en, this message translates to:
  /// **'Privacy mode set (Identifiable)'**
  String get rvCheckPrivacyId;

  /// No description provided for @rvCheckPrivacyAnon.
  ///
  /// In en, this message translates to:
  /// **'Privacy mode set (Anonymous)'**
  String get rvCheckPrivacyAnon;

  /// No description provided for @rvCheckChoices.
  ///
  /// In en, this message translates to:
  /// **'Candidates/options configured ({a})'**
  String rvCheckChoices(String a);

  /// No description provided for @rvCheckEligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility rules valid ({a})'**
  String rvCheckEligibility(String a);

  /// No description provided for @rvTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Publish'**
  String get rvTitle;

  /// No description provided for @rvChecklist.
  ///
  /// In en, this message translates to:
  /// **'ELECTION SETUP CHECKLIST'**
  String get rvChecklist;

  /// No description provided for @rvTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get rvTitleLabel;

  /// No description provided for @rvStart.
  ///
  /// In en, this message translates to:
  /// **'Start At'**
  String get rvStart;

  /// No description provided for @rvEnd.
  ///
  /// In en, this message translates to:
  /// **'End At'**
  String get rvEnd;

  /// No description provided for @rvChoices.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get rvChoices;

  /// No description provided for @rvItems.
  ///
  /// In en, this message translates to:
  /// **'{a} items configured'**
  String rvItems(String a);

  /// No description provided for @rvIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Complete every required checklist item above before publishing.'**
  String get rvIncomplete;

  /// No description provided for @rvBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get rvBack;

  /// No description provided for @rvPublishButton.
  ///
  /// In en, this message translates to:
  /// **'Publish election'**
  String get rvPublishButton;

  /// No description provided for @rvOptional.
  ///
  /// In en, this message translates to:
  /// **' (optional)'**
  String get rvOptional;

  /// No description provided for @scRequired.
  ///
  /// In en, this message translates to:
  /// **'Start and End times are required.'**
  String get scRequired;

  /// No description provided for @scPast.
  ///
  /// In en, this message translates to:
  /// **'Start time cannot be in the past.'**
  String get scPast;

  /// No description provided for @scShort.
  ///
  /// In en, this message translates to:
  /// **'Voting window must be at least 5 minutes.'**
  String get scShort;

  /// No description provided for @scLocked.
  ///
  /// In en, this message translates to:
  /// **'Event is no longer a DRAFT. Schedule is strictly immutable.'**
  String get scLocked;

  /// No description provided for @scTitle.
  ///
  /// In en, this message translates to:
  /// **'Voting Schedule'**
  String get scTitle;

  /// No description provided for @scZoneNote.
  ///
  /// In en, this message translates to:
  /// **'Times are entered in your time zone: {a}. All times are evaluated securely against the server clock.'**
  String scZoneNote(String a);

  /// No description provided for @scStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get scStartTime;

  /// No description provided for @scNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get scNotSet;

  /// No description provided for @scEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get scEndTime;

  /// No description provided for @scBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get scBack;

  /// No description provided for @scNext.
  ///
  /// In en, this message translates to:
  /// **'Next: Eligibility'**
  String get scNext;

  /// No description provided for @obTitle.
  ///
  /// In en, this message translates to:
  /// **'Observer Dashboard'**
  String get obTitle;

  /// No description provided for @obTransparency.
  ///
  /// In en, this message translates to:
  /// **'Trust & Transparency Center'**
  String get obTransparency;

  /// No description provided for @obLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load this view. Check your connection and try again.'**
  String get obLoadError;

  /// No description provided for @obNoOrgTitle.
  ///
  /// In en, this message translates to:
  /// **'No active organization'**
  String get obNoOrgTitle;

  /// No description provided for @obNoOrgBody.
  ///
  /// In en, this message translates to:
  /// **'Select an organization to view its observer dashboard.'**
  String get obNoOrgBody;

  /// No description provided for @obAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Observer access required'**
  String get obAccessTitle;

  /// No description provided for @obAccessBody.
  ///
  /// In en, this message translates to:
  /// **'This dashboard is only available to members granted observer access by an organization admin.'**
  String get obAccessBody;

  /// No description provided for @obNoElectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No elections yet'**
  String get obNoElectionsTitle;

  /// No description provided for @obNoElectionsBody.
  ///
  /// In en, this message translates to:
  /// **'There are no published elections in this organization yet.'**
  String get obNoElectionsBody;

  /// No description provided for @obNote.
  ///
  /// In en, this message translates to:
  /// **'You have read-only Observer access to {a}. You see organization-wide aggregates only, never individual ballots, voter identities, or per-department breakdowns.'**
  String obNote(String a);

  /// No description provided for @obActive.
  ///
  /// In en, this message translates to:
  /// **'Active Elections'**
  String get obActive;

  /// No description provided for @obTimeline.
  ///
  /// In en, this message translates to:
  /// **'Election Timeline'**
  String get obTimeline;

  /// No description provided for @obTurnoutUnknown.
  ///
  /// In en, this message translates to:
  /// **'Aggregate turnout unavailable'**
  String get obTurnoutUnknown;

  /// No description provided for @obTurnout.
  ///
  /// In en, this message translates to:
  /// **'{a} of {b} eligible voters ({c}%)'**
  String obTurnout(String a, String b, String c);

  /// No description provided for @vpWelcomeNamed.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {a}'**
  String vpWelcomeNamed(String a);

  /// No description provided for @vpWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get vpWelcome;

  /// No description provided for @vpReadyOne.
  ///
  /// In en, this message translates to:
  /// **'1 election is open for your vote.'**
  String get vpReadyOne;

  /// No description provided for @vpReadyMany.
  ///
  /// In en, this message translates to:
  /// **'{a} elections are open for your vote.'**
  String vpReadyMany(String a);

  /// No description provided for @vpAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up. Nothing is waiting for your vote.'**
  String get vpAllCaughtUp;

  /// No description provided for @vpYourWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Your voting workspace'**
  String get vpYourWorkspace;

  /// No description provided for @vpOpenFirst.
  ///
  /// In en, this message translates to:
  /// **'Go to my ballot'**
  String get vpOpenFirst;

  /// No description provided for @gsHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get gsHome;

  /// No description provided for @gsHomeSub.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get gsHomeSub;

  /// No description provided for @gsOrgs.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get gsOrgs;

  /// No description provided for @gsOrgsSub.
  ///
  /// In en, this message translates to:
  /// **'Your workspaces'**
  String get gsOrgsSub;

  /// No description provided for @gsEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get gsEvents;

  /// No description provided for @gsEventsSub.
  ///
  /// In en, this message translates to:
  /// **'Manage voting events'**
  String get gsEventsSub;

  /// No description provided for @gsMembers.
  ///
  /// In en, this message translates to:
  /// **'Members directory'**
  String get gsMembers;

  /// No description provided for @gsMembersSub.
  ///
  /// In en, this message translates to:
  /// **'Browse org members'**
  String get gsMembersSub;

  /// No description provided for @gsDepts.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get gsDepts;

  /// No description provided for @gsDeptsSub.
  ///
  /// In en, this message translates to:
  /// **'Manage departments'**
  String get gsDeptsSub;

  /// No description provided for @gsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get gsAccount;

  /// No description provided for @gsAccountSub.
  ///
  /// In en, this message translates to:
  /// **'Profile & security'**
  String get gsAccountSub;

  /// No description provided for @gsAudit.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get gsAudit;

  /// No description provided for @gsAuditSub.
  ///
  /// In en, this message translates to:
  /// **'Organization activity'**
  String get gsAuditSub;

  /// No description provided for @gsInvites.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get gsInvites;

  /// No description provided for @gsInvitesSub.
  ///
  /// In en, this message translates to:
  /// **'Pending org invitations'**
  String get gsInvitesSub;

  /// No description provided for @gsOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get gsOrganization;

  /// No description provided for @gsVotingEvent.
  ///
  /// In en, this message translates to:
  /// **'Voting event · {a}'**
  String gsVotingEvent(String a);

  /// No description provided for @gsSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get gsSearchLabel;

  /// No description provided for @gsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search events, members, organizations…'**
  String get gsSearchHint;

  /// No description provided for @gsEsc.
  ///
  /// In en, this message translates to:
  /// **'ESC'**
  String get gsEsc;

  /// No description provided for @gsNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{a}\"'**
  String gsNoResults(String a);

  /// No description provided for @authTagline.
  ///
  /// In en, this message translates to:
  /// **'Secure voting for organizations'**
  String get authTagline;

  /// No description provided for @aiWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {a}!'**
  String aiWelcome(String a);

  /// No description provided for @aiTheOrg.
  ///
  /// In en, this message translates to:
  /// **'the organization'**
  String get aiTheOrg;

  /// No description provided for @alBadge.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY-AWARE VOTING'**
  String get alBadge;

  /// No description provided for @alHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your Voice,\nYour Choice.'**
  String get alHeadline;

  /// No description provided for @alSub.
  ///
  /// In en, this message translates to:
  /// **'Secure, transparent and modern\ne-voting for organizations.'**
  String get alSub;

  /// No description provided for @alP1.
  ///
  /// In en, this message translates to:
  /// **'Server-authorized voting'**
  String get alP1;

  /// No description provided for @alP1b.
  ///
  /// In en, this message translates to:
  /// **'Ballots are validated and recorded by trusted backend services.'**
  String get alP1b;

  /// No description provided for @alP2.
  ///
  /// In en, this message translates to:
  /// **'Privacy-aware ballots'**
  String get alP2;

  /// No description provided for @alP2b.
  ///
  /// In en, this message translates to:
  /// **'Anonymous ballots are separated from participation records.'**
  String get alP2b;

  /// No description provided for @alP3.
  ///
  /// In en, this message translates to:
  /// **'Clear participation receipts'**
  String get alP3;

  /// No description provided for @alP3b.
  ///
  /// In en, this message translates to:
  /// **'Confirm participation without revealing your selection.'**
  String get alP3b;

  /// No description provided for @alCopy.
  ///
  /// In en, this message translates to:
  /// **'Kivora © 2026'**
  String get alCopy;

  /// No description provided for @alPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Android • Web'**
  String get alPlatforms;

  /// No description provided for @osTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch organization'**
  String get osTitle;

  /// No description provided for @osBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the workspace you want to work in.'**
  String get osBody;

  /// No description provided for @osLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your organizations.'**
  String get osLoadError;

  /// No description provided for @osRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get osRetry;

  /// No description provided for @osNone.
  ///
  /// In en, this message translates to:
  /// **'No joined organizations found.'**
  String get osNone;

  /// No description provided for @osJoin.
  ///
  /// In en, this message translates to:
  /// **'Join organization with code'**
  String get osJoin;

  /// No description provided for @osCreate.
  ///
  /// In en, this message translates to:
  /// **'Create new organization'**
  String get osCreate;

  /// No description provided for @osInvites.
  ///
  /// In en, this message translates to:
  /// **'View invitations'**
  String get osInvites;

  /// No description provided for @osRetry2.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get osRetry2;

  /// No description provided for @osSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Organization'**
  String get osSelect;

  /// No description provided for @osCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'CURRENT ORGANIZATION'**
  String get osCurrentLabel;

  /// No description provided for @osCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current organization'**
  String get osCurrent;

  /// No description provided for @osSwitchTo.
  ///
  /// In en, this message translates to:
  /// **'Switch to this organization'**
  String get osSwitchTo;

  /// No description provided for @aiMissing.
  ///
  /// In en, this message translates to:
  /// **'This invitation link is missing or malformed.'**
  String get aiMissing;

  /// No description provided for @aiInvited.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been invited'**
  String get aiInvited;

  /// No description provided for @aiInvitedBody.
  ///
  /// In en, this message translates to:
  /// **'Accept to join this organization with the email address you\'re signed in with.'**
  String get aiInvitedBody;

  /// No description provided for @aiNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get aiNotNow;

  /// No description provided for @aiAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept invitation'**
  String get aiAccept;

  /// No description provided for @aiAccepting.
  ///
  /// In en, this message translates to:
  /// **'Accepting invitation…'**
  String get aiAccepting;

  /// No description provided for @aiJoinedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve successfully joined. You can start exploring right away.'**
  String get aiJoinedBody;

  /// No description provided for @aiContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get aiContinue;

  /// No description provided for @aiFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t accept this invitation'**
  String get aiFailedTitle;

  /// No description provided for @aiFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get aiFailedBody;

  /// No description provided for @aiHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get aiHome;

  /// No description provided for @shCalendar.
  ///
  /// In en, this message translates to:
  /// **'Election Calendar'**
  String get shCalendar;

  /// No description provided for @shLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get shLight;

  /// No description provided for @shDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get shDark;

  /// No description provided for @shSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get shSearch;

  /// No description provided for @shNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get shNotifications;

  /// No description provided for @shMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get shMarkRead;

  /// No description provided for @shNoNotifications.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get shNoNotifications;

  /// No description provided for @shOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get shOrganization;

  /// No description provided for @shInvitedTo.
  ///
  /// In en, this message translates to:
  /// **'Invited to join {a}'**
  String shInvitedTo(String a);

  /// No description provided for @shRoleAction.
  ///
  /// In en, this message translates to:
  /// **'Role: {a} • Action required'**
  String shRoleAction(String a);

  /// No description provided for @shViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all notifications'**
  String get shViewAll;

  /// No description provided for @shAccountMenu.
  ///
  /// In en, this message translates to:
  /// **'Account menu'**
  String get shAccountMenu;

  /// No description provided for @shAccountRole.
  ///
  /// In en, this message translates to:
  /// **'Account {a}'**
  String shAccountRole(String a);

  /// No description provided for @shAccountUser.
  ///
  /// In en, this message translates to:
  /// **'Account user'**
  String get shAccountUser;

  /// No description provided for @shAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get shAccountSettings;

  /// No description provided for @shHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get shHelp;

  /// No description provided for @shBilling.
  ///
  /// In en, this message translates to:
  /// **'Plans & Billing'**
  String get shBilling;

  /// No description provided for @shTrust.
  ///
  /// In en, this message translates to:
  /// **'Trust & Transparency'**
  String get shTrust;

  /// No description provided for @shPlatformAdmin.
  ///
  /// In en, this message translates to:
  /// **'Platform admin'**
  String get shPlatformAdmin;

  /// No description provided for @shOrganizations.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get shOrganizations;

  /// No description provided for @shLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get shLogout;

  /// No description provided for @hsThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback! We have received your message.'**
  String get hsThanks;

  /// No description provided for @hsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send feedback. Please check your connection and try again.'**
  String get hsFailed;

  /// No description provided for @hsTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get hsTitle;

  /// No description provided for @hsFaq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get hsFaq;

  /// No description provided for @hsQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I cast my vote?'**
  String get hsQ1;

  /// No description provided for @hsA1.
  ///
  /// In en, this message translates to:
  /// **'You can cast your vote by selecting an active election from your organization dashboard and following the on-screen instructions.'**
  String get hsA1;

  /// No description provided for @hsQ2.
  ///
  /// In en, this message translates to:
  /// **'Are my votes anonymous?'**
  String get hsQ2;

  /// No description provided for @hsA2.
  ///
  /// In en, this message translates to:
  /// **'In an anonymous election, your ballot choice is never linked to your account - the system can confirm you voted without recording what you chose. Identifiable elections are clearly labeled before you vote. See the Trust & Transparency Center for full detail on what your receipt does and doesn\'t prove.'**
  String get hsA2;

  /// No description provided for @hsQ3.
  ///
  /// In en, this message translates to:
  /// **'How can I change my profile information?'**
  String get hsQ3;

  /// No description provided for @hsA3.
  ///
  /// In en, this message translates to:
  /// **'Navigate to the Account Settings page from the top-right profile dropdown menu to update your personal details.'**
  String get hsA3;

  /// No description provided for @hsGuidance.
  ///
  /// In en, this message translates to:
  /// **'Help & Guidance'**
  String get hsGuidance;

  /// No description provided for @hsVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify a receipt'**
  String get hsVerify;

  /// No description provided for @hsVerifyBody.
  ///
  /// In en, this message translates to:
  /// **'Check that a ballot receipt was recorded. This never shows how anyone voted.'**
  String get hsVerifyBody;

  /// No description provided for @hsTrust.
  ///
  /// In en, this message translates to:
  /// **'Trust & transparency'**
  String get hsTrust;

  /// No description provided for @hsTrustBody.
  ///
  /// In en, this message translates to:
  /// **'How Kivora protects ballot privacy and what is recorded.'**
  String get hsTrustBody;

  /// No description provided for @hsSend.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback or Contact Support'**
  String get hsSend;

  /// No description provided for @hsCategory.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get hsCategory;

  /// No description provided for @hsSubject.
  ///
  /// In en, this message translates to:
  /// **'SUBJECT'**
  String get hsSubject;

  /// No description provided for @hsSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'What is this regarding?'**
  String get hsSubjectHint;

  /// No description provided for @hsSubjectField.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get hsSubjectField;

  /// No description provided for @hsReceipt.
  ///
  /// In en, this message translates to:
  /// **'RECEIPT ID (OPTIONAL)'**
  String get hsReceipt;

  /// No description provided for @hsReceiptHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a receipt ID if this relates to a specific vote'**
  String get hsReceiptHint;

  /// No description provided for @hsReceiptNote.
  ///
  /// In en, this message translates to:
  /// **'Never include your ballot choice here - a receipt confirms your vote was recorded, it does not reveal what you selected.'**
  String get hsReceiptNote;

  /// No description provided for @hsMessage.
  ///
  /// In en, this message translates to:
  /// **'MESSAGE'**
  String get hsMessage;

  /// No description provided for @hsMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Please describe your issue or share your feedback...'**
  String get hsMessageHint;

  /// No description provided for @hsMessageField.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get hsMessageField;

  /// No description provided for @hsSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get hsSending;

  /// No description provided for @hsSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get hsSendButton;

  /// No description provided for @rvfTitle.
  ///
  /// In en, this message translates to:
  /// **'Public Receipt Verification'**
  String get rvfTitle;

  /// No description provided for @rvfHeading.
  ///
  /// In en, this message translates to:
  /// **'Verify ballot receipt'**
  String get rvfHeading;

  /// No description provided for @rvfIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter the receipt hash from your receipt to confirm the server recorded it. This checks that a matching receipt exists. It does not show how anyone voted, and it does not independently prove inclusion in the final tally.'**
  String get rvfIntro;

  /// No description provided for @rvfHashLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt hash'**
  String get rvfHashLabel;

  /// No description provided for @rvfHashHint.
  ///
  /// In en, this message translates to:
  /// **'64-character hash (letters a-f and digits)'**
  String get rvfHashHint;

  /// No description provided for @rvfVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify receipt'**
  String get rvfVerify;

  /// No description provided for @rvfOkTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt verified'**
  String get rvfOkTitle;

  /// No description provided for @rvfOkBody.
  ///
  /// In en, this message translates to:
  /// **'A matching receipt was found, so the server recorded this ballot. This does not independently prove inclusion in the final tally.'**
  String get rvfOkBody;

  /// No description provided for @rvfNoTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching receipt'**
  String get rvfNoTitle;

  /// No description provided for @rvfNoBody.
  ///
  /// In en, this message translates to:
  /// **'The service is working and has no receipt with this hash. Check that you copied the whole hash from your receipt.'**
  String get rvfNoBody;

  /// No description provided for @rvfBadTitle.
  ///
  /// In en, this message translates to:
  /// **'That is not a valid receipt hash'**
  String get rvfBadTitle;

  /// No description provided for @rvfBadBody.
  ///
  /// In en, this message translates to:
  /// **'A receipt hash is exactly 64 characters: digits 0-9 and letters a-f. Nothing was sent to the server.'**
  String get rvfBadBody;

  /// No description provided for @rvfRateTitle.
  ///
  /// In en, this message translates to:
  /// **'Too many lookups'**
  String get rvfRateTitle;

  /// No description provided for @rvfRateBody.
  ///
  /// In en, this message translates to:
  /// **'Please wait a minute before trying again.'**
  String get rvfRateBody;

  /// No description provided for @rvfDownTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification is unavailable right now'**
  String get rvfDownTitle;

  /// No description provided for @rvfDownBody.
  ///
  /// In en, this message translates to:
  /// **'We could not reach the verification service, so we cannot say whether your receipt exists. This is not a \"not found\" result. Check your connection and try again.'**
  String get rvfDownBody;

  /// No description provided for @rvfRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get rvfRetry;

  /// No description provided for @rgDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get rgDoneTitle;

  /// No description provided for @rgDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Your Kivora identity has been securely generated. You may now sign in using your credentials.'**
  String get rgDoneBody;

  /// No description provided for @rgReturn.
  ///
  /// In en, this message translates to:
  /// **'Return to Login'**
  String get rgReturn;

  /// No description provided for @rgFirstLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get rgFirstLabel;

  /// No description provided for @rgFirstHint.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get rgFirstHint;

  /// No description provided for @rgFirstField.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get rgFirstField;

  /// No description provided for @rgLastLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get rgLastLabel;

  /// No description provided for @rgLastHint.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get rgLastHint;

  /// No description provided for @rgLastField.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get rgLastField;

  /// No description provided for @rgEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get rgEmailLabel;

  /// No description provided for @rgEmailHint.
  ///
  /// In en, this message translates to:
  /// **'user@email.com'**
  String get rgEmailHint;

  /// No description provided for @rgPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get rgPassword;

  /// No description provided for @rgConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get rgConfirm;

  /// No description provided for @evYourEmail.
  ///
  /// In en, this message translates to:
  /// **'your email address'**
  String get evYourEmail;

  /// No description provided for @evOk.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully!'**
  String get evOk;

  /// No description provided for @evNot.
  ///
  /// In en, this message translates to:
  /// **'Email is not verified yet. Please check your inbox and click the verification link.'**
  String get evNot;

  /// No description provided for @evCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not check verification status: {a}'**
  String evCheckFailed(String a);

  /// No description provided for @evResent.
  ///
  /// In en, this message translates to:
  /// **'A new verification email has been sent. Please check your inbox.'**
  String get evResent;

  /// No description provided for @evResendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend email: {a}'**
  String evResendFailed(String a);

  /// No description provided for @evTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get evTitle;

  /// No description provided for @evSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get evSignOut;

  /// No description provided for @evHeading.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email Address'**
  String get evHeading;

  /// No description provided for @evSent.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification link to:\n{a}'**
  String evSent(String a);

  /// No description provided for @evClick.
  ///
  /// In en, this message translates to:
  /// **'Please click the link in your email to unlock complete platform access.'**
  String get evClick;

  /// No description provided for @evCooldown.
  ///
  /// In en, this message translates to:
  /// **'Resend Email in {a}s'**
  String evCooldown(String a);

  /// No description provided for @evResend.
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get evResend;

  /// No description provided for @evSwitch.
  ///
  /// In en, this message translates to:
  /// **'Sign Out / Use Different Account'**
  String get evSwitch;

  /// No description provided for @fpTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get fpTitle;

  /// No description provided for @fpBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address associated with your account to receive instructions to reset your password.'**
  String get fpBody;

  /// No description provided for @fpSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for this email address, a password reset link has been sent. Please check your inbox.'**
  String get fpSent;

  /// No description provided for @fpEmail.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get fpEmail;

  /// No description provided for @fpEmailHint.
  ///
  /// In en, this message translates to:
  /// **'user@email.com'**
  String get fpEmailHint;

  /// No description provided for @fpCooldown.
  ///
  /// In en, this message translates to:
  /// **'Resend Link in {a}s'**
  String fpCooldown(String a);

  /// No description provided for @fpSend.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get fpSend;

  /// No description provided for @plOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the payment page.'**
  String get plOpenFailed;

  /// No description provided for @plReauth.
  ///
  /// In en, this message translates to:
  /// **'For security, please sign out and sign back in, then try again.'**
  String get plReauth;

  /// No description provided for @plGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get plGeneric;

  /// No description provided for @plBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get plBack;

  /// No description provided for @plTitle.
  ///
  /// In en, this message translates to:
  /// **'Plans & Billing'**
  String get plTitle;

  /// No description provided for @plNoOrg.
  ///
  /// In en, this message translates to:
  /// **'Select an organization to see its plan.'**
  String get plNoOrg;

  /// No description provided for @plIntro.
  ///
  /// In en, this message translates to:
  /// **'Plans apply to {a}. Voters never pay and are never blocked from voting. Ads never appear on ballot, receipt, verification or admin screens.'**
  String plIntro(String a);

  /// No description provided for @plOwnerOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the organization owner can change the plan.'**
  String get plOwnerOnly;

  /// No description provided for @plSoon.
  ///
  /// In en, this message translates to:
  /// **'Online upgrade coming soon'**
  String get plSoon;

  /// No description provided for @plOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening…'**
  String get plOpening;

  /// No description provided for @plUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get plUpgrade;

  /// No description provided for @plManage.
  ///
  /// In en, this message translates to:
  /// **'Manage or cancel subscription'**
  String get plManage;

  /// No description provided for @plContact.
  ///
  /// In en, this message translates to:
  /// **'Contact sales'**
  String get plContact;

  /// No description provided for @plCurrent.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get plCurrent;

  /// No description provided for @spLogo.
  ///
  /// In en, this message translates to:
  /// **'Kivora Logo'**
  String get spLogo;

  /// No description provided for @spTag.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Multi-Tenant E-Voting'**
  String get spTag;

  /// No description provided for @spBadge.
  ///
  /// In en, this message translates to:
  /// **'Server-Authorized & Tenant-Isolated'**
  String get spBadge;

  /// No description provided for @spInit.
  ///
  /// In en, this message translates to:
  /// **'Initializing secure session...'**
  String get spInit;

  /// No description provided for @spErrTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get spErrTitle;

  /// No description provided for @spErrBody.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to Kivora services.'**
  String get spErrBody;

  /// No description provided for @spRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get spRetry;

  /// No description provided for @sclProfile.
  ///
  /// In en, this message translates to:
  /// **'Complete organization profile'**
  String get sclProfile;

  /// No description provided for @sclMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get sclMembers;

  /// No description provided for @sclDepts.
  ///
  /// In en, this message translates to:
  /// **'Set up departments'**
  String get sclDepts;

  /// No description provided for @sclFirst.
  ///
  /// In en, this message translates to:
  /// **'Create your first voting event'**
  String get sclFirst;

  /// No description provided for @sclTitle.
  ///
  /// In en, this message translates to:
  /// **'Get your organization ready'**
  String get sclTitle;

  /// No description provided for @sclDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get sclDismiss;

  /// No description provided for @sclProgress.
  ///
  /// In en, this message translates to:
  /// **'{a} of {b} completed'**
  String sclProgress(String a, String b);

  /// No description provided for @trS1Title.
  ///
  /// In en, this message translates to:
  /// **'Election Lifecycle'**
  String get trS1Title;

  /// No description provided for @trS1P1.
  ///
  /// In en, this message translates to:
  /// **'Every election moves through a fixed sequence of states, enforced by the server, not the app: Draft → Scheduled → Active → Closed → Archived.'**
  String get trS1P1;

  /// No description provided for @trS1P2.
  ///
  /// In en, this message translates to:
  /// **'An election cannot accept ballots outside the Active state, and the server - not your device\'s clock - decides when that window opens and closes.'**
  String get trS1P2;

  /// No description provided for @trS1P3.
  ///
  /// In en, this message translates to:
  /// **'Draft elections are never visible to anyone except the organization\'s own owners and admins.'**
  String get trS1P3;

  /// No description provided for @trS2Title.
  ///
  /// In en, this message translates to:
  /// **'Voter Eligibility'**
  String get trS2Title;

  /// No description provided for @trS2P1.
  ///
  /// In en, this message translates to:
  /// **'Each election is configured with one eligibility rule: every active member of the organization, a specific list of departments, or a specific list of members.'**
  String get trS2P1;

  /// No description provided for @trS2P2.
  ///
  /// In en, this message translates to:
  /// **'Eligibility is re-checked by the server at the moment you submit a ballot. What the app shows you beforehand (such as a \"Vote Now\" button) is a convenience - it is never the actual authorization check.'**
  String get trS2P2;

  /// No description provided for @trS3Title.
  ///
  /// In en, this message translates to:
  /// **'How a Vote Is Processed'**
  String get trS3Title;

  /// No description provided for @trS3P1.
  ///
  /// In en, this message translates to:
  /// **'Casting a ballot runs as a single atomic server-side transaction: it verifies your session hasn\'t been revoked, confirms you\'re eligible and haven\'t already voted, and records your choice - all or nothing.'**
  String get trS3P1;

  /// No description provided for @trS3P2.
  ///
  /// In en, this message translates to:
  /// **'A duplicate submission (for example, from a retried request after a network error) is rejected by the server rather than counted twice, because each voter\'s participation record for a given election has a fixed, predictable ID that can only be created once.'**
  String get trS3P2;

  /// No description provided for @trS4Title.
  ///
  /// In en, this message translates to:
  /// **'Anonymous vs. Identifiable Voting'**
  String get trS4Title;

  /// No description provided for @trS4P1.
  ///
  /// In en, this message translates to:
  /// **'Anonymous elections: your ballot choice is stored without any field linking it back to your account. The system can confirm you participated (to prevent double-voting) without recording what you chose.'**
  String get trS4P1;

  /// No description provided for @trS4P2.
  ///
  /// In en, this message translates to:
  /// **'Identifiable elections: your choice is recorded against your account. This mode exists for governance contexts that require attributable votes (for example, certain formal resolutions) and is clearly labeled before you vote.'**
  String get trS4P2;

  /// No description provided for @trS4P3.
  ///
  /// In en, this message translates to:
  /// **'An election\'s privacy mode is fixed when it\'s created and shown to you before you ever select a choice.'**
  String get trS4P3;

  /// No description provided for @trS5Title.
  ///
  /// In en, this message translates to:
  /// **'Vote Receipts'**
  String get trS5Title;

  /// No description provided for @trS5P1.
  ///
  /// In en, this message translates to:
  /// **'After voting, you receive a receipt: a receipt ID and a cryptographic hash generated from your ballot record at the moment it was recorded.'**
  String get trS5P1;

  /// No description provided for @trS5P2.
  ///
  /// In en, this message translates to:
  /// **'The receipt confirms your ballot was accepted and exists in the system\'s records. It is not a copy of your ballot choice, and in an anonymous election it cannot be used by anyone - including Kivora administrators - to determine what you selected.'**
  String get trS5P2;

  /// No description provided for @trS6Title.
  ///
  /// In en, this message translates to:
  /// **'What Receipt Verification Does and Does Not Prove'**
  String get trS6Title;

  /// No description provided for @trS6P1.
  ///
  /// In en, this message translates to:
  /// **'Verifying a receipt confirms that a ballot matching that receipt exists in the ledger. That is the full extent of what it proves.'**
  String get trS6P1;

  /// No description provided for @trS6P2.
  ///
  /// In en, this message translates to:
  /// **'It does NOT prove who cast that ballot, what choice was selected, that no other issue occurred elsewhere in the process, or provide independent cryptographic audit of the full tally beyond what is described here. Treat it as a record-existence check, not a formal proof of election integrity.'**
  String get trS6P2;

  /// No description provided for @trS7Title.
  ///
  /// In en, this message translates to:
  /// **'When Results Become Available'**
  String get trS7Title;

  /// No description provided for @trS7P1.
  ///
  /// In en, this message translates to:
  /// **'Results are calculated after an election closes, and are only visible to ordinary members once an organization admin explicitly publishes them.'**
  String get trS7P1;

  /// No description provided for @trS7P2.
  ///
  /// In en, this message translates to:
  /// **'Organization owners and admins may review computed results before publishing, in order to catch configuration problems - this is a normal part of the workflow, not evidence of hidden tallies.'**
  String get trS7P2;

  /// No description provided for @trS8Title.
  ///
  /// In en, this message translates to:
  /// **'Administrative Accountability'**
  String get trS8Title;

  /// No description provided for @trS8P1.
  ///
  /// In en, this message translates to:
  /// **'Sensitive administrative actions - publishing or closing an election, changing a member\'s role, granting Observer access, and similar actions - are written to an organization-scoped audit log, visible to that organization\'s owners and admins.'**
  String get trS8P1;

  /// No description provided for @trS8P2.
  ///
  /// In en, this message translates to:
  /// **'This is an operational log for the organization\'s own oversight, not a public, tamper-proof ledger - see \"Known Limitations\" below.'**
  String get trS8P2;

  /// No description provided for @trS9Title.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data Handling'**
  String get trS9Title;

  /// No description provided for @trS9P1.
  ///
  /// In en, this message translates to:
  /// **'Each organization\'s data is isolated from every other organization at the server level; membership in one organization never grants visibility into another\'s elections, members, or results.'**
  String get trS9P1;

  /// No description provided for @trS9P2.
  ///
  /// In en, this message translates to:
  /// **'Observers (a limited, admin-granted capability) see only organization-wide aggregate turnout numbers for active elections and published results - never individual ballots, voter identities, or small-group breakdowns that could reveal how a specific person or small group voted.'**
  String get trS9P2;

  /// No description provided for @trS9P3.
  ///
  /// In en, this message translates to:
  /// **'On the Free plan, mobile app users may see banner ads on browsing screens (home, organizations, calendar, published results). Ads are served by a third-party ad network that may collect device identifiers according to your consent choices. Ads never appear on the ballot, receipt, receipt-verification, transparency or admin screens, and ad networks never receive your vote, your choice, or your receipt.'**
  String get trS9P3;

  /// No description provided for @trS10Title.
  ///
  /// In en, this message translates to:
  /// **'Known Limitations'**
  String get trS10Title;

  /// No description provided for @trS10P1.
  ///
  /// In en, this message translates to:
  /// **'Audit logs are ordinary database records, not a cryptographically tamper-evident ledger - they describe operational history, not mathematical proof against retroactive modification.'**
  String get trS10P1;

  /// No description provided for @trS10P2.
  ///
  /// In en, this message translates to:
  /// **'Kivora is not independently certified by any national or third-party election-standards body, and receipt verification is not a substitute for an independent cryptographic audit of the full tally.'**
  String get trS10P2;

  /// No description provided for @trS10P3.
  ///
  /// In en, this message translates to:
  /// **'Some interface languages are provided via machine-assisted translation pending native-speaker review - see Settings → Preferences → Language.'**
  String get trS10P3;

  /// No description provided for @trTitle.
  ///
  /// In en, this message translates to:
  /// **'Trust & Transparency Center'**
  String get trTitle;

  /// No description provided for @trHeading.
  ///
  /// In en, this message translates to:
  /// **'How Kivora elections work'**
  String get trHeading;

  /// No description provided for @trIntro.
  ///
  /// In en, this message translates to:
  /// **'A plain-language explanation of what actually happens behind every election, written to match the real implementation - including its honest limitations.'**
  String get trIntro;

  /// No description provided for @trVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify a receipt'**
  String get trVerify;

  /// No description provided for @lcF1T.
  ///
  /// In en, this message translates to:
  /// **'Organization management'**
  String get lcF1T;

  /// No description provided for @lcF1B.
  ///
  /// In en, this message translates to:
  /// **'Manage members, roles, departments, invitations and joining codes in one place.'**
  String get lcF1B;

  /// No description provided for @lcF2T.
  ///
  /// In en, this message translates to:
  /// **'Elections and polls'**
  String get lcF2T;

  /// No description provided for @lcF2B.
  ///
  /// In en, this message translates to:
  /// **'Run candidate elections, single-choice polls and yes/no polls with a fixed lifecycle: Draft, Scheduled, Active, Closed, Archived.'**
  String get lcF2B;

  /// No description provided for @lcF3T.
  ///
  /// In en, this message translates to:
  /// **'Anonymous or identifiable'**
  String get lcF3T;

  /// No description provided for @lcF3B.
  ///
  /// In en, this message translates to:
  /// **'Choose the privacy mode when you create a vote. It is shown to members on the ballot, before they choose.'**
  String get lcF3B;

  /// No description provided for @lcF4T.
  ///
  /// In en, this message translates to:
  /// **'Eligibility you control'**
  String get lcF4T;

  /// No description provided for @lcF4B.
  ///
  /// In en, this message translates to:
  /// **'Open a vote to all active members, to selected departments, or to selected members. The server re-checks it when a ballot is submitted.'**
  String get lcF4B;

  /// No description provided for @lcF5T.
  ///
  /// In en, this message translates to:
  /// **'Reviewable history'**
  String get lcF5T;

  /// No description provided for @lcF5B.
  ///
  /// In en, this message translates to:
  /// **'Owners and admins can review a server-side record of key administrative and election actions.'**
  String get lcF5B;

  /// No description provided for @lcF6T.
  ///
  /// In en, this message translates to:
  /// **'Receipt verification'**
  String get lcF6T;

  /// No description provided for @lcF6B.
  ///
  /// In en, this message translates to:
  /// **'After voting you get a receipt. Anyone can check that a receipt exists, without an account.'**
  String get lcF6B;

  /// No description provided for @lcS1T.
  ///
  /// In en, this message translates to:
  /// **'Create your organization'**
  String get lcS1T;

  /// No description provided for @lcS1B.
  ///
  /// In en, this message translates to:
  /// **'Sign up, then create an organization and invite the people who belong to it.'**
  String get lcS1B;

  /// No description provided for @lcS2T.
  ///
  /// In en, this message translates to:
  /// **'Set up a vote'**
  String get lcS2T;

  /// No description provided for @lcS2B.
  ///
  /// In en, this message translates to:
  /// **'Choose the question, schedule, choices, eligibility and privacy mode.'**
  String get lcS2B;

  /// No description provided for @lcS3T.
  ///
  /// In en, this message translates to:
  /// **'Members take part'**
  String get lcS3T;

  /// No description provided for @lcS3B.
  ///
  /// In en, this message translates to:
  /// **'Eligible members get a simple route to the ballot while the vote is open.'**
  String get lcS3B;

  /// No description provided for @lcS4T.
  ///
  /// In en, this message translates to:
  /// **'Review the outcome'**
  String get lcS4T;

  /// No description provided for @lcS4B.
  ///
  /// In en, this message translates to:
  /// **'Results are calculated after the vote closes and shown to members once an admin publishes them.'**
  String get lcS4B;

  /// No description provided for @lcO1T.
  ///
  /// In en, this message translates to:
  /// **'Academic institutions'**
  String get lcO1T;

  /// No description provided for @lcO1B.
  ///
  /// In en, this message translates to:
  /// **'Departments, councils and committees.'**
  String get lcO1B;

  /// No description provided for @lcO2T.
  ///
  /// In en, this message translates to:
  /// **'Corporate teams'**
  String get lcO2T;

  /// No description provided for @lcO2B.
  ///
  /// In en, this message translates to:
  /// **'Internal polls and elections.'**
  String get lcO2B;

  /// No description provided for @lcO3T.
  ///
  /// In en, this message translates to:
  /// **'Non-profits'**
  String get lcO3T;

  /// No description provided for @lcO3B.
  ///
  /// In en, this message translates to:
  /// **'Boards, volunteers and members.'**
  String get lcO3B;

  /// No description provided for @lcO4T.
  ///
  /// In en, this message translates to:
  /// **'Clubs and societies'**
  String get lcO4T;

  /// No description provided for @lcO4B.
  ///
  /// In en, this message translates to:
  /// **'Student societies and clubs.'**
  String get lcO4B;

  /// No description provided for @lcO5T.
  ///
  /// In en, this message translates to:
  /// **'Community associations'**
  String get lcO5T;

  /// No description provided for @lcO5B.
  ///
  /// In en, this message translates to:
  /// **'Shared local decisions.'**
  String get lcO5B;

  /// No description provided for @lcT1T.
  ///
  /// In en, this message translates to:
  /// **'Two-step sign-in'**
  String get lcT1T;

  /// No description provided for @lcT1B.
  ///
  /// In en, this message translates to:
  /// **'Sensitive administrative actions require two-step verification.'**
  String get lcT1B;

  /// No description provided for @lcT2T.
  ///
  /// In en, this message translates to:
  /// **'Privacy is a choice'**
  String get lcT2T;

  /// No description provided for @lcT2B.
  ///
  /// In en, this message translates to:
  /// **'Anonymous voting stores the choice without a field linking it to your account.'**
  String get lcT2B;

  /// No description provided for @lcT3T.
  ///
  /// In en, this message translates to:
  /// **'Server-checked rules'**
  String get lcT3T;

  /// No description provided for @lcT3B.
  ///
  /// In en, this message translates to:
  /// **'Eligibility, timing and duplicate votes are enforced by the server, not the app.'**
  String get lcT3B;

  /// No description provided for @lcY1T.
  ///
  /// In en, this message translates to:
  /// **'Two-step verification'**
  String get lcY1T;

  /// No description provided for @lcY1B.
  ///
  /// In en, this message translates to:
  /// **'Sensitive administrative actions need a recent sign-in and two-step verification.'**
  String get lcY1B;

  /// No description provided for @lcY2T.
  ///
  /// In en, this message translates to:
  /// **'Privacy is a choice'**
  String get lcY2T;

  /// No description provided for @lcY2B.
  ///
  /// In en, this message translates to:
  /// **'Turn on anonymous voting when a decision calls for it. The mode is visible on the ballot.'**
  String get lcY2B;

  /// No description provided for @lcY3T.
  ///
  /// In en, this message translates to:
  /// **'The server decides'**
  String get lcY3T;

  /// No description provided for @lcY3B.
  ///
  /// In en, this message translates to:
  /// **'Voting windows, eligibility and one-vote-per-person are checked on the server at submission.'**
  String get lcY3B;

  /// No description provided for @lcY4T.
  ///
  /// In en, this message translates to:
  /// **'Reviewable records'**
  String get lcY4T;

  /// No description provided for @lcY4B.
  ///
  /// In en, this message translates to:
  /// **'Key administrative actions are recorded so owners and admins can review them.'**
  String get lcY4B;

  /// No description provided for @lcQ1T.
  ///
  /// In en, this message translates to:
  /// **'What can we use Kivora for?'**
  String get lcQ1T;

  /// No description provided for @lcQ1B.
  ///
  /// In en, this message translates to:
  /// **'Candidate elections, single-choice polls and yes/no polls for your organization, such as representative choices, committee decisions and member questions.'**
  String get lcQ1B;

  /// No description provided for @lcQ2T.
  ///
  /// In en, this message translates to:
  /// **'Who is allowed to vote?'**
  String get lcQ2T;

  /// No description provided for @lcQ2B.
  ///
  /// In en, this message translates to:
  /// **'The organizer sets one eligibility rule per vote: all active members, selected departments, or selected members. The server checks it again when you submit your ballot.'**
  String get lcQ2B;

  /// No description provided for @lcQ3T.
  ///
  /// In en, this message translates to:
  /// **'Can a ballot be anonymous?'**
  String get lcQ3T;

  /// No description provided for @lcQ3B.
  ///
  /// In en, this message translates to:
  /// **'Yes, it is optional. In an anonymous vote your choice is stored without a field linking it to your account, while a separate participation record prevents voting twice. The mode is fixed when the vote is created and shown before you choose.'**
  String get lcQ3B;

  /// No description provided for @lcQ4T.
  ///
  /// In en, this message translates to:
  /// **'How do I check my vote receipt?'**
  String get lcQ4T;

  /// No description provided for @lcQ4B.
  ///
  /// In en, this message translates to:
  /// **'Open Verify a receipt, paste your receipt hash and check it. The receipt confirms that a ballot with that receipt exists. It does not show your choice, who voted, or prove anything about the rest of the process.'**
  String get lcQ4B;

  /// No description provided for @lcQ5T.
  ///
  /// In en, this message translates to:
  /// **'What does the history show?'**
  String get lcQ5T;

  /// No description provided for @lcQ5B.
  ///
  /// In en, this message translates to:
  /// **'Owners and admins can review a server-side record of key administrative and election actions for their organization.'**
  String get lcQ5B;

  /// No description provided for @lcQ6T.
  ///
  /// In en, this message translates to:
  /// **'When can members see results?'**
  String get lcQ6T;

  /// No description provided for @lcQ6B.
  ///
  /// In en, this message translates to:
  /// **'Results are calculated after a vote closes. Ordinary members see them once an organization admin publishes them.'**
  String get lcQ6B;

  /// No description provided for @ldCandA.
  ///
  /// In en, this message translates to:
  /// **'Candidate A'**
  String get ldCandA;

  /// No description provided for @ldCandB.
  ///
  /// In en, this message translates to:
  /// **'Candidate B'**
  String get ldCandB;

  /// No description provided for @ldCandC.
  ///
  /// In en, this message translates to:
  /// **'Candidate C'**
  String get ldCandC;

  /// No description provided for @ldNavFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get ldNavFeatures;

  /// No description provided for @ldNavHow.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get ldNavHow;

  /// No description provided for @ldNavOrgs.
  ///
  /// In en, this message translates to:
  /// **'Organizations'**
  String get ldNavOrgs;

  /// No description provided for @ldNavSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & privacy'**
  String get ldNavSecurity;

  /// No description provided for @ldNavTransparency.
  ///
  /// In en, this message translates to:
  /// **'Transparency'**
  String get ldNavTransparency;

  /// No description provided for @ldBrandTop.
  ///
  /// In en, this message translates to:
  /// **'Kivora, back to top'**
  String get ldBrandTop;

  /// No description provided for @ldToLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to light theme'**
  String get ldToLight;

  /// No description provided for @ldToDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get ldToDark;

  /// No description provided for @ldSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get ldSignIn;

  /// No description provided for @ldGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get ldGetStarted;

  /// No description provided for @ldMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get ldMenu;

  /// No description provided for @ldCloseMenu.
  ///
  /// In en, this message translates to:
  /// **'Close menu'**
  String get ldCloseMenu;

  /// No description provided for @ldVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify a receipt'**
  String get ldVerify;

  /// No description provided for @ldHeroBadge.
  ///
  /// In en, this message translates to:
  /// **'Kivora · secure e-voting and polling'**
  String get ldHeroBadge;

  /// No description provided for @ldHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Run fair elections for your organization.'**
  String get ldHeroTitle;

  /// No description provided for @ldHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Hold elections and polls for your members, choose between anonymous and identifiable voting, and let the server enforce eligibility, timing and one vote per person.'**
  String get ldHeroBody;

  /// No description provided for @ldHaveCode.
  ///
  /// In en, this message translates to:
  /// **'Have a joining code or invitation?  '**
  String get ldHaveCode;

  /// No description provided for @ldCreateToJoin.
  ///
  /// In en, this message translates to:
  /// **'Create an account to join'**
  String get ldCreateToJoin;

  /// No description provided for @ldFeaturesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Built for collective decisions'**
  String get ldFeaturesEyebrow;

  /// No description provided for @ldFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'One place to vote and to manage who can.'**
  String get ldFeaturesTitle;

  /// No description provided for @ldFeaturesBody.
  ///
  /// In en, this message translates to:
  /// **'From choosing representatives to settling a yes/no question, every vote has a clear home.'**
  String get ldFeaturesBody;

  /// No description provided for @ldHowTitle.
  ///
  /// In en, this message translates to:
  /// **'A clear path from setup to result.'**
  String get ldHowTitle;

  /// No description provided for @ldHowBody.
  ///
  /// In en, this message translates to:
  /// **'Make participation straightforward for organizers and members alike.'**
  String get ldHowBody;

  /// No description provided for @ldStart.
  ///
  /// In en, this message translates to:
  /// **'Start with Kivora'**
  String get ldStart;

  /// No description provided for @ldOrgsEyebrow.
  ///
  /// In en, this message translates to:
  /// **'For every kind of organization'**
  String get ldOrgsEyebrow;

  /// No description provided for @ldOrgsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your community, represented.'**
  String get ldOrgsTitle;

  /// No description provided for @ldOrgsBody.
  ///
  /// In en, this message translates to:
  /// **'Kivora organizations are set up as one of these types, then shaped around the people who take part.'**
  String get ldOrgsBody;

  /// No description provided for @ldSecTitle.
  ///
  /// In en, this message translates to:
  /// **'Trust built into every step.'**
  String get ldSecTitle;

  /// No description provided for @ldSecBody.
  ///
  /// In en, this message translates to:
  /// **'The rules that matter run on the server, and the voting mode is visible to members before they choose.'**
  String get ldSecBody;

  /// No description provided for @ldExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore transparency'**
  String get ldExplore;

  /// No description provided for @ldPartRecord.
  ///
  /// In en, this message translates to:
  /// **'Participation record'**
  String get ldPartRecord;

  /// No description provided for @ldPartBody.
  ///
  /// In en, this message translates to:
  /// **'Records that an eligible member voted, so nobody can vote twice. It does not hold the choice in an anonymous vote.'**
  String get ldPartBody;

  /// No description provided for @ldBallotRecord.
  ///
  /// In en, this message translates to:
  /// **'Ballot record'**
  String get ldBallotRecord;

  /// No description provided for @ldBallotBody.
  ///
  /// In en, this message translates to:
  /// **'Holds the choice. In an anonymous vote it has no field linking it to the voter\'s account.'**
  String get ldBallotBody;

  /// No description provided for @ldAnonEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Anonymous voting'**
  String get ldAnonEyebrow;

  /// No description provided for @ldAnonTitle.
  ///
  /// In en, this message translates to:
  /// **'Participation is recorded. Ballots stay separate.'**
  String get ldAnonTitle;

  /// No description provided for @ldAnonBody.
  ///
  /// In en, this message translates to:
  /// **'Two separate records let Kivora prevent double voting while keeping an anonymous choice anonymous.'**
  String get ldAnonBody;

  /// No description provided for @ldReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Check a receipt without an account.'**
  String get ldReceiptTitle;

  /// No description provided for @ldReceiptBody.
  ///
  /// In en, this message translates to:
  /// **'Paste a receipt hash to confirm that a ballot with that receipt exists. It does not reveal a choice or a voter, and it is a record-existence check, not a formal proof of the whole process.'**
  String get ldReceiptBody;

  /// No description provided for @ldFaqEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get ldFaqEyebrow;

  /// No description provided for @ldFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Good decisions start with clear answers.'**
  String get ldFaqTitle;

  /// No description provided for @ldCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Make your next decision count.'**
  String get ldCtaTitle;

  /// No description provided for @ldCtaBody.
  ///
  /// In en, this message translates to:
  /// **'Give every member a clear, secure way to be heard.'**
  String get ldCtaBody;

  /// No description provided for @ldFooterTag.
  ///
  /// In en, this message translates to:
  /// **'Secure e-voting and polling for organizations.'**
  String get ldFooterTag;

  /// No description provided for @ldFooterProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get ldFooterProduct;

  /// No description provided for @ldFooterTrust.
  ///
  /// In en, this message translates to:
  /// **'Trust'**
  String get ldFooterTrust;

  /// No description provided for @ldFooterAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get ldFooterAccount;

  /// No description provided for @ldFooterCreate.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get ldFooterCreate;

  /// No description provided for @ldFooterFaq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get ldFooterFaq;

  /// No description provided for @ldCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Sonryan. All rights reserved.'**
  String get ldCopyright;

  /// No description provided for @ldBackTop.
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get ldBackTop;

  /// No description provided for @ldIllus.
  ///
  /// In en, this message translates to:
  /// **'Illustration, not a live election'**
  String get ldIllus;

  /// No description provided for @ldSample.
  ///
  /// In en, this message translates to:
  /// **'Sample ballot'**
  String get ldSample;

  /// No description provided for @ldChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose one candidate.'**
  String get ldChoose;

  /// No description provided for @ldSampleCands.
  ///
  /// In en, this message translates to:
  /// **'Sample candidates'**
  String get ldSampleCands;

  /// No description provided for @ldAnonBallot.
  ///
  /// In en, this message translates to:
  /// **'Anonymous ballot'**
  String get ldAnonBallot;

  /// No description provided for @ldSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit vote'**
  String get ldSubmit;

  /// No description provided for @ldTry.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a candidate. This is a preview only.'**
  String get ldTry;

  /// No description provided for @ldPicked.
  ///
  /// In en, this message translates to:
  /// **'You picked {a} in this preview. Nothing is submitted.'**
  String ldPicked(String a);

  /// No description provided for @ldHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Still need a hand?'**
  String get ldHelpTitle;

  /// No description provided for @ldHelpBody.
  ///
  /// In en, this message translates to:
  /// **'For access or eligibility questions, ask your organization administrator. To see how elections work end to end, read the Transparency Center.'**
  String get ldHelpBody;

  /// No description provided for @ldHelpOpen.
  ///
  /// In en, this message translates to:
  /// **'Open the Transparency Center'**
  String get ldHelpOpen;

  /// No description provided for @obSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get obSkip;

  /// No description provided for @obYourOrg.
  ///
  /// In en, this message translates to:
  /// **'Your organization'**
  String get obYourOrg;

  /// No description provided for @obCreate.
  ///
  /// In en, this message translates to:
  /// **'Create an organization'**
  String get obCreate;

  /// No description provided for @obCreateSub.
  ///
  /// In en, this message translates to:
  /// **'Start a space for your community'**
  String get obCreateSub;

  /// No description provided for @obJoin.
  ///
  /// In en, this message translates to:
  /// **'Join an organization'**
  String get obJoin;

  /// No description provided for @obJoinSub.
  ///
  /// In en, this message translates to:
  /// **'Use your code or invitation'**
  String get obJoinSub;

  /// No description provided for @obInviteNote.
  ///
  /// In en, this message translates to:
  /// **'An invitation brings you right in.'**
  String get obInviteNote;

  /// No description provided for @obTag1.
  ///
  /// In en, this message translates to:
  /// **'YOUR COMMUNITY, CONNECTED'**
  String get obTag1;

  /// No description provided for @obTitle1.
  ///
  /// In en, this message translates to:
  /// **'Create or join\nan organization'**
  String get obTitle1;

  /// No description provided for @obBody1.
  ///
  /// In en, this message translates to:
  /// **'Bring your people together. Create a home for your elections and polls, or join with an invitation code.'**
  String get obBody1;

  /// No description provided for @obCallout1.
  ///
  /// In en, this message translates to:
  /// **'One home for shared decisions'**
  String get obCallout1;

  /// No description provided for @obCallout1b.
  ///
  /// In en, this message translates to:
  /// **'Connect your members, elections and polls in one organization.'**
  String get obCallout1b;

  /// No description provided for @obNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get obNext;

  /// No description provided for @obExample.
  ///
  /// In en, this message translates to:
  /// **'EXAMPLE BALLOT'**
  String get obExample;

  /// No description provided for @obStudent.
  ///
  /// In en, this message translates to:
  /// **'Student council 2026'**
  String get obStudent;

  /// No description provided for @obPresident.
  ///
  /// In en, this message translates to:
  /// **'President · Choose one candidate'**
  String get obPresident;

  /// No description provided for @obAlex.
  ///
  /// In en, this message translates to:
  /// **'Alex Morgan'**
  String get obAlex;

  /// No description provided for @obJordan.
  ///
  /// In en, this message translates to:
  /// **'Jordan Lee'**
  String get obJordan;

  /// No description provided for @obReview.
  ///
  /// In en, this message translates to:
  /// **'Review vote'**
  String get obReview;

  /// No description provided for @obTag2.
  ///
  /// In en, this message translates to:
  /// **'EVERY VOICE MATTERS'**
  String get obTag2;

  /// No description provided for @obTitle2.
  ///
  /// In en, this message translates to:
  /// **'Vote with confidence'**
  String get obTitle2;

  /// No description provided for @obBody2.
  ///
  /// In en, this message translates to:
  /// **'Make your voice count in elections and polls. Review your options, choose, and submit your vote.'**
  String get obBody2;

  /// No description provided for @obCallout2.
  ///
  /// In en, this message translates to:
  /// **'Your choice stays private'**
  String get obCallout2;

  /// No description provided for @obCallout2b.
  ///
  /// In en, this message translates to:
  /// **'Private ballots protect your choices while keeping the process accountable.'**
  String get obCallout2b;

  /// No description provided for @obControls.
  ///
  /// In en, this message translates to:
  /// **'Organization controls'**
  String get obControls;

  /// No description provided for @obCodes.
  ///
  /// In en, this message translates to:
  /// **'Joining codes'**
  String get obCodes;

  /// No description provided for @obCodesSub.
  ///
  /// In en, this message translates to:
  /// **'Create and revoke'**
  String get obCodesSub;

  /// No description provided for @obLog.
  ///
  /// In en, this message translates to:
  /// **'Activity log'**
  String get obLog;

  /// No description provided for @obLogAdded.
  ///
  /// In en, this message translates to:
  /// **'Member added'**
  String get obLogAdded;

  /// No description provided for @obLogElection.
  ///
  /// In en, this message translates to:
  /// **'Election created'**
  String get obLogElection;

  /// No description provided for @obTag3.
  ///
  /// In en, this message translates to:
  /// **'CLEAR RULES. CLEAR RECORDS.'**
  String get obTag3;

  /// No description provided for @obTitle3.
  ///
  /// In en, this message translates to:
  /// **'Stay in control'**
  String get obTitle3;

  /// No description provided for @obBody3.
  ///
  /// In en, this message translates to:
  /// **'Set clear rules for your organization. Manage joining codes and follow important actions in the activity log.'**
  String get obBody3;

  /// No description provided for @obCallout3.
  ///
  /// In en, this message translates to:
  /// **'Private choices. Accountable actions.'**
  String get obCallout3;

  /// No description provided for @obCallout3b.
  ///
  /// In en, this message translates to:
  /// **'Eligibility rules control who can take part. Activity logs keep administrative actions on record.'**
  String get obCallout3b;

  /// No description provided for @obContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get obContinue;

  /// No description provided for @obComm.
  ///
  /// In en, this message translates to:
  /// **'Your community'**
  String get obComm;

  /// No description provided for @obCommSub.
  ///
  /// In en, this message translates to:
  /// **'A shared place to decide'**
  String get obCommSub;

  /// No description provided for @obElections.
  ///
  /// In en, this message translates to:
  /// **'Elections'**
  String get obElections;

  /// No description provided for @obPolls.
  ///
  /// In en, this message translates to:
  /// **'Polls'**
  String get obPolls;

  /// No description provided for @obTag4.
  ///
  /// In en, this message translates to:
  /// **'Better decisions, together.'**
  String get obTag4;

  /// No description provided for @obTitle4.
  ///
  /// In en, this message translates to:
  /// **'Give your organization\na voice.'**
  String get obTitle4;

  /// No description provided for @obBody4.
  ///
  /// In en, this message translates to:
  /// **'Create a home for your elections and polls. Bring your members in, and move forward together with Kivora.'**
  String get obBody4;

  /// No description provided for @obGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get obGetStarted;

  /// No description provided for @obHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get obHaveAccount;

  /// No description provided for @obPage.
  ///
  /// In en, this message translates to:
  /// **'{a} of 3'**
  String obPage(String a);

  /// No description provided for @obBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get obBack;

  /// No description provided for @cfAdd.
  ///
  /// In en, this message translates to:
  /// **'Add candidate'**
  String get cfAdd;

  /// No description provided for @cfEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit candidate'**
  String get cfEdit;

  /// No description provided for @cfClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get cfClose;

  /// No description provided for @cfPhotoSem.
  ///
  /// In en, this message translates to:
  /// **'Choose candidate photo'**
  String get cfPhotoSem;

  /// No description provided for @cfPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo (JPEG, optional)'**
  String get cfPhoto;

  /// No description provided for @cfPhotoChange.
  ///
  /// In en, this message translates to:
  /// **'Choose a different photo'**
  String get cfPhotoChange;

  /// No description provided for @cfName.
  ///
  /// In en, this message translates to:
  /// **'Full name *'**
  String get cfName;

  /// No description provided for @cfNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dr. Sarah Jenkins'**
  String get cfNameHint;

  /// No description provided for @cfNameShort.
  ///
  /// In en, this message translates to:
  /// **'Enter the candidate\'s name (at least 2 characters).'**
  String get cfNameShort;

  /// No description provided for @cf100.
  ///
  /// In en, this message translates to:
  /// **'Use 100 characters or fewer.'**
  String get cf100;

  /// No description provided for @cfParty.
  ///
  /// In en, this message translates to:
  /// **'Party / Affiliation (Optional)'**
  String get cfParty;

  /// No description provided for @cfPartyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Progressive Coalition'**
  String get cfPartyHint;

  /// No description provided for @cfBio.
  ///
  /// In en, this message translates to:
  /// **'Candidate Bio / Vision Statement (Optional)'**
  String get cfBio;

  /// No description provided for @cfBioHint.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of experience and objectives...'**
  String get cfBioHint;

  /// No description provided for @cf1000.
  ///
  /// In en, this message translates to:
  /// **'Use 1,000 characters or fewer.'**
  String get cf1000;

  /// No description provided for @cfCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cfCancel;

  /// No description provided for @cfSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get cfSave;

  /// No description provided for @clRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this candidate?'**
  String get clRemoveTitle;

  /// No description provided for @clRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'{a} will be removed from this election. You can add them again while the election is a draft.'**
  String clRemoveBody(String a);

  /// No description provided for @clKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep candidate'**
  String get clKeep;

  /// No description provided for @clRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get clRemove;

  /// No description provided for @clRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the candidate. Please try again.'**
  String get clRemoveFailed;

  /// No description provided for @clLocked.
  ///
  /// In en, this message translates to:
  /// **'This election is no longer a draft, so its candidates cannot be changed.'**
  String get clLocked;

  /// No description provided for @clLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the candidates.'**
  String get clLoadError;

  /// No description provided for @clRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get clRetry;

  /// No description provided for @clNeedOne.
  ///
  /// In en, this message translates to:
  /// **'Add at least 1 more candidate to publish (minimum {a}).'**
  String clNeedOne(String a);

  /// No description provided for @clNeedMany.
  ///
  /// In en, this message translates to:
  /// **'Add at least {a} more candidates to publish (minimum {b}).'**
  String clNeedMany(String a, String b);

  /// No description provided for @clCount.
  ///
  /// In en, this message translates to:
  /// **'{a} candidates added.'**
  String clCount(String a);

  /// No description provided for @clNone.
  ///
  /// In en, this message translates to:
  /// **'No candidates added yet.'**
  String get clNone;

  /// No description provided for @clIndependent.
  ///
  /// In en, this message translates to:
  /// **'Independent / no affiliation'**
  String get clIndependent;

  /// No description provided for @clEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit {a}'**
  String clEdit(String a);

  /// No description provided for @clRemoveName.
  ///
  /// In en, this message translates to:
  /// **'Remove {a}'**
  String clRemoveName(String a);

  /// No description provided for @clAdd.
  ///
  /// In en, this message translates to:
  /// **'Add candidate'**
  String get clAdd;

  /// No description provided for @pfAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Poll Option'**
  String get pfAddTitle;

  /// No description provided for @pfEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Poll Option'**
  String get pfEditTitle;

  /// No description provided for @pfLabel.
  ///
  /// In en, this message translates to:
  /// **'Option Label *'**
  String get pfLabel;

  /// No description provided for @pfLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Approve Proposal A'**
  String get pfLabelHint;

  /// No description provided for @pfLabelRequired.
  ///
  /// In en, this message translates to:
  /// **'Label is required'**
  String get pfLabelRequired;

  /// No description provided for @pfDesc.
  ///
  /// In en, this message translates to:
  /// **'Option Description (Optional)'**
  String get pfDesc;

  /// No description provided for @pfDescHint.
  ///
  /// In en, this message translates to:
  /// **'Provide additional details for voters...'**
  String get pfDescHint;

  /// No description provided for @pfCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pfCancel;

  /// No description provided for @pfAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get pfAdd;

  /// No description provided for @pfSave.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get pfSave;

  /// No description provided for @plsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get plsAdd;

  /// No description provided for @plsLoadError.
  ///
  /// In en, this message translates to:
  /// **'We could not load the options.'**
  String get plsLoadError;

  /// No description provided for @plsRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get plsRetry;

  /// No description provided for @plsNone.
  ///
  /// In en, this message translates to:
  /// **'No options added yet. Add at least {a} to publish.'**
  String plsNone(String a);

  /// No description provided for @plsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Option?'**
  String get plsDeleteTitle;

  /// No description provided for @plsDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {a}?'**
  String plsDeleteBody(String a);

  /// No description provided for @plsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get plsCancel;

  /// No description provided for @plsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get plsDelete;

  /// No description provided for @plsRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the option. Please try again.'**
  String get plsRemoveFailed;

  /// No description provided for @chRoster.
  ///
  /// In en, this message translates to:
  /// **'Candidate Roster'**
  String get chRoster;

  /// No description provided for @chYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes/No Options'**
  String get chYesNo;

  /// No description provided for @chPoll.
  ///
  /// In en, this message translates to:
  /// **'Poll Options'**
  String get chPoll;

  /// No description provided for @chBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get chBack;

  /// No description provided for @chNext.
  ///
  /// In en, this message translates to:
  /// **'Next: Review'**
  String get chNext;

  /// No description provided for @chYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get chYes;

  /// No description provided for @chNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get chNo;

  /// No description provided for @chSystem.
  ///
  /// In en, this message translates to:
  /// **'System-generated option'**
  String get chSystem;

  /// No description provided for @ciTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk Import Voters'**
  String get ciTitle;

  /// No description provided for @ciBody.
  ///
  /// In en, this message translates to:
  /// **'Paste CSV data or a list of email addresses below. Emails will be automatically validated against active organization members.'**
  String get ciBody;

  /// No description provided for @ciLabel.
  ///
  /// In en, this message translates to:
  /// **'CSV Content / Email List'**
  String get ciLabel;

  /// No description provided for @ciHint.
  ///
  /// In en, this message translates to:
  /// **'john@example.com, jane@organization.org\nmark@company.com'**
  String get ciHint;

  /// No description provided for @ciParse.
  ///
  /// In en, this message translates to:
  /// **'Parse & Validate'**
  String get ciParse;

  /// No description provided for @ciResults.
  ///
  /// In en, this message translates to:
  /// **'Validation Results'**
  String get ciResults;

  /// No description provided for @ciMatched.
  ///
  /// In en, this message translates to:
  /// **'{a} members matched and eligible'**
  String ciMatched(String a);

  /// No description provided for @ciUnmatched.
  ///
  /// In en, this message translates to:
  /// **'{a} emails not found in workspace directory'**
  String ciUnmatched(String a);

  /// No description provided for @ciReedit.
  ///
  /// In en, this message translates to:
  /// **'Re-edit List'**
  String get ciReedit;

  /// No description provided for @ciApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Selection ({a})'**
  String ciApply(String a);

  /// No description provided for @cdCreated.
  ///
  /// In en, this message translates to:
  /// **'Department created successfully.'**
  String get cdCreated;

  /// No description provided for @cdUpdated.
  ///
  /// In en, this message translates to:
  /// **'Department updated successfully.'**
  String get cdUpdated;

  /// No description provided for @cdEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Department'**
  String get cdEditTitle;

  /// No description provided for @cdCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Department'**
  String get cdCreateTitle;

  /// No description provided for @cdName.
  ///
  /// In en, this message translates to:
  /// **'Department Name *'**
  String get cdName;

  /// No description provided for @cdNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Computer Science'**
  String get cdNameHint;

  /// No description provided for @cdNameField.
  ///
  /// In en, this message translates to:
  /// **'Department Name'**
  String get cdNameField;

  /// No description provided for @cdNameShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get cdNameShort;

  /// No description provided for @cdNameLong.
  ///
  /// In en, this message translates to:
  /// **'Name cannot exceed 50 characters'**
  String get cdNameLong;

  /// No description provided for @cdDesc.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get cdDesc;

  /// No description provided for @cdDescHint.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of the department...'**
  String get cdDescHint;

  /// No description provided for @cdCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cdCancel;

  /// No description provided for @cdUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get cdUpdate;

  /// No description provided for @cdCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get cdCreate;

  /// No description provided for @teReason.
  ///
  /// In en, this message translates to:
  /// **'Enrolling two-factor authentication requires you to have signed in recently. Please verify your identity to continue.'**
  String get teReason;

  /// No description provided for @teStartFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start two-factor enrollment. Please try again.'**
  String get teStartFailed;

  /// No description provided for @teEnter6.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your app.'**
  String get teEnter6;

  /// No description provided for @teBadCode.
  ///
  /// In en, this message translates to:
  /// **'That code is incorrect or expired. Try the latest code from your app.'**
  String get teBadCode;

  /// No description provided for @teVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify that code.'**
  String get teVerifyFailed;

  /// No description provided for @teTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up two-factor authentication'**
  String get teTitle;

  /// No description provided for @teStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Scan this QR code with an authenticator app (Google Authenticator, Authy, 1Password, etc.).'**
  String get teStep1;

  /// No description provided for @teManual.
  ///
  /// In en, this message translates to:
  /// **'Can\'t scan? Enter this key manually:'**
  String get teManual;

  /// No description provided for @teStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Enter the 6-digit code it generates:'**
  String get teStep2;

  /// No description provided for @teCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get teCode;

  /// No description provided for @teCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get teCancel;

  /// No description provided for @teEnable.
  ///
  /// In en, this message translates to:
  /// **'Enable 2FA'**
  String get teEnable;

  /// No description provided for @tcEnter6.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your app.'**
  String get tcEnter6;

  /// No description provided for @tcBadCode.
  ///
  /// In en, this message translates to:
  /// **'That code is incorrect or expired. Try the latest code from your app.'**
  String get tcBadCode;

  /// No description provided for @tcVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify that code.'**
  String get tcVerifyFailed;

  /// No description provided for @tcTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-factor verification'**
  String get tcTitle;

  /// No description provided for @tcBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app to finish signing in.'**
  String get tcBody;

  /// No description provided for @tcCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get tcCode;

  /// No description provided for @tcCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tcCancel;

  /// No description provided for @tcVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get tcVerify;

  /// No description provided for @slPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to continue.'**
  String get slPassword;

  /// No description provided for @slWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get slWelcome;

  /// No description provided for @slVerifyAs.
  ///
  /// In en, this message translates to:
  /// **'For your security, please verify it\'s you to continue as {a}.'**
  String slVerifyAs(String a);

  /// No description provided for @slVerify.
  ///
  /// In en, this message translates to:
  /// **'For your security, please verify it\'s you to continue.'**
  String get slVerify;

  /// No description provided for @slPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get slPasswordLabel;

  /// No description provided for @slGoogle.
  ///
  /// In en, this message translates to:
  /// **'Verify with Google'**
  String get slGoogle;

  /// No description provided for @slVerifyBtn.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get slVerifyBtn;

  /// No description provided for @slSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out instead'**
  String get slSignOut;

  /// No description provided for @raReason.
  ///
  /// In en, this message translates to:
  /// **'For security, this action requires you to have signed in within the last 15 minutes. Please verify your identity to continue.'**
  String get raReason;

  /// No description provided for @raTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify it\'s you'**
  String get raTitle;

  /// No description provided for @raPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get raPassword;

  /// No description provided for @raCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get raCancel;

  /// No description provided for @raGoogle.
  ///
  /// In en, this message translates to:
  /// **'Verify with Google'**
  String get raGoogle;

  /// No description provided for @raVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get raVerify;

  /// No description provided for @phTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform health'**
  String get phTitle;

  /// No description provided for @phSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live checks for the platform API and Firestore.'**
  String get phSubtitle;

  /// No description provided for @phRun.
  ///
  /// In en, this message translates to:
  /// **'Run checks'**
  String get phRun;

  /// No description provided for @phUnavailTitle.
  ///
  /// In en, this message translates to:
  /// **'Health check unavailable'**
  String get phUnavailTitle;

  /// No description provided for @phUnavailBody.
  ///
  /// In en, this message translates to:
  /// **'The platform health endpoint did not respond. Retry to check it again.'**
  String get phUnavailBody;

  /// No description provided for @phOkTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified services are responding'**
  String get phOkTitle;

  /// No description provided for @phBadTitle.
  ///
  /// In en, this message translates to:
  /// **'A service needs attention'**
  String get phBadTitle;

  /// No description provided for @phFunctions.
  ///
  /// In en, this message translates to:
  /// **'Cloud Functions'**
  String get phFunctions;

  /// No description provided for @phFunctionsOk.
  ///
  /// In en, this message translates to:
  /// **'This health request completed successfully.'**
  String get phFunctionsOk;

  /// No description provided for @phFirestore.
  ///
  /// In en, this message translates to:
  /// **'Firestore'**
  String get phFirestore;

  /// No description provided for @phProbeFailed.
  ///
  /// In en, this message translates to:
  /// **'The read probe failed. No application data was returned.'**
  String get phProbeFailed;

  /// No description provided for @phCoverage.
  ///
  /// In en, this message translates to:
  /// **'Monitoring coverage'**
  String get phCoverage;

  /// No description provided for @phCoverageBody.
  ///
  /// In en, this message translates to:
  /// **'Storage, email delivery, push delivery, and client devices are not probed by this check.'**
  String get phCoverageBody;

  /// No description provided for @phOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get phOperational;

  /// No description provided for @phDown.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get phDown;

  /// No description provided for @phProbeOk.
  ///
  /// In en, this message translates to:
  /// **'Read probe completed.'**
  String get phProbeOk;

  /// No description provided for @phProbeOkMs.
  ///
  /// In en, this message translates to:
  /// **'Read probe completed in {a}ms.'**
  String phProbeOkMs(String a);

  /// No description provided for @phLast.
  ///
  /// In en, this message translates to:
  /// **'Last checked {a}'**
  String phLast(String a);

  /// No description provided for @ntLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load notifications. Check your connection and try again.'**
  String get ntLoadError;

  /// No description provided for @ntUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update notifications. Try again.'**
  String get ntUpdateFailed;

  /// No description provided for @navPlatformHealth.
  ///
  /// In en, this message translates to:
  /// **'Platform health'**
  String get navPlatformHealth;
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
