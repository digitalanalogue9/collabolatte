# Project Structure & Boundaries

## Complete Project Directory Structure

```
collabolatte/
├── README.md
├── pnpm-workspace.yaml
├── package.json
├── tsconfig.base.json            # shared TypeScript config
├── .nvmrc                         # Node version lock (20.11.0)
├── .eslintrc.cjs                  # ESLint config
├── .prettierrc                    # Prettier config
├── .gitignore
├── .env.example
├── .github/
│   └── workflows/
│       ├── swa-app.yml           # app+api SWA
│       ├── swa-marketing.yml     # marketing SWA
│       └── e2e.yml               # Playwright E2E tests
├── .vscode/
│   ├── settings.json
│   ├── extensions.json
│   └── tasks.json
├── apps/
│   ├── web/
│   │   ├── package.json
│   │   ├── vite.config.ts
│   │   ├── tsconfig.json
│   │   ├── tsconfig.app.json
│   │   ├── tsconfig.node.json
│   │   ├── public/
│   │   │   └── staticwebapp.config.json  # SWA config in public/
│   │   ├── src/
│   │   │   ├── App.tsx
│   │   │   ├── main.tsx
│   │   │   ├── routes/
│   │   │   ├── features/
│   │   │   │   ├── account/          # includes transparency page
│   │   │   │   ├── programmes/
│   │   │   │   ├── matches/
│   │   │   │   └── admin/
│   │   │   ├── lib/
│   │   │   │   ├── api/
│   │   │   │   ├── auth/
│   │   │   │   └── utils/
│   │   │   ├── components/
│   │   │   └── styles/
│   │   └── tests/                # co-located tests
│   ├── api/
│   │   ├── README.md
│   │   ├── Collabolatte.Api.sln
│   │   ├── src/
│   │   │   ├── Collabolatte.Api.csproj
│   │   │   ├── Program.cs
│   │   │   ├── host.json
│   │   │   ├── local.settings.json
│   │   │   ├── Properties/
│   │   │   ├── Functions/
│   │   │   │   ├── Programmes/
│   │   │   │   ├── Matches/
│   │   │   │   ├── Participation/
│   │   │   │   └── Admin/
│   │   │   ├── Contracts/
│   │   │   ├── Services/
│   │   │   ├── Repositories/
│   │   │   ├── Models/
│   │   │   ├── Validation/
│   │   │   └── Logging/
│   │   └── tests/
│   │       ├── README.md
│   │       ├── Collabolatte.Api.Tests.csproj
│   │       ├── GlobalUsings.cs
│   │       ├── Unit/              # TUnit tests
│   │       └── Integration/
│   └── marketing/
│       ├── package.json
│       ├── .eleventy.js
│       ├── src/
│       │   ├── _data/
│       │   ├── _includes/
│       │   ├── pages/
│       │   ├── assets/
│       │   └── styles/
│       └── dist/                  # 11ty output (SWA output_location)
├── packages/
│   └── theme/
│       ├── package.json
│       ├── tsconfig.json
│       └── src/
│           ├── index.ts
│           ├── tokens.ts
│           ├── muiTheme.ts
│           └── cssExport.ts
└── tests/
    ├── README.md
    ├── playwright.config.ts
    └── e2e/
        └── home.spec.ts
```

## Architectural Boundaries

**API Boundaries:**

- REST endpoints exposed in `apps/api/src/Collabolatte.Api/Functions/*`
- Auth boundary enforced per Function (EasyAuth claims validation)

**Component Boundaries:**

- Frontend features isolated under `apps/web/src/features/*`
- Shared UI in `apps/web/src/components`
- Shared utilities in `apps/web/src/lib`

