import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Landing page copy. Every claim here is backed by something in this
/// repository (see the comment on each block); nothing is a metric, a
/// testimonial or a guarantee.

class LandingFeature {
  const LandingFeature(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

// Organization screens: members, roles (owner/admin/member), departments,
// invitations and joining codes. Voting events: candidate elections,
// single-choice polls, yes/no polls. Privacy modes: anonymous / identifiable.
// Receipt verifier: public callable. Audit: organization audit log screen.
const landingFeatures = <LandingFeature>[
  LandingFeature(Icons.groups_rounded, 'Organization management',
      'Manage members, roles, departments, invitations and joining codes in one place.'),
  LandingFeature(Icons.how_to_vote_rounded, 'Elections and polls',
      'Run candidate elections, single-choice polls and yes/no polls with a fixed lifecycle: Draft, Scheduled, Active, Closed, Archived.'),
  LandingFeature(Icons.visibility_off_rounded, 'Anonymous or identifiable',
      'Choose the privacy mode when you create a vote. It is shown to members on the ballot, before they choose.'),
  LandingFeature(Icons.rule_rounded, 'Eligibility you control',
      'Open a vote to all active members, to selected departments, or to selected members. The server re-checks it when a ballot is submitted.'),
  LandingFeature(Icons.history_rounded, 'Reviewable history',
      'Owners and admins can review a server-side record of key administrative and election actions.'),
  LandingFeature(Icons.receipt_long_rounded, 'Receipt verification',
      'After voting you get a receipt. Anyone can check that a receipt exists, without an account.'),
];

class LandingStep {
  const LandingStep(this.title, this.body);
  final String title;
  final String body;
}

const landingSteps = <LandingStep>[
  LandingStep('Create your organization',
      'Sign up, then create an organization and invite the people who belong to it.'),
  LandingStep('Set up a vote',
      'Choose the question, schedule, choices, eligibility and privacy mode.'),
  LandingStep('Members take part',
      'Eligible members get a simple route to the ballot while the vote is open.'),
  LandingStep('Review the outcome',
      'Results are calculated after the vote closes and shown to members once an admin publishes them.'),
];

// Organization types offered by the create-organization form.
const landingOrgTypes = <LandingFeature>[
  LandingFeature(Icons.school_rounded, 'Academic institutions',
      'Departments, councils and committees.'),
  LandingFeature(Icons.business_rounded, 'Corporate teams',
      'Internal polls and elections.'),
  LandingFeature(Icons.volunteer_activism_rounded, 'Non-profits',
      'Boards, volunteers and members.'),
  LandingFeature(Icons.diversity_3_rounded, 'Clubs and societies',
      'Student societies and clubs.'),
  LandingFeature(Icons.location_city_rounded, 'Community associations',
      'Shared local decisions.'),
];

// Two-step: TOTP enrollment and requireMfaEnrolled on sensitive admin
// callables. Transparency Center describes the rest.
const landingTrustPoints = <LandingFeature>[
  LandingFeature(Icons.shield_rounded, 'Two-step sign-in',
      'Sensitive administrative actions require two-step verification.'),
  LandingFeature(Icons.lock_rounded, 'Privacy is a choice',
      'Anonymous voting stores the choice without a field linking it to your account.'),
  LandingFeature(Icons.fact_check_rounded, 'Server-checked rules',
      'Eligibility, timing and duplicate votes are enforced by the server, not the app.'),
];

const landingSecurityPoints = <LandingFeature>[
  LandingFeature(Icons.shield_outlined, 'Two-step verification',
      'Sensitive administrative actions need a recent sign-in and two-step verification.'),
  LandingFeature(Icons.visibility_off_outlined, 'Privacy is a choice',
      'Turn on anonymous voting when a decision calls for it. The mode is visible on the ballot.'),
  LandingFeature(Icons.gavel_rounded, 'The server decides',
      'Voting windows, eligibility and one-vote-per-person are checked on the server at submission.'),
  LandingFeature(Icons.history_rounded, 'Reviewable records',
      'Key administrative actions are recorded so owners and admins can review them.'),
];

class LandingFaq {
  const LandingFaq(this.question, this.answer);
  final String question;
  final String answer;
}

const landingFaqs = <LandingFaq>[
  LandingFaq('What can we use Kivora for?',
      'Candidate elections, single-choice polls and yes/no polls for your organization, such as representative choices, committee decisions and member questions.'),
  LandingFaq('Who is allowed to vote?',
      'The organizer sets one eligibility rule per vote: all active members, selected departments, or selected members. The server checks it again when you submit your ballot.'),
  LandingFaq('Can a ballot be anonymous?',
      'Yes, it is optional. In an anonymous vote your choice is stored without a field linking it to your account, while a separate participation record prevents voting twice. The mode is fixed when the vote is created and shown before you choose.'),
  LandingFaq('How do I check my vote receipt?',
      'Open Verify a receipt, paste your receipt hash and check it. The receipt confirms that a ballot with that receipt exists. It does not show your choice, who voted, or prove anything about the rest of the process.'),
  LandingFaq('What does the history show?',
      'Owners and admins can review a server-side record of key administrative and election actions for their organization.'),
  LandingFaq('When can members see results?',
      'Results are calculated after a vote closes. Ordinary members see them once an organization admin publishes them.'),
];

// ---- localized accessors -------------------------------------------------
// The constants above are the English source. These build the same lists from
// the ARB files so the page follows the app language. A test asserts the
// English ARB text equals the constants.

List<LandingFeature> localizedLandingFeatures(AppLocalizations l) => [
      LandingFeature(landingFeatures[0].icon, l.lcF1T, l.lcF1B),
      LandingFeature(landingFeatures[1].icon, l.lcF2T, l.lcF2B),
      LandingFeature(landingFeatures[2].icon, l.lcF3T, l.lcF3B),
      LandingFeature(landingFeatures[3].icon, l.lcF4T, l.lcF4B),
      LandingFeature(landingFeatures[4].icon, l.lcF5T, l.lcF5B),
      LandingFeature(landingFeatures[5].icon, l.lcF6T, l.lcF6B),
    ];

List<LandingStep> localizedLandingSteps(AppLocalizations l) => [
      LandingStep(l.lcS1T, l.lcS1B),
      LandingStep(l.lcS2T, l.lcS2B),
      LandingStep(l.lcS3T, l.lcS3B),
      LandingStep(l.lcS4T, l.lcS4B),
    ];

List<LandingFeature> localizedLandingOrgTypes(AppLocalizations l) => [
      LandingFeature(landingOrgTypes[0].icon, l.lcO1T, l.lcO1B),
      LandingFeature(landingOrgTypes[1].icon, l.lcO2T, l.lcO2B),
      LandingFeature(landingOrgTypes[2].icon, l.lcO3T, l.lcO3B),
      LandingFeature(landingOrgTypes[3].icon, l.lcO4T, l.lcO4B),
      LandingFeature(landingOrgTypes[4].icon, l.lcO5T, l.lcO5B),
    ];

List<LandingFeature> localizedLandingTrustPoints(AppLocalizations l) => [
      LandingFeature(landingTrustPoints[0].icon, l.lcT1T, l.lcT1B),
      LandingFeature(landingTrustPoints[1].icon, l.lcT2T, l.lcT2B),
      LandingFeature(landingTrustPoints[2].icon, l.lcT3T, l.lcT3B),
    ];

List<LandingFeature> localizedLandingSecurityPoints(AppLocalizations l) => [
      LandingFeature(landingSecurityPoints[0].icon, l.lcY1T, l.lcY1B),
      LandingFeature(landingSecurityPoints[1].icon, l.lcY2T, l.lcY2B),
      LandingFeature(landingSecurityPoints[2].icon, l.lcY3T, l.lcY3B),
      LandingFeature(landingSecurityPoints[3].icon, l.lcY4T, l.lcY4B),
    ];

List<LandingFaq> localizedLandingFaqs(AppLocalizations l) => [
      LandingFaq(l.lcQ1T, l.lcQ1B),
      LandingFaq(l.lcQ2T, l.lcQ2B),
      LandingFaq(l.lcQ3T, l.lcQ3B),
      LandingFaq(l.lcQ4T, l.lcQ4B),
      LandingFaq(l.lcQ5T, l.lcQ5B),
      LandingFaq(l.lcQ6T, l.lcQ6B),
    ];
