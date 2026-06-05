import { ClerkProvider } from '@clerk/nextjs';
import "@liveblocks/react-ui/styles.css";
import "./globals.css";
import type { Metadata } from "next";
import { LiveblocksAppProvider } from "@/components/liveblocks-app-provider";
import { WorkspaceShell } from "@/components/workspace-shell";
import { ThemeProvider } from "@/components/theme-provider";
import { getUserTheme } from "@/lib/user-preferences";

export const metadata: Metadata = {
  title: "AI Productivity Workspace",
  description:
    "An AI-powered productivity workspace for notes, tasks, whiteboards, calendars, templates, and real-time team collaboration.",
};

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const initialTheme = await getUserTheme();

  return (
    <ClerkProvider>
      <html lang="en" suppressHydrationWarning>
        <body style={{ margin: 0, padding: 0 }}>
          <ThemeProvider initialTheme={initialTheme}>
            <LiveblocksAppProvider>
              <WorkspaceShell>{children}</WorkspaceShell>
            </LiveblocksAppProvider>
          </ThemeProvider>
        </body>
      </html>
    </ClerkProvider>
  );
}
