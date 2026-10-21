import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";
import { defineSecret, defineString } from "firebase-functions/params";
import { HttpsError, onCall, onRequest } from "firebase-functions/v2/https";
import Stripe from "stripe";
import { requireActiveMembership, requireNotRevoked, requireRecentAuthentication } from "../utils/authorization";

export const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");
export const STRIPE_WEBHOOK_SECRET = defineSecret("STRIPE_WEBHOOK_SECRET");
/** Stripe Price id of the recurring Pro plan. Set in functions/.env (STRIPE_PRICE_PRO=price_...). */
const STRIPE_PRICE_PRO = defineString("STRIPE_PRICE_PRO", { default: "" });

// Fixed return URLs: never accept a redirect target from the client (open-redirect risk).
const APP_ORIGIN = "https://vote-d1ae4.web.app";
const SUCCESS_URL = `${APP_ORIGIN}/#/plans?checkout=success`;
const CANCEL_URL = `${APP_ORIGIN}/#/plans?checkout=cancelled`;

/** Statuses that keep a paid plan active (past_due keeps access during Stripe's retry window). */
const ENTITLED = new Set(["active", "trialing", "past_due"]);

/**
 * Owner starts a Stripe Checkout for the Pro plan. The plan itself is only ever
 * granted by the webhook below - a successful redirect alone proves nothing.
 */
export const createCheckoutSession = onCall({ secrets: [STRIPE_SECRET_KEY] }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication is required.");
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);

  const organizationId = typeof request.data?.organizationId === "string" ? request.data.organizationId.trim() : "";
  if (!organizationId) throw new HttpsError("invalid-argument", "A valid organizationId is required.");
  if (!STRIPE_PRICE_PRO.value()) {
    throw new HttpsError("failed-precondition", "Online upgrades are not available yet.");
  }

  const db = getFirestore();
  await requireActiveMembership(db, organizationId, uid, ["owner"]);

  const orgRef = db.collection("organizations").doc(organizationId);
  const orgSnap = await orgRef.get();
  if (!orgSnap.exists) throw new HttpsError("not-found", "Organization not found.");
  const org = orgSnap.data()!;
  if (org.plan === "pro" && ENTITLED.has(org.planStatus)) {
    throw new HttpsError("already-exists", "This organization is already on the Pro plan.");
  }

  const stripe = new Stripe(STRIPE_SECRET_KEY.value());
  try {
    const session = await stripe.checkout.sessions.create({
      mode: "subscription",
      line_items: [{ price: STRIPE_PRICE_PRO.value(), quantity: 1 }],
      client_reference_id: organizationId,
      ...(org.stripeCustomerId ? { customer: org.stripeCustomerId } : {}),
      subscription_data: { metadata: { organizationId } },
      metadata: { organizationId },
      success_url: SUCCESS_URL,
      cancel_url: CANCEL_URL,
    });
    return { url: session.url };
  } catch (error) {
    console.error("createCheckoutSession failed", { organizationId, error: (error as Error)?.message });
    throw new HttpsError("internal", "Could not start checkout. Please try again.");
  }
});

/** Owner opens the Stripe customer portal to manage or cancel the subscription. */
export const createBillingPortalSession = onCall({ secrets: [STRIPE_SECRET_KEY] }, async (request) => {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Authentication is required.");
  await requireNotRevoked(request);
  requireRecentAuthentication(request.auth);

  const organizationId = typeof request.data?.organizationId === "string" ? request.data.organizationId.trim() : "";
  if (!organizationId) throw new HttpsError("invalid-argument", "A valid organizationId is required.");

  const db = getFirestore();
  await requireActiveMembership(db, organizationId, uid, ["owner"]);
  const org = (await db.collection("organizations").doc(organizationId).get()).data();
  if (!org?.stripeCustomerId) throw new HttpsError("failed-precondition", "No subscription found for this organization.");

  const stripe = new Stripe(STRIPE_SECRET_KEY.value());
  const portal = await stripe.billingPortal.sessions.create({
    customer: org.stripeCustomerId,
    return_url: `${APP_ORIGIN}/#/plans`,
  });
  return { url: portal.url };
});

