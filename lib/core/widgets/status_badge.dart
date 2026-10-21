import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/kivora_colors.dart';

enum BadgeType { status, privacy, role }

/// Semantic tone. Colors are resolved at build time from [KivoraColors] so each
/// tone meets contrast in both light and dark mode (see docs/design/contrast_check.py).
enum BadgeTone { success, accent, neutral, error, warning, identifiable }

class StatusBadge extends StatelessWidget {
  /// Legacy constructor with explicit colors (kept for existing call sites).
  const StatusBadge({
    super.key,
    required this.label,
    required Color this.backgroundColor,
    required Color this.textColor,
    this.icon,
  }) : tone = null;

  const StatusBadge._tone({
    required this.label,
    required BadgeTone this.tone,
    this.icon,
  })  : backgroundColor = null,
        textColor = null;

  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final BadgeTone? tone;
  final IconData? icon;

  /// Event lifecycle badge. An unrecognized status shows its own text with a
  /// neutral tone; it is never silently relabelled as Draft.
  factory StatusBadge.eventStatus(String status) {
    final clean = status.trim().toUpperCase();
    switch (clean) {
      case 'ACTIVE':
        return const StatusBadge._tone(
            label: 'ACTIVE', tone: BadgeTone.success, icon: Icons.play_circle_fill_rounded);
      case 'SCHEDULED':
        return const StatusBadge._tone(
            label: 'SCHEDULED', tone: BadgeTone.accent, icon: Icons.event_rounded);
      case 'CLOSED':
        return const StatusBadge._tone(
            label: 'CLOSED', tone: BadgeTone.neutral, icon: Icons.lock_clock_rounded);
      case 'ARCHIVED':
        return const StatusBadge._tone(
            label: 'ARCHIVED', tone: BadgeTone.neutral, icon: Icons.inventory_2_outlined);
      case 'CANCELLED':
        return const StatusBadge._tone(
            label: 'CANCELLED', tone: BadgeTone.error, icon: Icons.cancel_rounded);
      case 'DRAFT':
        return const StatusBadge._tone(
            label: 'DRAFT', tone: BadgeTone.warning, icon: Icons.edit_note_rounded);
      default:
        return StatusBadge._tone(
            label: clean.isEmpty ? 'UNKNOWN' : clean,
            tone: BadgeTone.neutral,
            icon: Icons.help_outline_rounded);
    }
  }

  factory StatusBadge.privacyMode(String privacyMode) {
    if (privacyMode.trim().toUpperCase() == 'IDENTIFIABLE') {
      return const StatusBadge._tone(
          label: 'IDENTIFIABLE',
          tone: BadgeTone.identifiable,
          icon: Icons.account_circle_rounded);
    }
    return const StatusBadge._tone(
        label: 'ANONYMOUS', tone: BadgeTone.success, icon: Icons.visibility_off_rounded);
  }

  factory StatusBadge.role(String role) {
    switch (role.trim().toLowerCase()) {
      case 'owner':
        return const StatusBadge._tone(
            label: 'OWNER', tone: BadgeTone.warning, icon: Icons.stars_rounded);
      case 'admin':
        return const StatusBadge._tone(
            label: 'ADMIN',
            tone: BadgeTone.accent,
            icon: Icons.admin_panel_settings_rounded);
      default:
        return const StatusBadge._tone(
            label: 'MEMBER', tone: BadgeTone.neutral, icon: Icons.person_rounded);
    }
  }

  static Color _toneColor(BadgeTone tone, KivoraColors kc) {
    switch (tone) {
      case BadgeTone.success:
        return kc.successText;
      case BadgeTone.accent:
        return kc.accentText;
      case BadgeTone.error:
        return kc.errorText;
      case BadgeTone.warning:
        return kc.warningText;
      case BadgeTone.identifiable:
        return kc.isDark ? const Color(0xFFFFAB91) : const Color(0xFF9A2B06);
      case BadgeTone.neutral:
        return kc.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final fg = textColor ?? _toneColor(tone!, kc);
    final bg = backgroundColor ?? fg.withValues(alpha: kc.isDark ? 0.16 : 0.10);

    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusInput),
        border: Border.all(color: fg.withValues(alpha: 0.35), width: 1.0),
      ),
      // Scales down (never overflows) when a very narrow slot meets large text.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              ExcludeSemantics(child: Icon(icon, size: 14, color: fg)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: fg,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
