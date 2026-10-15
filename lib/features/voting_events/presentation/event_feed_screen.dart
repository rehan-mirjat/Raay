import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../data/voting_event_repository.dart';
import 'dashboard/event_card.dart';

final organizationEventsStreamProvider =
    StreamProvider.family<List<dynamic>, String>((ref, orgId) {
  return ref.watch(votingEventRepositoryProvider).watchOrganizationVotingEvents(orgId);
});

class EventFeedScreen extends ConsumerWidget {
  const EventFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrgState = ref.watch(activeOrganizationContextProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elections Feed'),
      ),
      body: activeOrgState.when(
        data: (activeOrgStateData) {
          final orgId = activeOrgStateData.context?.organization.id;
          if (orgId == null || orgId.isEmpty) {
            return const Center(
              child: Text('Please select or join an organization to view elections.'),
            );
          }

          final eventsAsync = ref.watch(organizationEventsStreamProvider(orgId));

          return eventsAsync.when(
            data: (events) {
              if (events.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.how_to_vote, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No elections available in this organization.'),
                    ],
                  ),
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
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Error loading elections: $err'),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading active organization: $err'),
        ),
      ),
    );
  }
}
