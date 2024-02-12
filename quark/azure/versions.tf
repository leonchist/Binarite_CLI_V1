terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
      configuration_aliases = [ azurerm.us_east, azurerm.eu_west ]
    }
  }
}
