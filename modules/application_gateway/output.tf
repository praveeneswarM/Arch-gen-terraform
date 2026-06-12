output "public_ip_address" {
  value = azurerm_public_ip.agw_pip.ip_address
}

output "agw_id" {
  value = azurerm_application_gateway.agw.id
}
