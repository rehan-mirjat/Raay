import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/loading_view.dart';
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

class _PendingInvitationsWidgetState
    extends ConsumerState<PendingInvitationsWidget> {
  String? _revokingId;

  String _formatExpiry(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    final expires = DateTime.tryParse(isoDate);
    if (expires == null) return '';
    final diff = expires.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inDays >= 1) {
      return 'Expires in ${diff.inDays} ${diff.inDays == 1 ? "day" : "days"}';
    } else if (diff.inHours >= 1) {
      return 'Expires in ${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"}';
    } else if (diff.inMinutes >= 1) {
      return 'Expires in ${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"}';
    }
    return 'Expiring soon';
  }

  Future<void> _revoke(String invitationId, String email) async {
    if (invitationId.isEmpty || _revokingId != null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Revoke this invitation?'),
        content: Text(
          '${email.isEmpty ? 'The recipient' : email} will no longer be able to accept it. You can invite them again later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Keep'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Revoke'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _revokingId = invitationId);
    try {
      await ref
          .read(organizationRepositoryProvider)
          .revokeInvitation(invitationId);
      ref.invalidate(pendingInvitationsProvider(widget.organizationId));
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Invitation revoked successfully.'),
          backgroundColor: AppTheme.success,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
              'Failed to revoke invitation: ${e.toString().replaceAll("Exception: ", "")}'),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _revokingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final invitationsAsync =
        ref.watch(pendingInvitationsProvider(widget.organizationId));
    // Intentionally narrower than ResponsiveLayout.compactBreakpoint: this is
    // an embedded card (not a full page), so it has far less width to work
    // with than the screen it sits on.
    final compact = MediaQuery.sizeOf(context).width < 500;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: KivoraColors.borderOf(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 14 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pending Invitations',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context)),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, size: 20),
                  tooltip: 'Refresh Invitations',
                  onPressed: () => ref.invalidate(
                      pendingInvitationsProvider(widget.organizationId)),
                ),
              ],
            ),
            Divider(height: 20),
            invitationsAsync.when(
              loading: () => const LoadingView(),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Could not load pending invitations.',
                      style: TextStyle(color: AppTheme.error),
                    ),
                    SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => ref.invalidate(
                          pendingInvitationsProvider(widget.organizationId)),
                      icon: Icon(Icons.refresh_rounded),
                      label: Text('Try again'),
                    ),
                  ],
                ),
              ),
              data: (invitations) {
                if (invitations.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No pending invitations found for this organization.',
                      style: TextStyle(
                          color: KivoraColors.textSecondaryOf(context), fontSize: 13),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invitations.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = invitations[index];
                    final email = item['email'] as String? ?? '';
                    final role =
                        (item['role'] as String? ?? 'member').toLowerCase();
                    final invitationId = item['invitationId'] as String? ?? '';
                    final expiryText =
                        _formatExpiry(item['expiresAt'] as String?);
                    final isExpired = expiryText == 'Expired';
                    final isAdminRole = role == 'admin';
                    final canRevoke = widget.isOwner || !isAdminRole;
                    final isWorking = _revokingId == invitationId;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Icons.mark_email_unread_outlined,
                          color: AppTheme.primaryBlue, size: 22),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: KivoraColors.textPrimaryOf(context)),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isAdminRole
                                  ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              role.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isAdminRole
                                      ? AppTheme.primaryBlue
                                      : KivoraColors.textPrimaryOf(context)),
                            ),
                          ),
                        ],
                      ),
                      subtitle: expiryText.isNotEmpty
                          ? Text(expiryText,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isExpired
                                      ? AppTheme.error
                                      : KivoraColors.textSecondaryOf(context)))
                          : null,
                      trailing: canRevoke
                          ? OutlinedButton(
                              onPressed: _revokingId != null
                                  ? null
                                  : () => _revoke(invitationId, email),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.error,
                                side: BorderSide(color: AppTheme.error),
                              ),
                              child: isWorking
                                  ? const SizedBox.square(
                                      dimension: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : Text(isExpired ? 'Remove' : 'Revoke'),
                            )
                          : Tooltip(
                              message:
                                  'Only Owner can revoke Admin-level invitations',
                              child: Icon(Icons.lock_outline,
                                  size: 18, color: KivoraColors.textSecondaryOf(context)),
                            ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
