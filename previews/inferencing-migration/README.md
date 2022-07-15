# Migration steps for ACI webservice to Managed online endpoint

[Managed online endpoints](https://docs.microsoft.com/azure/machine-learning/concept-endpoints) help to deploy your ML models in a turnkey manner. Managed online endpoints work with powerful CPU and GPU machines in Azure in a scalable, fully managed way. Managed online endpoints take care of serving, scaling, securing, and monitoring your models, freeing you from the overhead of setting up and managing the underlying infrastructure. Details can be found on [Deploy and score a machine learning model by using an online endpoint](https://docs.microsoft.com/azure/machine-learning/how-to-deploy-managed-online-endpoints).

You can deploy directly to the new compute target with your previous models and environments, or leverage the script provided by us to export the current services then deploy to the new compute. For customers who regularly create and delete ACI services, we strongly recommend the prior solution. Please notice that the **scoring URL will be changed after migration**.

## Supported Scenarios and Differences

### Auth Mode
No auth is not supported for managed online endpoint. We'll convert it to key auth if you migrate with below migration scripts.
For key auth, the original keys will be used. Token-based auth is also supported.

### TLS
For ACI service secured with HTTPS, you don't need to provide your own certificates any more, all the managed online endpoints are protected by TLS. Custom DNS name is not supported also.

### Resource Requirements
[ContainerResourceRequirements](https://docs.microsoft.com/python/api/azureml-core/azureml.core.webservice.aci.containerresourcerequirements?view=azure-ml-py) is not supported, you can choose the proper [SKU](https://docs.microsoft.com/azure/machine-learning/reference-managed-online-endpoints-vm-sku-list) for your inferencing.
With our migration scripts, we'll map the CPU requirement to corresponding SKU. More specifically, CPU requirement that is less than or equal to 2 cores will be mapped to Standard_F2s_v2,  more than 2 cores but less than or equal to 4 cores will be mapped to Standard_F4s_v2.

### Network Isolation
For private workspace and VNET scenarios, please check [Use network isolation with managed online endpoints (preview)](https://docs.microsoft.com/azure/machine-learning/how-to-secure-online-endpoint?tabs=model). As there're many settings for your workspace and VNET, we strongly suggest that redeploy through our new CLI instead of the below script tool.

## Not supported
[EncryptionProperties](https://docs.microsoft.com/python/api/azureml-core/azureml.core.webservice.aci.encryptionproperties?view=azure-ml-py) for ACI contaienr is not supported.

## Migration Steps
Here're the steps to use these scripts.

1. Linux/WSL to run the bash script.
2. Install [Python SDK V1](https://docs.microsoft.com/python/api/overview/azure/ml/install?view=azure-ml-py) to run the python script.
3. Install [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli).
4. Edit the subscription/resourcegroup/workspace/service name info in export-service.sh, also the expected new endpoint name and deployment name. We recommend that the new endpoint name is different from the previous one.
5. Execute the bash script, it will take several minutes to finish the new deployment.
6. After the deployment is done successfully, you can verify the endpoint with [invoke command](https://docs.microsoft.com/cli/azure/ml/online-endpoint?view=azure-cli-latest#az-ml-online-endpoint-invoke).