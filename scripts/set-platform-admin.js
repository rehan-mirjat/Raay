#!/usr/bin/env node
// Grants or revokes the `platformAdmin` custom claim for ONE account.
// Run it yourself with project-admin credentials; the app never does this.
//
//   cd functions
//   gcloud auth application-default login          # once, as a project owner
//   node ../scripts/set-platform-admin.js you@example.com grant
//   node ../scripts/set-platform-admin.js you@example.com revoke
//
// Optional: --project vote-d1ae4   (defaults to GOOGLE_CLOUD_PROJECT or vote-d1ae4)
// After granting, sign out and sign back in so the new claim is in your token.

const path = require("path");
const { createRequire } = require("module");
const nm = createRequire(path.join(__dirname, "..", "functions", "package.json"));
const { initializeApp } = nm("firebase-admin/app");
const { getAuth } = nm("firebase-admin/auth");

const args = process.argv.slice(2);
const pi = args.indexOf("--project");
const projectId = pi >= 0 ? args[pi + 1] : (process.env.GOOGLE_CLOUD_PROJECT || "vote-d1ae4");
const [who, action] = args.filter((a, i) => pi < 0 || (i !== pi && i !== pi + 1));

if (!who || !["grant", "revoke"].includes(action)) {
  console.error("Usage: node set-platform-admin.js <email-or-uid> <grant|revoke> [--project <id>]");
  process.exit(2);
}

(async () => {
  initializeApp({ projectId });
  const auth = getAuth();
  const user = who.includes("@") ? await auth.getUserByEmail(who) : await auth.getUser(who);
  const before = user.customClaims || {};
  const next = { ...before };
  if (action === "grant") next.platformAdmin = true; else delete next.platformAdmin;

  await auth.setCustomUserClaims(user.uid, next);
  const after = (await auth.getUser(user.uid)).customClaims || {};
  console.log(`Project: ${projectId}\nAccount: ${user.email} (${user.uid})`);
  console.log(`platformAdmin: ${before.platformAdmin === true} -> ${after.platformAdmin === true}`);
  console.log("Sign out and sign back in for the change to reach your token.");
})().catch((e) => { console.error("Failed:", e.message); process.exit(1); });