/**
 * Stripe -> Firestore entitlement sync. Verifies the signature on the raw body,
 * de-duplicates by event id, and is the ONLY writer of organizations.plan*.
 */
export const stripeWebhook = onRequest(
  { secrets: [STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET] },
  async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).send("Method not allowed");
      return;
    }
    const stripe = new Stripe(STRIPE_SECRET_KEY.value());
    let event: Stripe.Event;
    try {
      event = stripe.webhooks.constructEvent(
        req.rawBody,
        req.headers["stripe-signature"] as string,
        STRIPE_WEBHOOK_SECRET.value(),
      );
    } catch {
      res.status(400).send("Invalid signature");
      return;
    }

    const db = getFirestore();
    // create() fails if the doc exists -> Stripe retries/duplicates are ignored.
    try {
      await db.collection("stripeEvents").doc(event.id).create({
        type: event.type,
        receivedAt: FieldValue.serverTimestamp(),
      });
    } catch {
      res.status(200).send("Already processed");
      return;
    }

    try {
      await applyEvent(stripe, event);
      res.status(200).send("ok");
    } catch (error) {
      console.error("stripeWebhook failed", { id: event.id, type: event.type, error: (error as Error)?.message });
      // Allow Stripe to retry: forget the dedupe marker so the retry is processed.
      await db.collection("stripeEvents").doc(event.id).delete().catch(() => undefined);
      res.status(500).send("Processing error");
    }
  },
);

async function applyEvent(stripe: Stripe, event: Stripe.Event): Promise<void> {
  const db = getFirestore();

  if (event.type === "checkout.session.completed") {
    const session = event.data.object as Stripe.Checkout.Session;
    const organizationId = session.client_reference_id ?? session.metadata?.organizationId;
    if (!organizationId || !session.subscription) return;
    const sub = await stripe.subscriptions.retrieve(session.subscription as string);
    await writePlan(db, organizationId, sub, session.customer as string, event.type);
    return;
  }

  if (
    event.type === "customer.subscription.created" ||
    event.type === "customer.subscription.updated" ||
    event.type === "customer.subscription.deleted"
  ) {
    const sub = event.data.object as Stripe.Subscription;
    const organizationId = sub.metadata?.organizationId;
    if (!organizationId) return;
    await writePlan(db, organizationId, sub, sub.customer as string, event.type);
  }
}

async function writePlan(
  db: FirebaseFirestore.Firestore,
  organizationId: string,
  sub: Stripe.Subscription,
  customerId: string,
  trigger: string,
): Promise<void> {
  const loose = sub as unknown as {
    status: string;
    id: string;
    current_period_end?: number;
    items?: { data?: Array<{ current_period_end?: number }> };
  };
  const periodEnd = loose.items?.data?.[0]?.current_period_end ?? loose.current_period_end;
  const entitled = ENTITLED.has(loose.status);

  const orgRef = db.collection("organizations").doc(organizationId);
  if (!(await orgRef.get()).exists) return;

  await orgRef.update({
    plan: entitled ? "pro" : "free",
    planStatus: loose.status,
    planExpiresAt: periodEnd ? Timestamp.fromMillis(periodEnd * 1000) : null,
    stripeCustomerId: customerId,
    stripeSubscriptionId: loose.id,
    updatedAt: FieldValue.serverTimestamp(),
  });
  await db.collection("auditLogs").add({
    organizationId,
    actorUid: "SYSTEM_STRIPE_WEBHOOK",
    action: "PLAN_CHANGED",
    resourceType: "organization",
    resourceId: organizationId,
    details: { plan: entitled ? "pro" : "free", status: loose.status, trigger },
    timestamp: FieldValue.serverTimestamp(),
  });
}
