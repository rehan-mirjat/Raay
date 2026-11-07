import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../core/layout/responsive.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../services/firebase_service.dart';
import '../domain/member_filter.dart';
import '../domain/organization_enums.dart';
import '../data/organization_repository.dart';
import 'invite_member_dialog.dart';
import 'bulk_invite_dialog.dart';
import 'add_existing_member_dialog.dart';
import 'member_profile_dialog.dart';
import 'providers/organization_providers.dart';
import 'pending_invitations_widget.dart';

final organizationMembersDirectoryProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, orgId) async {
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
  String _query = '';
  MemberFilter _filter = MemberFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _filterLabel(AppLocalizations l10n, MemberFilter f) => switch (f) {
        MemberFilter.all => l10n.peopleFilterAll,
        MemberFilter.managers => l10n.peopleFilterManagers,
        MemberFilter.members => l10n.peopleFilterMembers,
        MemberFilter.notActive => l10n.peopleFilterNotActive,
      };

  Future<void> _openInvite(
      String orgId, String orgName, OrganizationRole role) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => InviteMemberDialog(
        organizationId: orgId,
        organizationName: orgName,
        isOwner: role == OrganizationRole.owner,
      ),
    );
    // Refresh regardless of the result: the dialog can also be dismissed by
    // tapping outside it, which returns null after a successful invite.
    if (mounted) ref.invalidate(pendingInvitationsProvider(orgId));
  }

  Future<void> _openAddExisting(String orgId) async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => AddExistingMemberDialog(organizationId: orgId),
    );
    if (added == true && mounted) {
      ref.invalidate(organizationMembersDirectoryProvider(orgId));
    }
  }

  Future<void> _openBulkInvite(String orgId) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => BulkInviteDialog(organizationId: orgId),
    );
    if (created == true && mounted) {
      ref.invalidate(pendingInvitationsProvider(orgId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bg = RaayColors.backgroundOf(context);
    final state = ref.watch(activeOrganizationContextProvider);

    return state.when(
      skipLoadingOnReload: true,
      loading: () => Material(color: bg, child: const LoadingView()),
      error: (_, __) => Material(
        color: bg,
        child: ErrorView(
          type: ErrorViewType.generic,
          message: l10n.peopleLoadError,
          onRetry: () => ref.invalidate(activeOrganizationContextProvider),
        ),
      ),
      data: (orgState) {
        final orgContext = orgState.context;
        if (orgContext == null) {
          return Material(
            color: bg,
            child: EmptyView(
                icon: Icons.corporate_fare_outlined,
                title: l10n.peopleNoOrgTitle,
                message: l10n.peopleNoOrgBody),
          );
        }
        final orgId = orgContext.organization.id;
        final callerRole = orgContext.member.role;
        if (!callerRole.isAdmin) {
          return Material(
            color: bg,
            child: EmptyView(
                icon: Icons.lock_outline_rounded,
                title: l10n.peopleRestricted,
                message: l10n.peopleRestrictedBody),
          );
        }

        final membersAsync =
            ref.watch(organizationMembersDirectoryProvider(orgId));
        final isDesktop = ResponsiveLayout.isWide(context);
        final hPad = isDesktop ? 32.0 : 16.0;
        final kc = RaayColors.of(context);

        // "/" focuses search unless it already has focus (a shortcut binding
        // would swallow the keystroke while typing).
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
          child: Material(
            color: bg,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: ResponsiveLayout.maxContentWidth),
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(organizationMembersDirectoryProvider(orgId));
                    ref.invalidate(pendingInvitationsProvider(orgId));
                    try {
                      await ref.read(
                          organizationMembersDirectoryProvider(orgId).future);
                    } catch (_) {}
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                            hPad, isDesktop ? 28 : 16, hPad, 12),
                        sliver: SliverToBoxAdapter(
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
                                    constraints:
                                        const BoxConstraints(maxWidth: 560),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Semantics(
                                          header: true,
                                          child: Text(l10n.peopleTitle,
                                              style: TextStyle(
                                                  fontSize: isDesktop ? 28 : 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: kc.textPrimary)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(l10n.peopleSubtitle,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: kc.textSecondary)),
                                      ],
                                    ),
                                  ),
                                  Wrap(spacing: 8, runSpacing: 8, children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(48, 48)),
                                      onPressed: () => _openAddExisting(orgId),
                                      icon: const Icon(
                                          Icons.person_add_alt_outlined,
                                          size: 18),
                                      label: Text(l10n.peopleAddExisting),
                                    ),
                                    FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                          minimumSize: const Size(48, 48)),
                                      onPressed: () => _openInvite(
                                          orgId,
                                          orgContext.organization.name,
                                          callerRole),
                                      icon: const Icon(
                                          Icons.mail_outline_rounded,
                                          size: 18),
                                      label: Text(l10n.peopleInvite),
                                    ),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(48, 48)),
                                      onPressed: () => _openBulkInvite(orgId),
                                      icon: const Icon(
                                          Icons.upload_file_rounded,
                                          size: 18),
                                      label: Text(AppLocalizations.of(context).directoryImportCsv),
                                    ),
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  hintText: l10n.peopleSearchHint,
                                  prefixIcon: const Icon(Icons.search_rounded,
                                      size: 20),
                                  suffixIcon: _query.isEmpty
                                      ? null
                                      : IconButton(
                                          tooltip: l10n.peopleSearchClear,
                                          constraints: const BoxConstraints(
                                              minWidth: 48, minHeight: 48),
                                          icon: const Icon(Icons.close_rounded,
                                              size: 18),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() => _query = '');
                                          },
                                        ),
                                ),
                                onChanged: (v) => setState(() => _query = v),
                              ),
                              const SizedBox(height: 12),
                              Wrap(spacing: 8, runSpacing: 8, children: [
                                for (final f in MemberFilter.values)
                                  ChoiceChip(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.padded,
                                    showCheckmark: true,
                                    label: Text(_filterLabel(l10n, f)),
                                    selected: _filter == f,
                                    onSelected: (_) =>
                                        setState(() => _filter = f),
                                  ),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: hPad),
                        sliver: SliverToBoxAdapter(
                          child: PendingInvitationsWidget(
                            organizationId: orgId,
                            isOwner: callerRole == OrganizationRole.owner,
                          ),
                        ),
                      ),
                      ..._memberSlivers(
                          context, l10n, membersAsync, orgId, callerRole, hPad),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _memberSlivers(
    BuildContext context,
    AppLocalizations l10n,
    AsyncValue<List<Map<String, dynamic>>> membersAsync,
    String orgId,
    OrganizationRole callerRole,
    double hPad,
  ) {
    return membersAsync.when(
      loading: () => [
        const SliverFillRemaining(hasScrollBody: false, child: LoadingView())
      ],
      error: (_, __) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorView(
            type: ErrorViewType.generic,
            message: l10n.peopleLoadError,
            onRetry: () =>
                ref.invalidate(organizationMembersDirectoryProvider(orgId)),
          ),
        ),
      ],
      data: (members) {
        final filtered = filterMembers(members, query: _query, filter: _filter);
        if (filtered.isEmpty) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
                child: EmptyView(
                  icon: members.isEmpty
                      ? Icons.people_outline_rounded
                      : Icons.search_off_rounded,
                  title: members.isEmpty
                      ? l10n.peopleNoMembersTitle
                      : l10n.peopleNoMatchTitle,
                  message: members.isEmpty
                      ? l10n.peopleNoMembersBody
                      : l10n.peopleNoMatchBody,
                ),
              ),
            ),
          ];
        }
        return [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 8),
            sliver: SliverToBoxAdapter(
              child: Text(l10n.peopleCount(filtered.length, members.length),
                  style: TextStyle(
                      fontSize: 14,
                      color: RaayColors.textSecondaryOf(context))),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 24),
            sliver: SliverList.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final member = filtered[index];
                return MemberCard(
                  member: member,
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
                );
              },
            ),
          ),
        ];
      },
    );
  }
}

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.member, required this.onTap});

  final Map<String, dynamic> member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    final l10n = AppLocalizations.of(context);
    final name = (member['displayName'] as String?)?.trim();
    final shownName =
        (name == null || name.isEmpty) ? l10n.peopleUnknownUser : name;
    final email = member['email'] as String? ?? '';
    final role = memberRole(member);
    final status = ((member['status'] as String?) ?? 'active').toLowerCase();
    final active = memberIsActive(member);
    final deptName = member['departmentName'] as String?;
    final rawPhotoUrl =
        (member['photoUrl'] as String?) ?? (member['photoURL'] as String?);
    final photoUrl = FirebaseService.sanitizeStorageUrl(rawPhotoUrl);
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      color: kc.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        side: BorderSide(color: kc.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      primary.withValues(alpha: active ? 0.12 : 0.06),
                  backgroundImage:
                      photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child: photoUrl.isEmpty
                      ? Text(shownName[0].toUpperCase(),
                          style: TextStyle(
                              color: active ? kc.accentText : kc.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18))
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shownName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color:
                                  active ? kc.textPrimary : kc.textSecondary)),
                      if (email.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(email,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, color: kc.textSecondary)),
                      ],
                      if (deptName != null && deptName.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(deptName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, color: kc.textSecondary)),
                      ],
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        StatusBadge.role(role),
                        if (!active)
                          StatusBadge(
                            label: status.toUpperCase(),
                            backgroundColor: kc.errorText
                                .withValues(alpha: kc.isDark ? 0.16 : 0.10),
                            textColor: kc.errorText,
                            icon: Icons.block_rounded,
                          ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
                      color: kc.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
