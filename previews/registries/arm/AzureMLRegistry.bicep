param resourceGroupLocation string = toLower(replace(resourceGroup().location, ' ', ''))
param registryName string
param acrReplicationLocations array
param storageLocations array

var constPrefix = 'mlreg'

// this is used to decide storage and acr names, so toLowering registryName
var uniqueRegistryName = substring(uniqueString(toLower(registryName)), 8)

var regionShortNameMapping = {
  westus2: {
    shortName: 'wus2'
  }
  eastus2: {
    shortName: 'eus2'
  }
  southcentralus: {
    shortName: 'scus'
  }
  westeurope: {
    shortName: 'weu'
  }
  eastus: {
    shortName: 'eus'
  }
  northeurope: {
    shortName: 'neu'
  }
  westcentralus:{
    shortName: 'wcus'
  }
  centralus: {
    shortName: 'cus'
  }
  eastasia: {
    shortName: 'eas'
  }
  southeastasia: {
    shortName: 'sea'
  }
  westus: {
    shortName: 'wus'
  }
  eastus2euap: {
    shortName: 'eus2e'
  }
  centraluseuap: {
    shortName: 'cseuap'
  }
  southafricanorth: {
    shortName: 'sano'
  }
  brazilsouth: {
    shortName: 'brs'
  }
  canadacentral: {
    shortName: 'cac'
  }
  westus3: {
    shortName: 'wus3'
  }
  northcentralus: {
    shortName: 'ncus'
  }
  francecentral: {
    shortName: 'frc'
  }
  germanywestcentral: {
    shortName: 'gwc'
  }
  switzerlandnorth: {
    shortName: 'swn'
  }
  uksouth: {
    shortName: 'uks'
  }
  japanwest: {
    shortName: 'jpw'
  }
  japaneast: {
    shortName: 'jpe'
  }
  australiaeast: {
    shortName: 'aue'
  }
  uaenorth: {
    shortName: 'uaen'
  }
  centralindia: {
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
  name: '${constPrefix}${uniqueRegistryName}${regionShortNameMapping[toLower(split(storageLocation, '-')[0])].shortName}${split(storageLocation, '-')[1]}'
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
    principalType: 'ServicePrincipal'
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
    principalType: 'ServicePrincipal'
  }
  scope: resourceGroup()
  dependsOn: [
    amlRegistry
  ]
}
