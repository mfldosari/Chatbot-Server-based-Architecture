##########################
# Resource Group Name
##########################

# The name of the resource group where resources will be created
variable "rg_name" {
  description = "The resource group name"
}

##########################
# Location of Resources
##########################

# The location (Azure region) where resources will be provisioned
variable "db_location" {
  description = "The location of the resources"
}

##########################
# Database Credentials
##########################

# The username for the database
variable "db_username" {
  description = "The username for the database"
}

# The password for the database
variable "db_password" {
  description = "The password for the database"
}

# The table for the database
variable "sqlcommand" {
  description = "The password for the database"
}

