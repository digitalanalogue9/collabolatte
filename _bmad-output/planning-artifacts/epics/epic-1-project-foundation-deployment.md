# Epic 1: Project Foundation & Deployment

Establish the technical foundation, deploy to Azure, and verify the end-to-end pipeline works before implementing features.

**FRs covered:** None (foundational infrastructure)
**NFR Focus:** NFR7 (deployment automation), NFR8 (operational requirements), NFR16 (maintainability)

**Epic 1 Purpose:** Create the project scaffolding, provision Azure infrastructure, and establish CI/CD so that feature development (Epic 2+) can proceed without infrastructure blockers.

**Success Criteria:**

- Monorepo structure is established with web (React/Vite), API (.NET Functions), and marketing (11ty) apps
- Azure infrastructure is provisioned (2x Static Web Apps, Storage Account, Azure Communication Services)
- Entra ID authentication is configured at the platform level
- CI/CD pipelines deploy to Azure successfully
- A minimal "hello world" application is deployed and accessible in dev environment
- Developers can run all projects locally without additional scaffolding

---

## Story 1.0: Document infrastructure provisioning (Bicep)

As a delivery team,
I want a documented Bicep-based infrastructure plan in /infra,
So that we can provision Azure consistently when we are ready.

**Acceptance Criteria:**

**Given** infrastructure is not yet provisioned,
**When** the /infra documentation is created,
**Then** it defines the resources required for MVP (2x SWA, Storage Account, ACS),
**And** it specifies naming conventions per Azure resource rules,
**And** it lists required parameters (project, environment, region, identifier),
**And** it documents Entra ID and EasyAuth setup steps.

**Given** the document exists,
**When** a developer reviews /infra/README.md,
**Then** they can follow it to implement Bicep later without ambiguity.

**Status:** ✅ Complete (review)

---

## Story 1.1: Set up initial project from starter template

As a delivery team,
I want to set up the initial project from the approved starter templates,
So that Join & Trust stories can be implemented without blocking setup work.

**Acceptance Criteria:**

**Given** the starter templates are approved in Architecture,
**When** we initialise the project,
**Then** the repo is scaffolded as a monorepo with `/apps/web`, `/apps/api`, and `/apps/marketing`,
**And** the web app is created from the official Vite React TypeScript template,
**And** the API is initialised with Azure Functions (.NET isolated),
**And** the marketing site is initialised with 11ty.

**Given** the scaffolding exists,
**When** baseline configuration is applied,
**Then** `staticwebapp.config.json` and SWA workflow stubs exist for app+api and marketing,
**And** Entra ID auth wiring is configured at the platform level (no custom auth code),
**And** storage connection placeholders are defined for local and cloud environments.

**Given** the foundations are in place,
**When** a developer starts work on Epic 2 stories,
**Then** they can run the web and API projects locally without additional scaffolding.

**Status:** 🔄 In Progress

---

## Story 1.2: Implement Bicep templates

As a delivery team,
I want to convert the infrastructure documentation into Bicep templates,
So that Azure resources can be provisioned consistently via infrastructure-as-code.

**Acceptance Criteria:**

**Given** the infrastructure documentation exists (Story 1.0),
**When** Bicep templates are implemented,
**Then** `/infra/main.bicep` defines all required resources:

- 2x Azure Static Web Apps (app+api, marketing)
- Azure Storage Account with Table Storage
- Azure Communication Services resource
- Resource Group

**Given** the Bicep templates exist,
**When** a developer reviews the templates,
**Then** parameter files exist for dev, staging, and prod environments,
**And** naming conventions match the documented standards,
**And** resource dependencies are correctly defined,
**And** outputs include resource names and connection strings needed for app configuration.

**Given** the Bicep implementation is complete,
**When** we validate the templates,
**Then** `az bicep build` succeeds without errors,
**And** templates follow Azure Bicep best practices,
**And** `/infra/README.md` documents manual Entra ID app registration steps (cannot be automated).

**Technical Notes:**

- Bicep templates define infrastructure declaratively
- Entra ID app registration remains manual (documented steps in README)
- Parameter files allow environment-specific configuration
- Outputs make connection strings available to application deployment

**Definition of Done:**

- `/infra/main.bicep` exists and validates successfully
- Parameter files exist for dev/staging/prod
- README documents deployment process and manual Entra ID steps
- Templates follow Azure naming conventions
- No hardcoded values; all configuration via parameters

**Status:** ⏸️ Not Started

---

## Story 1.3: Deploy infrastructure via Bicep

