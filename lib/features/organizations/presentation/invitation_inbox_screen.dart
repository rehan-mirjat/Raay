import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';

import '../data/organization_repository.dart';
import 'providers/organization_providers.dart';

class InvitationInboxScreen extends ConsumerStatefulWidget {
  const InvitationInboxScreen({super.key});

  @override
  ConsumerState<InvitationInboxScreen> createState() =>
      _InvitationInboxScreenState();
}

class _InvitationInboxScreenState extends ConsumerState<InvitationInboxScreen> {
  String? _respondingTo;

  Future<void> _respond(
    BuildContext context,
    Map<String, dynamic> invitation,
    bool accept,
  ) async {
    final invitationId = invitation['invitationId'] as String? ?? '';
    if (invitationId.isEmpty || _respondingTo != null) return;
    setState(() => _respondingTo = invitationId);

    if (!accept) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Decline this invitation?'),
          content: Text(
            'You will not join ${invitation['organizationName'] ?? 'this organization'}. The administrator can invite you again later.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Keep invitation'),
            ),
            FilledButton.tonal(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Decline'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) {
        if (mounted) setState(() => _respondingTo = null);
        return;
      }
    }

    try {
      final result = await ref
          .read(organizationRepositoryProvider)
          .respondToInvitation(invitationId: invitationId, accept: accept);
      if (accept) {
        ref.invalidate(userMembershipsProvider);
        ref.invalidate(userOrganizationsProvider);
        ref.invalidate(activeOrganizationContextProvider);
        await ref
            .read(activeOrgIdProvider.notifier)
            .selectOrganization(result.organizationId);
      }
      ref.invalidate(memberInvitationsProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(accept
              ? 'You joined ${result.organizationName}.'
              : 'Invitation declined.'),
          backgroundColor: accept ? AppTheme.success : null,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _respondingTo = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final invitations = ref.watch(memberInvitationsProvider);
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.mark_email_unread_outlined, color: AppTheme.primaryBlue, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'NOTIFICATIONS',
                          style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'View invitations',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.secondaryNavy,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Review invitations to join a new workspace and choose how you\'d like to respond.',
                                style: TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                invitations.when(
                  loading: () => const LoadingView(message: 'Checking your notifications…'),
                  error: (error, _) => ErrorView(type: ErrorViewType.generic, 
                    title: 'Could not load notifications',
                    message: error.toString().replaceFirst('Exception: ', ''),
                    onRetry: () => ref.invalidate(memberInvitationsProvider),
                  ),
                  data: (items) {
                    if (items.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: AppTheme.surfaceBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.notifications_none_rounded,
                                  size: 40, color: AppTheme.primaryBlue),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'You’re all caught up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryNavy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Organization invitations will appear here. You can accept or decline each one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.borderLight),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: AppTheme.primaryBlue, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${items.length} pending',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.secondaryNavy),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 24),
                          itemBuilder: (context, index) {
                            final invitation = items[index];
                            final organizationName =
                                invitation['organizationName'] as String? ?? 'Organization';
                            final roleValue = invitation['role'] as String? ?? 'member';
                            final roleDisplay = roleValue.isEmpty
                                ? 'Member'
                                : '${roleValue[0].toUpperCase()}${roleValue.substring(1)}';
                            final isWorking = _respondingTo == invitation['invitationId'];
                            final expiresAt = DateTime.tryParse(
                              invitation['expiresAt'] as String? ?? '',
                            );
                            final isExpired =
                                expiresAt != null && expiresAt.isBefore(DateTime.now());

                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppTheme.borderLight),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF0F5FF), // Light blue tint
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                          border: Border(bottom: BorderSide(color: AppTheme.borderLight)),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.info_outline, color: AppTheme.primaryBlue, size: 18),
                                                SizedBox(width: 8),
                                                Text('Action required', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13)),
                                              ],
                                            ),
                                            Text('Respond before the invitation expires', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 48,
                                                  height: 48,
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      organizationName.isNotEmpty
                                                          ? organizationName[0].toUpperCase()
                                                          : 'O',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                        color: AppTheme.primaryBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        organizationName,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppTheme.secondaryNavy,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      const Text(
                                                        'You\'ve been invited to join this organization.',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppTheme.textSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(20)),
                                                  child: Row(
                                                    children: [
                                                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFC2410C), shape: BoxShape.circle)),
                                                      const SizedBox(width: 6),
                                                      const Text('Awaiting response', style: TextStyle(color: Color(0xFFC2410C), fontWeight: FontWeight.bold, fontSize: 12)),
                                                    ]
                                                  )
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 24),
                                            const Divider(height: 1, color: AppTheme.borderLight),
                                            const SizedBox(height: 24),
                                            
                                            if (isMobile)
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets.all(8),
                                                              decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                                              child: const Icon(Icons.person_outline, color: AppTheme.primaryBlue, size: 20),
                                                            ),
                                                            const SizedBox(width: 12),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Text('Role', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                                                Text(roleDisplay, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.secondaryNavy)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets.all(8),
                                                              decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8)),
                                                              child: const Icon(Icons.event_available_outlined, color: Color(0xFFB45309), size: 20),
                                                            ),
                                                            const SizedBox(width: 12),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Text('Expires', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                                                Text(
                                                                  expiresAt != null ? MaterialLocalizations.of(context).formatShortDate(expiresAt.toLocal()) : 'Never',
                                                                  style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: isExpired ? AppTheme.error : AppTheme.secondaryNavy,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 24),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: _buildActions(context, invitation, isWorking, isExpired),
                                                  ),
                                                ],
                                              )
                                            else
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                                        child: const Icon(Icons.person_outline, color: AppTheme.primaryBlue, size: 20),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text('Role', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                                          Text(roleDisplay, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.secondaryNavy)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(width: 1, height: 40, color: AppTheme.borderLight),
                                                const SizedBox(width: 24),
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8)),
                                                        child: const Icon(Icons.event_available_outlined, color: Color(0xFFB45309), size: 20),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          const Text('Expires', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                                          Text(
                                                            expiresAt != null ? MaterialLocalizations.of(context).formatMediumDate(expiresAt.toLocal()) : 'Never',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                              color: isExpired ? AppTheme.error : AppTheme.secondaryNavy,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ..._buildActions(context, invitation, isWorking, isExpired),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.borderLight),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.verified_user_outlined, color: AppTheme.primaryBlue, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Join $organizationName as a $roleDisplay',
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryNavy, fontSize: 14),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Accepting adds $organizationName to your organizations. You can switch workspaces at any time.',
                                              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 48),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline, size: 16, color: AppTheme.textSecondary),
                    SizedBox(width: 8),
                    Text('Need help with an invitation? Contact Kivora support.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, Map<String, dynamic> invitation, bool isWorking, bool isExpired) {
    return [
      OutlinedButton.icon(
        onPressed: _respondingTo == null
            ? () => _respond(context, invitation, false)
            : null,
        icon: isWorking
            ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.close_rounded, size: 18),
        label: const Text('Decline'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      const SizedBox(width: 12),
      FilledButton.icon(
        onPressed: _respondingTo == null && !isExpired
            ? () => _respond(context, invitation, true)
            : null,
        icon: isWorking
            ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.check_rounded, size: 18),
        label: const Text('Accept invitation'),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    ];
  }
}
