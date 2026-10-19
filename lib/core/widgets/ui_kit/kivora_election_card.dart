import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import '../../../features/voting_events/domain/voting_event.dart';
import '../../theme/app_theme.dart';
import '../../theme/kivora_colors.dart';
import 'kivora_button.dart';
import 'kivora_card.dart';

class KivoraElectionCard extends StatelessWidget {
  final VotingEvent event;
  final bool isAdmin;
  final String? organizationName;

  const KivoraElectionCard({
    super.key,
    required this.event,
    this.isAdmin = false,
    this.organizationName,
  });

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final isActive = event.status == VotingEventStatus.active;

    return KivoraCard(
      padding: const EdgeInsets.all(20),
      onTap: () => context.go('/elections/${event.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isActive ? AppTheme.primaryBlue : AppTheme.accentTeal)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isActive ? KivoraIcons.vote : KivoraIcons.calendarClock,
                  color: isActive ? AppTheme.primaryBlue : AppTheme.accentTeal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kc.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      organizationName ?? event.votingType.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: kc.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(kc),
            ],
          ),
          const SizedBox(height: 16),
          if (event.description.isNotEmpty) ...[
            Text(
              event.description,
              style: TextStyle(
                fontSize: 13,
                color: kc.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
          ],
          const Spacer(),
          Row(
            children: [
              if (isActive && !isAdmin)
                Expanded(
                  child: KivoraButton(
                    label: 'Vote Now',
                    onPressed: () => context.go('/elections/${event.id}/vote'),
                  ),
                )
              else
                Expanded(
                  child: KivoraButton(
                    type: KivoraButtonType.secondary,
                    label: 'Details',
                    onPressed: () => context.go('/elections/${event.id}'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(KivoraColors kc) {
    Color bg;
    Color fg;
    String label;

    switch (event.status) {
      case VotingEventStatus.active:
        bg = AppTheme.success.withValues(alpha: 0.12);
        fg = AppTheme.success;
        label = 'Ongoing';
        break;
      case VotingEventStatus.scheduled:
        bg = AppTheme.warning.withValues(alpha: 0.12);
        fg = AppTheme.warning;
        label = 'Upcoming';
        break;
      case VotingEventStatus.draft:
        bg = kc.isDark ? AppTheme.darkBorder : AppTheme.borderLight;
        fg = kc.textSecondary;
        label = 'Draft';
        break;
      default:
        bg = kc.isDark ? AppTheme.darkBorder : AppTheme.borderLight;
        fg = kc.textSecondary;
        label = 'Completed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: fg,
        ),
      ),
    );
  }
}
