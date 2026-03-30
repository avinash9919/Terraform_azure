
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
        source_address_prefix  = "168.62.246.146"
        destination_port_range = "3389"
        }
    ]
    }
}

#private dns zone for azure sql
module "private_dns" {
    source = "../../modules/private_dns"

    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location

    vnet_id = module.network.vnet_id

    dns_zone_name = "privatelink.database.windows.net"
}

#sql server 

module "sql_server" {
    source = "../../modules/sql_server"

    name                = "sql-dev-centralindia"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    admin_login    = "sqladmin"
    admin_password = "StrongPassword123!"   #  we’ll fix later

    aad_admin = {
        login_username = "avinash@avinashmaddheshiya24gmail.onmicrosoft.com"
        object_id      = "88058409-90fa-4ea0-a81c-6b710db836f7"
    }
}

#sql databases

module "sql_database" {
    source = "../../modules/sql_database"

    sql_server_id = module.sql_server.sql_server_id

    databases = {
        appdb = {
        name = "appdb-dev"
        sku  = "S0"
        }

        logging = {
        name = "logging-dev"
        sku  = "S0"
        }
    }
}