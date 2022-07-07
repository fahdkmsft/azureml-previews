#!/bin/bash

set -e

subscription_id="<SUBSCRIPTION_ID>"
resource_group="<RESOURCEGROUP_NAME>"
workspace_name="<WORKSPACE_NAME>"
v1_service_name="<SERVICE_NAME>" # Service name of your aks/aci service
local_dir="<LOCAL_PATH>"
online_endpoint_name="<NEW_ENDPOINT_NAME>"
online_deployment_name="<NEW_DEPLOYMENT_NAME>"

migrate_type="Managed"

# STEP1 Export services
echo 'Export services...'
output=$(python3 export-service-util.py --export --export-json -w $workspace_name -g $resource_group -s $subscription_id| tee /dev/tty)
read -r storage_account blob_folder < <(echo "$output" |tail -n1| jq -r '"\(.storage_account) \(.blob_folder)"')

# STEP2 Download template & parameters files
echo 'Download files...'
az storage blob directory download -c azureml --account-name "$storage_account" -s "$blob_folder" -d $local_dir --recursive --subscription $subscription_id --only-show-errors 1> /dev/null

# STEP3 Overwrite parameters
echo 'Overwrite parameters...'
echo
params_file="$local_dir/$blob_folder/$v1_service_name/$migrate_type/$v1_service_name.params.json"
template_file="$local_dir/$blob_folder/online.endpoint.template.json"
output=$(python3 export-service-util.py --overwrite-parameters -mp "$params_file" -me "$online_endpoint_name" -md "$online_deployment_name"| tee /dev/tty)
params=$(echo "$output"|tail -n1)

# STEP4 Deploy to AMLArc/MIR
echo
echo "Params have been saved to $params"
echo "Deploy $migrate_type service $online_endpoint_name..."
deployment_name="Migration-$online_endpoint_name-$(echo $RANDOM | md5sum | head -c 4)"
az deployment group create --name "$deployment_name" --resource-group "$resource_group" --template-file "$template_file" --parameters "$params" --subscription $subscription_id