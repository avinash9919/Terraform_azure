output "azure_VM_name"{
    value = azurerm_windows_virtual_machine.db_vm.name
}

output "azure_VM_resourecGroup_name"{
    value = azurerm_resource_group.vm_rg.name
}

output "vm_size" {
  value = azurerm_windows_virtual_machine.db_vm.size
}

output "vm_SKU" {
  value = azurerm_windows_virtual_machine.db_vm.source_image_reference[0]
}