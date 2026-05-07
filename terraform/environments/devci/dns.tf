module "private_dns" {
    source = "../../modules/private_dns"

    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location

    vnet_id = module.network.vnet_id

    dns_zone_name = "privatelink.database.windows.net"
}

