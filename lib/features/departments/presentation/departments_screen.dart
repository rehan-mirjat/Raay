import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/layout/responsive.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../organizations/presentation/membership_directory_screen.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../../voting_events/data/voting_event_repository.dart';
import '../../voting_events/domain/voting_event.dart';
import '../../voting_events/presentation/voter_portal_screen.dart' show AdaptiveCardGrid;
import '../data/department_repository.dart';
import '../domain/department.dart';
import '../domain/department_list.dart';
import 'create_edit_department_dialog.dart';
import 'providers/department_providers.dart';

class DepartmentsScreen extends ConsumerStatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  ConsumerState<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends ConsumerState<DepartmentsScreen> {
  String _query = '';
  DepartmentSort _sort = DepartmentSort.nameAsc;

  Future<void> _confirmDelete(Department dept) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deptDeleteTitle),
        content: Text(l10n.deptDeleteBody(dept.name)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.deptKeep),
          ),
          TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: KivoraColors.of(ctx).errorText),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deptDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(departmentRepositoryProvider).deleteDepartment(dept.id);
      messenger.showSnackBar(SnackBar(content: Text(l10n.deptDeleted)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.deptDeleteFailed)));
    }
  }

  void _openEditor(String orgId, [Department? dept]) {
    showDialog<void>(
      context: context,
      builder: (_) => CreateEditDepartmentDialog(organizationId: orgId, departmentToEdit: dept),
    );
  }

  String _sortLabel(AppLocalizations l10n, DepartmentSort s) => switch (s) {
        DepartmentSort.nameAsc => l10n.deptSortName,
        DepartmentSort.nameDesc => l10n.deptSortNameDesc,
        DepartmentSort.membersDesc => l10n.deptSortMembers,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kc = KivoraColors.of(context);
    final orgContext = ref.watch(activeOrganizationContextProvider).valueOrNull?.context;

    if (orgContext == null) {
      return Scaffold(
        body: EmptyView(
          icon: Icons.business_outlined,
          title: l10n.deptNoOrgTitle,
          message: l10n.deptNoOrgBody,
          actionLabel: l10n.deptNoOrgAction,
          onAction: () => context.go('/home'),
        ),
      );
    }

    final orgId = orgContext.organization.id;
    final isManager = orgContext.member.isAdmin;
    final isDesktop = ResponsiveLayout.isWide(context);
    final departmentsAsync = ref.watch(activeOrganizationDepartmentsProvider);
    // Only managers can list members; for everyone else counts are unknown.
    final membersAsync =
        isManager ? ref.watch(organizationMembersDirectoryProvider(orgId)) : null;
    final events = ref
            .watch(organizationVotingEventsProvider((orgId: orgId, includeDrafts: false)))
            .valueOrNull ??
        const <VotingEvent>[];
    final members = membersAsync?.valueOrNull;
    final counts = memberCountsByDepartment(members);

    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      body: departmentsAsync.when(
        loading: () => const LoadingView(),
        error: (_, __) => ErrorView(
          type: ErrorViewType.generic,
          message: l10n.deptLoadError,
          onRetry: () => ref.invalidate(activeOrganizationDepartmentsProvider),
        ),
        data: (all) {
          final visible = isManager
              ? all
              : all.where((d) => d.id == orgContext.member.departmentId).toList();
          final shown =
              filterAndSortDepartments(visible, query: _query, sort: _sort, counts: counts);

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32 : 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: ResponsiveLayout.maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                header: true,
                                child: Text(l10n.deptTitle,
                                    style: TextStyle(
                                        fontSize: isDesktop ? 28 : 24,
                                        fontWeight: FontWeight.bold,
                                        color: kc.textPrimary)),
                              ),
                              const SizedBox(height: 4),
                              Text(l10n.deptSubtitle,
                                  style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                            ],
                          ),
                        ),
                        if (isManager)
                          FilledButton.icon(
                            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                            onPressed: () => _openEditor(orgId),
                            icon: const Icon(Icons.add_rounded, size: 20),
                            label: Text(l10n.deptNew),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (visible.isNotEmpty) ...[
                      Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 220, maxWidth: 420),
                          child: TextField(
                            onChanged: (v) => setState(() => _query = v),
                            decoration: InputDecoration(
                              hintText: l10n.deptSearchHint,
                              prefixIcon: const Icon(Icons.search_rounded, size: 20),
                            ),
                          ),
                        ),
                        PopupMenuButton<DepartmentSort>(
                          tooltip: l10n.deptSortLabel,
                          onSelected: (s) => setState(() => _sort = s),
                          itemBuilder: (_) => [
                            for (final s in DepartmentSort.values)
                              CheckedPopupMenuItem(
                                value: s,
                                checked: s == _sort,
                                child: Text(_sortLabel(l10n, s)),
                              ),
                          ],
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 48),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.swap_vert_rounded, size: 18, color: kc.textSecondary),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text('${l10n.deptSortLabel}: ${_sortLabel(l10n, _sort)}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14, color: kc.textPrimary)),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Text(l10n.deptCount(visible.length),
                          style: TextStyle(fontSize: 14, color: kc.textSecondary)),
                      const SizedBox(height: 16),
                    ],
                    if (visible.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: EmptyView(
                          icon: isManager ? Icons.domain_disabled_outlined : Icons.lock_outline_rounded,
                          title: isManager ? l10n.deptEmptyManagerTitle : l10n.deptEmptyMemberTitle,
                          message: isManager ? l10n.deptEmptyManagerBody : l10n.deptEmptyMemberBody,
                          actionLabel: isManager ? l10n.deptNew : null,
                          onAction: isManager ? () => _openEditor(orgId) : null,
                        ),
                      )
                    else if (shown.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                            child: Text(l10n.deptNoMatch,
                                style: TextStyle(color: kc.textSecondary, fontSize: 14))),
                      )
                    else
                      AdaptiveCardGrid(
                        minColumnWidth: 340,
                        children: [
                          for (final dept in shown)
                            DepartmentCard(
                              key: ValueKey(dept.id),
                              dept: dept,
                              memberCount: counts == null ? null : (counts[dept.id] ?? 0),
                              eventsCount:
                                  events.where((e) => e.eligibilityDepartmentIds.contains(dept.id)).length,
                              isManager: isManager,
                              onManageMembers: () => context.go('/orgs/departments/${dept.id}'),
                              onEdit: () => _openEditor(orgId, dept),
                              onDelete: () => _confirmDelete(dept),
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
}

enum _DeptAction { edit, manage, delete }

class DepartmentCard extends StatelessWidget {
  const DepartmentCard({
    super.key,
    required this.dept,
    required this.memberCount,
    required this.eventsCount,
    required this.isManager,
    required this.onManageMembers,
    required this.onEdit,
    required this.onDelete,
  });

  final Department dept;

  /// null = unknown (not visible to this role or failed to load).
  final int? memberCount;
  final int eventsCount;
  final bool isManager;
  final VoidCallback onManageMembers;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final l10n = AppLocalizations.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kc.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: kc.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                ),
                child: Icon(Icons.apartment_rounded, color: kc.accentText, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dept.name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kc.textPrimary)),
                    const SizedBox(height: 2),
                    Text(
                      memberCount == null ? l10n.deptMembersUnknown : l10n.deptMemberCount(memberCount!),
                      style: TextStyle(fontSize: 14, color: kc.textSecondary),
                    ),
                  ],
                ),
              ),
              if (isManager)
                PopupMenuButton<_DeptAction>(
                  tooltip: l10n.deptActions,
                  icon: Icon(Icons.more_horiz_rounded, color: kc.textSecondary),
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  onSelected: (a) => switch (a) {
                    _DeptAction.edit => onEdit(),
                    _DeptAction.manage => onManageMembers(),
                    _DeptAction.delete => onDelete(),
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _DeptAction.edit,
                      child: ListTile(
                          dense: false,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.edit_outlined),
                          title: Text(l10n.deptEdit)),
                    ),
                    PopupMenuItem(
                      value: _DeptAction.manage,
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.people_outline_rounded),
                          title: Text(l10n.deptManageMembers)),
                    ),
                    PopupMenuItem(
                      value: _DeptAction.delete,
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.delete_outline_rounded, color: kc.errorText),
                          title: Text(l10n.deptDelete, style: TextStyle(color: kc.errorText))),
                    ),
                  ],
                ),
            ],
          ),
          if (dept.description.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(dept.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, height: 1.4, color: kc.textSecondary)),
          ],
          const SizedBox(height: 12),
          Text(
            eventsCount > 0 ? l10n.deptUsedIn(eventsCount) : l10n.deptEventsNone,
            style: TextStyle(fontSize: 14, color: kc.textSecondary),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: onManageMembers,
              icon: const Icon(Icons.people_outline_rounded, size: 18),
              label: Text(l10n.deptManageMembers),
            ),
          ),
        ],
      ),
    );
  }
}
