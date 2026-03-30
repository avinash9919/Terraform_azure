variable "name" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "admin_login" {
    type = string
}

variable "admin_password" {
    type = string
    sensitive = true
}

variable "aad_admin" {
    type = object({
        login_username = string
        object_id      = string
    })
}