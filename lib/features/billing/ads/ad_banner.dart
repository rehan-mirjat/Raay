import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/plan_providers.dart';
import 'ads_stub.dart' if (dart.library.io) 'ads_real.dart';

export 'ads_stub.dart' if (dart.library.io) 'ads_real.dart' show initAds;

/// A banner shown only to members of Free-plan organizations, and only on
/// mobile. POLICY: place this widget ONLY on browsing screens (home, calendar,
/// organizations, published results). It must never appear on the ballot,
/// receipt, receipt verification, transparency or admin/management screens.
class AdBanner extends ConsumerWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(adsEnabledProvider)) return const SizedBox.shrink();
    // Must size itself to its content: this is used as a Scaffold
    // bottomNavigationBar, and anything that expands (Center, Align without a
    // heightFactor) would take the whole screen height and hide the body.
    return buildPlatformAdBanner();
  }
}
