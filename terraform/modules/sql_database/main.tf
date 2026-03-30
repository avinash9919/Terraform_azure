resource "azurerm_mssql_database" "db" {
    for_each = var.databases

    name      = each.value.name
    server_id = var.sql_server_id
    sku_name  = each.value.sku
}