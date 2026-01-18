# Story 1.5: Deploy Infrastructure via Bicep

Status: done

## Story

As a delivery team, I want to deploy Azure infrastructure using Bicep via a GitHub Actions workflow,
So that infrastructure changes are version-controlled and automated.

## Acceptance Criteria

1. **Given** Bicep templates exist (Story 1.4), **When** we create the infrastructure deployment
   workflow, **Then** `.github/workflows/infra-deploy.yml` exists, **And** it uses Azure CLI to
   deploy Bicep templates, **And** it is triggered manually or on changes to `/infra/**`, **And** it
   uses a service principal configured in GitHub Secrets.

2. **Given** the workflow is configured, **When** we deploy to the dev environment, **Then** all
   Azure resources are provisioned successfully, **And** resources follow documented naming
   conventions, **And** deployment outputs are captured and displayed, **And** deployment is
   idempotent (can be run multiple times safely).

3. **Given** infrastructure is deployed, **When** we complete manual Entra ID app registration,
   **Then** the app registration is documented in `/infra/README.md`, **And** Client ID, Client
   Secret, and Tenant ID are added to GitHub Secrets, **And** SWA app settings are configured with
   Entra ID values.

## Tasks / Subtasks

- [x] Task 1: Create infrastructure deployment workflow (AC: 1)
  - [x] Create `.github/workflows/infra-deploy.yml`
  - [x] Configure workflow triggers (manual + path filter)
  - [x] Add Azure login step using service principal
  - [x] Add Bicep deployment step
  - [x] Configure workflow inputs for environment selection

- [x] Task 2: Document GitHub Secrets for Azure deployment (AC: 1, 3)
  - [x] Document required secrets in README
  - [x] Document service principal creation
  - [x] Document Azure subscription details needed
  - [x] Document Entra ID app registration (already existed in README)

- [x] Task 3: Deploy infrastructure to dev environment (AC: 2)
  - [x] Create Azure resource group manually
  - [x] Create and configure Azure service principal
  - [x] Add GitHub Secrets (AZURE_CREDENTIALS, AZURE_SUBSCRIPTION_ID)
  - [x] Run workflow with dev parameters
  - [x] Verify all resources created successfully
  - [x] Verify naming conventions followed
  - [x] Capture deployment outputs
  - [x] Test idempotency (run deployment again)

- [x] Task 4: Manual Entra ID app registration (AC: 3)
  - [x] Create Entra ID app registration in Azure Portal
  - [x] Configure redirect URIs for all environments
  - [x] Configure API permissions (User.Read)
  - [x] Create client secret
  - [x] Add Entra ID values to GitHub Secrets
  - [x] Configure SWA app settings with Entra ID values

- [x] Task 5: Verify infrastructure deployment (AC: 2, 3)
  - [x] Confirm all resources exist in Azure Portal
  - [x] Verify resource group naming
  - [x] Verify SWA configuration
  - [x] Verify Storage Account access
  - [x] Verify ACS resource provisioned
  - [x] Confirm deployment matches architecture specifications

## Dev Notes

### Story Context

This story deploys the infrastructure defined in Story 1.4 using GitHub Actions automation. It
creates a repeatable, version-controlled infrastructure deployment process separate from application
deployment.

### Critical Architecture Constraints

**From Architecture Document:**

#### Infrastructure Deployment Pattern

- **Separation of Concerns**: Infrastructure deployment (Story 1.5) is separate from application
  deployment (Story 1.6)
- **Idempotency**: Bicep deployments can be run multiple times safely
- **Service Principal**: GitHub Actions uses Azure service principal for authentication
- **Manual Steps**: Entra ID app registration cannot be fully automated via Bicep

#### Security Considerations

- Service principal credentials stored in GitHub Secrets
- Least privilege: service principal needs only Contributor role on resource group
- Entra ID credentials (Client ID, Secret, Tenant ID) stored separately
- Never commit secrets to repository

### Technology Versions

| Technology     | Version | Notes                                 |
| -------------- | ------- | ------------------------------------- |
| Azure CLI      | Latest  | Included in GitHub-hosted runners     |
| Bicep          | Latest  | Via Azure CLI                         |
| GitHub Actions | N/A     | GitHub-hosted runners (ubuntu-latest) |

### Workflow Structure

```yaml
name: Deploy Infrastructure
on:
  workflow_dispatch: # Manual trigger
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        type: choice
        options:
          - dev
          - staging
          - prod
  push:
    branches:
      - main
    paths:
      - 'infra/**'
      - '.github/workflows/infra-deploy.yml'
```

### Required GitHub Secrets

| Secret Name             | Description                | Source                          |
| ----------------------- | -------------------------- | ------------------------------- |
| `AZURE_CREDENTIALS`     | Service principal JSON     | Azure Portal (App Registration) |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID      | Azure Portal                    |
| `AZURE_TENANT_ID`       | Entra ID tenant ID         | Azure Portal                    |
| `ENTRA_CLIENT_ID`       | Entra ID app client ID     | Manual app registration         |
| `ENTRA_CLIENT_SECRET`   | Entra ID app client secret | Manual app registration         |

### Deployment Command

```bash
az deployment group create \
  --resource-group rg-collabolatte-dev-uks \
  --template-file infra/main.bicep \
  --parameters infra/parameters/dev.bicepparam \
  --verbose
```

### Testing Notes

**Local Testing (Optional):**

- Can test Bicep syntax with `az bicep build --file infra/main.bicep`
- Cannot test actual deployment locally (requires Azure permissions)
- Use what-if mode: `az deployment group what-if ...`

**CI Testing:**

- Workflow will fail if service principal lacks permissions
- Workflow will fail if Bicep templates have errors
- First deployment creates resources; subsequent runs update them

### Trust & Privacy Considerations

- No user data involved in this story (infrastructure only)
- Sx] Infrastructure deployment workflow exists at `.github/workflows/infra-deploy.yml`
- [x] GitHub Secrets documented in `/infra/README.md`
- [x] Entra ID app registration documented in `/infra/README.md`
- [x] Azure resource group created
- [x] Service principal created and configured in GitHub Secrets
- [x] Workflow runs successfully (manual or automatic trigger)
- [x] Dev environment resources exist in Azure
- [x] All resources follow naming conventions from architecture
- [x] Entra ID app registration completed manuallys at `.github/workflows/infra-deploy.yml`
- [x] Workflow runs successfully (manual or automatic trigger)
- [x] Dev environment resources exist in Azure
- [x] All resources follow naming conventions from architecture
- [x] Entra ID app registration documented in `/infra/README.md`
- [x] GitHub Secrets documented and configured
- [x] Infrastructure is ready for application deployment (Story 1.6)

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.5 (via GitHub Copilot)

### Debug Log References

N/A

### Completion Notes List

(To be filled during implementation)

### Change Log

| Date       | Change                                    |
| ---------- | ----------------------------------------- |
| 2026-01-16 | Story 1.5 implementation artifact created |

### File List

(To be populated as files are created)
