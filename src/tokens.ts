/** Minimal design tokens — stand-in content so the sandbox package is real. */
export const tokens = {
  color: {
    primary: "#4B44E0",
    ink: "#141527",
    surface: "#FFFFFF",
    success: "#17A867",
  },
  radius: { sm: "6px", md: "11px", pill: "999px" },
} as const;

export type Tokens = typeof tokens;
