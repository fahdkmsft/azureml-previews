# Azure Machine Learning previews

Welcome to the Azure Machine Learning previews repository!

## ❗Important

**Features contained in this repository are in private preview. Preview versions are provided without a service level agreement, and they are not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/en-us/support/legal/preview-supplemental-terms/).**

## Prerequisites

1. An Azure subscription. If you don't have an Azure subscription, [create a free account](https://aka.ms/AMLFree) before you begin.
2. A terminal. [Install and set up the CLI (v2)](https://docs.microsoft.com/azure/machine-learning/how-to-configure-cli) before you begin.

## Private previews

**preview**|**description**
-|-
[pipelines](previews/pipelines)|Pipelines for the CLI (v2), defined through YAML specification
[interactive-job](previews/interactive-job)|Run an interactive job on Arc compute
[automl](https://github.com/Azure/AutoML-vNext-Preview)|AutoML for the CLI (v2), defined through YAML specification
[automl-dnn-nlp](previews/automl-dnn-nlp)|AutoML for language data powered by BERT, available to multiclass, multilabel and NER tasks.
[automatic-compute](previews/automatic-compute)|Submit training jobs without having to create a compute target.

## Contents

directory|description
-|-
`previews`|Self-contained directories of private previews

## Contributing

We welcome contributions and suggestions! Please see the [contributing guidelines](CONTRIBUTING.md) for details.

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). Please see the [code of conduct](CODE_OF_CONDUCT.md) for details.
