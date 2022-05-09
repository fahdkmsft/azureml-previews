---
title: 'What is an environment?'
titleSuffix: Azure Machine Learning
description: What is an environment?
services: machine-learning
ms.service: machine-learning
ms.subservice: core
ms.topic: conceptual
ms.author: sagopal
author:
ms.date: 5/13/22
---


# What is an Azure Machine Learning environment?

Azure Machine Learning environments define the execution environments for your jobs or deployments and encapsulate the dependencies for your code. Azure ML uses the environment specification to create the Docker container that your training or scoring code runs in on the specified compute target. You can define an environment from a conda specification, Docker image, or Docker build context.

You can use an `Environment` object on your local compute to:

* Develop your training script.
* Reuse the same environment on Azure Machine Learning Compute for model training at scale.
* Deploy your model with that same environment.
* Revisit the environment in which an existing model was trained.

## Types of Environments 

There are two types of environments in Azure ML: curated and custom environments. Curated environments are predefined environments containing popular ML frameworks and tooling. Custom environments are user-defined and can be created via `az ml environment create`.

Curated environments are provided by Azure ML and are available in your workspace by default. Azure ML routinely updates these environments with the latest framework version releases and maintains them for bug fixes and security patches. They are backed by cached Docker images, which reduces job preparation cost and model deployment time.

You can use these curated environments out of the box for training or deployment by referencing a specific environment using the `azureml:<curated-environment-name>:<version>` or `azureml:<curated-environment-name>@latest` syntax. You can also use them as reference for your own custom environments by modifying the Dockerfiles that back these curated environments.

You can see the set of available curated environments in the Azure ML studio UI, or by using the CLI (v2) via `az ml environments list`.

## Create and Manage Environments

You can create environments from clients like the AzureML Python SDK, Azure Machine Learning CLI, Environments page in Azure Machine Learning studio, and VS Code extension. Every client allows you to customize the base image, Dockerfile, and Python layer if needed.

For specific code samples, see the "Create an environment" section of [How to use environments](https://docs.microsoft.com/azure/machine-learning/how-to-manage-environments-v2).

Environments are also easily managed through your workspace, which allows you to:

Register environments.
* Fetch environments from your workspace to use for training or deployment.
* Create a new instance of an environment by editing an existing one.
* View changes to your environments over time, which ensures reproducibility.
* Build Docker images automatically from your environments.

"Anonymous" environments are automatically registered in your workspace when you submit an experiment. They will not be listed but may be retrieved by version.

## Next Steps

* [How to use Environments](https://docs.microsoft.com/azure/machine-learning/how-to-manage-environments-v2)
* [Environment YAML Schema](https://docs.microsoft.com/azure/machine-learning/reference-yaml-environment)
