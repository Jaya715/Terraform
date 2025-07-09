locals {
  location = "West Europe"
  resource_group_name = "app-grp"
  subnets = [
    {
      name             = "websubnet01"
      address_prefixes = ["10.0.0.0/24"]
    },
    {
      name             = "appsubnet01"
      address_prefixes = ["10.0.1.0/24"]
    }
  ]
  azurerm_virtual_network = {
    address_space       = ["10.0.0.0/16"]
}
VM = {
    name                = "app-vm"
    size                = "Standard_B1s"
    admin_username      = "adminuser"
    admin_password      = "P@ssw0rd1234!"
    network_interface_id = "appNic"

  }
}