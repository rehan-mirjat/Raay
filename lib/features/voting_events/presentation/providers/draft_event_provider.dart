import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/voting_event_repository.dart';
import '../../domain/voting_event.dart';
import '../../../../core/utils/friendly_error.dart';

class DraftEventState {
  final String title;
  final String description;
  final VotingType votingType;
  final PrivacyMode privacyMode;
  final DateTime? startAt;
  final DateTime? endAt;
  final EligibilityType eligibilityType;
  final List<String> selectedDepartmentIds;
  final List<String> selectedUserIds;
  final String? serverEventId;
  final VotingEventStatus status;
  final bool isLoading;
  final String? error;

  DraftEventState({
    this.title = '',
    this.description = '',
    this.votingType = VotingType.candidateElection,
    this.privacyMode = PrivacyMode.anonymous,
    this.startAt,
    this.endAt,
    this.eligibilityType = EligibilityType.allMembers,
    this.selectedDepartmentIds = const [],
    this.selectedUserIds = const [],
    this.serverEventId,
    this.status = VotingEventStatus.draft,
    this.isLoading = false,
    this.error,
  });

  DraftEventState copyWith({
    String? title,
    String? description,
    VotingType? votingType,
    PrivacyMode? privacyMode,
    DateTime? startAt,
    DateTime? endAt,
    EligibilityType? eligibilityType,
    List<String>? selectedDepartmentIds,
    List<String>? selectedUserIds,
    String? serverEventId,
    VotingEventStatus? status,
    bool? isLoading,
    String? error,
  }) {
    return DraftEventState(
      title: title ?? this.title,
      description: description ?? this.description,
      votingType: votingType ?? this.votingType,
      privacyMode: privacyMode ?? this.privacyMode,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      eligibilityType: eligibilityType ?? this.eligibilityType,
      selectedDepartmentIds: selectedDepartmentIds ?? this.selectedDepartmentIds,
      selectedUserIds: selectedUserIds ?? this.selectedUserIds,
      serverEventId: serverEventId ?? this.serverEventId,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Stable fingerprint of the persisted draft fields, used to tell whether the
/// form differs from what the server last accepted.
String draftSignature(DraftEventState s) => [
      s.title,
      s.description,
      s.votingType.name,
      s.privacyMode.name,
      s.startAt?.toIso8601String() ?? '',
      s.endAt?.toIso8601String() ?? '',
      s.eligibilityType.name,
      ([...s.selectedDepartmentIds]..sort()).join(','),
      ([...s.selectedUserIds]..sort()).join(','),
    ].join('|');

class DraftEventNotifier extends StateNotifier<DraftEventState> {
  DraftEventNotifier(this._repository, this.organizationId) : super(DraftEventState()) {
    _savedSignature = draftSignature(state);
  }

  late String _savedSignature;

  /// True when the form holds edits the server has not accepted: either brand
  /// new input, or changes since the last successful create/update. A
  /// freshly opened empty form and a just-saved draft are both "clean".
  bool get hasUnsavedChanges => draftSignature(state) != _savedSignature;

  final VotingEventRepository _repository;
  final String organizationId;

  void updateBasicInfo(String title, String desc, VotingType type, PrivacyMode privacyMode) {
    state = state.copyWith(title: title, description: desc, votingType: type, privacyMode: privacyMode);
  }

  void updateSchedule(DateTime start, DateTime end) {
    state = state.copyWith(startAt: start, endAt: end);
  }

  void updateEligibility(EligibilityType type, List<String> depts, List<String> users) {
    state = state.copyWith(eligibilityType: type, selectedDepartmentIds: depts, selectedUserIds: users);
  }

  void loadExistingDraft(VotingEvent event) {
    state = DraftEventState(
      title: event.title,
      description: event.description,
      votingType: event.votingType,
      privacyMode: event.privacyMode,
      startAt: event.startAt,
      endAt: event.endAt,
      eligibilityType: event.eligibilityType,
      selectedDepartmentIds: event.eligibilityDepartmentIds,
      selectedUserIds: event.eligibilityUserIds,
      serverEventId: event.id,
      status: event.status,
    );
    _savedSignature = draftSignature(state);
  }

  Future<bool> createServerDraft() async {
    if (state.startAt == null || state.endAt == null) {
      state = state.copyWith(error: "Schedule is incomplete.");
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final String vTypeStr = state.votingType == VotingType.candidateElection
          ? 'CANDIDATE_ELECTION'
          : state.votingType == VotingType.singleChoicePoll
              ? 'SINGLE_CHOICE_POLL'
              : 'YES_NO_POLL';

      final String eTypeStr = state.eligibilityType == EligibilityType.allMembers
          ? 'ALL_MEMBERS'
          : state.eligibilityType == EligibilityType.selectedDepartments
              ? 'SELECTED_DEPARTMENTS'
              : 'SELECTED_MEMBERS';
      final String privacyModeStr = state.privacyMode == PrivacyMode.identifiable ? 'IDENTIFIABLE' : 'ANONYMOUS';

      if (state.serverEventId != null) {
        await _repository.updateVotingEvent(
          eventId: state.serverEventId!,
          votingType: vTypeStr,
          privacyMode: privacyModeStr,
          title: state.title,
          description: state.description,
          startAt: state.startAt,
          endAt: state.endAt,
          eligibilityType: eTypeStr,
          eligibilityDepartmentIds: eTypeStr == 'SELECTED_DEPARTMENTS' ? state.selectedDepartmentIds : const [],
          eligibilityUserIds: eTypeStr == 'SELECTED_MEMBERS' ? state.selectedUserIds : const [],
        );
        state = state.copyWith(isLoading: false);
        _savedSignature = draftSignature(state);
        return true;
      }

      final eventId = await _repository.createVotingEvent(
        organizationId: organizationId,
        title: state.title,
        description: state.description,
        votingType: vTypeStr,
        privacyMode: privacyModeStr,
        eligibilityType: eTypeStr,
        // MUST BE EXPLICIT ARRAYS! Cloud functions require arrays for SELECTED states, 
        // even if empty, but previously we sent null if empty.
        eligibilityDepartmentIds: eTypeStr == 'SELECTED_DEPARTMENTS' ? state.selectedDepartmentIds : const [],
        eligibilityUserIds: eTypeStr == 'SELECTED_MEMBERS' ? state.selectedUserIds : const [],
        startAt: state.startAt!,
        endAt: state.endAt!,
      );

      state = state.copyWith(serverEventId: eventId, isLoading: false);
      _savedSignature = draftSignature(state);
      return true;
    } catch (e) {
      state = state.copyWith(error: friendlyError(e), isLoading: false);
      return false;
    }
  }

  void reset() {
    state = DraftEventState();
    _savedSignature = draftSignature(state);
  }
}

final draftEventProvider = StateNotifierProvider.autoDispose.family<DraftEventNotifier, DraftEventState, String>((ref, orgId) {
  return DraftEventNotifier(ref.watch(votingEventRepositoryProvider), orgId);
});
