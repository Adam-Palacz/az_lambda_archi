locals {
  postfix          = "${var.project}-${var.environment}-${var.location}"
  postfix_combined = "${var.project}${var.environment}${var.location}"
}

module "rg" {
  source = "./modules/rg"

  postfix     = local.postfix
  project     = var.project
  environment = var.environment
  location    = var.location
}

# module "databricks" {
#   source = "./modules/databricks"

#   rg_name = module.rg.rg_name
#   postfix = local.postfix

#   depends_on = [
#     module.rg
#   ]
# }

module "sa" {
  source = "./modules/storage_account"

  rg_name = module.rg.rg_name
  sa_name = "saapdevwesteurope"
  sc_name = "rawdata"

  depends_on = [
    module.rg
  ]
}

module "eventhub" {
  source = "./modules/eventhub"

  rg_name           = module.rg.rg_name
  sa_name           = module.sa.sa_name
  sc_name           = module.sa.sc_name
  postfix           = local.postfix
  eh_name           = "rawdata"
  eh_cg_stream_name = "stream"
  eh_cg_tw_name     = "tw"

  depends_on = [
    module.sa
  ]
}

module "az_fa" {
  source = "./modules/function_app"

  rg_name         = module.rg.rg_name
  sa_name         = module.sa.sa_name
  eh_ns_name      = module.eventhub.eh_ns_name
  eh_ns_auth_name = module.eventhub.eh_ns_auth_name
  postfix         = local.postfix

  depends_on = [
    module.eventhub
  ]
}

resource "null_resource" "package_and_upload" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOT
    powershell Compress-Archive -Path .\\modules\\function_app\\functions\\dataGenerator -DestinationPath .\\modules\\function_app\\functions\\dataGenerator\\dataGenerator.zip -Force
    EOT
  }
  provisioner "local-exec" {
    command = <<EOT
    az functionapp deployment source config-zip --resource-group ${module.rg.rg_name} --name ${module.az_fa.az_fa_name} --src .\\modules\\function_app\\functions\\dataGenerator\\dataGenerator.zip
    EOT
  }
  depends_on = [
    module.az_fa,
  ]
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
#     az functionapp deployment source config-zip --resource-group ${module.rg.rg_name} --name ${module.az_fa.az_fa_name} --src .\\modules\\function_app\\functions\\dataGenerator\\dataGenerator.zip
#     EOT
#   }
#   depends_on = [
#     module.az_fa,
#   ]
