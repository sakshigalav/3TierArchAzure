provider "azurerm" {
  features {}
}

module "resourcegroup" {
  source         = "./modules/resourcegroup"
  name           = var.name
  location       = var.location
}

module "network" {
  source         = "./modules/network"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  vnetcidr       = var.vnetip
  websubnetcidr  = var.websubnetip
  appsubnetcidr  = var.appsubnetip
  dbsubnetcidr   = var.dbsubnetip
}

module "nsg" {
  source         = "./modules/nsg"
  location       = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name 
  web_subnet_id  = module.network.webSub
  app_subnet_id  = module.network.appSub
  db_subnet_id   = module.network.dbSub
}

module "vm" {
  source         = "./modules/vm"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  webSub = module.network.webSub
  appSub = module.network.appSub
  hostName = var.hostName
  webUsername = var.webUsername
  webPass = var.webPass
  appVMname = var.appVMname
  appUsername = var.appUsername
  appPass = var.appPass
}

module "db" {
  source = "./modules/db"
  location = module.resourcegroup.location_id
  resource_group = module.resourcegroup.resource_group_name
  primary_database = var.db1
  primary_database_version = var.db1Version
  primary_database_admin = var.db1Admin
  db1Pass = var.db1Pass
}
