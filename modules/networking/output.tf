output "gateway_vnet_id" {
  value = azurerm_virtual_network.gateway_vnet.id
}

output "app_vnet_id" {
  value = azurerm_virtual_network.app_vnet.id
}

output "agw_subnet_id" {
  value = azurerm_subnet.agw_subnet.id
}

output "endpoint_subnet_id" {
  value = azurerm_subnet.endpoint_subnet.id
}

output "integration_subnet_id" {
  value = azurerm_subnet.integration_subnet.id
}

output "ai_vm_subnet_id" {
  value = azurerm_subnet.ai_vm_subnet.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}
