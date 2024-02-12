resource "azurerm_dedicated_host_group" "host_group" {
  name                        = var.dedicated_host_group_name
  location                    = var.region
  resource_group_name         = var.resource_group_name
  platform_fault_domain_count = 1
}

resource "azurerm_dedicated_host" "host" {
  name                  = var.dedicated_host_name
  location              = var.region
  dedicated_host_group_id = azurerm_dedicated_host_group.host_group.id
  sku_name              = "DSv3-Type1"
  platform_fault_domain = 1
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                 = var.instance_count
  name                  = "vm-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.region
  size                  = var.vm_size
  admin_username        = var.admin_username
  dedicated_host_id     = azurerm_dedicated_host.host.id
  network_interface_ids = [azurerm_network_interface.vm_nic[count.index].id]
  os_disk {
    caching            = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
  }
}

resource "azurerm_network_interface" "vm_nic" {
  count               = var.instance_count
  name                = "vm-nic-${count.index}"
  location            = var.region
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_internal_id
    private_ip_address_allocation = "Dynamic"
  }
  ip_configuration {
    name                          = "external"
    subnet_id                     = var.subnet_external_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_id
  }
}
