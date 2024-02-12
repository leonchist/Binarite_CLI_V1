module "quark" {
  source = "./quark"
  providers = {
    azurerm.us_east = azurerm.us_east
    azurerm.eu_west = azurerm.eu_west
  }
}
