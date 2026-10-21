import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/auth_service.dart';
import '../../organizations/domain/organization_enums.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../../voting/data/participation_repository.dart';
import '../../voting/data/receipt_repository.dart';
import '../../voting/presentation/cast_vote_screen.dart';
import '../domain/election_card_state.dart';
import '../domain/voting_event.dart';
import 'providers/voter_portal_providers.dart';
import 'voter_election_card.dart' show formatDeadline;

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final eventAsync = ref.watch(singleVotingEventProvider(eventId));
    final currentUser = ref.watch(authServiceProvider).currentUser;

    return Scaffold(
      backgroundColor: kc.background,
      body: SafeArea(
        child: eventAsync.when(
          loading: () => const LoadingView(),
          error: (_, __) => ErrorView(
            type: ErrorViewType.generic,
            message: l10n.evLoadError,
            onRetry: () => ref.invalidate(singleVotingEventProvider(eventId)),
          ),
          data: (event) {
            if (event == null) {
              return ErrorView(
                  type: ErrorViewType.generic, title: l10n.evNotFoundTitle, message: l10n.evNotFoundBody);
            }
            if (currentUser == null) {
              return ErrorView(
                  type: ErrorViewType.generic, title: l10n.evSignInTitle, message: l10n.evSignInBody);
            }

            final participationAsync = ref.watch(participationStatusProvider((
              organizationId: event.organizationId,
              eventId: event.id,
              userId: currentUser.uid,
            )));
            final isWide = ResponsiveLayout.isWide(context);
            final main = _MainColumn(
                event: event, currentUser: currentUser, participationAsync: participationAsync);
            final details = EventDetailsCard(event: event);

            return SingleChildScrollView(
              padding: ResponsiveLayout.pagePadding(context),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                        onPressed: () => context.go('/home'),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: Text(l10n.evBack),
                      ),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        StatusBadge.eventStatus(event.status.name),
                        StatusBadge.privacyMode(event.privacyMode.name),
                        StatusBadge(
                          label: event.votingType.label,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: kc.isDark ? 0.16 : 0.10),
                          textColor: kc.accentText,
                          icon: Icons.how_to_vote_rounded,
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Semantics(
                        header: true,
                        child: Text(event.title,
                            style: TextStyle(
                                fontSize: isWide ? 28 : 24,
                                fontWeight: FontWeight.bold,
                                color: kc.textPrimary)),
                      ),
                      if (event.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(event.description,
                            style: TextStyle(fontSize: 14, color: kc.textSecondary, height: 1.4)),
                      ],
                      const SizedBox(height: 24),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: main),
                            const SizedBox(width: 24),
                            SizedBox(width: 360, child: details),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [main, const SizedBox(height: 24), details],
                        ),
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
}

Widget _card(BuildContext context, {required Widget child, Color? tint}) {
  final kc = KivoraColors.of(context);
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: tint == null ? kc.surface : tint.withValues(alpha: kc.isDark ? 0.14 : 0.08),
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      border: Border.all(color: tint == null ? kc.border : tint.withValues(alpha: 0.5)),
    ),
    child: child,
  );
}

class _MainColumn extends ConsumerWidget {
  const _MainColumn({required this.event, required this.currentUser, required this.participationAsync});

  final VotingEvent event;
  final User currentUser;
  final AsyncValue<bool> participationAsync;

  bool get _finished =>
      event.status == VotingEventStatus.closed || event.status == VotingEventStatus.archived;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);

    final Widget participation = participationAsync.when(
      loading: () => _card(context,
          child: Row(children: [
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.evChecking, style: TextStyle(color: kc.textSecondary))),
          ])),
      // A failed lookup is never shown as "not voted": no ballot button.
      error: (_, __) => _card(context,
          tint: kc.warningText,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.evStatusLoadError, style: TextStyle(color: kc.textPrimary)),
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => ref.invalidate(participationStatusProvider),
              child: Text(l10n.evRetry),
            ),
          ])),
      data: (hasVoted) => hasVoted
          ? _VotedCard(event: event, userId: currentUser.uid)
          : _NotVotedCard(event: event),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        participation,
        if (_finished) ...[const SizedBox(height: 16), _ResultsCard(event: event)],
      ],
    );
  }
}

class _VotedCard extends ConsumerWidget {
  const _VotedCard({required this.event, required this.userId});

  final VotingEvent event;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    return _card(
      context,
      tint: kc.successText,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Icon(Icons.check_circle_rounded, color: kc.successText, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l10n.evVotedTitle,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                Text(l10n.evVotedBody, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Text(l10n.evVotedNote, style: TextStyle(fontSize: 14, color: kc.textSecondary, height: 1.4)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final router = GoRouter.of(context);
              final receipt =
                  await ref.read(receiptRepositoryProvider).getReceiptForEvent(event.id, userId);
              if (receipt != null) {
                router.push('/receipt', extra: {'receipt': receipt, 'eventTitle': event.title});
              } else {
                messenger.showSnackBar(SnackBar(content: Text(l10n.evReceiptMissing)));
              }
            },
            icon: const Icon(Icons.description_outlined, size: 18),
            label: Text(l10n.evViewReceipt),
          ),
        ],
      ),
    );
  }
}

