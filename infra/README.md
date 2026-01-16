# Collabolatte Infrastructure Documentation

This document provides the complete infrastructure specification for provisioning Collabolatte on
Azure. It serves as the authoritative reference for implementing Bicep templates.

## Table of Contents

1. [Deployment Instructions](#deployment-instructions)
2. [Overview](#overview)
3. [Azure Resources](#azure-resources)
4. [Naming Conventions](#naming-conventions)
5. [Parameters](#parameters)
6. [Entra ID and EasyAuth Setup](#entra-id-and-easyauth-setup)
7. [Resource Dependencies](#resource-dependencies)
8. [Post-Deployment Configuration](#post-deployment-configuration)
9. [Bicep Structure](#bicep-structure)

---

## Deployment Instructions

### Prerequisites

Before deploying, ensure you have:

- Azure CLI installed (`az --version` should show 2.x or later)
- Bicep CLI installed (included with Azure CLI)
- Appropriate Azure permissions (Contributor role on subscription or resource group)
- An Azure subscription

### Quick Start

**1. Deploy Infrastructure (creates resource group automatically)**

```bash
# Set environment (dev, staging, or prod)
ENVIRONMENT=dev
PROJECT=collabolatte
LOCATION=uksouth

# Deploy using parameter file (resource group created automatically)
az deployment sub create \
  --location ${LOCATION} \
  --template-file infra/main.bicep \
  --parameters infra/parameters/${ENVIRONMENT}.json

# OR deploy with inline parameters
az deployment sub create \
  --location ${LOCATION} \
  --template-file infra/main.bicep \
  --parameters \
    project=${PROJECT} \
    environment=${ENVIRONMENT} \
    location=${LOCATION} \
    identifier=001
```

**2. Review Deployment Outputs**

```bash
# Get deployment outputs (includes connection strings and URLs)
az deployment sub show \
  --location ${LOCATION} \
  --name main \
  --query properties.outputs
```

**3. Configure Entra ID** (see [Entra ID and EasyAuth Setup](#entra-id-and-easyauth-setup))

**4. Post-Deployment Configuration** (see
[Post-Deployment Configuration](#post-deployment-configuration))

### Deployment Commands

#### Validate Before Deploying

```bash
# Validate Bicep syntax
az bicep build --file infra/main.bicep

# Lint for best practices
az bicep lint --file infra/main.bicep

# Preview changes (what-if)
az deployment sub what-if \
  --location ${LOCATION} \
  --template-file infra/main.bicep \
  --parameters infra/parameters/${ENVIRONMENT}.json
```

#### Deploy to Specific Environments

```bash
# Development
az deployment sub create \
  --location uksouth \
  --template-file infra/main.bicep \
  --parameters infra/parameters/dev.json

# Staging
az deployment sub create \
  --location uksouth \
  --template-file infra/main.bicep \
  --parameters infra/parameters/staging.json

# Production
az deployment sub create \
  --location uksouth \
  --template-file infra/main.bicep \
  --parameters infra/parameters/prod.json
```

#### Update Parameter Files

Before deploying, update the parameter files with your values:

- `infra/parameters/dev.json` - Development environment
- `infra/parameters/staging.json` - Staging environment
- `infra/parameters/prod.json` - Production environment

**Required changes:**

- `repositoryUrl`: Update with your GitHub repository URL
- `repositoryBranch`: Usually `main` (default)
- Custom domains (prod only): Update if you have custom domains configured

### Important Notes

- **Entra ID Configuration**: App registration and client secret must be configured manually after
  deployment (see [Entra ID and EasyAuth Setup](#entra-id-and-easyauth-setup))
- **Custom Domains**: DNS records must be configured separately (see
  [Post-Deployment Configuration](#post-deployment-configuration))
- **Connection Strings**: Deployment outputs contain sensitive connection strings - store securely
  in GitHub Secrets or Azure Key Vault
- **Free Tier**: All resources use free tier by default to minimize costs
- **Idempotency**: Deployments are idempotent - running multiple times is safe

---

## Overview

Collabolatte is deployed as a serverless application on Azure using the following architecture:

- **Resource Group** (created automatically per environment)
- **Two Azure Static Web Apps** (Free tier) for hosting the SPA + API and marketing site
- **Azure Storage Account** with Table Storage for data persistence
- **Azure Communication Services** for email notifications
- **Microsoft Entra ID** for authentication via EasyAuth

All infrastructure is deployed using **Azure Verified Modules (AVM)** from the public registry,
ensuring best practices and Microsoft-verified patterns.

### MVP Cost Constraints (All-Free Tier)

| Constraint           | Decision                                            |
| -------------------- | --------------------------------------------------- |
| Static Web Apps      | Free tier (both instances)                          |
| Key Vault            | Not used in MVP (use app settings + GitHub Secrets) |
| Application Insights | Not used in MVP (basic platform logs only)          |
| Functions Plan       | Windows Consumption (included with SWA)             |

---

## Azure Resources

### Resource Group

| Property | Value                                         |
| -------- | --------------------------------------------- |
| Purpose  | Contains all Collabolatte resources           |
| Location | UK South (default)                            |
| Tags     | `project: collabolatte`, `environment: {env}` |

### Static Web App - Application (SPA + API)

| Property            | Value                         |
| ------------------- | ----------------------------- |
| SKU                 | Free                          |
| Location            | UK South                      |
| Custom Domain       | `app.collabolatte.co.uk`      |
| Repository          | GitHub (collabolatte repo)    |
| Branch              | `main`                        |
| Build Configuration |                               |
| - app_location      | `apps/web`                    |
| - api_location      | `apps/api`                    |
| - output_location   | `dist`                        |
| Identity Provider   | Microsoft Entra ID (EasyAuth) |

**Purpose:** Hosts the React SPA and Azure Functions API (.NET isolated worker).

### Static Web App - Marketing

| Property            | Value                      |
| ------------------- | -------------------------- |
| SKU                 | Free                       |
| Location            | UK South                   |
| Custom Domain       | `www.collabolatte.co.uk`   |
| Repository          | GitHub (collabolatte repo) |
| Branch              | `main`                     |
| Build Configuration |                            |
| - app_location      | `apps/marketing`           |
| - output_location   | `dist`                     |
| Identity Provider   | None (public site)         |

**Purpose:** Hosts the 11ty static marketing site.

### Storage Account

| Property                 | Value        |
| ------------------------ | ------------ |
| SKU                      | Standard_LRS |
| Kind                     | StorageV2    |
| Access Tier              | Hot          |
| Minimum TLS Version      | TLS1_2       |
| Allow Blob Public Access | false        |
| HTTPS Only               | true         |

**Table Storage Entities:**

| Table Name  | PartitionKey | RowKey                  | Purpose                                 |
| ----------- | ------------ | ----------------------- | --------------------------------------- |
| Memberships | ProgrammeId  | UserId                  | Programme membership records            |
| Cycles      | ProgrammeId  | CycleDate (ISO)         | Matching cycle records                  |
| Matches     | ProgrammeId  | MatchId (deterministic) | Match records                           |
| Events      | ProgrammeId  | Timestamp+Guid          | System event logs (optional)            |
| Roles       | "roles"      | UserId                  | Role allowlist (Admin, Programme Owner) |

**Data Isolation Rule:** Every query MUST include ProgrammeId as PartitionKey to enforce
programme-level data isolation. Cross-partition scans are prohibited.

### Azure Communication Services

| Property      | Value                         |
| ------------- | ----------------------------- |
| Data Location | UK                            |
| Service Type  | Email only                    |
| SDK           | Azure.Communication.Email 1.x |

**Email Domain Configuration:**

- Configure a verified sender domain or use Azure-managed domain
- Sender address: `noreply@collabolatte.co.uk` (or Azure-managed equivalent)

**Note:** SMS is not used in MVP. Teams notifications are additive; email is the authoritative
channel.

---

## Naming Conventions

### Pattern

```
{project}-{environment}-{resource}-{identifier}
```

Where:

- `{project}` = `collabolatte`
- `{environment}` = `dev` | `staging` | `prod`
- `{resource}` = Resource type abbreviation
- `{identifier}` = Optional unique suffix (required for globally-scoped resources)

### Resource Naming Rules

| Resource Type          | Abbreviation | Max Length | Allowed Characters     | Scope          | Example                    |
| ---------------------- | ------------ | ---------- | ---------------------- | -------------- | -------------------------- |
| Resource Group         | `rg`         | 90         | a-z, 0-9, -, \_, ., () | Subscription   | `collabolatte-dev-rg`      |
| Static Web App (app)   | `swa-app`    | 40         | a-z, 0-9, -            | Resource Group | `collabolatte-dev-swa-app` |
| Static Web App (www)   | `swa-www`    | 40         | a-z, 0-9, -            | Resource Group | `collabolatte-dev-swa-www` |
| Storage Account        | `st`         | 24         | a-z, 0-9 (NO hyphens)  | Global         | `collabolattedevst001`     |
| Communication Services | `acs`        | 64         | a-z, 0-9, -            | Resource Group | `collabolatte-dev-acs`     |

### Environment-Specific Names

| Resource               | Dev                        | Staging                        | Prod                        |
| ---------------------- | -------------------------- | ------------------------------ | --------------------------- |
| Resource Group         | `collabolatte-dev-rg`      | `collabolatte-staging-rg`      | `collabolatte-prod-rg`      |
| SWA (App)              | `collabolatte-dev-swa-app` | `collabolatte-staging-swa-app` | `collabolatte-prod-swa-app` |
| SWA (Marketing)        | `collabolatte-dev-swa-www` | `collabolatte-staging-swa-www` | `collabolatte-prod-swa-www` |
| Storage Account        | `collabolattedevst001`     | `collabolattestagingst001`     | `collabolatteprodst001`     |
| Communication Services | `collabolatte-dev-acs`     | `collabolatte-staging-acs`     | `collabolatte-prod-acs`     |

---

## Parameters

### Required Parameters

| Parameter     | Type   | Description                        | Default        | Validation                   |
| ------------- | ------ | ---------------------------------- | -------------- | ---------------------------- |
| `project`     | string | Project name                       | `collabolatte` | lowercase, no spaces         |
| `environment` | string | Deployment environment             | -              | `dev` \| `staging` \| `prod` |
| `location`    | string | Azure region                       | `uksouth`      | Valid Azure region           |
| `identifier`  | string | Unique suffix for global resources | `001`          | 3 alphanumeric chars         |

### Optional Parameters

| Parameter         | Type   | Description                     | Default                  |
| ----------------- | ------ | ------------------------------- | ------------------------ |
| `appCustomDomain` | string | Custom domain for app SWA       | `app.collabolatte.co.uk` |
| `wwwCustomDomain` | string | Custom domain for marketing SWA | `www.collabolatte.co.uk` |
| `entraClientId`   | string | Entra ID app client ID          | (from app registration)  |
| `entraTenantId`   | string | Entra ID tenant ID              | (organisation tenant)    |

### Parameter Files Structure

```
infra/
├── parameters/
│   ├── dev.json          # Development environment
│   ├── staging.json      # Staging environment
│   └── prod.json         # Production environment
```

**Example Parameter File (`dev.json`):**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "project": {
      "value": "collabolatte"
    },
    "environment": {
      "value": "dev"
    },
    "location": {
      "value": "uksouth"
    },
    "identifier": {
      "value": "001"
    }
  }
}
```

---

## Entra ID and EasyAuth Setup

### Step 1: Create App Registration

1. Navigate to **Azure Portal > Microsoft Entra ID > App registrations**
2. Click **New registration**
3. Configure:
   - **Name:** `collabolatte-{environment}` (e.g., `collabolatte-dev`)
   - **Supported account types:** Accounts in this organizational directory only (Single tenant)
   - **Redirect URI:** Select "Single-page application (SPA)"

### Step 2: Configure Redirect URIs

Add the following redirect URIs under **Authentication > Single-page application**:

| Environment | Redirect URI                                                                        |
| ----------- | ----------------------------------------------------------------------------------- |
| Production  | `https://app.collabolatte.co.uk/.auth/login/aad/callback`                           |
| Staging     | `https://collabolatte-staging-swa-app.azurestaticapps.net/.auth/login/aad/callback` |
| Development | `https://collabolatte-dev-swa-app.azurestaticapps.net/.auth/login/aad/callback`     |
| Local       | `http://localhost:4280/.auth/login/aad/callback`                                    |

### Step 3: Configure API Permissions

1. Navigate to **API permissions**
2. Click **Add a permission**
3. Select **Microsoft Graph > Delegated permissions**
4. Add: `User.Read`
5. Click **Grant admin consent for {organisation}**

### Step 4: Configure Token Claims (Optional)

1. Navigate to **Token configuration**
2. Click **Add optional claim**
3. Select **ID** token type
4. Add claims:
   - `email`
   - `preferred_username`

### Step 5: Create Client Secret (for EasyAuth)

1. Navigate to **Certificates & secrets**
2. Click **New client secret**
3. Set expiration (recommended: 24 months)
4. **Copy the secret value immediately** - it will not be shown again
5. Store in GitHub Secrets as `AZURE_CLIENT_SECRET`

### Step 6: Record Configuration Values

| Value                   | Location               | Store As              |
| ----------------------- | ---------------------- | --------------------- |
| Application (client) ID | Overview page          | `AZURE_CLIENT_ID`     |
| Directory (tenant) ID   | Overview page          | `AZURE_TENANT_ID`     |
| Client Secret           | Certificates & secrets | `AZURE_CLIENT_SECRET` |

### Step 7: Configure SWA EasyAuth

Create or update `staticwebapp.config.json` in the web app:

```json
{
  "auth": {
    "identityProviders": {
      "azureActiveDirectory": {
        "registration": {
          "openIdIssuer": "https://login.microsoftonline.com/{AZURE_TENANT_ID}/v2.0",
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
    },
    {
      "route": "/.auth/login/aad",
      "allowedRoles": ["anonymous"]
    },
    {
      "route": "/.auth/logout",
      "allowedRoles": ["anonymous", "authenticated"]
    }
  ],
  "responseOverrides": {
    "401": {
      "redirect": "/.auth/login/aad?post_login_redirect_uri=.referrer",
      "statusCode": 302
    }
  },
  "globalHeaders": {
    "X-Content-Type-Options": "nosniff",
    "X-Frame-Options": "DENY",
    "Content-Security-Policy": "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"
  }
}
```

### Step 8: Configure SWA Application Settings

Add these settings in the Azure Portal under **Static Web App > Configuration > Application
settings**:

| Setting Name          | Value Source                   |
| --------------------- | ------------------------------ |
| `AZURE_CLIENT_ID`     | App registration client ID     |
| `AZURE_CLIENT_SECRET` | App registration client secret |

---

## GitHub Actions Setup

The infrastructure deployment is automated via GitHub Actions
(`.github/workflows/infra-deploy.yml`). This workflow requires specific GitHub Secrets to
authenticate with Azure and deploy Bicep templates.

### Required GitHub Secrets

| Secret Name             | Description                                   | How to Obtain                            |
| ----------------------- | --------------------------------------------- | ---------------------------------------- |
| `AZURE_CREDENTIALS`     | Service principal credentials for Azure login | Create via Azure CLI (see below)         |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription GUID                       | Find in Azure Portal under Subscriptions |

### Create Service Principal for GitHub Actions

Run this Azure CLI command to create a service principal with Contributor access to the resource
group:

```bash
# For dev environment
az ad sp create-for-rbac \
  --name "collabolatte-github-actions-dev" \
  --role Contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/collabolatte-dev-rg \
  --sdk-auth

# For staging environment
az ad sp create-for-rbac \
  --name "collabolatte-github-actions-staging" \
  --role Contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/collabolatte-staging-rg \
  --sdk-auth

# For prod environment
az ad sp create-for-rbac \
  --name "collabolatte-github-actions-prod" \
  --role Contributor \
  --scopes /subscriptions/{subscription-id}/resourceGroups/collabolatte-prod-rg \
  --sdk-auth
```

**Important:** Replace `{subscription-id}` with your actual Azure subscription ID.

The command outputs JSON in this format (example shown):

```json
{
  "clientId": "00000000-0000-0000-0000-000000000000",
  "clientSecret": "YOUR_CLIENT_SECRET",
  "subscriptionId": "00000000-0000-0000-0000-000000000000",
  "tenantId": "00000000-0000-0000-0000-000000000000",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

### Add Secrets to GitHub

1. Navigate to your GitHub repository
2. Go to **Settings > Secrets and variables > Actions**
3. Click **New repository secret**
4. Add `AZURE_CREDENTIALS` with the full JSON output from the `az ad sp create-for-rbac` command
5. Add `AZURE_SUBSCRIPTION_ID` with your subscription GUID

### Workflow Triggers

The infrastructure deployment workflow runs:

- **Manually**: Via Actions tab with environment selection (dev/staging/prod)
- **Automatically**: On push to `main` branch when files in `infra/**` or
  `.github/workflows/infra-deploy.yml` change

### Deployment Process

The workflow performs these steps:

1. **Azure Login**: Authenticates using service principal from `AZURE_CREDENTIALS`
2. **Bicep Validation**: Runs `az bicep build` to check template syntax
3. **What-If Preview**: Shows what changes will be made without deploying
4. **Deployment**: Deploys to the specified environment using parameter files
5. **Output Capture**: Saves deployment outputs as JSON artifacts (30-day retention)

---

## Resource Dependencies

### Dependency Diagram

```
+------------------------------------------------------------------+
|                     Resource Group                                |
|                   collabolatte-{env}-rg                           |
|                                                                   |
|  +------------------+    +------------------+                     |
|  |   SWA (App)      |    |  SWA (Marketing) |                     |
|  | swa-app          |    |  swa-www         |                     |
|  |                  |    |                  |                     |
|  | - React SPA      |    | - 11ty site      |                     |
|  | - Functions API  |    | - Public         |                     |
|  | - EasyAuth       |    |                  |                     |
|  +--------+---------+    +------------------+                     |
|           |                                                       |
|           | reads/writes                                          |
|           v                                                       |
|  +------------------+    +------------------+                     |
|  | Storage Account  |    |  Entra ID        |                     |
|  | {project}st{id}  |    |  (External)      |                     |
|  |                  |    |                  |                     |
|  | - Table Storage  |    | - App Reg        |                     |
|  | - Memberships    |<---+ - EasyAuth       |                     |
|  | - Cycles         |    | - User.Read      |                     |
|  | - Matches        |    |                  |                     |
|  | - Events         |    +------------------+                     |
|  | - Roles          |                                             |
|  +--------+---------+                                             |
|           |                                                       |
|           | sends via                                             |
|           v                                                       |
|  +------------------+                                             |
|  | Communication    |                                             |
|  | Services (ACS)   |                                             |
|  |                  |                                             |
|  | - Email only     |                                             |
|  +------------------+                                             |
|                                                                   |
+------------------------------------------------------------------+
```

### Deployment Order

Resources must be deployed in this order due to dependencies:

| Order | Resource                   | Depends On          | Notes                                       |
| ----- | -------------------------- | ------------------- | ------------------------------------------- |
| 1     | Resource Group             | -                   | Container for all resources                 |
| 2     | Storage Account            | Resource Group      | Required for API data access                |
| 3     | Communication Services     | Resource Group      | Required for email notifications            |
| 4     | Entra ID App Registration  | -                   | External (portal or CLI)                    |
| 5     | Static Web App (App)       | Storage, ACS, Entra | Requires connection strings and auth config |
| 6     | Static Web App (Marketing) | Resource Group      | No dependencies on other resources          |
| 7     | Custom Domains             | SWAs                | DNS must be configured first                |

---

## Post-Deployment Configuration

After Bicep deployment completes, these manual steps are required:

### 1. Configure SWA Application Settings

```bash
# For App SWA
az staticwebapp appsettings set \
  --name collabolatte-{env}-swa-app \
  --resource-group collabolatte-{env}-rg \
  --setting-names \
    AZURE_CLIENT_ID="{client-id}" \
    AZURE_CLIENT_SECRET="{client-secret}" \
    STORAGE_CONNECTION_STRING="{storage-connection-string}" \
    ACS_CONNECTION_STRING="{acs-connection-string}"
```

### 2. Create Table Storage Tables

```bash
# Using Azure CLI
az storage table create --name Memberships --account-name collabolatte{env}st001
az storage table create --name Cycles --account-name collabolatte{env}st001
az storage table create --name Matches --account-name collabolatte{env}st001
az storage table create --name Events --account-name collabolatte{env}st001
az storage table create --name Roles --account-name collabolatte{env}st001
```

### 3. Seed Initial Admin Role

```bash
# Add initial admin user to Roles table
# PartitionKey: "roles", RowKey: "{admin-user-object-id}"
# Properties: role="Admin"
```

### 4. Configure Custom Domains

1. Add CNAME records in DNS:
   - `app.collabolatte.co.uk` -> `collabolatte-{env}-swa-app.azurestaticapps.net`
   - `www.collabolatte.co.uk` -> `collabolatte-{env}-swa-www.azurestaticapps.net`

2. Validate domain ownership in Azure Portal

3. Enable HTTPS (automatic with SWA)

### 5. Configure GitHub Actions Secrets

Add these secrets to the GitHub repository:

| Secret Name                           | Description                        |
| ------------------------------------- | ---------------------------------- |
| `AZURE_STATIC_WEB_APPS_API_TOKEN_APP` | Deployment token for app SWA       |
| `AZURE_STATIC_WEB_APPS_API_TOKEN_WWW` | Deployment token for marketing SWA |

---

## Trust and Privacy Guardrails

This infrastructure documentation explicitly excludes:

- **Application Insights** - No behavioural analytics in MVP
- **Key Vault** - Not required for MVP cost constraints
- **Individual-level analytics resources** - Trust contract prohibits surveillance
- **Cross-programme data access** - Storage partitioning enforces isolation

Any future additions must be reviewed against the trust contract defined in the architecture
document.

---

## Bicep Structure

The Bicep infrastructure-as-code is organized as follows:

```
infra/
├── README.md                 # This documentation
├── main.bicep               # Main orchestration template (uses AVM)
├── main.json                # Generated ARM template
└── parameters/               # Environment-specific parameters
    ├── dev.json             # Development environment
    ├── staging.json         # Staging environment
    └── prod.json            # Production environment
```

**Template Description:**

- **main.bicep**: Orchestrates all resources using Azure Verified Modules (AVM) from the public registry:
  - `br/public:avm/res/storage/storage-account:0.14.3` - Storage Account with Table Storage
  - `br/public:avm/res/communication/communication-service:0.3.0` - Azure Communication Services
  - `br/public:avm/res/web/static-site:0.5.0` - Static Web Apps (both app and marketing)
- **main.json**: ARM template generated from main.bicep via `az bicep build`

**Parameter Files:**

Each environment has its own parameter file with:

- Project name and environment identifier
- Azure region (default: uksouth)
- Unique identifier for global resources
- GitHub repository URL for SWA integration
- Custom domain settings (prod only)

**Outputs:**

Deployment outputs include:

- Storage account name and connection string
- ACS connection string and endpoint
- SWA hostnames, URLs, and deployment tokens
- Deployment summary object

---

## Version History

| Date       | Version | Changes                                                                  |
| ---------- | ------- | ------------------------------------------------------------------------ |
| 2026-01-15 | 1.0.0   | Comprehensive documentation (Story 1.0)                                  |
| 2026-01-16 | 1.1.0   | Bicep templates implemented (Story 1.4) - main.bicep with custom modules |
| 2026-01-16 | 2.0.0   | Refactored to Azure Verified Modules (AVM) and subscription scope        |

---

## References

- [Architecture Decision Document](../_bmad-output/planning-artifacts/architecture.md)
- [Project Context](../_bmad-output/project-context.md)
- [Azure Verified Modules](https://aka.ms/avm)
- [Azure Static Web Apps Documentation](https://learn.microsoft.com/en-us/azure/static-web-apps/)
- [Azure Table Storage Documentation](https://learn.microsoft.com/en-us/azure/storage/tables/)
- [Azure Communication Services Email](https://learn.microsoft.com/en-us/azure/communication-services/concepts/email/email-overview)
- [Microsoft Entra ID EasyAuth](https://learn.microsoft.com/en-us/azure/static-web-apps/authentication-authorization)
