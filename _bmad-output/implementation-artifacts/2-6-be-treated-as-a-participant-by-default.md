# Story 2.6: Be treated as a participant by default

Status: ready-for-dev

## Story

As a newly joined participant,
I want to be treated as a standard participant with no special visibility or responsibilities,
So that I do not feel pressure or role confusion.

## Acceptance Criteria

1. **Given** I have joined, **When** I view the post-join state,
   **Then** I do not see admin or programme-owner surfaces,
   **And** I do not see metrics or status indicators beyond “You may be matched.”

2. **Given** I am a standard participant, **When** I use the app,
   **Then** my default role is participant only.

## Tasks / Subtasks

- [ ] Implement a post-join “participant home” state that is calm and non-performative
- [ ] Ensure the UI does not display admin surfaces unless explicitly authorised in future epics
- [ ] Ensure any role checks default to participant if no explicit admin claim exists
- [ ] Add a simple test to confirm admin UI does not render for normal users

## Dev Notes

- Default to hiding admin capabilities entirely until Epic 6 introduces them deliberately.

