// Static Web App Module for Collabolatte
// Supports both app+api and marketing site variants

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

@description('SWA variant (app or www)')
@allowed([
  'app'
  'www'
])
param variant string

@description('GitHub repository URL (optional)')
param repositoryUrl string = ''

@description('GitHub repository branch')
param repositoryBranch string = 'main'

@description('Custom domain (optional)')
param customDomain string = ''

@description('Resource tags')
param tags object = {}

// SWA resource name follows standard naming convention
// Pattern: {project}-{environment}-swa-{variant}
var swaName = '${project}-${environment}-swa-${variant}'

// Build configuration varies by variant
var buildProperties = variant == 'app' ? {
  appLocation: '/apps/web'
  apiLocation: '/apps/api'
  outputLocation: 'dist'
} : {
  appLocation: '/apps/marketing'
  outputLocation: 'dist'
}

resource staticWebApp 'Microsoft.Web/staticSites@2023-01-01' = {
  name: swaName
  location: location
  tags: union(tags, {
    project: project
    environment: environment
    variant: variant
  })
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: repositoryUrl
    branch: repositoryBranch
    buildProperties: buildProperties
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
  }
}

// Custom domain (only if provided)
resource customDomainResource 'Microsoft.Web/staticSites/customDomains@2023-01-01' = if (!empty(customDomain)) {
  parent: staticWebApp
  name: customDomain
  properties: {}
}

@description('SWA resource ID')
output swaId string = staticWebApp.id

@description('SWA resource name')
output swaName string = staticWebApp.name

@description('SWA default hostname')
output swaHostname string = staticWebApp.properties.defaultHostname

@description('SWA deployment token (sensitive - used for GitHub Actions)')
output swaDeploymentToken string = staticWebApp.listSecrets().properties.apiKey

@description('SWA URL')
output swaUrl string = 'https://${staticWebApp.properties.defaultHostname}'
