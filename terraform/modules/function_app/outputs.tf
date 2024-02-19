# output "az_fa_name" {
#   description = "AZ FA name"
#   value       = azurerm_windows_function_app.az_fa.name
# }

output "az_fa_name" {
  description = "AZ FA name"
  value       = azurerm_linux_function_app.az_fa.name
}