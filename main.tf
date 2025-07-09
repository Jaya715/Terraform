
resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location
}

// https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_virtual_network" "app_network" {
  name                = "app-network"
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = local.azurerm_virtual_network.address_space
}
resource "azurerm_subnet" "web" {
  name                 = "websubnet01"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = local.subnets[0].address_prefixes
}

resource "azurerm_subnet" "app" {
  name                 = "appsubnet01"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefixes     = local.subnets[1].address_prefixes
}

resource "azurerm_network_interface" "NIC" {
  name                = local.VM.network_interface_id
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
        subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
  
}

resource "azurerm_subnet_network_security_group_association" "Appsubnet01_NSG" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}

resource "azurerm_subnet_network_security_group_association" "Websubnet01_NSG" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}
  resource "azurerm_public_ip" "PIP" {
  name                = "app-public-ip"
  location            = local.location  
  resource_group_name = local.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  }
resource "azurerm_windows_virtual_machine" "app_vm" {
  name                  = local.VM.name
  location              = local.location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.NIC.id]
  size                  = local.VM.size
  admin_username        = local.VM.admin_username
  admin_password        = local.VM.admin_password

  os_disk {
    name                 = "${local.VM.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

