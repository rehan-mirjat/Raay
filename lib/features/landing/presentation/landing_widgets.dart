import '../../../l10n/app_localizations.dart';
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/gestures.dart' show PointerHoverEvent;
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import 'landing_content.dart';

const kLandingMaxWidth = 1160.0;

/// Fades and slides its child in the first time it scrolls into view. Shows
/// immediately when the user asked for reduced motion. It never changes the
/// scroll physics or delays interaction: the content is already in the tree.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child});
  final Widget child;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool _shown = false;
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_check);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_shown || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height * 0.92) {
      setState(() => _shown = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return AnimatedSlide(
      offset: _shown ? Offset.zero : const Offset(0, 0.04),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _shown ? 1 : 0,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Frosted, softly lit navigation bar. The blur is decoration only; text sits
/// on a translucent surface that keeps contrast in both themes.
class GlassBar extends StatelessWidget {
  const GlassBar({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final radius = BorderRadius.circular(20);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
              color: AppTheme.primaryBlue
                  .withValues(alpha: kc.isDark ? 0.22 : 0.12),
              blurRadius: 36,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Container(
        // 1px violet-to-teal rim light; the bar itself stays a calm frosted panel.
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(colors: [
            AppTheme.primaryBlue.withValues(alpha: kc.isDark ? 0.55 : 0.35),
            kc.border,
            AppTheme.accentTeal.withValues(alpha: kc.isDark ? 0.45 : 0.30),
          ]),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              color: kc.surface.withValues(alpha: kc.isDark ? 0.74 : 0.82),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class SectionShell extends StatelessWidget {
  const SectionShell({super.key, required this.child, this.tinted = false});
  final Widget child;
  final bool tinted;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 640;
    return Container(
      width: double.infinity,
      color: tinted ? kc.surfaceTint : Colors.transparent,
      padding: EdgeInsets.symmetric(
          horizontal: narrow ? 16 : 24, vertical: narrow ? 56 : 88),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kLandingMaxWidth),
          child: Reveal(child: child),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(
      {super.key,
      required this.eyebrow,
      required this.title,
      this.body,
      this.center = false});
  final String eyebrow;
  final String title;
  final String? body;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 640;
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final ta = center ? TextAlign.center : TextAlign.start;
    return Column(crossAxisAlignment: align, children: [
      Text(eyebrow.toUpperCase(),
          textAlign: ta,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: kc.accentText)),
      const SizedBox(height: 10),
      Semantics(
        header: true,
        child: Text(title,
            textAlign: ta,
            style: TextStyle(
                fontSize: narrow ? 28 : 38,
                height: 1.15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                color: kc.textPrimary)),
      ),
      if (body != null) ...[
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(body!,
              textAlign: ta,
              style: TextStyle(
                  fontSize: 17, height: 1.55, color: kc.textSecondary)),
        ),
      ],
    ]);
  }
}

class IconTile extends StatelessWidget {
  const IconTile(this.icon, {super.key, this.size = 48});
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: kc.isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, size: size * 0.5, color: kc.accentText),
    );
  }
}

/// A card with a consistent structure (icon tile, title, body) and a restrained
/// pointer hover. It is not a link, so it is not focusable and does not behave
/// like a button; hover only tints the border and adds a soft shadow, never
/// moves or resizes the card, and resets when the pointer leaves.
class FeatureCard extends StatefulWidget {
  const FeatureCard(this.feature, {super.key});
  final LandingFeature feature;

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    final f = widget.feature;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: reduce ? Duration.zero : const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kc.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard + 4),
          // Same 1px width in every state: colour changes, layout does not.
          border: Border.all(
              color: _hover
                  ? AppTheme.primaryBlue
                      .withValues(alpha: kc.isDark ? 0.7 : 0.55)
                  : kc.border),
          boxShadow: _hover
              ? [
                  BoxShadow(
                      color: AppTheme.primaryBlue
                          .withValues(alpha: kc.isDark ? 0.22 : 0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8))
                ]
              : const [],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTile(f.icon),
              const SizedBox(height: 16),
              Text(f.title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kc.textPrimary)),
              const SizedBox(height: 8),
              Text(f.body,
                  style: TextStyle(
                      fontSize: 15, height: 1.55, color: kc.textSecondary)),
            ]),
      ),
    );
  }
}

