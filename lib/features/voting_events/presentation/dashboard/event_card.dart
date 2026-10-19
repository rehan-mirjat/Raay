import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../../../core/widgets/kivora_animations.dart';
import '../../domain/voting_event.dart';
import '../providers/event_lifecycle_provider.dart';

class EventCard extends ConsumerWidget {
  final VotingEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final format = DateFormat('MMM d, yyyy - h:mm a');

    return HoverLiftCard(
      borderRadius: AppTheme.radiusCard,
      onTap: () => context.go('/elections/${event.id}'),
      child: Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusCard)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusBadge(event.status),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _getTypeLabel(event.votingType),
              style: TextStyle(fontWeight: FontWeight.w600, color: KivoraColors.textPrimaryOf(context)),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: KivoraColors.textSecondaryOf(context)),
                SizedBox(width: 8),
                Text('${format.format(event.startAt)} to', style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 24),
                Text(format.format(event.endAt), style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
              ],
            ),
            Divider(height: 32),
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    )); // HoverLiftCard
  }

  Widget _buildStatusBadge(VotingEventStatus status) {
    Color color;
    String label;

    switch (status) {
      case VotingEventStatus.draft:
        color = Colors.grey;
        label = 'DRAFT';
        break;
      case VotingEventStatus.scheduled:
        color = Colors.blue;
        label = 'SCHEDULED';
        break;
      case VotingEventStatus.active:
        color = AppTheme.success;
        label = 'ACTIVE';
        break;
      case VotingEventStatus.closed:
        color = AppTheme.error;
        label = 'CLOSED';
        break;
      case VotingEventStatus.cancelled:
        color = AppTheme.error;
        label = 'CANCELLED';
        break;
      case VotingEventStatus.archived:
        color = Colors.brown;
        label = 'ARCHIVED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  String _getTypeLabel(VotingType type) {
    switch (type) {
      case VotingType.candidateElection: return 'Candidate Election';
      case VotingType.singleChoicePoll: return 'Single-Choice Poll';
      case VotingType.yesNoPoll: return 'Yes/No Poll';
    }
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    switch (event.status) {
      case VotingEventStatus.draft:
        return Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton.icon(
              onPressed: () => _confirmDelete(context, ref),
              icon: Icon(Icons.delete, color: AppTheme.error, size: 18),
              label: Text('Delete', style: TextStyle(color: AppTheme.error)),
            ),
            OutlinedButton(
              onPressed: () => context.go('/admin/events/${event.id}/choices'),
              child: Text('Manage Choices'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/admin/events/${event.id}/edit'),
              child: Text('Edit Config'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/admin/events/${event.id}/review'),
              child: Text('Publish'),
            ),
          ],
        );
      case VotingEventStatus.scheduled:
        return Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton.icon(
              onPressed: () => _confirmCancel(context, ref),
              icon: Icon(Icons.cancel, color: AppTheme.error, size: 18),
              label: Text('Cancel Event', style: TextStyle(color: AppTheme.error)),
            ),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Details view coming in Milestone 6.')));
              },
              child: Text('View Details'),
            ),
          ],
        );
      case VotingEventStatus.active:
        return Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton.icon(
              onPressed: () => _confirmClose(context, ref),
              icon: Icon(Icons.stop_circle, color: AppTheme.error, size: 18),
              label: Text('Close Early', style: TextStyle(color: AppTheme.error)),
            ),
            ElevatedButton(
              onPressed: () => context.go('/admin/events/${event.id}/monitor'),
              child: Text('Monitor Turnout'),
            ),
          ],
        );
      case VotingEventStatus.closed:
      case VotingEventStatus.archived:
        return Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/elections/${event.id}/results'),
              child: Text('View Results'),
            ),
          ],
        );
      case VotingEventStatus.cancelled:
        return Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Details view coming in Milestone 6.')));
              },
              child: Text('View Details'),
            ),
          ],
        );
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Draft Event?'),
        content: Text('Are you sure you want to permanently delete "${event.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      )
    );
    if (confirm == true) {
      ref.read(eventLifecycleProvider.notifier).deleteEvent(event.id);
    }
  }

  void _confirmCancel(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancel Scheduled Event?'),
        content: Text('Are you sure you want to cancel "${event.title}"? It will not become active.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Keep Scheduled')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Cancel Event', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      )
    );
    if (confirm == true) {
      ref.read(eventLifecycleProvider.notifier).cancelEvent(event.id);
    }
  }

  void _confirmClose(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Close Event Early?'),
        content: Text('Are you sure you want to close "${event.title}"? No further votes will be accepted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Close Early', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      )
    );
    if (confirm == true) {
      ref.read(eventLifecycleProvider.notifier).closeEventEarly(event.id);
    }
  }
}
