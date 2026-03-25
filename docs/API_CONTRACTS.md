# API Contracts

## Table of Contents

- [Overview](#overview)
- [Authentication Service API](#authentication-service-api)
  - [POST /api/auth/register](#post-apiauthregister)
  - [POST /api/auth/login](#post-apiauthlogin)
  - [POST /api/auth/refresh](#post-apiauthrefresh)
  - [GET /api/auth/profile](#get-apiauthprofile)
- [AI Service API](#ai-service-api)
  - [POST /api/ai/ingest](#post-apiaiingest)
  - [POST /api/ai/query](#post-apiaiquery)
  - [GET /api/ai/stream](#get-apiaistream)
  - [POST /api/ai/text-to-sql](#post-apiaitext-to-sql)
- [Authentication Requirements](#authentication-requirements)
- [RBAC Permission Requirements](#rbac-permission-requirements)
- [Error Responses](#error-responses)
- [Related Documentation](#related-documentation)

## Overview

This document specifies the REST API contracts for the Enterprise Insight RAG v1.0 system. All APIs follow OpenAPI 3.0 specification format and use JSON for request/response payloads.

**Base URLs:**
- Authentication Service: `http://localhost:8080` (development)
- AI Service: `http://localhost:8000` (development)

**Common Headers:**
- `Content-Type: application/json`
- `Authorization: Bearer <JWT_TOKEN>` (for protected endpoints)

**API Versioning:**
- All endpoints are prefixed with `/api` for consistency
- Future versions will use `/api/v2`, `/api/v3`, etc.

## Authentication Service API

The Authentication Service handles user registration, login, token management, and user profile operations.

### POST /api/auth/register

Register a new user account.

**Endpoint:** `POST /api/auth/register`

**Authentication:** None (public endpoint)

**Request Schema:**

```json
{
  "email": "string (required, valid email format)",
  "password": "string (required, min 8 characters)",
  "firstName": "string (required, max 50 characters)",
  "lastName": "string (required, max 50 characters)",
  "role": "string (optional, default: USER, enum: [USER, ADMIN, VIEWER])"
}
```

**Request Example:**

```json
{
  "email": "john.doe@example.com",
  "password": "SecureP@ssw0rd",
  "firstName": "John",
  "lastName": "Doe",
  "role": "USER"
}
```

**Response Schema (201 Created):**

```json
{
  "id": "string (UUID)",
  "email": "string",
  "firstName": "string",
  "lastName": "string",
  "role": "string",
  "createdAt": "string (ISO 8601 datetime)",
  "message": "string"
}
```

**Response Example (201 Created):**

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "john.doe@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "role": "USER",
  "createdAt": "2026-03-25T10:30:00Z",
  "message": "User registered successfully"
}
```

**Error Responses:**

- `400 Bad Request`: Invalid input (missing fields, invalid email, weak password)
- `409 Conflict`: Email already exists
- `500 Internal Server Error`: Server error

**Validation Rules:**
- Email must be valid format and unique
- Password must be at least 8 characters with uppercase, lowercase, number, and special character
- First name and last name are required and max 50 characters
- Role defaults to USER if not specified

---

### POST /api/auth/login

Authenticate user and receive JWT tokens.

**Endpoint:** `POST /api/auth/login`

**Authentication:** None (public endpoint)

**Request Schema:**

```json
{
  "email": "string (required, valid email format)",
  "password": "string (required)"
}
```

**Request Example:**

```json
{
  "email": "john.doe@example.com",
  "password": "SecureP@ssw0rd"
}
```

**Response Schema (200 OK):**

```json
{
  "accessToken": "string (JWT token)",
  "refreshToken": "string (JWT token)",
  "tokenType": "string (always 'Bearer')",
  "expiresIn": "number (seconds until access token expires)",
  "user": {
    "id": "string (UUID)",
    "email": "string",
    "firstName": "string",
    "lastName": "string",
    "role": "string"
  }
}
```

**Response Example (200 OK):**

```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "expiresIn": 3600,
  "user": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "email": "john.doe@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "USER"
  }
}
```

**Error Responses:**

- `400 Bad Request`: Invalid input (missing fields)
- `401 Unauthorized`: Invalid credentials
- `500 Internal Server Error`: Server error

**Token Details:**
- Access token expires in 1 hour (3600 seconds)
- Refresh token expires in 7 days (604800 seconds)
- Tokens are signed with HS256 algorithm

---

### POST /api/auth/refresh

Refresh access token using refresh token.

**Endpoint:** `POST /api/auth/refresh`

**Authentication:** None (uses refresh token in request body)

**Request Schema:**

```json
{
  "refreshToken": "string (required, valid JWT refresh token)"
}
```

**Request Example:**

```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response Schema (200 OK):**

```json
{
  "accessToken": "string (new JWT access token)",
  "refreshToken": "string (new JWT refresh token)",
  "tokenType": "string (always 'Bearer')",
  "expiresIn": "number (seconds until access token expires)"
}
```

**Response Example (200 OK):**

```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "expiresIn": 3600
}
```

**Error Responses:**

- `400 Bad Request`: Missing refresh token
- `401 Unauthorized`: Invalid or expired refresh token
- `500 Internal Server Error`: Server error

---

### GET /api/auth/profile

Get authenticated user's profile information.

**Endpoint:** `GET /api/auth/profile`

**Authentication:** Required (JWT access token)

**RBAC:** All authenticated users (USER, ADMIN, VIEWER)

**Request Headers:**

```
Authorization: Bearer <ACCESS_TOKEN>
```

**Response Schema (200 OK):**

```json
{
  "id": "string (UUID)",
  "email": "string",
  "firstName": "string",
  "lastName": "string",
  "role": "string",
  "createdAt": "string (ISO 8601 datetime)",
  "updatedAt": "string (ISO 8601 datetime)"
}
```

**Response Example (200 OK):**

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "email": "john.doe@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "role": "USER",
  "createdAt": "2026-03-25T10:30:00Z",
  "updatedAt": "2026-03-25T10:30:00Z"
}
```

**Error Responses:**

- `401 Unauthorized`: Missing or invalid access token
- `404 Not Found`: User not found
- `500 Internal Server Error`: Server error

---

## AI Service API

The AI Service handles document ingestion, RAG queries, streaming responses, and text-to-SQL operations.

### POST /api/ai/ingest

Ingest and process documents for RAG retrieval.

**Endpoint:** `POST /api/ai/ingest`

**Authentication:** Required (JWT access token)

**RBAC:** USER, ADMIN (VIEWER cannot ingest)

**Request Headers:**

```
Authorization: Bearer <ACCESS_TOKEN>
Content-Type: multipart/form-data
```

**Request Schema (multipart/form-data):**

```
file: binary (required, PDF/image/text file)
title: string (optional, document title)
tags: string (optional, comma-separated tags)
category: string (optional, document category)
```

**Request Example (cURL):**

```bash
curl -X POST http://localhost:8000/api/ai/ingest \
  -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -F "file=@document.pdf" \
  -F "title=Q4 Financial Report" \
  -F "tags=finance,quarterly,2026" \
  -F "category=reports"
```

**Response Schema (201 Created):**

```json
{
  "documentId": "string (UUID)",
  "title": "string",
  "fileName": "string",
  "fileSize": "number (bytes)",
  "mimeType": "string",
  "status": "string (enum: processing, completed, failed)",
  "chunksCreated": "number",
  "embeddingsCreated": "number",
  "graphNodesCreated": "number (if GraphRAG enabled)",
  "processingTime": "number (milliseconds)",
  "createdAt": "string (ISO 8601 datetime)",
  "message": "string"
}
```

**Response Example (201 Created):**

```json
{
  "documentId": "660e8400-e29b-41d4-a716-446655440001",
  "title": "Q4 Financial Report",
  "fileName": "document.pdf",
  "fileSize": 2048576,
  "mimeType": "application/pdf",
  "status": "completed",
  "chunksCreated": 45,
  "embeddingsCreated": 45,
  "graphNodesCreated": 12,
  "processingTime": 3450,
  "createdAt": "2026-03-25T11:00:00Z",
  "message": "Document ingested successfully"
}
```

**Error Responses:**

- `400 Bad Request`: Invalid file type or missing file
- `401 Unauthorized`: Missing or invalid access token
- `403 Forbidden`: Insufficient permissions (VIEWER role)
- `413 Payload Too Large`: File exceeds size limit (50MB)
- `500 Internal Server Error`: Processing error

**Supported File Types:**
- PDF: `.pdf`
- Images: `.jpg`, `.jpeg`, `.png`, `.gif` (OCR applied)
- Text: `.txt`, `.md`, `.csv`

---

### POST /api/ai/query

Query the RAG system with natural language.

**Endpoint:** `POST /api/ai/query`

**Authentication:** Required (JWT access token)

**RBAC:** All authenticated users (USER, ADMIN, VIEWER)

**Request Headers:**

```
Authorization: Bearer <ACCESS_TOKEN>
Content-Type: application/json
```

**Request Schema:**

```json
{
  "query": "string (required, user question)",
  "retrievalMode": "string (optional, enum: [vector, graph, hybrid], default: hybrid)",
  "topK": "number (optional, number of documents to retrieve, default: 5)",
  "enableCRAG": "boolean (optional, enable corrective RAG, default: true)",
  "temperature": "number (optional, LLM temperature 0-1, default: 0.7)",
  "maxTokens": "number (optional, max response tokens, default: 2000)"
}
```

**Request Example:**

```json
{
  "query": "What were the key financial highlights in Q4 2026?",
  "retrievalMode": "hybrid",
  "topK": 5,
  "enableCRAG": true,
  "temperature": 0.7,
  "maxTokens": 2000
}
```

**Response Schema (200 OK):**

```json
{
  "queryId": "string (UUID)",
  "query": "string",
  "answer": "string (generated response)",
  "sources": [
    {
      "documentId": "string (UUID)",
      "title": "string",
      "chunk": "string (relevant text chunk)",
      "score": "number (relevance score 0-1)",
      "page": "number (optional, page number)"
    }
  ],
  "retrievalMode": "string",
  "retrievalTime": "number (milliseconds)",
  "generationTime": "number (milliseconds)",
  "totalTime": "number (milliseconds)",
  "confidenceScore": "number (0-1, CRAG confidence)",
  "correctionApplied": "boolean (whether CRAG correction was triggered)",
  "createdAt": "string (ISO 8601 datetime)"
}
```

**Response Example (200 OK):**

```json
{
  "queryId": "770e8400-e29b-41d4-a716-446655440002",
  "query": "What were the key financial highlights in Q4 2026?",
  "answer": "The key financial highlights for Q4 2026 include: 1) Revenue increased by 15% to $50M, 2) Net profit margin improved to 22%, 3) Customer acquisition cost decreased by 10%, and 4) Annual recurring revenue reached $180M.",
  "sources": [
    {
      "documentId": "660e8400-e29b-41d4-a716-446655440001",
      "title": "Q4 Financial Report",
      "chunk": "Q4 2026 revenue reached $50M, representing a 15% increase...",
      "score": 0.92,
      "page": 3
    }
  ],
  "retrievalMode": "hybrid",
  "retrievalTime": 245,
  "generationTime": 1850,
  "totalTime": 2095,
  "confidenceScore": 0.89,
  "correctionApplied": false,
  "createdAt": "2026-03-25T11:15:00Z"
}
```

**Error Responses:**

- `400 Bad Request`: Invalid input (empty query, invalid parameters)
- `401 Unauthorized`: Missing or invalid access token
- `500 Internal Server Error`: Query processing error

---

### GET /api/ai/stream

Stream RAG query responses token-by-token using Server-Sent Events (SSE).

**Endpoint:** `GET /api/ai/stream`

**Authentication:** Required (JWT access token)

**RBAC:** All authenticated users (USER, ADMIN, VIEWER)

**Request Headers:**

```
Authorization: Bearer <ACCESS_TOKEN>
Accept: text/event-stream
```

**Query Parameters:**

```
query: string (required, URL-encoded user question)
retrievalMode: string (optional, enum: [vector, graph, hybrid], default: hybrid)
topK: number (optional, default: 5)
enableCRAG: boolean (optional, default: true)
temperature: number (optional, default: 0.7)
maxTokens: number (optional, default: 2000)
```

**Request Example:**

```bash
curl -N -H "Authorization: Bearer <ACCESS_TOKEN>" \
  -H "Accept: text/event-stream" \
  "http://localhost:8000/api/ai/stream?query=What%20were%20the%20key%20financial%20highlights%20in%20Q4%202026?"
```

**SSE Event Stream Format:**

```
event: start
data: {"queryId":"770e8400-e29b-41d4-a716-446655440002","status":"started"}

event: retrieval
data: {"status":"retrieving","documentsFound":5}

event: token
data: {"token":"The"}

event: token
data: {"token":" key"}

event: token
data: {"token":" financial"}

...

event: sources
data: {"sources":[{"documentId":"660e8400...","title":"Q4 Financial Report","score":0.92}]}

event: end
data: {"status":"completed","totalTokens":87,"totalTime":2150}
```

**SSE Event Types:**

- `start`: Query processing started
- `retrieval`: Document retrieval in progress
- `token`: Individual token from LLM response
- `sources`: Retrieved source documents
- `end`: Query processing completed
- `error`: Error occurred during processing

**Error Event Example:**

```
event: error
data: {"error":"Retrieval failed","message":"Database connection timeout"}
```

**Connection Management:**

- Client should reconnect on connection loss
- Server sends heartbeat every 30 seconds to keep connection alive
- Maximum connection duration: 5 minutes
- Maximum concurrent connections per user: 3

---

### POST /api/ai/text-to-sql

Convert natural language to SQL query and execute.

**Endpoint:** `POST /api/ai/text-to-sql`

**Authentication:** Required (JWT access token)

**RBAC:** USER, ADMIN (VIEWER has read-only SQL access)

**Request Headers:**

```
Authorization: Bearer <ACCESS_TOKEN>
Content-Type: application/json
```

**Request Schema:**

```json
{
  "query": "string (required, natural language question)",
  "database": "string (optional, target database name, default: ai_db)",
  "dryRun": "boolean (optional, validate SQL without executing, default: false)"
}
```

**Request Example:**

```json
{
  "query": "Show me the top 5 customers by revenue in 2026",
  "database": "ai_db",
  "dryRun": false
}
```

**Response Schema (200 OK):**

```json
{
  "queryId": "string (UUID)",
  "naturalLanguageQuery": "string",
  "generatedSQL": "string (SQL query)",
  "sqlValid": "boolean",
  "executed": "boolean",
  "results": [
    {
      "column1": "value1",
      "column2": "value2"
    }
  ],
  "rowCount": "number",
  "executionTime": "number (milliseconds)",
  "explanation": "string (human-readable explanation of results)",
  "createdAt": "string (ISO 8601 datetime)"
}
```

**Response Example (200 OK):**

```json
{
  "queryId": "880e8400-e29b-41d4-a716-446655440003",
  "naturalLanguageQuery": "Show me the top 5 customers by revenue in 2026",
  "generatedSQL": "SELECT customer_name, SUM(revenue) as total_revenue FROM sales WHERE EXTRACT(YEAR FROM sale_date) = 2026 GROUP BY customer_name ORDER BY total_revenue DESC LIMIT 5;",
  "sqlValid": true,
  "executed": true,
  "results": [
    {
      "customer_name": "Acme Corp",
      "total_revenue": 1250000
    },
    {
      "customer_name": "TechStart Inc",
      "total_revenue": 980000
    }
  ],
  "rowCount": 5,
  "executionTime": 145,
  "explanation": "The top 5 customers by revenue in 2026 are Acme Corp ($1.25M), TechStart Inc ($980K), ...",
  "createdAt": "2026-03-25T11:30:00Z"
}
```

**Error Responses:**

- `400 Bad Request`: Invalid query or SQL generation failed
- `401 Unauthorized`: Missing or invalid access token
- `403 Forbidden`: Insufficient permissions for write operations (VIEWER role)
- `500 Internal Server Error`: SQL execution error

**Safety Features:**

- Only SELECT queries allowed for VIEWER role
- INSERT, UPDATE, DELETE require USER or ADMIN role
- DROP, TRUNCATE, ALTER blocked for all users
- Query timeout: 30 seconds
- Result set limited to 1000 rows

---

## Authentication Requirements

### JWT Token Format

All protected endpoints require a JWT access token in the Authorization header:

```
Authorization: Bearer <ACCESS_TOKEN>
```

**Token Structure:**

```json
{
  "sub": "550e8400-e29b-41d4-a716-446655440000",
  "email": "john.doe@example.com",
  "role": "USER",
  "iat": 1711360200,
  "exp": 1711363800
}
```

**Token Claims:**

- `sub`: User ID (UUID)
- `email`: User email address
- `role`: User role (USER, ADMIN, VIEWER)
- `iat`: Issued at timestamp
- `exp`: Expiration timestamp

### Token Lifecycle

1. **Obtain tokens:** Call `/api/auth/login` with credentials
2. **Use access token:** Include in Authorization header for protected endpoints
3. **Refresh when expired:** Call `/api/auth/refresh` with refresh token
4. **Re-authenticate:** If refresh token expires, call `/api/auth/login` again

## RBAC Permission Requirements

### Role Definitions

| Role | Description | Permissions |
|------|-------------|-------------|
| ADMIN | Full system access | All operations including user management |
| USER | Standard user | Document upload, query, personal data management |
| VIEWER | Read-only access | Query documents, view shared content (no upload/delete) |

### Endpoint Permissions

| Endpoint | ADMIN | USER | VIEWER |
|----------|-------|------|--------|
| POST /api/auth/register | ✅ | ✅ | ✅ |
| POST /api/auth/login | ✅ | ✅ | ✅ |
| POST /api/auth/refresh | ✅ | ✅ | ✅ |
| GET /api/auth/profile | ✅ | ✅ | ✅ |
| POST /api/ai/ingest | ✅ | ✅ | ❌ |
| POST /api/ai/query | ✅ | ✅ | ✅ |
| GET /api/ai/stream | ✅ | ✅ | ✅ |
| POST /api/ai/text-to-sql (SELECT) | ✅ | ✅ | ✅ |
| POST /api/ai/text-to-sql (INSERT/UPDATE/DELETE) | ✅ | ✅ | ❌ |

## Error Responses

### Standard Error Format

All error responses follow this format:

```json
{
  "error": "string (error type)",
  "message": "string (human-readable error message)",
  "statusCode": "number (HTTP status code)",
  "timestamp": "string (ISO 8601 datetime)",
  "path": "string (request path)"
}
```

### Common Error Codes

| Status Code | Error Type | Description |
|-------------|------------|-------------|
| 400 | Bad Request | Invalid input or malformed request |
| 401 | Unauthorized | Missing or invalid authentication token |
| 403 | Forbidden | Insufficient permissions for operation |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Resource already exists (e.g., duplicate email) |
| 413 | Payload Too Large | Request body exceeds size limit |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server error |
| 503 | Service Unavailable | Service temporarily unavailable |

### Error Response Examples

**400 Bad Request:**

```json
{
  "error": "ValidationError",
  "message": "Password must be at least 8 characters",
  "statusCode": 400,
  "timestamp": "2026-03-25T12:00:00Z",
  "path": "/api/auth/register"
}
```

**401 Unauthorized:**

```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired access token",
  "statusCode": 401,
  "timestamp": "2026-03-25T12:00:00Z",
  "path": "/api/ai/query"
}
```

**403 Forbidden:**

```json
{
  "error": "Forbidden",
  "message": "VIEWER role cannot upload documents",
  "statusCode": 403,
  "timestamp": "2026-03-25T12:00:00Z",
  "path": "/api/ai/ingest"
}
```

## Related Documentation

- [Setup Guide](SETUP_GUIDE.md) - Local development setup and testing
- [PRD and SDLC](PRD_AND_SDLC.md) - Product requirements and phases
- [Development Workflow](DEV_WORKFLOW.md) - API development standards
- [Codebase Explanation](CODEBASE_EXPLANATION.md) - API implementation details
- [Project Walkthrough](PROJECT_WALKTHROUGH.md) - End-to-end API usage flow

---

**Document Version:** 1.0.0  
**Last Updated:** Phase 1 - Project Initiation  
**Next Review:** Phase 3 - Authentication Service Implementation  
**OpenAPI Specification:** 3.0.3

