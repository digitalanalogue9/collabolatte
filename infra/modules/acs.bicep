// Azure Communication Services Module for Collabolatte
// Provides email notification capabilities

@description('Project name (lowercase, no spaces)')
param project string = 'collabolatte'

@description('Environment (dev, staging, prod)')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string

@description('Data location for ACS (UK for compliance)')
param dataLocation string = 'UK'

@description('Resource tags')
param tags object = {}

// ACS resource name follows standard naming convention
// Pattern: {project}-{environment}-acs
var acsName = '${project}-${environment}-acs'

resource communicationService 'Microsoft.Communication/communicationServices@2023-04-01' = {
  name: acsName
  location: 'global' // ACS is a global resource
  tags: union(tags, {
    project: project
    environment: environment
  })
  properties: {
    dataLocation: dataLocation
  }
}

@description('ACS resource ID')
output acsId string = communicationService.id

@description('ACS resource name')
output acsName string = communicationService.name

@description('ACS primary connection string (sensitive)')
output acsConnectionString string = communicationService.listKeys().primaryConnectionString

@description('ACS endpoint')
output acsEndpoint string = communicationService.properties.hostName
