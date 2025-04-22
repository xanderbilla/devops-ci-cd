# Event Management System - DevOps Demo

A modern event management platform demonstrating DevOps best practices, built with Spring Boot and Next.js 15, containerized with Docker, and deployed using Docker Swarm.

## 🎯 What's This Project About?

This project showcases how to build and deploy a modern web application using industry-standard DevOps practices. While the application itself is an event management system, the focus is on demonstrating:

- Containerization with Docker
- Orchestration using Docker Swarm
- CI/CD implementation with Jenkins
- Cloud deployment strategies
- Infrastructure as Code principles

## 🛠️ Tech Stack

### Application

- **Frontend**: Next.js 15, TypeScript, Tailwind CSS
- **Backend**: Spring Boot 3, MongoDB Atlas
- **Future**: AWS, Redis, WebSocket

### DevOps

- Docker & Docker Swarm
- Jenkins CI/CD
- Maven & GitHub Actions
- Infrastructure as Code (planned)

## 🚀 Quick Start

1. **Prerequisites**

   ```bash
   # Required tools
   - Docker & Docker Compose
   - Node.js v20
   - Java 17+
   - MongoDB Atlas account
   ```

2. **Local Development**

   ```bash
   # Backend
   cd backend && ./mvnw spring-boot:run

   # Frontend
   cd frontend && npm install && npm run dev
   ```

3. **Docker Deployment**
   ```bash
   # Build and deploy
   ./cleanup.sh
   ./build-and-push.sh
   ./deploy.sh
   ```

## 🔄 CI/CD Pipeline

Our Jenkins pipeline automates:

- Code testing and building
- Docker image creation
- Automated deployment
- Health monitoring
- Rolling updates

## 📈 What's Next?

We're working on:

- AWS cloud integration
- Redis caching
- Real-time features
- Advanced monitoring
- Infrastructure as code

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

[Vikas Singh](https://xanderbilla.com)
