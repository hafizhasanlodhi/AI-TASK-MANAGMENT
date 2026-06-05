// "use client";

// import { createContext, useContext, useEffect, useState } from "react";

// type Theme = "light" | "dark" | "system";

// interface ThemeContextType {
//   theme: Theme;
//   setTheme: (theme: Theme) => void;
// }

// const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

// export function ThemeProvider({
//   children,
//   initialTheme = "system",
// }: {
//   children: React.ReactNode;
//   initialTheme?: string;
// }) {
//   const [theme, setThemeState] = useState<Theme>(initialTheme as Theme);

//   const applyTheme = (targetTheme: Theme) => {
//     const root = window.document.documentElement;
//     root.classList.remove("light", "dark");

//     if (targetTheme === "system") {
//       const systemTheme = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
//       root.classList.add(systemTheme);
//     } else {
//       root.classList.add(targetTheme);
//     }
//   };

//   const setTheme = (newTheme: Theme) => {
//     setThemeState(newTheme);
//     applyTheme(newTheme);
//   };

//   useEffect(() => {
//     applyTheme(theme);

//     if (theme === "system") {
//       const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
//       const handleChange = () => applyTheme("system");
//       mediaQuery.addEventListener("change", handleChange);
//       return () => mediaQuery.removeEventListener("change", handleChange);
//     }
//   }, [theme]);

//   return (
//     <ThemeContext.Provider value={{ theme, setTheme }}>
//       {children}
//     </ThemeContext.Provider>
//   );
// }

// export function useTheme() {
//   const context = useContext(ThemeContext);
//   if (context === undefined) {
//     throw new Error("useTheme must be used within a ThemeProvider");
//   }
//   return context;
// }
"use client";

import { createContext, useContext, useEffect, useState } from "react";

type Theme = "light" | "dark" | "system";

interface ThemeContextType {
  theme: Theme;
  setTheme: (theme: Theme) => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({
  children,
  initialTheme = "light", // 1. Default backup ko "light" kiya
}: {
  children: React.ReactNode;
  initialTheme?: string;
}) {
  // 2. Initial state ko directly "light" assign kiya taake pehli dafa light hi load ho
  const [theme, setThemeState] = useState<Theme>("light");

  const applyTheme = (targetTheme: Theme) => {
    if (typeof window === "undefined") return; // Next.js SSR safe check
    const root = window.document.documentElement;
    root.classList.remove("light", "dark");

    if (targetTheme === "system") {
      const systemTheme = window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
      root.classList.add(systemTheme);
    } else {
      root.classList.add(targetTheme);
    }
  };

  const setTheme = (newTheme: Theme) => {
    setThemeState(newTheme);
    applyTheme(newTheme);
  };

  useEffect(() => {
    applyTheme(theme);

    if (theme === "system") {
      const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
      const handleChange = () => applyTheme("system");
      mediaQuery.addEventListener("change", handleChange);
      return () => mediaQuery.removeEventListener("change", handleChange);
    }
  }, [theme]);

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error("useTheme must be used within a ThemeProvider");
  }
  return context;
}