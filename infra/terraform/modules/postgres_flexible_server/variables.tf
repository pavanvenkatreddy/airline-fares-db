variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "server_name" {
  type = string
}

variable "database_name" {
  type = string
}

variable "administrator_login" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "current_principal_object_id" {
  type = string
}

variable "key_vault_name" {
  type    = string
  default = null
}

variable "password_secret_name" {
  type    = string
  default = "postgres-password"
}

variable "connection_string_secret_name" {
  type    = string
  default = "postgres-connection-string"
}

variable "postgresql_version" {
  type    = string
  default = "15"
}

variable "zone" {
  type    = string
  default = "1"
}

variable "storage_mb" {
  type    = number
  default = 32768
}

variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "allow_azure_services" {
  type    = bool
  default = true
}

variable "allowed_ip_rules" {
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}
