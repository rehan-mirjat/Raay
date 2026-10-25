import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_service.dart';
import '../../platform/presentation/platform_scaffold.dart'
    show PlatformHeaderBar;
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/status_text.dart';
import '../domain/platform_organization_filter.dart';

class PlatformOrganizationsScreen extends ConsumerStatefulWidget {
  const PlatformOrganizationsScreen({super.key});

  @override
  ConsumerState<PlatformOrganizationsScreen> createState() =>
      _PlatformOrganizationsScreenState();
}

class _PlatformOrganizationsScreenState
    extends ConsumerState<PlatformOrganizationsScreen> {
  List<Map<String, dynamic>> _organizations = [];
  bool _loading = true;
  String? _error;
  String? _busyId;
  OrgFilter? _filter; // null until the first load picks a sensible default
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Only hit the admin-only callable once we know the caller is a platform admin.
    Future.microtask(() async {
      var isAdmin = false;
      try {
        isAdmin = await ref.read(platformAdminProvider.future);
      } catch (_) {}
      if (!mounted) return;
      if (isAdmin) {
        _load();
      } else {
        setState(() => _loading = false);
      }
    });
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await FirebaseService()
          .functions
          .httpsCallable('listOrganizationsForPlatformAdmin')
          .call();
      final data = Map<String, dynamic>.from(response.data as Map);
      final rows = (data['organizations'] as List<dynamic>? ?? const []);
      if (!mounted) return;
      setState(() {
        _organizations =
            rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
        // First load: land on what needs a decision; otherwise show everything.
        _filter ??= countByFilter(_organizations)[OrgFilter.needsReview]! > 0
            ? OrgFilter.needsReview
            : OrgFilter.all;
        _loading = false;
      });
    } on FirebaseFunctionsException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message ?? AppLocalizations.of(context).porLoadFailed;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = AppLocalizations.of(context).porLoadFailed;
          _loading = false;
        });
      }
    }
  }

  Future<void> _review(Map<String, dynamic> organization, String action) async {
    if (_busyId != null) return;
    final l = AppLocalizations.of(context);
    final (label, resultingStatus, destructive) = switch (action) {
      'VERIFY' => (l.porVerify, orgStatusText(l, 'verified'), false),
      'REJECT' => (l.porReject, orgStatusText(l, 'rejected'), true),
      'SUSPEND' => (l.porSuspend, orgStatusText(l, 'suspended'), true),
      'REACTIVATE' => (l.porReactivate, orgStatusText(l, 'active'), false),
      _ => (action, action.toLowerCase(), false),
    };
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.porReviewTitle(label)),
        content: Text(l.porReviewBody(
            (organization['name'] as String?) ?? l.porThisOrg,
            resultingStatus)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.porCancel)),
          FilledButton(
            style: destructive
                ? FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error)
                : null,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(label),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busyId = organization['id'] as String?);
    try {
      await FirebaseService()
          .functions
          .httpsCallable('reviewOrganization')
          .call({
        'organizationId': organization['id'],
        'action': action,
      });
      messenger
          .showSnackBar(SnackBar(content: Text(l.porMarked(resultingStatus))));
      if (mounted) await _load();
    } on FirebaseFunctionsException catch (error) {
      messenger.showSnackBar(
          SnackBar(content: Text(error.message ?? l.porUpdateFailed)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.porUpdateFailed)));
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = ref.watch(platformAdminProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PlatformHeaderBar(
          title: AppLocalizations.of(context).porTitle,
          onRefresh: _loading ? null : _load),
      body: admin.when(
        loading: () => LoadingView(
            message: AppLocalizations.of(context).porCheckingAccess),
        error: (_, __) => ErrorView(
            type: ErrorViewType.accessDenied,
            title: AppLocalizations.of(context).porDeniedTitle,
            message: AppLocalizations.of(context).porVerifyAccessFailed),
        data: (isAdmin) => !isAdmin
            ? ErrorView(
                type: ErrorViewType.accessDenied,
                title: AppLocalizations.of(context).porDeniedTitle,
                message: AppLocalizations.of(context).porSuperAdminsOnly)
            : _loading
                ? LoadingView(message: AppLocalizations.of(context).porLoading)
                : _error != null
                    ? ErrorView(
                        type: ErrorViewType.generic,
                        message: _error!,
                        onRetry: _load)
                    : _organizations.isEmpty
                        ? EmptyView(
                            icon: Icons.domain_outlined,
                            title: AppLocalizations.of(context).porEmptyTitle,
                            message: AppLocalizations.of(context).porEmptyBody,
                          )
                        : _list(),
      ),
    );
  }

  static const _tap =
      ButtonStyle(minimumSize: WidgetStatePropertyAll(Size(48, 48)));

  Widget _list() {
    final filter = _filter ?? OrgFilter.all;
    final counts = countByFilter(_organizations);
    final shown = filterOrganizations(_organizations, filter, _search.text);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).porSearch,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: AppLocalizations.of(context).porClearSearch,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(_search.clear),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final f in OrgFilter.values)
                ChoiceChip(
                  label: Text(
                      '${f.localized(AppLocalizations.of(context))} (${counts[f]})'),
                  selected: f == filter,
                  onSelected: (_) => setState(() => _filter = f),
                ),
            ]),
            if (_organizations.length >= 100)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(AppLocalizations.of(context).porShowing100,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            const SizedBox(height: 12),
            if (shown.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  _search.text.trim().isNotEmpty
                      ? AppLocalizations.of(context)
                          .porNoMatch(_search.text.trim())
                      : AppLocalizations.of(context).porNothingIn(
                          filter.localized(AppLocalizations.of(context))),
                  textAlign: TextAlign.center,
                ),
              )
            else
              for (final o in shown) _organizationCard(o),
          ],
        ),
      ),
    );
  }

  Widget _organizationCard(Map<String, dynamic> organization) {
    final status = organization['status'] as String? ?? 'pending';
    final name = organization['name'] as String? ?? 'Organization';
    final address = [organization['city'], organization['country']]
        .whereType<String>()
        .where((part) => part.isNotEmpty)
        .join(', ');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child:
                    Text(name, style: Theme.of(context).textTheme.titleMedium)),
            Chip(
                label: Text(orgStatusText(AppLocalizations.of(context), status)
                    .toUpperCase()))
          ]),
          if ((organization['email'] as String? ?? '').isNotEmpty)
            Text(organization['email'] as String),
          if (address.isNotEmpty)
            Text(address, style: Theme.of(context).textTheme.bodySmall),
          if (organization['createdAt'] is String)
            Text(
                AppLocalizations.of(context).porRegistered(
                    (organization['createdAt'] as String).split('T').first),
                style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          // Every status needs either an action or a reason there is none.
          if (status == 'archived')
            Text(AppLocalizations.of(context).porArchivedNote,
                style: Theme.of(context).textTheme.bodySmall),
          if (status == 'rejected')
            Text(AppLocalizations.of(context).porRejectedNote,
                style: Theme.of(context).textTheme.bodySmall),
          Wrap(spacing: 8, runSpacing: 8, children: [
            if (status == 'pending') ...[
              FilledButton.tonal(
                  style: _tap,
                  onPressed: _busyId != null
                      ? null
                      : () => _review(organization, 'VERIFY'),
                  child: Text(AppLocalizations.of(context).porVerify)),
              OutlinedButton(
                  style: _tap,
                  onPressed: _busyId != null
                      ? null
                      : () => _review(organization, 'REJECT'),
                  child: Text(AppLocalizations.of(context).porReject)),
            ],
            if (status == 'verified' || status == 'active')
              OutlinedButton(
                  style: _tap,
                  onPressed: _busyId != null
                      ? null
                      : () => _review(organization, 'SUSPEND'),
                  child: Text(AppLocalizations.of(context).porSuspend)),
            if (status == 'suspended')
              FilledButton.tonal(
                  style: _tap,
                  onPressed: _busyId != null
                      ? null
                      : () => _review(organization, 'REACTIVATE'),
                  child: Text(AppLocalizations.of(context).porReactivate)),
          ]),
        ]),
      ),
    );
  }
}
