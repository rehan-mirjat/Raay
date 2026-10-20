import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_service.dart';

class PlatformOrganizationsScreen extends ConsumerStatefulWidget {
  const PlatformOrganizationsScreen({super.key});

  @override
  ConsumerState<PlatformOrganizationsScreen> createState() => _PlatformOrganizationsScreenState();
}

class _PlatformOrganizationsScreenState extends ConsumerState<PlatformOrganizationsScreen> {
  List<Map<String, dynamic>> _organizations = [];
  bool _loading = true;
  String? _error;
  String? _busyId;

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
    setState(() { _loading = true; _error = null; });
    try {
      final response = await FirebaseService().functions.httpsCallable('listOrganizationsForPlatformAdmin').call();
      final data = Map<String, dynamic>.from(response.data as Map);
      final rows = (data['organizations'] as List<dynamic>? ?? const []);
      if (!mounted) return;
      setState(() {
        _organizations = rows.map((row) => Map<String, dynamic>.from(row as Map)).toList();
        _loading = false;
      });
    } on FirebaseFunctionsException catch (error) {
      if (mounted) setState(() { _error = error.message ?? 'Could not load organizations.'; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _error = 'Could not load organizations.'; _loading = false; });
    }
  }

  Future<void> _review(Map<String, dynamic> organization, String action) async {
    if (_busyId != null) return;
    final (label, resultingStatus, destructive) = switch (action) {
      'VERIFY' => ('Verify', 'verified', false),
      'REJECT' => ('Reject', 'rejected', true),
      'SUSPEND' => ('Suspend', 'suspended', true),
      'REACTIVATE' => ('Reactivate', 'active', false),
      _ => (action, action.toLowerCase(), false),
    };
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$label organization?'),
        content: Text('${organization['name'] ?? 'This organization'} will be marked as $resultingStatus.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: destructive ? FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error) : null,
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
      await FirebaseService().functions.httpsCallable('reviewOrganization').call({
        'organizationId': organization['id'],
        'action': action,
      });
      messenger.showSnackBar(SnackBar(content: Text('Organization marked as $resultingStatus.')));
      if (mounted) await _load();
    } on FirebaseFunctionsException catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(error.message ?? 'Could not update organization.')));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(content: Text('Could not update organization.')));
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = ref.watch(platformAdminProvider);
    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      appBar: AppBar(title: const Text('Platform organizations'), actions: [IconButton(onPressed: _loading ? null : _load, tooltip: 'Refresh', icon: const Icon(Icons.refresh_rounded))]),
      body: admin.when(
        loading: () => const LoadingView(message: 'Checking platform access…'),
        error: (_, __) => const ErrorView(type: ErrorViewType.accessDenied, title: 'Access denied', message: 'Could not verify platform administrator access.'),
        data: (isAdmin) => !isAdmin
            ? const ErrorView(type: ErrorViewType.accessDenied, title: 'Access denied', message: 'This area is available only to Platform Super Admins.')
            : _loading
                ? const LoadingView(message: 'Loading organizations…')
                : _error != null
                    ? ErrorView(type: ErrorViewType.generic, message: _error!, onRetry: _load)
                    : _organizations.isEmpty
                        ? const EmptyView(
                            icon: Icons.domain_outlined,
                            title: 'No organizations yet',
                            message: 'No organizations have been registered on the platform yet.',
                          )
                        : Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 820),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _organizations.length,
                                itemBuilder: (context, index) =>
                                    _organizationCard(_organizations[index]),
                              ),
                            ),
                          ),
      ),
    );
  }

  Widget _organizationCard(Map<String, dynamic> organization) {
    final status = organization['status'] as String? ?? 'pending';
    final name = organization['name'] as String? ?? 'Organization';
    final address = [organization['city'], organization['country']].whereType<String>().where((part) => part.isNotEmpty).join(', ');
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(name, style: Theme.of(context).textTheme.titleMedium)), Chip(label: Text(status.toUpperCase()))]),
          if ((organization['email'] as String? ?? '').isNotEmpty) Text(organization['email'] as String),
          if (address.isNotEmpty) Text(address, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            if (status == 'pending') ...[
              FilledButton.tonal(onPressed: _busyId != null ? null : () => _review(organization, 'VERIFY'), child: const Text('Verify')),
              OutlinedButton(onPressed: _busyId != null ? null : () => _review(organization, 'REJECT'), child: const Text('Reject')),
            ],
            if (status == 'verified' || status == 'active')
              OutlinedButton(onPressed: _busyId != null ? null : () => _review(organization, 'SUSPEND'), child: const Text('Suspend')),
            if (status == 'suspended')
              FilledButton.tonal(onPressed: _busyId != null ? null : () => _review(organization, 'REACTIVATE'), child: const Text('Reactivate')),
          ]),
        ]),
      ),
    );
  }
}
