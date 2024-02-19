data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

resource "azurerm_cosmosdb_account" "db_acc" {
  name                = "db-acc-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = data.azurerm_resource_group.rg.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "db_nosql" {
  name                = "FactoryData"
  resource_group_name = azurerm_cosmosdb_account.db_acc.resource_group_name
  account_name        = azurerm_cosmosdb_account.db_acc.name
}

