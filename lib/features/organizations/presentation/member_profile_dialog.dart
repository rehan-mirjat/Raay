import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/organization_repository.dart';
import '../domain/organization_enums.dart';

class MemberProfileDialog extends ConsumerStatefulWidget {
  const MemberProfileDialog({
    super.key,
    required this.organizationId,
    required this.callerRole,
    required this.memberData,
    required this.onChanged,
  });

  final String organizationId;
  final OrganizationRole callerRole;
  final Map<String, dynamic> memberData;
  final VoidCallback onChanged;

  @override
  ConsumerState<MemberProfileDialog> createState() =>
      _MemberProfileDialogState();
}

class _MemberProfileDialogState extends ConsumerState<MemberProfileDialog> {
  bool _isLoading = false;

  Future<void> _performAction(
      Future<void> Function() action, String successMessage) async {
    // Capture before awaiting: the dialog may be dismissed while the request runs.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isLoading = true);
    try {
      await action();
      widget.onChanged();
      messenger.showSnackBar(
        SnackBar(
            content: Text(successMessage), backgroundColor: AppTheme.success),
      );
      if (mounted) navigator.pop();
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return ok == true && mounted;
  }

  @override
  Widget build(BuildContext context) {
    final targetUid = widget.memberData['userId'] as String? ?? '';
    final displayName = widget.memberData['displayName'] as String? ?? 'User';
    final email = widget.memberData['email'] as String? ?? '';
    final roleStr = widget.memberData['role'] as String? ?? 'member';
    final statusStr = widget.memberData['status'] as String? ?? 'active';
    final deptName = widget.memberData['departmentName'] as String? ?? 'None';
    final isTargetObserver = widget.memberData['isObserver'] as bool? ?? false;

    final isTargetOwner = roleStr.toLowerCase() == 'owner';
    final isTargetAdmin = roleStr.toLowerCase() == 'admin';
    final isTargetMember = roleStr.toLowerCase() == 'member';
    final isTargetActive = statusStr.toLowerCase() == 'active';

    final isCallerOwner = widget.callerRole == OrganizationRole.owner;
    final isCallerAdmin = widget.callerRole == OrganizationRole.admin;

    final canManageRole = isCallerOwner && !isTargetOwner;
    final canManageStatus =
        (isCallerOwner && !isTargetOwner) || (isCallerAdmin && isTargetMember);
    final canRemove =
        (isCallerOwner && !isTargetOwner) || (isCallerAdmin && isTargetMember);
    final canManageObserver = (isCallerOwner || isCallerAdmin) && !isTargetOwner;

    final repo = ref.read(organizationRepositoryProvider);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppTheme.primaryBlue,
            child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(email,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          SizedBox(height: 8),
          _infoRow('Role', roleStr.toUpperCase()),
          _infoRow('Status', statusStr.toUpperCase()),
          _infoRow('Department', deptName),
          _infoRow('Observer', isTargetObserver ? 'Yes' : 'No'),
          if (_isLoading) ...[
            const LoadingView(),
          ],
        ],
      ),
      actions: [
        if (!_isLoading) ...[
          if (canManageRole && isTargetMember)
            TextButton(
              onPressed: () => _performAction(
                () => repo.updateMemberRole(
                    organizationId: widget.organizationId,
                    targetUid: targetUid,
                    newRole: 'admin'),
                'Promoted to Admin successfully.',
              ),
              child: Text('Promote to Admin'),
            ),
          if (canManageRole && isTargetAdmin)
            TextButton(
              onPressed: () => _performAction(
                () => repo.updateMemberRole(
                    organizationId: widget.organizationId,
                    targetUid: targetUid,
                    newRole: 'member'),
                'Demoted to Member successfully.',
              ),
              child: Text('Demote to Member'),
            ),
          if (canManageStatus && isTargetActive)
            TextButton(
              onPressed: () => _performAction(
                () => repo.updateMemberStatus(
                    organizationId: widget.organizationId,
                    targetUid: targetUid,
                    newStatus: 'inactive'),
                'Deactivated member successfully.',
              ),
              child: Text('Deactivate',
                  style: TextStyle(color: Colors.orange)),
            ),
          if (canManageStatus && !isTargetActive)
            TextButton(
              onPressed: () => _performAction(
                () => repo.updateMemberStatus(
                    organizationId: widget.organizationId,
                    targetUid: targetUid,
                    newStatus: 'active'),
                'Reactivated member successfully.',
              ),
              child: Text('Reactivate',
                  style: TextStyle(color: AppTheme.success)),
            ),
          if (canManageObserver && !isTargetObserver)
            TextButton(
              onPressed: () => _performAction(
                () => repo.setObserverStatus(
                    organizationId: widget.organizationId,
                    targetUid: targetUid,
                    isObserver: true),
                'Granted observer access.',
              ),
              child: Text('Grant Observer Access'),
            ),
          if (canManageObserver && isTargetObserver)
            TextButton(
              onPressed: () => _performAction(
                () => repo.setObserverStatus(
                    organizationId: widget.organizationId,
                    targetUid: targetUid,
                    isObserver: false),
                'Revoked observer access.',
              ),
              child: Text('Revoke Observer Access',
                  style: TextStyle(color: Colors.orange)),
            ),
          if (canRemove)
            TextButton(
              onPressed: () async {
                final confirmed = await _confirm(
                  title: 'Remove $displayName?',
                  message:
                      'They will lose access to this organization immediately. This cannot be undone from here.',
                  confirmLabel: 'Remove',
                );
                if (confirmed) {
                  await _performAction(
                    () => repo.removeMember(
                        organizationId: widget.organizationId,
                        targetUid: targetUid),
                    'Member removed from the organization.',
                  );
                }
              },
              child:
                  Text('Remove', style: TextStyle(color: AppTheme.error)),
            ),
        ],
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: KivoraColors.textPrimaryOf(context))),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.end,
                  softWrap: true,
                  style: TextStyle(color: KivoraColors.textSecondaryOf(context)))),
        ],
      ),
    );
  }
}
