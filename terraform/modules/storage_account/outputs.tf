output "sa_name" {
  description = "SA name"
  value       = azurerm_storage_account.sa.name
}

output "sc_name" {
  description = "SC name"
  value       = azurerm_storage_container.sc.name
}