class _NotVotedCard extends StatelessWidget {
  const _NotVotedCard({required this.event});

  final VotingEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final isActive = event.status == VotingEventStatus.active;
    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            onPressed: isActive ? () => context.push('/elections/${event.id}/vote') : null,
            icon: const Icon(Icons.how_to_vote_rounded, size: 18),
            label: Text(l10n.evProceed),
          ),
          if (!isActive) ...[
            const SizedBox(height: 12),
            Text(
              l10n.evNotAccepting(event.status.name),
              textAlign: TextAlign.center,
              style: TextStyle(color: kc.textSecondary, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

/// Closed/archived does not mean published. Admins can always open the
/// results screen (to calculate / publish); voters only when published.
class _ResultsCard extends ConsumerWidget {
  const _ResultsCard({required this.event});

  final VotingEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final isAdmin =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context?.member.role.isAdmin ?? false;
    final status = ref.watch(eventResultsStatusProvider(event.id)).valueOrNull ?? ResultsStatus.unknown;
    final closedOn = formatDeadline(context, event.endAt);

    final String title;
    final String body;
    final bool canOpen;
    switch (status) {
      case ResultsStatus.published:
        title = l10n.evResultsPublishedTitle;
        body = l10n.evResultsPublishedBody(closedOn);
        canOpen = true;
      case ResultsStatus.notPublished:
        title = l10n.evResultsPendingTitle;
        body = l10n.evResultsPendingBody(closedOn);
        canOpen = isAdmin;
      case ResultsStatus.unknown:
        title = l10n.evResultsUnknownTitle;
        body = l10n.evResultsUnknownBody;
        canOpen = isAdmin;
    }

    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Icon(Icons.bar_chart_rounded, color: kc.accentText, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kc.textPrimary)),
                Text(body, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              ]),
            ),
          ]),
          if (canOpen) ...[
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: () => context.push('/elections/${event.id}/results'),
              child: Text(l10n.evViewResults),
            ),
          ] else if (status == ResultsStatus.unknown) ...[
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => ref.invalidate(eventResultsStatusProvider(event.id)),
              child: Text(l10n.evRetry),
            ),
          ],
        ],
      ),
    );
  }
}

class EventDetailsCard extends ConsumerWidget {
  const EventDetailsCard({super.key, required this.event});

  final VotingEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final isAdmin =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context?.member.role.isAdmin ?? false;
    final s = event.status;
    final started = s == VotingEventStatus.active || s == VotingEventStatus.closed || s == VotingEventStatus.archived;
    final ended = s == VotingEventStatus.closed || s == VotingEventStatus.archived;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Semantics(
              header: true,
              child: Text(l10n.evDetails,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kc.textPrimary)),
            ),
          ),
          Divider(height: 1, color: kc.border),
          _row(context, Icons.how_to_vote_outlined, l10n.evType, event.votingType.label),
          Divider(height: 1, color: kc.border),
          _row(context, Icons.groups_outlined, l10n.evWho, event.eligibilityType.label),
          Divider(height: 1, color: kc.border),
          _row(context, Icons.schedule_rounded, started ? l10n.evOpened : l10n.evOpens,
              formatDeadline(context, event.startAt)),
          Divider(height: 1, color: kc.border),
          _row(context, Icons.event_busy_outlined, ended ? l10n.evClosed : l10n.evCloses,
              formatDeadline(context, event.endAt)),
          if (event.privacyMode == PrivacyMode.identifiable) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kc.warningText.withValues(alpha: kc.isDark ? 0.14 : 0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                border: Border.all(color: kc.warningText.withValues(alpha: 0.5)),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.person_outline_rounded, size: 18, color: kc.warningText),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(TextSpan(
                    style: TextStyle(fontSize: 14, color: kc.textPrimary, height: 1.4),
                    children: [
                      TextSpan(
                          text: '${l10n.evIdentifiableTitle} ',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: l10n.evIdentifiableBody),
                    ],
                  )),
                ),
              ]),
            ),
          ],
          const SizedBox(height: 12),
          if (isAdmin &&
              (s == VotingEventStatus.active || s == VotingEventStatus.closed || s == VotingEventStatus.draft)) ...[
            Divider(height: 1, color: kc.border),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (s == VotingEventStatus.active || s == VotingEventStatus.closed)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    onPressed: () => context.push('/admin/events/${event.id}/monitor'),
                    icon: const Icon(Icons.analytics_outlined, size: 18),
                    label: Text(l10n.evMonitor),
                  ),
                if (s == VotingEventStatus.draft)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                    onPressed: () => context.push('/admin/events/${event.id}/edit'),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l10n.evEditBuilder),
                  ),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, String value) {
    final kc = KivoraColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: kc.accentText),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(fontSize: 14, color: kc.textSecondary)),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kc.textPrimary)),
            ]),
          ),
        ],
      ),
    );
  }
}
