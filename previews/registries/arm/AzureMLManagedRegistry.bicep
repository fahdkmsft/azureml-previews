param resourceGroupLocation string = toLower(replace(resourceGroup().location, ' ', ''))
param registryName string
param registryLocations array

resource amlRegistry 'Microsoft.MachineLearningServices/registries@2022-05-01-privatepreview' = {
  name: registryName
  location: resourceGroupLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    regionDetails: [ for registryLocation in registryLocations: {
      location: registryLocation
      storageAccountDetails: [
        {
          newStorageAccount: {
            storageAccountType: 'Standard_GRS'
            StorageAccountHnsEnabled: false
          }
        }
      ]
      acrDetails: [ 
        {
          newAcrAccount: {
            acrAccountSku: 'Premium'
          }
        }
      ]
    }]
  }
}
