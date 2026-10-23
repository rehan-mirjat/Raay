import 'dart:ui' show ImageFilter;

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
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            decoration: BoxDecoration(
              color: kc.surface.withValues(alpha: kc.isDark ? 0.72 : 0.80),
              borderRadius: radius,
              border: Border.all(color: kc.border.withValues(alpha: 0.9)),
            ),
            child: child,
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

class FeatureCard extends StatelessWidget {
  const FeatureCard(this.feature, {super.key});
  final LandingFeature feature;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Container(
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
            IconTile(feature.icon),
            const SizedBox(height: 16),
            Text(feature.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kc.textPrimary)),
            const SizedBox(height: 8),
            Text(feature.body,
                style: TextStyle(
                    fontSize: 15, height: 1.55, color: kc.textSecondary)),
          ]),
    );
  }
}

/// A grid that reflows by available width: 1 column on phones, 2 on tablets,
/// [maxColumns] on wide screens. Cells size to their content.
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
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final ch in children) SizedBox(width: w, child: ch)],
      );
    });
  }
}

/// An illustration of the ballot screen. It is not a live election: every
/// control is inert and the card says so.
class IllustrativeBallot extends StatelessWidget {
  const IllustrativeBallot({super.key});

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Semantics(
      label:
          'Illustration of a ballot screen. Not a live election and not interactive.',
      excludeSemantics: true,
      child: IgnorePointer(
        child: Container(
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
                    child: Text('Illustration, not a live election',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kc.textSecondary)),
                  ),
                ]),
                const SizedBox(height: 16),
                Text('Sample ballot',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: kc.textPrimary)),
                const SizedBox(height: 4),
                Text('Choose one candidate.',
                    style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                const SizedBox(height: 16),
                for (var i = 0; i < 3; i++)
                  _row(context, 'Candidate ${String.fromCharCode(65 + i)}',
                      selected: i == 1),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.visibility_off_outlined,
                      size: 16, color: kc.successText),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('Anonymous ballot',
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
                    child: const Text('Submit vote'),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, {required bool selected}) {
    final kc = KivoraColors.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: selected
            ? AppTheme.primaryBlue.withValues(alpha: kc.isDark ? 0.18 : 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: selected ? AppTheme.primaryBlue : kc.border,
            width: selected ? 2 : 1),
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
            child: Text(label,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kc.textPrimary))),
      ]),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
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
