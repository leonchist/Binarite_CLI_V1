terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
      configuration_aliases = [ azurerm.us_east, azurerm.eu_west ]
    }
  }
}


module "quark_azure" {
  source = "./azure"

  providers = {
    azurerm.us_east = azurerm.us_east
    azurerm.eu_west = azurerm.eu_west
  }
}
