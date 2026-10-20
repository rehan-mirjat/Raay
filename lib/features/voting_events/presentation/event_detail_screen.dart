import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/fade_through.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../services/auth_service.dart';
import '../../organizations/domain/organization_enums.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../../voting/data/participation_repository.dart';
import '../../voting/data/receipt_repository.dart';
import '../../voting/presentation/cast_vote_screen.dart';
import '../domain/voting_event.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(singleVotingEventProvider(eventId));
    final currentUser = ref.watch(authServiceProvider).currentUser;

    final stateKey = eventAsync.when(
      loading: () => 'loading',
      error: (_, __) => 'error',
      data: (event) => event == null ? 'not-found' : 'event:${event.id}',
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: FadeThrough(
          stateKey: stateKey,
          child: eventAsync.when(
          loading: () => const LoadingView(message: 'Loading event details...'),
          error: (err, _) => ErrorView(
            type: ErrorViewType.generic,
            message: 'Error loading voting event: $err',
            onRetry: () => ref.invalidate(singleVotingEventProvider(eventId)),
          ),
          data: (event) {
            if (event == null) {
              return const ErrorView(
                type: ErrorViewType.generic,
                title: 'Event Not Found',
                message:
                    'The requested voting event does not exist or has been removed.',
              );
            }

            if (currentUser == null) {
              return const ErrorView(
                type: ErrorViewType.generic,
                title: 'Authentication Required',
                message: 'Please sign in to view voting event details.',
              );
            }

            final participationAsync = ref.watch(
              participationStatusProvider((
                organizationId: event.organizationId,
                eventId: event.id,
                userId: currentUser.uid,
              )),
            );

            final isWide = ResponsiveLayout.isWide(context);
            final leftColumn = _LeftColumn(
              event: event,
              currentUser: currentUser,
              participationAsync: participationAsync,
            );
            final rightColumn = _EventDetailsCard(event: event);

            return SingleChildScrollView(
              padding: ResponsiveLayout.pagePadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1040),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => context.go('/home'),
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back_rounded,
                                  size: 16, color: AppTheme.primaryBlue),
                              SizedBox(width: 4),
                              Text(
                                'Events',
                                style: TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusBadge.eventStatus(event.status.name),
                          StatusBadge.privacyMode(event.privacyMode.name),
                          StatusBadge(
                            label: event.votingType.label,
                            backgroundColor:
                                AppTheme.primaryBlue.withValues(alpha: 0.12),
                            textColor: AppTheme.primaryBlue,
                            icon: Icons.how_to_vote_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        event.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      if (event.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          event.description,
                          style: TextStyle(
                              fontSize: 14,
                              color: KivoraColors.textSecondaryOf(context)),
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: leftColumn),
                            const SizedBox(width: 24),
                            SizedBox(width: 320, child: rightColumn),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            leftColumn,
                            const SizedBox(height: 24),
                            rightColumn,
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
          ),
        ),
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  const _LeftColumn({
    required this.event,
    required this.currentUser,
    required this.participationAsync,
  });

  final VotingEvent event;
  final User currentUser;
  final AsyncValue<bool> participationAsync;

  bool get _isClosed =>
      event.status == VotingEventStatus.closed ||
      event.status == VotingEventStatus.archived;

  @override
  Widget build(BuildContext context) {
    return participationAsync.when(
      loading: () =>
          const LoadingView(message: 'Checking participation status...'),
      error: (err, _) => ErrorView(
          type: ErrorViewType.generic,
          message: 'Failed to verify participation status: $err'),
      data: (hasVoted) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasVoted)
              _VotedCard(event: event, userId: currentUser.uid)
            else
              _NotVotedCard(event: event),
            if (_isClosed) ...[
              const SizedBox(height: 16),
              _ResultsReadyCard(event: event),
            ],
          ],
        );
      },
    );
  }
}

class _VotedCard extends ConsumerWidget {
  const _VotedCard({required this.event, required this.userId});

