# Story 1.4: Implement Bicep Templates

Status: done

## Story

As a delivery team, I want to convert the infrastructure documentation into Bicep templates, So that Azure resources can be provisioned consistently via infrastructure-as-code.

## Acceptance Criteria

1. **Given** the infrastructure documentation exists (Story 1.0), **When** Bicep templates are implemented, **Then** `/infra/main.bicep` defines all required resources:
   - 2x Azure Static Web Apps (app+api, marketing)
   - Azure Storage Account with Table Storage
   - Azure Communication Services resource
   - Resource Group

2. **Given** the Bicep templates exist, **When** a developer reviews the templates, **Then** parameter files exist for dev, staging, and prod environments, **And** naming conventions match the documented standards, **And** resource dependencies are correctly defined, **And** outputs include resource names and connection strings needed for app configuration.

3. **Given** the Bicep implementation is complete, **When** we validate the templates, **Then** `az bicep build` succeeds without errors, **And** templates follow Azure Bicep best practices, **And** `/infra/README.md` documents manual Entra ID app registration steps (cannot be automated).

## Tasks / Subtasks

- [x] Task 1: Create main.bicep with parameters and outputs (AC: 1, 2)
  - [x] Define all required parameters (project, environment, location, identifier)
  - [x] Define optional parameters (custom domains, Entra IDs)
  - [x] Create resource naming variables following documented conventions
  - [x] Define outputs for connection strings and resource names

- [x] Task 2: Create storage.bicep module (AC: 1, 2)
  - [x] Define Storage Account resource with proper configuration
  - [x] Follow naming convention: {project}{environment}st{identifier}
  - [x] Set Standard_LRS, StorageV2, Hot, TLS1_2
  - [x] Output storage account name and connection string

- [x] Task 3: Create acs.bicep module (AC: 1, 2)
  - [x] Define Azure Communication Services resource
  - [x] Follow naming convention: {project}-{environment}-acs
  - [x] Set data location to UK
  - [x] Output ACS connection string

- [x] Task 4: Create swa.bicep module (AC: 1, 2)
  - [x] Define Static Web App resource (parameterized)
  - [x] Support both app (with API) and marketing (public) variants
  - [x] Follow naming convention: {project}-{environment}-swa-{variant}
  - [x] Set Free SKU, UK South location
  - [x] Configure build paths per architecture (app_location, api_location, output_location)
  - [x] Output SWA hostname and deployment token

- [x] Task 5: Wire up modules in main.bicep (AC: 2)
  - [x] Reference storage.bicep module
  - [x] Reference acs.bicep module
  - [x] Reference swa.bicep module twice (app and marketing)
  - [x] Define resource dependencies correctly
  - [x] Pass through all outputs

- [x] Task 6: Create parameter files for dev/staging/prod (AC: 2)
  - [x] Create infra/parameters/dev.json
  - [x] Create infra/parameters/staging.json
  - [x] Create infra/parameters/prod.json
  - [x] Follow documented parameter structure from README

- [x] Task 7: Validate Bicep templates (AC: 3)
  - [x] Run `az bicep build --file infra/main.bicep`
  - [x] Fix any validation errors
  - [x] Verify naming conventions match documentation
  - [x] Verify outputs are complete

- [x] Task 8: Update README with deployment instructions (AC: 3)
  - [x] Document how to deploy using Bicep
  - [x] Document manual Entra ID app registration steps
  - [x] Document post-deployment configuration steps
  - [x] Include examples of deployment commands

## Dev Notes

### Story Context

This story converts the infrastructure documentation (Story 1.0) into executable Bicep templates. It creates infrastructure-as-code that can be deployed via GitHub Actions (Story 1.5) or manually via Azure CLI.

### Critical Architecture Constraints

**From Infrastructure Documentation:**

#### Resource Naming Conventions

```
Pattern: {project}-{environment}-{resource}-{identifier}

Examples:
- Resource Group: collabolatte-dev-rg
- SWA App: collabolatte-dev-swa-app
- SWA Marketing: collabolatte-dev-swa-www
- Storage: collabolattedevst001 (NO hyphens - Azure restriction)
- ACS: collabolatte-dev-acs
```

#### Required Azure Resources

