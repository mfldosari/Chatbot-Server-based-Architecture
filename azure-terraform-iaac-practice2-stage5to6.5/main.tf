##########################
# Resource Group Module
##########################

module "resource_group" {
  source   = "./modules/general/resource_group"
  rg_name  = var.rg_name
  location = var.location
}

##########################
# Security (Key Vault) Module
##########################

module "security" {
  source            = "./modules/security"
  keyvault_name     = var.keyvault_name
  location          = module.resource_group.location
  rg_name           = module.resource_group.rg_name
  tenant_id         = var.tenant_id
  my_object_id      = var.my_object_id
  vmss_principal_id = module.compute.vmss_principal_id

  # Secrets related to the project
  PROJ_DB_NAME                 = var.PROJ_DB_NAME
  PROJ_DB_USER                 = var.PROJ_DB_USER
  PROJ_DB_PASSWORD             = var.PROJ_DB_PASSWORD
  PROJ_DB_HOST                 = module.database.db_host
  PROJ_DB_PORT                 = module.database.db_port
  PROJ_OPENAI_API_KEY          = var.PROJ_OPENAI_API_KEY
  PROJ_AZURE_STORAGE_SAS_URL   = module.storage.sas_url
  PROJ_AZURE_STORAGE_CONTAINER = var.storage_container_name
  PROJ_CHROMADB_HOST           = module.network.chroma_vm_private_ip
  PROJ_CHROMADB_PORT           = var.PROJ_CHROMADB_PORT
}


##########################
# Database Module
##########################

module "database" {
  source      = "./modules/database"
  rg_name     = module.resource_group.rg_name
  db_location = var.db_location
  db_username = var.db_username
  db_password = var.db_password
  sqlcommand  = var.sqlcommand
}

##########################
# Storage Module
##########################

module "storage" {
  source                 = "./modules/storage"
  location               = module.resource_group.location
  rg_name                = module.resource_group.rg_name
  storage_account_name   = var.storage_account_name
  storage_container_name = var.storage_container_name
}



##########################
# Network Module
##########################

module "network" {
  source              = "./modules/network"
  location            = module.resource_group.location
  rg_name             = module.resource_group.rg_name
  address_space       = var.address_space
  subnet1_name        = var.subnet1_name
  subnet2_name        = var.subnet2_name
  subnet1_prefixe     = var.subnet1_prefixe
  subnet2_prefixe     = var.subnet2_prefixe
  nic_name1_chroma_vm = var.nic_name1_chroma_vm
  nsg_name_sub1       = var.nsg_name_sub1
  nsg_name_sub2       = var.nsg_name_sub2
  vnet_name           = var.vnet_name
}



##########################
# Compute (VM and Function App) Module
##########################

module "compute" {
  source                = "./modules/compute"
  location              = module.resource_group.location
  rg_name               = module.resource_group.rg_name
  nic_name1_chroma_id   = module.network.nic_name1_chroma_id
  admin_username        = var.admin_username
  vm_size               = var.vm_size
  chroma_vm_name        = var.chroma_vm_name
  subnet1_id            = module.network.subnetid1
  appgw_backend_pool_id = tolist(module.network.appgw_backend_pool_id)[0]["id"]
  vmss_name             = var.vmss_name
  pathToSSHKey          = var.pathToSSHKey
  keyvaultname          = var.keyvault_name
}









