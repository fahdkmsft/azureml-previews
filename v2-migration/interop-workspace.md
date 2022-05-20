---
title: 'Interoperability of workspace between v1 and v2'
titleSuffix: Azure Machine Learning
description: Forward and backward compatibility of workspace between v1 and v2.
services: machine-learning
ms.service: machine-learning
ms.subservice: core
ms.topic:
ms.author:
author:
ms.date:
---


# Overview of interoperability of workspace

The workspace functionally remains unchanged with the new API platform. There are two network-related changes you must be aware, in the way that the workspace is configured.

## Backward compatibility

* If you were previously creating workspaces using the Azure CLI and using `az ml workspace private-endpoint` commands to configure Azure private link endpoints you require refactoring your code to use `az network private-endpoint` instead. For details, see [Manage Azure Machine Learning workspaces using Azure CLI](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-manage-workspace-cli?tabs=vnetpleconfigurationsv2cli%2Cbringexistingresources2%2Cworkspaceupdatev1%2Cworkspacesynckeysv1%2Cworkspacedeletev1#configure-workspace-for-private-network-connectivity).

## Forward compatibility

* The V2 API platform brings a change to network isolation concepts on Azure Resource Manager. When starting to use V2 on workspaces that use private link endpoint connectivity, you must configure `v1_legacy_mode` parameter. For more details see, [Network Isolation Change with Our New API Platform on Azure Resource Manager](http://aka.ms/amlv2network).

  *	If you use the latest API version (2022-05-01 or later), v1_legacy_mode parameter is set as False and you have no action.
  * If you use the old API version (before 2022-05-01), v1_legacy_mode parameter is set as True and you need to disable it if you want to use V2 features.
  * If you use the public workspace, you have no action.

## Next steps

* [Manage Azure Machine Learning workspaces using Azure CLI](https://docs.microsoft.com/en-us/azure/machine-learning/how-to-manage-workspace-cli?tabs=vnetpleconfigurationsv2cli%2Cbringexistingresources2%2Cworkspaceupdatev1%2Cworkspacesynckeysv1%2Cworkspacedeletev1#configure-workspace-for-private-network-connectivity)
