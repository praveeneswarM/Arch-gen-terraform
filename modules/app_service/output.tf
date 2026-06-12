output "frontend_app_id" {
  value = azurerm_linux_web_app.frontend_app.id
}

output "frontend_default_hostname" {
  value = azurerm_linux_web_app.frontend_app.default_hostname
}

output "backend_app_id" {
  value = azurerm_linux_web_app.backend_app.id
}

output "backend_default_hostname" {
  value = azurerm_linux_web_app.backend_app.default_hostname
}
