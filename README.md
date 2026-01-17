# Collabolatte

An Azure-native team collaboration platform built as a monorepo.

## 📁 Structure

```
collabolatte/
├── apps/
│   ├── web/              # React SPA (Vite + TypeScript + MUI)
│   │   ├── src/
│   │   ├── tests/        # Unit tests for web
│   │   └── public/
│   ├── api/              # Azure Functions (.NET isolated)
│   │   ├── src/          # API source code
│   │   └── tests/        # Unit & integration tests (TUnit)
│   └── marketing/        # 11ty static marketing site
│       └── src/
├── packages/
│   └── theme/            # Shared design tokens
│       └── src/
└── tests/
    └── e2e/              # End-to-end tests (Playwright)
```

## 🚀 Quick Start

### Prerequisites

- Node.js 22.x+ (use `nvm use` to switch)
- pnpm 8.0.0+
- .NET 10 SDK (for API)

### Installation

```bash
# Install all dependencies
pnpm install
```

### Development

```bash
# Start all apps in parallel
pnpm dev

# Start individual apps
pnpm --filter @collabolatte/web dev
pnpm --filter @collabolatte/marketing dev

# Start API (from apps/api directory)
func start
```

### Building

```bash
# Build all apps
pnpm build

# Build individual apps
pnpm build:web
pnpm build:api
pnpm build:marketing
```

### Testing

```bash
# Run all tests (unit + integration + E2E)
pnpm test

# Run unit/integration tests only
pnpm test:unit

# Run API tests only
pnpm test:api

# Run API tests in watch mode
pnpm test:api:watch

# Run E2E tests only
pnpm test:e2e
```

### Code Quality

```bash
# Lint all code
pnpm lint

# Format all code
pnpm format

# Check formatting (CI)
pnpm format:check

# Type check all TypeScript
pnpm type-check
```

## 📦 Apps

### Web (`apps/web`)

React SPA with:

- **Framework:** Vite + React 18 + TypeScript
- **UI:** Material-UI (MUI)
- **Auth:** MSAL (Azure AD B2C)
- **State:** TanStack Query
- **Routing:** React Router v6

**Local dev:** http://localhost:3000
**SWA CLI:** `swa build` uses `apps/web/dist` as `appLocation` to avoid npm workspace install issues.

### API (`apps/api`)

Azure Functions with:

- **Runtime:** .NET 10 isolated
- **Framework:** Azure Functions v4
- **Storage:** Azure Storage
- **Auth:** Azure AD B2C + Azure Easy Auth
- **Testing:** TUnit + FluentAssertions + Moq

**Structure:**

- `src/` - Function code, services, repositories
- `tests/` - Unit and integration tests

**Local dev:** http://localhost:7071

See [apps/api/README.md](apps/api/README.md) for details.

### Marketing (`apps/marketing`)

Static site with:

- **Framework:** Eleventy (11ty)
- **Styling:** CSS + design tokens from `@collabolatte/theme`

**Local dev:** http://localhost:8080

## 🎨 Theme Package

Shared design tokens (`packages/theme`) exported as:

- **TypeScript:** For React/MUI (web app)
- **CSS Custom Properties:** For 11ty (marketing site)

**Usage in web:**

```typescript
import { muiTheme } from '@collabolatte/theme';

<ThemeProvider theme={muiTheme}>
  <App />
</ThemeProvider>
```

**Usage in marketing:**

```typescript
import { generateCSS } from '@collabolatte/theme';

// Generate CSS file during build
const cssOutput = generateCSS();
```

## 🧪 Testing Strategy

### Unit Tests

- **Web:** Vitest + React Testing Library (in `apps/web/tests/`)
- **API:** TUnit + FluentAssertions + Moq (in `apps/api/tests/Unit/`)

### Integration Tests

- **API:** TUnit with real Azure services (in `apps/api/tests/Integration/`)

### E2E Tests

- **Cross-app:** Playwright (in `tests/e2e/`)

### Running Tests

```bash
# All tests
pnpm test

# Web unit tests
pnpm --filter @collabolatte/web test

# API tests
pnpm test:api

# API tests in watch mode
pnpm test:api:watch

# E2E tests
pnpm test:e2e
```

## 🚢 Deployment

Two separate Azure Static Web Apps:

### App + API SWA

- **Source:** `apps/web` + `apps/api`
- **Workflow:** `.github/workflows/swa-app.yml`
- **Config:** `apps/web/public/staticwebapp.config.json`

### Marketing SWA

- **Source:** `apps/marketing`
- **Workflow:** `.github/workflows/swa-marketing.yml`

## 🔧 Configuration Files

- **`.nvmrc`** - Node version lock (20.11.0)
- **`tsconfig.base.json`** - Shared TypeScript config
- **`.eslintrc.cjs`** - Linting rules
- **`.prettierrc`** - Code formatting
- **`pnpm-workspace.yaml`** - Monorepo workspace definition

## 📚 Documentation

- **Architecture:** `_bmad-output/planning-artifacts/architecture.md`
- **Project Context:** `_bmad-output/project-context.md`
- **Product Brief:** `_bmad-output/planning-artifacts/product-brief.md`
- **PRD:** `_bmad-output/planning-artifacts/prd.md`

## 🤝 Contributing

1. Create a feature branch from `main`
2. Make changes and ensure tests pass (`pnpm test`)
3. Format code (`pnpm format`)
4. Type check (`pnpm type-check`)
5. Submit a pull request

## 🏗️ Monorepo Setup

This project uses:

- **pnpm workspaces** for dependency management
- **Shared TypeScript config** via `tsconfig.base.json`
- **Unified scripts** at root level for consistency
- **Playwright** for E2E testing
- **ESLint + Prettier** for code quality

### Adding a New Package

1. Create directory under `packages/` or `apps/`
2. Add to `pnpm-workspace.yaml` if needed
3. Add `package.json` with name `@collabolatte/<name>`
4. Extend `tsconfig.base.json` if using TypeScript

### Running Commands Across Workspace

```bash
# Run script in all packages
pnpm -r <script>

# Run script in specific package
pnpm --filter @collabolatte/<name> <script>

# Run script in parallel
pnpm -r --parallel <script>
```

## 📄 License

[License information to be determined]

---

Built with ❤️ using Azure, React, and .NET
