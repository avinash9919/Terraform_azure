provider "azurerm"{
    features{}
}

resource "azurerm_resource_group" "rg" {
    name = var.backend_rg_name
    location = var.location
  
}

resource "azurerm_storage_account" "backend_storage" {
  name = var.storage_account_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "backend_container" {
  name = var.container_name
  storage_account_id = azurerm_storage_account.backend_storage.id
  container_access_type = "private"
}
