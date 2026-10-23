import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/theme/theme_provider.dart';
import 'landing_content.dart';
import 'landing_widgets.dart';

/// Public landing page. Every button goes to an existing route or scrolls to a
/// section on this page; see landing_content.dart for where each claim comes
/// from.
class LandingPageScreen extends ConsumerStatefulWidget {
  const LandingPageScreen({super.key});

  @override
  ConsumerState<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends ConsumerState<LandingPageScreen> {
  final _scroll = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _featuresKey = GlobalKey();
  final _howKey = GlobalKey();
  final _orgsKey = GlobalKey();
  final _securityKey = GlobalKey();
  final _faqKey = GlobalKey();

  final _progress = ValueNotifier<double>(0);
  final _active = ValueNotifier<int>(-1); // index into the section links
  final _glow = ValueNotifier<Offset?>(null);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    _progress.value = max > 0 ? (_scroll.offset / max).clamp(0.0, 1.0) : 0;

    // Scroll-spy: the last section whose top has passed 35% of the viewport.
    final line = MediaQuery.sizeOf(context).height * 0.35;
    var current = -1;
    final keys = [_featuresKey, _howKey, _orgsKey, _securityKey];
    for (var i = 0; i < keys.length; i++) {
      final box = keys[i].currentContext?.findRenderObject();
      if (box is RenderBox &&
          box.attached &&
          box.localToGlobal(Offset.zero).dy <= line) {
        current = i;
      }
    }
    // Past the last linked section into the FAQ and footer: nothing is active.
    final faq = _faqKey.currentContext?.findRenderObject();
    if (faq is RenderBox &&
        faq.attached &&
        faq.localToGlobal(Offset.zero).dy <= line) {
      current = -1;
    }
    _active.value = current;
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _progress.dispose();
    _active.dispose();
    _glow.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ---- actions (all real) ---------------------------------------------------

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    final reduce = MediaQuery.disableAnimationsOf(context);
    Scrollable.ensureVisible(ctx,
        duration: reduce ? Duration.zero : const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic);
  }

