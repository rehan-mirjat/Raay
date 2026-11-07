import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';

class _TopicSection {
  const _TopicSection(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final List<String> body;
}

/// Package D1: a public, user-facing explanation of how Raay's election
/// system actually works - written to match the implemented backend exactly,
/// not aspirational claims. Every statement here should be checkable against
/// functions/src/voting/*.ts and firestore.rules. No claims of national
/// certification, independent cryptographic audit, or guaranteed anonymity
/// beyond what the implementation provides are made anywhere on this screen.
class TransparencyCenterScreen extends StatelessWidget {
  const TransparencyCenterScreen({super.key});

  static List<_TopicSection> _sections(AppLocalizations l) => [
        _TopicSection(Icons.timeline_rounded, l.trS1Title,
            [l.trS1P1, l.trS1P2, l.trS1P3]),
        _TopicSection(
            Icons.how_to_vote_outlined, l.trS2Title, [l.trS2P1, l.trS2P2]),
        _TopicSection(
            Icons.security_rounded, l.trS3Title, [l.trS3P1, l.trS3P2]),
        _TopicSection(Icons.visibility_off_outlined, l.trS4Title,
            [l.trS4P1, l.trS4P2, l.trS4P3]),
        _TopicSection(
            Icons.receipt_long_outlined, l.trS5Title, [l.trS5P1, l.trS5P2]),
        _TopicSection(
            Icons.fact_check_outlined, l.trS6Title, [l.trS6P1, l.trS6P2]),
        _TopicSection(
            Icons.bar_chart_rounded, l.trS7Title, [l.trS7P1, l.trS7P2]),
        _TopicSection(Icons.admin_panel_settings_outlined, l.trS8Title,
            [l.trS8P1, l.trS8P2]),
        _TopicSection(Icons.privacy_tip_outlined, l.trS9Title,
            [l.trS9P1, l.trS9P2, l.trS9P3]),
        _TopicSection(Icons.flag_outlined, l.trS10Title,
            [l.trS10P1, l.trS10P2, l.trS10P3]),
      ];

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).trTitle,
            style: TextStyle(color: kc.textPrimary)),
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
                Text(AppLocalizations.of(context).trHeading,
                    style: TextStyle(
                        fontSize: isDesktop ? 26 : 22,
                        fontWeight: FontWeight.bold,
                        color: kc.textPrimary)),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).trIntro,
                  style: TextStyle(
                      fontSize: 14, color: kc.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 28),
                ..._sections(AppLocalizations.of(context))
                    .map((s) => _buildSection(context, s)),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go('/receipt-verify'),
                  icon: const Icon(Icons.search_rounded, size: 18),
                  label: Text(AppLocalizations.of(context).trVerify),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, _TopicSection section) {
    final kc = RaayColors.of(context);
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
              Icon(section.icon,
                  color: RaayColors.of(context).accentText, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(section.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kc.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...section.body.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(p,
                    style: TextStyle(
                        fontSize: 13, color: kc.textSecondary, height: 1.5)),
              )),
        ],
      ),
    );
  }
}
