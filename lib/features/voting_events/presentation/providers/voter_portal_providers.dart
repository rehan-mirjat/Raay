import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../organizations/data/organization_repository.dart';
import '../../../organizations/domain/organization.dart';
import '../../../organizations/domain/organization_enums.dart';
import '../../../organizations/domain/organization_member.dart';
import '../../../organizations/presentation/providers/organization_providers.dart';
import '../../data/voting_event_repository.dart';
import '../../domain/voting_event.dart';

/// One voting event bundled with the organization it belongs to and the
/// caller's own membership in that organization - everything a voter portal
/// card needs to render without each card re-fetching its own org/member.
class VoterPortalEntry {
  const VoterPortalEntry({
    required this.event,
    required this.organization,
    required this.member,
  });

  final VotingEvent event;
  final Organization organization;
  final OrganizationMember member;

  /// Display-only eligibility estimate, mirroring the server's rule in
  /// createVotingEvent/castVote. This NEVER gates the actual vote action -
  /// castVote re-derives eligibility server-side regardless of what this
  /// returns, so a stale or wrong client guess here can only ever hide or
  /// show a button, never let someone vote who shouldn't be able to.
  bool get isLikelyEligible {
    switch (event.eligibilityType) {
      case EligibilityType.allMembers:
        return true;
      case EligibilityType.selectedMembers:
        return event.eligibilityUserIds.contains(member.userId);
      case EligibilityType.selectedDepartments:
        return member.departmentId != null &&
            event.eligibilityDepartmentIds.contains(member.departmentId);
    }
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

  final membersByOrgId = {for (final m in activeMemberships) m.organizationId: m};

  return events
      .map((event) {
        final org = orgsById[event.organizationId];
        final member = membersByOrgId[event.organizationId];
        if (org == null || member == null) return null;
        return VoterPortalEntry(event: event, organization: org, member: member);
      })
      .whereType<VoterPortalEntry>()
      .toList();
});
