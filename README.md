# Airline Fares Database

A PostgreSQL database repository for storing and analyzing airline fare predictions, including Azure infrastructure for `airline-price-api`.

## Overview

This project provides:

- PostgreSQL schema, migrations, and seed data for airline fare predictions
- The `search_fares(...)` database function used by `airline-price-api`
- Terraform for Azure Database for PostgreSQL Flexible Server infrastructure

## Prerequisites

This project runs a PostgreSQL container. There are no Python dependencies, so a `requirements.txt` file would be misleading here.

The repo setup is OS-agnostic after clone, but Docker installation is still platform-specific:

- macOS: Docker Desktop, or Colima plus Docker CLI
- Linux: Docker Engine with the Compose plugin
- Windows: Docker Desktop with WSL2

You also need `make`, which is preinstalled on most macOS and Linux systems and available on Windows through common developer shells.

## Quick Start

1. Verify prerequisites:
```bash
make doctor
```

2. Start the database:
```bash
make up
```

3. Verify the seeded data:
```bash
make psql
```

Then run:
```bash
SELECT COUNT(*) FROM fare_predictions;
```

4. Reset the database any time:
```bash
make reset
```

5. Stop the database:
```bash
make down
```

## Available Commands

```bash
make up      # start postgres in the background
make down    # stop postgres
make doctor  # verify docker prerequisites
make reset   # recreate schema and seed data
make psql    # open a psql shell inside the container
make logs    # view postgres logs
```

## Manual Docker Commands

If you prefer not to use `make`, these commands are equivalent:

```bash
docker compose up -d
docker compose exec postgres psql -U airlineuser -d airlinefares
./scripts/reset_db.sh
docker compose down
```

## Database Schema

The database includes tables for:
- Fare predictions with route, date, and price information
- Historical pricing trends
- Flight availability data

The application-facing search function is created by [`migrations/002_create_search_fares_function.sql`](migrations/002_create_search_fares_function.sql).

## Connection Details

- Host: localhost
- Port: 5432
- Database: airlinefares
- Username: airlineuser
- Password: airlinepass

## Scripts

- `scripts/reset_db.sh` - Drop and recreate database with fresh migrations and seed data
- `scripts/check_prereqs.sh` - Validate Docker prerequisites across environments
- `Makefile` - Convenience commands for common local tasks

## Azure Infrastructure

Azure PostgreSQL infrastructure lives under [`infra/terraform`](infra/terraform).

For the dev environment, this repo provisions:

- Resource group `rg-airline-price-api-dev-data`
- PostgreSQL Flexible Server `airline-price-api-dev-pg`
- Database `airlinefares`
- Key Vault-backed PostgreSQL secrets for app consumption

See [`infra/terraform/README.md`](infra/terraform/README.md) for deployment and output details.
