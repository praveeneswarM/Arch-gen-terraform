terraform {
  backend "azurerm" {
    resource_group_name  = "RG-ArchGen-Prod"
    storage_account_name = "starchgenprod123"
    container_name       = "tfstate"
    key                  = "archgen-prod.tfstate"
  }
}
