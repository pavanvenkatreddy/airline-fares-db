data "azurerm_client_config" "current" {}

module "postgres" {
  source = "../../modules/postgres_flexible_server"

  resource_group_name         = var.resource_group_name
  location                    = var.location
  server_name                 = var.server_name
  database_name               = var.database_name
  administrator_login         = var.administrator_login
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  current_principal_object_id = data.azurerm_client_config.current.object_id

  key_vault_name                = var.key_vault_name
  password_secret_name          = var.password_secret_name
  connection_string_secret_name = var.connection_string_secret_name
  postgresql_version            = var.postgresql_version
  zone                          = var.zone
  storage_mb                    = var.storage_mb
  sku_name                      = var.sku_name
  backup_retention_days         = var.backup_retention_days
  allow_azure_services          = var.allow_azure_services
  allowed_ip_rules              = var.allowed_ip_rules
}
