set -x

rg_name="<resource group placeholder>"
location="<location placeholder>"
az_sub="<azure subscription placeholder>"

# this is optional, required by some policies - ignore if your org does not need this. 
owner_alias="owner_alias_placeholder"

# this is optional, required by some policies - ignore if your org does not need this. 
SkipAutoDeleteTillDate="2023-01-01"

if [[ -z "$rg_name" ]]
then
    echo "rg_name missing"
    exit 1
fi

if [[ -z "$location" ]]
then
    echo "location missing"
    exit 1
fi

if [[ -z "$az_sub" ]]
then
    echo "az_sub missing"
    exit 1
fi

# Comment this command if you plan to reuse an existing RG.
az group create --name $rg_name --location $location --subscription $az_sub --tags owner=$owner_alias SkipAutoDeleteTill=$SkipAutoDeleteTillDate

az deployment group create --subscription $az_sub --resource-group $rg_name --template-file ./AzureMLRegistry.bicep --parameters ./registry-properties.json