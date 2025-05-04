
##########################
# Storage Account Configuration
##########################

# Storage Account Resource
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

# Storage Container Resource
resource "azurerm_storage_container" "this" {
  name                  = var.storage_container_name 
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"

  depends_on = [azurerm_storage_account.this]
}


resource "null_resource" "generate_sas_url" {
  provisioner "local-exec" {
    command = "bash /home/whitehat/stage6.5/azure-terraform-iaac-practice2-stage5to6.5/modules/storage/sas.sh"
  }
    depends_on = [azurerm_storage_container.this]

}

  https_only = true
}
