##########################
# Key Vault Resource
##########################

resource "azurerm_key_vault" "kv" {
  # Basic Information
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rg_name
  tenant_id                   = var.tenant_id
  
  # SKU and Access Configuration
  sku_name                    = "standard"
  enable_rbac_authorization   = true

  # Soft Delete and Purge Protection
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  
  # Network Access Configuration
  public_network_access_enabled = true  

  # Tags
  tags = {
    managed_by = "terraform"
  }
}



##########################
# IAM Role Assignment (Self) and (VMSS)
##########################

resource "azurerm_role_assignment" "kv_admin" {
  principal_id         = var.my_object_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.kv.id
}

# Role assignment to allow VM to access secrets in the Key Vault
resource "azurerm_role_assignment" "vmss_kv_access" {
  principal_id         = var.vmss_principal_id  
  role_definition_name = "Key Vault Secrets User"  
  scope                = azurerm_key_vault.kv.id  
}


resource "azurerm_key_vault_secret" "dbname" {
  name         = "PROJ-DB-NAME"
  value        = var.PROJ_DB_NAME
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "dbuser" {
  name         = "PROJ-DB-USER"
  value        = var.PROJ_DB_USER
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "dbpassword" {
  name         = "PROJ-DB-PASSWORD"
  value        = var.PROJ_DB_PASSWORD
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "dbhost" {
  name         = "PROJ-DB-HOST"
  value        = var.PROJ_DB_HOST
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "dbport" {
  name         = "PROJ-DB-PORT"
  value        = var.PROJ_DB_PORT
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "openai_key" {
  name         = "PROJ-OPENAI-API-KEY"
  value        = var.PROJ_OPENAI_API_KEY
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "sas_url" {
  name         = "PROJ-AZURE-STORAGE-SAS-URL"
  value        = var.PROJ_AZURE_STORAGE_SAS_URL
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "container_name" {
  name         = "PROJ-AZURE-STORAGE-CONTAINER"
  value        = var.PROJ_AZURE_STORAGE_CONTAINER
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "chroma_host" {
  name         = "PROJ-CHROMADB-HOST"
  value        = var.PROJ_CHROMADB_HOST
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

resource "azurerm_key_vault_secret" "chroma_port" {
  name         = "PROJ-CHROMADB-PORT"
  value        = var.PROJ_CHROMADB_PORT
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_role_assignment.kv_admin]
}

