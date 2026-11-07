import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../navigation/exit_guard.dart';
import '../navigation/nav_destinations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/organizations/data/organization_repository.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../features/organizations/domain/organization.dart';
import '../../features/voting_events/data/voting_event_repository.dart';
import '../theme/app_theme.dart';
import '../theme/raay_colors.dart';
import '../../services/auth_service.dart';
import '../../features/organizations/domain/organization_enums.dart';

// ─── Result model ─────────────────────────────────────────────────────────────

enum _SearchCategory { org, event, member, route }

class _SearchResult {
  const _SearchResult({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.category,
    this.iconColor,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final _SearchCategory category;
  final Color? iconColor;
}

// ─── Static quick-nav items ───────────────────────────────────────────────────

List<_SearchResult> _staticRoutes(AppLocalizations l, NavModel model) => [
      _SearchResult(
          title: l.gsHome,
          subtitle: l.gsHomeSub,
          icon: Icons.home_outlined,
          route: '/home',
          category: _SearchCategory.route),
      _SearchResult(
          title: l.gsOrgs,
          subtitle: l.gsOrgsSub,
          icon: Icons.business_outlined,
          route: '/orgs',
          category: _SearchCategory.route),
      _SearchResult(
          title: l.gsEvents,
          subtitle: l.gsEventsSub,
          icon: Icons.how_to_vote_outlined,
          route: '/admin/events',
          category: _SearchCategory.route),
      _SearchResult(
          title: l.gsMembers,
          subtitle: l.gsMembersSub,
          icon: Icons.groups_outlined,
          route: '/orgs/members',
          category: _SearchCategory.route),
      _SearchResult(
          title: l.gsDepts,
          subtitle: l.gsDeptsSub,
          icon: Icons.apartment_outlined,
          route: '/orgs/departments',
          category: _SearchCategory.route),
      _SearchResult(
          title: l.gsAccount,
          subtitle: l.gsAccountSub,
          icon: Icons.settings_outlined,
          route: '/settings',
          category: _SearchCategory.route),
      _SearchResult(
          title: l.gsAudit,
          subtitle: l.gsAuditSub,
          icon: Icons.history_edu_outlined,
          route: '/orgs/audit',
          category: _SearchCategory.route),
      _SearchResult(
          title: l.gsInvites,
          subtitle: l.gsInvitesSub,
          icon: Icons.mail_outline_rounded,
          route: '/orgs/invitations',
          category: _SearchCategory.route),
    ]
        .where((result) =>
            model.all.any((destination) => destination.route == result.route))
        .toList();

/// The subtitle shown (and searched) for a result. Orgs and events store only
/// raw data; their wording is added here so it follows the app language.
String _subtitleFor(AppLocalizations l, _SearchResult r) =>
    switch (r.category) {
      _SearchCategory.org => l.gsOrganization,
      _SearchCategory.event => l.gsVotingEvent(_eventStatusWord(l, r.subtitle)),
      _ => r.subtitle,
    };

String _eventStatusWord(AppLocalizations l, String name) => switch (name) {
      'draft' => l.statusDraft,
      'scheduled' => l.statusScheduled,
      'active' => l.statusActive,
      'closed' => l.statusClosed,
      'cancelled' => l.statusCancelled,
      'archived' => l.statusArchived,
      _ => name,
    };

// ─── Provider: flattened search index ─────────────────────────────────────────

final _searchIndexProvider =
    FutureProvider.autoDispose<List<_SearchResult>>((ref) async {
  // Watch the selected tenant and role: the index must follow org switches,
  // and draft/member shortcuts must not linger from the previous context.
  final activeCtx =
      ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
  final isManager = activeCtx?.member.role.isAdmin ?? false;
  final orgs = await ref
      .watch(userOrganizationsProvider.future)
      .catchError((_) => <Organization>[]);

  final orgId = activeCtx?.organization.id;

  final results = <_SearchResult>[];

  for (final org in orgs) {
    results.add(_SearchResult(
      title: org.name,
      subtitle: '',
      icon: Icons.business_rounded,
      route: '/orgs',
      category: _SearchCategory.org,
      iconColor: AppTheme.primaryBlue,
    ));
  }

  if (orgId != null) {
    try {
      final repo = ref.read(votingEventRepositoryProvider);
      final events = await repo
          .watchOrganizationVotingEvents(orgId, includeDrafts: isManager)
          .first;
      for (final e in events.take(50)) {
        results.add(_SearchResult(
          title: e.title,
          subtitle: e.status.name,
          icon: Icons.how_to_vote_rounded,
          route: '/elections/${e.id}',
          category: _SearchCategory.event,
          iconColor: AppTheme.accentCyan,
        ));
      }
    } catch (_) {}

    if (isManager) {
      try {
        final repo = ref.read(organizationRepositoryProvider);
        final result = await repo.getOrganizationMembers(organizationId: orgId);
        final members = result.members;
        for (final m in members.take(100)) {
          final name = '${m['firstName'] ?? ''} ${m['lastName'] ?? ''}'.trim();
          final email = m['email'] as String? ?? '';
          if (name.isEmpty) continue;
          results.add(_SearchResult(
            title: name,
            subtitle: email,
            icon: Icons.person_rounded,
            route: '/orgs/members',
            category: _SearchCategory.member,
            iconColor: AppTheme.secondaryBlue,
          ));
        }
      } catch (_) {}
    }
  }

  return results;
});

// ─── Public entry point ───────────────────────────────────────────────────────

void showGlobalSearch(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppLocalizations.of(context).gsSearchLabel,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 180),
    transitionBuilder: (context, anim, _, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      );
    },
    pageBuilder: (context, _, __) => const _GlobalSearchDialog(),
  );
}

