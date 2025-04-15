#!/bin/bash

set -e

DOCKER_USERNAME=${DOCKER_USERNAME:-"xanderbilla"}
VERSION_FILE="version.txt"
STACK_NAME="devops-stack"
COMPOSE_FILE="docker-compose.yml"

# Determine version/tag
if [ -f "$VERSION_FILE" ]; then
  IMAGE_TAG=$(cat "$VERSION_FILE")
else
  echo "Version file not found. Using 'latest' tag."
  IMAGE_TAG="latest"
fi

export DOCKER_USERNAME
export IMAGE_TAG

echo "Deploying stack '$STACK_NAME' with tag '$IMAGE_TAG'"

# Deploy using Docker Stack (Swarm)
docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"

echo "Deployment complete!"
