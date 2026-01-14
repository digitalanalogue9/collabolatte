# Infrastructure (Bicep) - Plan and Runbook

## Purpose
Document the Azure infrastructure to be provisioned via Bicep. This is a planning and runbook document only; provisioning is not executed here.

## Scope (MVP)
- 2x Azure Static Web Apps (app+api, marketing)
- Azure Storage Account (Table Storage)
- Azure Communication Services (email)
- Entra ID app registration + EasyAuth wiring (documented; can be automated later)
- App settings and secrets stubs for SWA

## Naming Convention
Target pattern (human readable):
`{project}-{env}-{rtype}-{region}-{id}`

Notes:
- Not all Azure resources allow hyphens or mixed case.
- Some resources require global uniqueness and lowercase only.
- The storage account name must be 3-24 chars, lowercase letters and numbers only.

Suggested abbreviations:
- project: `collabolatte` -> `clt`
- env: `dev`, `test`, `prod`
- region: `uksouth` -> `uks`
- resource types:
  - resource group: `rg`
  - static web app (app): `swa-app`
  - static web app (marketing): `swa-mkt`
  - storage account: `st`
  - communication services: `acs`

Resource-specific name shaping:
- Resource group: `clt-{env}-rg-{region}-{id}`
- Static Web App: `clt-{env}-swa-app-{region}-{id}` and `clt-{env}-swa-mkt-{region}-{id}`
- Communication Services: `clt-{env}-acs-{region}-{id}`
- Storage account: `clt{env}st{region}{id}` (all lowercase, no hyphens)

## Parameters
- project: `clt`
- environment: `dev|test|prod`
- region: `uksouth`
- identifier: short unique suffix (e.g., `001`)

## Planned Bicep Structure (to be implemented)
- `infra/main.bicep`
  - Resource group (if deploying at subscription scope)
  - SWA app + api
  - SWA marketing
  - Storage account
  - Communication Services
  - Outputs for resource names and IDs
- `infra/params/{env}.bicepparam`
  - environment
  - region
  - identifier
  - project abbreviation

## Entra ID / EasyAuth
Documented steps:
1. Create Entra ID app registration for SWA auth.
2. Configure redirect URIs for SWA.
3. Add required app settings to SWA configuration.
4. Record client ID/tenant ID in secrets.

## App Settings (Stubs)
- `AzureWebJobsStorage`
- `TABLES_CONNECTION`
- `ACS_CONNECTION`
- `WEBSITE_RUN_FROM_PACKAGE` (if applicable)

## Deployment (Deferred)
This document defines the plan and naming rules. Provisioning will be done later using Bicep.
