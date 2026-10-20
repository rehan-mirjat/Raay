import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
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
      backgroundColor: KivoraColors.backgroundOf(context),
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
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                  _buildWelcomePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TOP BAR (Kivora Official Logo Asset + Brand Name + Skip Action)
  // ===========================================================================
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
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
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: KivoraColors.textPrimaryOf(context),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          if (_currentPage < 3)
            TextButton(
              onPressed: _skipToWelcome,
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: const Text('Skip',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
                    Text('Your organization',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textPrimaryOf(context))),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.corporate_fare_outlined,
                          size: 14, color: AppTheme.primaryBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _illustrationActionRow(
                    Icons.add_rounded,
                    'Create an organization',
                    'Start a space for your community'),
                const SizedBox(height: 8),
                _illustrationActionRow(Icons.person_add_outlined,
                    'Join an organization', 'Use your code or invitation'),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.key_outlined,
                        size: 12, color: AppTheme.primaryBlue),
                    SizedBox(width: 6),
                    Text('An invitation brings you right in.',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Category Badge & Titles
          _buildTextContent(
            tag: 'YOUR COMMUNITY, CONNECTED',
            title: 'Create or join\nan organization',
            subtitle:
                'Bring your people together. Create a home for your elections and polls, or join with an invitation code.',
          ),

          const SizedBox(height: 16),

          // Bottom Callout
          _buildCalloutBox(
            icon: Icons.groups_outlined,
            title: 'One home for shared decisions',
            text:
                'Connect your members, elections and polls in one organization.',
          ),

          const Spacer(),

          // Bottom Controls (1 of 3 + Next button)
          _buildBottomControls(
            pageIndex: 1,
            onNext: _nextPage,
            primaryLabel: 'Next',
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
                    Text('EXAMPLE BALLOT',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textSecondaryOf(context))),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.how_to_vote_outlined,
                          size: 14, color: AppTheme.primaryBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Student council 2026',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context))),
                Text('President · Choose one candidate',
                    style:
                        TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context))),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primaryBlue)),
                  child: const Row(
                    children: [
                      Icon(Icons.radio_button_checked_rounded,
                          size: 14, color: AppTheme.primaryBlue),
                      SizedBox(width: 8),
                      Text('Alex Morgan',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue)),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      color: KivoraColors.backgroundOf(context),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.radio_button_unchecked_rounded,
                          size: 14, color: KivoraColors.textSecondaryOf(context)),
                      const SizedBox(width: 8),
                      Text('Jordan Lee',
                          style: TextStyle(
                              fontSize: 12, color: KivoraColors.textPrimaryOf(context))),
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
                    child: const Text('Review vote',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Category Badge & Titles
          _buildTextContent(
            tag: 'EVERY VOICE MATTERS',
            title: 'Vote with confidence',
            subtitle:
                'Make your voice count in elections and polls. Review your options, choose, and submit your vote.',
          ),

          const SizedBox(height: 16),

          // Bottom Callout
          _buildCalloutBox(
            icon: Icons.lock_outline_rounded,
            title: 'Your choice stays private',
            text:
                'Private ballots protect your choices while keeping the process accountable.',
          ),

          const Spacer(),

          // Bottom Controls (2 of 3 + Back & Next)
          _buildBottomControls(
            pageIndex: 2,
            onBack: _previousPage,
            onNext: _nextPage,
            primaryLabel: 'Next',
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
                    Text('Organization settings',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: KivoraColors.textPrimaryOf(context))),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.tune_rounded,
                          size: 14, color: AppTheme.primaryBlue),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Member verification',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textPrimaryOf(context))),
                          Text('Approval required',
                              style: TextStyle(
                                  fontSize: 9, color: KivoraColors.textSecondaryOf(context))),
                        ],
                      ),
                      const Icon(Icons.toggle_on_rounded,
                          color: AppTheme.primaryBlue, size: 22),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text('Activity log',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context))),
                const SizedBox(height: 4),
                _miniLogItem('Member approved', '09:32'),
                _miniLogItem('Election created', '09:15'),
              ],
            ),
          ),

          const Spacer(),

          // Category Badge & Titles
          _buildTextContent(
            tag: 'CLEAR RULES. CLEAR RECORDS.',
            title: 'Stay in control',
            subtitle:
                'Set clear rules for your organization. Manage member verification and follow important actions in the activity log.',
          ),

          const SizedBox(height: 16),

          // Bottom Callout
          _buildCalloutBox(
            icon: Icons.shield_outlined,
            title: 'Private choices. Accountable actions.',
            text:
                'Verification controls who can take part. Activity logs keep administrative actions on record.',
          ),

          const Spacer(),

          // Bottom Controls (3 of 3 + Back & Continue)
          _buildBottomControls(
            pageIndex: 3,
            onBack: _previousPage,
            onNext: _nextPage,
            primaryLabel: 'Continue',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 4: WELCOME SCREEN (Kivora · Welcome)
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
                      child: const Icon(Icons.people_outline_rounded,
                          color: AppTheme.primaryBlue, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your community',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: KivoraColors.textPrimaryOf(context))),
                        Text('A shared place to decide',
                            style: TextStyle(
                                fontSize: 10, color: KivoraColors.textSecondaryOf(context))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: KivoraColors.backgroundOf(context),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const Icon(Icons.how_to_vote_outlined,
                                size: 18, color: AppTheme.primaryBlue),
                            const SizedBox(height: 4),
                            Text('Elections',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: KivoraColors.textPrimaryOf(context))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: KivoraColors.backgroundOf(context),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const Icon(Icons.bar_chart_rounded,
                                size: 18, color: AppTheme.primaryBlue),
                            const SizedBox(height: 4),
                            Text('Polls',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: KivoraColors.textPrimaryOf(context))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Better decisions, together.',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue)),
              ],
            ),
          ),

          const Spacer(),

          // Welcome Title & Subtitle
          Text(
            'Give your organization\na voice.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: KivoraColors.textPrimaryOf(context),
              height: 1.2,
              letterSpacing: -0.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Create a home for your elections and polls. Bring your members in, and move forward together with Kivora.',
            style: TextStyle(
              fontSize: 13,
              color: KivoraColors.textSecondaryOf(context),
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
              child: const Text('Get started',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                foregroundColor: AppTheme.primaryBlue,
                side: BorderSide(color: KivoraColors.borderOf(context), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('I already have an account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(height: 12),

          InkWell(
            onTap: () {
              ref.read(hasSeenIntroProvider.notifier).markSeen();
              context.go('/login');
            },
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Join an organization ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue)),
                  Icon(Icons.arrow_forward_rounded,
                      size: 14, color: AppTheme.primaryBlue),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'By continuing, you agree to our Terms and Privacy Policy.',
            style: TextStyle(fontSize: 10, color: KivoraColors.textSecondaryOf(context)),
            textAlign: TextAlign.center,
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
        border: Border.all(color: KivoraColors.borderOf(context)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: KivoraColors.surfaceOf(context),
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
          color: KivoraColors.backgroundOf(context),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: AppTheme.primaryBlue),
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
                        color: KivoraColors.textPrimaryOf(context))),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 10, color: KivoraColors.textSecondaryOf(context))),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              size: 16, color: KivoraColors.textSecondaryOf(context)),
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
          Row(
            children: [
              Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      color: AppTheme.primaryBlue, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 10, color: KivoraColors.textPrimaryOf(context))),
            ],
          ),
          Text(time,
              style:
                  TextStyle(fontSize: 9, color: KivoraColors.textSecondaryOf(context))),
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
          style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
              letterSpacing: 0.8),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: KivoraColors.textPrimaryOf(context),
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
            color: KivoraColors.textSecondaryOf(context),
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
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: KivoraColors.borderOf(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context))),
                Text(text,
                    style: TextStyle(
                        fontSize: 10,
                        color: KivoraColors.textSecondaryOf(context),
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
                color: isCurrent ? AppTheme.primaryBlue : KivoraColors.borderOf(context),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text('$pageIndex of 3',
            style:
                TextStyle(fontSize: 10, color: KivoraColors.textSecondaryOf(context))),
        const SizedBox(height: 16),

        // Action Buttons Row
        Row(
          children: [
            if (onBack != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KivoraColors.textPrimaryOf(context),
                    side: BorderSide(
                        color: KivoraColors.borderOf(context), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back',
                      style: TextStyle(fontWeight: FontWeight.bold)),
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
