import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../services/auth_service.dart';

/// Shared frame for every platform screen: re-checks the platform-admin claim
/// (the server checks it again on every call), then shows a page header and
/// the content. Non-admins see an access-denied state, never the content.
class PlatformPage extends ConsumerWidget {
  const PlatformPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.builder,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(platformAdminProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: admin.when(
        loading: () =>
            LoadingView(message: AppLocalizations.of(context).plCheckingAccess),
        error: (_, __) => ErrorView(
            type: ErrorViewType.accessDenied,
            title: AppLocalizations.of(context).plDeniedTitle,
            message: AppLocalizations.of(context).plVerifyFailed),
        data: (isAdmin) {
          if (!isAdmin) {
            return ErrorView(
                type: ErrorViewType.accessDenied,
                title: AppLocalizations.of(context).plDeniedTitle,
                message: AppLocalizations.of(context).plOnlySuper);
          }
          final kc = KivoraColors.of(context);
          final wide = ResponsiveLayout.isWide(context);
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxWidth: ResponsiveLayout.maxContentWidth),
              child: ListView(
                padding: EdgeInsets.all(wide ? 32 : 16),
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 12,
                    spacing: 12,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                header: true,
                                child: Text(title,
                                    style: TextStyle(
                                        fontSize: wide ? 28 : 24,
                                        fontWeight: FontWeight.bold,
                                        color: kc.textPrimary)),
                              ),
                              const SizedBox(height: 4),
                              Text(subtitle,
                                  style: TextStyle(
                                      fontSize: 14, color: kc.textSecondary)),
                            ]),
                      ),
                      if (actions.isNotEmpty)
                        Wrap(spacing: 8, runSpacing: 8, children: actions),
                    ],
                  ),
                  const SizedBox(height: 20),
                  builder(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A bordered panel with a title, used for the sections of a platform screen.
class PlatformPanel extends StatelessWidget {
  const PlatformPanel(
      {super.key, required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kc.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: kc.textPrimary))),
          if (trailing != null) trailing!,
        ]),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}

/// Slim page header for the older platform screens that still own their
/// Scaffold: left-aligned title and a refresh button, no second app bar under
/// the shell's header.
class PlatformHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const PlatformHeaderBar(
      {super.key, required this.title, required this.onRefresh});
  final String title;
  final VoidCallback? onRefresh;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary)),
                ),
              ),
              IconButton(
                tooltip: AppLocalizations.of(context).plRefresh,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
