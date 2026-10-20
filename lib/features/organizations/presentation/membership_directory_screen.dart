import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_button.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/kivora_animations.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../services/firebase_service.dart';
import '../domain/organization_enums.dart';
import '../data/organization_repository.dart';
import 'invite_member_dialog.dart';
import 'add_existing_member_dialog.dart';
import 'member_profile_dialog.dart';
import 'providers/organization_providers.dart';
import 'pending_invitations_widget.dart';

final organizationMembersDirectoryProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, orgId) async {
  final repo = ref.watch(organizationRepositoryProvider);
  final result = await repo.getOrganizationMembers(organizationId: orgId);
  return result.members;
});

class MembershipDirectoryScreen extends ConsumerStatefulWidget {
  const MembershipDirectoryScreen({super.key});

  @override
  ConsumerState<MembershipDirectoryScreen> createState() =>
      _MembershipDirectoryScreenState();
}

class _MembershipDirectoryScreenState
    extends ConsumerState<MembershipDirectoryScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _selectedRoleFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget _directoryHeading(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Member Directory',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: KivoraColors.textPrimaryOf(context),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage organization members, roles, and status.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: KivoraColors.textSecondaryOf(context),
                ),
          ),
        ],
      );

  Future<void> _openInvite(
      BuildContext context, String orgId, String orgName, OrganizationRole role) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => InviteMemberDialog(
        organizationId: orgId,
        organizationName: orgName,
        isOwner: role == OrganizationRole.owner,
      ),
    );
    // Refresh regardless of the result: after a successful invite the dialog can
    // also be closed by tapping outside it, which returns null.
    if (mounted) ref.invalidate(pendingInvitationsProvider(orgId));
  }

  Future<void> _openAddExisting(BuildContext context, String orgId) async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => AddExistingMemberDialog(organizationId: orgId),
    );
    if (added == true && mounted) {
      ref.invalidate(organizationMembersDirectoryProvider(orgId));
    }
  }

  Widget _memberActions(
          BuildContext context, String orgId, String orgName, OrganizationRole role) =>
      Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 10,
        children: [
          KivoraButton(
            type: KivoraButtonType.secondary,
            icon: KivoraIcons.userPlus,
            label: 'Add Existing',
            isExpanded: false,
            onPressed: () => _openAddExisting(context, orgId),
          ),
          KivoraButton(
            icon: KivoraIcons.mail,
            label: 'Invite Member',
            isExpanded: false,
            onPressed: () => _openInvite(context, orgId, orgName, role),
          ),
        ],
      );

  Widget _memberSearchField() => SizedBox(
        height: 48,
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.search,
          style: TextStyle(fontSize: 14, color: KivoraColors.textPrimaryOf(context)),
          decoration: InputDecoration(
            hintText: 'Search members by name or email',
            hintStyle: TextStyle(fontSize: 14, color: KivoraColors.textSecondaryOf(context)),
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 1.5),
            ),
            fillColor: KivoraColors.surfaceOf(context),
            filled: true,
            suffixIcon: _searchQuery.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
          ),
          onChanged: (value) =>
              setState(() => _searchQuery = value.trim().toLowerCase()),
        ),
      );

  Widget _roleFilter(BuildContext context) => PopupMenuButton<String>(
        tooltip: 'Filter by role',
        offset: const Offset(0, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: KivoraColors.borderOf(context)),
        ),
        color: KivoraColors.surfaceOf(context),
        onSelected: (value) {
          setState(() => _selectedRoleFilter = value);
        },
        itemBuilder: (ctx) => [
          _roleMenuItem('all', 'All roles'),
          _roleMenuItem('admin', 'Admins'),
          _roleMenuItem('member', 'Members'),
        ],
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _selectedRoleFilter != 'all' ? AppTheme.primaryBlue.withValues(alpha: 0.12) : KivoraColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _selectedRoleFilter != 'all' ? AppTheme.primaryBlue : KivoraColors.borderOf(context),
              width: _selectedRoleFilter != 'all' ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tune_rounded, size: 18, color: _selectedRoleFilter != 'all' ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context)),
              const SizedBox(width: 8),
              Text(
                _selectedRoleFilter == 'all'
                    ? 'All roles'
                    : (_selectedRoleFilter == 'admin' ? 'Admins' : 'Members'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: _selectedRoleFilter != 'all' ? FontWeight.bold : FontWeight.w500,
                  color: _selectedRoleFilter != 'all' ? AppTheme.primaryBlue : KivoraColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: _selectedRoleFilter != 'all' ? AppTheme.primaryBlue : KivoraColors.textSecondaryOf(context)),
            ],
          ),
        ),
      );

  PopupMenuItem<String> _roleMenuItem(String value, String label) {
    final isSelected = _selectedRoleFilter == value;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          if (isSelected)
            const Icon(Icons.check_rounded, size: 16, color: AppTheme.primaryBlue)
          else
            const SizedBox(width: 16),
          const SizedBox(width: 8),
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

  List<Map<String, dynamic>> _filter(List<Map<String, dynamic>> members) {
    return members.where((m) {
      final name = (m['displayName'] as String? ?? '').toLowerCase();
      final email = (m['email'] as String? ?? '').toLowerCase();
      final rawRole = (m['role'] as String? ?? '').toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          name.contains(_searchQuery) ||
          email.contains(_searchQuery);
      final matchesRole = _selectedRoleFilter == 'all' ||
          rawRole == _selectedRoleFilter ||
          rawRole.contains(_selectedRoleFilter);
      return matchesQuery && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activeContextState = ref.watch(activeOrganizationContextProvider);
    final background = Theme.of(context).scaffoldBackgroundColor;

    return activeContextState.when(
      // Keep showing the directory while the context silently reloads.
      skipLoadingOnReload: true,
      loading: () => Material(
        color: background,
        child: const LoadingView(message: 'Restoring active organization context...'),
      ),
      error: (err, stack) => Material(
        color: background,
        child: ErrorView(type: ErrorViewType.generic, 
          message: 'Failed to load organization context: $err',
          onRetry: () => ref.invalidate(activeOrganizationContextProvider),
        ),
      ),
      data: (state) {
        final compact = ResponsiveLayout.isCompact(context);
        final orgContext = state.context;

        if (orgContext == null) {
          return Material(
            color: background,
            child: const EmptyView(
              icon: Icons.corporate_fare_outlined,
              title: 'No Active Organization Selected',
              message:
                  'Please select an organization context to view the member directory.',
            ),
          );
        }

        final orgId = orgContext.organization.id;
        final orgName = orgContext.organization.name;
        final callerRole = orgContext.member.role;
        final isManager = callerRole.isAdmin;

        if (!isManager) {
          return Material(
            color: background,
            child: const EmptyView(
              icon: Icons.lock_outline_rounded,
              title: 'Access Restricted',
              message: 'The member directory is restricted to organization administrators only.',
            ),
          );
        }

        final membersAsync = ref.watch(organizationMembersDirectoryProvider(orgId));
        final hPad = compact ? 16.0 : 24.0;

        // "/" focuses the search box, but only when it isn't already focused;
        // a CallbackShortcuts binding would have swallowed the "/" keystroke
        // while typing in the search field.
        return Focus(
          canRequestFocus: false,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.slash &&
                !_searchFocusNode.hasFocus) {
              _searchFocusNode.requestFocus();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: PageEntry(child: Material(
            color: background,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(hPad, compact ? 16 : 28, hPad, 12),
                      child: compact
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _directoryHeading(context),
                                const SizedBox(height: 14),
                                _memberActions(context, orgId, orgName, callerRole),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: _directoryHeading(context)),
                                _memberActions(context, orgId, orgName, callerRole),
                              ],
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 8),
                      child: compact
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _memberSearchField(),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: _roleFilter(context),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: _memberSearchField()),
                                const SizedBox(width: 12),
                                _roleFilter(context),
                              ],
                            ),
                    ),
                    Expanded(
                      child: membersAsync.when(
                        loading: () => const LoadingView(message: 'Loading member directory...'),
                        error: (err, stack) => ErrorView(type: ErrorViewType.generic, 
                          message: 'Error loading directory: $err',
                          onRetry: () => ref.invalidate(organizationMembersDirectoryProvider(orgId)),
                        ),
                        data: (members) {
                          final filtered = _filter(members);
                          return RefreshIndicator(
                            onRefresh: () async {
                              ref.invalidate(organizationMembersDirectoryProvider(orgId));
                              ref.invalidate(pendingInvitationsProvider(orgId));
                              try {
                                await ref.read(organizationMembersDirectoryProvider(orgId).future);
                              } catch (_) {}
                            },
                            // Slivers: only visible member cards are built, instead of
                            // a shrink-wrapped ListView inside a SingleChildScrollView.
                            child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 20),
                                  sliver: SliverToBoxAdapter(
                                    child: PendingInvitationsWidget(
                                      organizationId: orgId,
                                      isOwner: callerRole == OrganizationRole.owner,
                                    ),
                                  ),
                                ),
                                if (filtered.isEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
                                      child: EmptyView(
                                        icon: members.isEmpty ? Icons.people_outline_rounded : Icons.search_off_rounded,
                                        title: members.isEmpty ? 'No members yet' : 'No matches found',
                                        message: members.isEmpty
                                            ? 'Add existing members or invite people to your organization.'
                                            : 'No members match your search or role filter.',
                                      ),
                                    ),
                                  )
                                else
                                  SliverPadding(
                                    padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 24),
                                    sliver: SliverList.builder(
                                      itemCount: filtered.length,
                                      itemBuilder: (context, index) {
                                        final member = filtered[index];
                                        return StaggeredListItem(
                                          index: index,
                                          child: _MemberCard(
                                          member: member,
                                          compact: compact,
                                          onTap: () => showDialog<void>(
                                            context: context,
                                            builder: (_) => MemberProfileDialog(
                                              organizationId: orgId,
                                              callerRole: callerRole,
                                              memberData: member,
                                              onChanged: () => ref.invalidate(
                                                  organizationMembersDirectoryProvider(orgId)),
                                            ),
                                          ),
                                        ));
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )), // PageEntry
        );
      },
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.member,
    required this.compact,
    required this.onTap,
  });

  final Map<String, dynamic> member;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = member['displayName'] as String? ?? 'Unknown User';
    final email = member['email'] as String? ?? '';
    final role = (member['role'] as String? ?? 'member').toLowerCase();
    final status = (member['status'] as String? ?? 'active').toLowerCase();
    final deptName = member['departmentName'] as String?;
    final rawPhotoUrl = (member['photoUrl'] as String?) ?? (member['photoURL'] as String?);
    final photoUrl = FirebaseService.sanitizeStorageUrl(rawPhotoUrl);
    final isInactive = status == 'inactive';

    return HoverLiftCard(
      borderRadius: 16,
      onTap: onTap,
      child: Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: KivoraColors.borderOf(context)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        hoverColor: AppTheme.primaryBlue.withValues(alpha: 0.06),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(compact ? 12 : 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: compact ? 20 : 24,
                backgroundColor: isInactive
                    ? Colors.grey.shade300
                    : AppTheme.primaryBlue.withValues(alpha: 0.12),
                backgroundImage: photoUrl.isNotEmpty
                    ? NetworkImage(photoUrl)
                    : null,
                child: photoUrl.isEmpty
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: TextStyle(
                          color: isInactive ? Colors.grey.shade600 : AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: compact ? 12 : 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isInactive ? Colors.grey : KivoraColors.textPrimaryOf(context),
                        decoration: isInactive ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _iconLine(context, Icons.email_outlined, email),
                    if (deptName != null && deptName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _iconLine(context, Icons.domain_outlined, deptName),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge.role(role),
                  if (isInactive) ...[
                    const SizedBox(height: 6),
                    _pill('INACTIVE', AppTheme.error.withValues(alpha: 0.12),
                        AppTheme.error,
                        fontSize: 10),
                  ],
                ],
              ),
              SizedBox(width: compact ? 6 : 16),
              Icon(Icons.chevron_right, color: KivoraColors.borderOf(context)),
            ],
          ),
        ),
      ),
    )); // HoverLiftCard
  }

  Widget _iconLine(BuildContext context, IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 14, color: KivoraColors.textSecondaryOf(context)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 13),
            ),
          ),
        ],
      );

  Widget _pill(String text, Color background, Color foreground,
          {required double fontSize}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: foreground,
          ),
        ),
      );
}
