# Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**Critical Conflict Points Identified:**
Naming, file structure, API formats, date handling, error/loading patterns.

### Naming Patterns

**Database Naming Conventions:**
- **Tables:** PascalCase (`Memberships`, `Cycles`, `Matches`, `Events`)
- **Entity properties:** camelCase (`programmeId`, `cycleDate`, `createdAt`)

**API Naming Conventions:**
- **Routes:** plural, noun-based (`/programmes`, `/matches`, `/me`)
- **Route params:** `{id}` (`/programmes/{programmeId}`)
- **JSON fields:** camelCase (`matchedUserId`, `cycleDate`)

**Code Naming Conventions:**
- **Components:** PascalCase (`MatchCard`)
- **Frontend files:** kebab-case (`match-card.tsx`)
- **Functions/vars:** camelCase (`getProgrammeById`, `userId`)

### Structure Patterns

**Project Organization:**
- Components organised **by feature** (`/features/...`)
- Shared utilities in `/lib`

**Tests:**
- Co-located `*.test.ts` / `*.test.tsx` alongside source files

### Format Patterns

**API Response Formats:**
- **Direct payloads** only (no `{ data, error }` wrapper)
- **Problem Details** is the only standard error wrapper shape

**Data Exchange Formats:**
- JSON fields: camelCase
- Dates: ISO 8601 strings with timezone offsets where relevant
  - Cycle date uses programme TZ

### Communication Patterns

**Events (if/when event log used):**
- Event rows use programme-scoped PartitionKey
- Event payload fields in camelCase

### Process Patterns

**Error Handling Patterns:**
- Global error boundary for unexpected UI crashes
- Per-call handling for API errors (show inline error states)

**Loading State Patterns:**
- Local component state only (no shared loading context)

### Pattern Risks

- **Route naming drift:** agents might reintroduce singular routes -> enforce in code review checklist.
- **Date format drift:** ISO 8601 vs epoch -> contract tests must assert ISO 8601.
- **Error shape drift:** problem-details vs ad-hoc error objects -> lint/test for error envelope consistency.
- **File naming drift:** PascalCase vs kebab-case on frontend -> enforce via linting rule.

### First Principles (Why These Patterns Exist)

- **Consistency beats cleverness:** shared naming/format rules prevent invisible integration bugs.
- **Directness over abstraction:** direct payloads and simple routing reduce accidental divergence.
- **Trust is the product:** error handling and date formats must be predictable and boring.

### Failure Modes

- **Mixed casing in routes/fields:** breaks client/server contract silently.
- **Inconsistent date formats:** invalid comparisons and broken sorting.
- **Non-standard error shapes:** UI error handling fails unpredictably.
- **Misplaced tests:** reduced coverage on contract boundaries.

### Consistency Checks

- Routes are plural and noun-based; params always `{id}`.
- JSON fields and entity properties are camelCase everywhere.
- Frontend file names are kebab-case; component names are PascalCase.
- Problem Details is the only error wrapper; success responses are direct payloads.

### Enforcement Guidelines

**All AI Agents MUST:**
- Use PascalCase table names and camelCase for entity/JSON fields.
- Use plural, noun-based API routes with `{id}` params.
- Keep frontend files kebab-case and components PascalCase.
- Use ISO 8601 date strings; Problem Details only for errors.

**Pattern Enforcement:**
- Add contract tests for ISO 8601 dates and Problem Details error shape.
- Review checklist includes naming/format rules; deviations require explicit approval.

### Pattern Examples (Condensed)

**Good:**
- `GET /programmes/{programmeId}` -> `{ programmeId, cadence, cycleDate }`
- `features/matches/match-card.tsx` exports `MatchCard`

**Anti-Patterns:**
- `/programme/123`
- `match_card.tsx`
- `{ data: {...} }` wrapper for success
- epoch timestamps
