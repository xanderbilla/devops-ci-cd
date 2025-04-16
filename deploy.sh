#!/bin/bash

# Exit on any error
set -e

# Configuration
DOCKER_USERNAME=${DOCKER_USERNAME:-"xanderbilla"}
VERSION_FILE="version.txt"
STACK_NAME="devops-stack"
COMPOSE_FILE="docker-compose.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_message "$RED" "❌ Docker is not running. Please start Docker and try again."
        exit 1
    fi
    print_message "$GREEN" "✅ Docker is running"
}

# Function to initialize swarm if not already initialized
init_swarm() {
    if ! docker info 2>/dev/null | grep -q "Swarm: active"; then
        print_message "$YELLOW" "🔄 Initializing Docker Swarm..."
        if docker swarm init; then
            print_message "$GREEN" "✅ Docker Swarm initialized successfully"
        else
            print_message "$RED" "❌ Failed to initialize Docker Swarm"
            exit 1
        fi
    else
        print_message "$GREEN" "✅ Docker Swarm is already active"
    fi
}

# Function to check if required files exist
check_files() {
    if [ ! -f "$COMPOSE_FILE" ]; then
        print_message "$RED" "❌ Docker Compose file not found: $COMPOSE_FILE"
        exit 1
    fi
    print_message "$GREEN" "✅ Found Docker Compose file"
}

# Function to determine version/tag
get_version() {
    if [ -f "$VERSION_FILE" ]; then
        IMAGE_TAG=$(cat "$VERSION_FILE")
        print_message "$GREEN" "✅ Using version from file: $IMAGE_TAG"
    else
        IMAGE_TAG="latest"
        print_message "$YELLOW" "⚠️ Version file not found. Using 'latest' tag"
    fi
}

# Function to remove existing stack
remove_existing_stack() {
    if docker stack ls | grep -q "$STACK_NAME"; then
        print_message "$YELLOW" "🔄 Removing existing stack..."
        docker stack rm "$STACK_NAME"
        
        # Wait for stack removal to complete
        while docker stack ls | grep -q "$STACK_NAME"; do
            print_message "$YELLOW" "⏳ Waiting for stack removal to complete..."
            sleep 2
        done
        print_message "$GREEN" "✅ Existing stack removed"
    fi
}

# Function to deploy the stack
deploy_stack() {
    print_message "$YELLOW" "🚀 Deploying stack '$STACK_NAME'..."
    if docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"; then
        print_message "$GREEN" "✅ Stack deployed successfully"
    else
        print_message "$RED" "❌ Failed to deploy stack"
        exit 1
    fi
}

# Function to check service status
check_services() {
    print_message "$YELLOW" "⏳ Waiting for services to be ready..."
    sleep 5
    
    print_message "$YELLOW" "📊 Checking service status..."
    docker stack services "$STACK_NAME"
}

# Main deployment process
main() {
    print_message "$YELLOW" "🚀 Starting deployment process..."
    print_message "$YELLOW" "📦 Stack name: $STACK_NAME"
    print_message "$YELLOW" "👤 Docker username: $DOCKER_USERNAME"
    
    # Export environment variables
    export DOCKER_USERNAME
    export IMAGE_TAG
    
    # Run deployment steps
    check_docker
    init_swarm
    check_files
    get_version
    remove_existing_stack
    deploy_stack
    check_services
    
    print_message "$GREEN" "✅ Deployment complete!"
    print_message "$YELLOW" "🔍 You can check service logs using: docker service logs $STACK_NAME_<service-name>"
}

# Run the main function
main

