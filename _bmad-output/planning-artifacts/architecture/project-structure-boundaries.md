# Project Structure & Boundaries

### Complete Project Directory Structure
```
collabolatte/
├── README.md
├── pnpm-workspace.yaml
├── package.json
├── .gitignore
├── .env.example
├── .github/
│   └── workflows/
│       ├── swa-app.yml           # app+api SWA
│       └── swa-marketing.yml     # marketing SWA
├── apps/
│   ├── web/
│   │   ├── package.json
│   │   ├── vite.config.ts
│   │   ├── tsconfig.json
│   │   ├── staticwebapp.config.json
│   │   ├── src/
│   │   │   ├── app.tsx
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
│   │   └── tests/                # co-located tests under feature folders
│   ├── api/
│   │   ├── collabolatte-api.sln
│   │   ├── src/
│   │   │   ├── Collabolatte.Api/
│   │   │   │   ├── Program.cs
│   │   │   │   ├── Functions/
│   │   │   │   │   ├── Programmes/
│   │   │   │   │   ├── Matches/
│   │   │   │   │   ├── Participation/
│   │   │   │   │   └── Admin/
│   │   │   │   ├── Contracts/
│   │   │   │   ├── Services/
│   │   │   │   ├── Repositories/
│   │   │   │   ├── Models/
│   │   │   │   ├── Validation/
│   │   │   │   └── Logging/
│   │   │   └── Collabolatte.Api.Tests/
│   │   │       ├── Functions/        # contract tests live here
│   │   │       ├── Services/
│   │   │       └── Repositories/
│   │   └── host.json
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
│       ├── tokens.css
│       └── muiTheme.ts
└── tests/
    └── e2e/
        ├── playwright.config.ts
        └── specs/
```

### Architectural Boundaries

**API Boundaries:**
- REST endpoints exposed in `apps/api/src/Collabolatte.Api/Functions/*`
- Auth boundary enforced per Function (EasyAuth claims validation)

**Component Boundaries:**
- Frontend features isolated under `apps/web/src/features/*`
- Shared UI in `apps/web/src/components`
- Shared utilities in `apps/web/src/lib`

**Service Boundaries:**
- Domain services in `apps/api/src/Collabolatte.Api/Services`
- Data access via `apps/api/src/Collabolatte.Api/Repositories`

**Data Boundaries:**
- Table Storage entities under `apps/api/src/Collabolatte.Api/Models`
- Partition rules enforced in repositories

### Requirements to Structure Mapping

**Feature Mapping (from FR categories):**
- **Identity & Access:** `apps/web/src/features/account`, `apps/api/src/Collabolatte.Api/Functions/Account`
- **Programme Participation:** `apps/web/src/features/programmes`, `apps/api/src/Collabolatte.Api/Functions/Participation`
- **Matching:** `apps/web/src/features/matches`, `apps/api/src/Collabolatte.Api/Functions/Matches`
- **Notifications:** `apps/api/src/Collabolatte.Api/Services/Notifications`
- **Administration:** `apps/web/src/features/admin`, `apps/api/src/Collabolatte.Api/Functions/Admin`
- **Transparency Page:** `apps/web/src/features/account`

**Cross-Cutting Concerns:**
- Auth/claims validation: `apps/api/src/Collabolatte.Api/Validation`
- Logging/event records: `apps/api/src/Collabolatte.Api/Logging`

### Integration Points

**Internal Communication:**
- Web app calls API endpoints under `/api/*`.
- API reads/writes Table Storage and sends email via ACS.

**External Integrations:**
- EasyAuth (SWA) for identity.
- Azure Communication Services for email delivery.

**Data Flow:**
- Client -> API -> Table Storage
- Scheduler -> Matching service -> Notifications

### File Organization Patterns

**Configuration Files:**
- `staticwebapp.config.json` must be emitted into the web build output root.
- `.env.example` at repo root.

**Source Organization:**
- Feature-first in web; feature-grouped Functions in API.

**Test Organization:**
- Co-located tests in web and API.
- Contract tests under `apps/api/src/Collabolatte.Api.Tests/Functions/`.
- Playwright E2E in `/tests/e2e`.

**Asset Organization:**
- Web assets in `apps/web/src/styles`
- Marketing assets in `apps/marketing/src/assets`

### Development Workflow Integration

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

### Structure Dependencies

- `/packages/theme` is a shared contract: both `apps/web` and `apps/marketing` depend on it for visual consistency.
- `apps/web` depends on `apps/api` endpoint shapes; API changes must update OpenAPI + contract tests.
- `tests/e2e` depends on stable routes and data fixtures; keep environment config consistent across SWA and local.

### Cross-Functional Structure Trade-offs

- **PM:** wants clear ownership boundaries -> feature-first layout keeps scope visible.
- **Engineering:** wants low merge conflicts -> shared `/packages/theme` reduces duplicated styling.
- **UX:** wants brand consistency across app and marketing -> tokens.css + MUI theme in one place.
- **Privacy/Legal:** wants clear separation between marketing and authenticated app -> distinct apps and SWA workflows.

### Structure Risks

- **Theme package drift:** shared tokens not updated across apps -> add a simple version bump/checklist.
- **API feature sprawl:** Functions folders diverge from routes -> enforce mapping in OpenAPI + tests.
- **Marketing build output mismatch:** 11ty output path doesn't match SWA config -> keep `dist/` consistent and documented.
