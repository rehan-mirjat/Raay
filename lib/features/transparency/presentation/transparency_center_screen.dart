import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';

class _TopicSection {
  const _TopicSection(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final List<String> body;
}

/// Package D1: a public, user-facing explanation of how Kivora's election
/// system actually works - written to match the implemented backend exactly,
/// not aspirational claims. Every statement here should be checkable against
/// functions/src/voting/*.ts and firestore.rules. No claims of national
/// certification, independent cryptographic audit, or guaranteed anonymity
/// beyond what the implementation provides are made anywhere on this screen.
class TransparencyCenterScreen extends StatelessWidget {
  const TransparencyCenterScreen({super.key});

  static final _sections = <_TopicSection>[
    const _TopicSection(Icons.timeline_rounded, 'Election Lifecycle', [
      'Every election moves through a fixed sequence of states, enforced by the server, not the app: Draft → Scheduled → Active → Closed → Archived.',
      'An election cannot accept ballots outside the Active state, and the server - not your device\'s clock - decides when that window opens and closes.',
      'Draft elections are never visible to anyone except the organization\'s own owners and admins.',
    ]),
    const _TopicSection(Icons.how_to_vote_outlined, 'Voter Eligibility', [
      'Each election is configured with one eligibility rule: every active member of the organization, a specific list of departments, or a specific list of members.',
      'Eligibility is re-checked by the server at the moment you submit a ballot. What the app shows you beforehand (such as a "Vote Now" button) is a convenience - it is never the actual authorization check.',
    ]),
    const _TopicSection(Icons.security_rounded, 'How a Vote Is Processed', [
      'Casting a ballot runs as a single atomic server-side transaction: it verifies your session hasn\'t been revoked, confirms you\'re eligible and haven\'t already voted, and records your choice - all or nothing.',
      'A duplicate submission (for example, from a retried request after a network error) is rejected by the server rather than counted twice, because each voter\'s participation record for a given election has a fixed, predictable ID that can only be created once.',
    ]),
    const _TopicSection(Icons.visibility_off_outlined, 'Anonymous vs. Identifiable Voting', [
      'Anonymous elections: your ballot choice is stored without any field linking it back to your account. The system can confirm you participated (to prevent double-voting) without recording what you chose.',
      'Identifiable elections: your choice is recorded against your account. This mode exists for governance contexts that require attributable votes (for example, certain formal resolutions) and is clearly labeled before you vote.',
      'An election\'s privacy mode is fixed when it\'s created and shown to you before you ever select a choice.',
    ]),
    const _TopicSection(Icons.receipt_long_outlined, 'Vote Receipts', [
      'After voting, you receive a receipt: a receipt ID and a cryptographic hash generated from your ballot record at the moment it was recorded.',
      'The receipt confirms your ballot was accepted and exists in the system\'s records. It is not a copy of your ballot choice, and in an anonymous election it cannot be used by anyone - including Kivora administrators - to determine what you selected.',
    ]),
    const _TopicSection(Icons.fact_check_outlined, 'What Receipt Verification Does and Does Not Prove', [
      'Verifying a receipt confirms that a ballot matching that receipt exists in the ledger. That is the full extent of what it proves.',
      'It does NOT prove who cast that ballot, what choice was selected, that no other issue occurred elsewhere in the process, or provide independent cryptographic audit of the full tally beyond what is described here. Treat it as a record-existence check, not a formal proof of election integrity.',
    ]),
    const _TopicSection(Icons.bar_chart_rounded, 'When Results Become Available', [
      'Results are calculated after an election closes, and are only visible to ordinary members once an organization admin explicitly publishes them.',
      'Organization owners and admins may review computed results before publishing, in order to catch configuration problems - this is a normal part of the workflow, not evidence of hidden tallies.',
    ]),
    const _TopicSection(Icons.admin_panel_settings_outlined, 'Administrative Accountability', [
      'Sensitive administrative actions - publishing or closing an election, changing a member\'s role, granting Observer access, and similar actions - are written to an organization-scoped audit log, visible to that organization\'s owners and admins.',
      'This is an operational log for the organization\'s own oversight, not a public, tamper-proof ledger - see "Known Limitations" below.',
    ]),
    const _TopicSection(Icons.privacy_tip_outlined, 'Privacy & Data Handling', [
      'Each organization\'s data is isolated from every other organization at the server level; membership in one organization never grants visibility into another\'s elections, members, or results.',
      'Observers (a limited, admin-granted capability) see only organization-wide aggregate turnout numbers for active elections and published results - never individual ballots, voter identities, or small-group breakdowns that could reveal how a specific person or small group voted.',
      'On the Free plan, mobile app users may see banner ads on browsing screens (home, organizations, calendar, published results). Ads are served by a third-party ad network that may collect device identifiers according to your consent choices. Ads never appear on the ballot, receipt, receipt-verification, transparency or admin screens, and ad networks never receive your vote, your choice, or your receipt.',
    ]),
    const _TopicSection(Icons.flag_outlined, 'Known Limitations', [
      'Audit logs are ordinary database records, not a cryptographically tamper-evident ledger - they describe operational history, not mathematical proof against retroactive modification.',
      'Kivora is not independently certified by any national or third-party election-standards body, and receipt verification is not a substitute for an independent cryptographic audit of the full tally.',
      'Some interface languages are provided via machine-assisted translation pending native-speaker review - see Settings → Preferences → Language.',
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Trust & Transparency Center', style: TextStyle(color: kc.textPrimary)),
        iconTheme: IconThemeData(color: kc.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('How Kivora elections work',
                    style: TextStyle(
                        fontSize: isDesktop ? 26 : 22,
                        fontWeight: FontWeight.bold,
                        color: kc.textPrimary)),
                const SizedBox(height: 8),
                Text(
                  'A plain-language explanation of what actually happens behind every election, written to match the real implementation - including its honest limitations.',
                  style: TextStyle(fontSize: 14, color: kc.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 28),
                ..._sections.map((s) => _buildSection(context, s)),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/receipt-verify'),
                  icon: const Icon(Icons.search_rounded, size: 18),
                  label: const Text('Verify a receipt'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, _TopicSection section) {
    final kc = KivoraColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(section.icon, color: KivoraColors.of(context).accentText, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(section.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15, color: kc.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...section.body.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(p,
                    style: TextStyle(fontSize: 13, color: kc.textSecondary, height: 1.5)),
              )),
        ],
      ),
    );
  }
}
