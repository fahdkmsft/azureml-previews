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

> [!NOTE]
> When creating an environment, a base image must be specified.

For specific code samples, see the "Create an environment" section of [How to use environments](https://docs.microsoft.com/azure/machine-learning/how-to-manage-environments-v2).

Environments are also easily managed through your workspace, which allows you to:

Register environments.
* Fetch environments from your workspace to use for training or deployment.
* Create a new instance of an environment by editing an existing one.
* View changes to your environments over time, which ensures reproducibility.
* Build Docker images automatically from your environments.

"Anonymous" environments are automatically registered in your workspace when you submit an experiment. They will not be listed but may be retrieved by version.

## Environment building, caching, and reuse

Azure Machine Learning builds environment definitions into conda specifications, Docker images, or Docker build contexts. It also caches the environments so they can be reused in subsequent training runs and service endpoint deployments.  

### Submitting a run using an environment

When you first submit a remote run using an environment, the Azure Machine Learning service invokes an [ACR Build Task](../container-registry/container-registry-tasks-overview.md) on the Azure Container Registry (ACR) associated with the Workspace. The built Docker image is then cached on the Workspace ACR. Curated environments are backed by Docker images that are cached in Global ACR. At the start of the run execution, the image is retrieved by the compute target from the relevant ACR.

### Image caching and reuse

If you use the same environment definition for another run, Azure Machine Learning reuses the cached image from the Workspace ACR to save time.

To determine whether to reuse a cached image or build a new one, AzureML computes a [hash value](https://en.wikipedia.org/wiki/Hash_table) from the environment definition and compares it to the hashes of existing environments. The hash is based on the environment definition's:
 
 * Base image
 * Custom docker steps
 * Python packages
 * Spark packages

The hash isn't affected by the environment name or version. If you rename your environment or create a new one with the same settings and packages as another environment, then the hash value will remain the same. However, environment definition changes like adding or removing a Python package or changing a package version will result cause the resulting hash value to change. Changing the order of dependencies or channels in an environment will also change the hash and require a new image build. Similarly, any change to a curated environment will result in the creation of a new "non-curated" environment. 

> [!NOTE]
> You will not be able to submit any local changes to a curated environment without changing the name of the environment. The prefixes "AzureML-" and "Microsoft" are reserved exclusively for curated environments, and your job submission will fail if the name starts with either of them.

The environment's computed hash value is compared with those in the Workspace and global ACR, or on the compute target (local runs only). If there is a match then the cached image is pulled and used, otherwise an image build is triggered.

The following diagram shows three environment definitions. Two of them have different names and versions but identical base images and Python packages, which results in the same hash and corresponding cached image. The third environment has different Python packages and versions, leading to a different hash and cached image.

![Diagram of environment caching and Docker images](./media/concept-environments/environment-caching.png)

Actual cached images in your workspace ACR will have names like `azureml/azureml_e9607b2514b066c851012848913ba19f` with the hash appearing at the end.

>[!IMPORTANT]
> * If you create an environment with an unpinned package dependency (for example, `numpy`), the environment uses the package version that was *available when the environment was created*. Any future environment that uses a matching definition will use the original version. 
>
>   To update the package, specify a version number to force an image rebuild. An example of this would be changing `numpy` to `numpy==1.18.1`. New dependencies--including nested ones--will be installed, and they might break a previously working scenario.
>
> * Using an unpinned base image like `mcr.microsoft.com/azureml/openmpi3.1.2-ubuntu18.04` in your environment definition results in rebuilding the image every time the `latest` tag is updated. This helps the image receive the latest patches and system updates.

> [!WARNING]
>  The [`Environment.build`](/python/api/azureml-core/azureml.core.environment.environment#build-workspace--image-build-compute-none-) method will rebuild the cached image, with the possible side-effect of updating unpinned packages and breaking reproducibility for all environment definitions corresponding to that cached image.

### Image patching

Microsoft is responsible for patching the base images for known security vulnerabilities. Updates for supported images are released every two weeks, with a commitment of no unpatched vulnerabilities older than 30 days in the the latest version of the image. Patched images are released with a new immutable tag and the `:latest` tag is updated to the latest version of the patched image. 

If you provide your own images, you are responsible for updating them.

For more information on the base images, see [Azure Machine Learning base images](https://github.com/Azure/AzureML-Containers) GitHub repository.


## Next Steps

* [How to use Environments](https://docs.microsoft.com/azure/machine-learning/how-to-manage-environments-v2)
* [Environment YAML Schema](https://docs.microsoft.com/azure/machine-learning/reference-yaml-environment)