/// A grid that reflows by available width: 1 column on phones, 2 on tablets,
/// up to [maxColumns] on wide screens. Every row is as tall as its tallest
/// cell, so cards in a row are equal height and still grow with larger text.
class ReflowGrid extends StatelessWidget {
  const ReflowGrid(
      {super.key,
      required this.children,
      this.maxColumns = 3,
      this.minColumnWidth = 300,
      this.gap = 20});
  final List<Widget> children;
  final int maxColumns;
  final double minColumnWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = (((c.maxWidth + gap) / (minColumnWidth + gap)).floor())
          .clamp(1, maxColumns);
      final rows = <List<Widget>>[
        for (var i = 0; i < children.length; i += cols)
          children.sublist(
              i, i + cols > children.length ? children.length : i + cols),
      ];
      return Column(children: [
        for (var r = 0; r < rows.length; r++) ...[
          if (r > 0) SizedBox(height: gap),
          IntrinsicHeight(
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              for (var j = 0; j < cols; j++) ...[
                if (j > 0) SizedBox(width: gap),
                Expanded(
                    child: j < rows[r].length
                        ? rows[r][j]
                        : const SizedBox.shrink()),
              ],
            ]),
          ),
        ],
      ]);
    });
  }
}

/// An illustration of the ballot screen. It is not a live election. Picking a
/// candidate only changes this card's own preview state: nothing is submitted,
/// stored or sent, Submit stays disabled, and the card says so.
class IllustrativeBallot extends StatefulWidget {
  const IllustrativeBallot({super.key});

  @override
  State<IllustrativeBallot> createState() => _IllustrativeBallotState();
}

class _IllustrativeBallotState extends State<IllustrativeBallot> {
  List<String> _names(AppLocalizations l) => [l.ldCandA, l.ldCandB, l.ldCandC];
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kc.border),
        boxShadow: [
          BoxShadow(
              color: AppTheme.primaryBlue
                  .withValues(alpha: kc.isDark ? 0.25 : 0.14),
              blurRadius: 60,
              offset: const Offset(0, 24)),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: kc.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(AppLocalizations.of(context).ldIllus,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kc.textSecondary)),
              ),
            ]),
            const SizedBox(height: 16),
            Semantics(
              header: true,
              child: Text(AppLocalizations.of(context).ldSample,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kc.textPrimary)),
            ),
            const SizedBox(height: 4),
            Text(AppLocalizations.of(context).ldChoose,
                style: TextStyle(fontSize: 14, color: kc.textSecondary)),
            const SizedBox(height: 16),
            Semantics(
              container: true,
              label: AppLocalizations.of(context).ldSampleCands,
              child: Column(children: [
                for (var i = 0; i < 3; i++) _row(context, i),
              ]),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.visibility_off_outlined,
                  size: 16, color: kc.successText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(AppLocalizations.of(context).ldAnonBallot,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kc.successText)),
              ),
            ]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: null,
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
                child: Text(AppLocalizations.of(context).ldSubmit),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _selected == null
                  ? AppLocalizations.of(context).ldTry
                  : AppLocalizations.of(context).ldPicked(
                      (_names(AppLocalizations.of(context))[_selected!])
                          .toString()),
              style:
                  TextStyle(fontSize: 13, height: 1.4, color: kc.textSecondary),
            ),
          ]),
    );
  }

  Widget _row(BuildContext context, int i) {
    final kc = KivoraColors.of(context);
    final selected = _selected == i;
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      label: _names(AppLocalizations.of(context))[i],
      excludeSemantics: true,
      onTap: () => setState(() => _selected = i),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _selected = i),
            child: AnimatedContainer(
              duration:
                  reduce ? Duration.zero : const Duration(milliseconds: 160),
              constraints: const BoxConstraints(minHeight: 52),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryBlue
                        .withValues(alpha: kc.isDark ? 0.18 : 0.08)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: selected ? AppTheme.primaryBlue : kc.border,
                    width: 1.5),
              ),
              child: Row(children: [
                Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 22,
                    color: selected ? kc.accentText : kc.textSecondary),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(_names(AppLocalizations.of(context))[i],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kc.textPrimary))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// One-open-at-a-time accordion. Rows are real focusable controls with
/// expanded state exposed to assistive technology.
class FaqList extends StatefulWidget {
  const FaqList({super.key, required this.items});
  final List<LandingFaq> items;

