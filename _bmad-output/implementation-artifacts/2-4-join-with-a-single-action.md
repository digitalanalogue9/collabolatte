# Story 2.4: Join with a single action

Status: ready-for-dev

## Story

As a prospective participant,
I want to opt in with one clear, reversible action,
So that joining feels low-stakes.

## Acceptance Criteria

1. **Given** I am on the join screen, **When** I choose to join,
   **Then** there is a single primary Join action,
   **And** I am not asked for a bio, interests, or extra details,
   **And** the language avoids commitment or obligation,
   **And** it conforms to the Trust Copy Checklist.

2. **Given** I select Join, **When** the action completes,
   **Then** I see a clear confirmation that I am now opted in.

3. **Given** I am authenticated, **When** I join,
   **Then** the system persists an opt-in state keyed to my Entra identity (no separate account system).

## Tasks / Subtasks

- [ ] Add an authenticated API endpoint to create/enable participation (e.g., `POST /api/participation/join`)
- [ ] Persist participation state in Table Storage (MVP), keyed by EasyAuth principal ID
- [ ] Add a web action to call the join endpoint and show calm confirmation UI
- [ ] If any new reusable components are created in `apps/web/src/components`, add Storybook stories (`*.stories.tsx`)
- [ ] Ensure join is idempotent (repeated join does not error or create duplicates)
- [ ] Add API tests covering: unauthenticated rejected, authenticated join creates entity, idempotent join
- [ ] Add minimal E2E test: sign in -> join -> confirmation shown

## Dev Notes

- Table Storage is already validated in `apps/api/src/Functions/StatusFunction.cs`; reuse `AzureWebJobsStorage`.
- Keep the data model minimal for Epic 2: `JoinedAt`, `Status=Joined`, `UserDisplayName?` if needed.
