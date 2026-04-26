resource "random_password" "admin" {
  length           = 32
  special          = true
  override_special = "!@#%^*-_"
}

resource "random_string" "key_vault_suffix" {
  length  = 5
  upper   = false
  special = false
}

locals {
  key_vault_name = coalesce(
    var.key_vault_name,
    "airlinepriceapidevkv${random_string.key_vault_suffix.result}"
  )

  postgres_fqdn = azurerm_postgresql_flexible_server.this.fqdn
  postgres_port = 5432
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.server_name
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  version                = var.postgresql_version
  administrator_login    = var.administrator_login
  administrator_password = random_password.admin.result
  zone                   = var.zone
  storage_mb             = var.storage_mb
  sku_name               = var.sku_name
  backup_retention_days  = var.backup_retention_days

  public_network_access_enabled = true

  authentication {
    active_directory_auth_enabled = false
    password_auth_enabled         = true
  }

  lifecycle {
    ignore_changes = [
      zone,
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  count = var.allow_azure_services ? 1 : 0

  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allowed_ips" {
  for_each = {
    for rule in var.allowed_ip_rules : rule.name => rule
  }

  name             = each.value.name
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_key_vault" "this" {
  name                            = local.key_vault_name
  location                        = azurerm_resource_group.this.location
  resource_group_name             = azurerm_resource_group.this.name
  tenant_id                       = var.tenant_id
  sku_name                        = "standard"
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  enabled_for_template_deployment = false
  enable_rbac_authorization       = false
}

resource "azurerm_key_vault_access_policy" "terraform_principal" {
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = var.tenant_id
  object_id    = var.current_principal_object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover",
  ]
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = var.password_secret_name
  value        = random_password.admin.result
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [azurerm_key_vault_access_policy.terraform_principal]
}

resource "azurerm_key_vault_secret" "postgres_connection_string" {
  name = var.connection_string_secret_name
  value = format(
    "postgresql://%s:%s@%s:%d/%s?sslmode=require",
    var.administrator_login,
    urlencode(random_password.admin.result),
    local.postgres_fqdn,
    local.postgres_port,
    azurerm_postgresql_flexible_server_database.this.name
  )
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [azurerm_key_vault_access_policy.terraform_principal]
}
