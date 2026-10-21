import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/utils/date_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../data/organization_repository.dart';

final pendingInvitationsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, organizationId) async {
  return ref
      .watch(organizationRepositoryProvider)
      .getPendingInvitations(organizationId);
});

class PendingInvitationsWidget extends ConsumerStatefulWidget {
  const PendingInvitationsWidget({
    super.key,
    required this.organizationId,
    required this.isOwner,
  });

  final String organizationId;
  final bool isOwner;

  @override
  ConsumerState<PendingInvitationsWidget> createState() =>
      _PendingInvitationsWidgetState();
}

class _PendingInvitationsWidgetState extends ConsumerState<PendingInvitationsWidget> {
  String? _revokingId;

  /// Expiry as structured data so the text can be localized; null = unknown.
  ({String kind, int n})? _expiry(dynamic rawDate) {
    final expires = parseFirestoreDate(rawDate);
    if (expires == null) return null;
    final diff = expires.difference(DateTime.now());
    if (diff.isNegative) return (kind: 'expired', n: 0);
    if (diff.inDays >= 1) return (kind: 'days', n: diff.inDays);
    if (diff.inHours >= 1) return (kind: 'hours', n: diff.inHours);
    if (diff.inMinutes >= 1) return (kind: 'minutes', n: diff.inMinutes);
    return (kind: 'soon', n: 0);
  }

  Future<void> _revoke(String invitationId, String email) async {
    if (invitationId.isEmpty || _revokingId != null) return;
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.invRevokeTitle),
        content: Text(l10n.invRevokeBody(email.isEmpty ? l10n.invRecipient : email)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.invKeep),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: KivoraColors.of(ctx).errorText),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.invRevoke),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _revokingId = invitationId);
    try {
      await ref.read(organizationRepositoryProvider).revokeInvitation(invitationId);
      ref.invalidate(pendingInvitationsProvider(widget.organizationId));
      messenger.showSnackBar(SnackBar(content: Text(l10n.invRevoked)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.invRevokeFailed)));
    } finally {
      if (mounted) setState(() => _revokingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final invitationsAsync = ref.watch(pendingInvitationsProvider(widget.organizationId));

    String expiryText(({String kind, int n}) e) => switch (e.kind) {
          'expired' => l10n.invExpired,
          'days' => l10n.invExpiresDays(e.n),
          'hours' => l10n.invExpiresHours(e.n),
          'minutes' => l10n.invExpiresMinutes(e.n),
          _ => l10n.invExpiringSoon,
        };

    Widget content = invitationsAsync.when(
      loading: () => const Padding(
          padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      error: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.invLoadError, style: TextStyle(color: kc.errorText)),
            TextButton.icon(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => ref.invalidate(pendingInvitationsProvider(widget.organizationId)),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.invTryAgain),
            ),
          ],
        ),
      ),
      data: (invitations) {
        if (invitations.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(l10n.invNone, style: TextStyle(color: kc.textSecondary, fontSize: 14)),
          );
        }
        return Column(
          children: [
            for (var i = 0; i < invitations.length; i++) ...[
              if (i > 0) Divider(height: 1, color: kc.border),
              _row(context, l10n, kc, invitations[i], expiryText),
            ],
          ],
        );
      },
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(l10n.invTitle,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kc.textPrimary)),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                tooltip: l10n.invRefresh,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: () => ref.invalidate(pendingInvitationsProvider(widget.organizationId)),
              ),
            ],
          ),
          Divider(height: 8, color: kc.border),
          content,
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    AppLocalizations l10n,
    KivoraColors kc,
    Map<String, dynamic> item,
    String Function(({String kind, int n})) expiryText,
  ) {
    final email = item['email'] as String? ?? '';
    final role = (item['role'] as String? ?? 'member').toLowerCase();
    final invitationId = item['invitationId'] as String? ?? '';
    final expiry = _expiry(item['expiresAt']);
    final isExpired = expiry?.kind == 'expired';
    final canRevoke = widget.isOwner || role != 'admin';
    final isWorking = _revokingId == invitationId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, right: 12),
            child: Icon(Icons.mark_email_unread_outlined, color: kc.accentText, size: 22),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: kc.textPrimary)),
                const SizedBox(height: 4),
                Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  StatusBadge.role(role),
                  if (expiry != null)
                    Text(expiryText(expiry),
                        style: TextStyle(
                            fontSize: 14, color: isExpired ? kc.errorText : kc.textSecondary)),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (canRevoke)
            OutlinedButton(
              onPressed: _revokingId != null ? null : () => _revoke(invitationId, email),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: kc.errorText,
                side: BorderSide(color: kc.errorText),
              ),
              child: isWorking
                  ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(isExpired ? l10n.invRemove : l10n.invRevoke),
            )
          else
            Tooltip(
              message: l10n.invOwnerOnly,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.lock_outline, size: 18, color: kc.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}
