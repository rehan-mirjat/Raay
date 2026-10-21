import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_button.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/organization_repository.dart';
import '../domain/organization_enums.dart';
import '../../../core/utils/friendly_error.dart';

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
          content: Text(friendlyError(e)),
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
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return ok == true && mounted;
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

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

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: kc.surface,
      child: SizedBox(
        width: (screenWidth - 80).clamp(280.0, 480.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryBlue,
                      child: Text(
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kc.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, color: kc.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(KivoraIcons.x, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),
                _infoRow(context, 'Role', roleStr.toUpperCase()),
                _infoRow(context, 'Status', statusStr.toUpperCase()),
                _infoRow(context, 'Department', deptName),
                _infoRow(context, 'Observer Access', isTargetObserver ? 'Granted' : 'None'),
                if (_isLoading) ...[
                  const SizedBox(height: 16),
                  const LoadingView(),
                ],
                const SizedBox(height: 24),
                if (!_isLoading) ...[
                  if (canManageRole && isTargetMember) ...[
                    KivoraButton(
                      type: KivoraButtonType.secondary,
                      icon: KivoraIcons.shieldCheck,
                      label: 'Promote to Admin',
                      onPressed: () => _performAction(
                        () => repo.updateMemberRole(
                            organizationId: widget.organizationId,
                            targetUid: targetUid,
                            newRole: 'admin'),
                        'Promoted to Admin successfully.',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (canManageRole && isTargetAdmin) ...[
                    KivoraButton(
                      type: KivoraButtonType.secondary,
                      icon: KivoraIcons.user,
                      label: 'Demote to Member',
                      onPressed: () => _performAction(
                        () => repo.updateMemberRole(
                            organizationId: widget.organizationId,
                            targetUid: targetUid,
                            newRole: 'member'),
                        'Demoted to Member successfully.',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (canManageObserver && !isTargetObserver) ...[
                    KivoraButton(
                      type: KivoraButtonType.secondary,
                      icon: KivoraIcons.eye,
                      label: 'Grant Observer Access',
                      onPressed: () => _performAction(
                        () => repo.setObserverStatus(
                            organizationId: widget.organizationId,
                            targetUid: targetUid,
                            isObserver: true),
                        'Granted observer access.',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (canManageObserver && isTargetObserver) ...[
                    KivoraButton(
                      type: KivoraButtonType.secondary,
                      icon: KivoraIcons.eyeOff,
                      label: 'Revoke Observer Access',
                      onPressed: () => _performAction(
                        () => repo.setObserverStatus(
                            organizationId: widget.organizationId,
                            targetUid: targetUid,
                            isObserver: false),
                        'Revoked observer access.',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (canManageStatus && isTargetActive) ...[
                    KivoraButton(
                      type: KivoraButtonType.secondary,
                      icon: KivoraIcons.userX,
                      label: 'Deactivate Member',
                      onPressed: () => _performAction(
                        () => repo.updateMemberStatus(
                            organizationId: widget.organizationId,
                            targetUid: targetUid,
                            newStatus: 'inactive'),
                        'Deactivated member successfully.',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (canManageStatus && !isTargetActive) ...[
                    KivoraButton(
                      type: KivoraButtonType.secondary,
                      icon: KivoraIcons.userCheck,
                      label: 'Reactivate Member',
                      onPressed: () => _performAction(
                        () => repo.updateMemberStatus(
                            organizationId: widget.organizationId,
                            targetUid: targetUid,
                            newStatus: 'active'),
                        'Reactivated member successfully.',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (canRemove) ...[
                    KivoraButton(
                      type: KivoraButtonType.destructive,
                      icon: KivoraIcons.trash2,
                      label: 'Remove Member',
                      onPressed: () async {
                        final confirmed = await _confirm(
                          title: 'Remove $displayName?',
                          message:
                              'They will lose access to this organization immediately.',
                          confirmLabel: 'Remove Member',
                        );
                        if (confirmed) {
                          await _performAction(
                            () => repo.removeMember(
                                organizationId: widget.organizationId,
                                targetUid: targetUid),
                            'Member removed from organization.',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
                KivoraButton(
                  type: KivoraButtonType.ghost,
                  label: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    final kc = KivoraColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: kc.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: kc.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
