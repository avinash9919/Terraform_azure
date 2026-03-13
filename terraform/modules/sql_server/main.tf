provider "azurerm" {
    features {}
    }


    resource "azurerm_resource_group" "sql_rg" {
    name     = "rg-tf-sql-prod"
    location = var.location
    }

    data "azurerm_client_config" "current" {}

resource "azurerm_mssql_server" "sqlserver" {
    name                         = var.sql_server_name
    resource_group_name          = azurerm_resource_group.sql_rg.name
    location                     = var.location
    version                      = "12.0"

    administrator_login          = var.sql_admin_login
    administrator_login_password = var.sql_admin_password

    public_network_access_enabled = false

    identity {
        type = "SystemAssigned"
        }

    azuread_administrator {
        azuread_authentication_only = false
        login_username              = "AzureADAdmin"
        object_id                   = data.azurerm_client_config.current.object_id
        tenant_id                   = data.azurerm_client_config.current.tenant_id
    }
}

# sqlserver identity

data "azurerm_mssql_server" "sqlserver_identity" {
    name                = azurerm_mssql_server.sqlserver.name
    resource_group_name = azurerm_resource_group.sql_rg.name

    depends_on = [
        azurerm_mssql_server.sqlserver
    ]
}


resource "azurerm_mssql_database" "database" {
    name      = var.sql_database_name
    server_id = azurerm_mssql_server.sqlserver.id
    sku_name  = var.sql_sku
}


data "azurerm_resource_group" "network_rg" {
    name = "rg-tf-network-dev"
}

data "azurerm_virtual_network" "vnet" {
    name                = "vnet-tf-dev"
    resource_group_name = data.azurerm_resource_group.network_rg.name
}

/*data "azurerm_subnet" "pe_subnet" {
    name                 = "snet-pe-dev"
    virtual_network_name = data.azurerm_virtual_network.vnet.name
    resource_group_name  = data.azurerm_resource_group.network_rg.name
}
*/


data "azurerm_private_dns_zone" "sql_dns" {
    name                = "privatelink.database.windows.net"
    resource_group_name = "rg-tf-sql-dev"
    }

resource "azurerm_private_endpoint" "sql_pe" {
    name                = "pe-sql-prod"
    location            = var.location
    resource_group_name = azurerm_resource_group.sql_rg.name
    subnet_id = "${data.azurerm_virtual_network.vnet.id}/subnets/snet-pe-dev"

    private_service_connection {
        name                           = "sql-private-connection"
        private_connection_resource_id = azurerm_mssql_server.sqlserver.id
        subresource_names              = ["sqlServer"]
        is_manual_connection           = false
    }

    private_dns_zone_group {
        name                 = "sql-dns-zone-group"
        private_dns_zone_ids = [data.azurerm_private_dns_zone.sql_dns.id]
    }
}

#Enable Defender for SQL
resource "azurerm_storage_account" "audit_logs" {
    name                     = "tfsqlauditci001"
    resource_group_name      = azurerm_resource_group.sql_rg.name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    min_tls_version = "TLS1_2"

    allow_nested_items_to_be_public = false
}

# Give SQL Server Access to Storage

resource "azurerm_role_assignment" "sql_storage_access" {
    scope                = azurerm_storage_account.audit_logs.id
    role_definition_name = "Storage Blob Data Contributor"

    principal_id = data.azurerm_mssql_server.sqlserver_identity.identity[0].principal_id
}

#Create Storage Account for Audit Logs

resource "azurerm_mssql_server_extended_auditing_policy" "audit" {
    server_id = azurerm_mssql_server.sqlserver.id

    storage_endpoint = azurerm_storage_account.audit_logs.primary_blob_endpoint

    retention_in_days = 30

    audit_actions_and_groups = [
    "FAILED_DATABASE_AUTHENTICATION_GROUP",
    "SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP",
    "SCHEMA_OBJECT_CHANGE_GROUP"
    ]
    depends_on = [
        azurerm_role_assignment.sql_storage_access
    ]
}


##Enable Defender for SQL
resource "azurerm_mssql_server_security_alert_policy" "defender" {
    resource_group_name = azurerm_resource_group.sql_rg.name
    server_name = azurerm_mssql_server.sqlserver.name
    state = "Enabled"
    email_account_admins = true
}