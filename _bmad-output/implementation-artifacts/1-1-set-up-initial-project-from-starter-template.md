# Story 1.1: Set Up Initial Project from Starter Template

Status: ready-for-dev

## Story

As a delivery team,
I want to set up the initial project from the approved starter templates,
So that Join & Trust stories can be implemented without blocking setup work.

## Acceptance Criteria

1. **Given** the starter templates are approved in Architecture,
   **When** we initialise the project,
   **Then** the repo is scaffolded as a monorepo with `/apps/web`, `/apps/api`, and `/apps/marketing`,
   **And** the web app is created from the official Vite React TypeScript template,
   **And** the API is initialised with Azure Functions (.NET isolated),
   **And** the marketing site is initialised with 11ty.

2. **Given** the scaffolding exists,
   **When** baseline configuration is applied,
   **Then** `staticwebapp.config.json` and SWA workflow stubs exist for app+api and marketing,
   **And** Entra ID auth wiring is configured at the platform level (no custom auth code),
   **And** storage connection placeholders are defined for local and cloud environments.

3. **Given** the foundations are in place,
   **When** a developer starts work on Epic 1 stories,
   **Then** they can run the web and API projects locally without additional scaffolding.

## Tasks / Subtasks

- [ ] Task 1: Initialise pnpm workspace at repo root (AC: 1)
  - [ ] Create `pnpm-workspace.yaml` defining workspace packages
  - [ ] Create root `package.json` with workspace scripts
  - [ ] Add `.npmrc` with pnpm configuration

- [ ] Task 2: Scaffold web app with Vite React TypeScript (AC: 1)
  - [ ] Run `pnpm create vite apps/web --template react-ts`
  - [ ] Install MUI dependencies: `@mui/material @emotion/react @emotion/styled`
  - [ ] Verify Vite dev server runs successfully

- [ ] Task 3: Initialise API with Azure Functions .NET isolated (AC: 1)
  - [ ] Run `func init apps/api --worker-runtime dotnet-isolated`
  - [ ] Create solution file `collabolatte-api.sln`
  - [ ] Verify Functions host runs locally

- [ ] Task 4: Scaffold marketing site with 11ty (AC: 1)
  - [ ] Initialise `apps/marketing` with `pnpm init`
  - [ ] Install 11ty: `pnpm add @11ty/eleventy`
  - [ ] Create minimal `.eleventy.js` configuration
  - [ ] Create basic `src/` structure with index page

- [ ] Task 5: Create shared theme package (AC: 1)
  - [ ] Create `packages/theme/package.json`
  - [ ] Create `packages/theme/tokens.css` with CSS variables
  - [ ] Create `packages/theme/muiTheme.ts` exporting MUI theme

- [ ] Task 6: Configure staticwebapp.config.json for app SWA (AC: 2)
  - [ ] Create `apps/web/staticwebapp.config.json` with EasyAuth routes
  - [ ] Configure Entra ID identity provider settings
  - [ ] Add security headers and route protection

- [ ] Task 7: Create GitHub Actions workflow stubs (AC: 2)
  - [ ] Create `.github/workflows/swa-app.yml` for app+api deployment
  - [ ] Create `.github/workflows/swa-marketing.yml` for marketing deployment
  - [ ] Configure build paths per architecture document

- [ ] Task 8: Set up environment configuration (AC: 2)
  - [ ] Create `.env.example` with all required variables
  - [ ] Create `apps/api/local.settings.json` with placeholders
  - [ ] Document environment variable requirements

- [ ] Task 9: Verify local development works (AC: 3)
  - [ ] Run web app dev server and verify it loads
  - [ ] Run API functions host and verify it starts
  - [ ] Run 11ty build and verify marketing site builds

## Dev Notes

### Story Context

This is a **scaffolding story** that creates the complete monorepo structure. It is foundational - all subsequent stories depend on this structure being in place.

### Critical Architecture Constraints

**From Architecture Document:**

#### Monorepo Structure

```
collabolatte/
├── pnpm-workspace.yaml
├── package.json
├── .npmrc
├── .env.example
├── .gitignore
├── .github/
│   └── workflows/
│       ├── swa-app.yml
│       └── swa-marketing.yml
├── apps/
│   ├── web/                    # Vite + React + TypeScript
│   │   ├── package.json
│   │   ├── vite.config.ts
│   │   ├── tsconfig.json
│   │   ├── staticwebapp.config.json
│   │   ├── index.html
│   │   └── src/
│   │       ├── main.tsx
│   │       ├── App.tsx
│   │       └── vite-env.d.ts
│   ├── api/                    # Azure Functions .NET isolated
│   │   ├── collabolatte-api.sln
│   │   ├── host.json
│   │   ├── local.settings.json
│   │   └── src/
│   │       └── Collabolatte.Api/
│   │           ├── Collabolatte.Api.csproj
│   │           └── Program.cs
│   └── marketing/              # 11ty
│       ├── package.json
│       ├── .eleventy.js
│       └── src/
│           └── index.njk
└── packages/
    └── theme/
        ├── package.json
        ├── tokens.css
        └── muiTheme.ts
```

