# Starter Template Evaluation

## Primary Technology Domain

Monorepo with three components:

- Web SPA (React/Vite)
- Serverless API (Azure Functions .NET isolated)
- Marketing site (11ty)

## Starter Options Considered

1. **Official Vite React TypeScript template** (for the web app)

- Command (official):
  ```bash
  pnpm create vite
  ```
  Then select React + TypeScript in prompts, or specify `--template react-ts`.

2. **Azure Functions Core Tools init** (for the API)

- Command:
  ```bash
  func init collabolatte-api --worker-runtime dotnet-isolated
  ```

3. **Eleventy (11ty) local install** (for the marketing site)

- Commands (official):
  ```bash
  pnpm init
  pnpm install @11ty/eleventy
  npx @11ty/eleventy
  ```

## Selected Starter: Official Vite + Functions Core Tools + 11ty

**Rationale for Selection:**

- Minimal and predictable, aligns with the trust-first, low surface area ethos.
- Keeps UI and content decisions in our control.
- Monorepo enables shared theming assets for both app and marketing site.

## Monorepo Structure (proposed)

```
/apps
  /web           # React + Vite SPA
  /api           # Azure Functions .NET isolated
  /marketing     # 11ty site
/packages
  /theme         # shared design tokens + CSS variables + MUI theme export
```

## Workspaces (pnpm)

- Use `pnpm-workspace.yaml` at the repo root to define workspace packages.

## Shared Theming (lightweight tokens)

- `/packages/theme/tokens.css` for CSS variables used by 11ty
- `/packages/theme/muiTheme.ts` exporting the MUI theme built from the same tokens

## Tooling Additions (confirmed)

**MUI (web app):**

```bash
pnpm add @mui/material @emotion/react @emotion/styled
```

**Playwright (E2E):**

```bash
npm init playwright@latest
```

**Storybook (component workshop):**

```bash
npm create storybook@latest
```

## Deployment (Azure Static Web Apps)

- **Two separate SWA resources**:
  - `app.collabolatte.co.uk` -> SPA + API (SWA with `app_location` + `api_location`)
  - `www.collabolatte.co.uk` -> marketing site (SWA with `app_location` only)
- **Plan:** Both SWAs on Free tier for MVP (cost-minimising), with upgrade path to Standard if/when needed.

- **Workflow build configuration**:
  - Use `app_location`, `api_location`, and `output_location` in the SWA workflow YAML to match each app folder.
  - `api_location` points to the Functions folder for the app SWA.

- **Routing/auth configuration**:
  - Use `staticwebapp.config.json`; `routes.json` is deprecated.
  - Place `staticwebapp.config.json` under the `app_location`, and ensure the build outputs it to the root of `output_location`.

## Architectural Decisions Provided by Starter

**Language & Runtime:**

- React + TypeScript via Vite scaffold.
- Azure Functions .NET isolated worker model for the API.
- 11ty for the marketing site.

**Styling Solution:**

- MUI + Emotion in the web app.
- Shared CSS variables/tokens package for 11ty and MUI.

**Testing Framework:**

- Playwright for E2E.

**Component Workshop:**

- Storybook for isolated UI development.

**Code Organisation:**

- pnpm workspaces with `/apps` and `/packages` to share theming across SPA and marketing site.

**Development Experience:**

- Vite dev server for the SPA.
- 11ty local build via npx.
- Storybook for UI states and docs.

## Cross-Functional Trade-offs (Starter & Monorepo)

- **PM:** wants speed to validate and clean separation between app and marketing -> two SWAs keep messaging and product surfaces distinct.
- **Engineering:** prefers minimal, predictable scaffolding -> official Vite + Functions init reduces surprises.
- **UX:** wants consistent brand across app and marketing -> shared tokens package is essential.
- **Privacy/Legal:** prefers clear boundary between marketing and authenticated app data -> separate SWAs and domains reduce accidental data coupling.

## Dependency Map (Monorepo & Deployment)

- **Shared theme package** feeds both `/apps/web` (MUI theme) and `/apps/marketing` (tokens.css).
- **SWA app+API** depends on repo layout alignment (`app_location`, `api_location`, `output_location`).
- **Marketing SWA** depends on 11ty build output location matching its SWA workflow.
- **Playwright** targets `/apps/web` (app domain), not marketing; marketing can use simple link checks.

## Critical Risks & Mitigations (Starter & Deployment)

- **Monorepo complexity creep:** multiple apps can drift -> keep shared tooling minimal and document boundaries.
- **Theme divergence:** 11ty and MUI could diverge visually -> enforce shared tokens as source of truth.
- **SWA config mismatch:** wrong `app_location`/`output_location` breaks deploys -> standardise build paths per app and document in workflows.
- **Domain confusion:** users mixing `www` and `app` expectations -> keep navigation boundaries explicit and avoid auth surfaces on marketing.

## Comparative Analysis Matrix (Starter & Deployment)

| Option                                                     | Maintainability | Trust/Privacy Fit | Delivery Speed | Complexity |  Score |
| ---------------------------------------------------------- | --------------: | ----------------: | -------------: | ---------: | -----: |
| **Chosen:** Official Vite + Functions + 11ty, pnpm, 2x SWA |               5 |                 5 |              4 |          4 | **18** |
| Single SWA for app + marketing                             |               3 |                 3 |              4 |          3 |     13 |
| MUI-opinionated starter                                    |               3 |                 4 |              4 |          3 |     14 |
| npm workspaces instead of pnpm                             |               4 |                 5 |              4 |          4 |     17 |

## Pre-mortem (What Could Go Wrong)

- Build pipelines drift between apps -> lock shared tooling and document per-app build outputs.
- Theme package becomes stale -> treat tokens as source of truth and update in one place only.
- Marketing deploy breaks due to 11ty output path mismatch -> standardise output dir and wire in SWA config.
- App SWA fails to route auth correctly -> ensure `staticwebapp.config.json` lands in app build output.

## Clarity Checks (Rubber Duck)

- **Simple:** We will create three apps in one repo, share a theme, and deploy two SWAs (app+API, marketing).
- **Detailed:** `/apps/web` (Vite+React+MUI+Storybook), `/apps/api` (Functions .NET isolated), `/apps/marketing` (11ty), `/packages/theme` for shared tokens.
- **Technical:** pnpm workspaces manage dependencies; SWA workflows point at app and api folders; 11ty output path aligns with marketing SWA.

## Red vs Blue (Starter & Deployment)

- **Red Team:** two SWAs and a monorepo increase config surface area -> higher chance of mis-deploys.
- **Blue Team:** standardised app locations and documented build outputs mitigate; CI checks can validate config.
- **Red Team:** shared theme package could create coupling across apps -> harder to evolve independently.
- **Blue Team:** keep tokens minimal and versioned; avoid deep UI dependencies across app and marketing.

**Note:** Project initialisation using these commands should be the first implementation story.
