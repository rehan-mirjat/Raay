// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kivora';

  @override
  String get navHome => 'Home';

  @override
  String get navOrganizations => 'Organizations';

  @override
  String get navOrgsShort => 'Orgs';

  @override
  String get navEvents => 'Events';

  @override
  String get navDirectory => 'Directory';

  @override
  String get navDepartments => 'Departments';

  @override
  String get navProfile => 'Profile';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navCommandCenter => 'Command Center';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionBack => 'Back';

  @override
  String get actionNext => 'Next';

  @override
  String get actionClose => 'Close';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionSignOut => 'Sign Out';

  @override
  String get authSignInTitle => 'Welcome Back';

  @override
  String get authSignInSubtitle => 'Sign in to continue';

  @override
  String get authEmail => 'Email address';

  @override
  String get authPassword => 'Password';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authSignInButton => 'Sign In Securely';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authRegisterSubtitle => 'Join Kivora today';

  @override
  String get authFullName => 'Full name';

  @override
  String get authConfirmPassword => 'Confirm password';

  @override
  String get voteStepSelect => 'Select';

  @override
  String get voteStepReview => 'Review & Submit';

  @override
  String get voteSelectionPrompt => 'Make your selection';

  @override
  String get voteReviewBallot => 'Review Ballot';

  @override
  String get voteReviewYourBallot => 'Review your ballot';

  @override
  String get voteYourSelection => 'Your selection';

  @override
  String get voteConfirmAndCast => 'Confirm & Cast Ballot';

  @override
  String get voteSubmitting => 'Submitting Ballot...';

  @override
  String get voteAnonymousExplanation =>
      'This ballot is anonymous. Your selection is never linked to your identity in the tally, and cannot be changed after submission.';

  @override
  String get voteIdentifiableExplanation =>
      'This is an identifiable ballot. Your selection will be recorded against your account and cannot be changed after submission.';

  @override
  String get voteAlreadyVotedTitle => 'You Have Already Voted';

  @override
  String voteAlreadyVotedMessage(String eventTitle) {
    return 'Your ballot for \"$eventTitle\" has already been cast and accepted into the anonymous tally.';
  }

  @override
  String get voteViewReceipt => 'View Your Confirmation Receipt';

  @override
  String get voteViewResults => 'View Results';

  @override
  String get voteNotOpenYet =>
      'Voting has not opened yet for this election. You can review the ballot below, but submission is disabled until it becomes active.';

  @override
  String get voteClosed => 'Voting is no longer open for this election.';

  @override
  String get receiptTitle => 'Vote Receipt';

  @override
  String get receiptId => 'Receipt ID';

  @override
  String get receiptHash => 'Receipt Hash';

  @override
  String get receiptCopy => 'Copy';

  @override
  String get receiptReturnHome => 'Return to Home Feed';

  @override
  String get resultsTitle => 'Election Results';

  @override
  String get resultsTotalVotes => 'Total Votes';

  @override
  String get resultsVoterTurnout => 'Voter Turnout';

  @override
  String get resultsTurnoutRate => 'Turnout Rate';

  @override
  String get resultsViewDetailed => 'View Detailed Results';

  @override
  String get myElectionsTitle => 'My Elections';

  @override
  String get myElectionsSubtitle =>
      'Every election you can see across your organizations, in one place.';

  @override
  String get filterAll => 'All';

  @override
  String get filterActive => 'Active';

  @override
  String get filterUpcoming => 'Upcoming';

  @override
  String get filterCompleted => 'Completed';

  @override
  String get filterParticipated => 'Participated';

  @override
  String get filterResultsAvailable => 'Results available';

  @override
  String get calendarTitle => 'Election Calendar';

  @override
  String get calendarAddToCalendar => 'Add to calendar';

  @override
  String get emptyGenericTitle => 'Nothing here yet';

  @override
  String get emptyGenericMessage => 'There\'s nothing to show right now.';

  @override
  String get errorGenericMessage => 'Something went wrong. Please try again.';

  @override
  String get loadingGeneric => 'Loading...';

  @override
  String get accessibilitySettingsTitle => 'Accessibility & Language';

  @override
  String get accessibilityLanguage => 'Language';

  @override
  String get accessibilityLanguageSystem => 'System default';

  @override
  String get accessibilityReducedMotion => 'Reduce motion';

  @override
  String get accessibilityReducedMotionSubtitle =>
      'Minimize animations throughout the app.';

  @override
  String get accessibilityHighContrast => 'High contrast';

  @override
  String get accessibilityHighContrastSubtitle =>
      'Increase text and border contrast for better visibility.';

  @override
  String get helpSupportTitle => 'Help & Support';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get transparencyTitle => 'Trust & Transparency Center';

  @override
  String get observerDashboardTitle => 'Observer Dashboard';
}
