import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { requireActiveMembership } from "../utils/authorization";

export const getOrganizationMembers = onCall(async (request) => {
  if (!request.auth || !request.auth.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }

  const uid = request.auth.uid;
  const { organizationId, pageSize = 50, pageToken } = request.data || {};

  if (!organizationId || typeof organizationId !== "string" || organizationId.trim().length === 0) {
    throw new HttpsError("invalid-argument", "Valid organizationId is required.");
  }

  const cleanOrganizationId = organizationId.trim();
  const limit = Math.min(Math.max(Number(pageSize) || 50, 1), 100);
  const db = getFirestore();

  // 1. Verify caller is an active member
  await requireActiveMembership(db, cleanOrganizationId, uid, ["owner", "admin"]);

  // 2. Fetch Paginated Members
  let membersQuery = db.collection("organizationMembers")
    .where("organizationId", "==", cleanOrganizationId)
    .orderBy("joinedAt", "desc")
    .limit(limit);

  if (pageToken && typeof pageToken === "string") {
    // Basic pagination using doc ID as cursor for simplicity in this implementation
    const cursorDoc = await db.collection("organizationMembers").doc(pageToken).get();
    if (cursorDoc.exists) {
      membersQuery = membersQuery.startAfter(cursorDoc);
    }
  }

  const membersSnap = await membersQuery.get();

  // 3. Resolve & Sanitize Users and Departments (batched, not one round-trip per member)
  const directory: any[] = [];
  let nextToken = null;

  if (!membersSnap.empty) {
    nextToken = membersSnap.docs[membersSnap.docs.length - 1].id;

    const memberRows = membersSnap.docs.map((doc) => doc.data());
    const userIds = [...new Set(memberRows.map((m) => m.userId as string).filter(Boolean))];
    const deptIds = [...new Set(memberRows.map((m) => m.departmentId as string).filter(Boolean))];

    const [userSnaps, deptSnaps] = await Promise.all([
      userIds.length
        ? db.getAll(...userIds.map((id) => db.collection("users").doc(id)))
        : Promise.resolve([]),
      deptIds.length
        ? db.getAll(...deptIds.map((id) => db.collection("departments").doc(id)))
        : Promise.resolve([]),
    ]);

    const usersById = new Map(userSnaps.map((snap) => [snap.id, snap.exists ? snap.data()! : null]));
    const deptsById = new Map(deptSnaps.map((snap) => [snap.id, snap.exists ? snap.data()! : null]));

    for (const memberData of memberRows) {
      const targetUserId = memberData.userId;
      const deptId = memberData.departmentId;

      const uData = usersById.get(targetUserId);
      const firstName = uData?.firstName || "Unknown";
      const lastName = uData?.lastName || "User";
      const email = uData?.email || "";
      const photoUrl = uData?.photoUrl || null;

      let departmentName = null;
      if (deptId) {
        const dData = deptsById.get(deptId);
        if (dData && dData.organizationId === cleanOrganizationId) {
          departmentName = dData.name;
        }
      }

      directory.push({
        userId: targetUserId,
        firstName: firstName,
        lastName: lastName,
        displayName: `${firstName} ${lastName}`.trim(),
        email: email,
        photoUrl: photoUrl,
        role: memberData.role || "member",
        status: memberData.status || "inactive",
        departmentId: deptId || null,
        departmentName: departmentName,
        joinedAt: memberData.joinedAt ? memberData.joinedAt.toDate().toISOString() : null,
      });
    }
  }

  return {
    status: "success",
    members: directory,
    nextPageToken: membersSnap.docs.length === limit ? nextToken : null,
  };
});
