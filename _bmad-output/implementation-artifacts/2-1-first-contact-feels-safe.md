# Story 2.1: First contact feels safe

Status: ready-for-dev

## Story

As a prospective participant,
I want to understand what Collabolatte is and is not before doing anything,
So that I can decide whether it feels safe and optional.

## Acceptance Criteria

1. **Given** I land on the Collabolatte app unauthenticated, **When** I view the first screen,
   **Then** I can immediately see that participation is optional and lightweight,
   **And** the screen explicitly states that behaviour is not tracked,
   **And** the copy conforms to the Trust Copy Checklist,
   **And** no action is required to understand this.

2. **Given** I have not signed in, **When** I read the first screen,
   **Then** the trust message is in plain English without legal language,
   **And** it conforms to the Trust Copy Checklist.

3. **Given** I am using a keyboard or screen reader, **When** I navigate the first screen,
   **Then** it is fully operable and readable (headings, landmarks, focus order, contrast) per baseline accessibility requirements (NFR18-21).

## Tasks / Subtasks

- [ ] Replace the deployment-verification "Hello, World" content with a trust-first landing experience
- [ ] If any new reusable components are created in `apps/web/src/components`, add Storybook stories (`*.stories.tsx`)
- [ ] Ensure the landing experience works unauthenticated and is the default route (`/`)
- [ ] Add a calm link to "What we store" (transparency) without forcing sign-in
- [ ] Confirm no behavioural analytics or tracking scripts are introduced (Trust Copy Checklist)
- [ ] Add basic web tests (Vitest) for rendering key trust copy
- [ ] Add an E2E smoke test to confirm anonymous landing copy is visible (Playwright)

## Dev Notes

- Web UI lives in `apps/web/src/pages` and `apps/web/src/components`.
- Prefer a single primary action per screen; avoid urgent CTAs.
- Trust Copy Checklist: `_bmad-output/planning-artifacts/epics/trust-copy-checklist-single-source-of-truth.md`.
