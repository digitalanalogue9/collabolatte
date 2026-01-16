# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Collabolatte is an enterprise opt-in matching platform that creates low-friction cross-boundary connections within large organisations. This repository is in the **planning phase** and uses the BMAD (Business Model Agile Development) methodology for requirements gathering, architecture, and story creation.

## BMAD Methodology

This project uses BMAD v6.0.0-alpha with two modules:
- **Core** (`_bmad/core/`): Base agents and resources
- **BMM** (`_bmad/bmm/`): Business Model Module with workflows for enterprise greenfield projects

### Key BMAD Commands

The project uses slash commands to invoke BMAD workflows. Common commands:

| Phase | Command | Purpose |
|-------|---------|---------|
| Analysis | `/bmad:bmm:workflows:create-product-brief` | Create product briefs collaboratively |
| Analysis | `/bmad:bmm:workflows:research` | Conduct market/technical/domain research |
| Planning | `/bmad:bmm:workflows:prd` | Create/validate/edit PRDs |
| Planning | `/bmad:bmm:workflows:create-ux-design` | Plan UX patterns (conditional on UI) |
| Solutioning | `/bmad:bmm:workflows:create-architecture` | Facilitated architecture decisions |
| Solutioning | `/bmad:bmm:workflows:create-epics-and-stories` | Transform PRD to implementation stories |
| Implementation | `/bmad:bmm:workflows:sprint-planning` | Generate sprint status tracking |
| Implementation | `/bmad:bmm:workflows:dev-story` | Execute story implementation |

### Workflow Status Tracking

Current workflow progress is tracked in `_bmad-output/planning-artifacts/bmm-workflow-status.yaml`. Check this file to understand:
- Current project phase (Analysis → Planning → Solutioning → Implementation)
- Which workflows have been completed
- What artifacts have been generated

## Directory Structure

```
_bmad/                    # BMAD methodology framework
  ├── core/               # Core agents and base resources
  ├── bmm/                # Business Model Module
  │   ├── agents/         # Role-based agents (analyst, architect, pm, dev, etc.)
  │   ├── workflows/      # Phase-organised workflow definitions
  │   └── testarch/       # Test architecture knowledge base
  └── _config/            # IDE and module configuration

_bmad-output/             # Generated artifacts
  ├── planning-artifacts/ # PRD, product brief, research
  ├── implementation-artifacts/ # Stories, sprint files (when created)
  └── project-context.md  # AI agent implementation rules

docs/                     # Project knowledge (currently llms-full.txt)
```

## Critical Project Context

The file `_bmad-output/project-context.md` contains **183 implementation rules** that AI agents must follow. Key constraints:

### Technology Stack
- **Frontend**: React 18.x + Vite 5.x (CSR SPA), TypeScript strict mode
- **Backend**: Azure Functions v4 (.NET 10.x isolated worker)
- **Auth**: Azure Static Web Apps EasyAuth with Microsoft Entra ID
- **Data**: Azure Table Storage (partitioned by ProgrammeId)
- **Notifications**: Azure Communication Services Email

### Trust-Critical Rules
1. **No surveillance**: No individual-level analytics, participation tracking, or manager visibility
2. **Data isolation**: Every Table Storage query must enforce ProgrammeId as PartitionKey
3. **Anti-mandate**: Participation is never required; opt-out is always easy
4. **Visibility limits**: Sponsors see only aggregate, non-identifying data

### Code Quality Requirements
- Boundary validation on all API inputs (auth claims are untrusted)
- Contract tests for every API shape change
- Trust-guard test suite blocks builds if surveillance-like features are introduced
- OpenAPI specs must stay in sync with DTOs

## Configuration

- **Language**: British English for both communication and documents
- **User**: DA9
- **Output folder**: `_bmad-output/`

## Development Commands

**Setup:**
```bash
pnpm install                    # Install dependencies (monorepo)
```

**Frontend (apps/web):**
```bash
pnpm --filter web dev           # Start dev server (Vite)
pnpm --filter web build         # Production build
pnpm --filter web test          # Run tests
pnpm --filter web test:e2e      # Playwright E2E tests
```

**Backend (apps/api):**
```bash
func start                      # Start Azure Functions locally
dotnet build                    # Build .NET project
dotnet test                     # Run tests
```

**Commits:**
- Use aggressive commit strategy: commit each accepted change
- Commits will be squashed when merging feature branches
- Follow conventional commits format (`feat:`, `fix:`, `docs:`, etc.)

## Current Project Status

**Current Phase**: Implementation (Phase 4)

Check `_bmad-output/planning-artifacts/bmm-workflow-status.yaml` for detailed workflow status.

**Completed Phases:**
- **Phase 1 (Analysis)**: Product brief, market and domain research
- **Phase 2 (Planning)**: PRD and UX design specification
- **Phase 3 (Solutioning)**: Architecture and epics/stories (5 epics defined)
- **Phase 4 (Implementation)**: In progress - Epic 1: Join & Trust

**Planning Artifacts**: All major planning documents are sharded into focused sections in `_bmad-output/planning-artifacts/` (architecture/, epics/, prd/, ux-design-specification/, research/)
