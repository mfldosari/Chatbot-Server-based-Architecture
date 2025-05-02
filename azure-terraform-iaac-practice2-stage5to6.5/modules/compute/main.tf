##########################
# Linux Virtual Machine (VM) Resource
##########################
/* data "azurerm_image" "streamlit_custom" {
name                = var.streamlit_custom_name
resource_group_name = var.streamlit_custom_rg_name 
}

data "azurerm_image" "chroma_custom" {
name                = var.chroma_custom_name
resource_group_name = var.chroma_custom_rg_name 
} */


# Define an Azure Linux Virtual Machine with the provided configuration
resource "azurerm_linux_virtual_machine" "chroma_vm" {
  name                = var.chroma_vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    var.nic_name1_chroma_id,
  ]

  # Admin SSH key for secure access to the VM
  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.pathToSSHKey) 
  }

  # OS disk configuration (Standard_LRS for redundant storage)
  os_disk {
    caching              = "ReadWrite" 
    storage_account_type = "Standard_LRS"  
  }
  # Source image configuration (Ubuntu 22.04 LTS)
  source_image_reference {
    publisher = "Canonical"  
    offer     = "0001-com-ubuntu-server-jammy" 
    sku       = "22_04-lts" 
    version   = "latest"  
  }
   identity {
    type = "SystemAssigned"
  }
  custom_data = filebase64("${path.module}/vm.yaml")
}


resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  depends_on = [ azurerm_linux_virtual_machine.chroma_vm ]
  name                       = var.vmss_name
  resource_group_name        = var.rg_name
  location                   = var.location
  sku                        = "Standard_DS1_v2"
  instances                  = 2
  admin_username             = "azureuser"
  computer_name_prefix       = "chatbotvm"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.pathToSSHKey)
  }

  network_interface {
    name    = "vmss-nic"
    primary = true
    ip_configuration {
      name                                   = "ipconfig1"
      subnet_id                              = var.subnet1_id
      primary                                = true
      application_gateway_backend_address_pool_ids = [var.appgw_backend_pool_id]
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }
  # Source image configuration (Ubuntu 22.04 LTS)
  source_image_reference {
    publisher = "Canonical"  
    offer     = "0001-com-ubuntu-server-jammy" 
    sku       = "22_04-lts" 
    version   = "latest"  
  }

  upgrade_mode = "Automatic"
  custom_data = filebase64("${path.module}/vmss.yaml")
}


resource "azurerm_monitor_autoscale_setting" "this" {
  name                = "myAutoscaleSetting"
  resource_group_name = var.rg_name
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 3
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 20
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  predictive {
    scale_mode      = "Enabled"
    look_ahead_time = "PT5M"
  }
  
}