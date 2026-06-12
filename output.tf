output "frontend_url" {
  value = "https://${module.app_service.frontend_default_hostname}"
}

output "backend_url" {
  value = "https://${module.app_service.backend_default_hostname}"
}

output "application_gateway_public_url" {
  value = "http://${module.application_gateway.public_ip_address}"
}

output "cosmosdb_endpoint" {
  value = module.cosmosdb.endpoint
}

output "mongodb_database" {
  value = var.mongodb_database
}

output "mongodb_connection_string" {
  value     = module.cosmosdb.primary_mongodb_connection_string
  sensitive = true
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "ollama_vm_private_ip" {
  value = module.ai_vm.private_ip_address
}
