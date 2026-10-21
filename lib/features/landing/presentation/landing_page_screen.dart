import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../../core/layout/responsive.dart';

class LandingPageScreen extends ConsumerStatefulWidget {
  const LandingPageScreen({super.key});

  @override
  ConsumerState<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends ConsumerState<LandingPageScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _organizationsKey = GlobalKey();
  final GlobalKey _securityKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  int _heroSelectedCandidate = 0;
  bool _heroVoteSubmitted = false;

  int? _expandedFaqIndex;

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isWide(context);
    final screenWidth = MediaQuery.of(context).size.width;
    // The six links plus two buttons need ~1100px; below that (or with large
    // text) the menu moves into the drawer instead of overflowing.
    final inlineNav = screenWidth >= 1100 && MediaQuery.textScalerOf(context).scale(14) / 14 <= 1.3;

    return Scaffold(
      backgroundColor: Colors.transparent,
      endDrawer: !inlineNav ? _buildMobileDrawer(context) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              _buildNavBar(context, inlineNav),
              _buildHeroSection(context, isDesktop, screenWidth),
              _buildTrustStrip(context, screenWidth),
              _buildFeaturesSection(context, key: _featuresKey),
              _buildHowItWorksSection(context, key: _howItWorksKey),
              _buildOrganizationTypesSection(context, key: _organizationsKey),
              _buildSecurityAndPrivacySection(context, key: _securityKey),
              _buildAnonymousVotingSection(context),
              _buildProductShowcaseSection(context),
              _buildFaqSection(context, key: _faqKey),
              _buildFinalCtaSection(context),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. NAVIGATION BAR
  // ===========================================================================
  Widget _buildNavBar(BuildContext context, bool inlineNav) {
    final isDesktop = inlineNav;
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        border:
            Border(bottom: BorderSide(color: KivoraColors.borderOf(context), width: 1.0)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Logo & Brand (Kivora)
              Flexible(
                child: InkWell(
                onTap: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Kivora',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: KivoraColors.textPrimaryOf(context),
                          letterSpacing: -0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

              // Center Navigation (Desktop)
              if (isDesktop)
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AnimatedNavLink(
                        label: 'Features',
                        onTap: () => _scrollToSection(_featuresKey)),
                    _AnimatedNavLink(
                        label: 'How it works',
                        onTap: () => _scrollToSection(_howItWorksKey)),
                    _AnimatedNavLink(
                        label: 'Organizations',
                        onTap: () => _scrollToSection(_organizationsKey)),
                    _AnimatedNavLink(
                        label: 'Security & Privacy',
                        onTap: () => _scrollToSection(_securityKey)),
                    _AnimatedNavLink(
                        label: 'Verify Receipt', onTap: () => context.go('/receipt-verify')),
                    _AnimatedNavLink(
                        label: 'Transparency', onTap: () => context.go('/transparency')),
                  ],
                ))),

              // Right CTAs
              if (isDesktop)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AnimatedButton(
                      isPrimary: false,
                      label: 'Sign in',
                      onPressed: () => context.go('/login'),
                    ),
                    const SizedBox(width: 12),
                    _AnimatedButton(
                      isPrimary: true,
                      label: 'Get started',
                      onPressed: () => context.go('/register'),
                    ),
                  ],
                )
              else
                Builder(
                  builder: (ctx) => IconButton(
                    tooltip: 'Menu',
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: Icon(Icons.menu_rounded,
                        color: KivoraColors.textPrimaryOf(context)),
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: KivoraColors.surfaceOf(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/icon/app_icon.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Kivora',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textPrimaryOf(context)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Divider(height: 1, color: KivoraColors.borderOf(context)),
              const SizedBox(height: 16),
              _drawerTile('Features', () {
                Navigator.pop(context);
                _scrollToSection(_featuresKey);
              }),
              _drawerTile('How it works', () {
                Navigator.pop(context);
                _scrollToSection(_howItWorksKey);
              }),
              _drawerTile('Organizations', () {
                Navigator.pop(context);
                _scrollToSection(_organizationsKey);
              }),
              _drawerTile('Security & Privacy', () {
                Navigator.pop(context);
                _scrollToSection(_securityKey);
              }),
              _drawerTile('FAQ', () {
                Navigator.pop(context);
                _scrollToSection(_faqKey);
              }),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/login');
                  },
                  child: const Text('Sign in'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/register');
                  },
                  style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue),
                  child: const Text('Get started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerTile(String label, VoidCallback onTap) {
    return ListTile(
      title: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: KivoraColors.textPrimaryOf(context))),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  // ===========================================================================
  // 2. HERO SECTION
  // ===========================================================================
  Widget _buildHeroSection(
      BuildContext context, bool isDesktop, double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isDesktop ? 64 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _buildHeroTextContent(context, true),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 5,
                      child: _buildHeroInteractiveWidget(context),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildHeroTextContent(context, false),
                    const SizedBox(height: 40),
                    _buildHeroInteractiveWidget(context),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeroTextContent(BuildContext context, bool alignLeft) {
    return Column(
      crossAxisAlignment:
          alignLeft ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        // Eyebrow Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.25)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_outlined,
                  size: 14, color: AppTheme.primaryBlue),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'KIVORA — SECURE E-VOTING AND POLLING',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                    letterSpacing: 0.8,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Headline
        Text(
          'Run fair elections for your organization.',
          style: TextStyle(
            fontSize: alignLeft ? 50 : 34,
            fontWeight: FontWeight.w800,
            color: KivoraColors.textPrimaryOf(context),
            height: 1.12,
            letterSpacing: -1.2,
          ),
          textAlign: alignLeft ? TextAlign.start : TextAlign.center,
        ),
        const SizedBox(height: 20),

        // Supporting Text
        Text(
          'Bring your members together. Hold elections and polls with Kivora’s verified identities, protected ballots, and server-authoritative audit logs.',
          style: TextStyle(
            fontSize: 16,
            color: KivoraColors.textSecondaryOf(context),
            height: 1.5,
          ),
          textAlign: alignLeft ? TextAlign.start : TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Primary Action Buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: alignLeft ? WrapAlignment.start : WrapAlignment.center,
          children: [
            _AnimatedButton(
              isPrimary: true,
              label: 'Get started →',
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              onPressed: () => context.go('/register'),
            ),
            _AnimatedButton(
              isPrimary: false,
              label: 'Sign in',
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
              onPressed: () => context.go('/login'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Micro-link
        InkWell(
          onTap: () => context.go('/login'),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Have a joining code or invitation? ',
                  style: TextStyle(fontSize: 13, color: KivoraColors.textSecondaryOf(context)),
                ),
                const Text(
                  'Join an organization →',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Interactive Mock Product Preview
  Widget _buildHeroInteractiveWidget(BuildContext context) {
    return _HoverContainer(
      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.08),
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(24),
      hoverBorderColor: AppTheme.primaryBlue.withValues(alpha: 0.3),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: KivoraColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.school_outlined,
                                size: 18, color: AppTheme.primaryBlue),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Student Council',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: KivoraColors.textPrimaryOf(context)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('ACTIVE',
                          style: TextStyle(
                              color: AppTheme.success,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  'Student Council Election 2026',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose one candidate to represent your department.',
                  style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                ),
                const SizedBox(height: 20),

                // Candidate options
                _heroCandidateOption(0, 'Candidate A — Sarah Jenkins'),
                const SizedBox(height: 10),
                _heroCandidateOption(1, 'Candidate B — Michael Chen'),
                const SizedBox(height: 10),
                _heroCandidateOption(2, 'Candidate C — David Miller'),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 14, color: KivoraColors.textSecondaryOf(context)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text('Anonymous ballot',
                          style: TextStyle(
                              fontSize: 13, color: KivoraColors.textSecondaryOf(context))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _heroVoteSubmitted = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                        _heroVoteSubmitted ? 'Vote Confirmed!' : 'Submit vote'),
                  ),
                ),

                if (_heroVoteSubmitted) ...[
                  const SizedBox(height: 16),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.success.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: AppTheme.success, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vote recorded',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: KivoraColors.textPrimaryOf(context))),
                              Text('Receipt code: #0x82f9...a42',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: KivoraColors.textSecondaryOf(context))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ILLUSTRATIVE BALLOT · MEMBER VIEW DEMO',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: KivoraColors.textSecondaryOf(context),
                letterSpacing: 0.8),
          ),
        ],
      ),
    );
  }

  Widget _heroCandidateOption(int index, String label) {
    final isSelected = _heroSelectedCandidate == index;
    return InkWell(
      onTap: () {
        setState(() {
          _heroSelectedCandidate = index;
          _heroVoteSubmitted = false;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryBlue.withValues(alpha: 0.12).withValues(alpha: 0.6)
              : KivoraColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : KivoraColors.borderOf(context),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                  color: isSelected
                      ? AppTheme.primaryBlue
                      : KivoraColors.textPrimaryOf(context),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 3. TRUST / VALUE STRIP
  // ===========================================================================
  Widget _buildTrustStrip(BuildContext context, double screenWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        border: Border.symmetric(
            horizontal: BorderSide(color: KivoraColors.borderOf(context))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 800;
              final colWidth =
                  isWide ? (constraints.maxWidth - 48) / 3 : double.infinity;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  SizedBox(
                    width: colWidth,
                    child: _trustItem(
                      icon: Icons.verified_user_outlined,
                      title: 'Kivora verified organizations',
                      subtitle:
                          'Phone verification + admin two-step verification.',
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: _trustItem(
                      icon: Icons.shield_outlined,
                      title: 'Private ballots',
                      subtitle: 'Optional anonymous voting for your members.',
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: _trustItem(
                      icon: Icons.list_alt_rounded,
                      title: 'Every action on record',
                      subtitle:
                          'An administrative audit log members cannot edit.',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _trustItem(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: KivoraColors.textPrimaryOf(context))),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 4. FEATURES SECTION
  // ===========================================================================
  Widget _buildFeaturesSection(BuildContext context, {required Key key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BUILT FOR COLLECTIVE DECISIONS',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                    letterSpacing: 1.0),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'One place to vote.\nMore ways to be heard.',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: KivoraColors.textPrimaryOf(context),
                          height: 1.15,
                          letterSpacing: -0.8),
                    ),
                  ),
                  if (ResponsiveLayout.isWide(context))
                    SizedBox(
                      width: 320,
                      child: Text(
                        'From choosing your next representative to finding a meeting time, give every decision a clear home.',
                        style: TextStyle(
                            color: KivoraColors.textSecondaryOf(context),
                            fontSize: 14,
                            height: 1.4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 48),

              _buildDualPreviewCards(context),

              const SizedBox(height: 48),

              // 6 Feature Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  final isTablet = constraints.maxWidth >= 600 && !isWide;
                  final cols = isWide ? 3 : (isTablet ? 2 : 1);
                  final itemWidth =
                      (constraints.maxWidth - (cols - 1) * 20) / cols;

                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: _featureCard(
                          title: 'Organization Management',
                          description:
                              'Manage members, roles, departments, invitations, and joining codes seamlessly.',
                          icon: Icons.corporate_fare_outlined,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _featureCard(
                          title: 'Secure Voting Events',
                          description:
                              'Create elections and polls with controlled lifecycle management and automatic tallying.',
                          icon: Icons.how_to_vote_outlined,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _featureCard(
                          title: 'Anonymous Voting',
                          description:
                              'Keep voter participation records separate from anonymous ballot data models.',
                          icon: Icons.shield_outlined,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _featureCard(
                          title: 'Eligibility Control',
                          description:
                              'Support organization-wide, selected-member, and department-based voter eligibility.',
                          icon: Icons.tune_rounded,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _featureCard(
                          title: 'Results & Turnout',
                          description:
                              'Provide controlled access to turnout and voting results according to event state.',
                          icon: Icons.bar_chart_rounded,
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: _featureCard(
                          title: 'Audit & Governance',
                          description:
                              'Track important administrative actions through tamper-evident application audit logging.',
                          icon: Icons.history_rounded,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDualPreviewCards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;
        final width =
            isWide ? (constraints.maxWidth - 24) / 2 : double.infinity;

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            // Left Card: Elections
            SizedBox(
              width: width,
              child: _HoverContainer(
                backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.08),
                padding: const EdgeInsets.all(28),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: KivoraColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.how_to_vote_outlined,
                          color: AppTheme.primaryBlue, size: 20),
                    ),
                    const SizedBox(height: 16),
                    Text('Elections with a clear purpose.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: KivoraColors.textPrimaryOf(context))),
                    const SizedBox(height: 8),
                    Text(
                        'Bring candidates and members into a focused ballot experience. Make participation feel straightforward.',
                        style: TextStyle(
                            fontSize: 13,
                            color: KivoraColors.textSecondaryOf(context),
                            height: 1.4)),
                    const SizedBox(height: 24),

                    // Mock Election Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: KivoraColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: KivoraColors.borderOf(context)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Student council 2026',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: KivoraColors.textPrimaryOf(context)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6)),
                                child: const Text('Election',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryBlue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _miniCandidateRow('A', 'Candidate A'),
                          const SizedBox(height: 8),
                          _miniCandidateRow('B', 'Candidate B'),
                          const SizedBox(height: 8),
                          _miniCandidateRow('C', 'Candidate C'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Right Card: Polls
            SizedBox(
              width: width,
              child: _HoverContainer(
                backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.08),
                padding: const EdgeInsets.all(28),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: KivoraColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.bar_chart_rounded,
                          color: AppTheme.primaryBlue, size: 20),
                    ),
                    const SizedBox(height: 16),
                    Text('Everyday questions, shared answers.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: KivoraColors.textPrimaryOf(context))),
                    const SizedBox(height: 8),
                    Text(
                        'Use polls to hear what members think. Keep everyday input alongside your organization’s elections.',
                        style: TextStyle(
                            fontSize: 13,
                            color: KivoraColors.textSecondaryOf(context),
                            height: 1.4)),
                    const SizedBox(height: 24),

                    // Mock Poll Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: KivoraColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: KivoraColors.borderOf(context)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'When should we meet?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: KivoraColors.textPrimaryOf(context)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6)),
                                child: const Text('Poll',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryBlue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _pollBarRow('Wednesday afternoon', 0.75),
                          const SizedBox(height: 8),
                          _pollBarRow('Thursday evening', 0.45),
                          const SizedBox(height: 8),
                          _pollBarRow('Friday morning', 0.30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _miniCandidateRow(String letter, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: KivoraColors.backgroundOf(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.12),
            child: Text(letter,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: KivoraColors.textPrimaryOf(context)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pollBarRow(String label, double ratio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: KivoraColors.textPrimaryOf(context))),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: KivoraColors.borderOf(context),
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
          ),
        ),
      ],
    );
  }

  Widget _featureCard(
      {required String title,
      required String description,
      required IconData icon}) {
    return _HoverContainer(
      padding: const EdgeInsets.all(28),
      borderRadius: BorderRadius.circular(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(height: 20),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: KivoraColors.textPrimaryOf(context))),
          const SizedBox(height: 8),
          Text(description,
              style: TextStyle(
                  fontSize: 13, color: KivoraColors.textSecondaryOf(context), height: 1.4)),
        ],
      ),
    );
  }

  // ===========================================================================
  // 5. HOW IT WORKS
  // ===========================================================================
  Widget _buildHowItWorksSection(BuildContext context, {required Key key}) {
    return Container(
      key: key,
      color: KivoraColors.surfaceOf(context),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HOW IT WORKS',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                              letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A simpler path to participation.',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: KivoraColors.textPrimaryOf(context),
                              letterSpacing: -0.6),
                        ),
                      ],
                    ),
                  ),
                  if (ResponsiveLayout.isWide(context)) ...[
                    const SizedBox(width: 16),
                    _AnimatedButton(
                      isPrimary: true,
                      label: 'Get started →',
                      onPressed: () => context.go('/register'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 850;
                  final width = isWide
                      ? (constraints.maxWidth - 48) / 3
                      : double.infinity;

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: width,
                        child: _stepCard(
                          step: '01',
                          title: 'Start with your organization',
                          description:
                              'Create your organization and complete phone verification. Admins set up two-step verification.',
                          caption: 'A verified starting point.',
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: _stepCard(
                          step: '02',
                          title: 'Bring your members in',
                          description:
                              'Invite your members to join your organization with an invitation or joining code.',
                          caption: 'Your community, connected.',
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: _stepCard(
                          step: '03',
                          title: 'Put a decision to a vote',
                          description:
                              'Set up an election or poll. Choose whether voting is anonymous, then let members have their say.',
                          caption: 'From a question to a decision.',
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepCard(
      {required String step,
      required String title,
      required String description,
      required String caption}) {
    return _HoverContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step,
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryBlue,
                  height: 1.0)),
          const SizedBox(height: 16),
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: KivoraColors.textPrimaryOf(context))),
          const SizedBox(height: 8),
          Text(description,
              style: TextStyle(
                  fontSize: 13, color: KivoraColors.textSecondaryOf(context), height: 1.4)),
          const SizedBox(height: 12),
          Text(caption,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue)),
        ],
      ),
    );
  }

  // ===========================================================================
  // 6. ORGANIZATION TYPES
  // ===========================================================================
  Widget _buildOrganizationTypesSection(BuildContext context,
      {required Key key}) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('FOR YOUR ORGANIZATION',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                      letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Text(
                'Different communities.\nA shared need to be heard.',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: KivoraColors.textPrimaryOf(context),
                    height: 1.15,
                    letterSpacing: -0.6),
              ),
              const SizedBox(height: 12),
              Text(
                'Kivora brings e-voting and polling to the groups that make decisions together.',
                style: TextStyle(fontSize: 14, color: KivoraColors.textSecondaryOf(context)),
              ),
              const SizedBox(height: 40),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 800;

                  return _HoverContainer(
                    padding: const EdgeInsets.all(28),
                    borderRadius: BorderRadius.circular(20),
                    child: isWide
                        ? Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Container(
                                  height: 240,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.groups_rounded,
                                        size: 80, color: AppTheme.primaryBlue),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 32),
                              Expanded(
                                flex: 6,
                                child: _orgTypesQuoteCard(),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Icon(Icons.groups_rounded,
                                      size: 60, color: AppTheme.primaryBlue),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _orgTypesQuoteCard(),
                            ],
                          ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // 3 Sub-types
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 750;
                  final width = isWide
                      ? (constraints.maxWidth - 32) / 3
                      : double.infinity;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                          width: width,
                          child: _orgTypeItem(
                              'Student councils',
                              'Elect representatives and ask students what matters on campus.',
                              Icons.school_outlined)),
                      SizedBox(
                          width: width,
                          child: _orgTypeItem(
                              'Clubs & associations',
                              'Gather member input on committee options and annual initiatives.',
                              Icons.groups_outlined)),
                      SizedBox(
                          width: width,
                          child: _orgTypeItem(
                              'Community organizations',
                              'Poll members on local priorities and company decisions.',
                              Icons.business_outlined)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orgTypesQuoteCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.chat_bubble_outline_rounded,
              color: AppTheme.primaryBlue, size: 20),
        ),
        const SizedBox(height: 16),
        Text(
          'Good decisions start with people.',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: KivoraColors.textPrimaryOf(context)),
        ),
        const SizedBox(height: 8),
        Text(
          'Build a space where your members can take part, not just stay informed.',
          style: TextStyle(
              fontSize: 14, color: KivoraColors.textSecondaryOf(context), height: 1.4),
        ),
      ],
    );
  }

  Widget _orgTypeItem(String title, String subtitle, IconData icon) {
    return _HoverContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: KivoraColors.textPrimaryOf(context)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: 18, color: AppTheme.primaryBlue),
            ],
          ),
          const SizedBox(height: 6),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 12, color: KivoraColors.textSecondaryOf(context), height: 1.3)),
        ],
      ),
    );
  }

  // ===========================================================================
  // 7. SECURITY & PRIVACY SECTION
  // ===========================================================================
  Widget _buildSecurityAndPrivacySection(BuildContext context,
      {required Key key}) {
    return Container(
      key: key,
      color: KivoraColors.textPrimaryOf(context),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SECURITY & PRIVACY',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8AB4FF),
                          letterSpacing: 1.0)),
                  const SizedBox(height: 12),
                  const Text(
                    'Private choices.\nAccountable actions.',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.15,
                        letterSpacing: -0.8),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Trust starts with Kivora’s clear rules: who administers your organization, how members vote, and what stays on record.',
                    style: TextStyle(
                        fontSize: 15, color: Color(0xFF94A3B8), height: 1.4),
                  ),
                  const SizedBox(height: 48),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _securityFeaturesList()),
                        const SizedBox(width: 48),
                        Expanded(flex: 6, child: _securityPipelineCard()),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _securityFeaturesList(),
                        const SizedBox(height: 40),
                        _securityPipelineCard(),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _securityFeaturesList() {
    return Column(
      children: [
        _secFeatureItem(
          icon: Icons.verified_user_outlined,
          title: 'Verification before participation',
          subtitle:
              'Organizations are verified with a phone number. Admins use two-step verification for an extra sign-in step.',
        ),
        const SizedBox(height: 24),
        _secFeatureItem(
          icon: Icons.lock_outline_rounded,
          title: 'Privacy is a choice, not an afterthought',
          subtitle:
              'Enable anonymous voting when a decision calls for it. Make the voting mode clear to members on their ballot.',
        ),
        const SizedBox(height: 24),
        _secFeatureItem(
          icon: Icons.history_rounded,
          title: 'A record members cannot rewrite',
          subtitle:
              'Administrative actions are written to an activity log that members cannot edit.',
        ),
      ],
    );
  }

  Widget _secFeatureItem(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF8AB4FF), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 13, color: Color(0xFF94A3B8), height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _securityPipelineCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text('SECURITY PIPELINE',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8AB4FF),
                        letterSpacing: 0.8)),
              ),
              SizedBox(width: 8),
              Icon(Icons.security_rounded, color: Color(0xFF8AB4FF), size: 18),
            ],
          ),
          const SizedBox(height: 24),
          _pipeStep('1. Authenticated User', 'Firebase Auth identity token'),
          _pipeArrow(),
          _pipeStep(
              '2. Organization Membership', 'Active status & tenant check'),
          _pipeArrow(),
          _pipeStep(
              '3. Role Authorization', 'Owner / Admin permission evaluation'),
          _pipeArrow(),
          _pipeStep('4. Eligibility Validation', 'Member / Department match'),
          _pipeArrow(),
          _pipeStep('5. Server-Side Processing',
              'Cloud Functions & atomic transaction write'),
        ],
      ),
    );
  }

  Widget _pipeStep(String title, String desc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: const TextStyle(fontSize: 13, color: Color(0xFFB4C0D0)),
          ),
        ],
      ),
    );
  }

  Widget _pipeArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Icon(Icons.arrow_downward_rounded,
            size: 14, color: Color(0xFF64748B)),
      ),
    );
  }

  // ===========================================================================
  // 8. ANONYMOUS VOTING EXPLANATION
  // ===========================================================================
  Widget _buildAnonymousVotingSection(BuildContext context) {
    return Container(
      color: KivoraColors.backgroundOf(context),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DATA SEPARATION ARCHITECTURE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                      letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Text(
                'How anonymous voting works in Kivora.',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: KivoraColors.textPrimaryOf(context)),
              ),
              const SizedBox(height: 12),
              Text(
                'Voter participation records are strictly separated from anonymous ballot records during server-side processing.',
                style: TextStyle(fontSize: 14, color: KivoraColors.textSecondaryOf(context)),
              ),
              const SizedBox(height: 36),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 800;
                  final colWidth = isWide
                      ? (constraints.maxWidth - 24) / 2
                      : double.infinity;

                  return Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: colWidth,
                        child: _anonCard(
                          title: 'Participation Record',
                          subtitle: 'User → Participation',
                          icon: Icons.person_outline_rounded,
                          fields: [
                            'organizationId',
                            'votingEventId',
                            'userId',
                            'votedAt'
                          ],
                        ),
                      ),
                      SizedBox(
                        width: colWidth,
                        child: _anonCard(
                          title: 'Anonymous Ballot',
                          subtitle: 'Vote → Anonymous Record',
                          icon: Icons.how_to_vote_outlined,
                          fields: [
                            'organizationId',
                            'votingEventId',
                            'selectedOptionId',
                            'castAt'
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: KivoraColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: KivoraColors.borderOf(context)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Notice: The stored data contains no direct join between participation records and anonymous ballots.',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: KivoraColors.textPrimaryOf(context)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _anonCard(
      {required String title,
      required String subtitle,
      required IconData icon,
      required List<String> fields}) {
    return _HoverContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryBlue, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: KivoraColors.textPrimaryOf(context))),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: KivoraColors.borderOf(context)),
          const SizedBox(height: 16),
          Text('STORED FIELDS:',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: KivoraColors.textSecondaryOf(context))),
          const SizedBox(height: 8),
          ...fields.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_rounded,
                        size: 14, color: AppTheme.primaryBlue),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(f,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'monospace',
                              color: KivoraColors.textPrimaryOf(context))),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ===========================================================================
  // 9. PRODUCT SHOWCASE / DEMO
  // ===========================================================================
  Widget _buildProductShowcaseSection(BuildContext context) {
    return Container(
      color: KivoraColors.surfaceOf(context),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PRODUCT SHOWCASE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                      letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Text(
                'A single administration suite for your organization.',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: KivoraColors.textPrimaryOf(context)),
              ),
              const SizedBox(height: 36),
              _HoverContainer(
                backgroundColor: KivoraColors.backgroundOf(context),
                padding: const EdgeInsets.all(28),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'KIVORA DASHBOARD DEMO',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: KivoraColors.textSecondaryOf(context)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text('Admin View',
                              style: TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _showcaseChip(
                            'Members Management', Icons.people_outline_rounded),
                        _showcaseChip('Joining Codes', Icons.key_outlined),
                        _showcaseChip(
                            'Departments Roster', Icons.domain_outlined),
                        _showcaseChip(
                            'Elections & Polls', Icons.how_to_vote_outlined),
                        _showcaseChip('Audit History', Icons.history_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showcaseChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KivoraColors.borderOf(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryBlue),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: KivoraColors.textPrimaryOf(context)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 10. FAQ SECTION
  // ===========================================================================
  Widget _buildFaqSection(BuildContext context, {required Key key}) {
    final faqs = [
      {
        'q': 'What can we use Kivora for?',
        'a':
            'Kivora supports secure e-voting and polling for organizations. Use it for representative elections, committee decisions, or everyday questions for your members.',
      },
      {
        'q': 'How are organizations verified?',
        'a':
            'Organizations complete phone verification, and admins use two-step verification. These checks help establish a verified organization and its administrators.',
      },
      {
        'q': 'Can members vote anonymously?',
        'a':
            'Yes. Anonymous voting is optional, so your organization can choose the voting mode appropriate for each decision.',
      },
      {
        'q': 'Can members change the administrative activity log?',
        'a':
            'No. Members cannot edit the administrative activity log. It provides an immutable record of administrative actions within the organization.',
      },
      {
        'q': 'How do I join an existing organization?',
        'a':
            'Choose Join an organization and use your joining code or invitation. If you already have an account, choose Sign in.',
      },
    ];

    return Container(
      key: key,
      color: KivoraColors.surfaceOf(context),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A LITTLE MORE CLARITY',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                      letterSpacing: 1.0)),
              const SizedBox(height: 8),
              Text('Good questions. Clear answers.',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: KivoraColors.textPrimaryOf(context))),
              const SizedBox(height: 36),
              ...faqs.asMap().entries.map((entry) {
                final idx = entry.key;
                final faq = entry.value;
                final isExpanded = _expandedFaqIndex == idx;

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expandedFaqIndex = isExpanded ? null : idx;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                faq['q']!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: KivoraColors.textPrimaryOf(context)),
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.remove_rounded
                                  : Icons.add_rounded,
                              color: AppTheme.primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          faq['a']!,
                          style: TextStyle(
                              fontSize: 14,
                              color: KivoraColors.textSecondaryOf(context),
                              height: 1.5),
                        ),
                      ),
                    Divider(height: 1, color: KivoraColors.borderOf(context)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 11. FINAL CTA SECTION
  // ===========================================================================
  Widget _buildFinalCtaSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.primaryBlue,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              const Text('YOUR NEXT DECISION STARTS HERE',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      letterSpacing: 1.0)),
              const SizedBox(height: 16),
              const Text(
                'Give your organization a voice. With Kivora.',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Create a home for your elections and polls. Bring your members in, and move forward together.',
                style:
                    TextStyle(fontSize: 15, color: Colors.white70, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _AnimatedButton(
                    isPrimary: true,
                    label: 'Get started →',
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryBlue,
                    onPressed: () => context.go('/register'),
                  ),
                  _AnimatedButton(
                    isPrimary: false,
                    label: 'Sign in',
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.white,
                    foregroundColor: Colors.white,
                    onPressed: () => context.go('/login'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sub-link
              InkWell(
                onTap: () => context.go('/login'),
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    'Already invited? Join an organization →',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 12. FOOTER
  // ===========================================================================
  Widget _buildFooter(BuildContext context) {
    return Container(
      color: KivoraColors.surfaceOf(context),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 36,
                runSpacing: 24,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              'assets/icon/app_icon.png',
                              width: 28,
                              height: 28,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('Kivora',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: KivoraColors.textPrimaryOf(context))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 260,
                        child: Text(
                          'Secure e-voting and polling. For organizations. For every voice.',
                          style: TextStyle(
                              fontSize: 12,
                              color: KivoraColors.textSecondaryOf(context),
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 36,
                    runSpacing: 24,
                    children: [
                      _footerCol('Explore', [
                        _footerLink(
                            'Features', () => _scrollToSection(_featuresKey)),
                        _footerLink('How it works',
                            () => _scrollToSection(_howItWorksKey)),
                        _footerLink(
                            'Security', () => _scrollToSection(_securityKey)),
                      ]),
                      _footerCol('Your organization', [
                        _footerLink(
                            'Get started', () => context.go('/register')),
                        _footerLink('Sign in', () => context.go('/login')),
                        _footerLink(
                            'Join organization', () => context.go('/login')),
                      ]),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Divider(height: 1, color: KivoraColors.borderOf(context)),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 16,
                runSpacing: 8,
                children: [
                  Text('© 2026 Kivora',
                      style: TextStyle(
                          fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
                  Text('Built for collective decisions',
                      style: TextStyle(
                          fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footerCol(String title, List<Widget> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: KivoraColors.textPrimaryOf(context))),
        const SizedBox(height: 12),
        ...links,
      ],
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Text(label,
            style:
                TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
      ),
    );
  }
}

// =============================================================================
// ANIMATED HOVER WIDGETS
// =============================================================================

class _HoverContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? hoverBorderColor;

  const _HoverContainer({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.backgroundColor,
    this.hoverBorderColor,
  });

  @override
  State<_HoverContainer> createState() => _HoverContainerState();
}

class _HoverContainerState extends State<_HoverContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? Matrix4.translationValues(0, -6, 0)
            : Matrix4.identity(),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? KivoraColors.surfaceOf(context),
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: _isHovered
                ? (widget.hoverBorderColor ??
                    AppTheme.primaryBlue.withValues(alpha: 0.6))
                : KivoraColors.borderOf(context),
            width: _isHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: _isHovered ? 20 : 8,
              offset: _isHovered ? const Offset(0, 8) : const Offset(0, 2),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

class _AnimatedNavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _AnimatedNavLink({required this.label, required this.onTap});

  @override
  State<_AnimatedNavLink> createState() => _AnimatedNavLinkState();
}

class _AnimatedNavLinkState extends State<_AnimatedNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppTheme.primaryBlue.withValues(alpha: 0.12).withValues(alpha: 0.7)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: TextStyle(
                fontSize: 14,
                fontWeight: _isHovered ? FontWeight.bold : FontWeight.w500,
                color:
                    _isHovered ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context),
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final bool isPrimary;
  final String label;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const _AnimatedButton({
    required this.isPrimary,
    required this.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    required this.onPressed,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = widget.backgroundColor ??
        (widget.isPrimary
            ? (_isHovered ? AppTheme.primaryBlueDark : AppTheme.primaryBlue)
            : (_isHovered ? AppTheme.primaryBlue.withValues(alpha: 0.12) : KivoraColors.surfaceOf(context)));

    final effectiveHoverBg = widget.backgroundColor != null
        ? (widget.backgroundColor == Colors.white
            ? AppTheme.primaryBlue.withValues(alpha: 0.12)
            : widget.backgroundColor!.withValues(alpha: 0.2))
        : effectiveBg;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transform: _isHovered
                ? Matrix4.translationValues(0, -2, 0)
                : Matrix4.identity(),
            padding: widget.padding,
            decoration: BoxDecoration(
              color: _isHovered ? effectiveHoverBg : effectiveBg,
              borderRadius: BorderRadius.circular(10),
              border: widget.borderColor != null
                  ? Border.all(
                      color: _isHovered ? Colors.white : widget.borderColor!,
                      width: 1.5)
                  : (widget.isPrimary
                      ? null
                      : Border.all(
                          color: _isHovered
                              ? AppTheme.primaryBlue
                              : KivoraColors.borderOf(context),
                          width: 1.5)),
              boxShadow: widget.isPrimary && widget.backgroundColor == null
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryBlue
                            .withValues(alpha: _isHovered ? 0.35 : 0.2),
                        blurRadius: _isHovered ? 12 : 6,
                        offset: _isHovered
                            ? const Offset(0, 4)
                            : const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: widget.foregroundColor ??
                    (widget.isPrimary
                        ? Colors.white
                        : (_isHovered
                            ? AppTheme.primaryBlue
                            : KivoraColors.textPrimaryOf(context))),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
