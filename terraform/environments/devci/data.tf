module "sql_server" {
  source = "../../modules/sql_server"

  name                = "sql-dev-centralindia"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  admin_login    = var.sql_admin_login
  admin_password = var.sql_admin_password

  aad_admin = var.aad_admin
}

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