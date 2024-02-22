# Defining local variables
locals {
  postfix          = "${var.project}-${var.environment}-${var.location}" # Makes unique names for our resources
  postfix_combined = "${var.project}${var.environment}${var.location}"
}

# Creates the Azure Resource Group where all resources will reside
module "rg" {
  source = "./modules/rg"
  postfix     = local.postfix
  project     = var.project
  environment = var.environment
  location    = var.location
}

# Creates the Storage Account used by all azure resources in this project
module "sa" {
  source = "./modules/storage_account"
  rg_name = module.rg.rg_name
  sa_name = "saapdevwesteurope"
  sc_name = "rawdata"
  # Making sure Resource Group is created first before Storage Account
  depends_on = [
    module.rg
  ]
}

# Creating Azure Key Vault for storing secrets used in this project
module "key_vault" {
  source = "./modules/key_vault"
  postfix = local.postfix
  rg_name = module.rg.rg_name
  sa_name = module.sa.sa_name
  # Ensuring Storage Account is created first before Key Vault
  depends_on = [
    module.sa
  ]
}

# Creating Azure Event Hub where event generating services can send data
module "eventhub" {
  source = "./modules/eventhub"
  rg_name           = module.rg.rg_name
  sa_name           = module.sa.sa_name
  sc_name           = module.sa.sc_name
  postfix           = local.postfix
  eh_name           = "rawdata"
  eh_cg_stream_name = "stream"
  eh_cg_tw_name     = "tw"
  # Making sure Storage Account is created first before Event Hub
  depends_on = [
    module.sa
  ]
}

# Create Azure Application Insights for monitoring application performance and usage
module "app_ins" {
  source = "./modules/app_insights"
  rg_name = module.rg.rg_name
  postfix = local.postfix
  # Ensuring Resource Group is created first before Application Insights
  depends_on = [
    module.rg
  ]
}

# Create Azure Function App where we can host our serverless functions
module "az_fa" {
  source = "./modules/function_app"
  rg_name         = module.rg.rg_name
  sa_name         = module.sa.sa_name
  eh_ns_name      = module.eventhub.eh_ns_name
  eh_ns_auth_name = module.eventhub.eh_ns_auth_name
  eh_name         = module.eventhub.eh_name
  app_ins_name    = module.app_ins.app_ins_name
  postfix         = local.postfix
  # Ensuring Event Hub and Application Insights are created first before Function App
  depends_on = [
    module.eventhub,
    module.app_ins
  ]
}

# Create Azure Cosmos DB which is used for storing data
module "cosmosdb" {
  source = "./modules/cosmosdb"
  rg_name = module.rg.rg_name
  # Ensuring Resource Group is created first before Cosmos DB
  depends_on = [
    module.rg
  ]
}

# Creating Azure Stream Analytics Job for real-time data stream processing 
module "stream" {
  source = "./modules/stream_analytics_job"
  rg_name           = module.rg.rg_name
  eh_ns_name        = module.eventhub.eh_ns_name
  eh_ns_auth_name   = module.eventhub.eh_ns_auth_name
  eh_name           = module.eventhub.eh_name
  eh_cg_stream_name = module.eventhub.eh_cg_stream_name
  db_acc_name       = module.cosmosdb.db_acc_name
  db_nosql_name     = module.cosmosdb.db_nosql_name
  # Ensuring Resource Group, Event Hub and Cosmos DB are created first before Stream Analytics Job
  depends_on = [
    module.rg,
    module.eventhub,
    module.cosmosdb
  ]
}

# Following two modules are commented out. If you want to use uncomment the module

# Define Databricks module
# module "databricks" {
#   source = "./modules/databricks"
#   rg_name = module.rg.rg_name
#   postfix = local.postfix
#   depends_on = [
#     module.rg,
#     module.key_vault
#   ]
# }

# Define Azure Portal Dashboard module
# module "dashboard" {
#   source = "./modules/dashboard"
#   rg_name = module.rg.rg_name
#   depends_on = [
#     module.rg
#   ]
# }