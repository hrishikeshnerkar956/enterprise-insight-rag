# Codebase Explanation

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Mobile Client (`/mobile-client`)](#mobile-client-mobile-client)
- [Java Auth Service (`/java-auth-service`)](#java-auth-service-java-auth-service)
- [Python AI Service (`/python-ai-service`)](#python-ai-service-python-ai-service)
- [Documentation (`/docs`)](#documentation-docs)
- [Tests (`/tests`)](#tests-tests)
- [Root Configuration Files](#root-configuration-files)
- [Key Functions and Classes](#key-functions-and-classes)
- [How to Update This Document](#how-to-update-this-document)
- [Related Documentation](#related-documentation)

## Overview

This document serves as a living encyclopedia of the Enterprise Insight RAG v1.0 codebase. It explains the purpose of every directory, file, function, and class in the repository. As code is added through Phases 2-7, this document will be updated to reflect the changes.

**Current Phase:** Phase 1 - Project Initiation & Documentation Setup

**Code Status:** No implementation code exists yet. This phase focuses on documentation and repository structure only.

## Repository Structure

```
enterprise-insight-rag/
├── .git/                           # Git version control metadata
├── .gitignore                      # Git ignore patterns
├── .kiro/                          # Kiro IDE configuration
├── .qodo/                          # Qodo configuration
├── .vscode/                        # VS Code workspace settings
├── LICENSE                         # MIT License
├── README.md                       # Project overview and documentation hub
├── docker-compose.yml              # Infrastructure orchestration (Phase 2)
├── docs/                           # Documentation system (9 files)
│   ├── API_CONTRACTS.md
│   ├── ARCHITECTURE_DECISIONS.md
│   ├── CODEBASE_EXPLANATION.md (this file)
│   ├── DEV_WORKFLOW.md
│   ├── PREREQUISITES_INSTALLATION.md
│   ├── PRD_AND_SDLC.md
│   ├── PROJECT_WALKTHROUGH.md
│   ├── SETUP_GUIDE.md
│   └── TASK_TRACKER.md
├── mobile-client/                  # React Native + Expo frontend (Phase 6)
├── java-auth-service/              # Spring Boot authentication service (Phase 3)
├── python-ai-service/              # FastAPI RAG/AI service (Phases 4-5)
└── tests/                          # Validation and test scripts
```

## Mobile Client (`/mobile-client`)

**Purpose:** Cross-platform mobile application for iOS and Android built with React Native and Expo.

**Technology Stack:**
- React Native 0.72+
- Expo 49+
- TypeScript 5.0+
- React Navigation 6.0+
- Axios (HTTP client)
- React Query (server state)
- Zustand (client state)

**Implementation Phase:** Phase 6

**Current Status:** Directory structure prepared, no code implemented yet.

### Planned Directory Structure (Phase 6)

```
mobile-client/
├── app/                            # Expo Router app directory
│   ├── (auth)/                     # Authentication screens
│   │   ├── login.tsx
│   │   ├── register.tsx
│   │   └── forgot-password.tsx
│   ├── (tabs)/                     # Main app tabs
│   │   ├── home.tsx
│   │   ├── documents.tsx
│   │   ├── query.tsx
│   │   └── profile.tsx
│   ├── _layout.tsx                 # Root layout
│   └── index.tsx                   # Entry point
├── components/                     # Reusable UI components
│   ├── common/                     # Common components (Button, Input, etc.)
│   ├── documents/                  # Document-related components
│   ├── query/                      # Query-related components
│   └── auth/                       # Authentication components
├── hooks/                          # Custom React hooks
│   ├── useAuth.ts                  # Authentication hook
│   ├── useQuery.ts                 # Query hook
│   └── useDocuments.ts             # Documents hook
├── services/                       # API service layer
│   ├── api.ts                      # Axios instance configuration
│   ├── authService.ts              # Authentication API calls
│   └── aiService.ts                # AI service API calls
├── store/                          # Zustand state management
│   ├── authStore.ts                # Authentication state
│   ├── queryStore.ts               # Query state
│   └── documentsStore.ts           # Documents state
├── types/                          # TypeScript type definitions
│   ├── auth.ts
│   ├── documents.ts
│   └── query.ts
├── utils/                          # Utility functions
│   ├── validation.ts               # Input validation
│   ├── formatting.ts               # Data formatting
│   └── storage.ts                  # AsyncStorage helpers
├── constants/                      # App constants
│   ├── colors.ts
│   ├── config.ts
│   └── endpoints.ts
├── assets/                         # Static assets (images, fonts)
├── .env                            # Environment variables (not committed)
├── .env.example                    # Environment variables template
├── app.json                        # Expo configuration
├── package.json                    # Dependencies
├── tsconfig.json                   # TypeScript configuration
└── README.md                       # Mobile client documentation
```

### Key Components (Phase 6)

**To be documented when implemented in Phase 6.**

## Java Auth Service (`/java-auth-service`)

**Purpose:** Authentication and authorization service handling user management, JWT tokens, and RBAC.

**Technology Stack:**
- Java 17 LTS
- Spring Boot 3.1+
- Spring Security 6.1+
- Spring Data JPA 3.1+
- PostgreSQL JDBC 42.6+
- jjwt 0.11+ (JWT library)
- Lombok 1.18+
- Maven 3.9+

**Implementation Phase:** Phase 3

**Current Status:** Directory structure prepared, no code implemented yet.

### Planned Directory Structure (Phase 3)

```
java-auth-service/
├── src/
│   ├── main/
│   │   ├── java/com/enterprise/rag/auth/
│   │   │   ├── AuthServiceApplication.java    # Spring Boot main class
│   │   │   ├── config/                         # Configuration classes
│   │   │   │   ├── SecurityConfig.java         # Spring Security configuration
│   │   │   │   ├── JwtConfig.java              # JWT configuration
│   │   │   │   └── CorsConfig.java             # CORS configuration
│   │   │   ├── controller/                     # REST controllers
│   │   │   │   ├── AuthController.java         # Authentication endpoints
│   │   │   │   └── UserController.java         # User management endpoints
│   │   │   ├── service/                        # Business logic
│   │   │   │   ├── AuthService.java            # Authentication service
│   │   │   │   ├── UserService.java            # User service
│   │   │   │   └── JwtService.java             # JWT token service
│   │   │   ├── repository/                     # Data access layer
│   │   │   │   ├── UserRepository.java         # User repository
│   │   │   │   └── RoleRepository.java         # Role repository
│   │   │   ├── model/                          # Entity models
│   │   │   │   ├── User.java                   # User entity
│   │   │   │   ├── Role.java                   # Role entity
│   │   │   │   └── RefreshToken.java           # Refresh token entity
│   │   │   ├── dto/                            # Data transfer objects
│   │   │   │   ├── LoginRequest.java
│   │   │   │   ├── RegisterRequest.java
│   │   │   │   ├── AuthResponse.java
│   │   │   │   └── UserDto.java
│   │   │   ├── security/                       # Security components
│   │   │   │   ├── JwtAuthenticationFilter.java
│   │   │   │   ├── JwtAuthenticationEntryPoint.java
│   │   │   │   └── UserDetailsServiceImpl.java
│   │   │   ├── exception/                      # Exception handling
│   │   │   │   ├── GlobalExceptionHandler.java
│   │   │   │   ├── UserNotFoundException.java
│   │   │   │   └── InvalidTokenException.java
│   │   │   └── util/                           # Utility classes
│   │   │       ├── PasswordValidator.java
│   │   │       └── EmailValidator.java
│   │   └── resources/
│   │       ├── application.properties          # Application configuration
│   │       ├── application-dev.properties      # Development configuration
│   │       ├── application-prod.properties     # Production configuration
│   │       └── db/migration/                   # Flyway database migrations
│   │           ├── V1__create_users_table.sql
│   │           └── V2__create_roles_table.sql
│   └── test/
│       └── java/com/enterprise/rag/auth/
│           ├── controller/                     # Controller tests
│           ├── service/                        # Service tests
│           └── integration/                    # Integration tests
├── .env                                        # Environment variables (not committed)
├── .env.example                                # Environment variables template
├── pom.xml                                     # Maven dependencies
├── mvnw                                        # Maven wrapper (Unix)
├── mvnw.cmd                                    # Maven wrapper (Windows)
└── README.md                                   # Auth service documentation
```

### Key Classes (Phase 3)

**To be documented when implemented in Phase 3.**

## Python AI Service (`/python-ai-service`)

**Purpose:** AI service handling document ingestion, RAG queries, GraphRAG, CRAG, text-to-SQL, and SSE streaming.

**Technology Stack:**
- Python 3.10+
- FastAPI 0.100+
- Uvicorn 0.23+ (ASGI server)
- LangChain 0.0.300+ (LLM orchestration)
- pgvector 0.2+ (vector search)
- psycopg2 2.9+ (PostgreSQL)
- neo4j 5.12+ (graph database)
- redis 4.6+ (caching)
- PyPDF2 3.0+ (PDF parsing)
- pytesseract 0.3+ (OCR)
- sentence-transformers 2.2+ (embeddings)

**Implementation Phases:** Phase 4 (foundation), Phase 5 (advanced features)

**Current Status:** Directory structure prepared, no code implemented yet.

### Planned Directory Structure (Phases 4-5)

```
python-ai-service/
├── app/
│   ├── main.py                                 # FastAPI application entry point
│   ├── config.py                               # Configuration and environment variables
│   ├── api/                                    # API routes
│   │   ├── __init__.py
│   │   ├── v1/
│   │   │   ├── __init__.py
│   │   │   ├── ingest.py                       # Document ingestion endpoints
│   │   │   ├── query.py                        # RAG query endpoints
│   │   │   ├── stream.py                       # SSE streaming endpoints
│   │   │   └── text_to_sql.py                  # Text-to-SQL endpoints
│   │   └── dependencies.py                     # Dependency injection
│   ├── core/                                   # Core business logic
│   │   ├── __init__.py
│   │   ├── ingestion/
│   │   │   ├── __init__.py
│   │   │   ├── pdf_parser.py                   # PDF parsing
│   │   │   ├── image_parser.py                 # Image OCR
│   │   │   ├── text_chunker.py                 # Text chunking
│   │   │   └── embedding_generator.py          # Embedding generation
│   │   ├── retrieval/
│   │   │   ├── __init__.py
│   │   │   ├── vector_retriever.py             # Vector similarity search
│   │   │   ├── graph_retriever.py              # GraphRAG retrieval
│   │   │   ├── hybrid_retriever.py             # Hybrid retrieval
│   │   │   └── reranker.py                     # Result re-ranking
│   │   ├── generation/
│   │   │   ├── __init__.py
│   │   │   ├── llm_client.py                   # LLM client (OpenAI/local)
│   │   │   ├── prompt_builder.py               # Prompt construction
│   │   │   └── response_formatter.py           # Response formatting
│   │   ├── graphrag/
│   │   │   ├── __init__.py
│   │   │   ├── entity_extractor.py             # Entity extraction
│   │   │   ├── relationship_extractor.py       # Relationship extraction
│   │   │   ├── graph_builder.py                # Neo4j graph construction
│   │   │   └── graph_traverser.py              # Graph traversal
│   │   ├── crag/
│   │   │   ├── __init__.py
│   │   │   ├── evaluator.py                    # Retrieval quality evaluation
│   │   │   ├── corrector.py                    # Corrective retrieval
│   │   │   └── confidence_scorer.py            # Confidence scoring
│   │   └── text_to_sql/
│   │       ├── __init__.py
│   │       ├── sql_generator.py                # SQL generation
│   │       ├── sql_validator.py                # SQL validation
│   │       └── sql_executor.py                 # SQL execution
│   ├── db/                                     # Database connections
│   │   ├── __init__.py
│   │   ├── postgres.py                         # PostgreSQL connection
│   │   ├── neo4j.py                            # Neo4j connection
│   │   └── redis.py                            # Redis connection
│   ├── models/                                 # Pydantic models
│   │   ├── __init__.py
│   │   ├── ingest.py                           # Ingestion models
│   │   ├── query.py                            # Query models
│   │   └── text_to_sql.py                      # Text-to-SQL models
│   ├── schemas/                                # Database schemas
│   │   ├── __init__.py
│   │   ├── documents.py                        # Document schema
│   │   └── embeddings.py                       # Embedding schema
│   ├── utils/                                  # Utility functions
│   │   ├── __init__.py
│   │   ├── logger.py                           # Logging configuration
│   │   ├── validators.py                       # Input validation
│   │   └── helpers.py                          # Helper functions
│   └── middleware/                             # FastAPI middleware
│       ├── __init__.py
│       ├── auth.py                             # JWT authentication
│       ├── cors.py                             # CORS middleware
│       └── rate_limit.py                       # Rate limiting
├── tests/                                      # Test suite
│   ├── __init__.py
│   ├── unit/                                   # Unit tests
│   ├── integration/                            # Integration tests
│   └── conftest.py                             # Pytest configuration
├── alembic/                                    # Database migrations
│   ├── versions/
│   └── env.py
├── .env                                        # Environment variables (not committed)
├── .env.example                                # Environment variables template
├── requirements.txt                            # Python dependencies
├── pyproject.toml                              # Poetry configuration (optional)
├── Dockerfile                                  # Docker image definition
└── README.md                                   # AI service documentation
```

### Key Functions and Classes (Phases 4-5)

**To be documented when implemented in Phases 4-5.**

## Documentation (`/docs`)

**Purpose:** Comprehensive documentation system serving as the single source of truth for the project.

**Current Status:** All 9 documentation files completed in Phase 1.

### Documentation Files

| File | Purpose | Status |
|------|---------|--------|
| `PREREQUISITES_INSTALLATION.md` | Environment setup guide | ✅ Complete |
| `PRD_AND_SDLC.md` | Product requirements and execution roadmap | ✅ Complete |
| `SETUP_GUIDE.md` | Local development setup instructions | ✅ Complete |
| `API_CONTRACTS.md` | REST API specifications (OpenAPI 3.0) | ✅ Complete |
| `CODEBASE_EXPLANATION.md` | Living encyclopedia of code structure (this file) | ✅ Complete |
| `TASK_TRACKER.md` | Kanban-style task management | 🔄 In Progress |
| `DEV_WORKFLOW.md` | GitFlow and development standards | 🔄 In Progress |
| `ARCHITECTURE_DECISIONS.md` | ADR log for technical choices | 🔄 In Progress |
| `PROJECT_WALKTHROUGH.md` | High-level user journey narrative | 🔄 In Progress |

### Documentation Cross-References

The documentation system uses markdown links to create a web of interconnected knowledge:

- `README.md` → Links to all 9 documentation files
- `PREREQUISITES_INSTALLATION.md` → Links to `SETUP_GUIDE.md`
- `SETUP_GUIDE.md` → Links to `PREREQUISITES_INSTALLATION.md`, `API_CONTRACTS.md`
- `PRD_AND_SDLC.md` → Links to `API_CONTRACTS.md`, `ARCHITECTURE_DECISIONS.md`
- `API_CONTRACTS.md` → Links to `SETUP_GUIDE.md`
- `DEV_WORKFLOW.md` → Links to `TASK_TRACKER.md`, `ARCHITECTURE_DECISIONS.md`
- `ARCHITECTURE_DECISIONS.md` → Links to `PRD_AND_SDLC.md`, `PROJECT_WALKTHROUGH.md`
- `PROJECT_WALKTHROUGH.md` → Links to `ARCHITECTURE_DECISIONS.md`, `API_CONTRACTS.md`

## Tests (`/tests`)

**Purpose:** Validation scripts and test suites for ensuring project quality.

**Implementation Phase:** Phase 1 (validation tests), Phases 2-7 (unit/integration tests)

**Current Status:** Directory structure prepared, validation tests to be added.

### Planned Test Structure

```
tests/
├── phase1-validation/                          # Phase 1 validation tests
│   ├── file-existence.bats                     # File existence tests
│   ├── content-validation.bats                 # Content validation tests
│   ├── git-repository.bats                     # Git repository tests
│   ├── cross-reference.bats                    # Cross-reference tests
│   └── helpers.bash                            # Shared test utilities
├── unit/                                       # Unit tests (Phases 3-6)
│   ├── auth-service/                           # Java auth service tests
│   ├── ai-service/                             # Python AI service tests
│   └── mobile-client/                          # React Native tests
├── integration/                                # Integration tests (Phases 3-6)
│   ├── api/                                    # API integration tests
│   └── e2e/                                    # End-to-end tests
└── scripts/                                    # Test utility scripts
    ├── validate-phase1.sh                      # Phase 1 validation script
    ├── validate-links.sh                       # Link validation script
    └── count-lines.sh                          # Line counting script
```

## Root Configuration Files

### `.gitignore`

**Purpose:** Specifies files and directories that Git should ignore.

**Key Patterns:**
- Node.js: `node_modules/`, `npm-debug.log*`
- Python: `__pycache__/`, `*.py[cod]`, `venv/`
- Java: `target/`, `*.class`, `*.jar`
- IDEs: `.vscode/`, `.idea/`, `*.swp`
- Environment: `.env`, `.env.local`
- Documentation security: `docs/**/INTERNAL_*.md`, `docs/**/*.draft.md`

### `README.md`

**Purpose:** Project overview and documentation hub.

**Contents:**
- Project title and tagline
- Key features overview
- Technology stack with badges
- Getting started instructions
- Links to all 9 documentation files
- Project status (7 phases)
- Architecture diagram
- License and contributing information

### `docker-compose.yml`

**Purpose:** Infrastructure orchestration for local development.

**Current Status:** Placeholder with commented service definitions (Phase 1).

**Phase 2 Implementation:** Will include:
- PostgreSQL with pgvector extension
- Neo4j with APOC plugin
- Redis for caching
- Volume definitions for data persistence
- Network configuration for service communication

### `LICENSE`

**Purpose:** MIT License for open-source distribution.

**Status:** Added from GitHub during repository initialization.

## Key Functions and Classes

**Note:** This section will be populated as code is implemented in Phases 2-7. Each function and class will be documented with:

- Purpose and responsibility
- Input parameters and return values
- Usage examples
- Related functions/classes
- Phase implemented

### Example Entry (Template for Future Updates)

**Function:** `generateEmbedding(text: string): Promise<number[]>`

**Location:** `python-ai-service/app/core/ingestion/embedding_generator.py`

**Purpose:** Generates vector embeddings for text using sentence-transformers.

**Parameters:**
- `text` (string): Input text to embed

**Returns:**
- `Promise<number[]>`: 384-dimensional embedding vector

**Implementation Phase:** Phase 4

**Usage Example:**

```python
from app.core.ingestion.embedding_generator import generate_embedding

text = "Enterprise Insight RAG is a production-ready chatbot"
embedding = await generate_embedding(text)
# Returns: [0.123, -0.456, 0.789, ...]
```

**Related Functions:**
- `chunk_text()`: Splits text before embedding
- `store_embedding()`: Stores embedding in PostgreSQL

## How to Update This Document

This document must be updated whenever code is added, modified, or removed from the repository. Follow these guidelines:

### When to Update

1. **New Directory Created:** Add directory to repository structure and create dedicated section
2. **New File Created:** Document file purpose, location, and key exports
3. **New Function/Class Added:** Add entry to "Key Functions and Classes" section
4. **Function/Class Modified:** Update existing entry with changes
5. **File/Function Deleted:** Remove or mark as deprecated

### Update Process

1. Make code changes in your feature branch
2. Update `CODEBASE_EXPLANATION.md` in the same commit
3. Ensure documentation accurately reflects code changes
4. Include documentation update in pull request
5. Code review should verify documentation accuracy

### Documentation Standards

- Use clear, concise language
- Include code examples for complex functions
- Link to related documentation files
- Maintain consistent formatting
- Update table of contents when adding sections

### Example Commit Message

```
feat: add PDF parsing functionality (Phase 4)

- Implement pdf_parser.py with extract_text() function
- Add PyPDF2 dependency
- Update CODEBASE_EXPLANATION.md with new function documentation

Requirements: FR-3 (Multi-Modal Document Ingestion)
```

## Related Documentation

- [PRD and SDLC](PRD_AND_SDLC.md) - Product requirements and phases
- [API Contracts](API_CONTRACTS.md) - REST API specifications
- [Setup Guide](SETUP_GUIDE.md) - Local development setup
- [Development Workflow](DEV_WORKFLOW.md) - Coding standards and Git workflow
- [Architecture Decisions](ARCHITECTURE_DECISIONS.md) - Technical decision log
- [Task Tracker](TASK_TRACKER.md) - Implementation task management

---

**Document Version:** 1.0.0  
**Last Updated:** Phase 1 - Project Initiation  
**Next Review:** Phase 2 - DevOps & Infrastructure  
**Maintainer:** Development Team