  void _top() => _scroll.animateTo(0,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 450),
      curve: Curves.easeInOut);

  void _go(String route) => context.go(route);
  void _open(String route) => context.push(route);

  void _toggleTheme() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    ref
        .read(themeModeProvider.notifier)
        .setMode(dark ? ThemeMode.light : ThemeMode.dark);
  }

  List<_NavItem> get _navItems => [
        _NavItem('Features', () => _scrollTo(_featuresKey), section: 0),
        _NavItem('How it works', () => _scrollTo(_howKey), section: 1),
        _NavItem('Organizations', () => _scrollTo(_orgsKey), section: 2),
        _NavItem('Security & privacy', () => _scrollTo(_securityKey),
            section: 3),
        _NavItem('Transparency', () => _open('/transparency')),
      ];

  // ---- build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final largeText = MediaQuery.textScalerOf(context).scale(14) / 14 > 1.3;
    // Six links and two buttons need about 1100px; below that, or at large text,
    // the menu moves into the drawer instead of overflowing.
    final inline = width >= 1100 && !largeText;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      endDrawer: inline ? null : _drawer(context),
      body: MouseRegion(
        // Mouse only: touch never reports hover. Skipped for reduced motion.
        onHover: MediaQuery.disableAnimationsOf(context)
            ? null
            : (e) => _glow.value = e.localPosition,
        onExit: (_) => _glow.value = null,
        child: Stack(children: [
          const Positioned.fill(child: _AmbientGlow()),
          Positioned.fill(child: _CursorGlow(position: _glow)),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(children: [
                const SizedBox(height: 92),
                _hero(context, width),
                _trustStrip(context),
                KeyedSubtree(key: _featuresKey, child: _features(context)),
                KeyedSubtree(key: _howKey, child: _howItWorks(context)),
                KeyedSubtree(key: _orgsKey, child: _organizations(context)),
                KeyedSubtree(key: _securityKey, child: _security(context)),
                _anonymous(context),
                _receipt(context),
                KeyedSubtree(key: _faqKey, child: _faq(context)),
                _finalCta(context),
                _footer(context),
              ]),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    width < 640 ? 10 : 20, 12, width < 640 ? 10 : 20, 0),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: kLandingMaxWidth),
                    child: GlassBar(child: _navBar(context, inline)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ScrollProgressBar(progress: _progress),
          ),
        ]),
      ),
    );
  }

  // ---- navigation ------------------------------------------------------------

  Widget _navBar(BuildContext context, bool inline) {
    final kc = KivoraColors.of(context);
    final dark = kc.isDark;
    final brand = Semantics(
      button: true,
      label: 'Kivora, back to top',
      child: InkWell(
        onTap: _top,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/icon/app_icon.png',
                  width: 36, height: 36, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text('Kivora',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: kc.textPrimary)),
            ),
          ]),
        ),
      ),
    );
    final theme = IconButton(
      tooltip: dark ? 'Switch to light theme' : 'Switch to dark theme',
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      onPressed: _toggleTheme,
      icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          color: kc.textPrimary),
    );

    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 16, end: 8, top: 4, bottom: 4),
      child: Row(children: [
        if (inline)
          brand
        else
          Expanded(
              child: Align(
                  alignment: AlignmentDirectional.centerStart, child: brand)),
        if (inline) ...[
          const SizedBox(width: 24),
          Expanded(
            // scaleDown keeps the links on one line whatever the font metrics.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                for (final item in _navItems)
                  ValueListenableBuilder<int>(
                    valueListenable: _active,
                    builder: (_, active, __) {
                      final on = item.section != null && item.section == active;
                      return Semantics(
                        selected: on,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            foregroundColor:
                                on ? kc.accentText : kc.textSecondary,
                            backgroundColor: on
                                ? AppTheme.primaryBlue
                                    .withValues(alpha: kc.isDark ? 0.16 : 0.08)
                                : Colors.transparent,
                            textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    on ? FontWeight.w800 : FontWeight.w600),
                          ),
                          onPressed: item.onTap,
                          child: Text(item.label),
                        ),
                      );
                    },
                  ),
              ]),
            ),
          ),
          theme,
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: kc.textPrimary),
            onPressed: () => _go('/login'),
            child: const Text('Sign in',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 4),
          FilledButton(
            style: FilledButton.styleFrom(
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.symmetric(horizontal: 20)),
            onPressed: () => _go('/register'),
            child: const Text('Get started'),
          ),
        ] else ...[
          theme,
          IconButton(
            tooltip: 'Menu',
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: Icon(Icons.menu_rounded, color: kc.textPrimary),
          ),
        ],
      ]),
    );
  }

  Widget _drawer(BuildContext context) {
    final kc = KivoraColors.of(context);
    Widget tile(String label, VoidCallback onTap) => ListTile(
          minVerticalPadding: 12,
          title: Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kc.textPrimary)),
          onTap: () {
            Navigator.of(context).pop();
            // Let the drawer close before the page moves.
            Future.delayed(const Duration(milliseconds: 220), () {
              if (mounted) onTap();
            });
          },
        );
    return Drawer(
      backgroundColor: kc.surface,
      child: SafeArea(
        child: ListView(padding: const EdgeInsets.all(12), children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              tooltip: 'Close menu',
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          for (final item in _navItems) tile(item.label, item.onTap),
          tile('Verify a receipt', () => _open('/receipt-verify')),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _go('/login');
                    },
                    child: const Text('Sign in'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _go('/register');
                    },
                    child: const Text('Get started'),
                  ),
                ]),
          ),
        ]),
      ),
    );
  }

  // ---- sections --------------------------------------------------------------

  Widget _hero(BuildContext context, double width) {
    final kc = KivoraColors.of(context);
    final wide = width >= 960;
    final narrow = width < 640;

    final text = Column(
      crossAxisAlignment:
          wide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color:
                AppTheme.primaryBlue.withValues(alpha: kc.isDark ? 0.18 : 0.09),
            borderRadius: BorderRadius.circular(999),
            border:
                Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
          ),
          child: Text('Kivora · secure e-voting and polling',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kc.accentText)),
        ),
        const SizedBox(height: 22),
        Semantics(
          header: true,
          child: Text('Run fair elections for your organization.',
              textAlign: wide ? TextAlign.start : TextAlign.center,
              style: TextStyle(
                  fontSize: narrow ? 36 : (wide ? 58 : 48),
                  height: 1.08,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.4,
                  color: kc.textPrimary)),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
              'Hold elections and polls for your members, choose between anonymous and identifiable voting, and let the server enforce eligibility, timing and one vote per person.',
              textAlign: wide ? TextAlign.start : TextAlign.center,
              style: TextStyle(
                  fontSize: narrow ? 16 : 18,
                  height: 1.6,
                  color: kc.textSecondary)),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: wide ? WrapAlignment.start : WrapAlignment.center,
          children: [
            FilledButton(
              style: FilledButton.styleFrom(
                  minimumSize: const Size(48, 52),
                  padding: const EdgeInsets.symmetric(horizontal: 28)),
              onPressed: () => _go('/register'),
              child: const Text('Get started',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 52),
                  padding: const EdgeInsets.symmetric(horizontal: 28)),
              onPressed: () => _go('/login'),
              child: const Text('Sign in',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: wide ? WrapAlignment.start : WrapAlignment.center,
          children: [
            Text('Have a joining code or invitation?  ',
                style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            TextButton(
              style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  foregroundColor: kc.accentText),
              // Joining needs an account, so this opens registration; the join
              // screen is reached from Organizations after signing in.
              onPressed: () => _go('/register'),
              child: const Text('Create an account to join',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(narrow ? 16 : 24, narrow ? 24 : 40,
          narrow ? 16 : 24, narrow ? 40 : 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kLandingMaxWidth),
          child: Reveal(
            child: wide
                ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(flex: 6, child: text),
                    const SizedBox(width: 48),
                    const Expanded(
                        flex: 5,
                        child: Center(
                            child: TiltCard(child: IllustrativeBallot()))),
                  ])
                : Column(children: [
                    text,
                    const SizedBox(height: 40),
                    const IllustrativeBallot()
                  ]),
          ),
        ),
      ),
    );
  }

  Widget _trustStrip(BuildContext context) {
    return SectionShell(
      tinted: true,
      child: ReflowGrid(
        maxColumns: 3,
        minColumnWidth: 280,
        children: [for (final p in landingTrustPoints) _trustItem(context, p)],
      ),
    );
  }

  Widget _trustItem(BuildContext context, LandingFeature p) {
    final kc = KivoraColors.of(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      IconTile(p.icon, size: 44),
      const SizedBox(width: 14),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kc.textPrimary)),
          const SizedBox(height: 4),
          Text(p.body,
              style: TextStyle(
                  fontSize: 14, height: 1.5, color: kc.textSecondary)),
        ]),
      ),
    ]);
  }

  Widget _features(BuildContext context) => SectionShell(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(
            eyebrow: 'Built for collective decisions',
            title: 'One place to vote and to manage who can.',
            body:
                'From choosing representatives to settling a yes/no question, every vote has a clear home.',
          ),
          const SizedBox(height: 40),
          ReflowGrid(
              children: [for (final f in landingFeatures) FeatureCard(f)]),
        ]),
      );

  Widget _howItWorks(BuildContext context) {
    return SectionShell(
      tinted: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(
          eyebrow: 'How it works',
          title: 'A clear path from setup to result.',
          body:
              'Make participation straightforward for organizers and members alike.',
        ),
        const SizedBox(height: 40),
        const StepsTimeline(steps: landingSteps),
        const SizedBox(height: 32),
        FilledButton(
          style: FilledButton.styleFrom(
              minimumSize: const Size(48, 52),
              padding: const EdgeInsets.symmetric(horizontal: 28)),
          onPressed: () => _go('/register'),
          child: const Text('Start with Kivora',
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  Widget _organizations(BuildContext context) => SectionShell(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(
            eyebrow: 'For every kind of organization',
            title: 'Your community, represented.',
            body:
                'Kivora organizations are set up as one of these types, then shaped around the people who take part.',
          ),
          const SizedBox(height: 40),
          ReflowGrid(maxColumns: 5, minColumnWidth: 200, gap: 16, children: [
            for (final t in landingOrgTypes) FeatureCard(t),
          ]),
        ]),
      );

  Widget _security(BuildContext context) {
    final kc = KivoraColors.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 960;
    final header =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(
        eyebrow: 'Security & privacy',
        title: 'Trust built into every step.',
        body:
            'The rules that matter run on the server, and the voting mode is visible to members before they choose.',
      ),
      const SizedBox(height: 24),
      OutlinedButton(
        style: OutlinedButton.styleFrom(
            minimumSize: const Size(48, 52),
            padding: const EdgeInsets.symmetric(horizontal: 24)),
        onPressed: () => _open('/transparency'),
        child: const Text('Explore transparency',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    ]);
    final points = ReflowGrid(
      maxColumns: 2,
      minColumnWidth: 240,
      gap: 16,
      children: [
        for (final p in landingSecurityPoints)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kc.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard + 2),
              border: Border.all(color: kc.border),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(p.icon, color: kc.successText),
                  const SizedBox(height: 12),
                  Text(p.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kc.textPrimary)),
                  const SizedBox(height: 6),
                  Text(p.body,
                      style: TextStyle(
                          fontSize: 14, height: 1.5, color: kc.textSecondary)),
                ]),
          ),
      ],
    );
    return SectionShell(
      tinted: true,
      child: wide
          ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 4, child: header),
              const SizedBox(width: 56),
              Expanded(flex: 6, child: points),
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [header, const SizedBox(height: 32), points]),
    );
  }

  Widget _anonymous(BuildContext context) {
    final kc = KivoraColors.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 860;
    Widget card(IconData icon, String title, String body) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kc.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard + 4),
            border: Border.all(color: kc.border),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTile(icon),
                const SizedBox(height: 14),
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kc.textPrimary)),
                const SizedBox(height: 6),
                Text(body,
                    style: TextStyle(
                        fontSize: 15, height: 1.55, color: kc.textSecondary)),
              ]),
        );
    final a = card(Icons.how_to_reg_rounded, 'Participation record',
        'Records that an eligible member voted, so nobody can vote twice. It does not hold the choice in an anonymous vote.');
    final b = card(Icons.ballot_rounded, 'Ballot record',
        'Holds the choice. In an anonymous vote it has no field linking it to the voter\'s account.');
    final link = Padding(
      padding: const EdgeInsets.all(12),
      child: Icon(wide ? Icons.sync_alt_rounded : Icons.swap_vert_rounded,
          size: 32, color: kc.accentText),
    );
    return SectionShell(
      child: Column(children: [
        const SectionHeader(
          eyebrow: 'Anonymous voting',
          title: 'Participation is recorded. Ballots stay separate.',
          body:
              'Two separate records let Kivora prevent double voting while keeping an anonymous choice anonymous.',
          center: true,
        ),
        const SizedBox(height: 40),
        wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Expanded(child: a), link, Expanded(child: b)])
            : Column(children: [a, link, b]),
      ]),
    );
  }

  Widget _receipt(BuildContext context) {
    final kc = KivoraColors.of(context);
    return SectionShell(
      tinted: true,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: kc.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kc.border),
        ),
        child: LayoutBuilder(builder: (context, c) {
          final row = c.maxWidth >= 720;
          const text =
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SectionHeader(
              eyebrow: 'Verify a receipt',
              title: 'Check a receipt without an account.',
              body:
                  'Paste a receipt hash to confirm that a ballot with that receipt exists. It does not reveal a choice or a voter, and it is a record-existence check, not a formal proof of the whole process.',
            ),
          ]);
          final button = FilledButton.icon(
            style: FilledButton.styleFrom(
                minimumSize: const Size(48, 52),
                padding: const EdgeInsets.symmetric(horizontal: 24)),
            onPressed: () => _open('/receipt-verify'),
            icon: const Icon(Icons.verified_outlined),
            label: const Text('Verify a receipt',
                style: TextStyle(fontWeight: FontWeight.w700)),
          );
          return row
              ? Row(children: [
                  const Expanded(child: text),
                  const SizedBox(width: 32),
                  button
                ])
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [text, const SizedBox(height: 24), button]);
        }),
      ),
    );
  }

  Widget _faq(BuildContext context) {
    return SectionShell(
      child: Column(children: [
        const SectionHeader(
          eyebrow: 'Frequently asked questions',
          title: 'Good decisions start with clear answers.',
          center: true,
        ),
        const SizedBox(height: 36),
        LayoutBuilder(builder: (context, c) {
          final help = HelpCard(onTransparency: () => _open('/transparency'));
          if (c.maxWidth >= 960) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Expanded(child: FaqList(items: landingFaqs)),
              const SizedBox(width: 32),
              SizedBox(width: 320, child: help),
            ]);
          }
          return Column(children: [
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: const FaqList(items: landingFaqs)),
            const SizedBox(height: 12),
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820), child: help),
          ]);
        }),
      ]),
    );
  }

  Widget _finalCta(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 640;
    return SectionShell(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: narrow ? 24 : 56, vertical: narrow ? 40 : 64),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDark]),
        ),
        child: Column(children: [
          Semantics(
            header: true,
            child: Text('Make your next decision count.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: narrow ? 28 : 40,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    color: Colors.white)),
          ),
          const SizedBox(height: 14),
          const Text('Give every member a clear, secure way to be heard.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, height: 1.5, color: Colors.white)),
          const SizedBox(height: 28),
          Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryBlueDark,
                      minimumSize: const Size(48, 52),
                      padding: const EdgeInsets.symmetric(horizontal: 28)),
                  onPressed: () => _go('/register'),
                  child: const Text('Get started',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      // The app theme fills outlined buttons with the surface
                      // colour; on the violet panel that hides the white label.
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      minimumSize: const Size(48, 52),
                      padding: const EdgeInsets.symmetric(horizontal: 28)),
                  onPressed: () => _go('/login'),
                  child: const Text('Sign in',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ]),
        ]),
      ),
    );
  }

  Widget _footer(BuildContext context) {
    final kc = KivoraColors.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 640;
    Widget link(String label, VoidCallback onTap) => TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 48),
            alignment: AlignmentDirectional.centerStart,
            foregroundColor: kc.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          onPressed: onTap,
          child: Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        );
    Widget col(String title, List<Widget> links) =>
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 4),
            child: Text(title,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: kc.textPrimary)),
          ),
          ...links,
        ]);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: kc.surface, border: Border(top: BorderSide(color: kc.border))),
      padding: EdgeInsets.symmetric(horizontal: narrow ? 16 : 24, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kLandingMaxWidth),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ReflowGrid(maxColumns: 4, minColumnWidth: 200, gap: 28, children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset('assets/icon/app_icon.png',
                              width: 32, height: 32, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text('Kivora',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: kc.textPrimary)),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Text('Secure e-voting and polling for organizations.',
                          style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: kc.textSecondary)),
                    ]),
              ),
              col('Product', [
                link('Features', () => _scrollTo(_featuresKey)),
                link('How it works', () => _scrollTo(_howKey)),
                link('Organizations', () => _scrollTo(_orgsKey)),
              ]),
              col('Trust', [
                link('Security & privacy', () => _scrollTo(_securityKey)),
                link('Transparency', () => _open('/transparency')),
                link('Verify a receipt', () => _open('/receipt-verify')),
              ]),
              col('Account', [
                link('Sign in', () => _go('/login')),
                link('Create an account', () => _go('/register')),
                link('FAQ', () => _scrollTo(_faqKey)),
              ]),
            ]),
            const SizedBox(height: 28),
            Divider(color: kc.border),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 4,
              spacing: 16,
              children: [
                Text('© 2026 Sonryan Technologies. All rights reserved.',
                    style: TextStyle(fontSize: 13, color: kc.textSecondary)),
                TextButton.icon(
                  style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      foregroundColor: kc.textSecondary),
                  onPressed: _top,
                  icon: const Icon(Icons.arrow_upward_rounded, size: 16),
                  label: const Text('Back to top'),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.onTap, {this.section});
  final String label;
  final VoidCallback onTap;

  /// Index of the page section this link scrolls to, for the active highlight.
  final int? section;
}

