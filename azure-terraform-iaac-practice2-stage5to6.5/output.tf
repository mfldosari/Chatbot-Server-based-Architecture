#output public ip address for streamlit and uvicorn application gateway access
output "public_ip_address_streamlit_uvicorn" {
  description = "The public IP address assigned to the network interface"
  value       = module.network.public_ip_address_streamlit_uvicorn
}

#output public ip address for chroma vm to ssh to it if needed
output "public_ip_address_chroma" {
  description = "The public IP address assigned to the network interface"
  value       = module.network.public_ip_address_chroma
}

