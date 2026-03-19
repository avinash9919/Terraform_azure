/*variable "sql_server_name" {
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
*/

### converting this in locals {} 

/*variable "sql_config" {
    description = "SQL confirguration object"

    type = object({
        server_name = string
        database_name = string
        admin_login =  string
        admin_password = string
        sku = string
        location = string
    })
} */


variable "sql_config" {
    type = object({
        server_name     = string
        admin_login     = string
        admin_password  = string
        location        = string
        resource_group  = string
    })
}