**Service Boundaries:**Services`

- Data access via `apps/api/srcApi/Services`
- Data access via `apps/api/src/Collabolatte.Api/Repositories`

**Data Boundaries:**

- Cosmos DB documents under `apps/api/src/Models`
- Partition key rules enforced in repositories

## Requirements to Structure Mapping

**Feature Mapping (from FR categories):**

- **Identity & Access:** `apps/web/src/features/account`, `apps/api/src/Functions/Account`
- **Programme Participation:** `apps/web/src/features/programmes`, `apps/api/src/Functions/Participation`
- **Matching:** `apps/web/src/features/matches`, `apps/api/src/Functions/Matches`
- **Notifications:** `apps/api/src/Services/Notifications`
- **Administration:** `apps/web/src/features/admin`, `apps/api/src/Functions/Admin`
- **Transparency Page:** `apps/web/src/features/account`

**Cross-Cutting Concerns:**

- Auth/claims validation: `apps/api/src/Validation`
- Logging/event records: `apps/api/src/Logging`

## Integration Points

**Internal Communication:**

- Web app calls APICosmos DBder `/api/*`.
- API reads/writes Table Storage and sends email via ACS.

**External Integrations:**

- EasyAuth (SWA) for identity.
- Azure Communication Services for email delivery.

**Data Flow:**Cosmos DB

- Client -> API -> Table Storage
- Scheduler -> Matching service -> Notifications

## File Organization Patterns

**Configuration Files:**

- `staticwebapp.config.json` must be emitted into the web build output root.
- `.env.example` at repo root.

**Source Organization:**

- Feature-first in web; feature-grouped Functions in API.

**Test Organization:**

- Co-located tests in web (`apps/web/tests/`).
- API tests in `apps/api/tests/` using TUnit framework.
- Contract tests under `apps/api/tests/Unit/`.
- Integration tests under `apps/api/tests/Integration/`.
- Playwright E2E in `/tests/e2e`.

**Asset Organization:**

- Web assets in `apps/web/src/styles`
- Marketing assets in `apps/marketing/src/assets`

## Development Workflow Integration

**Development Server Structure:**

- `apps/web` runs Vite dev server.
- `apps/api` runs Functions host locally.
- `apps/marketing` runs 11ty build/watch.

**Build Process Structure:**

- App SWA builds `apps/web` with API path `apps/api`.
- Marketing SWA builds `apps/marketing` output to `dist`.

**Deployment Structure:**

- `app.collabolatte.co.uk` SWA: `app_location=apps/web`, `api_location=apps/api`.
- `www.collabolatte.co.uk` SWA: `app_location=apps/marketing`, `output_location=dist`.

## Structure Dependencies

- `/packages/theme` is a shared contract: both `apps/web` and `apps/marketing` depend on it for visual consistency.
- `apps/web` depends on `apps/api` endpoint shapes; API changes must update OpenAPI + contract tests.
- `tests/e2e` depends on stable routes and data fixtures; keep environment config consistent across SWA and local.

## Cross-Functional Structure Trade-offs

- **PM:** wants clear ownership boundaries -> feature-first layout keeps scope visible.
- **Engineering:** wants low merge conflicts -> shared `/packages/theme` reduces duplicated styling.
- **UX:** wants brand consistency across app and marketing -> tokens.css + MUI theme in one place.
- **Privacy/Legal:** wants clear separation between marketing and authenticated app -> distinct apps and SWA workflows.

## Structure Risks

- **Theme package drift:** shared tokens not updated across apps -> add a simple version bump/checklist.

## Implementation Notes (Updated 2026-01-15)

**Actual Technology Versions (as implemented):**

- **Node.js:** 22.x (locked via `.nvmrc`) - Active LTS until April 2027
- **TypeScript:** 5.6.3 (updated from 5.3.3 for Vite 7 compatibility)
- **React:** 18.2.0 (using React 18 for MUI compatibility)
- **MUI:** 5.15.6 (MUI v5 for React 18 support)
- **Vite:** 7.2.4
- **.NET:** 9.0 (current due to Azure Static Web Apps support; upgrade when available)
- **Azure Functions:** v4 (Worker 2.51.0, Extensions 2.1.0, SDK 2.0.7)
- **TUnit:** 0.3.\* (testing framework for API)
- **FluentAssertions:** 7.0.0
- **Moq:** 4.20.72
- **Playwright:** 1.40.0

**API Test Framework:**

- Using **TUnit** (modern alternative to xUnit)
- TUnit.Assertions for test assertions
- FluentAssertions for readable assertions
- Moq for mocking

**Configuration Management:**

- Root-level shared configs: `tsconfig.base.json`, `.eslintrc.cjs`, `.prettierrc`
- VS Code workspace settings in `.vscode/settings.json`
- Recommended extensions in `.vscode/extensions.json`
- Build/test tasks in `.vscode/tasks.json`

**Package Management:**

- pnpm workspaces (`pnpm-workspace.yaml`)
- Shared dev dependencies at root level
- App-specific dependencies in respective `package.json` files

**Build Scripts (in root package.json):**

- `pnpm build` - Build all apps including API
- `pnpm build:api` - Build API solution
- `pnpm test` - Run all tests (unit + API + E2E)
- `pnpm test:api` - Run API tests only
- `pnpm test:api:watch` - Run API tests in watch mode
- `pnpm test:e2e` - Run Playwright E2E tests

**SWA Configuration:**

- `staticwebapp.config.json` located in `apps/web/public/` (copied to build output by Vite)
- VS Code Azure Functions extension configured to use `apps/api/src` as project path- **API feature sprawl:** Functions folders diverge from routes -> enforce mapping in OpenAPI + tests.
- **Marketing build output mismatch:** 11ty output path doesn't match SWA config -> keep `dist/` consistent and documented.
