# Story 1.3: Create Core Web App UI Components

Status: done

## Story

As a delivery team, I want to create the foundational UI components for the web app, So that Epic 2
feature development can proceed with reusable, tested components.

## Acceptance Criteria

1. **Given** Storybook is set up (Story 1.2), **When** we create the core layout components,
   **Then** the following components exist with Storybook stories:
   - `AppHeader` — Minimal header with logo, user name/avatar, settings menu
   - `AppFooter` — Simple footer with Privacy, Terms, Support links
   - `AppLayout` — Wrapper component that centers content with generous whitespace
   - `Logo` — Shared brand logo component

2. **Given** Storybook is set up, **When** we create the core content components, **Then** the
   following components exist with Storybook stories:
   - `MatchCard` ✅ (already created)
   - `JoinCard` — First-time entry screen (Direction 6)
   - `ContextInfoBlock` — "What happens next" subdued block (Direction 2)
   - `ProgrammeStatusCard` — Programme status view (Direction 3)
   - `EmptyState` — When no matches available

3. **Given** these components exist, **When** we review the implementation, **Then** each component:
   - Has a Storybook story demonstrating all variants
   - Uses the Sage Calm theme from `packages/theme`
   - Follows the UX specification (minimal, calm, low-pressure)
   - Has TypeScript props interfaces
   - Includes accessibility considerations (ARIA labels, focus management)

4. **Given** components follow UX patterns, **When** we review against the specification, **Then**
   copy uses trust language ("optional", "no tracking") **And** button hierarchy is clear (one
   primary action per screen) **And** secondary actions are always visible and safe **And** spacing
   is generous (airy, low-density)

## Tasks / Subtasks

- [x] Task 1: Create MatchCard component (AC: 2)
  - [x] Create `apps/web/src/components/MatchCard.tsx`
  - [x] Create `apps/web/src/components/MatchCard.stories.tsx`
  - [x] Implement all variants (matched, pending, no-match)
  - [x] Verify in Storybook

- [x] Task 2: Create AppLayout component (AC: 1)
  - [x] Create `apps/web/src/components/AppLayout.tsx`
  - [x] Create `apps/web/src/components/AppLayout.stories.tsx`
  - [x] Implement centered layout with generous whitespace
  - [x] Verify in Storybook

- [x] Task 3: Create Logo component (AC: 1)
  - [x] Create `apps/web/src/components/Logo.tsx`
  - [x] Create `apps/web/src/components/Logo.stories.tsx`
  - [x] Implement brand logo (text-based or SVG)
  - [x] Verify in Storybook

- [x] Task 4: Create AppHeader component (AC: 1)
  - [x] Create `apps/web/src/components/AppHeader.tsx`
  - [x] Create `apps/web/src/components/AppHeader.stories.tsx`
  - [x] Include Logo, user name/avatar, settings menu
  - [x] Verify in Storybook

- [x] Task 5: Create AppFooter component (AC: 1)
  - [x] Create `apps/web/src/components/AppFooter.tsx`
  - [x] Create `apps/web/src/components/AppFooter.stories.tsx`
  - [x] Include Privacy, Terms, Support links
  - [x] Verify in Storybook

- [x] Task 6: Create JoinCard component (AC: 2)
  - [x] Create `apps/web/src/components/JoinCard.tsx`
  - [x] Create `apps/web/src/components/JoinCard.stories.tsx`
  - [x] Implement Direction 6 (Minimal Join-First)
  - [x] Use trust language in copy
  - [x] Verify in Storybook

- [x] Task 7: Create ContextInfoBlock component (AC: 2)
  - [x] Create `apps/web/src/components/ContextInfoBlock.tsx`
  - [x] Create `apps/web/src/components/ContextInfoBlock.stories.tsx`
  - [x] Implement Direction 2 (Quiet Context)
  - [x] Style as subdued/secondary information
  - [x] Verify in Storybook

- [x] Task 8: Create ProgrammeStatusCard component (AC: 2)
  - [x] Create `apps/web/src/components/ProgrammeStatusCard.tsx`
  - [x] Create `apps/web/src/components/ProgrammeStatusCard.stories.tsx`
  - [x] Implement Direction 3 (MVP Programme Card)
  - [x] Show participation status clearly
  - [x] Verify in Storybook

- [x] Task 9: Create EmptyState component (AC: 2)
  - [x] Create `apps/web/src/components/EmptyState.tsx`
  - [x] Create `apps/web/src/components/EmptyState.stories.tsx`
  - [x] Implement calm messaging for empty states
  - [x] Include appropriate icon/illustration
  - [x] Verify in Storybook

- [x] Task 10: Update component documentation (AC: 3, 4)
  - [x] Update `apps/web/README.md` with component usage
  - [x] Document component props and variants
  - [x] Document accessibility considerations
  - [x] Document UX patterns implemented

## Dev Notes

### Story Context

This story creates the complete component library needed for Epic 2 (Join & Trust) feature
development. All components follow the **Sage Calm** design direction: minimal, trust-first,
low-pressure.

### Critical UX Constraints

**From UX Design Specification:**

#### Design Direction: Sage Calm

