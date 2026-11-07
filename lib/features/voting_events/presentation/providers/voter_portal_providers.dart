import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/auth_service.dart';
import '../../../../services/firebase_service.dart';
import '../../../voting/data/participation_repository.dart';
import '../../../organizations/data/organization_repository.dart';
import '../../../organizations/domain/organization.dart';
import '../../../organizations/domain/organization_enums.dart';
import '../../../organizations/domain/organization_member.dart';
import '../../../organizations/presentation/providers/organization_providers.dart';
import '../../data/eligibility_repository.dart';
import '../../data/voting_event_repository.dart';
import '../../domain/eligibility_decision.dart';
import '../../domain/election_card_state.dart';
import '../../domain/voting_event.dart';

/// One voting event bundled with the organization it belongs to and the
/// caller's own membership in that organization - everything a voter portal
/// card needs to render without each card re-fetching its own org/member.
class VoterPortalEntry {
  const VoterPortalEntry({
    required this.event,
    required this.organization,
    required this.member,
    this.eligibility,
  });

  /// The server's decision for the signed-in user in an actionable election.
  final EligibilityDecision? eligibility;

  final VotingEvent event;
  final Organization organization;
  final OrganizationMember member;

  /// Display-only eligibility estimate, mirroring the server's rule in
  /// createVotingEvent/castVote. This NEVER gates the actual vote action -
  /// castVote re-derives eligibility server-side regardless of what this
  /// returns, so a stale or wrong client guess here can only ever hide or
  /// show a button, never let someone vote who shouldn't be able to.
  bool get isLikelyEligible {
    // The activation voter roll is private and server-side for every type, so the
    // server's per-user answer is the only source. No answer = unknown, which
    // still lets the vote action show (castVote enforces).
    return eligibility?.showsAsEligible ?? true;
  }
}

/// Aggregates non-draft voting events across every organization the signed-in
/// user actively belongs to, for the "My Voting Portal" (Package A1) and the
/// election calendar (A2). Refetches whenever the membership list changes;
/// screens using this should also offer a manual pull-to-refresh since this
/// is a one-shot fetch, not a live stream (see fetchEventsAcrossOrganizations
/// for why).
final voterPortalEntriesProvider =
    FutureProvider.autoDispose<List<VoterPortalEntry>>((ref) async {
  final memberships = await ref.watch(userMembershipsProvider.future);
  final activeMemberships =
      memberships.where((m) => m.status == MembershipStatus.active).toList();
  if (activeMemberships.isEmpty) return [];

  final repo = ref.watch(votingEventRepositoryProvider);
  final orgRepo = ref.watch(organizationRepositoryProvider);

  final orgIds = activeMemberships.map((m) => m.organizationId).toList();
  final events = await repo.fetchEventsAcrossOrganizations(orgIds);

  final orgsById = <String, Organization>{};
  await Future.wait(activeMemberships.map((m) async {
    if (orgsById.containsKey(m.organizationId)) return;
    final org = await orgRepo.getOrganization(m.organizationId);
    if (org != null) orgsById[m.organizationId] = org;
  }));

  final membersByOrgId = {
    for (final m in activeMemberships) m.organizationId: m
  };

  final actionable = events
      .where((e) => e.status == VotingEventStatus.active || e.status == VotingEventStatus.scheduled)
      .map((e) => e.id)
      .toList();
  final decisions =
      await ref.watch(eligibilityRepositoryProvider).fetchMine(actionable);

  return events
      .map((event) {
        final org = orgsById[event.organizationId];
        final member = membersByOrgId[event.organizationId];
        if (org == null || member == null) return null;
        return VoterPortalEntry(
            event: event,
            organization: org,
            member: member,
            eligibility: decisions[event.id]);
      })
      .whereType<VoterPortalEntry>()
      .toList();
});

/// Participation per election id. A failed or impossible lookup is
/// [ParticipationStatus.unknown] for that election; this provider itself never
/// throws, so one bad lookup cannot turn the whole list into "not voted".
final participationStatusesProvider =
    FutureProvider.autoDispose<Map<String, ParticipationStatus>>((ref) async {
  final uid = ref.watch(authServiceProvider).currentUser?.uid;
  final entries = await ref.watch(voterPortalEntriesProvider.future);
  final repo = ref.watch(participationRepositoryProvider);

  final results = <MapEntry<String, ParticipationStatus>>[];
  for (var offset = 0; offset < entries.length; offset += 20) {
    results.addAll(await Future.wait(entries.skip(offset).take(20).map((e) async {
    if (uid == null) return MapEntry(e.event.id, ParticipationStatus.unknown);
    try {
      final voted = await repo.hasUserVoted(e.organization.id, e.event.id, uid);
      return MapEntry(e.event.id,
          voted ? ParticipationStatus.voted : ParticipationStatus.notVoted);
    } catch (_) {
      return MapEntry(e.event.id, ParticipationStatus.unknown);
    }
    })));
  }
  return Map.fromEntries(results);
});

/// Publication state of results for closed/archived elections, read from
/// `eventResults/{id}` (the same source the results screen uses). Lifecycle
/// status alone never implies published results.
final resultsStatusesProvider =
    FutureProvider.autoDispose<Map<String, ResultsStatus>>((ref) async {
  final entries = await ref.watch(voterPortalEntriesProvider.future);
  final firestore = FirebaseService().firestore;

  final finished = entries.where((e) =>
      e.event.status == VotingEventStatus.closed ||
      e.event.status == VotingEventStatus.archived);

  final records = finished.toList();
  final results = <MapEntry<String, ResultsStatus>>[];
  for (var offset = 0; offset < records.length; offset += 20) {
    results.addAll(await Future.wait(records.skip(offset).take(20).map((e) async {
    try {
      final doc =
          await firestore.collection('eventResults').doc(e.event.id).get();
      return MapEntry(
          e.event.id, resultsStatusFrom(exists: doc.exists, data: doc.data()));
    } catch (err) {
      return MapEntry(e.event.id, resultsStatusFrom(error: err));
    }
    })));
  }
  return Map.fromEntries(results);
});

/// Publication status of a single election's results (same source as the
/// results screen). Never inferred from lifecycle status.
final eventResultsStatusProvider = FutureProvider.autoDispose
    .family<ResultsStatus, String>((ref, eventId) async {
  try {
    final doc = await FirebaseService()
        .firestore
        .collection('eventResults')
        .doc(eventId)
        .get();
    return resultsStatusFrom(exists: doc.exists, data: doc.data());
  } catch (err) {
    return resultsStatusFrom(error: err);
  }
});

/// Raw `eventResults/{id}` document as a map (null when it does not exist).
/// Errors (including permission-denied for unpublished results) propagate so
/// the screen can tell "not available to you" from "failed to load".
final eventResultsDataProvider = StreamProvider.autoDispose
    .family<Map<String, dynamic>?, String>((ref, eventId) {
  return FirebaseService()
      .firestore
      .collection('eventResults')
      .doc(eventId)
      .snapshots()
      .map((doc) => doc.data());
});

/// First name for the greeting on the member home. Purely cosmetic: if the
/// signed-in user cannot be read the greeting simply has no name.
final greetingNameProvider = Provider.autoDispose<String?>((ref) {
  try {
    final name =
        ref.watch(authServiceProvider).currentUser?.displayName?.trim();
    if (name == null || name.isEmpty) return null;
    return name.split(' ').first;
  } catch (_) {
    return null;
  }
});
