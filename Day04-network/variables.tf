variable "rg_name"{
    description = "Resource groups name"
    type = string
}
variable "location"{
    description = "azure region"
    type = string
}
variable "vnet_name"{
    description="Virtual network name"
    type = string
}
variable "subnet_name"{
    description = "subnet name"
    type = string
}

variable "address_space"{
    description = "VNet address space"
    type = list(string)
}
variable "subnet_prefix"{
    description = "subnet address prefix"
    type = list(string)
}