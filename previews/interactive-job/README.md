## Overview
ML model training usually requires lots of experimentation and iterations. With the new AzureML interactive job experience, data scientists can now use CLI v2 or AzureML Studio Portal to quickly check out their required compute resources with custom environment, login to the compute via JupyterNotebook, JupyterLab, TensorBoard, or VS Code (VS Code will be available in August) to iterate on training scripts, monitor the training progress or debug the job remotely like they usually do on their local machines, while keeping the operation cost optimized for resource allocation and utilization as a team.

Interactive job is supported on **AzureML Compute Cluster** and **Azure Arc-enabled Kubernetes Cluster**  and will be available on Compute Instance in later release.

## Prerequisites
- To use the CLI (v2), you must have an Azure subscription. If you don't have an Azure subscription, create a free account before you begin. Try the [free or paid version of Azure Machine Learning](https://azure.microsoft.com/free/) today.
- [Install and set up CLI (v2)](how-to-configure-cli.md).
- If you are under VNet, you must [enable outbound traffic](https://docs.microsoft.com/azure/machine-learning/how-to-access-azureml-behind-firewall?tabs=ipaddress%2Cpublic#outbound-configuration) for UDP 5831 to AzureMachineLearning in order to use this feature.

## Get started
### Submit an interactive job via CLI v2
1. Create a job yaml `job.yaml` with below sample content. Make sure to replace `your compute name` with your own value. If you want to use custom environment, follow the examples in [this tutorial](https://docs.microsoft.com/azure/machine-learning/how-to-manage-environments-v2) to create a custom environment. 
```dotnetcli
code: src 
command: 
  python train.py 
  sleep 1h # you can add other commands before "sleep 1h", the sleeping time can be put at the end so that the compute resource is reserved after the script finishes running.
environment: azureml:AzureML-sklearn-0.24-ubuntu18.04-py37-cpu:5
environment_variables: 
  AZUREML_COMMON_RUNTIME_USE_INTERACTIVE_CAPABILITY: 'True' 
compute:
  target: azureml:<your compute name>
services:
  "my_jupyter":
    job_service_type: "Jupyter" # Jupyter Notebook
  "my_tensorboard":
    job_service_type: "TensorBoard"
    properties:
      logDir: "~/tblog" # where you want to store the TensorBoard output 
  "my_jupyterlab":
    job_service_type: "JupyterLab"
```
Please make sure to set the environment variable `AZUREML_COMMON_RUNTIME_USE_INTERACTIVE_CAPABILITY: 'True'` in order to enable the interactive capability in preview. The `services` section specifies the training applications you want to interact with.  
You can put `sleep <specific time>` at the end of the command to speicify the amount of time you want to reserve the compute resource. The format follows: 
* sleep 1s
* sleep 1m
* sleep 1h
* sleep 1d
You can also put `sleep infinity`. Note that if you put `sleep infinity`, you will need to cancel the job after you finish the work. We will work on an auto termination policy for this scenario in later release. 
 
2. Run command `az ml job create --file <path to your job yaml file> --workspace-name <your workspace name> --resource-group <your resource group name> --subscription <sub-id> `

### Submit an interactive job via AzureML studio portal
1. Create a new job from the left navigation pane in the studio portal.
![screenshot selct-job-ui](./media/selectjob.png)
1. Choose `Compute cluster` or `Attached compute` (Kubernetes) as the compute type, choose the compute target, and specify how many nodes you need in `Instance count`. Note that for distributed job, you can only access the head node in the current release.
![screenshot select-compute-ui](./media/selectcompute.png)
1. Follow the wizard to choose the environment you want to start the job.
1. In `Job settings` step, add your training code (and input/output data) and reference it in your command to make sure it's mounted to your job. **You can end your command with `sleep <specific time>` to reserve the resource.** An example is like below:
![screenshot set-command](./media/setcommand.png)
1. Select the training applications you want to interact with in the job.
![screenshot select-apps](./media/selectapps.png)
1. Review and create the job.


### Connect to endpoints
It might take a few minutes to start the job and applications specified. After the job is submitted and in **Running** state, you can connect to the applications by finding them from the job details page on the studio portal or directly from the CLI.
#### Connect via CLI v2
When the job is **running**, Run the command `az ml job show <your job name>` to get the URL to the applications. The endpoint URL will show under `services` in the output. Here is an example:
![screenshot show-services-cli](./media/servicescli.png)

#### Connect via AzureML studio portal
1. You can connect to the applications by clicking the button **Access training applications** in the job details page. 
![screenshot connect-to-apps](./media/accessbutton.png)
Clicking the applications in the panel opens a new tab for the applications. Please note that you can access the applications only when the applications is in **Running** status and only the **job owner** is authorized to access the applications.
![screenshot apps-panel](./media/appspanel.png)

### Interact with the applications
1. Open a terminal from Jupyter Notebook or Jupyter Lab and start interacting within the job container. You are landed on the home folder **/home/amluser**. **my_files** is a user level folder where you can keep your scripts and output data there. Next time when you submit a new job, this folder will be mounted to it as well.
![screenshot my_files](./media/my_files.png)
1. You can find the mounted data in `/tmp` folder.
![screenshot open-terminal](./media/open-terminal.png) 
1. If you run into any issues, the interactive capability and applications logs can be found from **system_logs->interactive_capability** under **Outputs + logs** tab.
![screenshot check-logs](./media/ijlogs.png)

### Release the compute resource
1. Once you are done with the interactive training, you can also go to the job details page to cancel the job. This will release the compute resource. Alternatively, use `az ml job cancel -n <your job name>` in the CLI. 
![screenshot cancel-job](./media/canceljob.png)

## Contact us
Reach out to us: interactivetraining@service.microsoft.com if you have any questions or feedback.
