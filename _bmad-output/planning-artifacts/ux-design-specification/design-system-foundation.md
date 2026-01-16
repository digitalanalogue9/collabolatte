# Design System Foundation

## 1.1 Design System Choice
Adopt a themeable component system with strong defaults (MUI, Chakra, or Tailwind UI). Prioritise speed, accessibility, and restraint over visual expression.

## Rationale for Selection
- The product should disappear; visual uniqueness is not a success metric.
- Themeable systems provide a trustworthy baseline with minimal overhead.
- Fully custom systems invite bikeshedding and slow delivery.
- Heavy established systems (Material/Ant) are too opinionated and “app-like” for a low-key utility.
- Risk to manage: over-customising a themeable system until it behaves like a custom system.

## Implementation Approach
- Use stock components as-is; avoid “designing around” the system.
- Prefer layout and copy to express calmness over visual embellishment.
- No bespoke components unless reused in at least two distinct flows.

## Customization Strategy
- Minimal theming only: colour, spacing, typography.
- No custom variants unless a repeated UX pattern demands it.
- Keep a neutral internal-tool aesthetic (quiet, predictable, low-attention).

## Guardrails (to prevent drift)
- If a component draws attention to itself, it’s probably wrong.
- If a theme change requires custom CSS overrides, it’s likely too far.
- If a new component is single-use, don’t build it.
