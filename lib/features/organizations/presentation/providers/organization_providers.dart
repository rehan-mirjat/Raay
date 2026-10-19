import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/auth_service.dart';
import '../../../../services/firebase_service.dart';
import '../../data/organization_repository.dart';
import '../../domain/active_organization_context.dart';
import '../../domain/organization.dart';
import '../../domain/organization_member.dart';
import '../../domain/member_growth_point.dart';

/// Streams the list of active organization memberships for the current user.
final userMembershipsProvider = StreamProvider<List<OrganizationMember>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Stream.value([]);
  }
  return ref.watch(organizationRepositoryProvider).watchUserMemberships(user.uid);
});

/// Refreshes recipient invitations while the signed-in app is open.
final memberInvitationsProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null || user.email == null || !user.emailVerified) {
    return Stream.value([]);
  }

  // Stream directly from Firestore for real-time updates and zero polling
  return FirebaseService()
      .firestore
      .collection('organizationInvitations')
      .where('email', isEqualTo: user.email)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .asyncMap((snapshot) async {
    final invites = <Map<String, dynamic>>[];
    for (final doc in snapshot.docs) {
      final data = doc.data();
      data['id'] = doc.id;
      
      // Try to fetch organization details from public projection
      try {
        final orgDoc = await FirebaseService()
            .firestore
            .collection('organizationPublic')
            .doc(data['organizationId'] as String)
            .get();
        if (orgDoc.exists) {
          final orgData = orgDoc.data()!;
          data['organizationName'] = orgData['name'] ?? 'Organization';
          data['organizationLogoUrl'] = orgData['logoUrl'];
        }
      } catch (_) {
        data['organizationName'] = 'Organization';
      }
      
      invites.add(data);
    }
    return invites;
  });
});

/// Streams the full list of [Organization] documents corresponding to active memberships.
/// Parallelizes organization document fetching for high-speed loading.
final userOrganizationsProvider = StreamProvider<List<Organization>>((ref) async* {
  final membershipsAsync = ref.watch(userMembershipsProvider);
  final repo = ref.watch(organizationRepositoryProvider);
  final memberships = membershipsAsync.valueOrNull ?? [];

  if (memberships.isEmpty) {
    yield [];
    return;
  }

  final orgIds = memberships.map((m) => m.organizationId).toSet().toList();

  // Parallelize fetches in 1 round trip instead of a sequential loop
  final results = await Future.wait(orgIds.map((id) => repo.getOrganization(id)));
  final orgs = results.whereType<Organization>().where((org) => org.isSelectable).toList();

  yield orgs;
});

/// Manages the user-specific selected organization ID string and local storage.
class ActiveOrgIdNotifier extends StateNotifier<String?> {
  ActiveOrgIdNotifier(this._ref) : super(null) {
    // Re-evaluate saved ID whenever auth state changes (e.g., login/logout)
    _ref.listen(authStateChangesProvider, (previous, next) {
      if (next.value != null) {
        _loadSavedOrgId();
      } else {
        state = null; // Clear on logout
        _ref.read(organizationRepositoryProvider).clearCache();
      }
    });
    _loadSavedOrgId();
  }

  final Ref _ref;

  Future<void> _loadSavedOrgId() async {
    final user = _ref.read(authStateChangesProvider).value;
    if (user == null) {
      state = null;
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = 'kivora_active_org_id_${user.uid}';
    state = prefs.getString(key);
  }

  Future<void> selectOrganization(String orgId) async {
    final user = _ref.read(authStateChangesProvider).value;
    if (user == null) return;

    state = orgId;
    final prefs = await SharedPreferences.getInstance();
    final key = 'kivora_active_org_id_${user.uid}';
    await prefs.setString(key, orgId);
  }

  Future<void> clearSelection() async {
    final user = _ref.read(authStateChangesProvider).value;
    state = null;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('kivora_active_org_id_${user.uid}');
    }
  }
}

final activeOrgIdProvider = StateNotifierProvider<ActiveOrgIdNotifier, String?>((ref) {
  return ActiveOrgIdNotifier(ref);
});

enum ActiveOrgSelectionState {
  restored,
  autoSelected,
  needsSelection,
  noOrganizations,
}

class ActiveOrgState {
  final ActiveOrganizationContext? context;
  final ActiveOrgSelectionState selectionState;
  final List<OrganizationMember> availableMemberships;

  const ActiveOrgState({
    this.context,
    required this.selectionState,
    required this.availableMemberships,
  });
}

/// Asynchronously resolves the ActiveOrganizationContext based on user-specific persistence
/// and strict validation against current active memberships.
final activeOrganizationContextProvider = StreamProvider<ActiveOrgState>((ref) async* {
  final membershipsAsync = ref.watch(userMembershipsProvider);
  final selectedOrgId = ref.watch(activeOrgIdProvider);
  final repo = ref.watch(organizationRepositoryProvider);

  final memberships = membershipsAsync.valueOrNull ?? [];

  if (memberships.isEmpty) {
    yield const ActiveOrgState(
      context: null,
      selectionState: ActiveOrgSelectionState.noOrganizations,
      availableMemberships: [],
    );
    return;
  }

  // 1. Try to restore saved organization preference ONLY IF user holds an active membership
  if (selectedOrgId != null && selectedOrgId.isNotEmpty) {
    final matchingMember = memberships.where((m) => m.organizationId == selectedOrgId).firstOrNull;
    if (matchingMember != null) {
      final org = await repo.getOrganization(selectedOrgId);
      if (org != null && org.isSelectable) {
        yield ActiveOrgState(
          context: ActiveOrganizationContext(organization: org, member: matchingMember),
          selectionState: ActiveOrgSelectionState.restored,
          availableMemberships: memberships,
        );
        return;
      }
    }
  }

  // 2. Deterministic Fallback Rules
  // If we reach here, the previous selectedOrgId was invalid or revoked.
  // We should gracefully auto-select an available organization to prevent the user from being stranded.
  for (final member in memberships) {
    final org = await repo.getOrganization(member.organizationId);
    if (org != null && org.isSelectable) {
      // Auto-update the selection so subsequent loads stick to this new valid context
      Future.microtask(() => ref.read(activeOrgIdProvider.notifier).selectOrganization(org.id));
      
      yield ActiveOrgState(
        context: ActiveOrganizationContext(organization: org, member: member),
        selectionState: ActiveOrgSelectionState.autoSelected,
        availableMemberships: memberships,
      );
      return;
    }
  }

  // 3. Multiple memberships available but none validly selected -> Require selection
  yield ActiveOrgState(
    context: null,
    selectionState: ActiveOrgSelectionState.needsSelection,
    availableMemberships: memberships,
  );
});

/// Last 30 days of member-count snapshots for the "Members Growth" chart.
final memberGrowthProvider =
    StreamProvider.family<List<MemberGrowthPoint>, String>((ref, orgId) {
  return ref.watch(organizationRepositoryProvider).watchMemberGrowth(orgId);
});
