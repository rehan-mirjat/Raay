import 'package:flutter/material.dart';

/// Shared breakpoint policy (docs/design/kivora-ui-spec.md section 3):
/// compact < 600, medium 600..<1024, expanded >= 1024.
abstract final class ResponsiveLayout {
  static const compactBreakpoint = 600.0;
  static const wideBreakpoint = 1024.0;

  /// Max width of page content inside the shell, and of forms and the ballot.
  static const maxContentWidth = 1200.0;
  static const maxFormWidth = 720.0;
  static const maxBallotWidth = 680.0;

  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compactBreakpoint;

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= wideBreakpoint;

  /// The tablet/medium zone between [compactBreakpoint] and [wideBreakpoint]
  /// that [isCompact] and [isWide] leave neither "compact" nor "wide".
  static bool isMedium(BuildContext context) =>
      !isCompact(context) && !isWide(context);

  static EdgeInsets pagePadding(BuildContext context) => EdgeInsets.symmetric(
        horizontal: isCompact(context) ? 16 : 24,
        vertical: isCompact(context) ? 16 : 24,
      );

  /// Column count for a card grid, from the width the grid actually gets
  /// (the shell's sidebar/rail already consumed part of the window), not from
  /// the window width. One column per [minColumnWidth], clamped to
  /// 1..[maxColumns].
  static int columnsFor(
    double availableWidth, {
    double minColumnWidth = 360,
    double gap = 16,
    int maxColumns = 3,
  }) {
    if (availableWidth <= 0) return 1;
    final cols = ((availableWidth + gap) / (minColumnWidth + gap)).floor();
    return cols.clamp(1, maxColumns);
  }
}
