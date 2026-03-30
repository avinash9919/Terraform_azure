#Vnet creation
resource "azurerm_virtual_network" "vnet" {
    name = var.vnet_name
    location = var.location
    resource_group_name = var.resource_group_name
    address_space = var.address_space
}


#Subnet creation
resource "azurerm_subnet" "subnets" {
    for_each = var.subnets

    name = each.value.name
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = each.value.address_prefix

    private_endpoint_network_policies = lookup(each.value, "private_endpoint_network_policies", null)
}

#NSG creation
resource "azurerm_network_security_group" "nsg" {
    for_each = {
        for k,v in var.subnets : 
        k => v if k!="pe"
    }

    name = "nsg-${each.key}"
    location = var.location
    resource_group_name = var.resource_group_name
}

#NSG association with subnets
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
    for_each = {
        for k,v in var.subnets : 
        k => v if k!="pe"
    }

    subnet_id = azurerm_subnet.subnets[each.key].id
    network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

#nsg rules creation

resource "azurerm_network_security_rule" "rules" {

    for_each = {
        for item in flatten([
        for subnet_key, rules in var.nsg_rules : [
            for rule in rules : {
            key        = "${subnet_key}-${rule.name}"
            subnet_key = subnet_key
            rule       = rule
            }
        ]
        ]) : item.key => item
    }

    name                        = each.value.rule.name
    priority                    = each.value.rule.priority
    direction                   = each.value.rule.direction
    access                      = each.value.rule.access
    protocol                    = each.value.rule.protocol

    source_port_range           = "*"
    destination_port_range      = each.value.rule.destination_port_range

    source_address_prefix       = each.value.rule.source_address_prefix
    destination_address_prefix  = "*"

    resource_group_name         = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.nsg[each.value.subnet_key].name
}