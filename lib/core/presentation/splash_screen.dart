import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../layout/responsive.dart';
import '../theme/app_theme.dart';
import '../../core/theme/kivora_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const SplashScreen({
    super.key,
    this.errorMessage,
    this.onRetry,
  });

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Desktop windows are wide and comparatively short, so a tall
            // mobile-portrait layout (logo near the top, trust badge pinned
            // to the very bottom edge) reads as disconnected - the footer
            // ends up floating far away from the content it relates to.
            // On wide screens, group everything into one vertically
            // centered, width-capped composition instead.
            if (isWide) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildBrandHero(),
                        const SizedBox(height: 40),
                        _buildFooterBadge(),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 12),
                      _buildBrandHero(),
                      _buildFooterBadge(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrandHero() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App icon badge - the source artwork already includes its own
            // rounded corners, background, and glow, so it's shown directly
            // rather than nested inside another decorative container.
            Semantics(
              label: 'Kivora Logo',
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // App Title & Tagline
            Semantics(
              header: true,
              child: Text(
                'Kivora',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  color: KivoraColors.textPrimaryOf(context),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Enterprise Multi-Tenant E-Voting',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                color: KivoraColors.textSecondaryOf(context),
              ),
            ),
            const SizedBox(height: 40),

            // Dynamic Status / Error State
            if (widget.errorMessage != null)
              _buildErrorCard(context)
            else
              _buildLoadingIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterBadge() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 14,
            color: KivoraColors.textSecondaryOf(context),
          ),
          const SizedBox(width: 6),
          Text(
            'Server-Authorized & Tenant-Isolated',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: KivoraColors.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Initializing secure session...',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: KivoraColors.textSecondaryOf(context),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.error.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppTheme.error,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'Connection Error',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: KivoraColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.errorMessage ?? 'Failed to connect to Kivora services.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: KivoraColors.textSecondaryOf(context),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          if (widget.onRetry != null)
            ElevatedButton.icon(
              onPressed: widget.onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry Connection'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
