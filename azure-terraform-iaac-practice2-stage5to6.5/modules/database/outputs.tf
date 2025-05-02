##########################
# Output the Database Details
##########################

output "db_host" {
  description = "The host of the PostgreSQL database"
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "db_port" {
  description = "The port of the PostgreSQL database"
  value       = "5432"  
}