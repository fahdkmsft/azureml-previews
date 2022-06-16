

## Create AzureML Registry using ARM teamplate

Pre-requsites

* Install Azure CLI
* Login to Azure CLI
*mYou need to be owner of the Resource Group in which you are creating the Registry. This is possible in two ways: i) You are the owner the subscription which means you are an inherited owner of the Resource Group you will create in the steps below. ii) You ask someone who has the permissions to make you owner of a Resource Group that you use to create the Registry 


### Step 0
Clone this repo or make sure you have the following files that are located in [this directory](./): 
```
AzureMLRegistry.bicep
create-registry.sh
registry-properties.json
```

### Step 1

Edit the following in `create-registry.sh` 

```
rg_name="<resource group placeholder>"
location="<location placeholder>"
az_sub="<azure subscription placeholder>"

```

### Step 2

Edit the following in `registry-properties.json`

* `registryName` - name of the Registry
* `storageLocations` - this is the list of Azure Regions in which you have Workspaces in which you plan to use assets from this Registry (for storage accounts)
* `acrReplicationLocations` - this is the list of Azure Regions in which you have Workspaces in which you plan to use assets from this Registry (for ACR replication)

### Step 3

Run `bash create-registry.sh`. Below shows sample output. This script works on Linux, but you can run the two commands on Windows too. Sample output of the commands is shown at the end of this page. 

Below is a screenshot of the RG in which the Registry is created. You can see the following:
* Orange arrow: Registry resource (you need to enable hidden types to see this, see green oval)
* Blue arrows: ACR with replication to 2 regions
* Red arrows: 2 storage accounts, one for each region


![Registry in Azure Portal](../images/registry-azure-portal.png)



