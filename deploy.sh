#!/bin/bash

set -e

DOCKER_USERNAME=${DOCKER_USERNAME:-"xanderbilla"}
VERSION_FILE="version.txt"
DEPLOY_TEMPLATE="deploy/deploy-stack.template.yml"
DEPLOY_FINAL="deploy/deploy-stack.yml"
REMOTE_USER="ubuntu"
REMOTE_HOST=<EC2-1-IP>  # ← Replace with your manager instance IP
STACK_NAME="devops"

# Read version
if [ ! -f "$VERSION_FILE" ]; then
  echo "Version file not found. Using 'latest'."
  IMAGE_TAG="latest"
else
  IMAGE_TAG=$(cat "$VERSION_FILE")
  echo "Using version: $IMAGE_TAG"
fi

# Replace placeholder with tag in stack template
echo "Preparing stack file..."
export IMAGE_TAG
envsubst < "$DEPLOY_TEMPLATE" > "$DEPLOY_FINAL"

# Deploy to swarm manager
echo "Deploying to Docker Swarm Manager..."
scp "$DEPLOY_FINAL" "$REMOTE_USER@$REMOTE_HOST:/home/ubuntu/deploy-stack.yml"
ssh "$REMOTE_USER@$REMOTE_HOST" "docker stack deploy -c /home/ubuntu/deploy-stack.yml $STACK_NAME"

echo "✅ Deployed stack: $STACK_NAME using tag: $IMAGE_TAG"