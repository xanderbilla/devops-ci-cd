# DevOps Project

This project consists of a Spring Boot backend and a Next.js 15.3 frontend, containerized with Docker.

## Project Structure

- `backend/`: Spring Boot application
- `frontend/`: Next.js 15.3 application (requires Node.js v20)
- `build-and-push.sh`: Script to build and push Docker images to Docker Hub
- `deploy.sh`: Script to deploy the application using Docker Hub images
- `docker-compose.yml`: Docker Compose configuration
- `version.txt`: Version tracking file (created automatically)

## Prerequisites

- Docker and Docker Compose installed
- Docker Hub account
- Git (optional)

## Setup

1. Edit the `build-and-push.sh` script to set your Docker Hub username:

   ```bash
   DOCKER_USERNAME="your-dockerhub-username"
   ```

2. Login to Docker Hub:
   ```bash
   docker login
   ```

## Building and Pushing Images

To build and push the Docker images to Docker Hub:

```bash
# On Linux/Mac
./build-and-push.sh

# On Windows (PowerShell)
.\build-and-push.sh
```

This script will:

1. Create or update the version file
2. Increment the version number
3. Build both backend and frontend images
4. Tag images with both `latest` and the version number
5. Push all images to Docker Hub

## Deploying the Application

To deploy the application using the Docker Hub images:

```bash
# On Linux/Mac
./deploy.sh

# On Windows (PowerShell)
.\deploy.sh
```

You can also specify a custom Docker Hub username and image tag:

```bash
# On Linux/Mac
DOCKER_USERNAME=myusername IMAGE_TAG=1.0.0 ./deploy.sh

# On Windows (PowerShell)
$env:DOCKER_USERNAME="myusername"; $env:IMAGE_TAG="1.0.0"; .\deploy.sh
```

## Accessing the Application

- Frontend: http://localhost:3000
- Backend API: http://localhost:8080
- MongoDB: localhost:27017

## Troubleshooting

### Docker Build Issues

If you encounter issues with the Docker build:

1. Make sure you have the correct Node.js version installed (Node 20 for Next.js 15.3)
2. Check that all required files are present in the project directories
3. For the frontend, ensure that the Next.js configuration is correct

### Deployment Issues

If you encounter issues with deployment:

1. Check that the Docker Hub images exist and are accessible
2. Verify that the version in version.txt matches an existing image tag
3. Check Docker logs for any errors:
   ```bash
   docker-compose logs
   ```
