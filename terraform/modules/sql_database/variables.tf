variable "db_config" {
    type = object({
        db_name   = string
        server_id = string
        sku       = string
    })
}