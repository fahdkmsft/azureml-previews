# Migration steps for ACI deployment to Managed online endpoint

Managed online endpoints help to deploy your ML models in a turnkey manner. Managed online endpoints work with powerful CPU and GPU machines in Azure in a scalable, fully managed way. Managed online endpoints take care of serving, scaling, securing, and monitoring your models, freeing you from the overhead of setting up and managing the underlying infrastructure. Details can be found on [Deploy and score a machine learning model by using an online endpoint](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-deploy-managed-online-endpoints)

You can deploy directly to the new compute target with your previous models and environments, or leverage the script provided by us to export the current services then deploy to the new compute.

Here're the steps to use these scripts.

1. Linux/WSL to run the bash script.
2. Install Python SDK V1 to run the python script.
3. Install Azure CLI.
4. Edit the subscription/resourcegroup/workspace/service name info in export-service.sh, also the expected new endpoint name and deployment name. We recommend that the new endpoint name is different from the previous one.
5. Execute the bash script, it will take several minutes to finish the new deployment.