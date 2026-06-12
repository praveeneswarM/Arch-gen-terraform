output "cosmos_account_id" {
  value = azurerm_cosmosdb_account.cosmos.id
}

output "endpoint" {
  value = azurerm_cosmosdb_account.cosmos.endpoint
}

output "primary_mongodb_connection_string" {
  value     = azurerm_cosmosdb_account.cosmos.primary_mongodb_connection_string
  sensitive = true
}