// ─── Dialog ───────────────────────────────────────────────────────────────────

class _GlobalSearchDialog extends ConsumerStatefulWidget {
  const _GlobalSearchDialog();

  @override
  ConsumerState<_GlobalSearchDialog> createState() =>
      _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends ConsumerState<_GlobalSearchDialog> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  String _query = '';
  int _selectedIndex = 0;

  List<_SearchResult> _filter(List<_SearchResult> index) {
    final l = AppLocalizations.of(context);
    final activeCtx =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
    final memberRole = activeCtx?.member.role;
    final isOwner = memberRole == OrganizationRole.owner;
    final isManager = isOwner || memberRole == OrganizationRole.admin;
    final isObserver = activeCtx?.member.isObserver ?? false;
    final isPlatformAdmin =
        ref.watch(platformAdminProvider).valueOrNull ?? false;
    final model = navModelFor(
      isManager: isManager,
      isOwner: isOwner,
      isObserver: isObserver,
      isPlatformAdmin: isPlatformAdmin,
    );
    final shortcuts = _staticRoutes(l, model);
    if (_query.isEmpty) return shortcuts;
    final q = _query.toLowerCase();
    final dynamic = index
        .where((r) =>
            r.title.toLowerCase().contains(q) ||
            _subtitleFor(l, r).toLowerCase().contains(q))
        .toList();
    final stat = shortcuts
        .where((r) =>
            r.title.toLowerCase().contains(q) ||
            r.subtitle.toLowerCase().contains(q))
        .toList();
    // Merge: dynamic first (orgs, events, members), then route shortcuts
    final seen = <String>{};
    final merged = <_SearchResult>[];
    for (final r in [...dynamic, ...stat]) {
      final key = '${r.title}|${r.route}';
      if (seen.add(key)) merged.add(r);
    }
    return merged;
  }

  Future<void> _navigate(String route) async {
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);
    // Leaving a screen with unsaved work (e.g. the election builder) asks first.
    final canLeave =
        await canLeaveCurrentScreen(ProviderScope.containerOf(context));
    if (!canLeave || !mounted) return;
    navigator.pop();
    router.go(route);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kc = RaayColors.of(context);
    final indexAsync = ref.watch(_searchIndexProvider);
    final index = indexAsync.valueOrNull ?? [];
    final results = _filter(index);
    if (_selectedIndex >= results.length) _selectedIndex = 0;

