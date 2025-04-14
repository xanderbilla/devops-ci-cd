#!/bin/bash

# Exit on error
set -e

# Configuration
DOCKER_USERNAME=${DOCKER_USERNAME:-"xanderbilla"}
IMAGE_TAG=${IMAGE_TAG:-"latest"}
VERSION_FILE="version.txt"

# Check if version file exists
if [ ! -f "$VERSION_FILE" ]; then
  echo "Version file not found. Using 'latest' tag."
  IMAGE_TAG="latest"
else
  # Read current version
  CURRENT_VERSION=$(cat "$VERSION_FILE")
  echo "Using version: $CURRENT_VERSION"
  IMAGE_TAG=$CURRENT_VERSION
fi

# Export environment variables for docker-compose
export DOCKER_USERNAME
export IMAGE_TAG

echo "Deploying application with:"
echo "Docker Username: $DOCKER_USERNAME"
echo "Image Tag: $IMAGE_TAG"

# Pull the latest images
echo "Pulling latest images..."
docker-compose pull

# Start the application
echo "Starting application..."
docker-compose up -d

echo "Deployment completed successfully!"
echo "Backend: $DOCKER_USERNAME/devops-backend:$IMAGE_TAG"
echo "Frontend: $DOCKER_USERNAME/devops-frontend:$IMAGE_TAG" 