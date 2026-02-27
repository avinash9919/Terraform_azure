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

resource "azurerm_subnet" "jump_subnet" {
  name                 = "snet-jump-dev"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# subnet for azure sql servers
resource "azurerm_subnet" "pe_subnet" {
  name                 = "snet-pe-dev"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-db-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "jump_nsg" {
  name                = "nsg-jump-dev"
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
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow_postgres" {
  name                        = "Allow-PostgreSQL"
  priority                    =  110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5432"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "allow_rdp" {
  name                        = "Allow-RDP-Home"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefixes     = var.jump_allowed_ips
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.jump_nsg.name
}
resource "azurerm_subnet_network_security_group_association" "subnet_assoc"{
    subnet_id = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "jump_assoc" {
  subnet_id = azurerm_subnet.jump_subnet.id
  network_security_group_id = azurerm_network_security_group.jump_nsg.id
}