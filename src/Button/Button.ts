import { tokens } from "../tokens";

export interface ButtonOptions {
  label: string;
  variant?: "primary" | "ghost";
}

/** Placeholder component. Returns a class list — enough to make releases meaningful. */
export function buttonClass({ variant = "primary" }: ButtonOptions): string {
  return `ds-btn ds-btn--${variant}`;
}

export const BUTTON_COLORS = tokens.color;
