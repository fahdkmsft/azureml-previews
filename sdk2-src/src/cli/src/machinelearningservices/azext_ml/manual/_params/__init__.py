# ---------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# ---------------------------------------------------------

from ._job_params import load_job_params
from ._datastore_params import load_datastore_params
from ._model_params import load_model_params
from ._code_params import load_code_params
from ._dataset_params import load_dataset_params
from ._datastore_params import load_endpoint_params


def load_arguments(self, _):
    load_job_params(self)
    load_datastore_params(self)
    load_model_params(self)
    load_code_params(self)
    load_dataset_params(self)
    load_endpoint_params(self)