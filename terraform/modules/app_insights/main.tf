data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

resource "azurerm_log_analytics_workspace" "log_a_ws" {
  name                = "log-a-ws-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "app_ins" {
  name                = "app-ins-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.log_a_ws.id
  application_type    = "Node.JS"
}