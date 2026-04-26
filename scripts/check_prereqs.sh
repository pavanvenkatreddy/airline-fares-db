#!/bin/sh

set -e

if [ -x /Applications/Docker.app/Contents/Resources/bin/docker ]; then
    PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
    export PATH
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker CLI was not found."
    echo "Install Docker Desktop or Docker Engine, then retry."
    exit 1
fi

if docker compose version >/dev/null 2>&1; then
    :
elif command -v docker-compose >/dev/null 2>&1; then
    :
else
    echo "Docker Compose was not found."
    echo "Install Docker Desktop or Docker Engine with the Compose plugin."
    exit 1
fi

echo "Docker prerequisites look good."