    return Align(
      alignment: const Alignment(0, -0.22),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 520),
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: kc.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kc.border, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Search input ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) {
                      if (event is! KeyDownEvent) return;
                      if (results.isEmpty) return;
                      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                        setState(() => _selectedIndex =
                            (_selectedIndex + 1) % results.length);
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowUp) {
                        setState(() => _selectedIndex =
                            (_selectedIndex - 1 + results.length) %
                                results.length);
                      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                        if (_selectedIndex < results.length) {
                          _navigate(results[_selectedIndex].route);
                        }
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.escape) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded,
                            size: 20, color: kc.textSecondary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            focusNode: _focus,
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context).gsSearchHint,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 16),
                            ),
                            style: TextStyle(
                                fontSize: 15,
                                color: kc.textPrimary,
                                fontWeight: FontWeight.w500),
                            onChanged: (v) => setState(() {
                              _query = v;
                              _selectedIndex = 0;
                            }),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          IconButton(
                            tooltip: MaterialLocalizations.of(context)
                                .deleteButtonTooltip,
                            onPressed: () => setState(() {
                              _ctrl.clear();
                              _query = '';
                            }),
                            icon: Icon(Icons.close_rounded,
                                size: 16, color: kc.textSecondary),
                            constraints: const BoxConstraints(
                                minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          ),
                        Container(
                          margin: const EdgeInsetsDirectional.only(start: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: kc.border,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(AppLocalizations.of(context).gsEsc,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: kc.textSecondary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, color: kc.border),

                // ── Results ──
                if (indexAsync.isLoading && _query.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LinearProgressIndicator(minHeight: 2),
                  )
                else if (results.isEmpty && _query.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 36, color: kc.textSecondary),
                        const SizedBox(height: 10),
                        Text(
                            AppLocalizations.of(context)
                                .gsNoResults(_query.toString()),
                            style: TextStyle(
                                color: kc.textSecondary, fontSize: 14)),
                      ],
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shrinkWrap: true,
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        final r = results[i];
                        final isSelected = i == _selectedIndex;
                        return _ResultTile(
                          result: r,
                          isSelected: isSelected,
                          onTap: () => _navigate(r.route),
                          onHover: (v) {
                            if (v) setState(() => _selectedIndex = i);
                          },
                        );
                      },
                    ),
                  ),

                // ── Footer hint ──
                Divider(height: 1, color: kc.border),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const _Kbd('↑↓'),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.of(context).searchHintNavigate,
                          style:
                              TextStyle(fontSize: 11, color: kc.textSecondary)),
                      const SizedBox(width: 12),
                      const _Kbd('↵'),
                      const SizedBox(width: 4),
                      Text(AppLocalizations.of(context).searchHintOpen,
                          style:
                              TextStyle(fontSize: 11, color: kc.textSecondary)),
                      const Spacer(),
                      if (indexAsync.isLoading)
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                              strokeWidth: 1.5, color: kc.textSecondary),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.result,
    required this.isSelected,
    required this.onTap,
    required this.onHover,
  });
  final _SearchResult result;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kc = RaayColors.of(context);
    final selBg = isDark
        ? AppTheme.primaryBlue.withValues(alpha: 0.14)
        : AppTheme.primaryBlue.withValues(alpha: 0.08);
    final iconBg = isDark
        ? (result.iconColor ?? kc.textSecondary).withValues(alpha: 0.12)
        : (result.iconColor ?? kc.textSecondary).withValues(alpha: 0.08);

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? selBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryBlue.withValues(alpha: 0.25)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(result.icon,
                    size: 16,
                    color: result.iconColor ??
                        (isSelected ? kc.accentText : kc.textSecondary)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.title,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? kc.accentText
                                : kc.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(_subtitleFor(AppLocalizations.of(context), result),
                        style: TextStyle(fontSize: 11, color: kc.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.keyboard_return_rounded,
                    size: 14, color: RaayColors.of(context).accentText),
            ],
          ),
        ),
      ),
    );
  }
}

class _Kbd extends StatelessWidget {
  const _Kbd(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final kc = RaayColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: kc.border,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10,
              color: kc.textSecondary,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace')),
    );
  }
}
