output "sql_server_name" {
    value = azurerm_mssql_server.sqlserver.name
}

output "sql_server_fqdn" {
    value = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
}

output "sql_database_name" {
    value = azurerm_mssql_database.database.name
}

output "audit_storage_account" {
  value = azurerm_storage_account.audit_logs.name
}