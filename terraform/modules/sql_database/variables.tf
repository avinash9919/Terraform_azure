variable "databases" {
    type = map(object({
        name  = string
        sku   = string
    }))
    }

    variable "sql_server_id" {
    type = string
}

