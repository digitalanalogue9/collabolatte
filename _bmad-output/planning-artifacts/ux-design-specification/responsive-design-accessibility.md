# Responsive Design & Accessibility

## Responsive Strategy
- Desktop-first build; mobile-safe by design for the core loop.
- Desktop is the primary working surface; mobile is a first-class consumption surface for match notifications.
- Mobile: single-column layouts; no two-panel layouts below tablet.
- Primary CTA visible without scrolling where possible.
- Secondary content collapsible on mobile (e.g., “What happens next”).
- Enforce copy length/truncation rules to preserve CTA visibility on small screens.

## Breakpoint Strategy
- **360px** small mobile (minimum supported)
- **768px** tablet
- **1024px** small laptop
- **1280px** desktop

## Accessibility Strategy
- WCAG 2.1 AA.
- Sufficient contrast without brightening the UI.
- Clear `:focus-visible` states.
- Keyboard-first navigation across all screens.
- No colour-only meaning; text carries semantics.
- Plain English, short sentences, no idioms.

## Testing Strategy
**Automated**
- Playwright for E2E journeys and trust-critical flows (join, match view, skip).
- Playwright MCP to replay key journeys and guard tone/interaction.
- Axe-core (or equivalent) integrated in Playwright for accessibility checks.
- Explicit 360px viewport tests for CTA visibility and spacing.
- Avoid brittle visual diffs unless they add clear value.

**Manual**
- Keyboard-only walkthroughs of critical journeys.
- Screen reader spot-checks on join and match screens.
- Visual contrast checks for primary surfaces and actions.

**Mobile Testing**
- Playwright at mobile viewport for join, match view, act/skip flow, and “what we store” page.

## Implementation Guidelines
- Respect reduced-motion preferences.
- Ensure comfortable touch targets and spacing between primary/secondary actions.
- Keep match-link screen calm, readable, and low-effort.
- Keep assets and bundles lightweight for managed corporate environments.
- Tests assert behaviour and intent; flaky tests are fixed or removed.

