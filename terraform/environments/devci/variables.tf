variable "vm_admin_username" {}
variable "vm_admin_password" {
    sensitive = true
    }

    variable "sql_admin_login" {}
    variable "sql_admin_password" {
    sensitive = true
    }

    variable "aad_admin" {
    type = object({
        login_username = string
        object_id      = string
    })
}