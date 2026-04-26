#!/bin/bash

# Script to reset the airline fares database
# This will drop all tables and recreate them with fresh migrations and seed data

set -e

if [ -x /Applications/Docker.app/Contents/Resources/bin/docker ]; then
    PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
    export PATH
fi

echo "🔄 Resetting airline fares database..."

if docker compose version >/dev/null 2>&1; then
    DC="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
    DC="docker-compose"
else
    echo "❌ Docker Compose is not installed."
    echo "Install Docker Desktop or Docker Engine with the Compose plugin."
    exit 1
fi

# Check if Docker container is running
if ! $DC ps | grep -q "airline-fares-db"; then
    echo "❌ Database container is not running. Starting it now..."
    $DC up -d
    echo "⏳ Waiting for database to be ready..."
    sleep 5
fi

# Drop all tables
echo "🗑️  Dropping existing tables..."
$DC exec -T postgres psql -U airlineuser -d airlinefares << EOF
DROP VIEW IF EXISTS fare_price_analysis CASCADE;
DROP TABLE IF EXISTS fare_predictions CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
EOF

# Run migrations in filename order
echo "📦 Running migrations..."
for migration in migrations/*.sql; do
    echo "   -> Applying $migration"
    migration_name=$(basename "$migration")
    $DC exec -T postgres psql -U airlineuser -d airlinefares -f "/docker-entrypoint-initdb.d/$migration_name"
done

# Seed data
echo "🌱 Seeding data..."
$DC exec -T postgres psql -U airlineuser -d airlinefares -f /seed/001_seed_fare_predictions.sql

# Verify
echo "✅ Verifying database..."
RECORD_COUNT=$($DC exec -T postgres psql -U airlineuser -d airlinefares -t -c "SELECT COUNT(*) FROM fare_predictions;")
echo "📊 Total fare predictions: $RECORD_COUNT"

echo "✨ Database reset complete!"
echo ""
echo "Connect to database:"
echo "  psql -h localhost -p 5432 -U airlineuser -d airlinefares"
echo ""
