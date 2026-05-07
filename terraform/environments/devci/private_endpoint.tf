module "private_endpoint_sql" {
    source = "../../modules/private_endpoint"

    name                = "pe-sql-dev"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    subnet_id = module.network.subnet_ids["pe"]

    target_resource_id = module.sql_server.sql_server_id

    subresource_names = ["sqlServer"]

    dns_zone_id = module.private_dns.dns_zone_id
}