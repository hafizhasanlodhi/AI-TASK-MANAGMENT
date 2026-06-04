import { and, eq } from "drizzle-orm";

import { db, kanbanBoardShares, kanbanBoards } from "@/db";
import {
  createLiveblocksClient,
  getAvatarColor,
  getInitials,
} from "@/lib/liveblocks";
import { syncCurrentUserToDatabase } from "@/lib/sync-user";

function parseKanbanRoomId(room?: string) {
  const match = room?.match(/^kanban-board:(\d+)$/);
  return match ? Number(match[1]) : null;
}

export async function POST(request: Request) {
  const { room } = (await request.json().catch(() => ({}))) as { room?: string };
  const boardId = parseKanbanRoomId(room);

  if (!room || !boardId) {
    return new Response("Invalid Liveblocks room.", { status: 400 });
  }

  const databaseUser = await syncCurrentUserToDatabase();

  if (!databaseUser) {
    return new Response("Unauthorized", { status: 401 });
  }

  const { id: userId, email: normalizedEmail, liveblocksId, name } = databaseUser;

  await db
    .update(kanbanBoardShares)
    .set({ acceptedUserId: userId, updatedAt: new Date() })
    .where(and(eq(kanbanBoardShares.email, normalizedEmail), eq(kanbanBoardShares.role, "editor")));

  const ownedBoard = await db.query.kanbanBoards.findFirst({
    where: and(eq(kanbanBoards.id, boardId), eq(kanbanBoards.userId, userId)),
  });
  const sharedBoard = ownedBoard
    ? null
    : await db.query.kanbanBoardShares.findFirst({
        where: and(eq(kanbanBoardShares.boardId, boardId), eq(kanbanBoardShares.email, normalizedEmail), eq(kanbanBoardShares.role, "editor")),
      });

  if (!ownedBoard && !sharedBoard) {
    return new Response("Forbidden", { status: 403 });
  }

  const session = createLiveblocksClient().prepareSession(liveblocksId, {
    userInfo: {
      name: name ?? normalizedEmail,
      email: normalizedEmail,
      color: getAvatarColor(normalizedEmail),
      initials: getInitials(name ?? normalizedEmail),
    },
  });

  session.allow(room, session.FULL_ACCESS);
  const response = await session.authorize();

  return new Response(response.body, { status: response.status });
}
