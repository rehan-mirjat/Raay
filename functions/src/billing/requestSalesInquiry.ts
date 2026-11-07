import { createHash } from 'node:crypto';
import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { FieldValue, getFirestore } from 'firebase-admin/firestore';
import { requireActiveMembership, requireNotRevoked } from '../utils/authorization';
import { checkRateLimit } from '../utils/rateLimiter';
import { sanitizePlainText } from '../utils/sanitize';
import { SALES_PACKAGES, SalesPackageId } from './salesCatalog';

export function parseSalesInquiry(data: Record<string, unknown>, now = Date.now()) {
  const allowed = ['requestId', 'packageId', 'organizationId', 'organizationName', 'estimatedVoters', 'electionDate', 'notes'];
  if (Object.keys(data).some(key => !allowed.includes(key))) {
    throw new HttpsError('invalid-argument', 'Unexpected inquiry fields.');
  }
  if (typeof data.requestId !== 'string' || !/^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$/i.test(data.requestId)) {
    throw new HttpsError('invalid-argument', 'A valid request ID is required.');
  }
  if (typeof data.packageId !== 'string' || !Object.prototype.hasOwnProperty.call(SALES_PACKAGES, data.packageId)) {
    throw new HttpsError('invalid-argument', 'Choose a valid package.');
  }
  const packageId = data.packageId as SalesPackageId;
  const offer = SALES_PACKAGES[packageId];
  const voters = data.estimatedVoters;
  if (typeof voters !== 'number' || !Number.isInteger(voters) || voters < 1 || voters > offer.maxVoters) {
    throw new HttpsError('invalid-argument', `This package supports 1–${offer.maxVoters} eligible voters. Choose Assisted for larger requirements.`);
  }
  const text = (key: string, max: number, required = false) => {
    const value = data[key];
    if (value === undefined && !required) return '';
    if (typeof value !== 'string') throw new HttpsError('invalid-argument', `Invalid ${key}.`);
    const cleaned = sanitizePlainText(value, { multiline: key === 'notes' });
    if (cleaned.length > max || (required && cleaned.length < 2)) throw new HttpsError('invalid-argument', `Check ${key}.`);
    return cleaned;
  };
  const organizationId = text('organizationId', 128);
  if (organizationId && !/^[A-Za-z0-9_-]+$/.test(organizationId)) throw new HttpsError('invalid-argument', 'Invalid organization.');
  const organizationName = text('organizationName', 100, true);
  const notes = text('notes', 2000);
  const electionDate = text('electionDate', 10);
  if (electionDate) {
    const date = Date.parse(`${electionDate}T00:00:00Z`);
    const clock = new Date(now);
    const utcDay = Date.UTC(clock.getUTCFullYear(), clock.getUTCMonth(), clock.getUTCDate());
    if (!/^\d{4}-\d{2}-\d{2}$/.test(electionDate) || !Number.isFinite(date) ||
        new Date(date).toISOString().slice(0, 10) !== electionDate ||
        date < utcDay - 24 * 60 * 60 * 1000 || date > now + 2 * 366 * 24 * 60 * 60 * 1000) {
      throw new HttpsError('invalid-argument', 'Choose an upcoming election date within two years.');
    }
  }
  return { requestId: data.requestId.toLowerCase(), packageId, offer, voters, organizationId, organizationName, notes, electionDate };
}

/** Authenticated lead intake, visible in the existing platform Reports workflow. */
export const requestSalesInquiry = onCall(async request => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError('unauthenticated', 'Sign in to request a package.');
  await requireNotRevoked(request);
  const email = request.auth?.token.email;
  if (request.auth?.token.email_verified !== true || typeof email !== 'string' || !email) {
    throw new HttpsError('failed-precondition', 'Verify your account email before requesting a package.');
  }
  const input = parseSalesInquiry(request.data || {});
  const db = getFirestore();
  if (input.organizationId) {
    await requireActiveMembership(db, input.organizationId, uid, ['owner', 'admin']);
  }
  const reportId = `sales_${uid}_${input.requestId}`;
  const ref = db.collection('userReports').doc(reportId);
  const fingerprint = createHash('sha256').update(JSON.stringify({ packageId: input.packageId, organizationId: input.organizationId, organizationName: input.organizationName, voters: input.voters, electionDate: input.electionDate, notes: input.notes })).digest('hex');
  const confirmDuplicate = (saved: FirebaseFirestore.DocumentData | undefined) => {
    if (saved?.userId !== uid || saved?.salesRequestFingerprint !== fingerprint) {
      throw new HttpsError('already-exists', 'This request reference is already used. View My requests before submitting changed details.');
    }
  };
  const existing = await ref.get();
  if (existing.exists) { confirmDuplicate(existing.data()); return { status: 'success', reportId }; }
  await checkRateLimit(uid, { keyPrefix: 'sales_inquiry', maxRequests: 5, windowMs: 24 * 60 * 60 * 1000 });
  const price = input.offer.priceCents === 0 ? 'Free mock demonstration' :
    `USD ${(input.offer.priceCents / 100).toFixed(2)}${input.offer.assisted ? ' starting quote' : input.packageId === 'annual' ? ' per year' : ' per election'}`;
  const message = [
    `Package: ${input.offer.name}`, `Introductory price: ${price}`,
    `Organization: ${input.organizationName}`, `Organization ID: ${input.organizationId || 'Prospective organization'}`,
    `Estimated eligible voters: ${input.voters}`, `Preferred election date: ${input.electionDate || 'Not decided'}`,
    `Scope: ${input.packageId === 'demo' ? 'Mock ballot preview only; no real voting' : `${input.offer.elections} election(s), up to ${input.offer.maxVoters} eligible voters per election`}`,
    `Notes: ${input.notes || 'None'}`, 'Inquiry only: no payment collected, license granted, or election quota changed.',
  ].join('\n');
  try {
    await ref.create({ userId: uid, userEmail: email, category: 'Sales enquiry',
      subject: `${input.offer.name} package request`, message, status: 'open',
      createdAt: FieldValue.serverTimestamp(), salesRequestFingerprint: fingerprint,
      salesDetails: { packageId: input.packageId, priceCents: input.offer.priceCents, currency: 'USD',
        estimatedVoters: input.voters, organizationId: input.organizationId || null,
        electionDate: input.electionDate || null, personalLicenseRequested: true },
    });
  } catch (error) {
    if ((error as { code?: number | string }).code !== 6 && (error as { code?: string }).code !== 'already-exists') throw error;
    confirmDuplicate((await ref.get()).data());
  }
  return { status: 'success', reportId };
});