/// Soft violet and teal light behind the page. Decorative only.
class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    final dark = KivoraColors.of(context).isDark;
    Widget orb(Color c, double size) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              c.withValues(alpha: dark ? 0.20 : 0.14),
              c.withValues(alpha: 0)
            ]),
          ),
        );
    return IgnorePointer(
      child: ExcludeSemantics(
        child: Stack(clipBehavior: Clip.hardEdge, children: [
          Positioned(
              top: -160, right: -120, child: orb(AppTheme.primaryBlue, 560)),
          Positioned(
              top: 380, left: -200, child: orb(AppTheme.accentTeal, 460)),
        ]),
      ),
    );
  }
}

/// A faint light that follows the mouse pointer. Decorative, mouse only.
class _CursorGlow extends StatelessWidget {
  const _CursorGlow({required this.position});
  final ValueListenable<Offset?> position;

  @override
  Widget build(BuildContext context) {
    final dark = KivoraColors.of(context).isDark;
    return IgnorePointer(
      child: ExcludeSemantics(
        child: ValueListenableBuilder<Offset?>(
          valueListenable: position,
          builder: (_, p, __) => Stack(children: [
            if (p != null)
              Positioned(
                left: p.dx - 220,
                top: p.dy - 220,
                child: Container(
                  width: 440,
                  height: 440,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      AppTheme.primaryBlue
                          .withValues(alpha: dark ? 0.16 : 0.09),
                      AppTheme.primaryBlue.withValues(alpha: 0),
                    ]),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
