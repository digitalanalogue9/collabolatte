// Storage Account Module for Collabolatte
// Provides Table Storage for membership, cycles, matches, events, and roles

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

@description('Resource tags')
param tags object = {}

// Storage account name must be lowercase, no hyphens, max 24 chars
// Pattern: {project}{environment}st{identifier}
var storageAccountName = toLower('${project}${environment}st${identifier}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: union(tags, {
    project: project
    environment: environment
  })
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true // Required for Azure Functions
    networkAcls: {
      defaultAction: 'Allow' // MVP uses public access with key auth
      bypass: 'AzureServices'
    }
  }
}

// Table Storage service (required for creating tables later)
resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

@description('Storage account resource ID')
output storageAccountId string = storageAccount.id

@description('Storage account name')
output storageAccountName string = storageAccount.name

@description('Storage account primary endpoints')
output storageAccountEndpoints object = storageAccount.properties.primaryEndpoints

@description('Storage connection string (includes account key - sensitive)')
output storageConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${az.environment().suffixes.storage}'
