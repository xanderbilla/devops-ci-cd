#!/bin/bash

# Exit on any error
set -e

echo "🧹 Starting thorough cleanup..."

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

# Remove all images
echo "Removing all images..."
docker rmi $(docker images -q) 2>/dev/null || true

# Remove unused networks
echo "Removing unused networks..."
docker network prune -f

# Remove unused volumes
echo "Removing unused volumes..."
docker volume prune -f

# Remove unused build cache
echo "Removing unused build cache..."
docker builder prune -f

echo "✅ Cleanup complete! All containers, images, networks, volumes, and build cache have been removed."
echo "You can now run build-and-push.sh followed by deploy.sh to deploy the stack." 