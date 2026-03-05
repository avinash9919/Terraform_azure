provider "azurerm" {
    features {  }
}

#tfstate backend
terraform {
  backend "azurerm" {
    resource_group_name = "rg-tf-backend"
    storage_account_name = "tfstatebackendci"
    container_name = "tfstate"
    key            = "azuresql.tfstate"
  } 
}

#create resource group for sql server

resource "azurerm_resource_group" "sql_rg" {
    name     = "rg-tf-sql-dev"
    location = "Central India"
}

#Reference Existing Network

data "azurerm_resource_group" "network_rg" {
    name = "rg-tf-network-dev"  
}

data "azurerm_subnet" "pe_subnet" {
    name = "snet-pe-dev"
    virtual_network_name = "vnet-tf-dev"
    resource_group_name = data.azurerm_resource_group.network_rg.name
}


data "azurerm_virtual_network" "vnet" {
  name                = "vnet-tf-dev"
  resource_group_name = data.azurerm_resource_group.network_rg.name
}
#Create SQL Server

resource "azurerm_mssql_server" "sqlserver" {
    name = "sql001devci"
    resource_group_name = azurerm_resource_group.sql_rg.name
    location = azurerm_resource_group.sql_rg.location
    version = "12.0"
    administrator_login = "sqlserveradmin"
    administrator_login_password = "Password1234!"

    public_network_access_enabled = false
}

## create SQL database on my sql server

resource "azurerm_mssql_database" "sql_db" {
    name = "mydbdev"
    server_id = azurerm_mssql_server.sqlserver.id
    sku_name = "basic"
}

##Private Endpoint (In SQL RG)

resource "azurerm_private_endpoint" "sql_pe" {
    name                = "pe-sql-dev"
    location            = azurerm_resource_group.sql_rg.location
    resource_group_name = azurerm_resource_group.sql_rg.name
    subnet_id           = data.azurerm_subnet.pe_subnet.id

    private_service_connection {
        name                           = "sql-private-connection"
        private_connection_resource_id = azurerm_mssql_server.sqlserver.id
        subresource_names              = ["sqlServer"]
        is_manual_connection           = false
    }
}

##Private DNS Zone (Still OK in SQL RG)

resource "azurerm_private_dns_zone" "sql_dns" {
    name                = "privatelink.database.windows.net"
    resource_group_name = azurerm_resource_group.sql_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
    name                  = "sql-dns-link"
    resource_group_name   = azurerm_resource_group.sql_rg.name
    private_dns_zone_name = azurerm_private_dns_zone.sql_dns.name
    virtual_network_id    = data.azurerm_virtual_network.vnet.id
}