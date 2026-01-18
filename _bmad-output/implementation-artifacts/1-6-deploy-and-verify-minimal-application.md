# Story 1.6: Deploy and Verify Minimal Application

Status: in-progress

## Story

As a delivery team, I want to deploy a minimal "hello world" application to the provisioned
infrastructure, So that we can verify the end-to-end pipeline works before Epic 2 feature
development.

## Acceptance Criteria

1. **Given** infrastructure is provisioned (Story 1.5), **When** we push code to the main branch,
   **Then** the SWA deployment workflows (from Story 1.1) deploy successfully, **And** both app+api
   and marketing sites are deployed, **And** deployment logs show no errors.

2. **Given** the application is deployed, **When** we access the deployed app URL, **Then** we can
   authenticate via Entra ID (EasyAuth), **And** we see a minimal "hello world" page confirming
   deployment, **And** the authenticated state is visible (user name/email displayed).

3. **Given** the deployment is verified, **When** we test API connectivity, **Then** an
   authenticated API endpoint responds successfully, **And** the API can connect to Table Storage
   (connection test, no data operations yet), **And** the API can verify ACS configuration
   (configuration test, no actual email sent).

4. **Given** all verification tests pass, **When** we review the deployment, **Then** all
   infrastructure costs remain within free tier limits, **And** the deployment matches architecture
   specifications, **And** developers can now work on Epic 2 features without infrastructure
   blockers.

## Tasks / Subtasks

- [ ] Task 1: Create minimal web app page showing auth status (AC: 2)
  - [ ] Update HomePage to display authenticated user info
  - [ ] Show user name/email from EasyAuth headers
  - [ ] Add "Hello World" confirmation message
  - [ ] Style using Sage Calm theme components

- [ ] Task 2: Create API health/status endpoint (AC: 3)
  - [ ] Create /api/status function endpoint
  - [ ] Verify authentication via EasyAuth headers
  - [ ] Test Table Storage connection
  - [ ] Test ACS configuration
  - [ ] Return status JSON response

- [ ] Task 3: Review and update SWA deployment workflows (AC: 1)
  - [ ] Verify app+api workflow exists from Story 1.1
  - [ ] Verify marketing workflow exists from Story 1.1
  - [ ] Add environment variables for Storage/ACS connections
  - [ ] Ensure workflows trigger on push to main

- [ ] Task 4: Deploy to dev environment (AC: 1)
  - [ ] Push changes to main branch
  - [ ] Monitor GitHub Actions workflow execution
  - [ ] Verify app+api deployment succeeds
  - [ ] Verify marketing deployment succeeds
  - [ ] Capture deployment URLs

- [ ] Task 5: Manual verification testing (AC: 2, 3)
  - [ ] Access deployed app URL
  - [ ] Authenticate via Entra ID
  - [ ] Verify user info displayed correctly
  - [ ] Test /api/status endpoint
  - [ ] Verify Table Storage connection test passes
  - [ ] Verify ACS configuration test passes

- [ ] Task 6: Document deployment verification (AC: 4)
  - [ ] Document deployment URLs
  - [ ] Confirm free tier usage
  - [ ] Update epic status to complete
  - [ ] Confirm Epic 2 is unblocked

## Dev Notes

### Story Context

This story proves the end-to-end deployment pipeline works before starting feature development. It's
purely infrastructure validation—no user-facing features yet.

### Critical Architecture Constraints

**From Architecture Document:**

#### Authentication Flow

- **EasyAuth at Platform Level**: No custom auth code in application
- **User Claims via Headers**: `x-ms-client-principal-name`, `x-ms-client-principal-id`,
  `x-ms-client-principal`
- **Validation Required**: User claims from headers are untrusted—validate at API boundaries

#### Minimal Verification Requirements

- **Web App**: Display authenticated user info to prove EasyAuth works
- **API**: Respond to authenticated requests to prove Functions integration works
- **Storage**: Connect to Table Storage to prove SDK and connection string work
- **ACS**: Verify configuration to prove email service is accessible (no actual email)

### Technology Versions

| Technology                 | Version | Notes                           |
| -------------------------- | ------- | ------------------------------- |
| React                      | 18.x    | From Story 1.1 scaffolding      |
| .NET                       | 10.x    | Azure Functions isolated worker |
| Azure Functions Core Tools | 4.x     | For local testing               |
| Azure Static Web Apps CLI  | Latest  | For local SWA emulation         |

### Implementation Notes

**Web App Changes:**

- Update `apps/web/src/pages/HomePage.tsx` (or create if needed)
- Use `AppLayout`, `AppHeader` components from Story 1.3
- Display user info from EasyAuth claims
- Simple, calm design matching Sage Calm theme

**API Changes:**

- Create `apps/api/src/Functions/StatusFunction.cs`
- Return JSON with connection test results
- Use Azure.Data.Tables SDK for Storage test
- Use Azure.Communication.Email SDK for ACS test

**Connection Strings:**

- Storage: `AzureWebJobsStorage` environment variable (set by SWA)
- ACS: `ACS_CONNECTION_STRING` environment variable (configure in SWA settings)

### Testing Strategy

**Local Testing:**

- Use SWA CLI to test locally:
  `swa start http://localhost:5173 --api-location http://localhost:7071`
- Use Functions emulator: `func start` in `apps/api/src`
- Use local.settings.json for connection strings (not committed)

**Deployed Testing:**

- Manual verification of deployed URLs
- Test authentication flow end-to-end
- Verify API responds to authenticated requests
- Check Azure Portal for deployed resources

## Definition of Done

- [x] Minimal web page created showing authenticated user info
- [x] API status endpoint created and tested locally
- [x] SWA workflows verified and updated with environment variables
- [ ] Application deployed successfully to dev environment
- [ ] Manual verification tests pass:
  - [ ] Can authenticate via Entra ID
  - [ ] User info displayed correctly
  - [ ] API status endpoint responds
  - [ ] Table Storage connection verified
  - [ ] ACS configuration verified
- [ ] Deployment matches architecture specifications
- [ ] Free tier costs confirmed
- [ ] Epic 1 marked complete
- [ ] Epic 2 confirmed unblocked

## References

- [Architecture Document](../_bmad-output/planning-artifacts/architecture/)
- [Project Context](../_bmad-output/project-context.md)
- [Infrastructure README](../../infra/README.md)
- [Azure Static Web Apps Docs](https://learn.microsoft.com/azure/static-web-apps/)
- [EasyAuth Headers](https://learn.microsoft.com/azure/static-web-apps/user-information)
