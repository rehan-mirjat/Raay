import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Public release metadata contains no secrets. Only trusted operators write it.
class ReleasePolicy {
  const ReleasePolicy(this.minimumBuild, this.updateUrl);
  final int minimumBuild;
  final Uri updateUrl;

  static ReleasePolicy? parse(
      Map<String, dynamic>? data, String platform, String packageName) {
    if (data == null || data['enabled'] != true) return null;
    final minimum = data['minimumBuild'];
    final uri =
        Uri.tryParse(data['updateUrl'] is String ? data['updateUrl'] : '');
    if (minimum is! int ||
        minimum < 1 ||
        uri == null ||
        uri.scheme != 'https' ||
        uri.userInfo.isNotEmpty ||
        uri.hasPort) {
      return null;
    }
    final validStore = platform == 'android'
        ? uri.host == 'play.google.com' &&
            uri.path == '/store/apps/details' &&
            uri.queryParameters['id'] == packageName
        : platform == 'ios' &&
            uri.host == 'apps.apple.com' &&
            RegExp(r'/id[0-9]+$').hasMatch(uri.path);
    return validStore ? ReleasePolicy(minimum, uri) : null;
  }

  bool requiresUpdate(int installedBuild) => installedBuild < minimumBuild;
}

/// An update UX gate, not a substitute for backend authorization or App Check.
/// A failed refresh retains a cached mandatory update, including after restart. A first-time
/// network failure allows access so outages do not prevent voting.
class AppUpdateGate extends StatefulWidget {
  const AppUpdateGate({super.key, required this.child});
  final Widget child;
  @override
  State<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends State<AppUpdateGate>
    with WidgetsBindingObserver {
  bool _checking = true;
  bool _busy = false;
  bool _blocked = false;
  Uri? _store;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    if (_busy) return;
    _busy = true;
    try {
      if (kIsWeb ||
          ![TargetPlatform.android, TargetPlatform.iOS]
              .contains(defaultTargetPlatform)) {
        return;
      }
      final platform =
          defaultTargetPlatform == TargetPlatform.android ? 'android' : 'ios';
      final info =
          await PackageInfo.fromPlatform().timeout(const Duration(seconds: 6));
      final build = int.tryParse(info.buildNumber);
      if (build == null) return;
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = 'appReleasePolicy.$platform';
      final cached = prefs.getString(cacheKey);
      if (cached != null) {
        try {
          final policy = ReleasePolicy.parse(
              Map<String, dynamic>.from(jsonDecode(cached) as Map),
              platform,
              info.packageName);
          if (mounted && policy != null) {
            setState(() {
              _blocked = policy.requiresUpdate(build);
              _store = policy.updateUrl;
            });
          }
        } catch (_) {
          await prefs.remove(cacheKey);
        }
      }
      final snap = await FirebaseFirestore.instance
          .collection('appReleases')
          .doc(platform)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 6));
      final policy =
          ReleasePolicy.parse(snap.data(), platform, info.packageName);
      if (policy != null) {
        await prefs.setString(
            cacheKey,
            jsonEncode({
              'enabled': true,
              'minimumBuild': policy.minimumBuild,
              'updateUrl': policy.updateUrl.toString(),
            }));
      } else {
        await prefs.remove(cacheKey);
      }
      if (!mounted) return;
      setState(() {
        _blocked = policy?.requiresUpdate(build) ?? false;
        _store = policy?.updateUrl;
        _error = null;
      });
    } catch (_) {
      if (mounted && _blocked) {
        setState(() => _error =
            'Could not refresh the update status. Check your connection and retry.');
      }
    } finally {
      _busy = false;
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _update() async {
    try {
      final uri = _store;
      if (uri == null ||
          !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw StateError('Store unavailable');
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'Could not open the store. Try again or open Raay in your app store.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checking && !_blocked) return widget.child;
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          if (_checking)
            const CircularProgressIndicator()
          else ...[
            const Icon(Icons.system_update_rounded, size: 56),
            const SizedBox(height: 20),
            Text('Update Raay to continue',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            const Text(
                'A newer supported version is required. Update the app, then return here.',
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
                onPressed: _update,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Update app')),
            TextButton(onPressed: _check, child: const Text('Check again')),
            if (_error != null) Text(_error!, textAlign: TextAlign.center),
          ],
        ]),
      ),
    ))));
  }
}
