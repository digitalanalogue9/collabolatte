// Collabolatte Infrastructure - Main Template
// Deploys all Azure resources for the Collabolatte MVP
// Target scope: Resource Group

targetScope = 'resourceGroup'

// ============================================================================
// PARAMETERS
// ============================================================================

@description('Project name (lowercase, no spaces)')
param project string = 'collabolatte'

@description('Environment (dev, staging, prod)')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string

@description('Azure region for deployment')
param location string = resourceGroup().location

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
// MODULES
// ============================================================================

// Storage Account Module
module storage 'modules/storage.bicep' = {
  name: 'storage-deployment'
  params: {
    project: project
    environment: environment
    location: location
    identifier: identifier
    tags: tags
  }
}

// Azure Communication Services Module
module acs 'modules/acs.bicep' = {
  name: 'acs-deployment'
  params: {
    project: project
    environment: environment
    dataLocation: 'UK'
    tags: tags
  }
}

// Static Web App - Application (React SPA + Azure Functions API)
module swaApp 'modules/swa.bicep' = {
  name: 'swa-app-deployment'
  params: {
    project: project
    environment: environment
    location: location
    variant: 'app'
    repositoryUrl: repositoryUrl
    repositoryBranch: repositoryBranch
    customDomain: appCustomDomain
    tags: tags
  }
}

// Static Web App - Marketing (11ty static site)
module swaMarketing 'modules/swa.bicep' = {
  name: 'swa-marketing-deployment'
  params: {
    project: project
    environment: environment
    location: location
    variant: 'www'
    repositoryUrl: repositoryUrl
    repositoryBranch: repositoryBranch
    customDomain: wwwCustomDomain
    tags: tags
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

// Storage Outputs
@description('Storage account resource ID')
output storageAccountId string = storage.outputs.storageAccountId

@description('Storage account name')
output storageAccountName string = storage.outputs.storageAccountName

@description('Storage connection string (sensitive)')
@secure()
output storageConnectionString string = storage.outputs.storageConnectionString

// Azure Communication Services Outputs
@description('ACS resource ID')
output acsId string = acs.outputs.acsId

@description('ACS resource name')
output acsName string = acs.outputs.acsName

@description('ACS connection string (sensitive)')
@secure()
output acsConnectionString string = acs.outputs.acsConnectionString

@description('ACS endpoint')
output acsEndpoint string = acs.outputs.acsEndpoint

// Static Web App (Application) Outputs
@description('App SWA resource ID')
output appSwaId string = swaApp.outputs.swaId

@description('App SWA name')
output appSwaName string = swaApp.outputs.swaName

@description('App SWA hostname')
output appSwaHostname string = swaApp.outputs.swaHostname

@description('App SWA URL')
output appSwaUrl string = swaApp.outputs.swaUrl

@description('App SWA deployment token (sensitive)')
@secure()
output appSwaDeploymentToken string = swaApp.outputs.swaDeploymentToken

// Static Web App (Marketing) Outputs
@description('Marketing SWA resource ID')
output marketingSwaId string = swaMarketing.outputs.swaId

@description('Marketing SWA name')
output marketingSwaName string = swaMarketing.outputs.swaName

@description('Marketing SWA hostname')
output marketingSwaHostname string = swaMarketing.outputs.swaHostname

@description('Marketing SWA URL')
output marketingSwaUrl string = swaMarketing.outputs.swaUrl

@description('Marketing SWA deployment token (sensitive)')
@secure()
output marketingSwaDeploymentToken string = swaMarketing.outputs.swaDeploymentToken

// Summary Output
@description('Deployment summary')
output deploymentSummary object = {
  environment: environment
  location: location
  storageAccount: storage.outputs.storageAccountName
  acs: acs.outputs.acsName
  appSwa: swaApp.outputs.swaName
  marketingSwa: swaMarketing.outputs.swaName
  appUrl: swaApp.outputs.swaUrl
  marketingUrl: swaMarketing.outputs.swaUrl
}
