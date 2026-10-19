import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../organizations/presentation/membership_directory_screen.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../../voting_events/data/voting_event_repository.dart';
import '../../voting_events/domain/voting_event.dart';
import '../domain/department.dart';
import 'create_edit_department_dialog.dart';
import 'providers/department_providers.dart';
import '../data/department_repository.dart';

class DepartmentsScreen extends ConsumerStatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  ConsumerState<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends ConsumerState<DepartmentsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedSort = 'az'; // 'az', 'za', 'members'

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, Department dept) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Department',
            style: TextStyle(color: AppTheme.error)),
        content: Text(
          'Are you sure you want to delete "${dept.name}"?\n\nThis permanently deletes the department. Existing member records may retain a reference to the deleted department, but the deleted department will no longer be valid for assignment or voting eligibility.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref
                    .read(departmentRepositoryProvider)
                    .deleteDepartment(dept.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Department deleted successfully.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Failed to delete: ${e.toString().replaceAll("Exception: ", "")}'),
                      backgroundColor: AppTheme.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  List<Department> _filterAndSortDepartments(
    List<Department> rawDepartments,
    List<Map<String, dynamic>> allMembers,
  ) {
    var filtered = rawDepartments.where((d) {
      if (_searchQuery.isEmpty) return true;
      final name = d.name.toLowerCase();
      final desc = d.description.toLowerCase();
      return name.contains(_searchQuery) || desc.contains(_searchQuery);
    }).toList();

    if (_selectedSort == 'az') {
      filtered
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_selectedSort == 'za') {
      filtered
          .sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    } else if (_selectedSort == 'members') {
      filtered.sort((a, b) {
        final countA =
            allMembers.where((m) => m['departmentId'] == a.id).length;
        final countB =
            allMembers.where((m) => m['departmentId'] == b.id).length;
        return countB.compareTo(countA);
      });
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final activeContextState = ref.watch(activeOrganizationContextProvider);
    final departmentsAsync = ref.watch(activeOrganizationDepartmentsProvider);

    final orgContext = activeContextState.valueOrNull?.context;
    if (orgContext == null) {
      return Scaffold(
        body: EmptyView(
          icon: Icons.business_outlined,
          title: 'Choose an organization to get started',
          message:
              'Departments belong to an organization. Select one to view its departments and manage their details.',
          actionLabel: 'Select organization',
          onAction: () => context.go('/home'),
        ),
      );
    }

    final orgId = orgContext.organization.id;
    final isManager = orgContext.member.isAdmin;
    final isDesktop = ResponsiveLayout.isWide(context);

    final membersAsync = ref.watch(organizationMembersDirectoryProvider(orgId));
    final eventsStream = ref
        .watch(votingEventRepositoryProvider)
        .watchOrganizationVotingEvents(orgId);

    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      body: departmentsAsync.when(
        loading: () => const LoadingView(message: 'Loading departments...'),
        error: (err, stack) => ErrorView(
          type: ErrorViewType.generic,
          message: 'Failed to load departments: $err',
          onRetry: () => ref.invalidate(activeOrganizationDepartmentsProvider),
        ),
        data: (allDepartments) {
          final userDepts = isManager
              ? allDepartments
              : (orgContext.member.departmentId != null
                  ? allDepartments
                      .where((d) => d.id == orgContext.member.departmentId)
                      .toList()
                  : <Department>[]);

          final allMembers = membersAsync.valueOrNull ?? [];
          final displayDepartments =
              _filterAndSortDepartments(userDepts, allMembers);

          return StreamBuilder<List<VotingEvent>>(
            stream: eventsStream,
            builder: (context, eventsSnapshot) {
              final allEvents = eventsSnapshot.data ?? [];

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 28,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Page Header (Title, Subtitle & New Department CTA)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Departments',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: KivoraColors.textPrimaryOf(context),
                                        ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Group members into departments to limit who is eligible to vote in an event.',
                                    style: TextStyle(
                                        color: KivoraColors.textSecondaryOf(context),
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            if (isManager) ...[
                              SizedBox(width: 16),
                              FilledButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        CreateEditDepartmentDialog(
                                      organizationId:
                                          orgContext.organization.id,
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add_rounded, size: 18),
                                label: Text('New department'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppTheme.primaryBlue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 28),

                        // 2. Toolbar (Search Input & Sort Dropdown)
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Search departments',
                                  prefixIcon: Icon(Icons.search_rounded,
                                      color: KivoraColors.textSecondaryOf(context), size: 20),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: KivoraColors.borderOf(context)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: KivoraColors.borderOf(context)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: AppTheme.primaryBlue,
                                        width: 1.5),
                                  ),
                                  fillColor: KivoraColors.surfaceOf(context),
                                  filled: true,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),

                            // Sort Dropdown
                            PopupMenuButton<String>(
                              tooltip: 'Sort departments',
                              offset: const Offset(0, 42),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: KivoraColors.borderOf(context)),
                              ),
                              color: KivoraColors.surfaceOf(context),
                              onSelected: (val) {
                                setState(() {
                                  _selectedSort = val;
                                });
                              },
                              itemBuilder: (context) => [
                                _sortMenuItem('az', 'Sort: Name A to Z'),
                                _sortMenuItem('za', 'Sort: Name Z to A'),
                                _sortMenuItem('members', 'Sort: Most members'),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: KivoraColors.surfaceOf(context),
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: KivoraColors.borderOf(context)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.swap_vert_rounded,
                                        size: 16,
                                        color: KivoraColors.textSecondaryOf(context)),
                                    SizedBox(width: 8),
                                    Text(
                                      _getSortLabel(_selectedSort),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: KivoraColors.textPrimaryOf(context)),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 16,
                                        color: KivoraColors.textSecondaryOf(context)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // 3. Sub-header Counter & Hint
                        Row(
                          children: [
                            Text(
                              '${userDepts.length} ${userDepts.length == 1 ? 'department' : 'departments'}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: KivoraColors.textPrimaryOf(context)),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Manage members directly, or use ••• for more actions',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: KivoraColors.textSecondaryOf(context)),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // 4. Department Cards Grid
                        if (userDepts.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: EmptyView(
                              icon: isManager
                                  ? Icons.domain_disabled_outlined
                                  : Icons.lock_outline_rounded,
                              title: isManager
                                  ? 'No Departments Found'
                                  : 'No Department Assigned',
                              message: isManager
                                  ? 'Create departments to organize members and restrict voting eligibility.'
                                  : 'You are not currently assigned to any department in this organization.',
                              actionLabel:
                                  isManager ? 'Create Department' : null,
                              onAction: isManager
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CreateEditDepartmentDialog(
                                          organizationId:
                                              orgContext.organization.id,
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                          )
                        else
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cardWidth = constraints.maxWidth >= 900
                                  ? (constraints.maxWidth - 32) / 3
                                  : (constraints.maxWidth >= 600
                                      ? (constraints.maxWidth - 16) / 2
                                      : double.infinity);

                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  ...displayDepartments.map((dept) {
                                    final deptMembers = allMembers
                                        .where(
                                            (m) => m['departmentId'] == dept.id)
                                        .toList();
                                    final eventsCount = allEvents.where((e) {
                                      return e.eligibilityDepartmentIds
                                          .contains(dept.id);
                                    }).length;

                                    return SizedBox(
                                      width: cardWidth,
                                      child: _DepartmentCard(
                                        dept: dept,
                                        deptMembers: deptMembers,
                                        eventsCount: eventsCount,
                                        isManager: isManager,
                                        onManageMembers: () => context
                                            .go('/orgs/departments/${dept.id}'),
                                        onEdit: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CreateEditDepartmentDialog(
                                              organizationId:
                                                  orgContext.organization.id,
                                              departmentToEdit: dept,
                                            ),
                                          );
                                        },
                                        onDelete: () => _showDeleteConfirmation(
                                            context, ref, dept),
                                      ),
                                    );
                                  }),

                                  // Add New Department Dashed Card
                                  if (isManager && _searchQuery.isEmpty)
                                    SizedBox(
                                      width: cardWidth,
                                      child: _NewDepartmentDashedCard(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CreateEditDepartmentDialog(
                                              organizationId:
                                                  orgContext.organization.id,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getSortLabel(String key) {
    switch (key) {
      case 'za':
        return 'Sort: Name Z to A';
      case 'members':
        return 'Sort: Most members';
      case 'az':
      default:
        return 'Sort: Name A to Z';
    }
  }

  PopupMenuItem<String> _sortMenuItem(String value, String label) {
    final isSelected = _selectedSort == value;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          if (isSelected)
            Icon(Icons.check_rounded,
                size: 16, color: AppTheme.primaryBlue)
          else
            SizedBox(width: 16),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppTheme.primaryBlue : KivoraColors.textPrimaryOf(context),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DEPARTMENT CARD WIDGET
// =============================================================================

class _DepartmentCard extends StatefulWidget {
  final Department dept;
  final List<Map<String, dynamic>> deptMembers;
  final int eventsCount;
  final bool isManager;
  final VoidCallback onManageMembers;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DepartmentCard({
    required this.dept,
    required this.deptMembers,
    required this.eventsCount,
    required this.isManager,
    required this.onManageMembers,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_DepartmentCard> createState() => _DepartmentCardState();
}

class _DepartmentCardState extends State<_DepartmentCard> {
  bool _isHovered = false;

  static const List<Color> _avatarColors = [
    Color(0xFF2563EB), // Blue
    Color(0xFF0D9488), // Teal
    Color(0xFF7C3AED), // Purple
    Color(0xFFD97706), // Amber
    Color(0xFFDC2626), // Red
  ];

  @override
  Widget build(BuildContext context) {
    final memberCount = widget.deptMembers.length;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: KivoraColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isHovered
                ? AppTheme.primaryBlue.withValues(alpha: 0.4)
                : KivoraColors.borderOf(context),
            width: _isHovered ? 1.4 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.05 : 0.02),
              blurRadius: _isHovered ? 16 : 8,
              offset: _isHovered ? const Offset(0, 6) : const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Department Name + Member Count
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.apartment_rounded,
                      color: AppTheme.primaryBlue,
                      size: 22,
                    ),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dept.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
                        style: TextStyle(
                            fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Middle Row: Avatars Stack & Event Usage Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Member Avatar Stack
                _buildAvatarStack(widget.deptMembers),

                // Event Usage Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.eventsCount > 0
                        ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                        : KivoraColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.eventsCount > 0
                        ? 'Used in ${widget.eventsCount} ${widget.eventsCount == 1 ? 'event' : 'events'}'
                        : 'Not used yet',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: widget.eventsCount > 0
                          ? AppTheme.primaryBlue
                          : KivoraColors.textSecondaryOf(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(height: 1, color: KivoraColors.borderOf(context)),
            SizedBox(height: 12),

            // Footer Row: Manage Members Link & Popup Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: widget.onManageMembers,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline_rounded,
                            size: 16, color: AppTheme.primaryBlue),
                        SizedBox(width: 6),
                        Text(
                          'Manage members',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.isManager)
                  PopupMenuButton<String>(
                    tooltip: 'Department actions',
                    offset: const Offset(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: KivoraColors.borderOf(context)),
                    ),
                    color: KivoraColors.surfaceOf(context),
                    icon: Icon(Icons.more_horiz_rounded,
                        color: KivoraColors.textSecondaryOf(context)),
                    onSelected: (value) {
                      if (value == 'edit') {
                        widget.onEdit();
                      } else if (value == 'manage') {
                        widget.onManageMembers();
                      } else if (value == 'delete') {
                        widget.onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        enabled: false,
                        height: 32,
                        child: Text(
                          widget.dept.name,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: KivoraColors.textSecondaryOf(context)),
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined,
                                size: 16, color: KivoraColors.textPrimaryOf(context)),
                            const SizedBox(width: 8),
                            const Text('Rename',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'manage',
                        child: Row(
                          children: [
                            Icon(Icons.people_outline_rounded,
                                size: 16, color: KivoraColors.textPrimaryOf(context)),
                            const SizedBox(width: 8),
                            const Text('Manage members',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded,
                                  size: 16, color: AppTheme.error),
                              SizedBox(width: 8),
                              Text('Delete department',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.error)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(List<Map<String, dynamic>> members) {
    if (members.isEmpty) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person_outline_rounded,
            size: 16, color: AppTheme.primaryBlue),
      );
    }

    const maxVisible = 3;
    final visibleMembers = members.take(maxVisible).toList();
    final remaining = members.length - maxVisible;

    return SizedBox(
      height: 28,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: (visibleMembers.length * 20.0) + 8,
            child: Stack(
              children: visibleMembers.asMap().entries.map((entry) {
                final idx = entry.key;
                final member = entry.value;
                final name = member['displayName'] as String? ?? 'User';
                final initials = _getInitials(name);
                final bgColor = _avatarColors[idx % _avatarColors.length];

                return Positioned(
                  left: idx * 18.0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (remaining > 0) ...[
            SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '+$remaining',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'U';
  }
}

// =============================================================================
// NEW DEPARTMENT DASHED CARD
// =============================================================================

class _NewDepartmentDashedCard extends StatefulWidget {
  final VoidCallback onTap;

  const _NewDepartmentDashedCard({required this.onTap});

  @override
  State<_NewDepartmentDashedCard> createState() =>
      _NewDepartmentDashedCardState();
}

class _NewDepartmentDashedCardState extends State<_NewDepartmentDashedCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          height: 180,
          decoration: BoxDecoration(
            color: _isHovered
                ? AppTheme.primaryBlue.withValues(alpha: 0.12).withValues(alpha: 0.5)
                : KivoraColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered ? AppTheme.primaryBlue : KivoraColors.borderOf(context),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
                ),
                child: Icon(Icons.add_rounded,
                    color: AppTheme.primaryBlue, size: 22),
              ),
              SizedBox(height: 12),
              Text(
                'New department',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Create a group for your members',
                style: TextStyle(fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
