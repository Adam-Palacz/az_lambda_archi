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

data "azurerm_eventhub" "eh" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.eh_name
  namespace_name      = var.eh_ns_name
}


data "azurerm_application_insights" "app_ins" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.app_ins_name
}

data "azurerm_eventhub_namespace_authorization_rule" "eh_ns_auth" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.eh_ns_auth_name
  namespace_name      = var.eh_ns_name
}


# resource "azurerm_service_plan" "app_sp" {
#   name                = "app-sp-${var.postfix}"
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   os_type             = "Windows"
#   sku_name            = "Y1"
# }

# resource "azurerm_windows_function_app" "az_fa" {
#   name                       = "az-fa-${var.postfix}"
#   location                   = data.azurerm_resource_group.rg.location
#   resource_group_name        = data.azurerm_resource_group.rg.name
#   service_plan_id            = azurerm_service_plan.app_sp.id
#   storage_account_name       = data.azurerm_storage_account.sa.name
#   storage_account_access_key = data.azurerm_storage_account.sa.primary_access_key


#   app_settings = {
#     "APPINSIGHTS_INSTRUMENTATIONKEY"        = data.azurerm_application_insights.app_ins.instrumentation_key
#     "APPLICATIONINSIGHTS_CONNECTION_STRING" = data.azurerm_application_insights.app_ins.connection_string
#     "EVENTHUB_CONNECTION_STRING"            = data.azurerm_eventhub_namespace_authorization_rule.eh_ns_auth.primary_connection_string
#   }

#   site_config {
#     application_stack {
#       node_version = "~18"
#     }
#     cors {
#       allowed_origins = ["https://portal.azure.com"]
#     }
#   }

resource "azurerm_service_plan" "app_sp" {
  name                = "app-sp-${var.postfix}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "az_fa" {
  name                       = "az-fa-${var.postfix}"
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.app_sp.id
  storage_account_name       = data.azurerm_storage_account.sa.name
  storage_account_access_key = data.azurerm_storage_account.sa.primary_access_key


  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = data.azurerm_application_insights.app_ins.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = data.azurerm_application_insights.app_ins.connection_string
    "EventHubConnectionString"              = data.azurerm_eventhub_namespace_authorization_rule.eh_ns_auth.primary_connection_string
    "EVENT_HUB_NAME"                        = data.azurerm_eventhub.eh.name
    "FUNCTIONS_WORKER_RUNTIME"              = "python"
  }
  site_config {
    application_stack {
      python_version = "3.11"
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }


}

# data "template_file" "function_json" {
#   template = file("${path.module}/functions/dataGenerator/function.json.tpl")

#   vars = {
#     eventhub_connection = data.azurerm_eventhub_namespace_authorization_rule.eh_ns_auth.name
#     eventhub_namespace  = data.azurerm_eventhub_namespace.eh_ns.name
#   }
# }

# resource "local_file" "function_json" {
#   content  = data.template_file.function_json.rendered
#   filename = "${path.module}/functions/dataGenerator/function.json"
# }

data "template_file" "function_py" {
  template = file("${path.module}/functions/dataGenerator/function_app.py.tpl")

  vars = {
    eventhub_name = data.azurerm_eventhub.eh.name
  }
}

resource "local_file" "function_py" {
  content  = data.template_file.function_py.rendered
  filename = "${path.module}/functions/dataGenerator/function_app.py"
}

resource "null_resource" "package_and_upload" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOT
    powershell Compress-Archive -Path .\\functions\\dataGenerator\\* -DestinationPath .\\functions\\dataGenerator\\dataGenerator.zip -Force
    EOT
  }
  provisioner "local-exec" {
    command = <<EOT
    az functionapp deployment source config-zip --resource-group ${data.azurerm_resource_group.rg.name} --name ${azurerm_linux_function_app.az_fa.name} --src .\\functions\\dataGenerator\\dataGenerator.zip
    EOT
  }
}

### For bash ###

# resource "null_resource" "package_and_upload" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = <<EOT
#     zip -r -DestinationPath ./modules/function_app/functions/dataGenerator/dataGenerator.zip ./modules/function_app/functions/dataGenerator 
#     EOT
#   }
#   provisioner "local-exec" {
#     command = <<EOT
#     az functionapp deployment source config-zip --resource-group ${data.azurerm_resource_group.rg.name} --name ${azurerm_linux_function_app.az_fa.name} --src .\\modules\\function_app\\functions\\dataGenerator\\dataGenerator.zip
#     EOT
#   }