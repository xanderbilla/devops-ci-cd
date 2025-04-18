#!/bin/bash

# Exit on any error
set -e

# Configuration
DOCKER_USERNAME=${DOCKER_USERNAME:-"xanderbilla"}
STACK_NAME="devops-stack"
COMPOSE_FILE="docker-compose.yml"
JENKINS_HOST=${JENKINS_HOST:-"localhost"}
BACKEND_PORT="8500"
FRONTEND_PORT="3000"
IMAGE_TAG="latest"

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
        # Get the host IP for swarm initialization
        HOST_IP=$(hostname -I | awk '{print $1}')
        if docker swarm init --advertise-addr $HOST_IP; then
            print_message "$GREEN" "✅ Docker Swarm initialized successfully on $HOST_IP"
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

# Function to wait for service health
wait_for_service() {
    local service_name=$1
    local max_attempts=30
    local attempt=1
    
    print_message "$YELLOW" "⏳ Waiting for $service_name to be healthy..."
    
    while [ $attempt -le $max_attempts ]; do
        if docker service ls | grep $service_name | grep -q "1/1"; then
            print_message "$GREEN" "✅ $service_name is healthy"
            return 0
        fi
        print_message "$YELLOW" "Attempt $attempt/$max_attempts: $service_name is not ready yet..."
        print_message "$YELLOW" "Checking logs for $service_name..."
        docker service logs "$STACK_NAME"_$service_name --tail 20
        sleep 5
        attempt=$((attempt + 1))
    done
    
    print_message "$RED" "❌ $service_name failed to become healthy after $max_attempts attempts"
    return 1
}

# Function to deploy the stack
deploy_stack() {
    print_message "$YELLOW" "🚀 Deploying stack '$STACK_NAME'..."
    
    # Export environment variables for the compose file
    export DOCKER_USERNAME
    export IMAGE_TAG
    export JENKINS_HOST
    
    if docker stack deploy -c "$COMPOSE_FILE" "$STACK_NAME"; then
        print_message "$GREEN" "✅ Stack deployed successfully"
        
        # Wait for services to be healthy
        wait_for_service "backend" || exit 1
        wait_for_service "frontend" || exit 1
    else
        print_message "$RED" "❌ Failed to deploy stack"
        exit 1
    fi
}

# Function to check service status and connectivity
check_services() {
    print_message "$YELLOW" "📊 Checking service status..."
    docker stack services "$STACK_NAME"
    
    # Check service connectivity
    print_message "$YELLOW" "🔍 Checking service connectivity..."
    
    # Wait for services to be fully ready
    print_message "$YELLOW" "Waiting for services to be fully ready..."
    sleep 10
    
    # Get container IDs
    BACKEND_CONTAINER=$(docker ps -q -f name=backend)
    FRONTEND_CONTAINER=$(docker ps -q -f name=frontend)
    
    # Check Backend with retries
    print_message "$YELLOW" "Testing backend health endpoint..."
    for i in {1..3}; do
        if docker exec $BACKEND_CONTAINER wget -q -O- http://localhost:8080/actuator/health > /dev/null; then
            print_message "$GREEN" "✅ Backend is accessible"
            break
        else
            if [ $i -eq 3 ]; then
                print_message "$RED" "❌ Backend is not accessible"
            else
                print_message "$YELLOW" "Retrying backend check in 5 seconds..."
                sleep 5
            fi
        fi
    done
    
    # Check Frontend with retries
    for i in {1..3}; do
        if docker exec $FRONTEND_CONTAINER wget -q -O- http://localhost:80 > /dev/null; then
            print_message "$GREEN" "✅ Frontend is accessible"
            break
        else
            if [ $i -eq 3 ]; then
                print_message "$RED" "❌ Frontend is not accessible"
            else
                print_message "$YELLOW" "Retrying frontend check in 5 seconds..."
                sleep 5
            fi
        fi
    done

    print_message "$GREEN" "✅ Service connectivity check completed"
}

# Main deployment process
main() {
    print_message "$YELLOW" "🚀 Starting deployment process..."
    print_message "$YELLOW" "📦 Stack name: $STACK_NAME"
    print_message "$YELLOW" "👤 Docker username: $DOCKER_USERNAME"
    print_message "$YELLOW" "🌐 Jenkins host: $JENKINS_HOST"
    print_message "$YELLOW" "🏷️  Using image tag: $IMAGE_TAG"
    
    # Run deployment steps
    check_docker
    init_swarm
    check_files
    remove_existing_stack
    deploy_stack
    check_services
    
    print_message "$GREEN" "✅ Deployment complete!"
    print_message "$YELLOW" "🔍 You can check service logs using: docker service logs $STACK_NAME_<service-name>"
}

# Run the main function
main

