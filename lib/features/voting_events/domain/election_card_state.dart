import 'package:cloud_firestore/cloud_firestore.dart';

import 'voting_event.dart';

/// Whether the signed-in user has a participation record for an election.
/// [unknown] covers "still loading" and "lookup failed"; it must never be
/// rendered as either "voted" or "not voted".
enum ParticipationStatus { voted, notVoted, unknown }

/// Whether an election's results are published to members.
enum ResultsStatus { published, notPublished, unknown }

/// The single primary action a voter-facing election card offers.
enum ElectionCardAction {
  voteNow,
  viewReceipt,
  viewDetails,
  checkingStatus,
  resultsPending,
  viewResults,
}

/// Chooses the card's primary action from authoritative state only.
///
/// [isLikelyEligible] is a display hint (castVote re-checks eligibility on the
/// server). [results] is only consulted for closed/archived elections.
ElectionCardAction primaryActionFor({
  required VotingEventStatus status,
  required bool isLikelyEligible,
  required ParticipationStatus participation,
  required ResultsStatus results,
}) {
  switch (status) {
    case VotingEventStatus.active:
      if (!isLikelyEligible) return ElectionCardAction.viewDetails;
      switch (participation) {
        case ParticipationStatus.voted:
          return ElectionCardAction.viewReceipt;
        case ParticipationStatus.notVoted:
          return ElectionCardAction.voteNow;
        case ParticipationStatus.unknown:
          return ElectionCardAction.checkingStatus;
      }
    case VotingEventStatus.closed:
    case VotingEventStatus.archived:
      switch (results) {
        case ResultsStatus.published:
          return ElectionCardAction.viewResults;
        case ResultsStatus.notPublished:
          return ElectionCardAction.resultsPending;
        case ResultsStatus.unknown:
          return ElectionCardAction.viewDetails;
      }
    case VotingEventStatus.scheduled:
    case VotingEventStatus.cancelled:
    case VotingEventStatus.draft:
      return ElectionCardAction.viewDetails;
  }
}

/// Maps a read of `eventResults/{eventId}` to a [ResultsStatus].
///
/// firestore.rules lets a member read that document only once it is published
/// (and lets anyone read a missing one). So for a member: missing -> not
/// published, permission-denied -> exists but unpublished, published:true ->
/// published. Any other failure is [ResultsStatus.unknown], not "pending".
ResultsStatus resultsStatusFrom({bool? exists, Object? data, Object? error}) {
  if (error != null) {
    if (error is FirebaseException && error.code == 'permission-denied') {
      return ResultsStatus.notPublished;
    }
    return ResultsStatus.unknown;
  }
  if (exists != true) return ResultsStatus.notPublished;
  final published = data is Map ? data['published'] : null;
  return published == true ? ResultsStatus.published : ResultsStatus.notPublished;
}
