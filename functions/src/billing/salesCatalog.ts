/** Introductory quote catalogue. No request or redirect grants paid access. */
export const SALES_PACKAGES = {
  demo: { name: 'Demo', priceCents: 0, maxVoters: 20, elections: 0, assisted: false },
  starter: { name: 'Starter', priceCents: 1500, maxVoters: 100, elections: 1, assisted: false },
  standard: { name: 'Standard', priceCents: 3900, maxVoters: 500, elections: 1, assisted: false },
  assisted: { name: 'Assisted', priceCents: 9900, maxVoters: 5000, elections: 1, assisted: true },
  annual: { name: 'Annual organizer', priceCents: 12900, maxVoters: 500, elections: 4, assisted: false },
} as const;
export type SalesPackageId = keyof typeof SALES_PACKAGES;