  @override
  State<FaqList> createState() => _FaqListState();
}

class _FaqListState extends State<FaqList> {
  int? _open;
  int? _focused;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final reduce = MediaQuery.disableAnimationsOf(context);
    return Column(children: [
      for (var i = 0; i < widget.items.length; i++)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: kc.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(
                color: _open == i
                    ? AppTheme.primaryBlue.withValues(alpha: 0.6)
                    : kc.border),
          ),
          // Keyboard focus ring drawn on top, so it never changes the layout.
          foregroundDecoration: _focused == i
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: AppTheme.primaryBlue, width: 2),
                )
              : null,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              onFocusChange: (f) => setState(() {
                if (f) {
                  _focused = i;
                } else if (_focused == i) {
                  _focused = null;
                }
              }),
              onTap: () => setState(() => _open = _open == i ? null : i),
              child: Semantics(
                button: true,
                expanded: _open == i,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 48),
                          child: Row(children: [
                            Expanded(
                              child: Text(widget.items[i].question,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: kc.textPrimary)),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                                _open == i
                                    ? Icons.remove_rounded
                                    : Icons.add_rounded,
                                color: kc.accentText),
                          ]),
                        ),
                        AnimatedSize(
                          duration: reduce
                              ? Duration.zero
                              : const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.topCenter,
                          child: _open == i
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 6),
                                  child: Text(widget.items[i].answer,
                                      style: TextStyle(
                                          fontSize: 15,
                                          height: 1.6,
                                          color: kc.textSecondary)),
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}

