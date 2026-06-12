output "app_service_dns_zone_id" {
  value = azurerm_private_dns_zone.app_service_dns.id
}

output "cosmos_dns_zone_id" {
  value = azurerm_private_dns_zone.cosmos_dns.id
}
