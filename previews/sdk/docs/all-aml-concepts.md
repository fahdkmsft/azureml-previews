# Concepts in Azure ML

Azure Machine Learning has several resources and assets to enable you to perform your machine learning tasks. The resources and assets are needed to run any job.

* Resources: These are the setup or infrastructural resources needed to run a machine learning workflow. They include:
  * [Workspace](#workspace)
  * [Compute](#compute)
  * [Datastore](#datastore)
* Assets: These are assets you create using Azure ML commands or as part of a training/scoring run. They are versioned and can be registered in the Azure ML workspace. They include:
  * [Model](#model)
  * [Environment](#environment)
  * [Data](#data)
  * [Component](#component)

This document provides a quick overview of these resources and assets.

## Workspace

The workspace is the top-level resource for Azure Machine Learning, providing a centralized place to work with all the artifacts you create when you use Azure Machine Learning. The workspace keeps a history of all jobs, including logs, metrics, output, and a snapshot of your scripts. The workspace stores references to resources like datastores and compute. It also holds all assets like models, environments, components and data asset.

### Creating a workspace

To create a workspace using CLI v2 use the following command:

```bash
az ml workspace create --file my_workspace.yml
```

See the [reference](https://docs.microsoft.com/azure/machine-learning/reference-yaml-workspace) documentation for more details

To create a model using Python SDK v2 you can use the following code:

```python
ws_basic = Workspace(
    name="my-workspace",
    location="eastus", # Azure region (location) of workspace
    display_name="Basic workspace-example",
    description="This example shows how to create a basic workspace"
)
ml_client.workspaces.begin_create(ws_basic) # use MLClient to connect to the subscription and resource group and create workspace
```

Check this [example](https://github.com/Azure/azureml-examples/blob/sdk-preview/sdk/resources/workspace/workspace.ipynb) for more ways to create an Azure ML workspace using SDK v2.

See the [reference](https://review.docs.microsoft.com/python/api/azure-ml/azure.ml.entities.workspace?view=azure-ml-py&branch=sdk-cli-v2-preview-master) documentation for more details.

## Compute

A compute is a designated compute resource where you run your job or host your endpoint. Azure Machine learning supports the following types of compute:

* Compute Cluster - Azure Machine Learning compute cluster is a managed-compute infrastructure that allows you to easily create a cluster of CPU or GPU compute nodes in the cloud.
* Compute Instance - A compute instance is a fully configured and managed development environment in the cloud. You can use the instance as a training or inference compute for development and testing. It is similar to a virtual machine on the cloud.
* Inference Cluster - Inference clusters are used to deploy trained machine learning models to Azure Kubernetes Service. You can create an Azure Kubernetes Service (AKS) cluster from your Azure ML workspace, or attach an existing AKS cluster to do this.
* Attached Compute - You can attach your own compute resources to your workspace and use them for training and inference.

To create a compute using CLI v2 use the following command:

```bash
az ml compute --file my_compute.yml
```

See the [reference](https://docs.microsoft.com/azure/machine-learning/reference-yaml-overview#compute) documentation for more details

To create a compute using Python SDK v2 you can use the following code:

```python
cluster_basic = AmlCompute(
    name="basic-example",
    type="amlcompute",
    size="STANDARD_DS3_v2",
    location="westus",
    min_instances=0,
    max_instances=2,
    idle_time_before_scale_down=120,
)
ml_client.begin_create_or_update(cluster_basic)
```

Check this [example](https://github.com/Azure/azureml-examples/blob/sdk-preview/sdk/resources/compute/compute.ipynb) for more ways to create compute using SDK v2.

See the [reference](https://review.docs.microsoft.com/python/api/azure-ml/azure.ml.entities.compute?view=azure-ml-py&branch=sdk-cli-v2-preview-master) documentation for more details.

## Datastore

Azure Machine Learning datastores securely keep the connection information to your data storage on Azure, so you don't have to code it in your scripts. You can register and create a datastore to easily connect to your storage account, and access the data in your underlying storage service. The CLI v2 and SDK v2 support the following types of cloud-based storage services:

* Azure Blob Container
* Azure File Share
* Azure Data Lake
* Azure Data Lake Gen2

### Creating a datastore

To create a datastore using CLI v2 use the following command:

```bash
az ml datastore create --file my_datastore.yml
```

See the [reference](https://docs.microsoft.com/azure/machine-learning/reference-yaml-overview#datastore) documentation for more details

To create a datastore using Python SDK v2 you can use the following code:

```python
blob_datastore1 = AzureBlobDatastore(
    name="blob-example",
    description="Datastore pointing to a blob container.",
    account_name="mytestblobstore",
    container_name="data-container",
    credentials={
        "account_key": "XXXxxxXXXxXXXXxxXXXXXxXXXXXxXxxXxXXXxXXXxXXxxxXXxxXXXxXxXXXxxXxxXXXXxxxxxXXxxxxxxXXXxXXX"
    },
)
ml_client.create_or_update(blob_datastore1)
```

Check this [example](https://github.com/Azure/azureml-examples/blob/sdk-preview/sdk/resources/datastores/datastore.ipynb) for more ways to create datastores using SDK v2.

## Model

Azure machine learning models consist of the binary file(s) that represent a machine learning model and any corresponding metadata. Models can be created from a local or remote file or directory. For remote locations `https`, `wasbs` and `azureml` locations are supported. The created model will be tracked in the workspace under the specified name and version. Azure ML supports 3 types of storage format for models:

1. `custom_model`
1. `mlflow_model`
1. `triton_model`

### Creating a model

To create a model using CLI v2 use the following command:

```bash
az ml model create --file my_model.yml
```

See the [reference](https://docs.microsoft.com/azure/machine-learning/reference-yaml-model) documentation for more details

To create a model using Python SDK v2 you can use the following code:

```python
my_model = Model(
    path="model.pkl", # the path to where my model file is located
    type="custom_model", # can be custom_model, mlflow_model or triton_model
    name="my-model",
    description="Model created from local file.",
)

ml_client.models.create_or_update(my_model) # use the MLClient to connect to workspace and create/register the model
```

See the [reference](https://review.docs.microsoft.com/python/api/azure-ml/azure.ml.entities.model?view=azure-ml-py&branch=sdk-cli-v2-preview-master) documentation for more details.

## Environment

Azure Machine Learning environments are an encapsulation of the environment where your machine learning task happens. They specify the software packages, environment variables, and software settings around your training and scoring scripts. The environments are managed and versioned entities within your Machine Learning workspace that enable reproducible, auditable, and portable machine learning workflows across a variety of computes.

### Types of Environment

Azure ML supports two types of Environments: curated and custom.

Curated environments are provided by Azure Machine Learning and are available in your workspace by default. Intended to be used as is, they contain collections of Python packages and settings to help you get started with various machine learning frameworks. These pre-created environments also allow for faster deployment time. For a full list, see the [curated environments article](https://docs.microsoft.com/azure/machine-learning/resource-curated-environments).

In custom environments, you're responsible for setting up your environment and installing packages or any other dependencies that your training or scoring script needs on the compute. Azure ML allows you to create your own environment using

* A docker image
* A base docker image with a conda YAML to customize further
* A docker build context

### Creating an Azure ML custom environment

To create an environment using CLI v2 use the following command:

```bash
az ml environment create --file my_environment.yml
```

See the [reference](https://docs.microsoft.com/azure/machine-learning/reference-yaml-environment) documentation for more details.

To create a model using Python SDK v2 you can use the following code:

```python
my_env = Environment(
    image="pytorch/pytorch:latest", # base image to use
    name="docker-image-example", # name of the model
    description="Environment created from a Docker image.",
)

ml_client.environments.create_or_update(my_env) # use the MLClient to connect to workspace and create/register the environment
```

Check this [example](https://github.com/Azure/azureml-examples/blob/sdk-preview/sdk/assets/environment/environment.ipynb) for more ways to create custom environments using SDK v2.

See the [reference](https://review.docs.microsoft.com/python/api/azure-ml/azure.ml.entities.environment?view=azure-ml-py&branch=sdk-cli-v2-preview-master) documentation for more details.

## Data

Azure Machine Learning allows you to work with different types of data:

* URIs (a location in local/cloud storage)
  * `uri_folder`
  * `uri_file`
* Tables (a tabular data abstraction)
  * `mltable`
* Primitives
  * `string`
  * `boolean`
  * `number`

For the vast majority of scenarios you will use URIs (`uri_folder` and `uri_file`) - these are a location in storage that can be easily mapped to the filesystem of a compute node in a job by either mounting or downloading the storage to the node.

`mltable` is an abstraction for tabular data that is to be used for AutoML Jobs, Parallel Jobs, and some advanced scenarios. If you are just starting to use Azure Machine Learning and are not using AutoML we strongly encourage you to begin with URIs.

Refer this [document](./how-to-use-data.md) for more details on how to work with data in Azure ML.

## Component

An Azure Machine Learning [component](https://docs.microsoft.com/azure/machine-learning/concept-component) is a self-contained piece of code that does one step in a machine learning pipeline. Components are the building blocks of advanced machine learning pipelines. Components can do tasks such as data processing, model training, model scoring, and so on. A component is analogous to a function - it has a name, parameters, expects input, and returns output. 