#!/bin/bash

# Exit on error
set -e

# Configuration
DOCKER_USERNAME="xanderbilla"
BACKEND_IMAGE_NAME="devops-backend"
FRONTEND_IMAGE_NAME="devops-frontend"
VERSION_FILE="version.txt"

# Check if version file exists, create if not
if [ ! -f "$VERSION_FILE" ]; then
  echo "1.0.0" > "$VERSION_FILE"
  echo "Created version file with initial version 1.0.0"
fi

# Read current version
CURRENT_VERSION=$(cat "$VERSION_FILE")
echo "Current version: $CURRENT_VERSION"

# Increment version (simple patch increment)
IFS='.' read -r major minor patch <<< "$CURRENT_VERSION"
NEW_PATCH=$((patch + 1))
NEW_VERSION="$major.$minor.$NEW_PATCH"
echo "New version: $NEW_VERSION"

# Update version file
echo "$NEW_VERSION" > "$VERSION_FILE"
echo "Updated version file to $NEW_VERSION"

# Build backend image
echo "Building backend image..."
docker build -t "$DOCKER_USERNAME/$BACKEND_IMAGE_NAME:latest" -t "$DOCKER_USERNAME/$BACKEND_IMAGE_NAME:$NEW_VERSION" ./backend

# Build frontend image
echo "Building frontend image..."
docker build -t "$DOCKER_USERNAME/$FRONTEND_IMAGE_NAME:latest" -t "$DOCKER_USERNAME/$FRONTEND_IMAGE_NAME:$NEW_VERSION" ./frontend



# Push backend images
echo "Pushing backend images to Docker Hub..."
docker push "$DOCKER_USERNAME/$BACKEND_IMAGE_NAME:latest"
docker push "$DOCKER_USERNAME/$BACKEND_IMAGE_NAME:$NEW_VERSION"

# Push frontend images
echo "Pushing frontend images to Docker Hub..."
docker push "$DOCKER_USERNAME/$FRONTEND_IMAGE_NAME:latest"
docker push "$DOCKER_USERNAME/$FRONTEND_IMAGE_NAME:$NEW_VERSION"

echo "All images built and pushed successfully!"
echo "Backend: $DOCKER_USERNAME/$BACKEND_IMAGE_NAME:$NEW_VERSION"
echo "Frontend: $DOCKER_USERNAME/$FRONTEND_IMAGE_NAME:$NEW_VERSION" 

docker run -d -p 8500:8080 "$DOCKER_USERNAME/$BACKEND_IMAGE_NAME:latest"