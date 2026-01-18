# Collabolatte Web App

React 18 + TypeScript + Vite SPA with MUI components.

## Development

```bash
# Start dev server
pnpm dev

# Run Storybook for component development
pnpm storybook

# Run tests
pnpm test

# Type check
pnpm type-check
```

## Storybook

Component development and documentation using Storybook. Configured with:

- Sage Calm theme from `@collabolatte/theme`
- Accessibility testing addon
- Interactive controls for props
- Automatic documentation generation

Stories are located alongside components in `src/components/**/*.stories.tsx`.

## Components

All components follow the **Sage Calm** design direction: minimal, trust-first, low-pressure. Components use MUI (Material-UI) themed with the Sage Calm palette from `@collabolatte/theme`.

### Layout Components

#### `<Logo />`

Brand logo component used throughout the application.

**Props:**
- `size?: 'small' | 'medium' | 'large'` - Logo size variant (default: 'medium')

**Usage:**
```tsx
import { Logo } from './components/Logo';
<Logo size="large" />
```

#### `<AppHeader />`

Application header with logo, user name/avatar, and settings menu.

**Props:**
- `userName?: string` - Current user's display name
- `userAvatar?: string` - URL to user's avatar image
- `onSettingsClick?: () => void` - Callback when settings menu is clicked

**Accessibility:**
- Includes ARIA labels for navigation
- Keyboard navigable menu

**Usage:**
```tsx
import { AppHeader } from './components/AppHeader';
<AppHeader
  userName="Jane Smith"
  userAvatar="/avatar.jpg"
  onSettingsClick={() => navigate('/settings')}
/>
```

#### `<AppFooter />`

Application footer with Privacy, Terms, and Support links.

**Props:**
- `privacyUrl?: string` - URL for privacy policy (default: '/privacy')
- `termsUrl?: string` - URL for terms of service (default: '/terms')
- `supportUrl?: string` - URL for support page (default: '/support')

**Usage:**
```tsx
import { AppFooter } from './components/AppFooter';
<AppFooter />
```

#### `<AppLayout />`

Wrapper component that centers content with generous whitespace following Sage Calm design.

**Props:**
- `children: ReactNode` - Content to be centered and wrapped
- `maxWidth?: 'sm' | 'md' | 'lg'` - Maximum content width (default: 'md')

**Usage:**
```tsx
import { AppLayout } from './components/AppLayout';
<AppLayout maxWidth="md">
  <YourContent />
</AppLayout>
```

### Content Components

#### `<MatchCard />`

Displays match information with three variants: matched, pending, or no-match.

**Props:**
- `variant: 'matched' | 'pending' | 'no-match'` - Card state
- `matchName?: string` - Name of matched person (for 'matched' variant)
- `matchedAt?: Date` - Timestamp of match (for 'matched' variant)
- `teamsLink?: string` - Deep link to Teams meeting (for 'matched' variant)
- `onScheduleClick?: () => void` - Callback for schedule action

**Accessibility:**
- Clear status announcements for screen readers
- Keyboard accessible actions

**Usage:**
```tsx
import { MatchCard } from './components/MatchCard';
<MatchCard
  variant="matched"
  matchName="Alex Johnson"
  matchedAt={new Date()}
  teamsLink="https://teams.microsoft.com/l/..."
/>
```

#### `<JoinCard />`

First-time entry screen implementing Direction 6 (Minimal Join-First).

**Props:**
- `onJoin: () => void` - Callback when user clicks Join
- `onLearnMore?: () => void` - Optional callback for "What we store" link
- `isLoading?: boolean` - Shows loading state during join

**Trust-First Language:**
- Emphasises that participation is optional
- Shows "What we store" transparency link
- Clear messaging about ability to leave anytime

**Usage:**
```tsx
import { JoinCard } from './components/JoinCard';
<JoinCard
  onJoin={handleJoin}
  onLearnMore={() => navigate('/privacy')}
/>
```

#### `<ContextInfoBlock />`

Subdued information block implementing Direction 2 (Quiet Context). Never interrupts; user reads when ready.

**Props:**
- `title?: string` - Optional block title
- `children: ReactNode` - Information content
- `variant?: 'info' | 'warning' | 'success'` - Visual variant (default: 'info')

**Usage:**
```tsx
import { ContextInfoBlock } from './components/ContextInfoBlock';
<ContextInfoBlock title="What happens next">
  You'll be matched with someone in the next cycle. We'll send you an email
  with their name and a Teams meeting link.
</ContextInfoBlock>
```

#### `<ProgrammeStatusCard />`

Shows participation status implementing Direction 3 (MVP Programme Card).

**Props:**
- `status: 'active' | 'paused' | 'not-joined'` - Current participation status
- `nextCycleDate?: Date` - Date of next matching cycle
- `onPause?: () => void` - Callback to pause participation
- `onResume?: () => void` - Callback to resume participation
- `onLeave?: () => void` - Callback to leave programme

**Trust Patterns:**
- Emphasises opt-out visibility (pause/leave always visible)
- No metrics or pressure indicators
- Clear about next action and timing

**Usage:**
```tsx
import { ProgrammeStatusCard } from './components/ProgrammeStatusCard';
<ProgrammeStatusCard
  status="active"
  nextCycleDate={new Date('2026-01-20')}
  onPause={handlePause}
  onLeave={handleLeave}
/>
```

#### `<EmptyState />`

Calm messaging for empty states (e.g., no matches available).

**Props:**
- `icon?: ReactNode` - Optional icon or illustration
- `title: string` - Primary message
- `description?: string` - Secondary explanatory text
- `action?: ReactNode` - Optional action button

**Usage:**
```tsx
import { EmptyState } from './components/EmptyState';
<EmptyState
  title="No matches yet"
  description="You'll be matched in the next cycle on Monday."
  action={<Button>Learn More</Button>}
/>
```

### Component Patterns

#### Trust-First Language

All components use trust language:
- ✅ "You can leave anytime"
- ✅ "Participation is optional"
- ✅ "We don't track your behaviour"
- ❌ Avoid: "Must", "Required", "Mandatory"

#### Accessibility

All components include:
- ARIA labels for screen readers
- Keyboard navigation support
- Focus management
- Semantic HTML elements

#### Visual Design

Following Sage Calm design direction:
- Airy, low-density layouts with generous whitespace
- Minimal visual hierarchy - one primary action per screen
- Subdued colour palette - sage greens, soft greys, warm neutrals
- No dark patterns or hidden controls

## Architecture

- **State:** React Query for server state
- **Auth:** Azure MSAL for Entra ID authentication
- **UI:** Material-UI (MUI) with custom Sage Calm theme
- **Routing:** React Router v6

---

# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react)
  uses [Babel](https://babeljs.io/) (or [oxc](https://oxc.rs) when used in
  [rolldown-vite](https://vite.dev/guide/rolldown)) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc)
  uses [SWC](https://swc.rs/) for Fast Refresh

## React Compiler

The React Compiler is not enabled on this template because of its impact on dev & build
performances. To add it, see
[this documentation](https://react.dev/learn/react-compiler/installation).

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable
type-aware lint rules:

```js
export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...

      // Remove tseslint.configs.recommended and replace with this
      tseslint.configs.recommendedTypeChecked,
      // Alternatively, use this for stricter rules
      tseslint.configs.strictTypeChecked,
      // Optionally, add this for stylistic rules
      tseslint.configs.stylisticTypeChecked,

      // Other configs...
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
]);
```

You can also install
[eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x)
and
[eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom)
for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x';
import reactDom from 'eslint-plugin-react-dom';

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
]);
```
