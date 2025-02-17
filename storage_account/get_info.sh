# get key and save to environment variables
RESOURCE_GROUP_NAME=tfstate
STORAGE_ACCOUNT_NAME=$(az storage account list --resource-group $RESOURCE_GROUP_NAME --query '[0].name' -o tsv)
CONTAINER_NAME=tfstate

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY

echo $RESOURCE_GROUP_NAME
echo $CONTAINER_NAME
echo $STORAGE_ACCOUNT_NAME
echo $ACCOUNT_KEY
