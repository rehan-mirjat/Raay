import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';
import '../providers/onboarding_providers.dart';

class MobileOnboardingScreen extends ConsumerStatefulWidget {
  const MobileOnboardingScreen({super.key});

  @override
  ConsumerState<MobileOnboardingScreen> createState() =>
      _MobileOnboardingScreenState();
}

class _MobileOnboardingScreenState
    extends ConsumerState<MobileOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skipToWelcome() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            _buildTopBar(),

            // PageView Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (idx) {
                  setState(() {
                    _currentPage = idx;
                  });
                },
                children: [
                  _page(_buildStep1()),
                  _page(_buildStep2()),
                  _page(_buildStep3()),
                  _page(_buildWelcomePage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Pages scroll instead of clipping when large text or a short window makes
  /// them taller than the screen; Spacers still space them out when they fit.
  Widget _page(Widget content) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(child: content),
        ),
      ),
    );
  }

  // ===========================================================================
  // TOP BAR (Raay Official Logo Asset + Brand Name + Skip Action)
  // ===========================================================================
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                Flexible(
                  child: Text(
                    'Raay',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: RaayColors.textPrimaryOf(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_currentPage < 3)
            TextButton(
              onPressed: _skipToWelcome,
              style: TextButton.styleFrom(
                foregroundColor: RaayColors.of(context).accentText,
                minimumSize: const Size(48, 48),
              ),
              child: Text(AppLocalizations.of(context).obSkip,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
            ),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 1: CREATE OR JOIN AN ORGANIZATION
  // ===========================================================================
  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Illustration Graphic Card
          _buildGraphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(AppLocalizations.of(context).obYourOrg,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: RaayColors.textPrimaryOf(context))),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(Icons.corporate_fare_outlined,
                          size: 14, color: RaayColors.of(context).accentText),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _illustrationActionRow(
                    Icons.add_rounded,
                    AppLocalizations.of(context).obCreate,
                    AppLocalizations.of(context).obCreateSub),
                const SizedBox(height: 8),
                _illustrationActionRow(
                    Icons.person_add_outlined,
                    AppLocalizations.of(context).obJoin,
                    AppLocalizations.of(context).obJoinSub),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.key_outlined,
                        size: 14, color: RaayColors.of(context).accentText),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(AppLocalizations.of(context).obInviteNote,
                          style: TextStyle(
                              fontSize: 12,
                              color: RaayColors.of(context).accentText,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Category Badge & Titles
          _buildTextContent(
            tag: AppLocalizations.of(context).obTag1,
            title: AppLocalizations.of(context).obTitle1,
            subtitle: AppLocalizations.of(context).obBody1,
          ),

          const SizedBox(height: 16),

          // Bottom Callout
          _buildCalloutBox(
            icon: Icons.groups_outlined,
            title: AppLocalizations.of(context).obCallout1,
            text: AppLocalizations.of(context).obCallout1b,
          ),

          const Spacer(),

          // Bottom Controls (1 of 3 + Next button)
          _buildBottomControls(
            pageIndex: 1,
            onNext: _nextPage,
            primaryLabel: AppLocalizations.of(context).obNext,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 2: VOTE WITH CONFIDENCE
  // ===========================================================================
  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Illustration Graphic Card
          _buildGraphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(AppLocalizations.of(context).obExample,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: RaayColors.textSecondaryOf(context))),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(Icons.how_to_vote_outlined,
                          size: 14, color: RaayColors.of(context).accentText),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context).obStudent,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: RaayColors.textPrimaryOf(context))),
                Text(AppLocalizations.of(context).obPresident,
                    style: TextStyle(
                        fontSize: 12,
                        color: RaayColors.textSecondaryOf(context))),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: RaayColors.of(context).accentText)),
                  child: Row(
                    children: [
                      Icon(Icons.radio_button_checked_rounded,
                          size: 14, color: RaayColors.of(context).accentText),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(AppLocalizations.of(context).obAlex,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: RaayColors.of(context).accentText)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: RaayColors.backgroundOf(context),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.radio_button_unchecked_rounded,
                          size: 14,
                          color: RaayColors.textSecondaryOf(context)),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(AppLocalizations.of(context).obJordan,
                            style: TextStyle(
                                fontSize: 12,
                                color: RaayColors.textPrimaryOf(context))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(AppLocalizations.of(context).obReview,
                        style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Category Badge & Titles
          _buildTextContent(
            tag: AppLocalizations.of(context).obTag2,
            title: AppLocalizations.of(context).obTitle2,
            subtitle: AppLocalizations.of(context).obBody2,
          ),

          const SizedBox(height: 16),

          // Bottom Callout
          _buildCalloutBox(
            icon: Icons.lock_outline_rounded,
            title: AppLocalizations.of(context).obCallout2,
            text: AppLocalizations.of(context).obCallout2b,
          ),

          const Spacer(),

          // Bottom Controls (2 of 3 + Back & Next)
          _buildBottomControls(
            pageIndex: 2,
            onBack: _previousPage,
            onNext: _nextPage,
            primaryLabel: AppLocalizations.of(context).obNext,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 3: STAY IN CONTROL
  // ===========================================================================
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Illustration Graphic Card
          _buildGraphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(AppLocalizations.of(context).obControls,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: RaayColors.textPrimaryOf(context))),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(Icons.tune_rounded,
                          size: 14, color: RaayColors.of(context).accentText),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context).obCodes,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: RaayColors.textPrimaryOf(context))),
                          Text(AppLocalizations.of(context).obCodesSub,
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      RaayColors.textSecondaryOf(context))),
                        ],
                      )),
                      Icon(Icons.toggle_on_rounded,
                          color: RaayColors.of(context).accentText, size: 22),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context).obLog,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: RaayColors.textPrimaryOf(context))),
                const SizedBox(height: 4),
                _miniLogItem(AppLocalizations.of(context).obLogAdded, '09:32'),
                _miniLogItem(
                    AppLocalizations.of(context).obLogElection, '09:15'),
              ],
            ),
          ),

          const Spacer(),

          // Category Badge & Titles
          _buildTextContent(
            tag: AppLocalizations.of(context).obTag3,
            title: AppLocalizations.of(context).obTitle3,
            subtitle: AppLocalizations.of(context).obBody3,
          ),

          const SizedBox(height: 16),

          // Bottom Callout
          _buildCalloutBox(
            icon: Icons.shield_outlined,
            title: AppLocalizations.of(context).obCallout3,
            text: AppLocalizations.of(context).obCallout3b,
          ),

          const Spacer(),

          // Bottom Controls (3 of 3 + Back & Continue)
          _buildBottomControls(
            pageIndex: 3,
            onBack: _previousPage,
            onNext: _nextPage,
            primaryLabel: AppLocalizations.of(context).obContinue,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 4: WELCOME SCREEN (Raay · Welcome)
  // ===========================================================================
  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Graphic Card
          _buildGraphicCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.people_outline_rounded,
                          color: RaayColors.of(context).accentText, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context).obComm,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: RaayColors.textPrimaryOf(context))),
                        Text(AppLocalizations.of(context).obCommSub,
                            style: TextStyle(
                                fontSize: 12,
                                color: RaayColors.textSecondaryOf(context))),
                      ],
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: RaayColors.backgroundOf(context),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Icon(Icons.how_to_vote_outlined,
                                size: 18,
                                color: RaayColors.of(context).accentText),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context).obElections,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        RaayColors.textPrimaryOf(context))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: RaayColors.backgroundOf(context),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Icon(Icons.bar_chart_rounded,
                                size: 18,
                                color: RaayColors.of(context).accentText),
                            const SizedBox(height: 4),
                            Text(AppLocalizations.of(context).obPolls,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        RaayColors.textPrimaryOf(context))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context).obTag4,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: RaayColors.of(context).accentText)),
              ],
            ),
          ),

          const Spacer(),

          // Welcome Title & Subtitle
          Text(
            AppLocalizations.of(context).obTitle4,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: RaayColors.textPrimaryOf(context),
              height: 1.2,
              letterSpacing: -0.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).obBody4,
            style: TextStyle(
              fontSize: 13,
              color: RaayColors.textSecondaryOf(context),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Action Buttons
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ref.read(hasSeenIntroProvider.notifier).markSeen();
                context.go('/register');
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context).obGetStarted,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ref.read(hasSeenIntroProvider.notifier).markSeen();
                context.go('/login');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: RaayColors.of(context).accentText,
                side: BorderSide(
                    color: RaayColors.borderOf(context), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context).obHaveAccount,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 12),

          TextButton.icon(
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              foregroundColor: RaayColors.of(context).accentText,
            ),
            onPressed: () {
              ref.read(hasSeenIntroProvider.notifier).markSeen();
              context.go('/login');
            },
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            iconAlignment: IconAlignment.end,
            label: Text(AppLocalizations.of(context).obJoin,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ===========================================================================
  // HELPER WIDGETS
  // ===========================================================================
  Widget _buildGraphicCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: RaayColors.borderOf(context)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RaayColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _illustrationActionRow(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: RaayColors.backgroundOf(context),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon,
                size: 16, color: RaayColors.of(context).accentText),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: RaayColors.textPrimaryOf(context))),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: RaayColors.textSecondaryOf(context))),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              size: 16, color: RaayColors.textSecondaryOf(context)),
        ],
      ),
    );
  }

  Widget _miniLogItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: RaayColors.of(context).accentText,
                        shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 12,
                          color: RaayColors.textPrimaryOf(context))),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(time,
              style: TextStyle(
                  fontSize: 12, color: RaayColors.textSecondaryOf(context))),
        ],
      ),
    );
  }

  Widget _buildTextContent(
      {required String tag, required String title, required String subtitle}) {
    return Column(
      children: [
        Text(
          tag,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: RaayColors.of(context).accentText,
              letterSpacing: 0.8),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: RaayColors.textPrimaryOf(context),
            height: 1.2,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: RaayColors.textSecondaryOf(context),
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCalloutBox(
      {required IconData icon, required String title, required String text}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RaayColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RaayColors.borderOf(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon,
                color: RaayColors.of(context).accentText, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: RaayColors.textPrimaryOf(context))),
                Text(text,
                    style: TextStyle(
                        fontSize: 12,
                        color: RaayColors.textSecondaryOf(context),
                        height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls({
    required int pageIndex,
    VoidCallback? onBack,
    required VoidCallback onNext,
    required String primaryLabel,
  }) {
    return Column(
      children: [
        // Page Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (idx) {
            final isCurrent = (pageIndex - 1) == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isCurrent ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppTheme.primaryBlue
                    : RaayColors.borderOf(context),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(AppLocalizations.of(context).obPage(pageIndex.toString()),
            style: TextStyle(
                fontSize: 12, color: RaayColors.textSecondaryOf(context))),
        const SizedBox(height: 16),

        // Action Buttons Row
        Row(
          children: [
            if (onBack != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: RaayColors.textPrimaryOf(context),
                    side: BorderSide(
                        color: RaayColors.borderOf(context), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(AppLocalizations.of(context).obBack,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: FilledButton(
                onPressed: onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(primaryLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
