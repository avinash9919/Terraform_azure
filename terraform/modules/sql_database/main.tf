resource "azurerm_mssql_database" "db" {
    name      = var.db_config.db_name
    server_id = var.db_config.server_id
    sku_name  = var.db_config.sku

    lifecycle {
        prevent_destroy = false
    }
}