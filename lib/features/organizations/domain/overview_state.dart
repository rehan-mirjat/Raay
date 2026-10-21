import '../../voting_events/domain/voting_event.dart';

/// A count shown on the admin overview. A failed or pending lookup is never
/// shown as 0.
sealed class MetricValue {
  const MetricValue();
}

class MetricLoading extends MetricValue {
  const MetricLoading();
}

class MetricUnavailable extends MetricValue {
  const MetricUnavailable();
}

class MetricCount extends MetricValue {
  const MetricCount(this.count);
  final int count;
}

MetricValue metricFrom({required bool hasValue, required bool hasError, int? count}) {
  if (hasValue && count != null) return MetricCount(count);
  if (hasError) return const MetricUnavailable();
  return const MetricLoading();
}

enum RequiredActionKind { finishDrafts, reviewInvites }

class RequiredAction {
  const RequiredAction(this.kind, this.count);
  final RequiredActionKind kind;
  final int count;
}

/// Things an admin should do next. Empty means the section is hidden. Unknown
/// inputs (null) never produce an action.
List<RequiredAction> requiredActionsFor({
  required List<VotingEvent>? events,
  required int? pendingInvites,
}) {
  final out = <RequiredAction>[];
  final drafts = events?.where((e) => e.status == VotingEventStatus.draft).length ?? 0;
  if (drafts > 0) out.add(RequiredAction(RequiredActionKind.finishDrafts, drafts));
  if ((pendingInvites ?? 0) > 0) {
    out.add(RequiredAction(RequiredActionKind.reviewInvites, pendingInvites!));
  }
  return out;
}

/// Live elections first, then upcoming by soonest start; capped.
List<VotingEvent> featuredElections(List<VotingEvent> events, {int limit = 4}) {
  final live = events.where((e) => e.status == VotingEventStatus.active).toList()
    ..sort((a, b) => a.endAt.compareTo(b.endAt));
  final upcoming = events.where((e) => e.status == VotingEventStatus.scheduled).toList()
    ..sort((a, b) => a.startAt.compareTo(b.startAt));
  return [...live, ...upcoming].take(limit).toList();
}

enum AgeUnit { justNow, minutes, hours, days, weeks }

({AgeUnit unit, int n}) ageOf(Duration d) {
  if (d.inMinutes < 1) return (unit: AgeUnit.justNow, n: 0);
  if (d.inMinutes < 60) return (unit: AgeUnit.minutes, n: d.inMinutes);
  if (d.inHours < 24) return (unit: AgeUnit.hours, n: d.inHours);
  if (d.inDays < 7) return (unit: AgeUnit.days, n: d.inDays);
  return (unit: AgeUnit.weeks, n: d.inDays ~/ 7);
}

/// "ELECTION_CLOSED" -> "Election closed".
String humanizeAuditAction(String raw) {
  final words = raw.split('_').where((w) => w.isNotEmpty).map((w) => w.toLowerCase()).toList();
  final text = words.join(' ');
  if (text.isEmpty) return '';
  return '${text[0].toUpperCase()}${text.substring(1)}';
}
