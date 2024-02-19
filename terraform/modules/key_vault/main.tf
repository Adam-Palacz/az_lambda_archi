data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_storage_account" "sa" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.sa_name
}

resource "azurerm_key_vault" "key_vault" {
  name                       = "kv-${var.postfix}"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}


# resource "azurerm_key_vault_secret" "storage_key" {
#   name         = "sakey${var.postfix_combined}"
#   value        = data.azurerm_storage_account.key_vault.primary_access_key
#   key_vault_id = azurerm_key_vault.key_vault.id
# }