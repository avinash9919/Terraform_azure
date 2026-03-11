variable "sql_server_name" {
    description = "name of sql server"
    type = string
}

variable "sql_database_name" {
    description = "nameof the SQL database"
    type = string
}

variable "location" {
    type = string
}

variable "sql_admin_login" {
    type = string
}

variable "sql_admin_password" {
    type = string
    sensitive = true
}

variable "sql_sku" {
    type = string
}