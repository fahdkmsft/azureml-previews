This is a Readme is created with Insturctions Import data feature. 
Having a workspace connection to the source you are trying to connect is a pre-requisite. Please follow the following steps to create the necessary workspace connections. You can give an appropriate name to your connection by updating the name in the corresponding YAML file in the samples or by creating your own YAML using the sample and referencing it in the following when you are ready to create. These are just samples provided for you to get familiar with the required parameters that needs to be passed to create a new resource.


**Create test workspace with a compute instance 'cpu-instance'**

If you don't have an Azure subscription, sign up to try the [free or paid version of Azure Machine Learning](https://azure.microsoft.com/free/) today.
and follow the instructions to create a [AzureML workspace and compute instance](https://learn.microsoft.com/en-us/azure/machine-learning/quickstart-create-resources)

**2. Install SDKv2 private preview release**

**NOTE:** Execute the following in CI terminal (Go to workspace Notebooks and open terminal using the icon  in the left)

```cli
conda info
```
switch to V2 using the following commands - 
```cli
conda deactivate

conda activate azureml_py310_sdkv2
```
```cli
az extension remove -n ml
```
```cli
az extension add --source https://azuremlsdktestpypi.blob.core.windows.net/wheels/azureml-v2-cli-e2e-test/71493720/ml-0.0.71493720-py3-none-any.whl --pip-extra-index-urls https://azuremlsdktestpypi.azureedge.net/azureml-v2-cli-e2e-test/71493720 --yes
```


**Login to Azure:**

```cli
az login
```
```cli
az account set --subscription "<your subscription here>"
```

**Check for existing Connections or create a new one in CLI**

```cli
az ml connection list --resource-group <my resource group> --workspace-name <my workspace name>
```

**If you wish to create a new one for the <storage_type> you want to test using the YAML files refer to the following - [CLIV2-create-ws-connection](./CLIV2_create_ws_connection)

**Submit standalone import job in CLI**

Run the following CLI commands to by replacing <type> with the appropriate source type from samples/job folder:

```cli
az ml job create --file job/import_job_test_<type>.yml --resource-group <my resource group> --workspace-name <my workspace name>
```


**Submit import as part of a pipeline job in CLI**

```cli
az ml job create --file job/import_pipeline_test.yml --resource-group <my resource group> --workspace-name <my workspace name>
```