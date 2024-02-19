output "db_acc_name" {
  value = azurerm_cosmosdb_account.db_acc.name
}

output "db_nosql_name" {
  value = azurerm_cosmosdb_sql_database.db_nosql.name
}
