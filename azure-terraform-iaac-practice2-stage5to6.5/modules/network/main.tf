##########################
# Network Security Group Creation
##########################

# Creates a network security group for sub 1 with an SSH rule allowing inbound traffic on port 22
resource "azurerm_network_security_group" "nsg1" {
  name                = var.nsg_name_sub1
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  description                 = "Allow SSH traffic on port 22"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}

resource "azurerm_network_security_rule" "allow_streamlit" {
  name                        = "Allow-streamlit"
  priority                    = 900
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8501"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  description                 = "Allow Streamlit traffic on port 8501"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}

resource "azurerm_network_security_rule" "allow_fastapi" {
  name                        = "Allow-fastapi"
  priority                    = 800
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5000"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  description                 = "Allow FastAPI traffic on port 5000"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}

resource "azurerm_network_security_rule" "allow_chroma" {
  name                        = "Allow-chroma"
  priority                    = 700
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8000"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  description                 = "Allow ChromaDB traffic on port 8000"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}


# Creates a network security group for sub 2 with an SSH rule allowing inbound traffic on port 22
resource "azurerm_network_security_group" "nsg2" {
  name                = var.nsg_name_sub2
  location            = var.location
  resource_group_name = var.rg_name

}
resource "azurerm_network_security_rule" "Allow_SSH" {
  name                        = "Allow-SSH"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg2.name
}
resource "azurerm_network_security_rule" "allow_http" {
  name                        = "Allow-HTTP"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg2.name
}

resource "azurerm_network_security_rule" "allow_https" {
  name                        = "Allow-HTTPS"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg2.name
}

resource "azurerm_network_security_rule" "allow_appgw_infra" {
  name                        = "Allow-AppGW-Infrastructure"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["65200-65535"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg2.name
  description                 = "Required for App Gateway v2 infrastructure"
}


##########################
# Virtual Network Creation
##########################

# Creates a virtual network in the specified resource group and location
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.rg_name
}

##########################
# Subnets Creation
##########################

# Creates a subnet within the virtual network
resource "azurerm_subnet" "sub1" {
  name                 = var.subnet1_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet1_prefixe
}

# Creates a subnet within the virtual network
resource "azurerm_subnet" "sub2" {
  name                 = var.subnet2_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.subnet2_prefixe
}

resource "azurerm_subnet_network_security_group_association" "sub1link" {
  subnet_id                 = azurerm_subnet.sub1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_subnet_network_security_group_association" "sub2link" {
  subnet_id                 = azurerm_subnet.sub2.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}

##########################
# Public IP Address Creation
##########################

# Creates a static public IP address for use with a network interface
resource "azurerm_public_ip" "chroma_vm" {
  name                = "tr-chroma-ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}

# Creates a static public IP address for use with a network interface
resource "azurerm_public_ip" "streamlit_uvicorn_vm" {
  name                = "tr-streamlit-ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}

##########################
# Network Interface Creation
##########################

# Creates a network interface and assigns a dynamic private IP with a public IP
resource "azurerm_network_interface" "nic1-chroma" {
  name                = var.nic_name1_chroma_vm
  location            = var.location
  resource_group_name = var.rg_name

  # Configuration for IP address allocation and association with a public IP
  ip_configuration {
    name                          = "ip_address_chroma"
    subnet_id                     = azurerm_subnet.sub1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.chroma_vm.id
  }
}



##########################
# Network Interface Security Group Association and Application Gateway
##########################

# Associates the network interface with a network security group for security rules enforcement (Chroma vm)
resource "azurerm_network_interface_security_group_association" "linktoChromavm" {
  network_interface_id      = azurerm_network_interface.nic1-chroma.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}




resource "azurerm_application_gateway" "appgw" {
  name                = "chatbot-appgw"
  resource_group_name = var.rg_name
  location            = var.location
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.sub2.id
  }

  frontend_ip_configuration {
    name                 = "tr-appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.streamlit_uvicorn_vm.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  backend_address_pool {
    name = "tr-vmss-backend-pool"
    # no addresses - backend is linked by VMSS backend pool ID
  }

  backend_http_settings {
    name                  = "http-settings"
    port                  = 8501
    protocol              = "Http"
    cookie_based_affinity = "Disabled"
    request_timeout       = 20
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "tr-appgw-frontend-ip"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "tr-vmss-backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 100  

  }
}
 