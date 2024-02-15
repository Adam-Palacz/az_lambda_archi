output "eh_ns_name" {
  value = azurerm_eventhub_namespace.eh_ns.name
}

output "eh_ns_auth_name" {
  value = azurerm_eventhub_namespace_authorization_rule.eh_ns_auth.name
}