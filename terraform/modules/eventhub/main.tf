data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_storage_account" "sa" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.sa_name
}

data "azurerm_storage_container" "sc" {
  storage_account_name = data.azurerm_storage_account.sa.name
  name                 = var.sc_name
}

resource "azurerm_eventhub_namespace" "eh_ns" {
  name                = "ehns-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = data.azurerm_resource_group.rg.tags["environment"]
    team        = data.azurerm_resource_group.rg.tags["team"]
  }
}

resource "azurerm_eventhub_namespace_authorization_rule" "eh_ns_auth" {
  name                = "eh-auth-${var.postfix}"
  namespace_name      = azurerm_eventhub_namespace.eh_ns.name
  resource_group_name = data.azurerm_resource_group.rg.name

  listen = true
  send   = true
  manage = false
}

resource "azurerm_eventhub" "eh" {
  name                = var.eh_name
  namespace_name      = azurerm_eventhub_namespace.eh_ns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 1

  capture_description {
    enabled             = true
    encoding            = var.encoding
    interval_in_seconds = 300
    size_limit_in_bytes = 314572800
    skip_empty_archives = true
    destination {
      name                = "EventHubArchive.AzureBlockBlob"
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      blob_container_name = data.azurerm_storage_container.sc.name
      storage_account_id  = data.azurerm_storage_account.sa.id
    }
  }
}

resource "azurerm_eventhub_consumer_group" "eh_cg_stream" {
  name                = var.eh_cg_stream_name
  namespace_name      = azurerm_eventhub_namespace.eh_ns.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_eventhub_consumer_group" "eh_cg_tw" {
  name                = var.eh_cg_tw_name
  namespace_name      = azurerm_eventhub_namespace.eh_ns.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = data.azurerm_resource_group.rg.name

}

