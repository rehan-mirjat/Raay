import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kivora_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/kivora_animations.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../organizations/domain/organization_enums.dart';
import '../../../organizations/presentation/providers/organization_providers.dart';
import '../../domain/voting_event.dart';
import '../../data/voting_event_repository.dart';
import '../providers/event_lifecycle_provider.dart';
import '../voter_portal_screen.dart';
import 'event_card.dart';

enum _EventFilter { all, active, scheduled, draft, closed, archived }

extension on _EventFilter {
  String get label => switch (this) {
        _EventFilter.all => 'All',
        _EventFilter.active => 'Active',
        _EventFilter.scheduled => 'Scheduled',
        _EventFilter.draft => 'Draft',
        _EventFilter.closed => 'Closed',
        _EventFilter.archived => 'Archived',
      };

  /// Null means "no status filter" (the All chip). Cancelled events have no
  /// dedicated chip (matching the reference design) but remain visible
  /// under All rather than being permanently hidden.
  VotingEventStatus? get status => switch (this) {
        _EventFilter.all => null,
        _EventFilter.active => VotingEventStatus.active,
        _EventFilter.scheduled => VotingEventStatus.scheduled,
        _EventFilter.draft => VotingEventStatus.draft,
        _EventFilter.closed => VotingEventStatus.closed,
        _EventFilter.archived => VotingEventStatus.archived,
      };
}

class AdminEventDashboardScreen extends ConsumerStatefulWidget {
  const AdminEventDashboardScreen({super.key});

  @override
  ConsumerState<AdminEventDashboardScreen> createState() =>
      _AdminEventDashboardScreenState();
}

class _AdminEventDashboardScreenState
    extends ConsumerState<AdminEventDashboardScreen> {
  _EventFilter _filter = _EventFilter.all;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
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
      // Members land on the same "Events" nav destination as admins, but see
      // their own cross-organization voting portal instead of the admin
      // management console - not a silent bounce back to /home.
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: VoterPortalScreen(embedded: true)),
      );
    }

    final eventsAsync = ref.watch(votingEventRepositoryProvider).watchOrganizationVotingEvents(orgId, includeDrafts: true);
    final lifecycleState = ref.watch(eventLifecycleProvider);

    ref.listen<EventLifecycleState>(eventLifecycleProvider, (prev, next) {
       if (next.error != null && (prev?.error != next.error)) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error!), backgroundColor: AppTheme.error));
       }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
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

              return PageEntry(child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1040),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Page Header
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today_rounded,
                                    color: AppTheme.primaryBlue,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Event Management',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: KivoraColors.textPrimaryOf(context),
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Create, manage and organize events for your community.',
                                      style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => context.go('/admin/command-center'),
                                  icon: const Icon(Icons.dashboard_customize_outlined, size: 18),
                                  label: const Text('Command Center'),
                                ),
                                if (events.isNotEmpty)
                                  _AnimatedCreateButton(
                                    onPressed: () => context.go('/admin/events/new'),
                                  ),
                              ],
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
                                      color: KivoraColors.surfaceOf(context),
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
                              Text(
                                'No voting events found.',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: KivoraColors.textPrimaryOf(context),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Get started by creating a new voting event\nfor your organization members.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: KivoraColors.textSecondaryOf(context),
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
                        else ...[
                          _buildFilterAndSearchRow(context, events),
                          const SizedBox(height: 20),
                          Builder(builder: (context) {
                            final filtered = _applyFilter(events);
                            if (filtered.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 48),
                                child: Center(
                                  child: Text(
                                    _searchQuery.isNotEmpty
                                        ? 'No events match "$_searchQuery".'
                                        : 'No ${_filter.label.toLowerCase()} events.',
                                    style: TextStyle(
                                        color: KivoraColors.textSecondaryOf(context), fontSize: 14),
                                  ),
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final event = filtered[index];
                                return StaggeredListItem(
                                  index: index,
                                  child: EventCard(event: event),
                                );
                              },
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
              )); // PageEntry
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

  List<VotingEvent> _applyFilter(List<VotingEvent> events) {
    final status = _filter.status;
    final query = _searchQuery.trim().toLowerCase();
    return events.where((e) {
      if (status != null && e.status != status) return false;
      if (query.isNotEmpty && !e.title.toLowerCase().contains(query)) return false;
      return true;
    }).toList();
  }

  Widget _buildFilterAndSearchRow(BuildContext context, List<VotingEvent> events) {
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    final chips = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _EventFilter.values.map((f) {
        final count = f == _EventFilter.all
            ? events.length
            : events.where((e) => e.status == f.status).length;
        final selected = _filter == f;
        return InkWell(
          onTap: () => setState(() => _filter = f),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppTheme.primaryBlue : KivoraColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: selected ? AppTheme.primaryBlue : KivoraColors.borderOf(context),
              ),
            ),
            child: Text(
              '${f.label} $count',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : KivoraColors.textPrimaryOf(context),
              ),
            ),
          ),
        );
      }).toList(),
    );

    final search = SizedBox(
      width: isWide ? 260 : double.infinity,
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: const InputDecoration(
          hintText: 'Search events',
          prefixIcon: Icon(Icons.search_rounded, size: 20),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );

    if (isWide) {
      return Row(
        children: [
          Expanded(child: chips),
          const SizedBox(width: 16),
          search,
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        chips,
        const SizedBox(height: 12),
        search,
      ],
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
      color: KivoraColors.surfaceOf(context),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: KivoraColors.borderOf(context)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.12),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: KivoraColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: KivoraColors.textSecondaryOf(context),
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
