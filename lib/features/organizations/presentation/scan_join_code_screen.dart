import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/kivora_colors.dart';

const _kivoraJoinPrefix = 'KIVORA-JOIN:';

/// Extracts a joining code from scanned QR text. Accepts both the app's own
/// `KIVORA-JOIN:<code>` QR payload (see joining_codes_screen.dart) and a bare
/// code, so a code copy-pasted into a generic QR generator still works.
String? extractJoiningCode(String rawValue) {
  final trimmed = rawValue.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith(_kivoraJoinPrefix)) {
    final code = trimmed.substring(_kivoraJoinPrefix.length).trim();
    return code.isEmpty ? null : code;
  }
  // A bare code: letters/digits only, matching the format createJoiningCode
  // generates server-side.
  if (RegExp(r'^[A-Za-z0-9]{4,12}$').hasMatch(trimmed)) {
    return trimmed;
  }
  return null;
}

typedef ScannerErrorBuilder = Widget Function(
    BuildContext, MobileScannerException);

/// Plain-language reason the camera cannot be used, with what to do instead.
String scannerProblemMessage(MobileScannerErrorCode code) {
  switch (code) {
    case MobileScannerErrorCode.permissionDenied:
      return 'Camera access is blocked. Allow the camera for this site or app in your settings, or enter the code by hand.';
    case MobileScannerErrorCode.unsupported:
      return 'This browser or device cannot scan QR codes. Enter the joining code by hand instead.';
    default:
      return 'The camera could not be started. You can enter the joining code by hand instead.';
  }
}

/// Camera-driven "Scan to Join" screen. On a valid detection it hands the
/// extracted code to JoinOrganizationScreen via [initialCode] - that screen
/// still owns the real join flow (preview -> confirm -> joinOrganizationWithCode),
/// this screen's only job is getting the code off a QR into that form.
class ScanJoinCodeScreen extends StatefulWidget {
  const ScanJoinCodeScreen({super.key, this.scannerBuilder});

  /// Replaces the camera view (tests). Receives the screen's error builder so a
  /// fake camera can exercise the same fallback a real failure shows.
  final Widget Function(BuildContext context, ScannerErrorBuilder onError)?
      scannerBuilder;

  @override
  State<ScanJoinCodeScreen> createState() => _ScanJoinCodeScreenState();
}

class _ScanJoinCodeScreenState extends State<ScanJoinCodeScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      if (rawValue == null) continue;
      final code = extractJoiningCode(rawValue);
      if (code != null) {
        _handled = true;
        context.go('/orgs/join', extra: {'initialCode': code});
        return;
      }
    }
  }

  /// Shown instead of the camera when it cannot run. Entering the code by hand
  /// is the same join flow the QR feeds, so nothing is lost.
  Widget _error(BuildContext context, MobileScannerException e) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.no_photography_outlined,
              color: Colors.white, size: 40),
          const SizedBox(height: 16),
          Text(scannerProblemMessage(e.errorCode),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, height: 1.5)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan to Join'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                );
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.scannerBuilder?.call(context, _error) ??
              MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
                errorBuilder: (context, e) => _error(context, e),
              ),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(
                    color: KivoraColors.of(context).accentText, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  'Point your camera at an organization\'s joining QR code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.white70),
                    minimumSize: const Size(48, 48),
                  ),
                  // The same join flow the QR feeds; the code is typed instead.
                  onPressed: () => context.go('/orgs/join'),
                  icon: const Icon(Icons.keyboard_outlined, size: 18),
                  label: const Text('Enter the code instead'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
