# Output the VM's managed identity principal ID for use in the root module
output "vmss_principal_id" {
  value = azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id
}