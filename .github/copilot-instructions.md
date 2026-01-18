# Copilot Instructions for Collabolatte

## Project Overview

Collabolatte is an enterprise opt-in matching platform that creates low-friction cross-boundary
connections within large organisations. The platform enables employees to be randomly matched with
colleagues across departments for casual conversations, fostering serendipitous connections and
breaking down organisational silos.

**Core Principle**: Trust-first design with zero surveillance. Participation is always voluntary,
and individual-level tracking is prohibited.

## Tech Stack

**Frontend:**

- React 18.x with TypeScript (strict mode)
- Vite 5.x for build tooling
- MUI (Material-UI) with Emotion for styling
- Client-side rendered SPA

**Backend:**

- Azure Functions v4 (.NET 10.x isolated worker)
- C# with nullable reference types enabled
- Azure Table Storage (partitioned by ProgrammeId)
- Azure Communication Services for email

**Authentication:**

- Azure Static Web Apps EasyAuth
- Microsoft Entra ID (formerly Azure AD)
- User claims from auth headers are untrusted and must be validated

**Infrastructure:**

- Azure Bicep for IaC
- Monorepo structure with pnpm workspaces

## Project Structure

```
apps/
  web/        # React SPA (Vite)
  api/        # Azure Functions .NET
  marketing/  # 11ty static site
packages/     # Shared code
infra/        # Bicep templates
```

## Coding Standards

**General:**

- Use British English for all code, comments, and documentation
- Follow conventional commits format (feat:, fix:, docs:, etc.)
- Aggressive commit strategy: commit each accepted change individually
- Commits will be squashed when merging feature branches

**TypeScript/React:**

- Prefer functional components with hooks
- Use TypeScript strict mode
- Avoid any types; use proper typing
- Follow project's existing component patterns (see apps/web/src/components/)

**C#/.NET:**

- Follow .NET naming conventions (PascalCase for public members)
- Enable nullable reference types
- Use isolated worker model for Azure Functions
- DTOs must match OpenAPI specs exactly

**Testing:**

- Every new component requires a corresponding test file
- E2E tests use Playwright
- Contract tests required for API shape changes
- Trust-guard test suite ensures no surveillance features creep in

## Branching and Pull Requests

`main` is protected: never push directly to `main`.

- Use a topic branch per change (prefer `ai/<topic>` for agent work).
- Open a pull request and merge via PR only.

### Sprint status updates

When updating `_bmad-output/implementation-artifacts/sprint-status.yaml`:

- Do it only once the corresponding PR is ready (or after it has merged).
- Prefer a tiny follow-up PR that only contains the sprint status change, based on the latest
  `main`.

### Epic completion gate

Before starting the next epic, run `pnpm validate:epic-gate`. Do not start a new epic while any
previous epic/story artefacts remain incomplete.

## Trust-Critical Constraints

These rules are non-negotiable and MUST be followed in all code:

1. **No Surveillance**: Never implement individual-level analytics, participation tracking, or
   manager visibility of who participates
2. **Data Isolation**: Every Table Storage query MUST enforce ProgrammeId as PartitionKey - no
   cross-programme data access
3. **Opt-Out First**: Participation is always voluntary; opt-out must be easy and prominently
   displayed
4. **Aggregate Only**: Sponsors see only aggregate, non-identifying data - never individual
   participant information

**Prohibited Features:**

- Individual participation reports
- "Who hasn't participated" queries
- Manager dashboards showing employee names
- Any analytics that could identify individual participants

## Development Workflow

**Setup:**

```bash
pnpm install
```

**Frontend Development:**

```bash
pnpm --filter web dev          # Start dev server
pnpm --filter web build        # Production build
pnpm --filter web test         # Run tests
pnpm --filter web test:e2e     # Playwright E2E
```

**Backend Development:**

```bash
func start                     # Start Functions locally
dotnet build                   # Build API
dotnet test                    # Run tests
```

## Key Files & Patterns

- **Architecture Decisions**: See `_bmad-output/planning-artifacts/architecture/` (sharded
  documentation)
- **Trust Copy**:
  `_bmad-output/planning-artifacts/epics/trust-copy-checklist-single-source-of-truth.md`
- **Project Context**: `_bmad-output/project-context.md` (183 implementation rules)
- **Epic Definitions**: `_bmad-output/planning-artifacts/epics/epic-*.md`

## Implementation Rules

Reference `_bmad-output/project-context.md` for comprehensive implementation rules. Key patterns:

- All API inputs must be validated at boundaries (auth claims are untrusted)
- Table Storage queries partition by ProgrammeId for isolation
- Error messages never expose internal details to users
- Matching algorithm must be idempotent and handle odd participant counts
- Email delivery uses retry logic with 60-minute window post-match

## Code Review Focus

When reviewing code, check for:

- Compliance with trust-critical constraints (no surveillance)
- Proper data isolation (ProgrammeId partitioning)
- Boundary validation on all inputs
- Test coverage for new features
- OpenAPI spec alignment with DTOs
- British English spelling in user-facing text
