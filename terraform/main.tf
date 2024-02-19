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

module "sa" {
  source = "./modules/storage_account"

  rg_name = module.rg.rg_name
  sa_name = "saapdevwesteurope"
  sc_name = "rawdata"

  depends_on = [
    module.rg
  ]
}

module "key_vault" {
  source = "./modules/key_vault"

  postfix = local.postfix
  rg_name = module.rg.rg_name
  sa_name = module.sa.sa_name

  depends_on = [
    module.sa
  ]
}

# module "databricks" {
#   source = "./modules/databricks"

#   rg_name = module.rg.rg_name
#   postfix = local.postfix

#   depends_on = [
#     module.rg,
#     module.key_vault
#   ]
# }

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

module "app_ins" {
  source = "./modules/app_insights"

  rg_name = module.rg.rg_name
  postfix = local.postfix

  depends_on = [
    module.rg
  ]
}

module "az_fa" {
  source = "./modules/function_app"

  rg_name         = module.rg.rg_name
  sa_name         = module.sa.sa_name
  eh_ns_name      = module.eventhub.eh_ns_name
  eh_ns_auth_name = module.eventhub.eh_ns_auth_name
  eh_name         = module.eventhub.eh_name
  app_ins_name    = module.app_ins.app_ins_name
  postfix         = local.postfix

  depends_on = [
    module.eventhub,
    module.app_ins
  ]
}

module "cosmosdb" {
  source = "./modules/cosmosdb"

  rg_name = module.rg.rg_name

  depends_on = [
    module.rg
  ]
}

module "stream" {
  source = "./modules/stream_analytics_job"

  rg_name           = module.rg.rg_name
  eh_ns_name        = module.eventhub.eh_ns_name
  eh_ns_auth_name   = module.eventhub.eh_ns_auth_name
  eh_name           = module.eventhub.eh_name
  eh_cg_stream_name = module.eventhub.eh_cg_stream_name
  db_acc_name       = module.cosmosdb.db_acc_name
  db_nosql_name     = module.cosmosdb.db_nosql_name

  depends_on = [
    module.rg,
    module.eventhub,
    module.cosmosdb
  ]

}
# module "dashboard" {
#   source = "./modules/dashboard"

#   rg_name = module.rg.rg_name

#   depends_on = [
#     module.rg
#   ]
# }
