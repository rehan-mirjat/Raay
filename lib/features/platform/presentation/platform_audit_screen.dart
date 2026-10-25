import '../../../core/utils/audit_action_label.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../data/platform_providers.dart';
import '../domain/platform_audit_entry.dart';
import 'platform_overview_screen.dart' show AuditEntryRow;
import 'platform_scaffold.dart';

/// The platform audit log: real entries from `platformAuditLogs`, newest
/// first. Only completed actions are recorded, so there is no outcome column.
class PlatformAuditScreen extends ConsumerStatefulWidget {
  const PlatformAuditScreen({super.key});

  @override
  ConsumerState<PlatformAuditScreen> createState() =>
      _PlatformAuditScreenState();
}

class _PlatformAuditScreenState extends ConsumerState<PlatformAuditScreen> {
  int _limit = kPlatformPageSize;
  String? _action;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformPage(
      title: AppLocalizations.of(context).plAuditTitle,
      subtitle: AppLocalizations.of(context).plAuditSubtitle,
      actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
          onPressed: () {
            ref.invalidate(platformAuditProvider(_limit));
            ref.invalidate(platformDirectoryProvider);
          },
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: Text(AppLocalizations.of(context).plRefresh),
        ),
      ],
      builder: (context) {
        final kc = KivoraColors.of(context);
        final logs = ref.watch(platformAuditProvider(_limit));
        final dir = ref.watch(platformDirectoryProvider).valueOrNull ??
            const PlatformDirectory();
        return logs.when(
          loading: () => Padding(
              padding: const EdgeInsets.all(32),
              child: LoadingView(
                  message: AppLocalizations.of(context).plAuditLoading)),
          error: (e, _) => ErrorView(
            type: ErrorViewType.generic,
            message: AppLocalizations.of(context).plAuditFailed,
            onRetry: () => ref.invalidate(platformAuditProvider(_limit)),
          ),
          data: (entries) {
            if (entries.isEmpty) {
              return EmptyView(
                icon: Icons.history_rounded,
                title: AppLocalizations.of(context).plAuditEmptyTitle,
                message: AppLocalizations.of(context).plAuditEmptyBody,
              );
            }
            final actions = {for (final e in entries) e.action}.toList()
              ..sort();
            if (_action != null && !actions.contains(_action)) {
              _action = null;
            }
            final shown = filterAuditEntries(entries,
                action: _action,
                query: _search.text,
                userName: dir.user,
                orgName: dir.org);
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(AppLocalizations.of(context).plAuditNote,
                      style: TextStyle(fontSize: 13, color: kc.textSecondary)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).plAuditSearch,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip:
                                  AppLocalizations.of(context).plClearSearch,
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => setState(_search.clear)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    ChoiceChip(
                        label: Text(AppLocalizations.of(context).plAllActions),
                        selected: _action == null,
                        onSelected: (_) => setState(() => _action = null)),
                    for (final a in actions)
                      ChoiceChip(
                          label: Text(
                              auditActionText(AppLocalizations.of(context), a)),
                          selected: _action == a,
                          onSelected: (_) => setState(() => _action = a)),
                  ]),
                  const SizedBox(height: 16),
                  PlatformPanel(
                    title: shown.length == 1
                        ? AppLocalizations.of(context).plEntryOne
                        : AppLocalizations.of(context)
                            .plEntryMany('${shown.length}'),
                    child: shown.isEmpty
                        ? Text(AppLocalizations.of(context).plNoEntryMatch,
                            style: TextStyle(color: kc.textSecondary))
                        : Column(children: [
                            for (var i = 0; i < shown.length; i++) ...[
                              if (i > 0) Divider(height: 1, color: kc.border),
                              AuditEntryRow(entry: shown[i], directory: dir),
                            ],
                          ]),
                  ),
                  if (entries.length >= _limit)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size(48, 48)),
                          onPressed: () =>
                              setState(() => _limit += kPlatformPageSize),
                          child: Text(AppLocalizations.of(context).plLoadOlder),
                        ),
                      ),
                    ),
                ]);
          },
        );
      },
    );
  }
}