  final VotingEvent event;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppTheme.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: AppTheme.success, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You voted in this event',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Your participation was securely recorded.',
                      style: TextStyle(
                          fontSize: 13,
                          color: KivoraColors.textSecondaryOf(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Each member can vote once, so voting again is not possible. '
            'Keep your receipt as proof that you took part.',
            style: TextStyle(
                fontSize: 13,
                color: KivoraColors.textSecondaryOf(context),
                height: 1.4),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              final receipt = await ref
                  .read(receiptRepositoryProvider)
                  .getReceiptForEvent(event.id, userId);
              if (receipt != null && context.mounted) {
                context.push('/receipt', extra: {
                  'receipt': receipt,
                  'eventTitle': event.title,
                });
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Receipt not found.')),
                );
              }
            },
            icon: const Icon(Icons.description_outlined, size: 18),
            label: const Text('View your confirmation receipt'),
            style: OutlinedButton.styleFrom(
              backgroundColor: KivoraColors.surfaceOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotVotedCard extends StatelessWidget {
  const _NotVotedCard({required this.event});

  final VotingEvent event;

  @override
  Widget build(BuildContext context) {
    final isActive = event.status == VotingEventStatus.active;
    final kc = KivoraColors.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: isActive
                ? () => context.push('/elections/${event.id}/vote')
                : null,
            icon: const Icon(Icons.how_to_vote_rounded, size: 18),
            label: const Text('Proceed to Ballot'),
          ),
          if (!isActive) ...[
            const SizedBox(height: 12),
            Text(
              'This event is currently ${event.status.name.toUpperCase()} and not accepting votes.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppTheme.error,
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultsReadyCard extends StatelessWidget {
  const _ResultsReadyCard({required this.event});

  final VotingEvent event;

  static final _dateFormat = DateFormat('MMM d, yyyy, h:mm a');

  @override
  Widget build(BuildContext context) {
    final dateFormat = _dateFormat;
    final kc = KivoraColors.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bar_chart_rounded,
                    color: AppTheme.primaryBlue, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Results are ready',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Voting closed on ${dateFormat.format(event.endAt)}.',
                      style: TextStyle(
                          fontSize: 13, color: kc.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.push('/elections/${event.id}/results'),
            child: const Text('View election results'),
          ),
        ],
      ),
    );
  }
}

class _EventDetailsCard extends ConsumerWidget {
  const _EventDetailsCard({required this.event});

  final VotingEvent event;

  static final _dateFormat = DateFormat('MMM d, yyyy');
  static final _timeFormat = DateFormat('h:mm a');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = _dateFormat;
    final timeFormat = _timeFormat;
    final kc = KivoraColors.of(context);
    final memberRole = ref
        .watch(activeOrganizationContextProvider)
        .valueOrNull
        ?.context
        ?.member
        .role;
    final isAdmin = memberRole?.isAdmin ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'EVENT DETAILS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: kc.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          _detailRow(
            context: context,
            icon: Icons.how_to_vote_outlined,
            label: 'Voting type',
            value: event.votingType.label,
          ),
          const Divider(height: 1),
          _detailRow(
            context: context,
            icon: Icons.groups_outlined,
            label: 'Who could vote',
            value: event.eligibilityType.label,
          ),
          const Divider(height: 1),
          _detailRow(
            context: context,
            icon: Icons.schedule_rounded,
            label: 'Voting opened',
            subvalue: timeFormat.format(event.startAt),
            value: dateFormat.format(event.startAt),
          ),
          const Divider(height: 1),
          _detailRow(
            context: context,
            icon: Icons.event_busy_outlined,
            label: 'Voting closed',
            subvalue: timeFormat.format(event.endAt),
            value: dateFormat.format(event.endAt),
          ),
          const SizedBox(height: 12),
          if (event.privacyMode == PrivacyMode.identifiable) ...[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.identifiable.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.identifiable.withValues(alpha: 0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.person_outline_rounded,
                      size: 16, color: AppTheme.identifiable),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 12.5,
                            color: AppTheme.identifiable,
                            height: 1.4),
                        children: [
                          TextSpan(
                              text: 'Identifiable ballot. ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'Your vote was recorded together with your identity.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else
            const SizedBox(height: 16),
          if (isAdmin) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (event.status == VotingEventStatus.active ||
                      event.status == VotingEventStatus.closed)
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.push('/admin/events/${event.id}/monitor'),
                      icon: const Icon(Icons.analytics_outlined, size: 18),
                      label: const Text('Monitor Turnout'),
                    ),
                  if (event.status == VotingEventStatus.draft) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.push('/admin/events/${event.id}/edit'),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit Event Builder'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    String? subvalue,
  }) {
    final kc = KivoraColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: AppTheme.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12.5, color: kc.textSecondary),
                ),
                if (subvalue != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subvalue,
                    style: TextStyle(fontSize: 12, color: kc.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: kc.textPrimary),
          ),
        ],
      ),
    );
  }
}
