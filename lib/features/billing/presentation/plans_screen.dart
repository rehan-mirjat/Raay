import '../../../l10n/app_localizations.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kivora_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/friendly_error.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/ui_kit/kivora_button.dart';
import '../../../core/widgets/ui_kit/kivora_card.dart';
import '../../../services/firebase_service.dart';
import '../../organizations/domain/organization_enums.dart';
import '../../organizations/presentation/providers/organization_providers.dart';
import '../domain/plan.dart';
import 'plan_providers.dart';

/// Optional sales contact, injected at build time: --dart-define=SALES_EMAIL=...
const _salesEmail = String.fromEnvironment('SALES_EMAIL');

/// Flip on once the Stripe functions are deployed: --dart-define=BILLING_ENABLED=true
const _billingEnabled = bool.fromEnvironment('BILLING_ENABLED');

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  bool _busy = false;

  Future<void> _openStripe(String callable, String orgId) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final result = await FirebaseService()
          .functions
          .httpsCallable(callable)
          .call({'organizationId': orgId});
      final url = (result.data as Map?)?['url'] as String?;
      if (url == null ||
          !await launchUrl(Uri.parse(url),
              mode: LaunchMode.externalApplication)) {
        throw Exception(l.plOpenFailed);
      }
    } catch (e) {
      if (!mounted) return;
      final message = e is FirebaseFunctionsException
          ? (isRecentAuthError(e)
              ? l.plReauth
              : (e.message ?? l.plGeneric))
          : friendlyError(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    final ctx =
        ref.watch(activeOrganizationContextProvider).valueOrNull?.context;
    final current = ref.watch(activePlanProvider);
    final isOwner = ctx?.member.role == OrganizationRole.owner;

    return Scaffold(
      backgroundColor: kc.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: Text(AppLocalizations.of(context).plBack),
                ),
                Semantics(
                  header: true,
                  child: Text(AppLocalizations.of(context).plTitle,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary)),
                ),
                const SizedBox(height: 6),
                Text(
                  ctx == null
                      ? AppLocalizations.of(context).plNoOrg
                      : AppLocalizations.of(context)
                          .plIntro(ctx.organization.name.toString()),
                  style: TextStyle(color: kc.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 20),
                for (final plan in kPlans) ...[
                  _PlanCard(
                    plan: plan,
                    isCurrent: plan.id == current,
                    action:
                        _action(plan, current, isOwner, ctx?.organization.id),
                  ),
                  const SizedBox(height: 14),
                ],
                if (!isOwner && ctx != null)
                  Text(AppLocalizations.of(context).plOwnerOnly,
                      style: TextStyle(color: kc.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _action(PlanInfo plan, PlanId current, bool isOwner, String? orgId) {
    if (orgId == null || plan.id == current) return null;
    if (!_billingEnabled && plan.id == PlanId.pro) {
      return KivoraButton(
        type: KivoraButtonType.secondary,
        label: AppLocalizations.of(context).plSoon,
        icon: Icons.schedule_rounded,
        onPressed: null,
      );
    }
    if (plan.id == PlanId.pro && current == PlanId.free) {
      return KivoraButton(
        label: _busy
            ? AppLocalizations.of(context).plOpening
            : AppLocalizations.of(context).plUpgrade,
        icon: Icons.workspace_premium_outlined,
        onPressed: (!isOwner || _busy)
            ? null
            : () => _openStripe('createCheckoutSession', orgId),
      );
    }
    if (plan.id == PlanId.free && current == PlanId.pro) {
      return KivoraButton(
        type: KivoraButtonType.secondary,
        label: _busy
            ? AppLocalizations.of(context).plOpening
            : AppLocalizations.of(context).plManage,
        onPressed: (!isOwner || _busy)
            ? null
            : () => _openStripe('createBillingPortalSession', orgId),
      );
    }
    if (plan.id == PlanId.enterprise && _salesEmail.isNotEmpty) {
      return KivoraButton(
        type: KivoraButtonType.secondary,
        label: AppLocalizations.of(context).plContact,
        onPressed: () => launchUrl(Uri(scheme: 'mailto', path: _salesEmail)),
      );
    }
    return null;
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.isCurrent, this.action});

  final PlanInfo plan;
  final bool isCurrent;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final kc = KivoraColors.of(context);
    return KivoraCard(
      isGlass: isCurrent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(plan.name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary)),
                  if (isCurrent)
                    StatusBadge(
                      label: AppLocalizations.of(context).plCurrent,
                      backgroundColor: AppTheme.primaryBlue
                          .withValues(alpha: kc.isDark ? 0.16 : 0.10),
                      textColor: kc.accentText,
                      icon: Icons.check_circle_rounded,
                    ),
                ],
              ),
              Text(plan.priceLabel,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kc.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          for (final f in plan.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_rounded, size: 18, color: kc.successText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(f,
                        style: TextStyle(color: kc.textPrimary, fontSize: 14)),
                  ),
                ],
              ),
            ),
          if (action != null) ...[const SizedBox(height: 10), action!],
        ],
      ),
    );
  }
}
