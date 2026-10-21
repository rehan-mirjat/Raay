import '../../organizations/domain/organization.dart';

enum PlanId { free, pro, enterprise }

class PlanInfo {
  const PlanInfo({
    required this.id,
    required this.name,
    required this.priceLabel,
    required this.features,
    required this.showsAds,
  });

  final PlanId id;
  final String name;
  final String priceLabel;
  final List<String> features;
  final bool showsAds;
}

/// Display copy only. The real limits are enforced server-side
/// (functions/src/billing/plans.ts) and must be kept in sync by hand.
const kPlans = <PlanInfo>[
  PlanInfo(
    id: PlanId.free,
    name: 'Free',
    priceLabel: '\$0',
    showsAds: true,
    features: [
      'Up to 50 members',
      '2 live elections at a time',
      'Anonymous & identifiable voting',
      'Vote receipts and verification',
      'Contains ads outside voting screens',
    ],
  ),
  PlanInfo(
    id: PlanId.pro,
    name: 'Pro',
    priceLabel: 'Monthly',
    showsAds: false,
    features: [
      'Up to 1,000 members',
      '25 live elections at a time',
      'CSV export and observers',
      'No ads for your members',
    ],
  ),
  PlanInfo(
    id: PlanId.enterprise,
    name: 'Enterprise',
    priceLabel: 'Contact us',
    showsAds: false,
    features: [
      'Unlimited members and elections',
      'Everything in Pro',
      'Priority support and onboarding',
    ],
  ),
];

/// Mirrors resolvePlanId() on the server.
PlanId effectivePlan(Organization org) {
  final paid = org.plan == 'pro' || org.plan == 'enterprise';
  final entitled = const {'active', 'trialing', 'past_due'}.contains(org.planStatus);
  final notExpired =
      org.planExpiresAt == null || org.planExpiresAt!.isAfter(DateTime.now());
  if (paid && entitled && notExpired) {
    return org.plan == 'enterprise' ? PlanId.enterprise : PlanId.pro;
  }
  return PlanId.free;
}
