output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}
output "terraform_state_storage_account" {
  value = azurerm_storage_account.storage.name
}

