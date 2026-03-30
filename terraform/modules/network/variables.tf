variable "vnet_name" {
    description = "The name of the virtual network."
    type        = string
}

variable "location" {
    description = "The location of the virtual network."
    type        = string
}

variable "resource_group_name" {
    type = string
}

variable "address_space" {
    type = list(string)
}

variable "subnets" {
    type = map(object({
        name           = string
        address_prefix = list(string)
        private_endpoint_network_policies =optional(string)
    }))
}

#NSG rules variable
variable "nsg_rules" {
    type = map(list(object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_address_prefix      = string
        destination_port_range     = string
    })))
}