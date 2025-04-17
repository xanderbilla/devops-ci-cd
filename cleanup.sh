#!/bin/bash

# Exit on any error
set -e

echo "🧹 Cleaning up existing containers and stacks..."

# Remove the stack if it exists
if docker stack ls | grep -q "devops-stack"; then
    echo "Removing devops-stack..."
    docker stack rm devops-stack
    sleep 10
fi

# Stop and remove all containers
echo "Stopping and removing all containers..."
docker stop $(docker ps -aq) 2>/dev/null || true
docker rm $(docker ps -aq) 2>/dev/null || true

# Remove unused networks
echo "Removing unused networks..."
docker network prune -f

echo "✅ Cleanup complete! You can now run deploy.sh to deploy the stack." 