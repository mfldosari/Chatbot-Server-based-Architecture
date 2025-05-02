##########################
# Virtual Machine Variables
##########################

# Name of the virtual machine (VM)
variable "chroma_vm_name" {
  description = "The name of the virtual machine (Chroma vm)"
}


# The resource group name in which the VM will reside
variable "rg_name" {
  description = "The name of the resource group for the VM"
}

# The location of the resources (e.g., "East US", "West Europe")
variable "location" {
  description = "The location of the resources"
}

# Size of the virtual machine, e.g., "Standard_DS1_v2"
variable "vm_size" {
  description = "The size of the virtual machine"
}

# The admin username to be used for logging into the virtual machine
variable "admin_username" {
  description = "The admin username for the VM"
}

# The network interface (NIC) ID to be associated with the virtual machine
variable "nic_name1_chroma_id" {
  description = "The network interface ID for the VM (chroma vm)"
}



variable "subnet1_id" {
  description = "Subnet ID where VMSS NICs will be attached"
  type        = string
}

variable "appgw_backend_pool_id" {
  description = "Backend address pool ID of the Application Gateway"
  type        = string
}

variable "vmss_name" {
  description = "Vmss name"
  type        = string
}

/* 
variable "streamlit_custom_name" {
  description = "image name"
  type        = string
}

variable "streamlit_custom_rg_name" {
  description = "image resource group  name"
  type        = string
}

variable "chroma_custom_name" {
  description = "image name"
  type        = string
}

variable "chroma_custom_rg_name" {
  description = "image resource group  name"
  type        = string
} */

variable "pathToSSHKey" {
  description = "SSH key path"
  type        = string
}

variable "keyvaultname" {
  description = "Key Vault name"
  type        = string
}
