# Visual Design Foundation

## Color System

- **Base background:** #f6f5f2 (warm neutral)
- **Surface:** #ffffff
- **Borders:** #e6e4df (soft, consistent)
- **Primary text:** #1f2428
- **Secondary text:** #4f5b61
- **Muted surface:** #f0ede7
- **Chip background:** #f5f2ed
- **Primary accent (actions):** #3a7f6c
- **Accent border:** #5d9a89
- **Secondary action accent:** #6a9486
- **Focus outline:** #7ea99a

**Semantics:**

- Primary action uses sage accent; secondary actions use muted sage.
- Avoid urgency colours or celebratory states.
- Default to neutral, low-attention surfaces.

## Typography System

- **Base size:** 14px (minimum) with 1.6 line height.
- **Body weight:** regular; avoid light weights for readability.
- **Headings:** understated scale, small jumps in size to keep hierarchy calm.
- **Tone:** plain, quiet, and predictable.

## Spacing & Layout Foundation

- **Layout feel:** airy, low-density, easy to scan.
- **Spacing unit:** 8px base rhythm (multiples for consistency).
- **Component spacing:** generous padding to reduce cognitive load.
- **Depth:** minimal; avoid heavy shadows and layered effects.

## Accessibility Considerations

- WCAG 2.1 AA contrast for body/secondary text, buttons, and key UI surfaces.
- Focus states visible via outline + offset; no colour-only indicators.
- Click targets large enough for imperfect motor control.
- No essential meaning conveyed by animation; respect reduced-motion preferences.
- Plain English microcopy; consistent cues: optional, no obligation, easy to skip.

## Implementation Notes

- Keep tokens stable to minimise engineering churn.
- Avoid CSS overrides that fight the design system defaults.
- Maintain a single visual “voice”; no hero treatments or attention-seeking components.
