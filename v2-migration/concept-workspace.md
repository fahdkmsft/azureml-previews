---
title: 'What is a workspace?'
titleSuffix: Azure Machine Learning
description: The workspace is the top-level resource for Azure Machine Learning. It keeps a history of all training runs, with logs, metrics, output, and a snapshot of your scripts.
services: machine-learning
ms.service: machine-learning
ms.subservice: core
ms.topic: conceptual
ms.author: deeikele
author: deeikele
ms.date: 05/13/2022
---


# What is an Azure Machine Learning workspace?

An Azure Machine Learning workspace is an environment for accessing and grouping your Azure Machine Learning artifacts. The workspace organizes objects including jobs, data, models, endpoints and notebooks, and also provides access to data and computational resources such as clusters. The workspace keeps a history of all training runs, including logs, metrics, outputs, and a snapshot of your scripts. You can use this information to compare runs, determine which training run produces the best models, and to debug your code.

*TBD screenshot*

You can access the workspace using the [Azure Machine Learning studio](https://ml.azure.com), the Azure CLI, the Azure Machine Learning SDK or the [Azure Machine Learning VS Code Extension](how-to-manage-resources-vscode.md#workspaces).

## What content is managed in the workspace?

*TBD*

* Jobs
* Data
* Environments
* Models
* Endpoints

## What resources are managed by the workspace?

*TBD*

* Compute clusters
* Compute instances
* Attached compute resources
* Connections

## <a name='create-workspace'></a> Create a workspace

There are multiple ways to create a workspace:  

* Use the [Azure portal](how-to-manage-workspace.md?tabs=azure-portal#create-a-workspace) for a point-and-click interface to walk you through each step.
* Use the [Azure Machine Learning SDK for Python](how-to-manage-workspace.md?tabs=python#create-a-workspace) to create a workspace on the fly from Python scripts or Jupyter notebooks.
* Use an [Automation template](how-to-create-workspace-template.md) or the [Azure Machine Learning CLI](reference-azure-machine-learning-cli.md) when you need to automate or customize the creation with corporate security standards.
* If you work in Visual Studio Code, use the [VS Code extension](how-to-manage-resources-vscode.md#create-a-workspace).

> [!Tip]
> When you create a new workspace, you can give your workspace a display name and a description. You can use these fields to capture your machine learning project's experimentation goals, findings and domain knowledge. Along with the security and data isolation boundary the workspace provides, this makes the workspace well-suited for machine learning-project collaboration.

## Managing the workspace

Availability of management actions varies dependent on your method of accessing with the workspace:

| Workspace management task   | Portal              | Studio | Python SDK      | Azure CLI        | VS Code
|---------------------------|---------|---------|------------|------------|------------|
| Create a workspace        | **&check;**     | | **&check;** | **&check;** | **&check;** |
| Manage workspace access    | **&check;**   || |  **&check;**    ||
| Create and manage compute resources    | **&check;**   | **&check;** | **&check;** |  **&check;**   ||
| Create a Notebook VM |   | **&check;** | |     ||

> [!WARNING]
> Moving your Azure Machine Learning workspace to a different subscription, or moving the owning subscription to a new tenant, is not supported. Doing so may cause errors.

## <a name="resources"></a> Associated resources

When you create a new workspace, it automatically creates several Azure resources that are used by the workspace:

+ [Azure Storage account](https://azure.microsoft.com/services/storage/): Is used as the default datastore for the workspace.  Jupyter notebooks that are used with your Azure Machine Learning compute instances are stored here as well. 
  
  > [!IMPORTANT]
  > By default, the storage account is a general-purpose v1 account. You can [upgrade this to general-purpose v2](../storage/common/storage-account-upgrade.md) after the workspace has been created. 
  > Do not enable hierarchical namespace on the storage account after upgrading to general-purpose v2.

  To use an existing Azure Storage account, it cannot be of type BlobStorage or a premium account (Premium_LRS and Premium_GRS). It also cannot have a hierarchical namespace (used with Azure Data Lake Storage Gen2). Neither premium storage nor hierarchical namespaces are supported with the _default_ storage account of the workspace. You can use premium storage or hierarchical namespace with _non-default_ storage accounts.
  
+ [Azure Container Registry](https://azure.microsoft.com/services/container-registry/): Registers docker containers that are used for the following components:
    * [Azure Machine Learning environments](concept-environments.md) when training and deploying models
    * [AutoML](concept-automated-ml.md) when deploying
    * [Data profiling](how-to-connect-data-ui.md#data-profile-and-preview)

    To minimize costs, Azure Container Registry is **lazy-loaded** until images are needed.

    > [!NOTE]
    > If your subscription setting requires adding tags to resources under it, Azure Container Registry (ACR) created by Azure Machine Learning will fail, since we cannot set tags to ACR.

+ [Azure Application Insights](https://azure.microsoft.com/services/application-insights/): Stores monitoring and diagnostics information. For more information, see [Monitor and collect data from Machine Learning web service endpoints](../../articles/machine-learning/how-to-enable-app-insights.md).

    > [!NOTE]
    > You can delete the Application Insights instance after cluster creation if you want. Deleting it limits the information gathered from the workspace, and may make it more difficult to troubleshoot problems. __If you delete the Application Insights instance created by the workspace, you cannot re-create it without deleting and recreating the workspace__.

+ [Azure Key Vault](https://azure.microsoft.com/services/key-vault/): Stores secrets that are used by compute targets and other sensitive information that's needed by the workspace.

> [!NOTE]
> You can instead use existing Azure resource instances when you create the workspace with the [Python SDK](how-to-manage-workspace.md?tabs=python#create-a-workspace) or the Azure Machine Learning CLI [using an ARM template](how-to-create-workspace-template.md).

## <a name="sub-resources"></a> Sub resources

Dependent on your workspace configuration, the following sub resources are created along with your workspace.

* VMs: provide computing power for your Azure Machine Learning workspace and are an integral part in deploying and training models.
* Load Balancer: a network load balancer is created for each compute instance and compute cluster to manage traffic even while the compute instance/cluster is stopped.
* Virtual Network: these help Azure resources communicate with one another, the internet, and other on-premises networks.
* Bandwidth: encapsulates all outbound data transfers across regions.

## Next steps

To learn about common patterns in setting up Azure Machine Learning workspaces, to meet your organization's requirements, see [Organize and set up Azure Machine Learning](/azure/cloud-adoption-framework/ready/azure-best-practices/ai-machine-learning-resource-organization).

To get started with Azure Machine Learning, see:

+ [What is Azure Machine Learning?](overview-what-is-azure-machine-learning.md)
+ [Create and manage a workspace](how-to-manage-workspace.md)
+ [Tutorial: Get started with Azure Machine Learning](quickstart-create-resources.md)
+ [Tutorial: Create your first classification model with automated machine learning](tutorial-first-experiment-automated-ml.md) 
+ [Tutorial: Predict automobile price with the designer](tutorial-designer-automobile-price-train-score.md)

