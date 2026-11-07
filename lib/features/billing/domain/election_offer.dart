/// Quote catalogue only. Payment and license activation are separate operations.
class ElectionOffer {
  const ElectionOffer(this.id, this.name, this.priceCents, this.priceSuffix,
      this.maxVoters, this.features,
      {this.featured = false});
  final String id, name, priceSuffix;
  final int priceCents, maxVoters;
  final List<String> features;
  final bool featured;
  String get price => priceCents == 0 ? 'Free' : '\$${priceCents ~/ 100}';
}

const electionOffers = [
  ElectionOffer('demo', 'Demo', 0, 'Mock demonstration', 20, [
    'For groups of up to 20',
    'Guided mock ballot preview',
    'No real votes or live election'
  ]),
  ElectionOffer('starter', 'Starter', 1500, 'USD / election', 100, [
    '1 election · up to 100 eligible voters',
    'Candidates or a poll',
    'Vote receipts and published results'
  ]),
  ElectionOffer(
      'standard',
      'Standard',
      3900,
      'USD / election',
      500,
      [
        '1 election · up to 500 eligible voters',
        'Anonymous or identifiable voting',
        'Organizer setup guidance'
      ],
      featured: true),
  ElectionOffer('assisted', 'Assisted', 9900, 'USD starting price', 5000, [
    'Election setup and ballot review',
    'Organizer training',
    'Election-day support agreed in your quote'
  ]),
  ElectionOffer('annual', 'Annual organizer', 12900, 'USD / year', 500, [
    '4 elections over 12 months',
    'Up to 500 eligible voters per election',
    'Scope and activation confirmed before payment'
  ]),
];
