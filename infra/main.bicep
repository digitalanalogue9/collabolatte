// Collabolatte Infrastructure - Main Template
// Deploys all Azure resources for the Collabolatte MVP
// Target scope: Subscription (creates resource group automatically)

targetScope = 'subscription'

// ============================================================================
// PARAMETERS
// ============================================================================

@description('Project name (lowercase, no spaces)')
param project string = 'collabolatte'

@description('Project name (lowercase, no spaces)')
param projectStorage string = 'collab'


@description('Environment (dev, staging, prod)')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string

@description('Azure region for deployment')
param location string = 'westeurope'

@description('Unique identifier for globally-scoped resources (3 alphanumeric chars)')
@maxLength(3)
param identifier string = '001'

@description('GitHub repository URL (optional, for SWA)')
param repositoryUrl string = ''

@description('GitHub repository branch')
param repositoryBranch string = 'main'

@description('Custom domain for app SWA (optional)')
param appCustomDomain string = ''

@description('Custom domain for marketing SWA (optional)')
param wwwCustomDomain string = ''

@description('Resource tags')
param tags object = {
  project: 'collabolatte'
  managedBy: 'bicep'
}

// ============================================================================
// RESOURCE GROUP
// ============================================================================

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-${project}-${environment}-${location}'
  location: location
  tags: union(tags, {
    environment: environment
  })
}

// ============================================================================
// MODULES (using Azure Verified Modules)
// ============================================================================

// Storage Account Module (AVM)
module storage 'br/public:avm/res/storage/storage-account:0.14.3' = {
  scope: rg
  name: 'storage-deployment'
  params: {
    name: toLower('st${projectStorage}${environment}${identifier}')
    location: location
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true // Required for Azure Functions
    networkAcls: {
      defaultAction: 'Allow' // MVP uses public access with key auth
      bypass: 'AzureServices'
    }
    tableServices: {
      tables: [] // Tables created later via application code
    }
    tags: union(tags, {
      project: project
      environment: environment
    })
  }
}

// Reference to deployed storage account for listKeys
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  scope: rg
  name: toLower('st${project}${environment}${identifier}')
  dependsOn: [
    storage
  ]
}

// Reference to deployed ACS for listKeys
resource communicationService 'Microsoft.Communication/communicationServices@2023-04-01' existing = {
  scope: rg
  name: 'acs-${project}-${environment}-${location}'
  dependsOn: [
    acs
  ]
}

// Reference to deployed app SWA for listSecrets
resource staticWebAppApp 'Microsoft.Web/staticSites@2023-01-01' existing = {
  scope: rg
  name: 'stapp-${project}-app-${environment}-${location}'
  dependsOn: [
    swaApp
  ]
}

// Reference to deployed marketing SWA for listSecrets
resource staticWebAppMarketing 'Microsoft.Web/staticSites@2023-01-01' existing = {
  scope: rg
  name: 'stapp-${project}-www-${environment}-${location}'
  dependsOn: [
    swaMarketing
  ]
}

// Azure Communication Services Module (AVM)
module acs 'br/public:avm/res/communication/communication-service:0.3.0' = {
  scope: rg
  name: 'acs-deployment'
  params: {
    name: 'acs-${project}-${environment}-${location}'
    dataLocation: 'UK'
    tags: union(tags, {
      project: project
      environment: environment
    })
  }
}

// Static Web App - Application (React SPA + Azure Functions API) (AVM)
module swaApp 'br/public:avm/res/web/static-site:0.5.0' = {
  scope: rg
  name: 'swa-app-deployment'
  params: {
    name: 'stapp-${project}-app-${environment}-${location}'
    location: location
    sku: 'Free'
    repositoryUrl: repositoryUrl
    branch: repositoryBranch  // Correct parameter name is 'branch' not 'repositoryBranch'
    buildProperties: {
      appLocation: '/apps/web'
      apiLocation: '/apps/api'
      outputLocation: 'dist'
    }
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    customDomains: !empty(appCustomDomain) ? [
      {
        name: appCustomDomain
      }
    ] : []
    tags: union(tags, {
      project: project
      environment: environment
      variant: 'app'
    })
  }
}

// Static Web App - Marketing (11ty static site) (AVM)
module swaMarketing 'br/public:avm/res/web/static-site:0.5.0' = {
  scope: rg
  name: 'swa-marketing-deployment'
  params: {
    name: 'stapp-${project}-www-${environment}-${location}'
    location: location
    sku: 'Free'
    repositoryUrl: repositoryUrl
    branch: repositoryBranch  // Correct parameter name is 'branch' not 'repositoryBranch'
    buildProperties: {
      appLocation: '/apps/marketing'
      outputLocation: 'dist'
    }
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    customDomains: !empty(wwwCustomDomain) ? [
      {
        name: wwwCustomDomain
      }
    ] : []
    tags: union(tags, {
      project: project
      environment: environment
      variant: 'www'
    })
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

// Storage Outputs
@description('Storage account resource ID')
output storageAccountId string = storage.outputs.resourceId

@description('Storage account name')
output storageAccountName string = storage.outputs.name

@description('Storage connection string (sensitive)')
@secure()
output storageConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storage.outputs.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${az.environment().suffixes.storage}'

// Azure Communication Services Outputs
@description('ACS resource ID')
output acsId string = acs.outputs.resourceId

@description('ACS resource name')
output acsName string = acs.outputs.name

@description('ACS connection string (sensitive)')
@secure()
output acsConnectionString string = communicationService.listKeys().primaryConnectionString

@description('ACS endpoint')
output acsEndpoint string = 'https://${acs.outputs.name}.communication.azure.com'

// Static Web App (Application) Outputs
@description('App SWA resource ID')
output appSwaId string = swaApp.outputs.resourceId

@description('App SWA name')
output appSwaName string = swaApp.outputs.name

@description('App SWA hostname')
output appSwaHostname string = swaApp.outputs.defaultHostname

@description('App SWA URL')
output appSwaUrl string = 'https://${swaApp.outputs.defaultHostname}'

@description('App SWA deployment token (sensitive)')
@secure()
output appSwaDeploymentToken string = staticWebAppApp.listSecrets().properties.apiKey

// Static Web App (Marketing) Outputs
@description('Marketing SWA resource ID')
output marketingSwaId string = swaMarketing.outputs.resourceId

@description('Marketing SWA name')
output marketingSwaName string = swaMarketing.outputs.name

@description('Marketing SWA hostname')
output marketingSwaHostname string = swaMarketing.outputs.defaultHostname

@description('Marketing SWA URL')
output marketingSwaUrl string = 'https://${swaMarketing.outputs.defaultHostname}'

@description('Marketing SWA deployment token (sensitive)')
@secure()
output marketingSwaDeploymentToken string = staticWebAppMarketing.listSecrets().properties.apiKey

// Summary Output
@description('Deployment summary')
output deploymentSummary object = {
  environment: environment
  location: location
  resourceGroup: rg.name
  storageAccount: storage.outputs.name
  acs: acs.outputs.name
  appSwa: swaApp.outputs.name
  marketingSwa: swaMarketing.outputs.name
  appUrl: 'https://${swaApp.outputs.defaultHostname}'
  marketingUrl: 'https://${swaMarketing.outputs.defaultHostname}'
}
