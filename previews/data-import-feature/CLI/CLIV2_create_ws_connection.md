This is a Readme is created with Insturctions Import data feature. 
Having a workspace connection to the source you are trying to connect is a pre-requisite. Please follow the following steps to create the necessary workspace connections. You can give an appropriate name to your connection by updating the name in the corresponding YAML file in the samples or by creating your own YAML using the sample and referencing it in the following when you are ready to create. These are just samples provided for you to get familiar with the required parameters that needs to be passed to create a new resource.


**Create test workspace with a compute instance 'cpu-instance'**

If you don't have an Azure subscription, sign up to try the [free or paid version of Azure Machine Learning](https://azure.microsoft.com/free/) today.
and follow the instructions to create a [AzureML workspace and compute instance](https://learn.microsoft.com/en-us/azure/machine-learning/quickstart-create-resources)

**Login to Azure:**

**NOTE:**  Execute the following in CI terminal (Go to workspace Notebooks and open terminal using the icon  in the left)
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

**If you wish to create a new one for the <storage_type> you want to test using the YAML files placed in "import-prp-bugbash\workspace_connection" folder** and remember to change the name of your connection and use that name in future when referring it

***NOTE:*** The value of Username and password are in YAML in plain text, however you can choose to run it directly or supply the credentails by typing which is the preferred way.

```cli
az ml connection create --file workspace_connection/my_<storage_type>_connection.yaml --resource-group <my resource group> --workspace-name <my workspace name>
```

**OR by typing the value in the prompt**

```cli
az ml connection create --file my_<storage_type>_connection.yaml --set credentials.username="<type value here>" credentials.username="<type value here>" --resource-group <my resource group> --workspace-name <my workspace name>
```