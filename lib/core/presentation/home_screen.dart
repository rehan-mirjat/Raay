import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import '../layout/responsive.dart';
import '../../../core/widgets/error_view.dart';
import '../widgets/fade_through.dart';
import '../widgets/loading_view.dart';
import '../widgets/status_badge.dart';
import '../../features/departments/presentation/providers/department_providers.dart';
import '../../features/organizations/domain/organization_enums.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../features/voting_events/data/voting_event_repository.dart';
import '../../features/voting_events/domain/voting_event.dart';
import '../../features/onboarding/providers/onboarding_providers.dart';
import '../../features/onboarding/presentation/welcome_dialog.dart';
import '../../features/onboarding/presentation/quick_tour_overlay.dart';
import '../../features/onboarding/presentation/setup_checklist_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _welcomeDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowWelcome();
    });
  }

  void _checkAndShowWelcome() async {
    if (_welcomeDialogShown) return;
    final onboarding = ref.read(onboardingProvider);
    if (!onboarding.hasCompletedTour && mounted) {
      if (ModalRoute.of(context)?.isCurrent == true) {
        _welcomeDialogShown = true;
        final startTour = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const WelcomeDialog(),
        );
        if (startTour == true && mounted) {
          QuickTourOverlay.show(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeContextState = ref.watch(activeOrganizationContextProvider);

    return activeContextState.when(
      loading: () => const LoadingView(message: 'Restoring active context...'),
      error: (e, _) => ErrorView(
        type: ErrorViewType.generic,
        message: 'Failed to restore active organization: $e',
        onRetry: () => ref.invalidate(activeOrganizationContextProvider),
      ),
      data: (orgState) {
        if (orgState.selectionState ==
                ActiveOrgSelectionState.noOrganizations ||
            orgState.context == null) {
          return const _SrsWelcomeOverviewScreen();
        }

        final orgContext = orgState.context!;
        final isDesktop = ResponsiveLayout.isWide(context);
        final isAdmin = orgContext.member.role == OrganizationRole.owner ||
            orgContext.member.role == OrganizationRole.admin;
        final eventsArgs = (orgId: orgContext.organization.id, includeDrafts: isAdmin);
        final eventsAsync = ref.watch(organizationVotingEventsProvider(eventsArgs));

        final departmentsAsync =
            ref.watch(activeOrganizationDepartmentsProvider);
        return RefreshIndicator(
          color: AppTheme.primaryBlue,
          onRefresh: () async {
            ref.invalidate(activeOrganizationContextProvider);
            ref.invalidate(organizationVotingEventsProvider(eventsArgs));
            await Future.delayed(const Duration(milliseconds: 300));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Elections & Voting events',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.secondaryNavy),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage public and private decision channels for ${orgContext.organization.name}.',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (isAdmin)
                          OutlinedButton.icon(
                            onPressed: () => context.go('/admin/events'),
                            icon: const Icon(Icons.settings_outlined, size: 18),
                            label: const Text('Manage Events'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              eventsAsync.when(
                                loading: () => const LoadingView(
                                    message: 'Loading active elections...'),
                                error: (err, _) => ErrorView(
                                  type: ErrorViewType.generic,
                                  message: 'Error loading elections: $err',
                                  onRetry: () => ref.invalidate(
                                      organizationVotingEventsProvider(eventsArgs)),
                                ),
                                data: (allEvents) {
                                  final memberEvents = allEvents
                                      .where((e) =>
                                          e.status ==
                                              VotingEventStatus.active ||
                                          e.status == VotingEventStatus.closed)
                                      .toList();

                                  if (memberEvents.isEmpty) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 64, horizontal: 24),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceWhite,
                                        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                                        border: Border.all(
                                            color: AppTheme.borderLight),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryBlue
                                                  .withValues(alpha: 0.08),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                                Icons.inbox_outlined,
                                                size: 48,
                                                color: AppTheme.primaryBlue),
                                          ),
                                          const SizedBox(height: 24),
                                          const Text(
                                            'No Active Elections',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.secondaryNavy),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'There are currently no active or running elections inside the ${orgContext.organization.name}\ncontext. Start a new secure vote to gather member feedback.',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: AppTheme.textSecondary,
                                                height: 1.5),
                                          ),
                                          if (isAdmin) ...[
                                            const SizedBox(height: 32),
                                            FilledButton.icon(
                                              onPressed: () => context
                                                  .go('/admin/events/new'),
                                              icon: const Icon(Icons.add,
                                                  size: 18),
                                              label: const Text(
                                                  'Create Voting Event'),
                                              style: FilledButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 12),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: memberEvents.length,
                                    itemBuilder: (context, index) {
                                      final event = memberEvents[index];
                                      return FadeSlideIn(
                                        key: ValueKey(event.id),
                                        delay: Duration(
                                            milliseconds:
                                                40 * index.clamp(0, 8)),
                                        child: _buildMemberEventCard(
                                            context, event),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        if (isDesktop) ...[
                          const SizedBox(width: 32),
                          Expanded(
                            child: _buildRightSidebar(
                                context, orgContext, departmentsAsync),
                          ),
                        ],
                      ],
                    ),

                    if (!isDesktop) ...[
                      const SizedBox(height: 32),
                      _buildRightSidebar(context, orgContext, departmentsAsync),
                    ],

                    const SizedBox(height: 32),
                    // Bottom Summary Metrics Row
                    _buildSummaryMetrics(context, isDesktop),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRightSidebar(BuildContext context, dynamic orgContext,
      AsyncValue<List<dynamic>> departmentsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SetupChecklistWidget(),

        // Departments Card
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondaryNavy.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Departments',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.secondaryNavy),
                    ),
                    InkWell(
                      onTap: () => context.go('/orgs/departments'),
                      child: const Text('View All',
                          style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppTheme.borderLight),
              departmentsAsync.when(
                  loading: () => const LoadingView(),
                  error: (_, __) => const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Failed to load departments.',
                          style: TextStyle(color: AppTheme.error))),
                  data: (depts) {
                    if (depts.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No departments found.',
                            style: TextStyle(color: AppTheme.textSecondary)),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: depts.length > 4 ? 4 : depts.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: AppTheme.borderLight),
                      itemBuilder: (context, index) {
                        final dept = depts[index];
                        String badgeText = 'Standard';
                        Color badgeBg =
                            AppTheme.primaryBlue.withValues(alpha: 0.1);
                        Color badgeColor = AppTheme.primaryBlue;
                        if (index == 0) badgeText = 'Primary';
                        if (index == 2) {
                          badgeText = 'Restricted';
                          badgeBg = Colors.grey.shade100;
                          badgeColor = AppTheme.textSecondary;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dept.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppTheme.secondaryNavy),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text('View members',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(badgeText,
                                    style: TextStyle(
                                        color: badgeColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Security Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondaryNavy.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppTheme.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.shield_outlined,
                        color: AppTheme.success, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Secure Voting Sandbox',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.secondaryNavy),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Kivora uses end-to-end homomorphic cryptography. Your individual selection is completely decoupled from your identity receipt.',
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryMetrics(BuildContext context, bool isDesktop) {
    return IntrinsicHeight(
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: isDesktop ? 1 : 0,
            child: _buildMetricCard('REGISTERED VOTERS', 'All members', null),
          ),
          if (isDesktop)
            const SizedBox(width: 24)
          else
            const SizedBox(height: 16),
          Expanded(
            flex: isDesktop ? 1 : 0,
            child: _buildMetricCard(
                'ACTIVE DEPARTMENTS', 'View departments', null),
          ),
          if (isDesktop)
            const SizedBox(width: 24)
          else
            const SizedBox(height: 16),
          Expanded(
            flex: isDesktop ? 1 : 0,
            child: _buildMetricCard(
                'AUDIT VERIFIABILITY', '100% Cryptographic', AppTheme.success),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color? statusColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryNavy.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryNavy,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (statusColor != null) ...[
                Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: statusColor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor ?? AppTheme.secondaryNavy),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static final _dateFormat = DateFormat('MMM d, yyyy • h:mm a');

  Widget _buildMemberEventCard(BuildContext context, VotingEvent event) {
    final dateFormat = _dateFormat;
    final isActive = event.status == VotingEventStatus.active;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        side: BorderSide(
          color: isActive
              ? AppTheme.primaryBlue.withValues(alpha: 0.5)
              : AppTheme.borderLight,
          width: isActive ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryNavy),
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge.eventStatus(event.status.name),
              ],
            ),
            const SizedBox(height: 8),
            StatusBadge.privacyMode(event.privacyMode.name),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                event.description,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule_rounded,
                    size: 15, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Ends: ${dateFormat.format(event.endAt)}',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.go('/elections/${event.id}'),
                  icon: const Icon(Icons.info_outline_rounded, size: 16),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 38),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                const SizedBox(width: 8),
                if (isActive)
                  ElevatedButton.icon(
                    onPressed: () => context.go('/elections/${event.id}/vote'),
                    icon: const Icon(Icons.how_to_vote_rounded, size: 16),
                    label: const Text('Cast Vote'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 38),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SrsWelcomeOverviewScreen extends StatelessWidget {
  const _SrsWelcomeOverviewScreen();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isWide(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: isDesktop ? 48 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 48 : 32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.7)),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.secondaryNavy.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppTheme.surfaceBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.inventory_2_outlined,
                          size: 40, color: AppTheme.primaryBlue),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome to Kivora',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppTheme.secondaryNavy,
                                letterSpacing: -0.5,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your Voice, Your Choice.',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select an active organization context from the top bar to view active elections, manage\nmembers, or participate in secure voting.',
                      style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                          height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/orgs'),
                      icon: const Icon(Icons.menu_book_rounded, size: 18),
                      label: const Text('Browse Joined Organizations'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'PLATFORM CAPABILITIES & VERIFIABILITY',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.2),
              ),
              const SizedBox(height: 20),
              if (isDesktop)
                const IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _CapabilityCard(
                          icon: Icons.shield_outlined,
                          title: 'Cryptographic Receipts',
                          description:
                              'Every cast ballot generates an anonymous, tamper-evident SHA-256 receipt for independent verification.',
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _CapabilityCard(
                          icon: Icons.manage_accounts_outlined,
                          title: 'Multi-Tenant Security',
                          description:
                              'Role-based access control and department isolation ensure voting eligibility is strictly enforced.',
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _CapabilityCard(
                          icon: Icons.insights_rounded,
                          title: 'Lifecycle Auditing',
                          description:
                              'Voting events transition automatically through Scheduled, Active, and Closed lifecycles with immutable audit logs.',
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CapabilityCard(
                      icon: Icons.shield_outlined,
                      title: 'Cryptographic Receipts',
                      description:
                          'Every cast ballot generates an anonymous, tamper-evident SHA-256 receipt for independent verification.',
                    ),
                    SizedBox(height: 16),
                    _CapabilityCard(
                      icon: Icons.manage_accounts_outlined,
                      title: 'Multi-Tenant Security',
                      description:
                          'Role-based access control and department isolation ensure voting eligibility is strictly enforced.',
                    ),
                    SizedBox(height: 16),
                    _CapabilityCard(
                      icon: Icons.insights_rounded,
                      title: 'Lifecycle Auditing',
                      description:
                          'Voting events transition automatically through Scheduled, Active, and Closed lifecycles with immutable audit logs.',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapabilityCard extends StatelessWidget {
  const _CapabilityCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryNavy.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.secondaryNavy),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
