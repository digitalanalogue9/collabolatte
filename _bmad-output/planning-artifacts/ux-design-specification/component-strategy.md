# Component Strategy

## Design System Components
**Selected system:** MUI (Material UI)

Use default MUI components with minimal styling (spacing, borders, typography). No bespoke component library for MVP.

**Primary components:**
- Match notification: `Card` + `CardContent` + `CardActions`
- Chips: `Chip` (outlined or subtle filled variant)
- “What happens next” block: `Paper` with heading, or neutral `Alert`
- Join screen panel: `Paper` or `Card`
- Next match info: `Typography` + `Divider` inside `Paper`

## Custom Components
None required for MVP. Optional tiny wrappers only if reused more than once:
- Consistent card spacing wrapper
- Consistent chip group layout

## Component Implementation Strategy
- Theme MUI fully (typography scale, border radius, spacing, Sage Calm palette).
- Keep layout minimal: one dominant card, generous whitespace, no navigation in MVP.
- Use microcopy as the differentiator; avoid enterprise jargon.
- Do not override MUI into a new system; restraint is the product.

## Implementation Roadmap
**Phase 1 — Core:** Match card, join panel, chips, next-match block, neutral context block.
**Phase 2 — Supporting:** Optional wrappers for spacing/consistency if reused.
**Phase 3 — Post‑MVP:** Programme list card patterns (invitation‑first, no metrics).

## Accessibility & Interaction Rules
- Visible `:focus-visible` on all interactive elements; no hover-only affordances.
- No colour-only signalling; text must carry meaning.
- Explicit verb labels on buttons.
- Respect reduced-motion; no animation-dependent meaning.
- Avoid disabled-as-default; hide or explain unavailable actions.

## Uniqueness Without Custom Components
- Unique tone through copy, spacing, and restraint.
- Signature patterns: match card layout, calm “what happens next” block, consistent optional action styling.
- Minimal illustration usage (sparingly, one per screen max).
