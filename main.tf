terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group_central" {
  source   = "./modules/resource_group"
  name     = var.rg_central_name
  location = var.rg_central_location
  tags     = var.tags
}

module "networking" {
  source                  = "./modules/networking"
  rg_name                 = module.resource_group_central.name
  location                = module.resource_group_central.location
  gateway_vnet_name       = var.gateway_vnet_name
  gateway_vnet_cidr       = var.gateway_vnet_cidr
  agw_subnet_name         = var.agw_subnet_name
  agw_subnet_cidr         = var.agw_subnet_cidr
  app_vnet_name           = var.app_vnet_name
  app_vnet_cidr           = var.app_vnet_cidr
  endpoint_subnet_name    = var.endpoint_subnet_name
  endpoint_subnet_cidr    = var.endpoint_subnet_cidr
  integration_subnet_name = var.integration_subnet_name
  integration_subnet_cidr = var.integration_subnet_cidr
  ai_vm_subnet_name       = var.ai_vm_subnet_name
  ai_vm_subnet_cidr       = var.ai_vm_subnet_cidr
  bastion_subnet_name     = var.bastion_subnet_name
  bastion_subnet_cidr     = var.bastion_subnet_cidr
  tags                    = var.tags
}

module "nat_gateway" {
  source           = "./modules/nat_gateway"
  rg_name          = module.resource_group_central.name
  location         = module.resource_group_central.location
  nat_gateway_name = var.nat_gateway_name
  public_ip_name   = var.nat_public_ip_name
  ai_vm_subnet_id  = module.networking.ai_vm_subnet_id
  tags             = var.tags
}

module "application_gateway" {
  source            = "./modules/application_gateway"
  rg_name           = module.resource_group_central.name
  location          = module.resource_group_central.location
  agw_name          = var.agw_name
  public_ip_name    = var.agw_public_ip_name
  subnet_id         = module.networking.agw_subnet_id
  waf_policy_name   = var.waf_policy_name
  frontend_app_fqdn = module.app_service.frontend_default_hostname
  tags              = var.tags
}

module "app_service" {
  source                         = "./modules/app_service"
  rg_name                        = module.resource_group_central.name
  location                       = module.resource_group_central.location
  app_service_plan_name          = var.app_service_plan_name
  frontend_app_name              = var.frontend_app_name
  backend_app_name               = var.backend_app_name
  integration_subnet_id          = module.networking.integration_subnet_id
  tags                           = var.tags
  next_public_api_url            = var.next_public_api_url
  ollama_url                     = var.ollama_url
  mongo_uri                      = module.cosmosdb.primary_mongodb_connection_string
  mongodb_database               = var.mongodb_database
  scm_do_build_during_deployment = var.scm_do_build_during_deployment
}

module "dns" {
  source               = "./modules/dns"
  rg_name              = module.resource_group_central.name
  app_vnet_id          = module.networking.app_vnet_id
  app_service_dns_name = var.app_service_dns_name
  cosmos_dns_name      = var.cosmos_dns_name
  tags                 = var.tags
}

module "cosmosdb" {
  source               = "./modules/cosmosdb"
  rg_name              = module.resource_group_central.name
  location             = module.resource_group_central.location
  cosmos_account_name  = var.cosmos_account_name
  cosmos_mongo_db_name = var.cosmos_mongo_db_name
  tags                 = var.tags
}

module "storage" {
  source               = "./modules/storage"
  rg_name              = module.resource_group_central.name
  location             = module.resource_group_central.location
  storage_account_name = var.storage_account_name
  tags                 = var.tags
}

module "private_endpoint" {
  source                  = "./modules/private_endpoint"
  rg_name                 = module.resource_group_central.name
  location                = module.resource_group_central.location
  endpoint_subnet_id      = module.networking.endpoint_subnet_id
  frontend_app_id         = module.app_service.frontend_app_id
  backend_app_id          = module.app_service.backend_app_id
  cosmos_account_id       = module.cosmosdb.cosmos_account_id
  app_service_dns_zone_id = module.dns.app_service_dns_zone_id
  cosmos_dns_zone_id      = module.dns.cosmos_dns_zone_id
  frontend_pe_name        = var.frontend_pe_name
  backend_pe_name         = var.backend_pe_name
  cosmos_pe_name          = var.cosmos_pe_name
  tags                    = var.tags
}

module "ai_vm" {
  source             = "./modules/ai_vm"
  rg_name            = module.resource_group_central.name
  location           = module.resource_group_central.location
  vm_name            = var.ai_vm_name
  nic_name           = var.ai_vm_nic_name
  nsg_name           = var.ai_vm_nsg_name
  subnet_id          = module.networking.ai_vm_subnet_id
  admin_username     = var.ai_vm_admin_username
  admin_password     = var.ai_vm_admin_password
  private_ip_address = var.ai_vm_private_ip_address
  tags               = var.tags
}

module "bastion" {
  source         = "./modules/bastion"
  rg_name        = module.resource_group_central.name
  location       = module.resource_group_central.location
  bastion_name   = var.bastion_name
  public_ip_name = var.bastion_public_ip_name
  subnet_id      = module.networking.bastion_subnet_id
  tags           = var.tags
}
