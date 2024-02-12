# Network Interfaces and VM for US East
resource "azurerm_network_interface" "external_us_east" {
  provider            = azurerm.us_east
  name                = "nic-external-us-east"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg_us_east.name

  ip_configuration {
    name                          = "externalConfig"
    subnet_id                     = azurerm_subnet.external_us_east.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example_us_east.id
  }
}

resource "azurerm_network_interface" "internal_us_east" {
  provider            = azurerm.us_east
  name                = "nic-internal-us-east"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg_us_east.name

  ip_configuration {
    name                          = "internalConfig"
    subnet_id                     = azurerm_subnet.internal_us_east.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_us_east" {
  count                = 3

  provider             = azurerm.us_east
  name                 = "vm-us-east-01"
  resource_group_name  = azurerm_resource_group.rg_us_east.name
  location             = "East US"
  size                 = "Standard_HB120-32rs_v3"
  admin_username       = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.external_us_east.id,
    azurerm_network_interface.internal_us_east.id,
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

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}

# Repeat for EU West - Adjust resource names, location, and provider to azurerm.eu_west
resource "azurerm_network_interface" "external_eu_west" {
  provider            = azurerm.eu_west
  name                = "nic-external-eu-west"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.rg_eu_west.name

  ip_configuration {
    name                          = "externalConfig"
    subnet_id                     = azurerm_subnet.external_eu_west.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example_eu_west.id
  }
}

resource "azurerm_network_interface" "internal_eu_west" {
  provider            = azurerm.eu_west
  name                = "nic-internal-eu-west"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.rg_eu_west.name

  ip_configuration {
    name                          = "internalConfig"
    subnet_id                     = azurerm_subnet.internal_eu_west.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_eu_west" {
  count                = 3

  provider             = azurerm.eu_west
  name                 = "vm-eu-west-01"
  resource_group_name  = azurerm_resource_group.rg_eu_west.name
  location             = "West Europe"
  size                 = "Standard_HB120-32rs_v3"
  admin_username       = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.external_eu_west.id,
    azurerm_network_interface.internal_eu_west.id,
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

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}
