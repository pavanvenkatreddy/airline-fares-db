output "resource_group_name" {
  value = module.postgres.resource_group_name
}

output "server_name" {
  value = module.postgres.server_name
}

output "postgres_host" {
  value = module.postgres.postgres_host
}

output "postgres_port" {
  value = module.postgres.postgres_port
}

output "postgres_database" {
  value = module.postgres.postgres_database
}

output "postgres_username" {
  value = module.postgres.postgres_username
}

output "postgres_password_secret_name" {
  value = module.postgres.postgres_password_secret_name
}

output "postgres_password_secret_id" {
  value = module.postgres.postgres_password_secret_id
}

output "postgres_connection_string_secret_name" {
  value = module.postgres.postgres_connection_string_secret_name
}

output "postgres_connection_string_secret_id" {
  value = module.postgres.postgres_connection_string_secret_id
}

output "key_vault_name" {
  value = module.postgres.key_vault_name
}

output "key_vault_uri" {
  value = module.postgres.key_vault_uri
}