As a delivery team,
I want to deploy Azure infrastructure using Bicep via a GitHub Actions workflow,
So that infrastructure changes are version-controlled and automated.

**Acceptance Criteria:**

**Given** Bicep templates exist (Story 1.2),
**When** we create the infrastructure deployment workflow,
**Then** `.github/workflows/infra-deploy.yml` exists,
**And** it uses Azure CLI to deploy Bicep templates,
**And** it is triggered manually or on changes to `/infra/**`,
**And** it uses a service principal configured in GitHub Secrets.

**Given** the workflow is configured,
**When** we deploy to the dev environment,
**Then** all Azure resources are provisioned successfully,
**And** resources follow documented naming conventions,
**And** deployment outputs are captured and displayed,
**And** deployment is idempotent (can be run multiple times safely).

**Given** infrastructure is deployed,
**When** we complete manual Entra ID app registration,
**Then** the app registration is documented in `/infra/README.md`,
**And** Client ID, Client Secret, and Tenant ID are added to GitHub Secrets,
**And** SWA app settings are configured with Entra ID values.

**Technical Notes:**

- Infrastructure deployment is separate from application deployment
- Use `az deployment group create --template-file infra/main.bicep`
- Service principal needs Contributor role on subscription/resource group
- Entra ID app registration is manual (cannot be fully automated via Bicep)
- This workflow runs infrequently (only when infrastructure changes)

**Definition of Done:**

- Infrastructure deployment workflow exists and runs successfully
- Dev environment resources exist in Azure
- All resources follow naming conventions
- Entra ID app registration completed manually
- GitHub Secrets configured with deployment tokens and Entra ID values
- Infrastructure is ready for application deployment

**Status:** ⏸️ Not Started

---

## Story 1.4: Deploy and verify minimal application

As a delivery team,
I want to deploy a minimal "hello world" application to the provisioned infrastructure,
So that we can verify the end-to-end pipeline works before Epic 2 feature development.

**Acceptance Criteria:**

**Given** infrastructure is provisioned (Story 1.3),
**When** we push code to the main branch,
**Then** the SWA deployment workflows (from Story 1.1) deploy successfully,
**And** both app+api and marketing sites are deployed,
**And** deployment logs show no errors.

**Given** the application is deployed,
**When** we access the deployed app URL,
**Then** we can authenticate via Entra ID (EasyAuth),
**And** we see a minimal "hello world" page confirming deployment,
**And** the authenticated state is visible (user name/email displayed).

**Given** the deployment is verified,
**When** we test API connectivity,
**Then** an authenticated API endpoint responds successfully,
**And** the API can connect to Table Storage (connection test, no data operations yet),
**And** the API can verify ACS configuration (configuration test, no actual email sent).

**Given** all verification tests pass,
**When** we review the deployment,
**Then** all infrastructure costs remain within free tier limits,
**And** the deployment matches architecture specifications,
**And** developers can now work on Epic 2 features without infrastructure blockers.

**Technical Notes:**

- Create minimal test components/endpoints to verify connections
- No user-facing features yet - purely infrastructure validation
- Test authentication flow end-to-end
- Verify storage and ACS SDK connections work
- This proves the pipeline before building Join & Trust features (Epic 2)

**Definition of Done:**

- Application deploys successfully via GitHub Actions
- Can authenticate and see minimal page at deployed URL
- API endpoint responds to authenticated requests
- Table Storage connection verified
- ACS connection verified
- No infrastructure blockers for Epic 2 development

**Status:** ⏸️ Not Started

---

## Epic 1 Completion Checklist

- [x] Infrastructure documented (Story 1.0)
- [ ] Project scaffolding complete (Story 1.1)
- [ ] Bicep templates implemented (Story 1.2)
- [ ] Infrastructure deployed via Bicep workflow (Story 1.3)
- [ ] Minimal app deployed and verified (Story 1.4)
- [ ] End-to-end pipeline proven (Story 1.4)
- [ ] Developers can work on Epic 2 without infrastructure blockers

---

## Epic 1 Dependencies

**Prerequisites:**

- Architecture document complete (defines tech stack, infrastructure, conventions)
- Azure subscription with permissions to create resources
- GitHub repository with Actions enabled
- Entra ID tenant access for app registration

**Blocks:**

- Epic 2 (Join & Trust) blocked until Epic 1 complete

**Notes:**

- This epic intentionally avoids feature development
- Focus is purely on technical foundation and deployment verification
- All trust-critical features (join, matching, etc.) deferred to Epic 2+
