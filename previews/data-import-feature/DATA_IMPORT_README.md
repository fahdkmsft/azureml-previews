# Connect External data source via data import in Azure Machine Learning (Private Preview)

## ❗Important
**AzureML data import (connect external data source) is currently in private preview. The preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/en-us/support/legal/preview-supplemental-terms/).**


## Overview

This document outlines how to use the data import feature to connecto to external data sources and bring in data in to Azure Machine Learning (ML). This gives the pre-requisties for using the samples provided in the [samples](./samples) directory

## Prerequisites

* Please fill out [this form](https://aka.ms/AzureMLImportFeaturePreview) to join the private preview.
* Azure subscription. If you don't have an Azure subscription, sign up to try the [free or paid version of Azure Machine Learning](https://azure.microsoft.com/free/) today.

>**NOTE:** Additional charges for the usage of compute and storage would be applicable for running the import job and storing the imported data. Customers can manage the frequency of import as well as the time of data expiry to manage costs.

> **NOTE:** Your job run will take ~3mins to ~8mins on Snowflake or AzSQL for a table of 35GB to 50GB

## 🎓 Learn

Below are some sample notebooks:

- [Create your first workspace connection creation](./notebooks/create_ws_connection_sdk_v2.ipynb)
- [Run your first data import job](./notebooks/create_job_sdk_v2.ipynb)
- [Run your first data import in a pipeline job](./notebooks/create_pipeline_job_sdk_v2.ipynb)

## 🛣️ Coming soon

⭐ UI support.  
⭐ Create/Delete/Update workspace connections in Studio UI.  
⭐ VNET support.  
⭐ Data refresh schedule.  
⭐ Managed datacache experience.


## ✉️ Feedback and Support
If you have feedback or require support during this private preview, please send us an [email](mailto:azuremldatasupport@microsoft.com).