| Resource | SKU/Tier | Configuration |
|----------|----------|---------------|
| Resource Group | N/A | Contains all resources |
| Static Web App (App) | Free | app_location: apps/web, api_location: apps/api, output: dist |
| Static Web App (Marketing) | Free | app_location: apps/marketing, output: dist |
| Storage Account | Standard_LRS | StorageV2, Hot tier, TLS1.2, HTTPS only |
| Communication Services | Standard | Data location: UK, Email only |

#### Resource Dependencies

```
1. Resource Group (first)
2. Storage Account (depends on RG)
3. Communication Services (depends on RG)
4. Static Web Apps (depends on RG, can reference Storage/ACS)
```

#### Bicep Modular Structure

```
infra/
├── main.bicep           # Main orchestrator
├── modules/
│   ├── swa.bicep        # Static Web App module (reusable)
│   ├── storage.bicep    # Storage Account module
│   └── acs.bicep        # Communication Services module
└── parameters/
    ├── dev.json
    ├── staging.json
    └── prod.json
```

### Technology Versions

| Technology | Version | Notes |
|------------|---------|-------|
| Bicep | Latest | Azure CLI includes Bicep |
| Azure CLI | 2.x | For deployment and validation |

### Dependencies on Previous Stories

- **Story 1.0**: Infrastructure documentation complete
- No other dependencies - this is pure infrastructure definition

### Testing Notes

**Bicep Validation:**
- Run `az bicep build --file infra/main.bicep` to validate syntax
- Run `az bicep lint --file infra/main.bicep` for best practices
- Use `--what-if` flag to preview changes without deploying

**Local Development:**
- No local Azure resources needed
- Validation can be done offline with Bicep CLI

### Trust & Privacy Considerations

**Explicitly Excluded:**
- Application Insights (no behavioural analytics)
- Key Vault (MVP uses app settings)
- Cosmos DB (Table Storage enforces PartitionKey isolation)

**Trust Guardrails:**
- Storage partitioning by ProgrammeId enforced at query level (not infrastructure)
- No cross-programme data access possible
- All resources within Free tier to prevent runaway costs

### Definition of Done

- [x] `/infra/main.bicep` exists and validates successfully
- [x] Module files exist: `storage.bicep`, `acs.bicep`, `swa.bicep`
- [x] Parameter files exist for dev/staging/prod in `parameters/` folder
- [x] `az bicep build` succeeds without errors
- [x] `az bicep lint` shows no critical issues
- [x] Naming conventions match documented standards
- [x] All outputs defined (connection strings, resource names)
- [x] README updated with deployment instructions
- [x] Manual Entra ID steps documented in README

## Dev Agent Record

### Agent Model Used

Claude Sonnet 4.5

### Debug Log References

N/A

### Completion Notes List

- Created modular Bicep structure with reusable modules
- All naming conventions follow documented standards from Story 1.0
- Storage module includes Table Storage service configuration
- ACS module configured for UK data location (compliance)
- SWA module is reusable for both app and marketing variants
- Main template orchestrates all resources with proper parameter flow
- Parameter files created for all three environments (dev, staging, prod)
- Validation successful - `az bicep build` passes with only expected secret warnings
- Secrets properly marked with `@secure()` decorator in main.bicep
- README updated with comprehensive deployment instructions and quick start guide
- Bicep linter warnings reviewed - only expected warnings about outputting secrets (intentional)
- All outputs include connection strings and deployment tokens needed for CI/CD

### Change Log

| Date | Change |
|------|--------|
| 2026-01-16 | Created implementation artifact for Story 1.4 |
| 2026-01-16 | Implemented all Bicep templates and modules |
| 2026-01-16 | Created parameter files for dev/staging/prod |
| 2026-01-16 | Validated templates with az bicep build and lint |
| 2026-01-16 | Updated README with deployment instructions |

### File List

**Bicep Templates:**
- `infra/main.bicep` - Main orchestration template (targetScope: resourceGroup)
- `infra/modules/storage.bicep` - Storage Account module
- `infra/modules/acs.bicep` - Azure Communication Services module
- `infra/modules/swa.bicep` - Static Web App module (reusable)

**Parameter Files:**
- `infra/parameters/dev.json` - Development environment parameters
- `infra/parameters/staging.json` - Staging environment parameters
- `infra/parameters/prod.json` - Production environment parameters (with custom domains)

**Documentation:**
- `infra/README.md` - Updated with deployment instructions, quick start, and Bicep structure
