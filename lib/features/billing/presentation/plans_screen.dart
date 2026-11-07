import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/raay_colors.dart';
import '../../../core/widgets/ui_kit/raay_card.dart';
import '../../../core/widgets/ui_kit/raay_button.dart';
import '../../landing/presentation/landing_widgets.dart' show ReflowGrid;
import '../../organizations/presentation/providers/organization_providers.dart';
import '../../organizations/domain/organization_enums.dart';
import '../domain/election_offer.dart';
import '../data/sales_repository.dart';
import 'sales_inquiry_dialog.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key, this.publicView = false});
  final bool publicView;
  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.publicView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final pending = ref.read(pendingSalesOfferProvider);
        if (pending != null) {
          ref.read(pendingSalesOfferProvider.notifier).state = null;
          final offer =
              electionOffers.where((item) => item.id == pending).firstOrNull;
          if (offer != null) _choose(offer);
        }
      });
    }
  }

  void _choose(ElectionOffer offer) {
    if (widget.publicView) {
      ref.read(pendingSalesOfferProvider.notifier).state = offer.id;
      context.go('/login');
      return;
    }
    final org =
        ref.read(activeOrganizationContextProvider).valueOrNull?.context;
    final mayUseOrg = org != null &&
        [OrganizationRole.owner, OrganizationRole.admin]
            .contains(org.member.role);
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => SalesInquiryDialog(
            offer: offer,
            organizationId: mayUseOrg ? org.organization.id : null,
            organizationName: mayUseOrg ? org.organization.name : null));
  }

  @override
  Widget build(BuildContext context) {
    final colors = RaayColors.of(context);
    if (!widget.publicView) ref.watch(activeOrganizationContextProvider);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 12, runSpacing: 8, children: [
              TextButton.icon(
                  onPressed: () =>
                      context.go(widget.publicView ? '/' : '/home'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back')),
              if (!widget.publicView)
                TextButton.icon(
                    onPressed: () => context.go('/help/reports'),
                    icon: const Icon(Icons.receipt_long_outlined),
                    label: const Text('My requests')),
            ]),
            const SizedBox(height: 28),
            Text('YOUR ELECTION. A CLEAR START.',
                style: TextStyle(
                    color: colors.accentText,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    fontSize: 12)),
            const SizedBox(height: 12),
            Text('A package for your next decision.',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1)),
            const SizedBox(height: 12),
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 730),
                child: Text(
                    'Start with a guided demo, run a single election, or ask us to help with setup. '
                    'The organizer pays; members do not pay to vote.',
                    style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 16,
                        height: 1.6))),
            const SizedBox(height: 24),
            RaayCard(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Icon(Icons.info_outline, color: colors.accentText),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(
                          'Introductory USD quote prices. Submitting a request is free. '
                          'We confirm scope, availability, payment terms and any applicable taxes before you pay. '
                          'A request does not activate a paid license.',
                          style: TextStyle(
                              color: colors.textSecondary, height: 1.5))),
                ])),
            const SizedBox(height: 28),
            ReflowGrid(
                maxColumns: 3,
                minColumnWidth: 290,
                gap: 18,
                children: electionOffers
                    .map((offer) => _OfferCard(
                        offer: offer,
                        publicView: widget.publicView,
                        onChoose: !kIsWeb && offer.priceCents > 0
                            ? null
                            : () => _choose(offer)))
                    .toList()),
            const SizedBox(height: 32),
            Text('How your request works',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const Text(
                '1. Tell us your voter count and preferred election date.\n'
                '2. Track the request from My requests while our team reviews the scope.\n'
                '3. Confirm a written quote and verified payment before paid access is activated.',
                style: TextStyle(height: 1.8)),
            const SizedBox(height: 24),
            const ExpansionTile(
                title: Text('What does a personal organizer license mean?'),
                children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'The request belongs to your signed-in account. Proposed paid organizer access is for '
                          'the purchaser; organization members can still participate in the election. '
                          'Personal license activation is subject to the confirmed quote.'))
                ]),
            const ExpansionTile(
                title: Text('Are invitations emailed automatically?'),
                children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'Currently, organizers share invitation links or joining codes themselves. '
                          'Automatic email delivery is not included in these packages.'))
                ]),
            const ExpansionTile(
                title: Text('Does the demo include a live election?'),
                children: [
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'The free demo is a mock ballot preview and walkthrough for groups of up to 20. '
                          'It does not submit real votes or create a paid election.'))
                ]),
            if (!widget.publicView &&
                ref
                        .watch(activeOrganizationContextProvider)
                        .valueOrNull
                        ?.context
                        ?.member
                        .role ==
                    OrganizationRole.owner) ...[
              const SizedBox(height: 24),
              TextButton(
                  onPressed: () => context.go('/plans/legacy'),
                  child: const Text(
                      'Manage an existing organization subscription')),
            ],
            const SizedBox(height: 32),
          ]),
        )),
      )),
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard(
      {required this.offer, required this.publicView, required this.onChoose});
  final ElectionOffer offer;
  final bool publicView;
  final VoidCallback? onChoose;
  @override
  Widget build(BuildContext context) {
    final colors = RaayColors.of(context);
    return RaayCard(
        isGlass: offer.featured,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (offer.featured) ...[
            Text('FOR GROWING COMMUNITIES',
                style: TextStyle(
                    color: colors.accentText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
            const SizedBox(height: 10),
          ],
          Text(offer.name,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Text(offer.price,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          Text(offer.priceSuffix,
              style: TextStyle(color: colors.textSecondary)),
          const SizedBox(height: 20),
          for (final feature in offer.features)
            Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 18, color: colors.accentText),
                      const SizedBox(width: 9),
                      Expanded(
                          child: Text(feature,
                              style: const TextStyle(height: 1.4))),
                    ])),
          const Spacer(),
          const SizedBox(height: 16),
          if (!kIsWeb && offer.priceCents > 0)
            const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                    'Paid packages are not available for purchase in this app.')),
          RaayButton(
              label: publicView
                  ? 'Sign in to request'
                  : offer.id == 'demo'
                      ? 'Request free demo'
                      : 'Request ${offer.name}',
              type: offer.featured
                  ? RaayButtonType.primary
                  : RaayButtonType.secondary,
              onPressed: onChoose),
        ]));
  }
}
