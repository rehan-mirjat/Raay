import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A calm, branded banner at the top of a workspace page: a deep navy to teal
/// gradient with a soft light, a greeting-sized title, one supporting line and
/// optional actions. Text is always white on the dark end of the gradient
/// (checked: white on #0F2233 is 15:1, on #0F766E 5.5:1).
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 640;
    return Semantics(
      container: true,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard + 6),
          gradient: const LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [Color(0xFF0F2233), Color(0xFF0F3B4A), Color(0xFF0F766E)],
            stops: [0, 0.55, 1],
          ),
          boxShadow: AppTheme.cardShadow(dark: false),
        ),
        child: Stack(children: [
          // Decorative light; never carries information.
          PositionedDirectional(
            end: -60,
            top: -80,
            child: ExcludeSemantics(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF5EEAD4).withValues(alpha: 0.28),
                    const Color(0xFF5EEAD4).withValues(alpha: 0),
                  ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(narrow ? 20 : 28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (eyebrow != null) ...[
                Text(eyebrow!.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFF99F6E4))),
                const SizedBox(height: 8),
              ],
              Semantics(
                header: true,
                child: Text(title,
                    style: TextStyle(
                        fontSize: narrow ? 24 : 30,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: Colors.white)),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(subtitle!,
                    style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFFDCE8EE))),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 18),
                Wrap(spacing: 12, runSpacing: 12, children: actions),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}

/// A primary action for use on a [HeroBanner]: white on the dark gradient.
class HeroAction extends StatelessWidget {
  const HeroAction({super.key, required this.label, required this.onPressed, this.icon, this.filled = true});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final child = Text(label, style: const TextStyle(fontWeight: FontWeight.w700));
    final style = filled
        ? FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0B5F58),
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 22),
          )
        : OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white70, width: 1.4),
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 22),
          );
    if (filled) {
      return icon == null
          ? FilledButton(style: style, onPressed: onPressed, child: child)
          : FilledButton.icon(style: style, onPressed: onPressed, icon: Icon(icon, size: 18), label: child);
    }
    return icon == null
        ? OutlinedButton(style: style, onPressed: onPressed, child: child)
        : OutlinedButton.icon(style: style, onPressed: onPressed, icon: Icon(icon, size: 18), label: child);
  }
}
