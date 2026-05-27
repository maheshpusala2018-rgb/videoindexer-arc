@description('The location to deploy this resource to')
param location string = resourceGroup().location

@description('The name of the AVAM resource')
param accountName string = 'cbintelvideoindexer'

@description('The name of the storage account used by Video Indexer')
param storageAccountName string = 'cbintelstorageacc'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

@description('The AVAM Template')
resource avamAccount 'Microsoft.VideoIndexer/accounts@2025-04-01' = {
  name: accountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    storageServices: {
      resourceId: storageAccount.id
      userAssignedIdentity: ''
    }
  }
}

output videoIndexerAccountName string = avamAccount.name
output videoIndexerAccountId string = avamAccount.properties.accountId
output videoIndexerPrincipalId string = avamAccount.identity.principalId
