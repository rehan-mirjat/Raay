import 'package:flutter/material.dart';
import '../../../../core/layout/responsive.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/raay_colors.dart';
import '../../../../l10n/app_localizations.dart';

class AuthSplitLayout extends StatelessWidget {
  final Widget child;
  final VoidCallback? onMobileBackTap;

  const AuthSplitLayout({
    super.key,
    required this.child,
    this.onMobileBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isWide(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isDesktop) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: onMobileBackTap != null
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  icon: Icon(Icons.arrow_back,
                      color: isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.textPrimary),
                  onPressed: onMobileBackTap,
                ),
              )
            : null,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                child,
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 16),
                  child: Text(
                    AppLocalizations.of(context).authTagline,
                    style: TextStyle(
                        color: RaayColors.of(context).textSecondary,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          // Left Side — Dark branding panel (always dark for contrast)
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    Color(0xFF0F2A3D), // Deep navy-teal
                    Color(0xFF0B1722), // Midnight navy
                    Color(0xFF0B1722),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Teal glow top-left
                  PositionedDirectional(
                    top: -120,
                    start: -80,
                    child: Container(
                      width: 420,
                      height: 420,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryBlue.withValues(alpha: 0.22),
                      ),
                    ),
                  ),
                  // Blue glow bottom-right
                  PositionedDirectional(
                    bottom: -80,
                    end: -80,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.secondaryBlue.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                  // Scrolls (never clips) when large text makes the content taller
                  // than the window; Spacers still space it out when it fits.
                  LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 48),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight - 96),
                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: Image.asset(
                                          'assets/icon/app_icon.png',
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      const Text(
                                        'Raay',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentCyan
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: AppTheme.accentCyan
                                              .withValues(alpha: 0.3),
                                          width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.accentCyan,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                            child: Text(
                                          AppLocalizations.of(context).alBadge,
                                          style: const TextStyle(
                                            color: AppTheme.accentCyan,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.1,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    AppLocalizations.of(context).alHeadline,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    AppLocalizations.of(context).alSub,
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.55),
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 48),
                                  _buildFeatureItem(
                                    icon: Icons.lock_outline,
                                    title: AppLocalizations.of(context).alP1,
                                    description:
                                        AppLocalizations.of(context).alP1b,
                                  ),
                                  const SizedBox(height: 28),
                                  _buildFeatureItem(
                                    icon: Icons.fingerprint,
                                    title: AppLocalizations.of(context).alP2,
                                    description:
                                        AppLocalizations.of(context).alP2b,
                                  ),
                                  const SizedBox(height: 28),
                                  _buildFeatureItem(
                                    icon: Icons.check_circle_outline,
                                    title: AppLocalizations.of(context).alP3,
                                    description:
                                        AppLocalizations.of(context).alP3b,
                                  ),
                                  const Spacer(),
                                  Divider(
                                      color:
                                          Colors.white.withValues(alpha: 0.1)),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          AppLocalizations.of(context).alCopy,
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withValues(alpha: 0.6),
                                              fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .alPlatforms,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: Colors.white
                                                  .withValues(alpha: 0.6),
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))),
                  ),
                ],
              ),
            ),
          ),
          // Right Side — Auth Form
          Expanded(
            flex: 1,
            child: Container(
              color: isDark
                  ? AppTheme.darkBackground
                  : RaayColors.backgroundOf(context),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      {required IconData icon,
      required String title,
      required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppTheme.primaryBlue.withValues(alpha: 0.25), width: 1),
          ),
          child: Icon(icon,
              color: const Color(0xFFAB98FF), // light violet
              size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
