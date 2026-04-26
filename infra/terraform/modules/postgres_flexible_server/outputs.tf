output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "server_name" {
  value = azurerm_postgresql_flexible_server.this.name
}

output "postgres_host" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "postgres_port" {
  value = 5432
}

output "postgres_database" {
  value = azurerm_postgresql_flexible_server_database.this.name
}

output "postgres_username" {
  value = var.administrator_login
}

output "postgres_password_secret_name" {
  value = azurerm_key_vault_secret.postgres_password.name
}

output "postgres_password_secret_id" {
  value = azurerm_key_vault_secret.postgres_password.id
}

output "postgres_connection_string_secret_name" {
  value = azurerm_key_vault_secret.postgres_connection_string.name
}

output "postgres_connection_string_secret_id" {
  value = azurerm_key_vault_secret.postgres_connection_string.id
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "key_vault_resource_group" {
  value = azurerm_resource_group.this.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}
