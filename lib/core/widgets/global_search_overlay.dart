import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/organizations/data/organization_repository.dart';
import '../../features/organizations/presentation/providers/organization_providers.dart';
import '../../features/organizations/domain/organization.dart';
import '../../features/voting_events/data/voting_event_repository.dart';
import '../theme/app_theme.dart';
import '../theme/kivora_colors.dart';

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

const _staticRoutes = [
  _SearchResult(
      title: 'Home', subtitle: 'Dashboard', icon: Icons.home_outlined,
      route: '/home', category: _SearchCategory.route),
  _SearchResult(
      title: 'Organizations', subtitle: 'Your workspaces', icon: Icons.business_outlined,
      route: '/orgs', category: _SearchCategory.route),
  _SearchResult(
      title: 'Events', subtitle: 'Manage voting events', icon: Icons.how_to_vote_outlined,
      route: '/admin/events', category: _SearchCategory.route),
  _SearchResult(
      title: 'Members directory', subtitle: 'Browse org members', icon: Icons.groups_outlined,
      route: '/orgs/members', category: _SearchCategory.route),
  _SearchResult(
      title: 'Departments', subtitle: 'Manage departments', icon: Icons.apartment_outlined,
      route: '/orgs/departments', category: _SearchCategory.route),
  _SearchResult(
      title: 'Account settings', subtitle: 'Profile & security', icon: Icons.settings_outlined,
      route: '/settings', category: _SearchCategory.route),
  _SearchResult(
      title: 'Audit log', subtitle: 'Organization activity', icon: Icons.history_edu_outlined,
      route: '/orgs/audit', category: _SearchCategory.route),
  _SearchResult(
      title: 'Invitations', subtitle: 'Pending org invitations', icon: Icons.mail_outline_rounded,
      route: '/orgs/invitations', category: _SearchCategory.route),
];

// ─── Provider: flattened search index ─────────────────────────────────────────

final _searchIndexProvider =
    FutureProvider.autoDispose<List<_SearchResult>>((ref) async {
  final orgs = await ref.watch(userOrganizationsProvider.future).catchError((_) => <Organization>[]);

  final activeCtx = ref.read(activeOrganizationContextProvider).valueOrNull?.context;
  final orgId = activeCtx?.organization.id;

  final results = <_SearchResult>[];

  for (final org in orgs) {
    results.add(_SearchResult(
      title: org.name,
      subtitle: 'Organization',
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
          .watchOrganizationVotingEvents(orgId, includeDrafts: true)
          .first;
      for (final e in events.take(50)) {
        results.add(_SearchResult(
          title: e.title,
          subtitle: 'Voting event · ${e.status.name}',
          icon: Icons.how_to_vote_rounded,
          route: '/elections/${e.id}',
          category: _SearchCategory.event,
          iconColor: AppTheme.accentCyan,
        ));
      }
    } catch (_) {}

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

  return results;
});

// ─── Public entry point ───────────────────────────────────────────────────────

void showGlobalSearch(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Search',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 180),
    transitionBuilder: (context, anim, _, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
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
  ConsumerState<_GlobalSearchDialog> createState() => _GlobalSearchDialogState();
}

class _GlobalSearchDialogState extends ConsumerState<_GlobalSearchDialog> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  String _query = '';
  int _selectedIndex = 0;

  List<_SearchResult> _filter(List<_SearchResult> index) {
    if (_query.isEmpty) return _staticRoutes;
    final q = _query.toLowerCase();
    final dynamic = index
        .where((r) =>
            r.title.toLowerCase().contains(q) ||
            r.subtitle.toLowerCase().contains(q))
        .toList();
    final stat = _staticRoutes
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

  void _navigate(String route) {
    Navigator.of(context).pop();
    context.go(route);
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
    final kc = KivoraColors.of(context);
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
                        setState(() =>
                            _selectedIndex = (_selectedIndex + 1) % results.length);
                      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                        setState(() => _selectedIndex =
                            (_selectedIndex - 1 + results.length) % results.length);
                      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                        if (_selectedIndex < results.length) {
                          _navigate(results[_selectedIndex].route);
                        }
                      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
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
                            decoration: const InputDecoration(
                              hintText: 'Search events, members, organizations…',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            style: TextStyle(
                                fontSize: 15,
                                color: kc.textPrimary,
                                fontWeight: FontWeight.w500),
                            onChanged: (v) =>
                                setState(() { _query = v; _selectedIndex = 0; }),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          IconButton(
                            onPressed: () =>
                                setState(() { _ctrl.clear(); _query = ''; }),
                            icon: Icon(Icons.close_rounded,
                                size: 16, color: kc.textSecondary),
                            constraints:
                                const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          ),
                        Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: kc.border,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('ESC',
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
                if (results.isEmpty && _query.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 36, color: kc.textSecondary),
                        const SizedBox(height: 10),
                        Text('No results for "$_query"',
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
                      Text('navigate', style: TextStyle(fontSize: 11, color: kc.textSecondary)),
                      const SizedBox(width: 12),
                      const _Kbd('↵'),
                      const SizedBox(width: 4),
                      Text('open', style: TextStyle(fontSize: 11, color: kc.textSecondary)),
                      const Spacer(),
                      if (indexAsync.isLoading)
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: kc.textSecondary),
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
    final kc = KivoraColors.of(context);
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
                        (isSelected ? AppTheme.primaryBlue : kc.textSecondary)),
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
                                ? AppTheme.primaryBlue
                                : kc.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(result.subtitle,
                        style: TextStyle(fontSize: 11, color: kc.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.keyboard_return_rounded,
                    size: 14, color: AppTheme.primaryBlue),
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
    final kc = KivoraColors.of(context);
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
