import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Google's public TEST banner units. Real units are injected at build time:
//   --dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-xxx/yyy
const _androidBanner = String.fromEnvironment('ADMOB_BANNER_ANDROID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111');
const _iosBanner = String.fromEnvironment('ADMOB_BANNER_IOS',
    defaultValue: 'ca-app-pub-3940256099942544/2934735716');

bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

Future<bool>? _ready;

/// Runs the UMP consent flow first and only initializes the ads SDK when the
/// user's choices (or region) allow requesting ads.
Future<void> initAds() {
  if (!_supported) return Future.value();
  _ready ??= _initialize();
  return _ready!.then((_) {});
}

Future<bool> _initialize() async {
  try {
    final info = ConsentInformation.instance;
    final consentDone = Completer<void>();
    info.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
        consentDone.complete();
      },
      (_) => consentDone.complete(),
    );
    await consentDone.future;
    if (!await info.canRequestAds()) return false;
    await MobileAds.instance.initialize();
    return true;
  } catch (_) {
    return false;
  }
}

Widget buildPlatformAdBanner() =>
    _supported ? const _BannerAdView() : const SizedBox.shrink();

class _BannerAdView extends StatefulWidget {
  const _BannerAdView();

  @override
  State<_BannerAdView> createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<_BannerAdView> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await initAds();
    if (_ready == null || !await _ready! || !mounted) return;
    final ad = BannerAd(
      adUnitId: Platform.isAndroid ? _androidBanner : _iosBanner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    _ad = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (!_loaded || ad == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: ad.size.width.toDouble(),
            height: ad.size.height.toDouble(),
            child: AdWidget(ad: ad),
          ),
        ],
      ),
    );
  }
}
