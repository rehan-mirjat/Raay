import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../organizations/presentation/providers/organization_providers.dart';
import '../domain/plan.dart';

/// Plan of the currently selected organization (free when none is selected).
final activePlanProvider = Provider<PlanId>((ref) {
  final org = ref
      .watch(activeOrganizationContextProvider)
      .valueOrNull
      ?.context
      ?.organization;
  return org == null ? PlanId.free : effectivePlan(org);
});

/// Ads are shown only to members of organizations on the Free plan.
final adsEnabledProvider =
    Provider<bool>((ref) => ref.watch(activePlanProvider) == PlanId.free);
