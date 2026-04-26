# Azure PostgreSQL Infrastructure

This directory is the source of truth for Azure PostgreSQL infrastructure used by `airline-price-api`.

## Current scope

- Environment: `dev`
- Region: supplied per environment configuration
- Azure service: Azure Database for PostgreSQL Flexible Server
- Resource group: `rg-airline-price-api-dev-data`
- Server: `airline-price-api-dev-pg`
- Database: `airlinefares`

The SQL objects used by the application, including `search_fares($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`, remain defined in this repo's migrations. Terraform provisions infrastructure only.

## Resources provisioned

- Azure resource group
- PostgreSQL Flexible Server
- PostgreSQL database
- Firewall rule allowing Azure services
- Optional additional firewall rules for explicit IP ranges
- Azure Key Vault
- Key Vault secret containing the PostgreSQL password
- Key Vault secret containing a full PostgreSQL connection string

## Secret handling

Terraform generates a strong administrator password and stores it in Azure Key Vault.

The app repo should consume:

- `PGHOST` from Terraform output `postgres_host`
- `PGPORT` from Terraform output `postgres_port`
- `PGDATABASE` from Terraform output `postgres_database`
- `PGUSER` from Terraform output `postgres_username`
- `PGPASSWORD` from Azure Key Vault secret `postgres_password_secret_name`
- `key_vault_name` and `key_vault_resource_group` to resolve the secret from Key Vault

Optional:

- Use `postgres_connection_string_secret_name` when the app platform prefers a single connection string secret.

## Deploy dev

1. Authenticate with Azure and target subscription 1, or populate the actual subscription ID in `terraform.tfvars`.
2. Copy `environments/dev/terraform.tfvars.example` to `environments/dev/terraform.tfvars`.
3. Run Terraform from `infra/terraform/environments/dev`.

Example:

```bash
terraform init
terraform plan
terraform apply
```

## Outputs for `airline-price-api`

- `postgres_host`
- `postgres_port`
- `postgres_database`
- `postgres_username`
- `postgres_password_secret_name`
- `postgres_password_secret_id`
- `postgres_connection_string_secret_name`
- `postgres_connection_string_secret_id`
- `key_vault_name`
- `key_vault_resource_group`
- `key_vault_uri`

## App repo integration

The app repo should stop managing PostgreSQL creation and instead consume this stack's outputs or remote state.

One straightforward pattern is:

1. Read Terraform remote state from this repo's `dev` environment.
2. Resolve `PGPASSWORD` from the emitted Key Vault secret.
3. Set `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, and `PGPASSWORD` in the app runtime.

Azure Flexible Server typically requires TLS. If the app platform or driver does not enable TLS automatically, set `PGSSLMODE=require` in the app runtime as well.

## GitHub Actions

This repo includes four manual GitHub Actions workflows:

- `Terraform Plan`
- `Terraform Apply`
- `Terraform Destroy`
- `Terraform Rollback`

Each workflow takes an `environment` input and targets `infra/terraform/environments/<environment>`.

`Terraform Rollback` is a config rollback, not a state snapshot restore. It checks out an older Git ref and runs `terraform apply` for that version of the configuration.

### Required GitHub Environment configuration

For each GitHub Environment such as `dev`, `stage`, or `prod`, configure:

Secrets:

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

Variables:

- `TF_VAR_LOCATION`
- `TF_BACKEND_RESOURCE_GROUP_NAME`
- `TF_BACKEND_STORAGE_ACCOUNT_NAME`
- `TF_BACKEND_CONTAINER_NAME`
- Optional `TF_BACKEND_STATE_KEY`

The remote state storage account and blob container must already exist before these workflows can run.

The workflows use GitHub OIDC with `azure/login` and Terraform's `azurerm` backend. HashiCorp documents `use_oidc = true` and `use_azuread_auth = true` for GitHub-based Azure backend authentication, and GitHub documents Azure OIDC setup for Actions. See:

- https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
- https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-azure

### Safeguards

- `Destroy` requires the exact confirmation text `destroy`
- `Rollback` requires the exact confirmation text `rollback`
- Job concurrency is scoped per environment to avoid overlapping state operations
- You should protect GitHub Environments so `prod` requires approval before apply, destroy, or rollback
