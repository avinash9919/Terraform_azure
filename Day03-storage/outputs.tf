output "resourec_group_name" {
    description = "name of the resource group"
    value = azurerm_resource_group.rg.name
}

output "storage_accounts_name"{
    description = "name of the storage accounts"
    value = [for sa in azurerm_storage_account.sa : sa.name]
}
