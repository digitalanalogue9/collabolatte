# Design Direction Decision

## Design Directions Explored
Six calm directions were explored using Theme A: single-screen match focus, quiet context add-on, MVP programme card, MVP card with post-MVP placeholder, two-panel layout, and minimal join-first entry.

## Chosen Direction
**Direction 1 — Single-Screen Calm** is the core product experience. **Direction 2 — Quiet Context** is a secondary, subdued block that answers “what happens next” without competing with the match. **Direction 6 — Minimal Join-First** is the first-time entry screen only. **Direction 3 — MVP Programme Card** is a secondary status view. **Direction 5** is deferred; **Direction 4** is hidden from MVP UI.

## Design Rationale
- The match notification is the product; Direction 1 keeps it central and low-noise.
- Quiet context reduces anxiety without adding a second goal.
- Entry should be minimal; joined users should see the match surface immediately.
- Programme thinking increases cognitive load; it stays secondary or post-MVP.

## Implementation Approach
- Base layout: Direction 1.
- Add Direction 2’s “What happens next” as a soft, collapsible or secondary block.
- Use Direction 6 for first-time join only.
- Keep Direction 3 as a low-key status view.
- Rename any KPI-like blocks to neutral labels (e.g., “Next match”).
- Keep chips consistent across screens; keep Skip/Later placement stable.
- No iconography yet; text carries the meaning.
