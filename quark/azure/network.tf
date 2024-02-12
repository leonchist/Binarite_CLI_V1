# Resource Group, Virtual Network, and Subnets for US East
resource "azurerm_resource_group" "rg_us_east" {
  provider = azurerm.us_east
  name     = "rg-us-east"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet_us_east" {
  provider            = azurerm.us_east
  name                = "vnet-us-east"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_us_east.location
  resource_group_name = azurerm_resource_group.rg_us_east.name
}

resource "azurerm_subnet" "external_us_east" {
  provider            = azurerm.us_east
  name                = "subnet-external-us-east"
  resource_group_name = azurerm_resource_group.rg_us_east.name
  virtual_network_name = azurerm_virtual_network.vnet_us_east.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "internal_us_east" {
  provider            = azurerm.us_east
  name                = "subnet-internal-us-east"
  resource_group_name = azurerm_resource_group.rg_us_east.name
  virtual_network_name = azurerm_virtual_network.vnet_us_east.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_quark_us_east" {
  provider            = azurerm.us_east
  name                = "example-publicip-us-east"
  location            = azurerm_resource_group.rg_us_east.location
  resource_group_name = azurerm_resource_group.rg_us_east.name
  allocation_method   = "Static"
}

# Repeat for EU West
resource "azurerm_resource_group" "rg_eu_west" {
  provider = azurerm.eu_west
  name     = "rg-eu-west"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet_eu_west" {
  provider            = azurerm.eu_west
  name                = "vnet-eu-west"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_eu_west.location
  resource_group_name = azurerm_resource_group.rg_eu_west.name
}

resource "azurerm_subnet" "external_eu_west" {
  provider            = azurerm.eu_west
  name                = "subnet-external-eu-west"
  resource_group_name = azurerm_resource_group.rg_eu_west.name
  virtual_network_name = azurerm_virtual_network.vnet_eu_west.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "internal_eu_west" {
  provider            = azurerm.eu_west
  name                = "subnet-internal-eu-west"
  resource_group_name = azurerm_resource_group.rg_eu_west.name
  virtual_network_name = azurerm_virtual_network.vnet_eu_west.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_public_ip" "public_quark_eu_west" {
  provider            = azurerm.eu_west
  name                = "example-publicip-eu-west"
  location            = azurerm_resource_group.rg_eu_west.location
  resource_group_name = azurerm_resource_group.rg_eu_west.name
  allocation_method   = "Static"
}

# Load Balancer for US East
resource "azurerm_lb" "lb_us_east" {
  provider            = azurerm.us_east
  name                = "lb-us-east"
  location            = azurerm_resource_group.rg_us_east.location
  resource_group_name = azurerm_resource_group.rg_us_east.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_quark_us_east.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_us_east" {
  provider            = azurerm.us_east
  loadbalancer_id     = azurerm_lb.lb_us_east.id
  name                = "backendAddressPool-us-east"
}

# Load Balancer for EU West
resource "azurerm_lb" "lb_eu_west" {
  provider            = azurerm.eu_west
  name                = "lb-eu-west"
  location            = azurerm_resource_group.rg_eu_west.location
  resource_group_name = azurerm_resource_group.rg_eu_west.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_quark_eu_west.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_eu_west" {
  provider            = azurerm.eu_west
  loadbalancer_id     = azurerm_lb.lb_eu_west.id
  name                = "backendAddressPool-eu-west"
}

# Azure Traffic Manager for Global Load Balancing
resource "azurerm_traffic_manager_profile" "global_traffic_manager" {
  name                   = "global-traffic-manager"
  resource_group_name    = azurerm_resource_group.rg_us_east.name
  traffic_routing_method = "Performance"
  dns_config {
    relative_name = "globaltraffic"
    ttl           = 60
  }
  monitor_config { #we need to come up with some healthcheck?ok
    protocol = "http"
    port     = 80
    path     = "/healthcheck"
  }
}

resource "azurerm_traffic_manager_endpoint" "us_east_endpoint" {
  name                  = "us-east-endpoint"
  profile_name          = azurerm_traffic_manager_profile.global_traffic_manager.name
  resource_group_name   = azurerm_resource_group.rg_us_east.name
  type                  = "externalEndpoints"
  target_resource_id    = azurerm_public_ip.public_quark_us_east.id
  endpoint_status       = "Enabled"
}

resource "azurerm_traffic_manager_endpoint" "eu_west_endpoint" {
  name                  = "eu-west-endpoint"
  profile_name          = azurerm_traffic_manager_profile.global_traffic_manager.name
  resource_group_name   = azurerm_resource_group.rg_eu_west.name
  type                  = "externalEndpoints"
  target_resource_id    = azurerm_public_ip.public_quark_eu_west.id
  endpoint_status       = "Enabled"
}
