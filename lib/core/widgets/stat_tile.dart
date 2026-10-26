import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/kivora_colors.dart';

/// A read-only number with a label (not a control). A null [value] shows a
/// dash: the figure is unknown, never guessed.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value});
  final String label;
  final int? value;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Semantics(
      container: true,
      label: '$label: ${value ?? '-'}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kc.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(color: kc.border),
          boxShadow: AppTheme.cardShadow(dark: kc.isDark),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kc.textSecondary)),
          const SizedBox(height: 8),
          Text(value == null ? '–' : '$value',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: kc.textPrimary)),
        ]),
      ),
    );
  }
}

/// Lays [tiles] out in [columnsWide] columns when there is room, else two.
class StatTileRow extends StatelessWidget {
  const StatTileRow({super.key, required this.tiles, this.columnsWide = 4});
  final List<Widget> tiles;
  final int columnsWide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 720 ? columnsWide : 2;
      const gap = 12.0;
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(spacing: gap, runSpacing: gap, children: [
        for (final t in tiles) SizedBox(width: w, child: t),
      ]);
    });
  }
}
