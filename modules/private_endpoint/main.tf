resource "azurerm_private_endpoint" "pe_frontend" {
  name                = var.frontend_pe_name
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-frontend"
    private_connection_resource_id = var.frontend_app_id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdns-group-frontend"
    private_dns_zone_ids = [var.app_service_dns_zone_id]
  }
}

resource "azurerm_private_endpoint" "pe_backend" {
  name                = var.backend_pe_name
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-backend"
    private_connection_resource_id = var.backend_app_id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdns-group-backend"
    private_dns_zone_ids = [var.app_service_dns_zone_id]
  }
}

resource "azurerm_private_endpoint" "pe_cosmos" {
  name                = var.cosmos_pe_name
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-cosmos"
    private_connection_resource_id = var.cosmos_account_id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdns-group-cosmos"
    private_dns_zone_ids = [var.cosmos_dns_zone_id]
  }
}
