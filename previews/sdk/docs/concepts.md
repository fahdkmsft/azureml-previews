# Concepts in Azure ML

## Workspace

The workspace is the top-level resource for Azure Machine Learning, providing a centralized place to work with all the artifacts you create when you use Azure Machine Learning. The workspace keeps a history of all jobs, including logs, metrics, output, and a snapshot of your scripts. The workspace stores references to resources like datastores and compute. It also holds all assets like models, environments, components and data asset.

### Creating a workspace

To create a workspace.

## Compute

A compute is a designated compute resource where you run your job or host your endpoint. Azure Machine learning supports the following types of compute:

* Compute Cluster - Azure Machine Learning compute cluster is a managed-compute infrastructure that allows you to easily create a single or multi-node compute.
* Compute Instance
* Inference Cluster
* Attached COmpute 

TBD

## Model

Azure machine learning models consist of the binary file(s) that represent a machine learning model and any corresponding metadata. Models can be created from a local or remote file or directory. For remote locations `https`, `wasbs` and `azureml` locations are supported. The created model will be tracked in the workspace under the specified name and version. Azure ML supports 3 types of storage format for models:

1. `custom_model`
1. `mlflow_model`
1. `triton_model`

### Creating a model

To create a model using Python SDK v2 you can use the following code:

```python
my_model = Model(
    path="model.pkl", # the path to where my model file is located
    type="custom_model", # can be custom_model, mlflow_model or triton_model
    name="my-model",
    description="Model created from local file.",
)

ml_client.models.create_or_update(file_model) # use the MLClient to connect to workspace and register the model
```

See the [reference](https://review.docs.microsoft.com/python/api/azure-ml/azure.ml.entities.model?view=azure-ml-py&branch=sdk-cli-v2-preview-master) documentation for more details.
