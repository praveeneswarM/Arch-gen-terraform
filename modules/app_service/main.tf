resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = var.rg_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v3"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "frontend_app" {
  name                = var.frontend_app_name
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id
  tags                = var.tags
  https_only          = true

  site_config {
    always_on        = true
    app_command_line = "pm2 start npm --no-daemon -- start"
    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    "NEXT_PUBLIC_API_URL"            = var.next_public_api_url
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "ENABLE_ORYX_BUILD"              = "true"
  }

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = var.integration_subnet_id
}

resource "azurerm_app_service_source_control" "frontend_sc" {
  app_id                 = azurerm_linux_web_app.frontend_app.id
  repo_url               = "https://github.com/praveeneswarM/ArchGen-frontend"
  branch                 = "master"
  use_manual_integration = true
}

resource "azurerm_linux_web_app" "backend_app" {
  name                = var.backend_app_name
  resource_group_name = var.rg_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id
  tags                = var.tags
  https_only          = true

  site_config {
    always_on              = true
    vnet_route_all_enabled = true
    app_command_line       = "uvicorn main:app --host 0.0.0.0 --port 8000"
    application_stack {
      python_version = "3.12"
    }
  }

  app_settings = {
    "OLLAMA_BASE_URL"                = var.ollama_url
    "MONGO_URI"                      = var.mongo_uri
    "MONGODB_DATABASE"               = var.mongodb_database
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = var.scm_do_build_during_deployment
    "ENABLE_ORYX_BUILD"              = "true"
    "OLLAMA_MODEL"                   = ""
    "CORS_ORIGINS"                   = ""
  }

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = var.integration_subnet_id
}

resource "azurerm_app_service_source_control" "backend_sc" {
  app_id                 = azurerm_linux_web_app.backend_app.id
  repo_url               = "https://github.com/praveeneswarM/ArchGen-Backend"
  branch                 = "master"
  use_manual_integration = true
}
