resource "azurerm_virtual_network" "gateway_vnet" {
  name                = var.gateway_vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.gateway_vnet_cidr
  tags                = var.tags
}

resource "azurerm_subnet" "agw_subnet" {
  name                 = var.agw_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.gateway_vnet.name
  address_prefixes     = var.agw_subnet_cidr
}

resource "azurerm_virtual_network" "app_vnet" {
  name                = var.app_vnet_name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = var.app_vnet_cidr
  tags                = var.tags
}

resource "azurerm_subnet" "endpoint_subnet" {
  name                 = var.endpoint_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = var.endpoint_subnet_cidr
}

resource "azurerm_subnet" "integration_subnet" {
  name                 = var.integration_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = var.integration_subnet_cidr
  delegation {
    name = "appservice-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "ai_vm_subnet" {
  name                 = var.ai_vm_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = var.ai_vm_subnet_cidr
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = var.bastion_subnet_cidr
}

resource "azurerm_virtual_network_peering" "gateway_to_app" {
  name                      = "peer-gateway-to-app"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.gateway_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.app_vnet.id

  depends_on = [
    azurerm_subnet.agw_subnet,
    azurerm_subnet.endpoint_subnet,
    azurerm_subnet.integration_subnet,
    azurerm_subnet.ai_vm_subnet,
    azurerm_subnet.bastion_subnet
  ]
}

resource "azurerm_virtual_network_peering" "app_to_gateway" {
  name                      = "peer-app-to-gateway"
  resource_group_name       = var.rg_name
  virtual_network_name      = azurerm_virtual_network.app_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.gateway_vnet.id

  depends_on = [
    azurerm_subnet.agw_subnet,
    azurerm_subnet.endpoint_subnet,
    azurerm_subnet.integration_subnet,
    azurerm_subnet.ai_vm_subnet,
    azurerm_subnet.bastion_subnet
  ]
}
