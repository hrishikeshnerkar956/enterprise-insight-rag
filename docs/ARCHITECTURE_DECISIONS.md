# Architecture Decisions

## Table of Contents

- [Overview](#overview)
- [ADR Format](#adr-format)
- [ADR-001: React Native with Expo for Mobile Development](#adr-001-react-native-with-expo-for-mobile-development)
- [ADR-002: Spring Boot for Authentication Service](#adr-002-spring-boot-for-authentication-service)
- [ADR-003: FastAPI for AI Service](#adr-003-fastapi-for-ai-service)
- [ADR-004: PostgreSQL with pgvector for Vector Storage](#adr-004-postgresql-with-pgvector-for-vector-storage)
- [ADR-005: Neo4j for GraphRAG Knowledge Graphs](#adr-005-neo4j-for-graphrag-knowledge-graphs)
- [ADR-006: Monorepo Structure](#adr-006-monorepo-structure)
- [ADR-007: 100% Free and Open-Source Technologies](#adr-007-100-free-and-open-source-technologies)
- [How to Add New ADRs](#how-to-add-new-adrs)
- [Related Documentation](#related-documentation)

## Overview

This document records all significant architectural decisions made during the development of Enterprise Insight RAG v1.0. Each decision is documented using the Architecture Decision Record (ADR) format to provide context, rationale, and consequences.

**Purpose of ADRs:**
- Document why decisions were made, not just what was decided
- Provide historical context for future developers
- Enable informed decision-making when revisiting choices
- Create accountability for architectural choices

**When to Create an ADR:**
- Choosing a technology, framework, or library
- Deciding on system architecture or design patterns
- Selecting data storage or communication protocols
- Making trade-offs between competing approaches
- Establishing coding standards or conventions

## ADR Format

Each ADR follows this structure:

### Title
ADR-XXX: Brief descriptive title

### Status
- **Proposed**: Under consideration
- **Accepted**: Decision approved and implemented
- **Deprecated**: No longer recommended
- **Superseded**: Replaced by another ADR

### Context
What is the issue we're facing? What factors are influencing this decision?

### Decision
What did we decide to do? Be specific and actionable.

### Consequences
What are the positive and negative outcomes of this decision?

---

## ADR-001: React Native with Expo for Mobile Development

### Status
**Accepted** (Phase 1)

### Context

We need to build a cross-platform mobile application for iOS and Android. The app must:
- Provide native-like performance and user experience
- Support biometric authentication (Face ID, Touch ID, fingerprint)
- Handle real-time SSE streaming for AI responses
- Work offline with cached data
- Be maintainable by a solo developer or small team

**Options Considered:**

1. **Native Development (Swift + Kotlin)**
   - Pros: Best performance, full platform access
   - Cons: Requires two codebases, double development time, need expertise in both languages

2. **Flutter**
   - Pros: Good performance, single codebase, growing ecosystem
   - Cons: Dart language less common, smaller community than React

3. **React Native with Expo**
   - Pros: JavaScript/TypeScript, large ecosystem, Expo simplifies development, single codebase
   - Cons: Slightly lower performance than native, some platform limitations

### Decision

We will use **React Native with Expo** for mobile development.

**Rationale:**
- JavaScript/TypeScript is widely known, reducing learning curve
- React Native has mature ecosystem with extensive libraries
- Expo provides managed workflow with OTA updates, push notifications, and build services
- Single codebase for iOS and Android reduces development time by 50%
- Strong community support and documentation
- Proven track record in production apps (Discord, Shopify, Microsoft)

### Consequences

**Positive:**
- Faster development with single codebase
- Easier to find developers with React/JavaScript skills
- Expo simplifies complex tasks (push notifications, OTA updates)
- Hot reloading speeds up development
- Can eject to bare React Native if needed

**Negative:**
- Slightly lower performance than native (acceptable for our use case)
- Some platform-specific features require native modules
- Expo adds bundle size overhead
- Dependency on Expo's release cycle

**Mitigation:**
- Use Expo's bare workflow if we need more native control
- Profile performance regularly and optimize bottlenecks
- Keep Expo SDK updated to latest stable version

---

## ADR-002: Spring Boot for Authentication Service

### Status
**Accepted** (Phase 1)

### Context

We need a robust authentication service handling user management, JWT tokens, and RBAC. The service must:
- Provide enterprise-grade security
- Support JWT token generation and validation
- Implement role-based access control
- Integrate with PostgreSQL database
- Be production-ready and scalable

**Options Considered:**

1. **Node.js with Express**
   - Pros: JavaScript consistency with frontend, lightweight, fast development
   - Cons: Less mature security ecosystem, callback hell, weaker typing

2. **Python with Django**
   - Pros: Batteries-included, strong ORM, admin panel
   - Cons: Monolithic, slower than Java, less suitable for microservices

3. **Java with Spring Boot**
   - Pros: Enterprise-grade, Spring Security, strong typing, mature ecosystem
   - Cons: More verbose, longer startup time, steeper learning curve

### Decision

We will use **Spring Boot 3.1+ with Java 17** for the authentication service.

**Rationale:**
- Spring Security is industry-standard for authentication/authorization
- Strong typing with Java prevents many runtime errors
- Excellent support for JWT, OAuth2, and RBAC
- Spring Data JPA simplifies database operations
- Production-proven in enterprise environments
- Comprehensive testing support with Spring Boot Test
- Active community and extensive documentation

### Consequences

**Positive:**
- Enterprise-grade security out of the box
- Strong type safety reduces bugs
- Excellent tooling and IDE support
- Easy integration with PostgreSQL via Spring Data JPA
- Built-in health checks and metrics (Actuator)
- Mature ecosystem for testing and monitoring

**Negative:**
- More verbose than Node.js or Python
- Longer startup time (mitigated by Spring Native in future)
- Steeper learning curve for developers unfamiliar with Java
- Larger memory footprint

**Mitigation:**
- Use Lombok to reduce boilerplate code
- Leverage Spring Boot DevTools for faster development
- Provide comprehensive code examples and documentation
- Consider GraalVM native image for faster startup (Phase 7)

---

## ADR-003: FastAPI for AI Service

### Status
**Accepted** (Phase 1)

### Context

We need an AI service handling document ingestion, RAG queries, GraphRAG, CRAG, and text-to-SQL. The service must:
- Support async operations for concurrent requests
- Integrate with Python AI/ML libraries (LangChain, sentence-transformers)
- Provide SSE streaming for real-time responses
- Generate OpenAPI documentation automatically
- Be performant and scalable

**Options Considered:**

1. **Flask**
   - Pros: Simple, lightweight, mature
   - Cons: No async support, no automatic API docs, minimal features

2. **Django REST Framework**
   - Pros: Batteries-included, ORM, admin panel
   - Cons: Monolithic, slower, overkill for API-only service

3. **FastAPI**
   - Pros: Async support, automatic OpenAPI docs, fast, modern Python
   - Cons: Newer framework, smaller community than Flask/Django

### Decision

We will use **FastAPI 0.100+ with Python 3.10+** for the AI service.

**Rationale:**
- Native async/await support for concurrent RAG queries
- Automatic OpenAPI documentation generation
- Excellent performance (comparable to Node.js and Go)
- Type hints with Pydantic for request/response validation
- Perfect fit for Python AI/ML ecosystem (LangChain, transformers, etc.)
- Built-in SSE support for streaming responses
- Modern Python features (type hints, async)

### Consequences

**Positive:**
- Async operations handle concurrent users efficiently
- Automatic API documentation saves development time
- Type validation prevents many runtime errors
- Seamless integration with Python AI libraries
- Fast development with minimal boilerplate
- Excellent developer experience

**Negative:**
- Newer framework with smaller community than Flask
- Some developers may need to learn async/await
- Fewer third-party extensions than Django

**Mitigation:**
- Provide async/await training and examples
- Leverage FastAPI's excellent documentation
- Use well-tested libraries for critical functionality
- Monitor performance and optimize as needed

---

## ADR-004: PostgreSQL with pgvector for Vector Storage

### Status
**Accepted** (Phase 1)

### Context

We need a database for storing documents, embeddings, and user data. The database must:
- Support vector similarity search for RAG
- Provide ACID compliance for user data
- Scale to millions of embeddings
- Be reliable and production-ready
- Integrate with both Java and Python services

**Options Considered:**

1. **Dedicated Vector Databases (Pinecone, Weaviate, Milvus)**
   - Pros: Optimized for vectors, fast similarity search
   - Cons: Additional infrastructure, cost (Pinecone), learning curve

2. **Elasticsearch with Dense Vector**
   - Pros: Full-text search + vectors, mature
   - Cons: Complex setup, resource-intensive, eventual consistency

3. **PostgreSQL with pgvector**
   - Pros: Single database, ACID compliance, familiar SQL, free
   - Cons: Slower than dedicated vector DBs at massive scale

### Decision

We will use **PostgreSQL 16+ with pgvector extension** for vector storage.

**Rationale:**
- Single database for relational data and vectors simplifies architecture
- ACID compliance ensures data integrity
- pgvector provides efficient vector similarity search (HNSW index)
- No additional infrastructure or costs
- Familiar SQL interface for developers
- Excellent Python (psycopg2) and Java (JDBC) support
- Production-ready and battle-tested

### Consequences

**Positive:**
- Simplified architecture with single database
- No additional infrastructure to manage
- ACID transactions for data consistency
- Familiar SQL for queries and maintenance
- Cost-effective (no licensing fees)
- Easy backup and replication

**Negative:**
- Slower than dedicated vector databases at 10M+ vectors
- Requires pgvector extension installation
- Vector search performance depends on index tuning

**Mitigation:**
- Use HNSW index for fast approximate nearest neighbor search
- Monitor query performance and optimize indexes
- Consider sharding if we exceed 10M embeddings
- Evaluate dedicated vector DB if performance becomes bottleneck

---

## ADR-005: Neo4j for GraphRAG Knowledge Graphs

### Status
**Accepted** (Phase 1)

### Context

We need a graph database for GraphRAG to store entities and relationships extracted from documents. The database must:
- Support complex graph traversals
- Enable multi-hop reasoning
- Provide efficient relationship queries
- Scale to 100,000+ nodes
- Be free and open-source

**Options Considered:**

1. **PostgreSQL with Recursive CTEs**
   - Pros: Single database, familiar SQL
   - Cons: Poor performance for graph queries, complex queries

2. **ArangoDB**
   - Pros: Multi-model (graph + document), flexible
   - Cons: Smaller community, less mature than Neo4j

3. **Neo4j**
   - Pros: Purpose-built for graphs, Cypher query language, mature
   - Cons: Additional infrastructure, learning curve for Cypher

### Decision

We will use **Neo4j 5.15+ Community Edition** for GraphRAG knowledge graphs.

**Rationale:**
- Purpose-built for graph data with optimized storage and queries
- Cypher query language is intuitive and powerful
- Excellent performance for graph traversals and pattern matching
- APOC plugin provides advanced graph algorithms
- Strong Python driver (neo4j-driver)
- Community Edition is free and open-source
- Proven in production for knowledge graphs

### Consequences

**Positive:**
- Efficient graph traversals for multi-hop reasoning
- Cypher simplifies complex relationship queries
- APOC provides graph algorithms out of the box
- Excellent visualization tools for debugging
- Active community and documentation

**Negative:**
- Additional database to manage and monitor
- Learning curve for Cypher query language
- Requires separate backup strategy
- Memory-intensive for large graphs

**Mitigation:**
- Provide Cypher training and query examples
- Use Docker for simplified deployment
- Implement automated backups
- Monitor memory usage and tune configuration

---

## ADR-006: Monorepo Structure

### Status
**Accepted** (Phase 1)

### Context

We need to organize code for three services (mobile client, auth service, AI service) and documentation. We must decide between:
- Monorepo: Single repository for all services
- Polyrepo: Separate repository for each service

**Options Considered:**

1. **Polyrepo (Multiple Repositories)**
   - Pros: Independent versioning, smaller repos, clear ownership
   - Cons: Complex dependency management, harder to coordinate changes, fragmented documentation

2. **Monorepo (Single Repository)**
   - Pros: Atomic commits across services, simplified dependency management, unified documentation
   - Cons: Larger repository, potential for merge conflicts, requires discipline

### Decision

We will use a **monorepo structure** with all services in a single Git repository.

**Rationale:**
- Atomic commits spanning multiple services (e.g., API contract changes)
- Simplified dependency management and versioning
- Unified documentation in `/docs` directory
- Easier code sharing and refactoring
- Single CI/CD pipeline configuration
- Better for solo developer or small team
- Proven by Google, Facebook, Microsoft

### Consequences

**Positive:**
- Atomic commits ensure consistency across services
- Simplified dependency updates
- Single source of truth for documentation
- Easier to enforce coding standards
- Unified CI/CD pipeline
- Better code discoverability

**Negative:**
- Larger repository size
- Potential for merge conflicts in shared files
- Requires discipline to maintain structure
- All developers need access to all code

**Mitigation:**
- Use clear directory structure with service separation
- Implement code ownership with CODEOWNERS file
- Use branch protection and required reviews
- Document monorepo conventions in DEV_WORKFLOW.md

---

## ADR-007: 100% Free and Open-Source Technologies

### Status
**Accepted** (Phase 1)

### Context

We need to decide whether to use proprietary/paid technologies or restrict ourselves to free and open-source software (FOSS). Considerations:
- Cost constraints
- Vendor lock-in risks
- Community support
- Transparency and auditability
- Long-term sustainability

**Options Considered:**

1. **Mixed Approach (FOSS + Proprietary)**
   - Pros: Best-in-class tools, commercial support
   - Cons: Licensing costs, vendor lock-in, less transparency

2. **100% Free and Open-Source**
   - Pros: No costs, no vendor lock-in, full transparency, community-driven
   - Cons: May lack commercial support, need to evaluate maturity

### Decision

We will use **100% free and open-source technologies** for all components.

**Rationale:**
- Zero licensing costs enable deployment at any scale
- No vendor lock-in provides flexibility to switch technologies
- Full transparency allows security audits and customization
- Community-driven development ensures longevity
- Aligns with project goal of accessibility
- Proven FOSS alternatives exist for all requirements
- Enables contribution back to open-source community

### Consequences

**Positive:**
- No licensing fees regardless of scale
- Complete control over technology stack
- Can audit and modify source code
- No vendor lock-in or forced upgrades
- Community support and contributions
- Transparent security and privacy

**Negative:**
- No commercial support contracts (must rely on community)
- Need to evaluate maturity and stability ourselves
- May require more effort for some integrations
- Responsibility for security updates

**Mitigation:**
- Choose mature, widely-adopted FOSS projects
- Contribute to projects we depend on
- Maintain internal expertise for critical components
- Monitor security advisories and apply patches promptly
- Consider commercial support if needed in future

---

## How to Add New ADRs

When making a significant architectural decision:

1. **Create new ADR file:**
   - Assign next sequential number (ADR-008, ADR-009, etc.)
   - Use descriptive title

2. **Follow ADR format:**
   - Status: Proposed (initially)
   - Context: Explain the problem and constraints
   - Decision: State what was decided
   - Consequences: List positive and negative outcomes

3. **Update this document:**
   - Add new ADR to table of contents
   - Add full ADR section
   - Update "Last Updated" date

4. **Commit with PR:**
   - Include ADR in same PR as implementation
   - Request review from team
   - Update status to "Accepted" after approval

5. **Reference in code:**
   - Link to ADR in relevant code comments
   - Mention ADR number in commit messages

### Example Commit Message

```
feat(ai): implement caching layer (ADR-008)

Add Redis caching for frequently accessed embeddings
to improve query performance.

See ADR-008 for rationale and trade-offs.

Requirements: NFR-2 (Performance)
```

## Related Documentation

- [PRD and SDLC](PRD_AND_SDLC.md) - Technology stack and requirements
- [Project Walkthrough](PROJECT_WALKTHROUGH.md) - System architecture overview
- [Codebase Explanation](CODEBASE_EXPLANATION.md) - Implementation details
- [Development Workflow](DEV_WORKFLOW.md) - When to create ADRs

---

**Document Version:** 1.0.0  
**Last Updated:** Phase 1 - Project Initiation  
**Next Review:** Phase 2 - DevOps & Infrastructure  
**Maintainer:** Development Team

