# Story 2.5: Know I can leave or pause

Status: ready-for-dev

## Story

As a prospective participant,
I want to know I can pause or leave at any time,
So that I feel safe opting in.

## Acceptance Criteria

1. **Given** I am on the join screen, **When** I read the opt-in information,
   **Then** I can clearly see that leaving or pausing is allowed at any time,
   **And** it is stated as consequence-free.

2. **Given** I have not joined yet, **When** I read the join copy,
   **Then** pausing or leaving is mentioned explicitly at join time.

## Tasks / Subtasks

- [ ] Ensure join/landing copy includes a clear “leave or pause anytime” statement (Trust Copy Checklist)
- [ ] Ensure post-join confirmation reiterates reversibility
- [ ] Provide a visible, non-hidden path to participation controls (may link to “Settings” for now)
- [ ] Add a small copy regression test to prevent accidental drift toward obligation/surveillance wording

## Dev Notes

- This story is about confidence and expectation-setting; actual pause/leave functionality is implemented in Epic 5.

