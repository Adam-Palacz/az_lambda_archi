data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

resource "azurerm_portal_dashboard" "lambda-board" {
  name                = "Lambda"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags = {
    environment = data.azurerm_resource_group.rg.tags["environment"]
    team        = data.azurerm_resource_group.rg.tags["team"]
  }
  dashboard_properties = <<DASH
{
  }
DASH
}