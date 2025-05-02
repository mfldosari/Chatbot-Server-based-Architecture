##########################
# Network Interface Outputs
##########################

output "nic_name1_chroma_id" {
  description = "The ID of the network interface (Chroma NIC)"
  value       = azurerm_network_interface.nic1-chroma.id
}



##########################
# Public IP Address Outputs
##########################

output "public_ip_address_chroma" {
  description = "The public IP address assigned to the network interface (Chroma VM IP)"
  value       = azurerm_public_ip.chroma_vm.ip_address
}

output "public_ip_address_streamlit_uvicorn" {
  description = "The public IP address assigned to the network interface (Streamlit and Uvicorn VM IP)"
  value       = azurerm_public_ip.streamlit_uvicorn_vm.ip_address
}

output "subnetid1" {
  description = "The public IP address assigned to the network interface (Streamlit and Uvicorn VM IP)"
  value       = azurerm_subnet.sub1.id
}

output "appgw_backend_pool_id" {
  value = azurerm_application_gateway.appgw.backend_address_pool 
}

output "chroma_vm_private_ip" {
  description = "The private IP address of the Chroma VM"
  value       = azurerm_network_interface.nic1-chroma.ip_configuration[0].private_ip_address
}
