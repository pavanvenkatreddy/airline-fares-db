variable "subscription_id" {
  description = "Azure subscription ID for the target environment."
  type        = string
}

variable "resource_group_name" {
  type    = string
  default = "rg-airline-price-api-dev-data"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "server_name" {
  type    = string
  default = "airline-price-api-dev-pg"
}

variable "database_name" {
  type    = string
  default = "airlinefares"
}

variable "administrator_login" {
  description = "Admin username used by the app and migrations until a dedicated app role is introduced."
  type        = string
  default     = "airlineadmin"
}

variable "key_vault_name" {
  description = "Optional override for the Key Vault name. Leave null to generate a globally unique name."
  type        = string
  default     = null
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
  description = "Creates the 0.0.0.0 firewall rule so Azure-hosted apps can connect."
  type        = bool
  default     = true
}

variable "allowed_ip_rules" {
  description = "Optional explicit firewall rules, for example local office or VPN egress IPs."
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  default = []
}
