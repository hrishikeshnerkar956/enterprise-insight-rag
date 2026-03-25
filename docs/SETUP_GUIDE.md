# Setup Guide

## Table of Contents

- [Prerequisites Check](#prerequisites-check)
- [Repository Cloning](#repository-cloning)
- [Environment Variables Configuration](#environment-variables-configuration)
  - [Mobile Client Environment Variables](#mobile-client-environment-variables)
  - [Java Auth Service Environment Variables](#java-auth-service-environment-variables)
  - [Python AI Service Environment Variables](#python-ai-service-environment-variables)
- [Docker Compose Database Setup](#docker-compose-database-setup)
- [Mobile Client Setup](#mobile-client-setup)
- [Java Auth Service Setup](#java-auth-service-setup)
- [Python AI Service Setup](#python-ai-service-setup)
- [Running Services](#running-services)
- [Health Checks](#health-checks)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Prerequisites Check

Before setting up the project, ensure you have all required tools installed. If you haven't installed them yet, follow the [Prerequisites Installation Guide](PREREQUISITES_INSTALLATION.md).

Verify all tools are installed by running these commands:

```bash
# Check Node.js
node --version
# Expected: v18.x.x or higher

# Check Java
java --version
# Expected: openjdk 17.x.x or higher

# Check Python
python3 --version
# Expected: Python 3.10.x or higher

# Check Docker
docker --version
# Expected: Docker version 24.x.x or higher

# Check Docker Compose
docker compose version
# Expected: Docker Compose version v2.x.x or higher

# Check Git
git --version
# Expected: git version 2.x.x or higher
```

If any command fails, return to the [Prerequisites Installation Guide](PREREQUISITES_INSTALLATION.md) and install the missing tool.

## Repository Cloning

Clone the Enterprise Insight RAG repository to your local machine:

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/enterprise-insight-rag.git

# Navigate to the project directory
cd enterprise-insight-rag

# Verify you're on the develop branch
git branch
# You should see: * develop

# If not on develop, switch to it
git checkout develop
```

Verify the repository structure:

```bash
# List top-level directories
ls -la

# You should see:
# - mobile-client/
# - java-auth-service/
# - python-ai-service/
# - docs/
# - tests/
# - .gitignore
# - README.md
# - docker-compose.yml
```

## Environment Variables Configuration

Each service requires environment variables for configuration. Create `.env` files for each service based on the templates below.

**IMPORTANT:** Never commit `.env` files to Git. They are already included in `.gitignore`.

### Mobile Client Environment Variables

Create `mobile-client/.env`:

```bash
# Navigate to mobile-client directory
cd mobile-client

# Create .env file
touch .env
```

Add the following content to `mobile-client/.env`:

```env
# API Configuration
API_BASE_URL=http://localhost:8080
AI_SERVICE_URL=http://localhost:8000

# Authentication
JWT_SECRET_KEY=your-mobile-jwt-secret-key-change-in-production

# App Configuration
APP_NAME=Enterprise Insight RAG
APP_VERSION=1.0.0
ENVIRONMENT=development

# Feature Flags
ENABLE_BIOMETRIC_AUTH=true
ENABLE_OFFLINE_MODE=true
ENABLE_PUSH_NOTIFICATIONS=false

# Logging
LOG_LEVEL=debug
```

### Java Auth Service Environment Variables

Create `java-auth-service/.env`:

```bash
# Navigate to java-auth-service directory
cd ../java-auth-service

# Create .env file
touch .env
```

Add the following content to `java-auth-service/.env`:

```env
# Server Configuration
SERVER_PORT=8080
SPRING_PROFILES_ACTIVE=development

# Database Configuration
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/auth_db
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=postgres_password_change_in_production
SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.postgresql.Driver

# JPA/Hibernate Configuration
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_JPA_SHOW_SQL=true
SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT=org.hibernate.dialect.PostgreSQLDialect
SPRING_JPA_PROPERTIES_HIBERNATE_FORMAT_SQL=true

# JWT Configuration
JWT_SECRET=your-jwt-secret-key-at-least-256-bits-change-in-production
JWT_EXPIRATION_MS=3600000
JWT_REFRESH_EXPIRATION_MS=604800000

# CORS Configuration
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:19006
CORS_ALLOWED_METHODS=GET,POST,PUT,DELETE,OPTIONS
CORS_ALLOWED_HEADERS=*
CORS_ALLOW_CREDENTIALS=true

# Logging
LOGGING_LEVEL_ROOT=INFO
LOGGING_LEVEL_COM_ENTERPRISE_RAG=DEBUG
```

### Python AI Service Environment Variables

Create `python-ai-service/.env`:

```bash
# Navigate to python-ai-service directory
cd ../python-ai-service

# Create .env file
touch .env
```

Add the following content to `python-ai-service/.env`:

```env
# Server Configuration
HOST=0.0.0.0
PORT=8000
ENVIRONMENT=development

# Database Configuration - PostgreSQL with pgvector
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=ai_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres_password_change_in_production

# Neo4j Configuration
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=neo4j_password_change_in_production

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=redis_password_change_in_production
REDIS_DB=0

# LLM Configuration (OpenAI - Optional)
OPENAI_API_KEY=your-openai-api-key-or-leave-empty-for-local-models
OPENAI_MODEL=gpt-3.5-turbo
OPENAI_TEMPERATURE=0.7
OPENAI_MAX_TOKENS=2000

# Embedding Configuration
EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L6-v2
EMBEDDING_DIMENSION=384
CHUNK_SIZE=512
CHUNK_OVERLAP=50

# RAG Configuration
RETRIEVAL_TOP_K=5
RERANK_TOP_K=3
ENABLE_GRAPHRAG=true
ENABLE_CRAG=true

# Text-to-SQL Configuration
ENABLE_TEXT_TO_SQL=true
SQL_TIMEOUT_SECONDS=30

# SSE Streaming Configuration
SSE_HEARTBEAT_INTERVAL=30
SSE_MAX_CONNECTIONS=100

# Logging
LOG_LEVEL=DEBUG
LOG_FORMAT=json
```

## Docker Compose Database Setup

The project uses Docker Compose to run PostgreSQL, Neo4j, and Redis locally. This eliminates the need to install these databases directly on your machine.

**Note:** In Phase 1, the `docker-compose.yml` file contains only commented placeholders. It will be fully configured in Phase 2. For now, you can verify the file exists:

```bash
# Navigate to project root
cd ..

# Verify docker-compose.yml exists
ls -la docker-compose.yml
```

**Phase 2 Preview:** Once configured in Phase 2, you'll start all databases with:

```bash
# Start all infrastructure services
docker-compose up -d

# Verify services are running
docker-compose ps

# View logs
docker-compose logs -f
```

## Mobile Client Setup

The mobile client is built with React Native and Expo. Follow these steps to set up the development environment:

```bash
# Navigate to mobile-client directory
cd mobile-client

# Install dependencies
npm install

# Or if you prefer yarn
yarn install
```

**Verify installation:**

```bash
# Check for node_modules directory
ls -la node_modules

# Verify package.json exists
cat package.json
```

**Phase 6 Note:** The mobile client code will be implemented in Phase 6. For now, the directory structure is prepared.

## Java Auth Service Setup

The authentication service is built with Spring Boot and Maven. Follow these steps to set up the development environment:

```bash
# Navigate to java-auth-service directory
cd ../java-auth-service

# Install dependencies using Maven
./mvnw clean install

# Or on Windows
mvnw.cmd clean install

# Skip tests during initial setup (optional)
./mvnw clean install -DskipTests
```

**Verify installation:**

```bash
# Check for target directory
ls -la target

# Verify pom.xml exists
cat pom.xml
```

**Phase 3 Note:** The authentication service code will be implemented in Phase 3. For now, the directory structure is prepared.

## Python AI Service Setup

The AI service is built with FastAPI and Python. Follow these steps to set up the development environment:

```bash
# Navigate to python-ai-service directory
cd ../python-ai-service

# Create a virtual environment
python3 -m venv venv

# Activate the virtual environment
# On macOS/Linux:
source venv/bin/activate

# On Windows (Git Bash):
source venv/Scripts/activate

# On Windows (PowerShell):
.\venv\Scripts\Activate.ps1

# On Windows (CMD):
venv\Scripts\activate.bat

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

**Verify installation:**

```bash
# Check installed packages
pip list

# Verify virtual environment is active (you should see (venv) in your prompt)
which python
# Should point to venv/bin/python or venv\Scripts\python.exe
```

**Phase 4 Note:** The AI service code will be implemented in Phase 4. For now, the directory structure is prepared.

## Running Services

Once all services are set up (in later phases), you'll run them as follows:

### Running Infrastructure Services (Phase 2+)

```bash
# From project root
docker-compose up -d

# Verify services are running
docker-compose ps

# Expected output:
# - postgres (port 5432)
# - neo4j (ports 7474, 7687)
# - redis (port 6379)
```

### Running Java Auth Service (Phase 3+)

```bash
# From java-auth-service directory
./mvnw spring-boot:run

# Or on Windows
mvnw.cmd spring-boot:run

# Service will start on http://localhost:8080
```

### Running Python AI Service (Phase 4+)

```bash
# From python-ai-service directory
# Ensure virtual environment is activated
source venv/bin/activate  # or appropriate command for your OS

# Run with Uvicorn
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Service will start on http://localhost:8000
```

### Running Mobile Client (Phase 6+)

```bash
# From mobile-client directory
npm start

# Or with Expo CLI
npx expo start

# Options:
# - Press 'a' to open Android emulator
# - Press 'i' to open iOS simulator
# - Scan QR code with Expo Go app on physical device
```

## Health Checks

Once services are running (in later phases), verify they are healthy:

### Infrastructure Health Checks

```bash
# PostgreSQL
docker exec -it enterprise-rag-postgres psql -U postgres -c "SELECT version();"

# Neo4j (open browser)
open http://localhost:7474
# Login with username: neo4j, password: (from .env)

# Redis
docker exec -it enterprise-rag-redis redis-cli ping
# Expected: PONG
```

### Java Auth Service Health Check

```bash
# Check health endpoint
curl http://localhost:8080/actuator/health

# Expected response:
# {"status":"UP"}
```

### Python AI Service Health Check

```bash
# Check health endpoint
curl http://localhost:8000/health

# Expected response:
# {"status":"healthy","version":"1.0.0"}

# Check API documentation
open http://localhost:8000/docs
# Opens interactive Swagger UI
```

### Mobile Client Health Check

```bash
# Verify Expo dev server is running
curl http://localhost:19000

# Expected: HTML response from Expo dev server
```

## Troubleshooting

### Common Issues and Solutions

#### Issue: Port Already in Use

**Symptoms:**
- Error: "Port 8080 is already in use"
- Error: "Port 5432 is already in use"

**Solution:**

```bash
# Find process using the port (example: port 8080)
# On macOS/Linux:
lsof -i :8080

# On Windows:
netstat -ano | findstr :8080

# Kill the process
# On macOS/Linux:
kill -9 <PID>

# On Windows:
taskkill /PID <PID> /F

# Or change the port in .env file
```

#### Issue: Docker Containers Won't Start

**Symptoms:**
- Error: "Cannot connect to Docker daemon"
- Containers exit immediately

**Solution:**

```bash
# Ensure Docker Desktop is running (Windows/macOS)
# Or start Docker daemon (Linux)
sudo systemctl start docker

# Check Docker status
docker info

# Remove old containers and volumes
docker-compose down -v

# Rebuild and restart
docker-compose up -d --build
```

#### Issue: Database Connection Failed

**Symptoms:**
- Error: "Connection refused"
- Error: "Authentication failed"

**Solution:**

```bash
# Verify database is running
docker-compose ps

# Check database logs
docker-compose logs postgres
docker-compose logs neo4j
docker-compose logs redis

# Verify credentials in .env match docker-compose.yml
# Restart services
docker-compose restart
```

#### Issue: Maven Build Fails

**Symptoms:**
- Error: "Could not resolve dependencies"
- Error: "JAVA_HOME not set"

**Solution:**

```bash
# Verify Java version
java --version

# Set JAVA_HOME (if not set)
# On macOS/Linux:
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# On Windows:
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot"

# Clear Maven cache and rebuild
./mvnw clean install -U
```

#### Issue: Python Virtual Environment Issues

**Symptoms:**
- Error: "No module named 'fastapi'"
- Wrong Python version

**Solution:**

```bash
# Deactivate current environment
deactivate

# Remove old virtual environment
rm -rf venv

# Create new virtual environment with specific Python version
python3.10 -m venv venv

# Activate and reinstall
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

#### Issue: Node Modules Installation Fails

**Symptoms:**
- Error: "EACCES: permission denied"
- Error: "Unsupported platform"

**Solution:**

```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Reinstall with legacy peer deps (if needed)
npm install --legacy-peer-deps

# Or use yarn instead
yarn install
```

#### Issue: Expo Won't Start

**Symptoms:**
- Error: "Metro bundler failed to start"
- QR code doesn't appear

**Solution:**

```bash
# Clear Expo cache
npx expo start -c

# Or clear all caches
rm -rf node_modules .expo .expo-shared
npm install
npx expo start

# Ensure port 19000 is available
```

### Getting Help

If you encounter issues not covered here:

1. **Check service logs:**
   ```bash
   # Docker services
   docker-compose logs -f [service-name]
   
   # Java service
   tail -f java-auth-service/logs/application.log
   
   # Python service
   tail -f python-ai-service/logs/app.log
   ```

2. **Search error messages:** Copy the exact error message and search online

3. **Check official documentation:**
   - [Spring Boot Docs](https://spring.io/projects/spring-boot)
   - [FastAPI Docs](https://fastapi.tiangolo.com/)
   - [Expo Docs](https://docs.expo.dev/)
   - [Docker Docs](https://docs.docker.com/)

4. **Ask for help:**
   - Open an issue on the project repository
   - Contact the development team
   - Check the project's discussion forum

## Next Steps

Congratulations! You've set up the Enterprise Insight RAG development environment.

### Current Phase: Phase 1 (Documentation Setup)

In Phase 1, we're focused on documentation only. No code implementation yet.

**What you can do now:**
- Read through all documentation in the `/docs` folder
- Familiarize yourself with the project structure
- Review the [PRD and SDLC](PRD_AND_SDLC.md) to understand the 7-phase roadmap
- Study the [API Contracts](API_CONTRACTS.md) to understand the planned APIs
- Review [Architecture Decisions](ARCHITECTURE_DECISIONS.md) to understand technical choices

### Upcoming Phases

**Phase 2: DevOps & Infrastructure (Next)**
- Configure docker-compose.yml with all services
- Set up database schemas and migrations
- Create CI/CD pipeline with GitHub Actions

**Phase 3: Authentication Service**
- Implement JWT authentication
- Build user registration and login
- Set up RBAC

**Phase 4: AI Service Foundation**
- Implement document ingestion
- Build basic RAG query functionality
- Set up vector storage

**Phase 5: Advanced RAG Features**
- Implement GraphRAG with Neo4j
- Build CRAG self-correction
- Add text-to-SQL capability

**Phase 6: Mobile & Web Frontend**
- Build React Native mobile app
- Implement all user-facing screens
- Integrate with backend APIs

**Phase 7: Testing & Deployment**
- Comprehensive testing
- Performance optimization
- Production deployment

### Related Documentation

- [Prerequisites Installation](PREREQUISITES_INSTALLATION.md) - Tool installation guide
- [PRD and SDLC](PRD_AND_SDLC.md) - Product requirements and phases
- [API Contracts](API_CONTRACTS.md) - REST API specifications
- [Development Workflow](DEV_WORKFLOW.md) - GitFlow and coding standards
- [Codebase Explanation](CODEBASE_EXPLANATION.md) - Code structure guide
- [Task Tracker](TASK_TRACKER.md) - Project task management
- [Architecture Decisions](ARCHITECTURE_DECISIONS.md) - Technical decision log
- [Project Walkthrough](PROJECT_WALKTHROUGH.md) - High-level system overview

---

**Document Version:** 1.0.0  
**Last Updated:** Phase 1 - Project Initiation  
**Next Review:** Phase 2 - DevOps & Infrastructure

