locals {
  postfix = "${var.project}-${var.environment}-${var.location}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.postfix}"
  location = var.location

  tags = {
    environment = var.environment
    team        = var.project
  }
}

resource "azurerm_databricks_workspace" "databricks" {
  name                = "databricks-${local.postfix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"

  tags = {
    environment = azurerm_resource_group.rg.tags["environment"]
    team        = azurerm_resource_group.rg.tags["team"]
  }
}