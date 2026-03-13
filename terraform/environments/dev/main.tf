module "sql_server" {
    source = "../../modules/sql_server"

    sql_server_name     = var.sql_server_name
    sql_admin_login     = var.sql_admin_login
    sql_admin_password  = var.sql_admin_password
    sql_database_name   = var.sql_database_name
    sql_sku             = var.sql_sku
    location            = var.location
}