**Visual Language:**

- **Airy, low-density layouts** with generous whitespace
- **Minimal visual hierarchy** - one primary action per screen
- **Subdued colour palette** - sage greens, soft greys, warm neutrals
- **Trust-first language** - "optional", "you can leave anytime", "no tracking"

#### Key Component Patterns

**Direction 2: Quiet Context**

- Information presented in subdued blocks (ContextInfoBlock)
- Never interrupts or demands attention
- User reads when ready

**Direction 3: MVP Programme Card**

- Shows participation status clearly
- Emphasises opt-out visibility
- No metrics, no pressure

**Direction 6: Minimal Join-First**

- Single prominent action: "Join"
- Minimal explanation required
- Trust signals visible but not overwhelming

### Component Strategy

**Prefer MUI components** themed to match Sage Calm:

- Use `Card`, `Button`, `Typography` from MUI
- Theme via `packages/theme/muiTheme.ts`
- Only create custom components when MUI doesn't fit

**All components must:**

- Work in isolation (Storybook) and in app context
- Have clear TypeScript interfaces
- Include accessibility attributes (ARIA labels, keyboard navigation)
- Follow trust-first language patterns

### Technology Versions

| Technology | Version | Notes                |
| ---------- | ------- | -------------------- |
| React      | 18.x    | Via Vite template    |
| TypeScript | 5.x     | Strict mode enabled  |
| MUI        | 6.x     | Material UI v6       |
| Emotion    | 11.x    | CSS-in-JS for MUI    |
| Storybook  | 8.6.x   | React Vite framework |

### Dependencies on Previous Stories

This story depends on:

- **Story 1.1** - Project scaffolding must exist
- **Story 1.2** - Storybook must be configured and working
- Theme package (`packages/theme`) must be built and accessible

### Testing Notes

**Storybook Testing:**

- Each component has a `.stories.tsx` file
- Stories demonstrate all variants (e.g., matched/pending/empty states)
- Use Storybook controls for interactive testing
- Verify accessibility with a11y addon

**Component Isolation:**

- Components should not depend on app routing or auth
- Use mock data for Storybook stories
- Props should be clearly typed and documented

### Trust & Privacy Considerations

**Language Patterns:**

- ✅ "You can leave anytime"
- ✅ "Participation is optional"
- ✅ "We don't track your behaviour"
- ❌ Avoid: "Must", "Required", "Mandatory"
- ❌ Avoid: Activity metrics, participation scores

**Visual Design:**

- Opt-out actions must be as visible as opt-in
- No dark patterns or hidden controls
- Clear, honest communication about what happens

### Definition of Done

- [x] MatchCard component created with stories
- [x] AppLayout component created with stories
- [x] Logo component created with stories
- [x] AppHeader component created with stories
- [x] AppFooter component created with stories
- [x] JoinCard component created with stories
- [x] ContextInfoBlock component created with stories
- [x] ProgrammeStatusCard component created with stories
- [x] EmptyState component created with stories
- [x] All stories render correctly in Storybook
- [x] All components use Sage Calm theme consistently
- [x] TypeScript types properly defined for all components
- [x] Accessibility attributes included (ARIA, keyboard nav)
- [x] Component documentation updated in README
- [x] Trust-first language verified in all copy

## Dev Agent Record

### Agent Model Used

(To be filled during implementation)

### Debug Log References

(To be filled during implementation)

### Completion Notes List

- MatchCard component created with three variants (matched, pending, no-match)
- MatchCard includes timestamp, match name, and Teams meeting link
- MatchCard demonstrates MUI theme integration
- (Additional notes to be added as work progresses)

### Change Log

| Date       | Change                                                        |
| ---------- | ------------------------------------------------------------- |
| 2026-01-16 | Created implementation artifact for Story 1.3                 |
| 2026-01-16 | All 9 components completed with Storybook stories             |
| 2026-01-16 | Component documentation added to apps/web/README.md (Task 10) |

### File List

**Component Files:**
- `apps/web/src/components/MatchCard.tsx`
- `apps/web/src/components/AppLayout.tsx`
- `apps/web/src/components/Logo.tsx`
- `apps/web/src/components/AppHeader.tsx`
- `apps/web/src/components/AppFooter.tsx`
- `apps/web/src/components/JoinCard.tsx`
- `apps/web/src/components/ContextInfoBlock.tsx`
- `apps/web/src/components/ProgrammeStatusCard.tsx`
- `apps/web/src/components/EmptyState.tsx`

**Story Files:**
- `apps/web/src/components/MatchCard.stories.tsx`
- `apps/web/src/components/AppLayout.stories.tsx`
- `apps/web/src/components/Logo.stories.tsx`
- `apps/web/src/components/AppHeader.stories.tsx`
- `apps/web/src/components/AppFooter.stories.tsx`
- `apps/web/src/components/JoinCard.stories.tsx`
- `apps/web/src/components/ContextInfoBlock.stories.tsx`
- `apps/web/src/components/ProgrammeStatusCard.stories.tsx`
- `apps/web/src/components/EmptyState.stories.tsx`

**Documentation:**
- `apps/web/README.md` (updated with component documentation)
