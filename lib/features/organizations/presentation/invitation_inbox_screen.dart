import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../voting_events/presentation/voter_election_card.dart' show formatDeadline;
import '../data/organization_repository.dart';
import 'providers/organization_providers.dart';

class InvitationInboxScreen extends ConsumerStatefulWidget {
  const InvitationInboxScreen({super.key});

  @override
  ConsumerState<InvitationInboxScreen> createState() => _InvitationInboxScreenState();
}

class _InvitationInboxScreenState extends ConsumerState<InvitationInboxScreen> {
  String? _respondingTo;

  Future<void> _respond(Map<String, dynamic> invitation, bool accept) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final invitationId = invitation['invitationId'] as String? ?? '';
    final orgName = (invitation['organizationName'] as String?) ?? l10n.inbDefaultOrg;
    if (invitationId.isEmpty || _respondingTo != null) return;

    if (!accept) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.inbDeclineTitle),
          content: Text(l10n.inbDeclineBody(orgName)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.inbKeep),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  foregroundColor: RaayColors.of(ctx).errorText),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.inbDeclineConfirm),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    setState(() => _respondingTo = invitationId);
    try {
      final result = await ref
          .read(organizationRepositoryProvider)
          .respondToInvitation(invitationId: invitationId, accept: accept);
      if (accept) {
        ref.invalidate(userMembershipsProvider);
        ref.invalidate(userOrganizationsProvider);
        ref.invalidate(activeOrganizationContextProvider);
        await ref.read(activeOrgIdProvider.notifier).selectOrganization(result.organizationId);
      }
      ref.invalidate(memberInvitationsProvider);
      messenger.showSnackBar(SnackBar(
          content: Text(accept ? l10n.inbJoined(result.organizationName) : l10n.inbDeclined)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.inbRespondFailed)));
    } finally {
      if (mounted) setState(() => _respondingTo = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = RaayColors.of(context);
    final invitations = ref.watch(memberInvitationsProvider);
    final isDesktop = ResponsiveLayout.isWide(context);

    return Scaffold(
      backgroundColor: kc.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxFormWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(l10n.inbTitle,
                      style: TextStyle(
                          fontSize: isDesktop ? 28 : 24,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary)),
                ),
                const SizedBox(height: 4),
                Text(l10n.inbSubtitle, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                const SizedBox(height: 24),
                invitations.when(
                  loading: () => const Padding(padding: EdgeInsets.all(32), child: LoadingView()),
                  error: (_, __) => ErrorView(
                    type: ErrorViewType.generic,
                    message: l10n.inbLoadError,
                    onRetry: () => ref.invalidate(memberInvitationsProvider),
                  ),
                  data: (items) {
                    if (items.isEmpty) return const _Empty();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(l10n.inbPending(items.length),
                            style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                        const SizedBox(height: 12),
                        for (final inv in items) ...[
                          InvitationCard(
                            invitation: inv,
                            busy: _respondingTo == inv['invitationId'],
                            anyBusy: _respondingTo != null,
                            onAccept: () => _respond(inv, true),
                            onDecline: () => _respond(inv, false),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.help_outline, size: 16, color: kc.textSecondary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(l10n.inbHelp,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kc.textSecondary, fontSize: 14)),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(children: [
        ExcludeSemantics(child: Icon(Icons.notifications_none_rounded, size: 48, color: kc.accentText)),
        const SizedBox(height: 16),
        Text(l10n.inbEmptyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kc.textPrimary)),
        const SizedBox(height: 8),
        Text(l10n.inbEmptyBody,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
      ]),
    );
  }
}

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    super.key,
    required this.invitation,
    required this.busy,
    required this.anyBusy,
    required this.onAccept,
    required this.onDecline,
  });

  final Map<String, dynamic> invitation;
  final bool busy;
  final bool anyBusy;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    final orgName = (invitation['organizationName'] as String?) ?? l10n.inbDefaultOrg;
    final role = ((invitation['role'] as String?) ?? 'member').toLowerCase();
    final expiresAt = parseFirestoreDate(invitation['expiresAt']);
    final expired = expiresAt != null && expiresAt.isBefore(DateTime.now());
    final expiryText = expiresAt == null
        ? l10n.inbNoExpiry
        : (expired ? l10n.inbExpired : l10n.inbExpires(formatDeadline(context, expiresAt)));

    const spinner = SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                ),
                child: Text(orgName.isEmpty ? 'O' : orgName[0].toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kc.accentText)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orgName,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kc.textPrimary)),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                      StatusBadge.role(role),
                      Text(expiryText,
                          style: TextStyle(fontSize: 14, color: expired ? kc.errorText : kc.textSecondary)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.inbJoinLine(orgName, role),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kc.textPrimary)),
          const SizedBox(height: 2),
          Text(l10n.inbAcceptNote(orgName),
              style: TextStyle(fontSize: 14, color: kc.textSecondary)),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 12, children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: anyBusy || expired ? null : onAccept,
              icon: busy ? spinner : const Icon(Icons.check_rounded, size: 18),
              label: Text(expired ? l10n.inbAcceptExpired : l10n.inbAccept),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: anyBusy ? null : onDecline,
              icon: const Icon(Icons.close_rounded, size: 18),
              label: Text(l10n.inbDecline),
            ),
          ]),
        ],
      ),
    );
  }
}
