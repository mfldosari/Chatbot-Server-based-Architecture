# Required Inputs — update these as needed
SUBSCRIPTION_ID=""
RESOURCE_GROUP=""
VAULT_NAME=""
APP_NAME=""  

# Get the service principal object ID for the existing GitHubActions app
SP_OBJECT_ID=$(az ad sp list --filter "displayName eq '$APP_NAME'" --query "[0].id" -o tsv)

# Assign "Key Vault Secrets User" role at the Key Vault scope
az role assignment create \
  --assignee-object-id "$SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Key Vault Secrets User" \
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/$VAULT_NAME"