```
root@mabableslenovo:/mnt/c/CODE/REPOS/azureml-previews/previews/registries/arm 
# bash create-registry.sh
+ rg_name=bug-bash-rg1
+ location=eastus
+ az_sub=ea4faa5b-5e44-4236-91f6-5483d5b17d14
+ [[ -z bug-bash-rg1 ]]
+ [[ -z eastus ]]
+ [[ -z ea4faa5b-5e44-4236-91f6-5483d5b17d14 ]]
+ az group create --name bug-bash-rg1 --location eastus --subscription ea4faa5b-5e44-4236-91f6-5483d5b17d14 --tags owner=mabables SkipAutoDeleteTill=2023-01-01
{
  "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1",
  "location": "eastus",
  "managedBy": null,
  "name": "bug-bash-rg1",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": {
    "Created": "2022-06-15T01:08:02.5085957Z",
    "SkipAutoDeleteTill": "2023-01-01",
    "owner": "mabables"
  },
  "type": "Microsoft.Resources/resourceGroups"
}
+ az deployment group create --subscription ea4faa5b-5e44-4236-91f6-5483d5b17d14 --resource-group bug-bash-rg1 --template-file ./AzureMLRegistry.bicep --parameters ./registry-properties.json
/mnt/c/CODE/REPOS/azureml-previews/previews/registries/arm/AzureMLRegistry.bicep(158,22) : Warning BCP081: Resource type "Microsoft.MachineLearningServices/registries@2022-05-01-privatepreview" does not have types available.
/mnt/c/CODE/REPOS/azureml-previews/previews/registries/arm/AzureMLRegistry.bicep(200,5) : Warning no-unnecessary-dependson: Remove unnecessary dependsOn entry 'amlRegistry'. [https://aka.ms/bicep/linter/no-unnecessary-dependson]
/mnt/c/CODE/REPOS/azureml-previews/previews/registries/arm/AzureMLRegistry.bicep(212,5) : Warning no-unnecessary-dependson: Remove unnecessary dependsOn entry 'amlRegistry'. [https://aka.ms/bicep/linter/no-unnecessary-dependson]

{
  "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Resources/deployments/AzureMLRegistry",
  "location": null,
  "name": "AzureMLRegistry",
  "properties": {
    "correlationId": "8c73ca9b-86b5-4dc1-b697-eeeb9b1afb17",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.ContainerRegistry/registries/mlregcsix4",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "mlregcsix4",
            "resourceType": "Microsoft.ContainerRegistry/registries"
          },
          {
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Storage/storageAccounts/mlregcsix4eus1",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "mlregcsix4eus1",
            "resourceType": "Microsoft.Storage/storageAccounts"
          },
          {
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Storage/storageAccounts/mlregcsix4eus21",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "mlregcsix4eus21",
            "resourceType": "Microsoft.Storage/storageAccounts"
          },
          {
            "apiVersion": "2021-04-01",
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Storage/storageAccounts/mlregcsix4eus1",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "mlregcsix4eus1",
            "resourceType": "Microsoft.Storage/storageAccounts"
          },
          {
            "apiVersion": "2021-12-01-preview",
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.ContainerRegistry/registries/mlregcsix4",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "mlregcsix4",
            "resourceType": "Microsoft.ContainerRegistry/registries"
          },
          {
            "apiVersion": "2021-04-01",
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Storage/storageAccounts/mlregcsix4eus21",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "mlregcsix4eus21",
            "resourceType": "Microsoft.Storage/storageAccounts"
          }
        ],
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.MachineLearningServices/registries/ContosoMLjun14",
        "resourceGroup": "bug-bash-rg1",
        "resourceName": "ContosoMLjun14",
        "resourceType": "Microsoft.MachineLearningServices/registries"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.MachineLearningServices/registries/ContosoMLjun14",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "ContosoMLjun14",
            "resourceType": "Microsoft.MachineLearningServices/registries"
          },
          {
            "apiVersion": "2022-05-01-privatepreview",
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.MachineLearningServices/registries/ContosoMLjun14",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "ContosoMLjun14",
            "resourceType": "Microsoft.MachineLearningServices/registries"
          }
        ],
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Authorization/roleAssignments/956e1416-fe9a-5fb3-a91b-fcda88f79335",
        "resourceGroup": "bug-bash-rg1",
        "resourceName": "956e1416-fe9a-5fb3-a91b-fcda88f79335",
        "resourceType": "Microsoft.Authorization/roleAssignments"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.MachineLearningServices/registries/ContosoMLjun14",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "ContosoMLjun14",
            "resourceType": "Microsoft.MachineLearningServices/registries"
          },
          {
            "apiVersion": "2022-05-01-privatepreview",
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.MachineLearningServices/registries/ContosoMLjun14",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "ContosoMLjun14",
            "resourceType": "Microsoft.MachineLearningServices/registries"
          }
        ],
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Authorization/roleAssignments/1ade005c-4072-56e8-a667-d102aab57559",
        "resourceGroup": "bug-bash-rg1",
        "resourceName": "1ade005c-4072-56e8-a667-d102aab57559",
        "resourceType": "Microsoft.Authorization/roleAssignments"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.ContainerRegistry/registries/mlregcsix4",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "mlregcsix4",
            "resourceType": "Microsoft.ContainerRegistry/registries"
          }
        ],
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.ContainerRegistry/registries/mlregcsix4/replications/eastusAcrRepmqcigod3smhdi",
        "resourceGroup": "bug-bash-rg1",
        "resourceName": "mlregcsix4/eastusAcrRepmqcigod3smhdi",
        "resourceType": "Microsoft.ContainerRegistry/registries/replications"
      },
      {
        "dependsOn": [
          {
            "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.ContainerRegistry/registries/mlregcsix4",
            "resourceGroup": "bug-bash-rg1",
            "resourceName": "mlregcsix4",
            "resourceType": "Microsoft.ContainerRegistry/registries"
          }
        ],
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.ContainerRegistry/registries/mlregcsix4/replications/eastus2AcrRepmqcigod3smhdi",
        "resourceGroup": "bug-bash-rg1",
        "resourceName": "mlregcsix4/eastus2AcrRepmqcigod3smhdi",
        "resourceType": "Microsoft.ContainerRegistry/registries/replications"
      }
    ],
    "duration": "PT52.4651437S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Authorization/roleAssignments/1ade005c-4072-56e8-a667-d102aab57559",
        "resourceGroup": "bug-bash-rg1"
      },
      {
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Authorization/roleAssignments/956e1416-fe9a-5fb3-a91b-fcda88f79335",
        "resourceGroup": "bug-bash-rg1"
      },
      {
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.ContainerRegistry/registries/mlregcsix4",
        "resourceGroup": "bug-bash-rg1"
      },
      {
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.ContainerRegistry/registries/mlregcsix4/replications/eastus2AcrRepmqcigod3smhdi",
        "resourceGroup": "bug-bash-rg1"
      },
      {
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.MachineLearningServices/registries/ContosoMLjun14",
        "resourceGroup": "bug-bash-rg1"
      },
      {
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Storage/storageAccounts/mlregcsix4eus1",
        "resourceGroup": "bug-bash-rg1"
      },
      {
        "id": "/subscriptions/ea4faa5b-5e44-4236-91f6-5483d5b17d14/resourceGroups/bug-bash-rg1/providers/Microsoft.Storage/storageAccounts/mlregcsix4eus21",
        "resourceGroup": "bug-bash-rg1"
      }
    ],
    "outputs": null,
    "parameters": {
      "acrReplicationLocations": {
        "type": "Array",
        "value": [
          "EastUS",
          "EastUS2"
        ]
      },
      "registryName": {
        "type": "String",
        "value": "ContosoMLjun14"
      },
      "resourceGroupLocation": {
        "type": "String",
        "value": "eastus"
      },
      "storageLocations": {
        "type": "Array",
        "value": [
          "EastUS-1",
          "EastUS2-1"
        ]
      }
    },
    "parametersLink": null,
    "providers": [
      {
        "id": null,
        "namespace": "Microsoft.ContainerRegistry",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "eastus"
            ],
            "properties": null,
            "resourceType": "registries"
          },
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "eastus2"
            ],
            "properties": null,
            "resourceType": "registries/replications"
          }
        ]
      },
      {
        "id": null,
        "namespace": "Microsoft.MachineLearningServices",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "eastus"
            ],
            "properties": null,
            "resourceType": "registries"
          }
        ]
      },
      {
        "id": null,
        "namespace": "Microsoft.Authorization",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              null
            ],
            "properties": null,
            "resourceType": "roleAssignments"
          }
        ]
      },
      {
        "id": null,
        "namespace": "Microsoft.Storage",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "eastus",
              "eastus2"
            ],
            "properties": null,
            "resourceType": "storageAccounts"
          }
        ]
      }
    ],
    "provisioningState": "Succeeded",
    "templateHash": "13429112038653231989",
    "templateLink": null,
    "timestamp": "2022-06-15T01:09:08.053706+00:00",
    "validatedResources": null
  },
  "resourceGroup": "bug-bash-rg1",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
(base) root@mabableslenovo:/mnt/c/CODE/REPOS/azureml-previews/previews/registries/arm 
# 


```