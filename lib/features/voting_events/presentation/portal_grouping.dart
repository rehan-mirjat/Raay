import '../domain/election_card_state.dart';
import '../domain/voting_event.dart';
import 'providers/voter_portal_providers.dart';

/// Voter home sections, in display order.
enum PortalSection { ready, upcoming, participated, other }

/// Splits entries into the voter-home sections.
///
/// * ready: active, likely eligible, and not known to have voted (unknown
///   participation stays here so the card can say "checking", never "voted")
/// * upcoming: scheduled
/// * participated: known to have voted (receipt access), any lifecycle status
/// * other: everything else (closed without a vote, ineligible, cancelled...)
Map<PortalSection, List<VoterPortalEntry>> groupPortalEntries(
  List<VoterPortalEntry> entries,
  Map<String, ParticipationStatus> participation,
) {
  final out = {for (final s in PortalSection.values) s: <VoterPortalEntry>[]};
  for (final e in entries) {
    final p = participation[e.event.id] ?? ParticipationStatus.unknown;
    if (p == ParticipationStatus.voted) {
      out[PortalSection.participated]!.add(e);
    } else if (e.event.status == VotingEventStatus.active && e.isLikelyEligible) {
      out[PortalSection.ready]!.add(e);
    } else if (e.event.status == VotingEventStatus.scheduled) {
      out[PortalSection.upcoming]!.add(e);
    } else {
      out[PortalSection.other]!.add(e);
    }
  }
  return out;
}
