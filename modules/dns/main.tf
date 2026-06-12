resource "azurerm_private_dns_zone" "app_service_dns" {
  name                = var.app_service_dns_name
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service_vnet_link" {
  name                  = "link-app-service-dns"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.app_service_dns.name
  virtual_network_id    = var.app_vnet_id
}

resource "azurerm_private_dns_zone" "cosmos_dns" {
  name                = var.cosmos_dns_name
  resource_group_name = var.rg_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_vnet_link" {
  name                  = "link-cosmos-dns"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmos_dns.name
  virtual_network_id    = var.app_vnet_id
}