/// Thin bar along the top edge showing how far down the page the reader is.
class ScrollProgressBar extends StatelessWidget {
  const ScrollProgressBar({super.key, required this.progress});
  final ValueListenable<double> progress;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: 3,
        child: ValueListenableBuilder<double>(
          valueListenable: progress,
          builder: (_, v, __) => Align(
            alignment: AlignmentDirectional.centerStart,
            child: FractionallySizedBox(
              widthFactor: v.clamp(0.0, 1.0),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [AppTheme.primaryBlue, AppTheme.accentTeal]),
                ),
                child: SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tilts its child a few degrees toward a mouse pointer. Mouse only (touch
/// never reports hover) and disabled when the user asked for reduced motion.
class TiltCard extends StatefulWidget {
  const TiltCard({super.key, required this.child});
  final Widget child;

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  double _x = 0, _y = 0;

  void _hover(PointerHoverEvent e) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final local = box.globalToLocal(e.position);
    setState(() {
      _x = (local.dx / box.size.width - 0.5).clamp(-0.5, 0.5);
      _y = (local.dy / box.size.height - 0.5).clamp(-0.5, 0.5);
    });
  }

  void _reset() => setState(() => _x = _y = 0);

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return MouseRegion(
      onHover: _hover,
      onExit: (_) => _reset(),
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(end: Offset(_x, _y)),
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        builder: (_, t, child) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..rotateX(-t.dy * 0.07)
            ..rotateY(t.dx * 0.09),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

/// The "how it works" steps as one connected timeline. Numbered markers sit on
/// a rail that fills as steps scroll into view: horizontally above equal-height
/// cards on wide screens, vertically beside the cards on narrow ones. The
/// markers and the filled rail always agree because both come from one
/// [_active] count. Cards stay readable whatever the progress.
class StepsTimeline extends StatefulWidget {
  const StepsTimeline({super.key, required this.steps});
  final List<LandingStep> steps;

  @override
  State<StepsTimeline> createState() => _StepsTimelineState();
}

class _StepsTimelineState extends State<StepsTimeline> {
  static const _marker = 40.0;
  static const _gap = 20.0;
  static const _wideMinWidth = 4 * 220.0 + 3 * _gap;

  late final List<GlobalKey> _keys = [
    for (final _ in widget.steps) GlobalKey()
  ];
  ScrollPosition? _position;
  int _active = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_update);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  @override
  void dispose() {
    _position?.removeListener(_update);
    super.dispose();
  }

  /// Number of steps whose card top has entered the upper part of the screen.
  void _update() {
    if (!mounted) return;
    final h = MediaQuery.sizeOf(context).height;
    var n = 0;
    for (var i = 0; i < _keys.length; i++) {
      final box = _keys[i].currentContext?.findRenderObject();
      if (box is RenderBox &&
          box.attached &&
          box.hasSize &&
          box.localToGlobal(Offset.zero).dy < h * 0.78) {
        n = i + 1;
      }
    }
    if (n != _active) setState(() => _active = n);
  }

  Duration get _anim => MediaQuery.disableAnimationsOf(context)
      ? Duration.zero
      : const Duration(milliseconds: 450);

  Widget _markerFor(int i) {
    final kc = KivoraColors.of(context);
    final on = i < _active;
    return AnimatedContainer(
      duration: _anim,
      width: _marker,
      height: _marker,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? AppTheme.primaryBlue : kc.surface,
        border:
            Border.all(color: on ? AppTheme.primaryBlue : kc.border, width: 2),
      ),
      child: Text('${i + 1}',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: on ? Colors.white : kc.textSecondary)),
    );
  }

  Widget _card(int i, {Key? key}) {
    final kc = KivoraColors.of(context);
    final on = i < _active;
    return AnimatedContainer(
      key: key,
      duration: _anim,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard + 4),
        border: Border.all(
            color: on ? AppTheme.primaryBlue.withValues(alpha: 0.6) : kc.border,
            width: on ? 1.5 : 1),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.steps[i].title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kc.textPrimary)),
            const SizedBox(height: 8),
            Text(widget.steps[i].body,
                style: TextStyle(
                    fontSize: 15, height: 1.55, color: kc.textSecondary)),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final n = widget.steps.length;
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth >= _wideMinWidth) return _wide(kc, c.maxWidth, n);
      return _narrow(kc, n);
    });
  }

  Widget _wide(KivoraColors kc, double width, int n) {
    final colW = (width - _gap * (n - 1)) / n;
    final pitch = colW + _gap;
    // The rail runs from the first marker's centre to the last marker's centre;
    // its fill ends at the centre of the last active marker.
    const railLeft = _marker / 2;
    final railWidth = pitch * (n - 1);
    final fill = _active <= 1 ? 0.0 : pitch * (_active - 1);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: _marker,
        child: Stack(children: [
          PositionedDirectional(
            start: railLeft,
            top: _marker / 2 - 2,
            width: railWidth,
            height: 4,
            child: DecoratedBox(
                decoration: BoxDecoration(
                    color: kc.border, borderRadius: BorderRadius.circular(2))),
          ),
          PositionedDirectional(
            start: railLeft,
            top: _marker / 2 - 2,
            height: 4,
            child: AnimatedContainer(
              duration: _anim,
              curve: Curves.easeOutCubic,
              width: fill,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppTheme.primaryBlue, AppTheme.accentTeal]),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          for (var i = 0; i < n; i++)
            PositionedDirectional(start: pitch * i, top: 0, child: _markerFor(i)),
        ]),
      ),
      const SizedBox(height: 16),
      IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < n; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            Expanded(child: _card(i, key: _keys[i])),
          ],
        ]),
      ),
    ]);
  }

  Widget _narrow(KivoraColors kc, int n) {
    return Column(children: [
      for (var i = 0; i < n; i++)
        IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              width: _marker,
              child: Column(children: [
                _markerFor(i),
                if (i < n - 1)
                  Expanded(
                    child: Center(
                      child: AnimatedContainer(
                        duration: _anim,
                        width: 4,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                            color: i + 1 < _active
                                ? AppTheme.primaryBlue
                                : kc.border,
                            borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                  ),
              ]),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: i < n - 1 ? 16 : 0),
                child: _card(i, key: _keys[i]),
              ),
            ),
          ]),
        ),
    ]);
  }
}

/// The "Still need a hand?" card beside the FAQ.
class HelpCard extends StatelessWidget {
  const HelpCard({super.key, required this.onTransparency});
  final VoidCallback onTransparency;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kc.surfaceTint,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard + 4),
        border: Border.all(color: kc.border),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconTile(Icons.support_agent_rounded),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context).ldHelpTitle,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kc.textPrimary)),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).ldHelpBody,
                style: TextStyle(
                    fontSize: 15, height: 1.55, color: kc.textSecondary)),
            const SizedBox(height: 16),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: onTransparency,
              child: Text(AppLocalizations.of(context).ldHelpOpen),
            ),
          ]),
    );
  }
}
