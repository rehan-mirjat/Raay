import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../data/organization_repository.dart';
import 'providers/organization_providers.dart';
import '../../../core/utils/friendly_error.dart';

/// Landing screen for a kivora://invite (or https://.../invite) deep link -
/// see buildInviteLink in organization_repository.dart for how the link is
/// generated, and pendingInviteTokenProvider in app_router.dart for how a
/// not-yet-signed-in user is brought back here once they finish signing in.
class AcceptInvitationLinkScreen extends ConsumerStatefulWidget {
  const AcceptInvitationLinkScreen({super.key, required this.rawToken});

  final String? rawToken;

  @override
  ConsumerState<AcceptInvitationLinkScreen> createState() =>
      _AcceptInvitationLinkScreenState();
}

enum _Stage { confirm, working, success, error }

class _AcceptInvitationLinkScreenState
    extends ConsumerState<AcceptInvitationLinkScreen> {
  _Stage _stage = _Stage.confirm;
  String? _error;
  String? _organizationName;

  @override
  void initState() {
    super.initState();
    if (widget.rawToken == null || widget.rawToken!.trim().isEmpty) {
      _stage = _Stage.error;
      _error = 'This invitation link is missing or malformed.';
    }
    // The token has now reached this screen - stop the router from
    // redirecting back here on every navigation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(pendingInviteTokenProvider.notifier).state = null;
    });
  }

  Future<void> _accept() async {
    setState(() => _stage = _Stage.working);
    try {
      final repo = ref.read(organizationRepositoryProvider);
      final activeOrg = ref.read(activeOrgIdProvider.notifier);
      final result = await repo.acceptInvitationByToken(widget.rawToken!);

      ref.invalidate(userMembershipsProvider);
      ref.invalidate(userOrganizationsProvider);
      ref.invalidate(activeOrganizationContextProvider);
      await activeOrg.selectOrganization(result.organizationId);

      if (mounted) {
        setState(() {
          _stage = _Stage.success;
          _organizationName = result.organizationName;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _stage = _Stage.error;
          _error = friendlyError(e);
        });
      }
    }
  }

  void _continue() {
    if (mounted) context.go('/orgs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              decoration: BoxDecoration(
                color: KivoraColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: KivoraColors.borderOf(context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(28),
              child: switch (_stage) {
                _Stage.confirm => _buildConfirm(),
                _Stage.working => _buildWorking(),
                _Stage.success => _buildSuccess(),
                _Stage.error => _buildError(),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.mail_outline_rounded,
              size: 24, color: KivoraColors.of(context).accentText),
        ),
        const SizedBox(height: 20),
        Text(
          'You\'ve been invited',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: KivoraColors.textPrimaryOf(context),
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Accept to join this organization with the email address you\'re signed in with.',
          style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () => context.go('/home'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Not now'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _accept,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Accept invitation'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorking() {
    return SizedBox(
      height: 160,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Accepting invitation…',
                style: TextStyle(color: KivoraColors.textSecondaryOf(context))),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded,
            size: 40, color: KivoraColors.of(context).successText),
        const SizedBox(height: 16),
        Text(
          'Welcome to ${_organizationName ?? 'the organization'}!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: KivoraColors.textPrimaryOf(context),
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'You\'ve successfully joined. You can start exploring right away.',
          style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: _continue,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline_rounded, size: 40, color: KivoraColors.of(context).errorText),
        const SizedBox(height: 16),
        Text(
          'Couldn\'t accept this invitation',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KivoraColors.textPrimaryOf(context)),
        ),
        const SizedBox(height: 8),
        Text(
          _error ?? 'Something went wrong. Please try again.',
          style: TextStyle(color: KivoraColors.textSecondaryOf(context), fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: () => context.go('/home'),
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Go to home'),
          ),
        ),
      ],
    );
  }
}
