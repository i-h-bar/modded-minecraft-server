#!/bin/bash

REQUIRED_VARS="MINECRAFT_HOST_DIR NGROK_AUTHTOKEN FORGE_VERSION MEMORY_ALLOCATION"
ENV_FILE="./.env"

if [ -f "$ENV_FILE" ]; then
    echo "Sourcing environment variables from '$ENV_FILE'..."
    set -a
    . "$ENV_FILE"
    set +a
else
    echo "Warning: No '$ENV_FILE' file found. Checking only system environment variables."
fi

echo "Checking for required environment variables..."

for var in $REQUIRED_VARS; do
    eval value=\$${var}
    if [ -z "$value" ]; then
        echo "Error: The environment variable '$var' is not set."
        exit 1
    fi
done

echo "All required environment variables are set. Proceeding..."
echo "Building and starting Docker containers..."

docker compose build
docker compose up -d

sleep 5

url=$(docker logs ngrok-tunnel | grep "url=" | awk -F'url=' '{print $2}' | sed 's/tcp:\/\///' | tr -d '\r')
echo "ngrok tunnel URL: $url"

echo "Script finished."