# DevOps Project

A full-stack application with Spring Boot backend and Next.js 15.3 frontend, containerized with Docker and deployed using Docker Compose.

## 🚀 Features

- Spring Boot backend with RESTful APIs
- Next.js 15.3 frontend with modern UI
- MongoDB database integration
- Docker containerization
- Automated build and deployment scripts
- Version tracking system

## 📁 Project Structure

```
.
├── backend/           # Spring Boot application
├── frontend/         # Next.js 15.3 application
├── build-and-push.sh # Script to build and push Docker images
├── deploy.sh         # Script to deploy the application
├── docker-compose.yml# Docker Compose configuration
└── version.txt       # Version tracking file
```

## ⚙️ Prerequisites

- Docker and Docker Compose
- Docker Hub account
- Git (optional)
- Node.js v20 (for local frontend development)
- Java 17+ (for local backend development)

## 🛠️ Local Development Setup

### Backend Setup

1. Navigate to the backend directory
2. Run the Spring Boot application:
   ```bash
   ./mvnw spring-boot:run
   ```

### Frontend Setup

1. Navigate to the frontend directory
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the development server:
   ```bash
   npm run dev
   ```

## 🐳 Docker Setup

1. Edit the `build-and-push.sh` script to set your Docker Hub username:

   ```bash
   DOCKER_USERNAME="your-dockerhub-username"
   ```

2. Login to Docker Hub:
   ```bash
   docker login
   ```

## 🏗️ Building and Pushing Images

To build and push the Docker images to Docker Hub:

```bash
# On Linux/Mac
./build-and-push.sh

# On Windows (PowerShell)
.\build-and-push.sh
```

The script will:

1. Create/update the version file
2. Increment the version number
3. Build both backend and frontend images
4. Tag images with `latest` and version number
5. Push all images to Docker Hub

## 🚀 Deployment

To deploy the application:

```bash
# On Linux/Mac
./deploy.sh

# On Windows (PowerShell)
.\deploy.sh
```

Custom deployment with specific username and tag:

```bash
# On Linux/Mac
DOCKER_USERNAME=myusername IMAGE_TAG=1.0.0 ./deploy.sh

# On Windows (PowerShell)
$env:DOCKER_USERNAME="myusername"; $env:IMAGE_TAG="1.0.0"; .\deploy.sh
```

## 🌐 Application Access

- Frontend: http://localhost:3000
- Backend API: http://localhost:8080
- MongoDB: localhost:27017
- API Documentation: http://localhost:8080/swagger-ui.html

## 🔍 Troubleshooting

### Docker Build Issues

1. Verify Node.js version (v20 required for Next.js 15.3)
2. Check for required files in project directories
3. Validate Next.js configuration
4. Ensure Docker daemon is running
5. Check available disk space

### Deployment Issues

1. Verify Docker Hub image accessibility
2. Check version.txt matches existing image tags
3. Inspect Docker logs:
   ```bash
   docker-compose logs
   ```
4. Check container status:
   ```bash
   docker-compose ps
   ```

### Common Issues

1. **Port Conflicts**

   - Ensure ports 3000, 8080, and 27017 are available
   - Check for running services on these ports

2. **Memory Issues**

   - Increase Docker memory limit if builds fail
   - Check system resources

3. **Network Issues**
   - Verify Docker network connectivity
   - Check firewall settings

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Support

For support, please open an issue in the repository or contact the maintainers.
