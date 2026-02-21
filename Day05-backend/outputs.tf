output "resource_group_name" {
    value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
    value = azurerm_storage_account.backend_storage.name
}

output "container_name" {
  value = azurerm_storage_container.backend_container.name
}