module "vm" {
  source = "../../modules/vm"

  vm_name             = "vm-jump-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  subnet_id = module.network.subnet_ids["jump"]

  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password
}