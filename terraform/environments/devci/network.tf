resource "azurerm_resource_group" "rg" {
    name     = "rg-dev-ci"
    location = "Central India"
}

module "network" {
    source = "../../modules/network"

    vnet_name           = "vnet-dev-ci"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    address_space = ["10.0.0.0/16"]

    subnets = {
    app = {
        name           = "snet-app-dev"
        address_prefix = ["10.0.1.0/24"]
    }

    jump = {
        name           = "snet-jump-dev"
        address_prefix = ["10.0.2.0/24"]
    }

    pe = {
        name           = "snet-pe-dev"
        address_prefix = ["10.0.3.0/24"]
        private_endpoint_network_policies = "Disabled"
    }
    }

    nsg_rules = {
    app = [
        {
        name                       = "allow-sql-from-jump"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_address_prefix      = "10.0.2.0/24"
        destination_port_range     = "1433"
        }
    ]

    jump = [
        {
        name                   = "allow-rdp"
        priority               = 100
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = "Tcp"
        source_address_prefix  = "168.62.246.146"#"223.190.82.146"
        destination_port_range = "3389"
        }
    ]
    }
}