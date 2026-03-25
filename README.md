# Enterprise Insight RAG v1.0

> A production-ready, cross-platform RAG chatbot with GraphRAG, CRAG, and multi-modal capabilities

## Overview

Enterprise Insight RAG is an advanced Retrieval-Augmented Generation (RAG) chatbot system designed for enterprise-grade document analysis and intelligent question answering. Built with a focus on security, scalability, and cutting-edge AI capabilities, this system operates on a custom, securely siloed organizational knowledge base.

## Key Features

- **GraphRAG** - Knowledge graph-based retrieval using Neo4j for complex reasoning and relationship mapping
- **CRAG (Corrective RAG)** - Self-correcting retrieval mechanism with evaluator agents for improved accuracy
- **Multi-Modal Document Ingestion** - Process PDFs, images, tables, and charts with intelligent parsing
- **Text-to-SQL** - Natural language to database query translation for quantitative analysis
- **Real-Time SSE Streaming** - Token-by-token response streaming for responsive user experience
- **JWT Authentication with RBAC** - Enterprise-grade security with role-based access control
- **Cross-Platform Mobile App** - Native iOS and Android applications built with React Native + Expo
- **100% Free & Open Source** - No vendor lock-in, complete transparency

## Technology Stack

### Frontend
![React Native](https://img.shields.io/badge/React_Native-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![Expo](https://img.shields.io/badge/Expo-000020?style=for-the-badge&logo=expo&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)
![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=next.js&logoColor=white)

### Backend
![Spring Boot](https://img.shields.io/badge/Spring_Boot-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)

### Data & AI
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Neo4j](https://img.shields.io/badge/Neo4j-008CC1?style=for-the-badge&logo=neo4j&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)

### DevOps
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)

## Getting Started

### Prerequisites

Before you begin, ensure you have all required tools installed on your system. Follow our comprehensive installation guide:

📖 **[Prerequisites Installation Guide](docs/PREREQUISITES_INSTALLATION.md)**

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/enterprise-insight-rag.git
   cd enterprise-insight-rag
   ```

2. **Follow the setup guide**
   
   📖 **[Setup Guide](docs/SETUP_GUIDE.md)**

3. **Start the services**
   ```bash
   # Start infrastructure
   docker-compose up -d
   
   # Start backend services
   cd java-auth-service && ./mvnw spring-boot:run
   cd python-ai-service && uvicorn app.main:app --reload
   
   # Start mobile app
   cd mobile-client && npm start
   ```

## Documentation

Comprehensive documentation is available in the `/docs` directory:

- 📋 **[Prerequisites Installation](docs/PREREQUISITES_INSTALLATION.md)** - Environment setup guide
- 📄 **[Product Requirements & SDLC](docs/PRD_AND_SDLC.md)** - Product vision and execution roadmap
- ⚙️ **[Setup Guide](docs/SETUP_GUIDE.md)** - Local development setup instructions
- 🔌 **[API Contracts](docs/API_CONTRACTS.md)** - REST API specifications (OpenAPI 3.0)
- 📚 **[Codebase Explanation](docs/CODEBASE_EXPLANATION.md)** - Living encyclopedia of code structure
- ✅ **[Task Tracker](docs/TASK_TRACKER.md)** - Kanban-style task management
- 🔄 **[Development Workflow](docs/DEV_WORKFLOW.md)** - GitFlow and development standards
- 🏗️ **[Architecture Decisions](docs/ARCHITECTURE_DECISIONS.md)** - ADR log for technical choices
- 🚀 **[Project Walkthrough](docs/PROJECT_WALKTHROUGH.md)** - High-level user journey narrative

## Project Status

✅ **Phase 1:** Project Initiation & Documentation Setup (Complete)  
🔄 **Phase 2:** DevOps & Infrastructure (In Progress)  
⏳ **Phase 3:** Authentication Service (Java)  
⏳ **Phase 4:** AI Service Foundation (Python)  
⏳ **Phase 5:** Advanced RAG Features  
⏳ **Phase 6:** Mobile & Web Frontend  
⏳ **Phase 7:** Testing, Optimization & Deployment  

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        User Devices                             │
│  ┌──────────────────┐              ┌──────────────────┐        │
│  │  Mobile App      │              │   Web App        │        │
│  │  (React Native)  │              │   (Next.js)      │        │
│  └────────┬─────────┘              └────────┬─────────┘        │
└───────────┼────────────────────────────────┼──────────────────┘
            │         HTTPS/JWT              │
            │                                │
┌───────────┼────────────────────────────────┼──────────────────┐
│           │         Backend Services       │                  │
│  ┌────────▼─────────┐          ┌──────────▼────────┐         │
│  │  Auth Service    │          │   AI Service      │         │
│  │  (Spring Boot)   │          │   (FastAPI)       │         │
│  │  - JWT/RBAC      │          │   - GraphRAG      │         │
│  └────────┬─────────┘          │   - CRAG          │         │
│           │                    │   - Text-to-SQL   │         │
│           │                    └──────────┬────────┘         │
└───────────┼───────────────────────────────┼──────────────────┘
            │         Database Layer        │
┌───────────┼───────────────────────────────┼──────────────────┐
│  ┌────────▼─────────┐  ┌────────────────▼────────┐         │
│  │   PostgreSQL     │  │   PostgreSQL             │         │
│  │   (Auth DB)      │  │   (AI DB + pgvector)     │         │
│  └──────────────────┘  └──────────────────────────┘         │
│                                                              │
│  ┌──────────────────┐          ┌──────────────────┐        │
│  │     Neo4j        │          │      Redis       │        │
│  │  (Knowledge      │          │   (Cache)        │        │
│  │   Graph)         │          │                  │        │
│  └──────────────────┘          └──────────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## Contributing

We welcome contributions! Please follow our development workflow and coding standards:

📖 **[Development Workflow Guide](docs/DEV_WORKFLOW.md)**

### Quick Contribution Guide

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes following our commit message format
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

For questions, issues, or feature requests, please:
- 📝 Open an issue on GitHub
- 📧 Contact the development team
- 📖 Check the documentation in `/docs`

## Acknowledgments

Built with ❤️ using 100% free and open-source technologies.

---

**Note:** This project follows Spec-Driven Development methodology with strict SDLC adherence for production-ready, enterprise-grade software.
