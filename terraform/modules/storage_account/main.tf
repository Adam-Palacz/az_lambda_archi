data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

resource "azurerm_storage_account" "sa" {
  name                     = var.sa_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = data.azurerm_resource_group.rg.tags["environment"]
    team        = data.azurerm_resource_group.rg.tags["team"]
  }
}

resource "azurerm_storage_container" "sc" {
  name                  = var.sc_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}