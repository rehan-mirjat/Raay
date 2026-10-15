import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../organizations/domain/organization_enums.dart';
import '../../../organizations/presentation/providers/organization_providers.dart';
import '../../domain/voting_event.dart';
import '../../data/voting_event_repository.dart';
import '../providers/event_lifecycle_provider.dart';
import 'event_card.dart';

class AdminEventDashboardScreen extends ConsumerWidget {
  const AdminEventDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeContextState = ref.watch(activeOrganizationContextProvider);
    final orgContext = activeContextState.valueOrNull?.context;

    if (orgContext == null) {
      return const Scaffold(
        body: ErrorView(type: ErrorViewType.generic, 
          title: 'No Active Organization',
          message: 'Please select an organization context to access the event management dashboard.',
        ),
      );
    }

    final orgId = orgContext.organization.id;
    final role = orgContext.member.role;

    if (orgContext.organization.status == OrganizationStatus.suspended) {
      return const Scaffold(
        body: ErrorView(type: ErrorViewType.generic, 
          title: 'Organization suspended',
          message: 'This organization is currently suspended. Voting event management is disabled.',
        ),
      );
    }

    if (!role.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
         context.go('/home'); 
      });
      return const Scaffold(body: LoadingView(message: 'Verifying administrative access...'));
    }

    final eventsAsync = ref.watch(votingEventRepositoryProvider).watchOrganizationVotingEvents(orgId);
    final lifecycleState = ref.watch(eventLifecycleProvider);

    ref.listen<EventLifecycleState>(eventLifecycleProvider, (prev, next) {
       if (next.error != null && (prev?.error != next.error)) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!), backgroundColor: AppTheme.error));
       }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Stack(
        children: [
          StreamBuilder<List<VotingEvent>>(
            stream: eventsAsync,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingView(message: 'Loading organization events...');
              }

              if (snapshot.hasError) {
                return ErrorView(type: ErrorViewType.generic, 
                  message: 'Error loading events: ${snapshot.error}',
                  onRetry: () => ref.invalidate(votingEventRepositoryProvider),
                );
              }

              final events = snapshot.data ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Page Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceBlue,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.calendar_today_rounded,
                                color: AppTheme.primaryBlue,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Event Management',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.secondaryNavy,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Create, manage and organize events for your community.',
                                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            if (events.isNotEmpty)
                              _AnimatedCreateButton(
                                onPressed: () => context.go('/admin/events/new'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        if (events.isEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 24),
                              // Illustration Treatment
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 160,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(22),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceWhite,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                                          blurRadius: 20,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_rounded,
                                          size: 52,
                                          color: AppTheme.primaryBlue,
                                        ),
                                        Positioned(
                                          bottom: -4,
                                          right: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: AppTheme.primaryBlue,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'No voting events found.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.secondaryNavy,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Get started by creating a new voting event\nfor your organization members.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 28),

                              _AnimatedCreateButton(
                                onPressed: () => context.go('/admin/events/new'),
                                isPrimaryCta: true,
                              ),

                              const SizedBox(height: 48),

                              _buildGuidanceCardsGrid(context),
                            ],
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: events.length,
                            itemBuilder: (context, index) {
                              final event = events[index];
                              return EventCard(event: event);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          if (lifecycleState.isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.2),
              child: const LoadingView(message: 'Processing lifecycle update...'),
            ),
        ],
      ),
    );
  }
}

Widget _buildGuidanceCardsGrid(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 700;
      final cardWidth = isWide ? (constraints.maxWidth - 36) / 4 : double.infinity;

      final cards = [
        _buildInfoCard(
          context,
          title: 'Set up your event',
          subtitle: 'Define the event details, voting rules and schedule.',
          icon: Icons.calendar_today_rounded,
          width: cardWidth,
        ),
        _buildInfoCard(
          context,
          title: 'Invite participants',
          subtitle: 'Add organization members and manage their access.',
          icon: Icons.people_outline_rounded,
          width: cardWidth,
        ),
        _buildInfoCard(
          context,
          title: 'Track & manage',
          subtitle: 'Monitor participation and view results in real-time.',
          icon: Icons.shield_outlined,
          width: cardWidth,
        ),
        _buildInfoCard(
          context,
          title: 'Build engagement',
          subtitle: 'Make decisions together with your community.',
          icon: Icons.bar_chart_rounded,
          width: cardWidth,
        ),
      ];

      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards,
      );
    },
  );
}

Widget _buildInfoCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required IconData icon,
  required double width,
}) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppTheme.surfaceWhite,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.borderLight),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppTheme.secondaryNavy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _AnimatedCreateButton extends StatefulWidget {
  const _AnimatedCreateButton({
    required this.onPressed,
    this.isPrimaryCta = false,
  });

  final VoidCallback onPressed;
  final bool isPrimaryCta;

  @override
  State<_AnimatedCreateButton> createState() => _AnimatedCreateButtonState();
}

class _AnimatedCreateButtonState extends State<_AnimatedCreateButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isReducedMotion = MediaQuery.of(context).disableAnimations;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: (_isPressed && !isReducedMotion) ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: widget.isPrimaryCta ? 24 : 18,
              vertical: widget.isPrimaryCta ? 14 : 10,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: _isHovered ? 0.35 : 0.2),
                  blurRadius: _isHovered ? 12 : 6,
                  offset: Offset(0, _isHovered ? 4 : 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(Icons.add, size: 12, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  'Create Voting Event',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.isPrimaryCta ? 14 : 13,
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedSlide(
                  offset: (_isHovered && !isReducedMotion)
                      ? const Offset(0.2, 0)
                      : Offset.zero,
                  duration: const Duration(milliseconds: 150),
                  child: const Icon(Icons.east_rounded, size: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
