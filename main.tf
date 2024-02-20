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
  tags = {
    source = "terraform-dev"
  }
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
  name                = "quark-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  #size                = "Standard_D64s_v3"
  size                = "Standard_DC16s_v3"

  admin_username      = "adminuser"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  provider = azurerm.eu_west
}

variable "startup_script" {
  type = string
  default = "./startup.sh"
}

resource "azurerm_virtual_machine_extension" "deployment_script" {
  name = "deployment-script"
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.0"

  protected_settings = <<PROTECTED_SETTINGS
  {
    "script": "${base64encode(file(var.startup_script))}"
  }
  PROTECTED_SETTINGS
}

output "public-ip-for-compute-instance" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}