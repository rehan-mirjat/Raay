import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/layout/responsive.dart';
import '../../core/theme/raay_colors.dart';
import '../../core/utils/date_text.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/loading_view.dart';
import '../../l10n/app_localizations.dart';
import 'notification_providers.dart';

/// Recipient-scoped inbox backed by the server-written notifications
/// collection. Invitation requests remain in their dedicated invitation page.
class NotificationInboxScreen extends ConsumerStatefulWidget {
  const NotificationInboxScreen({super.key});

  @override
  ConsumerState<NotificationInboxScreen> createState() =>
      _NotificationInboxScreenState();
}

class _NotificationInboxScreenState
    extends ConsumerState<NotificationInboxScreen> {
  int _limit = 50;
  bool _markingAll = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = RaayColors.of(context);
    final inbox = ref.watch(notificationInboxProvider(_limit));
    final wide = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: kc.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: ListView(
            padding: EdgeInsets.all(wide ? 32 : 16),
            children: [
              Row(children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(l10n.notificationsTitle,
                        style: TextStyle(
                            fontSize: wide ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: kc.textPrimary)),
                  ),
                ),
                IconButton(
                  tooltip: l10n.plRefresh,
                  constraints:
                      const BoxConstraints(minHeight: 48, minWidth: 48),
                  onPressed: () =>
                      ref.invalidate(notificationInboxProvider(_limit)),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ]),
              const SizedBox(height: 8),
              inbox.when(
                loading: () => const Padding(
                    padding: EdgeInsets.all(32), child: LoadingView()),
                error: (_, __) => ErrorView(
                  type: ErrorViewType.generic,
                  message: l10n.ntLoadError,
                  onRetry: () =>
                      ref.invalidate(notificationInboxProvider(_limit)),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.notifications_none_rounded,
                            size: 44, color: kc.textSecondary),
                        const SizedBox(height: 12),
                        Text(l10n.shNoNotifications,
                            style: TextStyle(color: kc.textSecondary)),
                      ]),
                    );
                  }
                  final unread = items.where((item) => !item.read).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (unread.isNotEmpty)
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                                minimumSize: const Size(48, 48)),
                            onPressed:
                                _markingAll ? null : () => _markAll(unread),
                            icon: _markingAll
                                ? const SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.done_all_rounded),
                            label: Text(l10n.shMarkRead),
                          ),
                        ),
                      const SizedBox(height: 8),
                      for (final item in items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _NotificationCard(
                            item: item,
                            onTap: () => _open(item),
                          ),
                        ),
                      if (items.length >= _limit)
                        Center(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                minimumSize: const Size(48, 48)),
                            onPressed: () => setState(() => _limit += 50),
                            child: Text(l10n.plLoadOlder),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markAll(List<AppNotification> unread) async {
    final l = AppLocalizations.of(context);
    setState(() => _markingAll = true);
    try {
      await markAllUnreadNotificationsRead();
      ref.invalidate(notificationInboxProvider(_limit));
      ref.invalidate(unreadNotificationsProvider);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l.ntUpdateFailed)));
      }
    } finally {
      if (mounted) setState(() => _markingAll = false);
    }
  }

  Future<void> _open(AppNotification item) async {
    final l = AppLocalizations.of(context);
    if (!item.read) {
      try {
        await markNotificationRead(item.id);
        ref.invalidate(notificationInboxProvider(_limit));
        ref.invalidate(unreadNotificationsProvider);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.ntUpdateFailed)));
        }
      }
    }
    if (item.votingEventId != null && mounted) {
      context.go('/elections/${item.votingEventId}');
    }
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.onTap});

  final AppNotification item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    return Material(
      color: kc.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kc.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.type == 'RESULTS_PUBLISHED'
                    ? Icons.poll_outlined
                    : Icons.notifications_active_outlined,
                color: item.read ? kc.textSecondary : kc.accentText,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: TextStyle(
                            fontWeight:
                                item.read ? FontWeight.w500 : FontWeight.w700,
                            color: kc.textPrimary)),
                    if (item.message.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(item.message,
                          style:
                              TextStyle(color: kc.textSecondary, height: 1.4)),
                    ],
                    const SizedBox(height: 8),
                    if (item.createdAt != null)
                      Text(formatDateTimeText(context, item.createdAt!),
                          style:
                              TextStyle(fontSize: 12, color: kc.textSecondary)),
                  ],
                ),
              ),
              if (!item.read)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, top: 6),
                  child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                          color: kc.accentText, shape: BoxShape.circle)),
                ),
              if (item.votingEventId != null)
                Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    color: kc.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
