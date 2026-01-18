# Story 1.1: Set Up Initial Project from Starter Template

Status: done

## Story

As a delivery team, I want to set up the initial project from the approved starter templates, So
that Join & Trust stories can be implemented without blocking setup work.

## Acceptance Criteria

1. **Given** the starter templates are approved in Architecture, **When** we initialise the project,
   **Then** the repo is scaffolded as a monorepo with `/apps/web`, `/apps/api`, and
   `/apps/marketing`, **And** the web app is created from the official Vite React TypeScript
   template, **And** the API is initialised with Azure Functions (.NET isolated), **And** the
   marketing site is initialised with 11ty.

2. **Given** the scaffolding exists, **When** baseline configuration is applied, **Then**
   `staticwebapp.config.json` and SWA workflow stubs exist for app+api and marketing, **And** Entra
   ID auth wiring is configured at the platform level (no custom auth code), **And** storage
   connection placeholders are defined for local and cloud environments.

3. **Given** the foundations are in place, **When** a developer starts work on Epic 1 stories,
   **Then** they can run the web and API projects locally without additional scaffolding.

## Tasks / Subtasks

- [x] Task 1: Initialise pnpm workspace at repo root (AC: 1)
  - [x] Create `pnpm-workspace.yaml` defining workspace packages
  - [x] Create root `package.json` with workspace scripts
  - [x] Add `.npmrc` with pnpm configuration

- [x] Task 2: Scaffold web app with Vite React TypeScript (AC: 1)
  - [x] Run `pnpm create vite apps/web --template react-ts`
  - [x] Install MUI dependencies: `@mui/material @emotion/react @emotion/styled`
  - [x] Verify Vite dev server runs successfully

- [x] Task 3: Initialise API with Azure Functions .NET isolated (AC: 1)
  - [x] Run `func init apps/api --worker-runtime dotnet-isolated`
  - [x] Create solution file `collabolatte-api.sln`
  - [x] Verify Functions host runs locally

- [x] Task 4: Scaffold marketing site with 11ty (AC: 1)
  - [x] Initialise `apps/marketing` with `pnpm init`
  - [x] Install 11ty: `pnpm add @11ty/eleventy`
  - [x] Create minimal `.eleventy.js` configuration
  - [x] Create basic `src/` structure with index page

- [x] Task 5: Create shared theme package (AC: 1)
  - [x] Create `packages/theme/package.json`
  - [x] Create `packages/theme/tokens.css` with CSS variables
  - [x] Create `packages/theme/muiTheme.ts` exporting MUI theme

- [x] Task 6: Configure staticwebapp.config.json for app SWA (AC: 2)
  - [x] Create `apps/web/staticwebapp.config.json` with EasyAuth routes
  - [x] Configure Entra ID identity provider settings
  - [x] Add security headers and route protection

- [x] Task 7: Create GitHub Actions workflow stubs (AC: 2)
  - [x] Create `.github/workflows/swa-app.yml` for app+api deployment
  - [x] Create `.github/workflows/swa-marketing.yml` for marketing deployment
  - [x] Configure build paths per architecture document

- [x] Task 8: Set up environment configuration (AC: 2)
  - [x] Create `.env.example` with all required variables
  - [x] Create `apps/api/local.settings.json` with placeholders
  - [x] Document environment variable requirements

- [x] Task 9: Verify local development works (AC: 3)
  - [x] Run web app dev server and verify it loads
  - [x] Run API functions host and verify it starts
  - [x] Run 11ty build and verify marketing site builds

## Dev Notes

### Story Context

This is a **scaffolding story** that creates the complete monorepo structure. It is foundational -
all subsequent stories depend on this structure being in place.

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
    if:
      github.event_name == 'push' || (github.event_name == 'pull_request' && github.event.action !=
      'closed')
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
          action: 'upload'
          app_location: 'apps/web'
          api_location: 'apps/api'
          output_location: 'dist'
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

| Technology                 | Version  | Notes                      |
| -------------------------- | -------- | -------------------------- |
| Node.js                    | 20.x LTS | Required for Vite and 11ty |
| pnpm                       | 9.x      | Workspace package manager  |
| .NET                       | 10.x     | Azure Functions runtime    |
| Azure Functions Core Tools | 4.x      | Local development          |
| React                      | 18.x     | Via Vite template          |
| TypeScript                 | 5.x      | Via Vite template          |
| 11ty                       | 2.x      | Static site generator      |

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

- [x] pnpm workspace configured and working
- [x] Web app runs with `pnpm dev` in apps/web
- [x] API runs with `func start` in apps/api
- [x] Marketing site builds with `eleventy` in apps/marketing
- [x] staticwebapp.config.json includes EasyAuth configuration
- [x] GitHub Actions workflows exist (stubs, not tested)
- [x] Environment configuration documented

## Dev Agent Record

### Agent Model Used

GPT-5.2 (Codex CLI)

### Debug Log References

N/A (no persistent debug log captured in this run)

### Completion Notes List

- Aligned API layout to `apps/api/src/Collabolatte.Api` as per architecture tree
- Made root workspace scripts resilient via `pnpm -r --if-present`
- Made marketing `clean` script Windows-friendly
- Fixed 11ty configuration: Removed `"type": "module"` from marketing package.json to enable proper
  config loading with Eleventy 2.0
- Verified all three apps run/build successfully:
  - Web app: Vite dev server runs on http://localhost:3000/
  - API: Functions host starts successfully (no functions defined yet, as expected)
  - Marketing: Eleventy builds successfully, outputs to dist/

### Change Log

- Restructured Azure Functions project into `apps/api/src/Collabolatte.Api`
- Updated `apps/api/collabolatte-api.sln` project path
- Updated root `package.json` scripts for safer monorepo runs
- Updated `apps/marketing/package.json` clean script
- Updated root `.gitignore` for nested API build outputs

### File List

- `_bmad-output/implementation-artifacts/1-1-set-up-initial-project-from-starter-template.md`
- `apps/api/collabolatte-api.sln`
- `apps/api/src/Collabolatte.Api/Collabolatte.Api.csproj`
- `apps/api/src/Collabolatte.Api/Program.cs`
- `apps/api/src/Collabolatte.Api/Properties/launchSettings.json`
- `package.json`
- `apps/marketing/package.json`
- `.gitignore`
