import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_service.dart';

class PlatformAdminScreen extends ConsumerStatefulWidget {
  const PlatformAdminScreen({super.key});

  @override
  ConsumerState<PlatformAdminScreen> createState() =>
      _PlatformAdminScreenState();
}

class _PlatformAdminScreenState extends ConsumerState<PlatformAdminScreen> {
  Map<String, dynamic>? _analytics;
  List<Map<String, dynamic>> _users = [];
  String? _nextPageToken;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  String? _busyUid;

  @override
  void initState() {
    super.initState();
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
      final functions = FirebaseService().functions;
      final results = await Future.wait([
        functions.httpsCallable('getPlatformAnalytics').call(),
        functions.httpsCallable('listPlatformUsers').call(),
      ]);

      final analytics = Map<String, dynamic>.from(results[0].data as Map);
      final usersData = Map<String, dynamic>.from(results[1].data as Map);
      final rows = (usersData['users'] as List<dynamic>? ?? const [])
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();

      if (!mounted) return;
      setState(() {
        _analytics = analytics;
        _users = rows;
        _nextPageToken = usersData['nextPageToken'] as String?;
        _loading = false;
      });
    } on FirebaseFunctionsException catch (error) {
      if (mounted) {
        setState(() {
          _error = error.message ?? 'Could not load platform data.';
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not load platform data.';
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadMoreUsers() async {
    if (_nextPageToken == null || _loadingMore) return;
    setState(() => _loadingMore = true);
    try {
      final response = await FirebaseService()
          .functions
          .httpsCallable('listPlatformUsers')
          .call({'pageToken': _nextPageToken});
      final data = Map<String, dynamic>.from(response.data as Map);
      final rows = (data['users'] as List<dynamic>? ?? const [])
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
      if (!mounted) return;
      setState(() {
        _users = [..._users, ...rows];
        _nextPageToken = data['nextPageToken'] as String?;
        _loadingMore = false;
      });
    } on FirebaseFunctionsException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.message ?? 'Could not load more users.')));
        setState(() => _loadingMore = false);
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  Future<void> _grantAdmin() async {
    if (_busyUid != null) return;
    setState(() => _busyUid = 'grant');

    final emailController = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        scrollable: true,
        title: const Text('Grant platform admin access'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: TextField(
            controller: emailController,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Account email address',
              hintText: 'name@example.com',
            ),
            onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () =>
                Navigator.pop(ctx, emailController.text.trim()),
            child: const Text('Grant access'),
          ),
        ],
      ),
    );
    if (email == null || email.isEmpty || !mounted) {
      if (mounted) setState(() => _busyUid = null);
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await FirebaseService()
          .functions
          .httpsCallable('createAdmin')
          .call({'email': email});
      messenger.showSnackBar(
          SnackBar(content: Text('Platform admin access granted to $email.')));
      if (mounted) await _load();
    } on FirebaseFunctionsException catch (error) {
      messenger.showSnackBar(SnackBar(
          content: Text(error.message ?? 'Could not grant admin access.')));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Could not grant admin access.')));
    } finally {
      if (mounted) setState(() => _busyUid = null);
    }
  }

  Future<void> _revokeAdmin(Map<String, dynamic> user) async {
    if (_busyUid != null) return;
    final uid = user['uid'] as String;
    final email = user['email'] as String? ?? 'this account';
    setState(() => _busyUid = uid);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        title: const Text('Revoke platform admin access?'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Text('$email will lose Platform Super Admin privileges.'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style:
                FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      if (mounted) setState(() => _busyUid = null);
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      await FirebaseService()
          .functions
          .httpsCallable('removeAdmin')
          .call({'uid': uid});
      messenger.showSnackBar(const SnackBar(content: Text('Admin access revoked.')));
      if (mounted) await _load();
    } on FirebaseFunctionsException catch (error) {
      messenger.showSnackBar(SnackBar(
          content: Text(error.message ?? 'Could not revoke admin access.')));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Could not revoke admin access.')));
    } finally {
      if (mounted) setState(() => _busyUid = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = ref.watch(platformAdminProvider);
    return Scaffold(
      backgroundColor: KivoraColors.backgroundOf(context),
      appBar: AppBar(
        title: const Text('Platform administration'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _load,
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: admin.when(
        loading: () => const LoadingView(message: 'Checking platform access…'),
        error: (_, __) => const ErrorView(
          type: ErrorViewType.accessDenied,
          title: 'Access denied',
          message: 'Could not verify platform administrator access.',
        ),
        data: (isAdmin) => !isAdmin
            ? const ErrorView(
                type: ErrorViewType.accessDenied,
                title: 'Access denied',
                message:
                    'This area is available only to Platform Super Admins.',
              )
            : _loading
                ? const LoadingView(message: 'Loading platform data…')
                : _error != null
                    ? ErrorView(
                        type: ErrorViewType.generic,
                        message: _error!,
                        onRetry: _load)
                    : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
        if (_analytics != null) _buildAnalytics(_analytics!),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Accounts', style: Theme.of(context).textTheme.titleMedium),
            FilledButton.icon(
              onPressed: _busyUid != null ? null : _grantAdmin,
              icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
              label: const Text('Grant admin access'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final user in _users) _userCard(user),
        if (_nextPageToken != null) ...[
          const SizedBox(height: 12),
          Center(
            child: OutlinedButton(
              onPressed: _loadingMore ? null : _loadMoreUsers,
              child: _loadingMore
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Load more'),
            ),
          ),
        ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnalytics(Map<String, dynamic> a) {
    Widget stat(String label, dynamic value) => SizedBox(
          width: 140,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$value',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: KivoraColors.textPrimaryOf(context))),
                  const SizedBox(height: 4),
                  Text(label,
                      style: TextStyle(
                          fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
                ],
              ),
            ),
          ),
        );

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        stat('Users', a['users'] ?? 0),
        stat('Organizations', a['organizations'] ?? 0),
        stat('Pending orgs', a['pendingOrganizations'] ?? 0),
        stat('Active orgs', a['activeOrganizations'] ?? 0),
        stat('Suspended orgs', a['suspendedOrganizations'] ?? 0),
        stat('Members', a['members'] ?? 0),
        stat('Active members', a['activeMembers'] ?? 0),
        stat('Voting events', a['votingEvents'] ?? 0),
        stat('Active events', a['activeVotingEvents'] ?? 0),
        stat('Pending reports', a['pendingReports'] ?? 0),
      ],
    );
  }

  Widget _userCard(Map<String, dynamic> user) {
    final uid = user['uid'] as String;
    final email = user['email'] as String? ?? '(no email)';
    final displayName = user['displayName'] as String? ?? '';
    final isPlatformAdmin = user['platformAdmin'] == true;
    final disabled = user['disabled'] == true;
    final emailVerified = user['emailVerified'] == true;
    final busy = _busyUid == uid;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.12),
              child: Text(
                (displayName.isNotEmpty ? displayName : email)
                    .characters
                    .first
                    .toUpperCase(),
                style: const TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName.isNotEmpty ? displayName : email,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(email,
                      style: TextStyle(
                          fontSize: 12, color: KivoraColors.textSecondaryOf(context))),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: [
                      if (isPlatformAdmin)
                        const _Tag(label: 'Platform admin', color: AppTheme.primaryBlue),
                      if (!emailVerified)
                        _Tag(label: 'Unverified', color: KivoraColors.textSecondaryOf(context)),
                      if (disabled)
                        const _Tag(label: 'Disabled', color: AppTheme.error),
                    ],
                  ),
                ],
              ),
            ),
            if (isPlatformAdmin)
              OutlinedButton(
                onPressed: busy ? null : () => _revokeAdmin(user),
                style: OutlinedButton.styleFrom(foregroundColor: AppTheme.error),
                child: busy
                    ? const SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Revoke'),
              ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
