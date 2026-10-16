import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../data/voting_event_repository.dart';
import 'dashboard/event_card.dart';

final organizationEventsStreamProvider =
    StreamProvider.family<List<dynamic>, String>((ref, orgId) {
  return ref
      .watch(votingEventRepositoryProvider)
      .watchOrganizationVotingEvents(orgId);
});

class EventFeedScreen extends ConsumerWidget {
  const EventFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrgState = ref.watch(activeOrganizationContextProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Elections Feed'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: activeOrgState.when(
            data: (activeOrgStateData) {
              final orgId = activeOrgStateData.context?.organization.id;
              if (orgId == null || orgId.isEmpty) {
                return const EmptyView(
                  icon: Icons.domain_outlined,
                  title: 'No active organization',
                  message:
                      'Select or join an organization to view its elections.',
                );
              }

              final eventsAsync =
                  ref.watch(organizationEventsStreamProvider(orgId));

              return eventsAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const EmptyView(
                      icon: Icons.how_to_vote_outlined,
                      title: 'No elections yet',
                      message:
                          'No elections are available in this organization right now.',
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(event: event);
                    },
                  );
                },
                loading: () => const LoadingView(),
                error: (err, stack) => ErrorView(
                  type: ErrorViewType.generic,
                  message: 'Could not load elections: $err',
                  onRetry: () =>
                      ref.invalidate(organizationEventsStreamProvider(orgId)),
                ),
              );
            },
            loading: () => const LoadingView(),
            error: (err, stack) => ErrorView(
              type: ErrorViewType.generic,
              message: 'Could not load your active organization: $err',
              onRetry: () => ref.invalidate(activeOrganizationContextProvider),
            ),
          ),
        ),
      ),
    );
  }
}
