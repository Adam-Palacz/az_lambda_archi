data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_eventhub_namespace" "eh_ns" {
  name                = var.eh_ns_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_eventhub" "eh" {
  name                = var.eh_name
  namespace_name      = data.azurerm_eventhub_namespace.eh_ns.name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_eventhub_consumer_group" "eh_cg_stream" {
  name                = var.eh_cg_stream_name
  namespace_name      = data.azurerm_eventhub_namespace.eh_ns.name
  eventhub_name       = data.azurerm_eventhub.eh.name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_eventhub_namespace_authorization_rule" "eh_ns_auth" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.eh_ns_auth_name
  namespace_name      = data.azurerm_eventhub_namespace.eh_ns.name
}

data "azurerm_cosmosdb_account" "db_acc" {
  name                = var.db_acc_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_cosmosdb_sql_database" "db_nosql" {
  name                = var.db_nosql_name
  resource_group_name = data.azurerm_resource_group.rg.name
  account_name        = data.azurerm_cosmosdb_account.db_acc.name
}

resource "azurerm_stream_analytics_job" "stream_job" {
  name                                     = "stream-${var.postfix}-job"
  resource_group_name                      = data.azurerm_resource_group.rg.name
  location                                 = data.azurerm_resource_group.rg.location
  compatibility_level                      = "1.2"
  data_locale                              = "en-GB"
  events_late_arrival_max_delay_in_seconds = 60
  events_out_of_order_max_delay_in_seconds = 50
  events_out_of_order_policy               = "Adjust"
  output_error_policy                      = "Drop"
  streaming_units                          = 1

  tags = {
    environment = data.azurerm_resource_group.rg.tags["environment"]
    team        = data.azurerm_resource_group.rg.tags["team"]
  }

  transformation_query = <<QUERY
    SELECT 
      factoryId,
      [timeStamp],
      messageType,
      data.ProductionRate,
      data.PowerUsage,
      data.ProductionRate/data.PowerUsage as ProductionPowerEfficiency
    INTO CosmosOutput
    FROM EventHubInput
    WHERE messageType = 'metrics'
QUERY
}

resource "azurerm_stream_analytics_stream_input_eventhub" "stream_input_eh" {
  name                         = "EventHubInput"
  stream_analytics_job_name    = azurerm_stream_analytics_job.stream_job.name
  resource_group_name          = azurerm_stream_analytics_job.stream_job.resource_group_name
  eventhub_consumer_group_name = data.azurerm_eventhub_consumer_group.eh_cg_stream.name
  eventhub_name                = data.azurerm_eventhub.eh.name
  servicebus_namespace         = data.azurerm_eventhub_namespace.eh_ns.name
  shared_access_policy_key     = data.azurerm_eventhub_namespace.eh_ns.default_primary_key
  shared_access_policy_name    = data.azurerm_eventhub_namespace_authorization_rule.eh_ns_auth.name

  serialization {
    type     = "Json"
    encoding = "UTF8"
  }
}

resource "azurerm_cosmosdb_sql_container" "db_container" {
  name                  = "Telemetrics"
  resource_group_name   = data.azurerm_cosmosdb_account.db_acc.resource_group_name
  account_name          = data.azurerm_cosmosdb_account.db_acc.name
  database_name         = data.azurerm_cosmosdb_sql_database.db_nosql.name
  partition_key_path    = "/factoryId"
  partition_key_version = 1
}

resource "azurerm_stream_analytics_output_cosmosdb" "stream_out_db" {
  name                     = "CosmosOutput"
  stream_analytics_job_id  = azurerm_stream_analytics_job.stream_job.id
  cosmosdb_account_key     = data.azurerm_cosmosdb_account.db_acc.primary_key
  cosmosdb_sql_database_id = data.azurerm_cosmosdb_sql_database.db_nosql.id
  container_name           = azurerm_cosmosdb_sql_container.db_container.name
}

resource "null_resource" "package_and_upload" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOT
    az stream-analytics job start --job-name "${azurerm_stream_analytics_job.stream_job.name}" --resource-group "${data.azurerm_resource_group.rg.name}" 
    EOT
  }
}