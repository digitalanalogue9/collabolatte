# Story 1.0: Document Infrastructure Provisioning (Bicep)

Status: ready-for-dev

## Story

As a delivery team,
I want a documented Bicep-based infrastructure plan in /infra,
So that we can provision Azure consistently when we are ready.

## Acceptance Criteria

1. **Given** infrastructure is not yet provisioned,
   **When** the /infra documentation is created,
   **Then** it defines the resources required for MVP (2x SWA, Storage Account, ACS),
   **And** it specifies naming conventions per Azure resource rules,
   **And** it lists required parameters (project, environment, region, identifier),
   **And** it documents Entra ID and EasyAuth setup steps.

2. **Given** the document exists,
   **When** a developer reviews /infra/README.md,
   **Then** they can follow it to implement Bicep later without ambiguity.

## Tasks / Subtasks

- [ ] Task 1: Create /infra directory structure (AC: 1, 2)
  - [ ] Create /infra/README.md as the main documentation file
  - [ ] Create /infra/parameters/ directory for environment parameter files (future)

- [ ] Task 2: Document Azure Resource Definitions (AC: 1)
  - [ ] Document Azure Static Web App (app+api) resource requirements
  - [ ] Document Azure Static Web App (marketing) resource requirements
  - [ ] Document Azure Storage Account resource requirements
  - [ ] Document Azure Communication Services resource requirements

- [ ] Task 3: Define Naming Conventions (AC: 1)
  - [ ] Document Azure resource naming rules and constraints
  - [ ] Define naming pattern: `{project}-{environment}-{resource}-{identifier}`
  - [ ] Document character limits and allowed characters per resource type

- [ ] Task 4: Document Required Parameters (AC: 1)
  - [ ] Define `project` parameter (collabolatte)
  - [ ] Define `environment` parameter (dev, staging, prod)
  - [ ] Define `region` parameter (default: uksouth)
  - [ ] Define `identifier` parameter (unique suffix for global resources)

- [ ] Task 5: Document Entra ID and EasyAuth Setup (AC: 1)
  - [ ] Document Entra ID app registration steps
  - [ ] Document EasyAuth configuration for SWA
  - [ ] Document required API permissions and scopes
  - [ ] Document redirect URIs configuration

- [ ] Task 6: Document Resource Dependencies (AC: 2)
  - [ ] Create dependency diagram (text-based)
  - [ ] Document deployment order requirements
  - [ ] Document post-deployment configuration steps

## Dev Notes

### Story Context

This is a **documentation-only** story. No Bicep code is written; the output is a comprehensive README.md that allows future implementation of Bicep templates without ambiguity.

### Critical Architecture Constraints

**From Architecture Document:**

1. **Two Azure Static Web Apps (Free tier):**
   - `app.collabolatte.co.uk` - SPA + API (Vite React + Azure Functions .NET isolated)
   - `www.collabolatte.co.uk` - Marketing site (11ty)

2. **Azure Storage Account:**
   - Table Storage for data (Memberships, Cycles, Matches, Events)
   - Partitioning by ProgrammeId
   - Azure.Data.Tables SDK 12.x

3. **Azure Communication Services:**
   - Email service only (Azure.Communication.Email 1.x)
   - No SMS in MVP

4. **MVP Cost Constraints (All-Free):**
   - Both SWAs on Free tier
   - No Key Vault (use app settings + GitHub Secrets)
   - No Application Insights (basic platform logs only)
   - Windows Consumption plan for Functions

5. **Entra ID Configuration:**
   - Single app registration for EasyAuth
   - Microsoft identity platform v2.0
   - User.Read scope minimum

### Azure Resource Naming Rules Reference

| Resource Type | Max Length | Allowed Characters | Scope |
|--------------|-----------|-------------------|-------|
| Static Web App | 40 | a-z, 0-9, - | Resource Group |
| Storage Account | 24 | a-z, 0-9 (no hyphens) | Global |
| Communication Services | 64 | a-z, 0-9, - | Resource Group |
| Resource Group | 90 | alphanumeric, -, _, ., () | Subscription |

### Suggested Naming Pattern

```
Pattern: {project}{env}{resource}{id}

Examples:
- Resource Group: collabolatte-dev-rg
- Static Web App (app): collabolatte-dev-swa-app
- Static Web App (marketing): collabolatte-dev-swa-www
- Storage Account: collabolattedevst001 (no hyphens, max 24 chars)
- Communication Services: collabolatte-dev-acs
```

### Entra ID Setup Requirements

1. **App Registration:**
   - Name: `collabolatte-{env}`
   - Supported account types: Single tenant (organisation directory only)
   - Platform: Single-page application

2. **Redirect URIs:**
   - `https://app.collabolatte.co.uk/.auth/login/aad/callback`
   - `http://localhost:4280/.auth/login/aad/callback` (local dev)

3. **API Permissions:**
   - Microsoft Graph: User.Read (delegated)

4. **Token Configuration:**
   - Optional claims: email, preferred_username

### SWA EasyAuth Configuration

The `staticwebapp.config.json` must include:

```json
{
  "auth": {
    "identityProviders": {
      "azureActiveDirectory": {
        "registration": {
          "openIdIssuer": "https://login.microsoftonline.com/{tenant-id}/v2.0",
          "clientIdSettingName": "AZURE_CLIENT_ID",
          "clientSecretSettingName": "AZURE_CLIENT_SECRET"
        }
      }
    }
  },
  "routes": [
    {
      "route": "/api/*",
      "allowedRoles": ["authenticated"]
    }
  ]
}
```

### Project Structure Notes

**Output Location:** `/infra/README.md`

This documentation will be created at the repository root level, not within the `/apps` directory structure.

```
collabolatte/
├── infra/
│   ├── README.md           # Main infrastructure documentation (THIS STORY)
│   └── parameters/         # Future: environment-specific parameter files
│       ├── dev.json
│       ├── staging.json
│       └── prod.json
├── apps/
│   ├── web/
│   ├── api/
│   └── marketing/
└── ...
```

### References

- [Source: _bmad-output/planning-artifacts/architecture.md#Starter Template Evaluation]
- [Source: _bmad-output/planning-artifacts/architecture.md#Infrastructure & Deployment]
- [Source: _bmad-output/planning-artifacts/architecture.md#Authentication & Security]
- [Source: _bmad-output/project-context.md#Technology Stack & Versions]
- [Source: _bmad-output/planning-artifacts/epics.md#Story 1.0]

### Trust & Privacy Considerations

While this is an infrastructure story, documentation must note:
- No individual-level analytics resources should be provisioned
- Storage account access must enforce programme-level isolation
- No behavioural tracking infrastructure

### Definition of Done

- [ ] /infra/README.md exists and is comprehensive
- [ ] All Azure resources are documented with naming conventions
- [ ] Entra ID setup steps are clear and complete
- [ ] A developer can read the document and implement Bicep without asking questions
- [ ] Document reviewed for accuracy against Architecture decisions

## Dev Agent Record

### Agent Model Used

(To be filled by implementing agent)

### Debug Log References

(To be filled during implementation)

### Completion Notes List

(To be filled during implementation)

### File List

- /infra/README.md (to be created)