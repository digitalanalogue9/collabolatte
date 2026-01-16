# Story 1.2: Set Up Storybook for Component Development

Status: done

## Story

As a delivery team, I want to set up Storybook for the web app, So that components can be developed,
documented, and tested in isolation before Epic 2 feature work begins.

## Acceptance Criteria

1. **Given** the project scaffolding exists (Story 1.1), **When** Storybook is installed and
   configured, **Then** Storybook runs successfully with `pnpm --filter web storybook`, **And** it
   is configured for React 18 and TypeScript, **And** it supports the MUI theme from
   `packages/theme`.

2. **Given** Storybook is configured, **When** we create example stories, **Then** at least one
   example component story exists to verify setup, **And** the story demonstrates MUI theme
   integration, **And** the story includes basic controls/args for interactive testing.

3. **Given** Storybook is working, **When** we review the configuration, **Then** it includes
   add-ons for accessibility, viewport testing, and controls, **And** it is configured to use the
   project's TypeScript settings, **And** a script exists in `apps/web/package.json` to run
   Storybook.

## Tasks / Subtasks

- [x] Task 1: Install Storybook (AC: 1)
  - [x] Run `pnpm dlx storybook@latest init` in apps/web directory
  - [x] Verify Storybook installs for Vite + React + TypeScript
  - [x] Add Storybook scripts to `apps/web/package.json`

- [x] Task 2: Configure Storybook with essential add-ons (AC: 3)
  - [x] Verify @storybook/addon-essentials is installed
  - [x] Install @storybook/addon-a11y for accessibility testing
  - [x] Configure add-ons in `.storybook/main.ts`

- [x] Task 3: Configure MUI theme integration (AC: 1, 2)
  - [x] Create `.storybook/preview.tsx` with theme provider
  - [x] Import theme from `packages/theme/muiTheme.ts`
  - [x] Wrap all stories with MUI ThemeProvider

- [x] Task 4: Create example story to verify setup (AC: 2)
  - [x] Create example component with story
  - [x] Demonstrate MUI theme integration
  - [x] Include basic controls/args for interactive testing

- [x] Task 5: Verify Storybook runs successfully (AC: 1, 3)
  - [x] Run `pnpm --filter web storybook`
  - [x] Verify Storybook opens on port 6006
  - [x] Verify example story renders correctly
  - [x] Verify accessibility addon is active

- [x] Task 6: Document Storybook usage (AC: 3)
  - [x] Add Storybook documentation to apps/web/README.md
  - [x] Document how to create new stories
  - [x] Document how to run Storybook

## Dev Notes

### Story Context

This story sets up Storybook as the component development and documentation environment for the web
app. Storybook enables:

- **Component isolation** - Develop and test components without running the full app
- **Visual documentation** - Auto-generated component documentation
- **Interactive testing** - Test component variants with controls
- **Accessibility testing** - Built-in a11y checks via addon

### Critical Architecture Constraints

**From Architecture Document:**

#### Storybook Configuration

- Use Storybook 8.x with Vite framework
- Configure for React 18 and TypeScript 5
- Include essential add-ons:
  - `@storybook/addon-essentials` (controls, actions, viewport, docs)
  - `@storybook/addon-a11y` (accessibility testing)

#### Theme Integration

- Import theme from `packages/theme/muiTheme.ts`
- Wrap all stories in MUI ThemeProvider
- Ensure Sage Calm theme applies to all components

### Technology Versions

| Technology                  | Version | Notes                  |
| --------------------------- | ------- | ---------------------- |
| Storybook                   | 8.6.x   | Latest stable          |
| @storybook/react-vite       | 8.6.x   | Vite framework support |
| @storybook/addon-essentials | 8.6.x   | Core add-ons bundle    |
| @storybook/addon-a11y       | 8.6.x   | Accessibility testing  |
| React                       | 18.x    | From Vite template     |
| TypeScript                  | 5.x     | Strict mode            |
| MUI                         | 6.x     | Material UI v6         |

### Dependencies on Previous Stories

This story depends on:

- **Story 1.1** - Project scaffolding must exist
- Theme package (`packages/theme`) must be built and accessible

### Testing Notes

**Storybook Verification:**

- Storybook should run without errors
- Example story should render with MUI theme applied
- Accessibility addon should show in toolbar
- Controls panel should allow interactive testing

**Port Configuration:**

- Storybook runs on port 6006 (default)
- Does not conflict with Vite dev server (port 5173/3000)

### Definition of Done

- [x] Storybook installed and configured in `apps/web`
- [x] Runs with `pnpm --filter web storybook`
- [x] Example component story exists and renders correctly
- [x] MUI theme is applied in Storybook preview
- [x] Accessibility addon is active
- [x] Documentation on using Storybook added to project README or apps/web/README

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.5 (via GitHub Copilot)

### Debug Log References

N/A

### Completion Notes List

- Storybook 8.6.14 installed successfully
- Configured for Vite + React + TypeScript
- Essential add-ons installed: @storybook/addon-essentials, @storybook/addon-a11y,
  @storybook/addon-interactions, @storybook/test
- MUI theme integration configured in `.storybook/preview.tsx`
- MatchCard component created as example story
- Storybook runs successfully on port 6006
- Accessibility addon verified and active
- **VERIFIED 2026-01-16**: Storybook starts without errors, MatchCard story renders correctly, all
  acceptance criteria met
- Minor version mismatch warnings (8.6.14 vs 8.6.15) present but non-blocking

### Change Log

| Date       | Change                                    |
| ---------- | ----------------------------------------- |
| 2026-01-16 | Storybook 8.6.14 installed and configured |
| 2026-01-16 | MUI theme integration added to preview    |
| 2026-01-16 | MatchCard example story created           |
| 2026-01-16 | Verified Storybook runs successfully      |

### File List

- `apps/web/.storybook/main.ts` (Storybook configuration)
- `apps/web/.storybook/preview.tsx` (Global decorators, theme provider)
- `apps/web/src/components/MatchCard.tsx` (Example component)
- `apps/web/src/components/MatchCard.stories.tsx` (Example story)
- `apps/web/package.json` (Updated with Storybook scripts and dependencies)
