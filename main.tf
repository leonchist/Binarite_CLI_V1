#module "quark" {
#  source = "./quark"
#  providers = {
#    azurerm.us_east = azurerm.us_east
#    azurerm.eu_west = azurerm.eu_west
#  }
#}


# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "QuarkTest"
  location = "West Europe"
  provider = azurerm.eu_west
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "quark_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  provider            = azurerm.eu_west
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "quark_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  provider             = azurerm.eu_west
}

# Public IP
resource "azurerm_public_ip" "pip" {
  name                = "quark_pub_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  provider            = azurerm.eu_west
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "quark_nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "quark_nic_config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }

  provider = azurerm.eu_west
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "quark_vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_M8ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provider = azurerm.eu_west
}
