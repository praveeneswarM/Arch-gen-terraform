output "pe_frontend_id" {
  value = azurerm_private_endpoint.pe_frontend.id
}

output "pe_backend_id" {
  value = azurerm_private_endpoint.pe_backend.id
}

output "pe_cosmos_id" {
  value = azurerm_private_endpoint.pe_cosmos.id
}
