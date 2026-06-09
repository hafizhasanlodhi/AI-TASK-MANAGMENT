import "server-only";

import { currentUser } from "@clerk/nextjs/server";
import { eq, or } from "drizzle-orm";

import { db, users } from "@/db";
import { getLiveblocksUserId, normalizeCollaborationEmail } from "@/lib/liveblocks";

export async function syncCurrentUserToDatabase() {
  const user = await currentUser();

  const email = user?.primaryEmailAddress?.emailAddress;
  const clerkId = user?.id;

  if (!email || !clerkId) {
    return null;
  }

  const normalizedEmail = normalizeCollaborationEmail(email);
  const name =
    user.fullName ||
    user.username ||
    normalizedEmail.split("@")[0] ||
    null;

  const liveblocksId = getLiveblocksUserId(normalizedEmail);

  try {
    // Try to find existing user by clerkId or email
    const existingUser = await db.query.users.findFirst({
      where: or(eq(users.clerkId, clerkId), eq(users.email, normalizedEmail)),
    });

    if (existingUser) {
      // Update existing user to ensure all IDs and info are in sync
      const [updatedUser] = await db
        .update(users)
        .set({
          clerkId,
          email: normalizedEmail,
          liveblocksId,
          name,
        })
        .where(eq(users.id, existingUser.id))
        .returning();
      
      return updatedUser;
    }

    // Insert new user if not found
    const [newUser] = await db
      .insert(users)
      .values({
        clerkId,
        email: normalizedEmail,
        liveblocksId,
        name,
      })
      .returning();

    return newUser;
  } catch (err) {
    console.error("Critical error in syncCurrentUserToDatabase:", err);
    return null;
  }
}