#### Commands Reference

**Web App (Vite React TypeScript):**
```bash
pnpm create vite apps/web --template react-ts
cd apps/web
pnpm add @mui/material @emotion/react @emotion/styled
```

**API (Azure Functions .NET isolated):**
```bash
func init apps/api --worker-runtime dotnet-isolated
```

**Marketing (11ty):**
```bash
cd apps/marketing
pnpm init
pnpm add @11ty/eleventy
```

#### pnpm-workspace.yaml

```yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

#### staticwebapp.config.json (for apps/web)

```json
{
  "auth": {
    "identityProviders": {
      "azureActiveDirectory": {
        "registration": {
          "openIdIssuer": "https://login.microsoftonline.com/{AZURE_TENANT_ID}/v2.0",
          "clientIdSettingName": "AZURE_CLIENT_ID",
          "clientSecretSettingName": "AZURE_CLIENT_SECRET"
        }
      }
    }
  },
  "routes": [
    {
      "route": "/api/*",
      "allowedRoles": ["authenticated"]
    },
    {
      "route": "/.auth/login/aad",
      "allowedRoles": ["anonymous"]
    },
    {
      "route": "/.auth/logout",
      "allowedRoles": ["anonymous", "authenticated"]
    }
  ],
  "responseOverrides": {
    "401": {
      "redirect": "/.auth/login/aad?post_login_redirect_uri=.referrer",
      "statusCode": 302
    }
  },
  "globalHeaders": {
    "X-Content-Type-Options": "nosniff",
    "X-Frame-Options": "DENY",
    "Content-Security-Policy": "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"
  },
  "navigationFallback": {
    "rewrite": "/index.html",
    "exclude": ["/api/*", "/.auth/*"]
  }
}
```

#### SWA Workflow Configuration (app+api)

```yaml
name: Azure Static Web Apps CI/CD (App)

on:
  push:
    branches:
      - main
    paths:
      - 'apps/web/**'
      - 'apps/api/**'
      - 'packages/theme/**'
  pull_request:
    types: [opened, synchronize, reopened, closed]
    branches:
      - main

jobs:
  build_and_deploy_job:
    if: github.event_name == 'push' || (github.event_name == 'pull_request' && github.event.action != 'closed')
    runs-on: ubuntu-latest
    name: Build and Deploy Job
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: true
      - name: Build And Deploy
        id: builddeploy
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN_APP }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          action: "upload"
          app_location: "apps/web"
          api_location: "apps/api"
          output_location: "dist"
```

#### Environment Variables (.env.example)

```bash
# Azure Static Web Apps (for local SWA CLI)
AZURE_CLIENT_ID=your-client-id-here
AZURE_CLIENT_SECRET=your-client-secret-here
AZURE_TENANT_ID=your-tenant-id-here

# Storage (for API)
STORAGE_CONNECTION_STRING=UseDevelopmentStorage=true

# Azure Communication Services
ACS_CONNECTION_STRING=your-acs-connection-string-here
```

#### local.settings.json (apps/api)

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "dotnet-isolated",
    "STORAGE_CONNECTION_STRING": "UseDevelopmentStorage=true",
    "ACS_CONNECTION_STRING": ""
  }
}
```

### Technology Versions

| Technology | Version | Notes |
|------------|---------|-------|
| Node.js | 20.x LTS | Required for Vite and 11ty |
| pnpm | 9.x | Workspace package manager |
| .NET | 10.x | Azure Functions runtime |
| Azure Functions Core Tools | 4.x | Local development |
| React | 18.x | Via Vite template |
| TypeScript | 5.x | Via Vite template |
| 11ty | 2.x | Static site generator |

### Dependencies on Story 1.0

This story depends on the infrastructure documentation created in Story 1.0:
- `/infra/README.md` contains naming conventions and configuration details
- EasyAuth configuration values reference the Entra ID setup steps documented there

### Testing Notes

This story creates scaffolding only - no application tests are written. Verification is:
1. Web dev server starts without errors
2. API Functions host starts without errors
3. 11ty builds without errors

### Trust & Privacy Considerations

- No user data handling in this story
- EasyAuth configuration is platform-level only (no custom auth code)
- No analytics or tracking code is added

### Definition of Done

- [ ] pnpm workspace configured and working
- [ ] Web app runs with `pnpm dev` in apps/web
- [ ] API runs with `func start` in apps/api
- [ ] Marketing site builds with `npx @11ty/eleventy` in apps/marketing
- [ ] staticwebapp.config.json includes EasyAuth configuration
- [ ] GitHub Actions workflows exist (stubs, not tested)
- [ ] Environment configuration documented

## Dev Agent Record

### Agent Model Used

(To be filled by implementing agent)

### Debug Log References

(To be filled during implementation)

### Completion Notes List

(To be filled during implementation)

### Change Log

(To be filled during implementation)

### File List

(To be filled during implementation)
