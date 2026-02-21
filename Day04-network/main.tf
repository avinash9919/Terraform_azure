provider "azurerm"{
    features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-backend"
    storage_account_name = "tfstatebackendci"
    container_name       = "tfstate"
    key                  = "network.tfstate"
  }
}
resource "azurerm_resource_group" "rg"{
    name = var.rg_name
    location = var.location
}

resource "azurerm_virtual_network" "vnet"{
    name = var.vnet_name
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = var.address_space
}
resource "azurerm_subnet" "subnet"{
    name = var.subnet_name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.subnet_prefix
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-db-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_sql" {
  name                        = "Allow-SQL"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "subnet_assoc"{
    subnet_id = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}
