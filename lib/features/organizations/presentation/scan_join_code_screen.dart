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

/// Camera-driven "Scan to Join" screen. On a valid detection it hands the
/// extracted code to JoinOrganizationScreen via [initialCode] - that screen
/// still owns the real join flow (preview -> confirm -> joinOrganizationWithCode),
/// this screen's only job is getting the code off a QR into that form.
class ScanJoinCodeScreen extends StatefulWidget {
  const ScanJoinCodeScreen({super.key});

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
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: KivoraColors.of(context).accentText, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Text(
              'Point your camera at an organization\'s joining QR code',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
