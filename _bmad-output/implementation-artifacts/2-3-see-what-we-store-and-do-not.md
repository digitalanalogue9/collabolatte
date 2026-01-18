# Story 2.3: See what we store (and do not)

Status: ready-for-dev

## Story

As a prospective participant,
I want to see a clear, plain-English summary of what data is stored about me before joining,
So that I can decide with confidence.

## Acceptance Criteria

1. **Given** I am on the join screen, **When** I look for data handling information,
   **Then** I can see a short, plain-English summary of what is stored and what is not,
   **And** it conforms to the Trust Copy Checklist.

2. **Given** I want more detail, **When** I select the “What we store” link,
   **Then** I can view the full explanation without legalese,
   **And** I can return to the join screen without losing my place.

3. **Given** I am using assistive technology, **When** I read the transparency content,
   **Then** it is readable, structured, and navigable (headings, lists, links).

## Tasks / Subtasks

- [ ] Create a Transparency page/route ("What we store") in the web app
- [ ] Link to the Transparency page from the join/landing experience
- [ ] Ensure copy follows the Trust Copy Checklist and remains consistent across pages
- [ ] If any new reusable components are created in `apps/web/src/components`, add Storybook stories (`*.stories.tsx`)
- [ ] (Optional) Add an API "data preview" endpoint for authenticated users to view what is stored about them (without exposing internal IDs)
- [ ] Add basic tests for navigation to/from the Transparency page

## Dev Notes

- Keep content plain English; avoid legal/compliance theatre.
- Consider co-locating trust copy constants to prevent drift.
