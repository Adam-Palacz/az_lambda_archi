output "eh_ns_name" {
  value = azurerm_eventhub_namespace.eh_ns.name
}

output "eh_ns_auth_name" {
  value = azurerm_eventhub_namespace_authorization_rule.eh_ns_auth.name
}

output "eh_name" {
  value = azurerm_eventhub.eh.name
}

output "eh_cg_stream_name" {
  value = azurerm_eventhub_consumer_group.eh_cg_stream.name
}

output "eh_cg_tw_name" {
  value = azurerm_eventhub_consumer_group.eh_cg_tw.name
}