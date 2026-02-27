provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-backend"
    storage_account_name = "tfstatebackendci"
    container_name       = "tfstate"
    key                  = "vmcreation.tfstate"
  }
}

# Create new resource group for VM (Dev)
resource "azurerm_resource_group" "vm_rg" {
  name     = "rg-tf-vm-dev"
  location = "Central India"
}

# Reference existing network RG
data "azurerm_resource_group" "network_rg" {
  name = "rg-tf-network-dev"
}

# Reference existing subnet
data "azurerm_subnet" "db_subnet" {
  name                 = "snet-db-dev"
  virtual_network_name = "vnet-tf-dev"
  resource_group_name  = data.azurerm_resource_group.network_rg.name
}

# Reference existing jump subnet
data "azurerm_subnet" "jump_subnet" {
  name                 = "snet-jump-dev"
  virtual_network_name = "vnet-tf-dev"
  resource_group_name  = data.azurerm_resource_group.network_rg.name
}

# Create NIC in VM resource group
resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-db-vm"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.jump_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jump_pip.id
  }
}

resource "azurerm_public_ip" "jump_pip" {
  name                = "pip-jump-dev"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


# Create Windows VM
resource "azurerm_windows_virtual_machine" "db_vm" {
  name                = "vm-db-dev"
  resource_group_name = azurerm_resource_group.vm_rg.name
  location            = azurerm_resource_group.vm_rg.location
  size                = "Standard_D2as_v5"
  admin_username      = "azureuser"
  admin_password      = "Password1234!"

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

