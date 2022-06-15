param resourceGroupLocation string = toLower(replace(resourceGroup().location, ' ', ''))
param registryName string
param acrReplicationLocations array
param storageLocations array

var constPrefix = 'mlreg'

var uniqueRegistryName = substring(uniqueString(registryName), 8)

var regionShortNameMapping = {
  WestUS2: {
    shortName: 'wus2'
  }
  EastUS2: {
    shortName: 'eus2'
  }
  SouthCentralUS: {
    shortName: 'scus'
  }
  WestEurope: {
    shortName: 'weu'
  }
  EastUS: {
    shortName: 'eus'
  }
  NorthEurope: {
    shortName: 'neu'
  }
  WestCentralUS:{
    shortName: 'wcus'
  }
  CentralUS: {
    shortName: 'cus'
  }
  EastAsia: {
    shortName: 'eas'
  }
  SouthEastAsia: {
    shortName: 'sea'
  }
  WestUS: {
    shortName: 'wus'
  }
  EastUS2EUAP: {
    shortName: 'eus2e'
  }
  CentralUSEUAP: {
    shortName: 'cseuap'
  }
  SouthAfricaNorth: {
    shortName: 'sano'
  }
  BrazilSouth: {
    shortName: 'brs'
  }
  CanadaCentral: {
    shortName: 'cac'
  }
  WestUS3: {
    shortName: 'wus3'
  }
  NorthCentralUS: {
    shortName: 'ncus'
  }
  FranceCentral: {
    shortName: 'frc'
  }
  GermanyWestCentral: {
    shortName: 'gwc'
  }
  SwitzerlandNorth: {
    shortName: 'swn'
  }
  UKSouth: {
    shortName: 'uks'
  }
  JapanWest: {
    shortName: 'jpw'
  }
  JapanEast: {
    shortName: 'jpe'
  }
  AustraliaEast: {
    shortName: 'aue'
  }
  UAENorth: {
    shortName: 'uaen'
  }
  CentralIndia: {
    shortName: 'cind'
  }
}

var subscriptionId = subscription().subscriptionId
var rbacPrefix = '/subscriptions/${subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/'
var ownerRoleDefinitionId = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
var blobContributorRoleDefinitionId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

var roles = {
  Owner: '${rbacPrefix}/${ownerRoleDefinitionId}'
  BlobDataContributor: '${rbacPrefix}/${blobContributorRoleDefinitionId}'
}

// TODO: Iterative role assignment doesn't work with module. It is an experimental feature now. So we can enable it later.
// So, for now we put the whole storage bicep here.
resource storageResources 'Microsoft.Storage/storageAccounts@2021-04-01' = [for storageLocation in storageLocations: {
  name: '${constPrefix}${uniqueRegistryName}${regionShortNameMapping[split(storageLocation, '-')[0]].shortName}${split(storageLocation, '-')[1]}'
  location: split(storageLocation, '-')[0]
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true // false
    allowCrossTenantReplication: false
    // This disables storage account key.
    allowSharedKeyAccess: false
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}]

resource acrResource 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: '${constPrefix}${uniqueRegistryName}'
  location: resourceGroupLocation
  sku: {
    name: 'Premium'
  }
  properties: {
    adminUserEnabled: false
    anonymousPullEnabled: false
  }

  // Replication is only allowed in regions other than acr region.
  resource acrReplications 'replications' = [ for index in range(0, length(acrReplicationLocations)): if (toLower(acrReplicationLocations[index]) != resourceGroupLocation) {
    name: '${toLower(acrReplicationLocations[index])}AcrRep${uniqueString(acrResource.id)}'
    location: acrReplicationLocations[index]
    properties: {
      regionEndpointEnabled: true
    }
  }]
}

resource amlRegistry 'Microsoft.MachineLearningServices/registries@2022-05-01-privatepreview' = {
  name: registryName
  location: resourceGroupLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    regionDetails: [ for index in range(0, length(storageLocations)): {
      location: storageResources[index].location
      storageAccountDetails: [
        {
          existingStorageAccount: {
            armResourceId: {
              resourceId: storageResources[index].id
            }
          }
        }
      ]
      acrDetails: (toLower(replace(storageResources[index].location, ' ', '')) == toLower(replace(acrResource.location, ' ', ''))) ? [ 
        {
          existingAcrAccount: {
            armResourceId: {
            resourceId: acrResource.id
          }
        }
      }
    ] :  null
    }]
  }
  dependsOn: [
    storageResources
  ]
}

resource rgOwnerRoleAssign 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name:  guid('RGAssign${resourceGroup().id}${roles.Owner}${uniqueRegistryName}')
  properties: {
    roleDefinitionId: roles.Owner
    principalId: amlRegistry.identity.principalId
  }
  scope: resourceGroup()
  dependsOn: [
    amlRegistry
  ]
}

resource rgBlobContributorRoleAssign 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name:  guid('RGAssign${resourceGroup().id}${roles.BlobDataContributor}${uniqueRegistryName}')
  properties: {
    roleDefinitionId: roles.BlobDataContributor
    principalId: amlRegistry.identity.principalId
  }
  scope: resourceGroup()
  dependsOn: [
    amlRegistry
  ]
}
