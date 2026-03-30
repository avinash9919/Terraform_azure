resource "azurerm_mssql_server" "sql_server" {
    name                = var.name
    location            = var.location
    resource_group_name = var.resource_group_name
    version = "12.0"

    administrator_login    = var.admin_login
    administrator_login_password = var.admin_password

    public_network_access_enabled = true

    azuread_administrator {
        login_username = var.aad_admin.login_username
        object_id = var.aad_admin.object_id
    }
}

# Azure AD Admin
