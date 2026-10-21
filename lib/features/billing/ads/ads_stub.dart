import 'package:flutter/widgets.dart';

/// Web and platforms without the AdMob SDK: ads are never shown.
Future<void> initAds() async {}

Widget buildPlatformAdBanner() => const SizedBox.shrink();
