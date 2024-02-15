data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = "databricks-${var.postfix}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "standard"

  tags = {
    environment = data.azurerm_resource_group.rg.tags["environment"]
    team        = data.azurerm_resource_group.rg.tags["team"]
  }
}