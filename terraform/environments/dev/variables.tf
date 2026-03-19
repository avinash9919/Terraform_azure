#   sql_server_name     = var.sql_server_name
#   sql_admin_login     = var.sql_admin_login
#   sql_admin_password  = var.sql_admin_password
#   sql_database_name   = var.sql_database_name
#   sql_sku             = var.sql_sku
#   location            = var.location

/*variable "location" {
    type = string
}

variable "sql_server_name" {
    type = string
}

variable "sql_admin_login" {
    type = string
}

variable "sql_admin_password" {
    type = string
    sensitive = true
}

variable "sql_database_name" {
    type = string
}

variable "sql_sku" {
    type = string
} */

/*variable "sql_config" {
    type = object({
        server_name = string
        database_name = string
        admin_login = string
        admin_password = string
        sku   = string
        location = string
    })
}
*/


variable "location" {}
variable "server_name" {}
variable "admin_login" {}
variable "admin_password" {}
#variable "db_sku" {}

variable "databases" {
    type = map(object({
        name = string
        sku  = string
    }))
}