import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../organizations/presentation/membership_directory_screen.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../data/department_repository.dart';
import '../domain/department.dart';
import 'create_edit_department_dialog.dart';
import 'providers/department_providers.dart';

class DepartmentMembersScreen extends ConsumerStatefulWidget {
  const DepartmentMembersScreen({super.key, required this.departmentId});

  final String departmentId;

  @override
  ConsumerState<DepartmentMembersScreen> createState() =>
      _DepartmentMembersScreenState();
}

class _DepartmentMembersScreenState
    extends ConsumerState<DepartmentMembersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _selectedMemberFilter = 'all'; // 'all', 'unassigned', 'assigned'
  final Set<String> _pendingSelectedUids = {};
  bool _isAssigning = false;

  static const List<Color> _avatarColors = [
    Color(0xFF2563EB), // Blue
    Color(0xFF0D9488), // Teal
    Color(0xFF7C3AED), // Purple
    Color(0xFFD97706), // Amber
    Color(0xFFDC2626), // Red
  ];

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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'M';
  }

  void _showDeleteConfirmation(
      BuildContext context, Department dept, String orgId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Department',
            style: TextStyle(color: AppTheme.error)),
        content: Text(
          'Are you sure you want to delete "${dept.name}"?\n\nThis permanently deletes the department.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
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
                  context.go('/orgs/departments');
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
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAssignSelected(String orgId, Department dept) async {
    if (_pendingSelectedUids.isEmpty || _isAssigning) return;

    setState(() => _isAssigning = true);
    int successCount = 0;

    try {
      final repo = ref.read(departmentRepositoryProvider);
      final targets = _pendingSelectedUids.toList();

      for (final uid in targets) {
        await repo.assignMemberToDepartment(
          organizationId: orgId,
          targetUid: uid,
          departmentId: dept.id,
        );
        successCount++;
      }

      ref.invalidate(organizationMembersDirectoryProvider(orgId));

      if (mounted) {
        setState(() {
          _pendingSelectedUids.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Successfully assigned $successCount member(s) to ${dept.name}.'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to assign members: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isAssigning = false);
    }
  }

  void _showRemoveMemberConfirmation(
      BuildContext context, String orgId, String targetUid, String memberName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from department',
            style: TextStyle(color: AppTheme.error)),
        content: Text('Remove "$memberName" from this department?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              _handleRemoveMember(orgId, targetUid, memberName);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRemoveMember(
      String orgId, String targetUid, String memberName) async {
    try {
      final repo = ref.read(departmentRepositoryProvider);
      await repo.removeMemberFromDepartment(
        organizationId: orgId,
        targetUid: targetUid,
      );

      ref.invalidate(organizationMembersDirectoryProvider(orgId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed $memberName from department.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to remove member: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeContextState = ref.watch(activeOrganizationContextProvider);
    final orgContext = activeContextState.valueOrNull?.context;

    if (orgContext == null) {
      return const Scaffold(
        body: ErrorView(
          type: ErrorViewType.generic,
          title: 'No Active Organization',
          message:
              'Please select an organization context to view department members.',
        ),
      );
    }

    final orgId = orgContext.organization.id;
    final isManager = orgContext.member.isAdmin;
    final isDesktop = ResponsiveLayout.isWide(context);

    final departmentsAsync = ref.watch(activeOrganizationDepartmentsProvider);
    final department = departmentsAsync.valueOrNull
        ?.where((d) => d.id == widget.departmentId)
        .firstOrNull;

    if (department == null) {
      return const Scaffold(
        body: LoadingView(message: 'Loading department details...'),
      );
    }

    final membersAsync = ref.watch(organizationMembersDirectoryProvider(orgId));
    final allDepartments = departmentsAsync.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: membersAsync.when(
        loading: () =>
            const LoadingView(message: 'Loading department roster...'),
        error: (err, stack) => ErrorView(
          type: ErrorViewType.generic,
          message: 'Failed to load roster: $err',
          onRetry: () =>
              ref.invalidate(organizationMembersDirectoryProvider(orgId)),
        ),
        data: (allMembers) {
          // Identify members assigned to THIS department
          final assignedMembers = allMembers.where((m) {
            final deptIds =
                List<String>.from(m['departmentIds'] as List? ?? []);
            final singleDept = m['departmentId'] as String?;
            return deptIds.contains(widget.departmentId) ||
                singleDept == widget.departmentId;
          }).toList();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : 16,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Back Navigation Link
                    InkWell(
                      onTap: () => context.go('/orgs/departments'),
                      borderRadius: BorderRadius.circular(6),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back_rounded,
                                size: 16, color: AppTheme.primaryBlue),
                            SizedBox(width: 6),
                            Text(
                              'Departments',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Header Title & Actions Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      department.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: KivoraColors.textPrimaryOf(context),
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: KivoraColors.surfaceOf(context),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: KivoraColors.borderOf(context)),
                                    ),
                                    child: Text(
                                      '${assignedMembers.length} assigned members',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: KivoraColors.textSecondaryOf(context)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Members in this department can be chosen as eligible voters for events.',
                                style: TextStyle(
                                    color: KivoraColors.textSecondaryOf(context),
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (isManager) ...[
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        CreateEditDepartmentDialog(
                                      organizationId: orgId,
                                      departmentToEdit: department,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit_outlined, size: 16),
                                label: const Text('Rename'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                onPressed: () => _showDeleteConfirmation(
                                    context, department, orgId),
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 16, color: AppTheme.error),
                                label: const Text('Delete',
                                    style: TextStyle(color: AppTheme.error)),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: KivoraColors.borderOf(context)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 28),

                    // 3. Two-Column Assignment Grid
                    isDesktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // LEFT COLUMN: Assigned Members List Card
                              Expanded(
                                flex: 5,
                                child: _buildAssignedMembersCard(
                                  context,
                                  department,
                                  assignedMembers,
                                  isManager,
                                  orgId,
                                ),
                              ),
                              const SizedBox(width: 24),

                              // RIGHT COLUMN: Add Members List & Selection Card
                              Expanded(
                                flex: 6,
                                child: _buildAddMembersCard(
                                  context,
                                  department,
                                  allMembers,
                                  allDepartments,
                                  isManager,
                                  orgId,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildAssignedMembersCard(
                                context,
                                department,
                                assignedMembers,
                                isManager,
                                orgId,
                              ),
                              const SizedBox(height: 24),
                              _buildAddMembersCard(
                                context,
                                department,
                                allMembers,
                                allDepartments,
                                isManager,
                                orgId,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // LEFT CARD: MEMBERS IN {DEPT_NAME}
  // ===========================================================================
  Widget _buildAssignedMembersCard(
    BuildContext context,
    Department dept,
    List<Map<String, dynamic>> assignedMembers,
    bool isManager,
    String orgId,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KivoraColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members in ${dept.name}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context)),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${assignedMembers.length}',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: KivoraColors.borderOf(context)),

          // Body: List or Empty View
          if (assignedMembers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.people_outline_rounded,
                        size: 28, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No members assigned yet',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: KivoraColors.textPrimaryOf(context)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose people from the list to add them to this department. You can change it at any time.',
                    style: TextStyle(
                        fontSize: 13,
                        color: KivoraColors.textSecondaryOf(context),
                        height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Assigned members will appear here.',
                    style:
                        TextStyle(fontSize: 11, color: KivoraColors.textSecondaryOf(context)),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: assignedMembers.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: KivoraColors.borderOf(context)),
              itemBuilder: (context, idx) {
                final member = assignedMembers[idx];
                final name = member['displayName'] as String? ?? 'Member';
                final role = member['role'] as String? ?? 'member';
                final userId = member['userId'] as String? ?? '';
                final initials = _getInitials(name);
                final color = _avatarColors[idx % _avatarColors.length];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: color,
                        child: Text(initials,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: KivoraColors.textPrimaryOf(context))),
                          ],
                        ),
                      ),
                      StatusBadge.role(role),
                      if (isManager) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.close_rounded,
                              size: 18, color: KivoraColors.textSecondaryOf(context)),
                          tooltip: 'Remove from department',
                          onPressed: () => _showRemoveMemberConfirmation(
                              context, orgId, userId, name),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

          Divider(height: 1, color: KivoraColors.borderOf(context)),

          // Footnote Notice
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    size: 15, color: KivoraColors.textSecondaryOf(context)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pending selections are not members yet. Confirm with "Assign ${_pendingSelectedUids.length} members" to add them to ${dept.name}.',
                    style: TextStyle(
                        fontSize: 11,
                        color: KivoraColors.textSecondaryOf(context),
                        height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // RIGHT CARD: ADD MEMBERS
  // ===========================================================================
  Widget _buildAddMembersCard(
    BuildContext context,
    Department dept,
    List<Map<String, dynamic>> allMembers,
    List<Department> allDepartments,
    bool isManager,
    String orgId,
  ) {
    // 1. Filter members list by search query & filter tabs
    final filteredMembers = allMembers.where((m) {
      final name = (m['displayName'] as String? ?? '').toLowerCase();
      final email = (m['email'] as String? ?? '').toLowerCase();

      // Search query filter
      if (_searchQuery.isNotEmpty) {
        if (!name.contains(_searchQuery) && !email.contains(_searchQuery)) {
          return false;
        }
      }

      // Filter tabs filter ('all', 'unassigned', 'assigned')
      final deptIds = List<String>.from(m['departmentIds'] as List? ?? []);
      final singleDept = m['departmentId'] as String?;
      final inThisDept = deptIds.contains(dept.id) || singleDept == dept.id;
      final hasNoDept =
          (singleDept == null || singleDept.isEmpty) && deptIds.isEmpty;

      if (_selectedMemberFilter == 'unassigned') {
        if (!hasNoDept) return false;
      } else if (_selectedMemberFilter == 'assigned') {
        if (!inThisDept) return false;
      }

      return true;
    }).toList();

    final deptMap = {for (var d in allDepartments) d.id: d.name};

    return Container(
      decoration: BoxDecoration(
        color: KivoraColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KivoraColors.borderOf(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add members',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KivoraColors.textPrimaryOf(context)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Select people to assign to ${dept.name}.',
                  style: TextStyle(
                      fontSize: 12, color: KivoraColors.textSecondaryOf(context)),
                ),
                const SizedBox(height: 16),

                // Search Bar
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search by name',
                    prefixIcon: Icon(Icons.search_rounded,
                        color: KivoraColors.textSecondaryOf(context), size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: KivoraColors.borderOf(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: KivoraColors.borderOf(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppTheme.primaryBlue, width: 1.5),
                    ),
                    fillColor: KivoraColors.surfaceOf(context),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Tabs Row (horizontally scrollable - a long department
                // name can otherwise overflow narrow screens)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Icon(Icons.filter_list_rounded,
                          size: 18, color: KivoraColors.textSecondaryOf(context)),
                      const SizedBox(width: 8),
                      _buildFilterPill('all', 'All members'),
                      const SizedBox(width: 6),
                      _buildFilterPill('unassigned', 'No department'),
                      const SizedBox(width: 6),
                      _buildFilterPill('assigned', dept.name),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: KivoraColors.borderOf(context)),

          // Selectable Members List
          if (filteredMembers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text('No members match your search.',
                    style:
                        TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 13)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: filteredMembers.length,
              itemBuilder: (context, idx) {
                final member = filteredMembers[idx];
                final userId = member['userId'] as String? ?? '';
                final name = member['displayName'] as String? ?? 'Member';
                final role = member['role'] as String? ?? 'member';
                final initials = _getInitials(name);
                final color = _avatarColors[idx % _avatarColors.length];

                final singleDept = member['departmentId'] as String?;
                final deptIds =
                    List<String>.from(member['departmentIds'] as List? ?? []);
                final inThisDept =
                    deptIds.contains(dept.id) || singleDept == dept.id;

                final currentDeptName =
                    singleDept != null && deptMap.containsKey(singleDept)
                        ? 'In ${deptMap[singleDept]}'
                        : (deptIds.isNotEmpty
                            ? 'In ${deptMap[deptIds.first] ?? 'department'}'
                            : 'No department');

                final isChecked =
                    inThisDept || _pendingSelectedUids.contains(userId);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: InkWell(
                    onTap: isManager && !inThisDept
                        ? () {
                            setState(() {
                              if (_pendingSelectedUids.contains(userId)) {
                                _pendingSelectedUids.remove(userId);
                              } else {
                                _pendingSelectedUids.add(userId);
                              }
                            });
                          }
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isChecked
                            ? AppTheme.primaryBlue.withValues(alpha: 0.12).withValues(alpha: 0.6)
                            : KivoraColors.surfaceOf(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isChecked
                              ? AppTheme.primaryBlue
                              : KivoraColors.borderOf(context),
                          width: isChecked ? 1.4 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Custom Checkbox
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? AppTheme.primaryBlue
                                  : KivoraColors.surfaceOf(context),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isChecked
                                    ? AppTheme.primaryBlue
                                    : KivoraColors.borderOf(context),
                                width: 1.5,
                              ),
                            ),
                            child: isChecked
                                ? const Icon(Icons.check_rounded,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),

                          // Avatar
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: color,
                            child: Text(initials,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),

                          // Name & Department subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isChecked
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isChecked
                                        ? AppTheme.primaryBlue
                                        : KivoraColors.textPrimaryOf(context),
                                  ),
                                ),
                                Text(
                                  inThisDept
                                      ? 'Assigned to ${dept.name}'
                                      : currentDeptName,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: KivoraColors.textSecondaryOf(context)),
                                ),
                              ],
                            ),
                          ),

                          // Role Badge
                          StatusBadge.role(role),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          Divider(height: 1, color: KivoraColors.borderOf(context)),

          // Bottom Action Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${_pendingSelectedUids.length} selected',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: KivoraColors.textPrimaryOf(context)),
                        ),
                        if (_pendingSelectedUids.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _pendingSelectedUids.clear();
                              });
                            },
                            child: const Text('Clear',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pending assignment to ${dept.name}',
                      style: TextStyle(
                          fontSize: 11, color: KivoraColors.textSecondaryOf(context)),
                    ),
                  ],
                ),
                if (isManager)
                  FilledButton.icon(
                    onPressed: _pendingSelectedUids.isEmpty || _isAssigning
                        ? null
                        : () => _handleAssignSelected(orgId, dept),
                    icon: _isAssigning
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.person_add_alt_1_rounded, size: 16),
                    label: Text(_isAssigning
                        ? 'Assigning...'
                        : 'Assign ${_pendingSelectedUids.length} members'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String key, String label) {
    final isSelected = _selectedMemberFilter == key;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMemberFilter = key;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : KivoraColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: KivoraColors.borderOf(context)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : KivoraColors.textSecondaryOf(context),
          ),
        ),
      ),
    );
  }
}
