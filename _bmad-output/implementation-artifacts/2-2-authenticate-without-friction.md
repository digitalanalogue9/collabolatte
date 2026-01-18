# Story 2.2: Authenticate without friction

Status: ready-for-dev

## Story

As a prospective participant,
I want to authenticate using my corporate Entra ID without creating an account,
So that joining feels invisible and low-effort.

## Acceptance Criteria

1. **Given** I choose to sign in, **When** I authenticate via Entra ID,
   **Then** I am signed in without creating any custom credentials,
   **And** I do not see any additional create account steps.

2. **Given** I have authenticated successfully, **When** I land back in the app,
   **Then** I see clear reassurance that only basic identity data is used.

3. **Given** I am authenticated, **When** the web app calls the API,
   **Then** the API correctly derives identity from EasyAuth headers and does not require custom token handling.

## Tasks / Subtasks

- [ ] Provide a clear sign-in CTA that uses SWA EasyAuth (`/.auth/login/aad`)
- [ ] Add a signed-in state that shows a short reassurance message (data-minimisation, no tracking)
- [ ] Add a signed-out state that stays useful without sign-in (no dead ends)
- [ ] Add/extend an API endpoint that confirms authenticated identity (e.g., `GET /api/whoami` or extend `GET /api/status`)
- [ ] Add API tests validating EasyAuth header parsing for user ID/name

## Dev Notes

- API currently reads identity via headers (`x-ms-client-principal-id`, `x-ms-client-principal-name`) in `apps/api/src/Functions/StatusFunction.cs`.
- Keep auth Entra-only (NFR6). Do not introduce custom account tables or signup flows.

