# Azure Machine Learning CLI v2 and Python SDK v2

Azure Machine Learning is introducing a new CLI and Python SDK version. These are called Azure Machine Learning CLI v2 and Azure Machine Learning Python SDK v2. The v2 versions of the SDK bring the following benefits:

* Consistency of features across SDK and CLI - feature set is same across both
* Assets (nouns), properties and actions (verbs) are the same within and across SDK and the CLI. For e.g. to list an asset, the `list` action can be used in both CLI and SDK. The same `list` action can be used to list a compute, model, environment etc.

## Azure Machine Learning CLI v2

The Azure Machine Learning CLI v2 (aka CLI v2) is a new extension for the [Azure CLI](https://docs.microsoft.com/cli/azure/what-is-azure-cli). The CLI v2 provides commands in the format az ml **<noun>** *<verb>* <options> to create and maintain Azure ML assets or workflows. The assets or workflows themselves are defined using a YAML file. The YAML file defines the configuration of the asset or workflow – what is it, where should it run, and so on.

A few examples of CLI v2 commands:

* az ml **job** *create* --file my_job_definition.yaml
* az ml **environment** *update* --name my-env --file my_updated_env_definition.yaml
* az ml **model** *list*
* az ml **compute** *show* --name my_compute

### Use cases for CLI v2

The CLI v2 is useful in the following scenarios:

* On board to Azure ML without the need to learn a specific programming language

    The YAML file defines the configuration of the asset or workflow – what is it, where should it run, and so on. Any custom logic/IP used, say data preparation, model training, model scoring can remain in script files which are referred to in the YAML, but not part of the YAML itself. Azure ML supports script files in python, R, Java, Julia or C#. All you need to learn is YAML format and command lines to use Azure ML. You can stick with script files of your choice.

* Ease of deployment and automation

    The use of command-line for execution makes deployment and automation simpler since workflows can be invoked from any offering/platform which allows users to call the command line.

* Managed Inferencing

    Azure ML offers [endpoints](https://docs.microsoft.com/azure/machine-learning/concept-endpoints) to streamline model deployments for both real-time and batch inference deployments. This functionality is available only via CLI v2 and SDK v2.

* Reusable components in pipelines

    Azure ML introduces [components](https://docs.microsoft.com/azure/machine-learning/concept-component) for managing and reusing common logic across pipelines. This functionality is available only via CLI v2 and SDK v2.

### Get started with CLI v2

* [Install and set up CLI (v2)](https://docs.microsoft.com/azure/machine-learning/how-to-configure-cli)
* [Train models with the CLI (v2)](https://docs.microsoft.com/azure/machine-learning/how-to-train-cli)
* [Deploy and score models with managed online endpoint](https://docs.microsoft.com/azure/machine-learning/how-to-deploy-managed-online-endpoints)

## Azure Machine Learning Python SDK v2

Azure ML Python SDK v2 is an updated Python SDK package offering which allows users to submit training jobs, manage data, models, environment, perform Managed Inferencing (realtime and batch) and stitch together multiple tasks using Azure ML Pipelines to orchestrate workflows. The SDK v2 is on par with CLI v2 functionality and is consistent in how assets (nouns) and actions (verbs) are used between SDK and CLI.

### Use cases for SDK v2

The SDK v2 is useful in the following scenarios:

* Use python functions to build a single step or a complex workflow

    SDK v2 allows you to build a single command or a chain of commands like python functions - the command has a name, parameters, expects input, and returns output.

* Move from simple to complex concepts incrementally

    SDK v2 is designed such that you can construct a single command, add a hyperparameter sweep on top of that command, add the command with various others into a pipeline one after the other. This is useful given the iterative nature of machine learning.

* Reusable components in pipelines

    Azure ML introduces [components](https://docs.microsoft.com/azure/machine-learning/concept-component) for managing and reusing common logic across pipelines. This functionality is available only via CLI v2 and SDK v2.

* Managed Inferencing

    Azure ML offers [endpoints](https://docs.microsoft.com/azure/machine-learning/concept-endpoints) to streamline model deployments for both real-time and batch inference deployments. This functionality is available only via CLI v2 and SDK v2.

### Get started with SDK v2

* [Install and set up SDK (v2) - link TBD](https://docs.microsoft.com/python/api/overview/azure/ml/install?view=azure-ml-py)
* [Train models with the Azure ML Python SDK v2](https://github.com/MicrosoftDocs/azure-docs-pr/blob/release-build-2022-azureml/articles/machine-learning/how-to-train-sdk.md)