/*/*module "sql_server" {
    source = "../../modules/sql_server"

    sql_config  = var.sql_config
}*/

#============================
/*provider "azurerm" {
  features {}
}*/

locals {
  env        = "dev"
  project    = "tf"

  naming = {
    resource_group = "rg-${local.project}-sql-${local.env}"
    sql_server     = "sql-${local.project}-${local.env}"
    database       = "sqldb-${local.project}-${local.env}"
  }
}

/*resource "azurerm_resource_group" "rg" {
  name     = "rg-tf-sql-dev"
  location = var.location
}*/

resource "azurerm_resource_group" "rg" {
  name     = local.naming.resource_group
  location = var.location
}


/*module "sql_server" {
  source = "../../modules/sql_server"

  sql_config = {
    server_name    = var.server_name
    admin_login    = var.admin_login
    admin_password = var.admin_password
    location       = var.location
    resource_group = azurerm_resource_group.rg.name
  }
}

module "sql_server" {
  source = "../../modules/sql_server"

  sql_config = {
    server_name    = local.naming.sql_server
    admin_login    = var.admin_login
    admin_password = var.admin_password
    location       = var.location
    resource_group = azurerm_resource_group.rg.name
  }
}

module "sql_database" {
  source = "../../modules/sql_database"

  for_each = var.databases

  db_config = {
    db_name   = each.value.name
    server_id = module.sql_server.server_id
    sku       = each.value.sku
  }
} */