##########################
# General Configuration
##########################

rg_name    = "" # Resource group name
location   = "" # Azure region (e.g., East US)


##########################
# Virtual Network & Subnets
##########################

vnet_name       = "" # Virtual network name
subnet1_name    = "" # Subnet 1 (e.g., for VMs)
subnet2_name    = "" # Subnet 2 (e.g., for App Gateway)
address_space   = [] # VNet address space (e.g., ["10.0.0.0/16"])
subnet1_prefixe = [] # Subnet 1 CIDR (e.g., ["10.0.0.0/24"])
subnet2_prefixe = [] # Subnet 2 CIDR (e.g., ["10.0.1.0/24"])


##########################
# Network Security Groups & NICs
##########################

nsg_name_sub1       = "" # NSG for subnet 1
nsg_name_sub2       = "" # NSG for subnet 2
nic_name1_chroma_vm = "" # NIC for Chroma VM


##########################
# Virtual Machines
##########################

chroma_vm_name = "" # Chroma VM name
vm_size        = "" # VM size (e.g., Standard_B1s)
admin_username = "" # VM admin username


##########################
# Azure Identity
##########################

subscription_id = "" # Azure subscription ID
tenant_id       = "" # Azure tenant ID


##########################
# Storage
##########################

storage_account_name   = "" # Storage account name
storage_container_name = "" # Blob container name


##########################
# Database Configuration
##########################

db_location = "" # Region for DB
db_username = "" # DB username
db_password = "" # DB password (use sensitive var)
sqlcommand  = "" # SQL to initialize DB


##########################
# Key Vault
##########################

keyvault_name = "" # Key Vault name
my_object_id  = "" # Azure AD object ID (for access policy)


##########################
# Project Secrets
##########################

PROJ_DB_NAME         = "" # DB name
PROJ_DB_USER         = "" # DB user
PROJ_DB_PASSWORD     = "" # DB password
PROJ_OPENAI_API_KEY  = "" # OpenAI API key
PROJ_CHROMADB_PORT   = "" # ChromaDB port


##########################
# VM Scale Set
##########################

vmss_name = "" # VM Scale Set name


##########################
# SSH Key
##########################

pathToSSHKey = "" # Path to SSH public key (e.g., ~/.ssh/id_rsa.pub)
