/// The server's answer to "may I vote in this election?" for the signed-in
/// user only. It carries no roster information.
enum EligibilityReason { eligible, notOnList, notOpenToYou, rosterNotReady, unknown }

class EligibilityDecision {
  const EligibilityDecision({required this.eligible, required this.reason});

  final bool eligible;
  final EligibilityReason reason;

  /// Whether the UI may offer the vote action. Only a definite "no" hides it:
  /// when the voter roll is not frozen yet, or the answer is unknown, the
  /// server (castVote) stays the final judge.
  bool get showsAsEligible =>
      eligible || reason == EligibilityReason.rosterNotReady || reason == EligibilityReason.unknown;

  factory EligibilityDecision.fromMap(Object? raw) {
    if (raw is! Map) {
      return const EligibilityDecision(eligible: false, reason: EligibilityReason.unknown);
    }
    final reason = switch (raw['reason']) {
      'ELIGIBLE' => EligibilityReason.eligible,
      'NOT_ON_LIST' => EligibilityReason.notOnList,
      'NOT_OPEN_TO_YOU' => EligibilityReason.notOpenToYou,
      'ROSTER_NOT_READY' => EligibilityReason.rosterNotReady,
      _ => EligibilityReason.unknown,
    };
    return EligibilityDecision(eligible: raw['eligible'] == true, reason: reason);
  }
}
