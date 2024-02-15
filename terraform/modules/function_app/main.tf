data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

data "azurerm_storage_account" "sa" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.sa_name
}

data "azurerm_eventhub_namespace" "eh_ns" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.eh_ns_name
}

data "azurerm_eventhub_namespace_authorization_rule" "eh_ns_auth" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.eh_ns_auth_name
  namespace_name      = var.eh_ns_name
}

resource "azurerm_service_plan" "app_sp" {
  name                = "app-sp-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "az_fa" {
  name                       = "az-fa-${var.postfix}"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.app_sp.id
  storage_account_name       = data.azurerm_storage_account.sa.name
  storage_account_access_key = data.azurerm_storage_account.sa.primary_access_key

  app_settings = {
    "ehns-apdvc-dev-westeurope_eh-auth-apdvc-dev-westeurope_EVENTHUB"  =  data.azurerm_eventhub_namespace_authorization_rule.eh_ns_auth.primary_connection_string
  }

  site_config {
    application_stack {
      node_version = "~18"
    }
  }
}

data "template_file" "function_json" {
  template = file("${path.module}/functions/dataGenerator/function.json.tpl")

  vars = {
    eventhub_connection = data.azurerm_eventhub_namespace_authorization_rule.eh_ns_auth.name
    eventhub_namespace = data.azurerm_eventhub_namespace.eh_ns.name
  }
}

resource "local_file" "function_json" {
  content  = data.template_file.function_json.rendered
  filename = "${path.module}/functions/dataGenerator/function.json"
}