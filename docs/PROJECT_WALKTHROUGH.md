# Project Walkthrough

## Table of Contents

- [Introduction](#introduction)
- [High-Level User Journey](#high-level-user-journey)
- [Authentication and Authorization Flow](#authentication-and-authorization-flow)
- [Document Ingestion Process](#document-ingestion-process)
- [GraphRAG Query Processing Flow](#graphrag-query-processing-flow)
- [CRAG Self-Correction Mechanism](#crag-self-correction-mechanism)
- [Text-to-SQL Capability](#text-to-sql-capability)
- [SSE Streaming Response Mechanism](#sse-streaming-response-mechanism)
- [System Architecture Overview](#system-architecture-overview)
- [Related Documentation](#related-documentation)

## Introduction

Welcome to the Enterprise Insight RAG v1.0 project walkthrough! This document provides a high-level narrative of how the system works from a user's perspective. It's designed for stakeholders, product managers, and anyone who wants to understand the system without diving into technical details.

**What is Enterprise Insight RAG?**

Imagine having a conversation with your organization's entire knowledge base. Enterprise Insight RAG is an intelligent chatbot that reads your documents, understands their content, and answers questions with accurate, contextual responses. It's like having an expert assistant who has read every document in your company and can instantly recall relevant information.

**Key Capabilities:**

- **Smart Document Understanding**: Upload PDFs, images, and text files - the system extracts and understands the content
- **Intelligent Retrieval**: Finds the most relevant information using advanced AI techniques
- **Self-Correcting Accuracy**: Automatically detects and fixes retrieval errors for better answers
- **Database Queries**: Ask questions in plain English and get data from your databases
- **Real-Time Responses**: See answers appear word-by-word as they're generated
- **Secure Access**: Enterprise-grade security with role-based permissions

## High-Level User Journey

Let's follow Sarah, a financial analyst, as she uses Enterprise Insight RAG to analyze quarterly reports.

### Step 1: Opening the App

Sarah opens the Enterprise Insight RAG mobile app on her phone. She sees a clean, modern interface with a login screen.

### Step 2: Logging In

She enters her email and password. The system verifies her credentials and grants her access based on her role (USER). If she had enabled biometric authentication, she could use Face ID instead.

### Step 3: Uploading Documents

Sarah navigates to the "Documents" tab and taps "Upload". She selects the Q4 2026 Financial Report PDF from her device. The system:
- Uploads the file securely
- Extracts text from all pages
- Identifies key entities (companies, people, numbers)
- Creates a knowledge graph of relationships
- Generates embeddings for semantic search

A progress indicator shows "Processing... 45 pages analyzed". Within seconds, the document is ready.

### Step 4: Asking Questions

Sarah switches to the "Query" tab and types: "What were the key financial highlights in Q4 2026?"

The system:
- Searches through all uploaded documents
- Finds relevant sections using vector similarity
- Traverses the knowledge graph for related information
- Verifies the retrieved information is relevant (CRAG)
- Generates a comprehensive answer using AI

### Step 5: Receiving Streaming Responses

Sarah sees the answer appear word-by-word in real-time:

"The key financial highlights for Q4 2026 include: 1) Revenue increased by 15% to $50M, 2) Net profit margin improved to 22%, 3) Customer acquisition cost decreased by 10%, and 4) Annual recurring revenue reached $180M."

Below the answer, she sees the source documents with page numbers, allowing her to verify the information.

### Step 6: Asking Follow-Up Questions

Sarah asks a follow-up: "Show me the top 5 customers by revenue"

The system recognizes this as a database query, converts it to SQL, executes it safely, and presents the results in a readable format.

### Step 7: Saving and Sharing

Sarah marks this query as a favorite for quick access later. She can also share the results with her team through the app.

## Authentication and Authorization Flow

**The Challenge**: How do we ensure only authorized users can access sensitive documents?

**The Solution**: Multi-layered security with JWT tokens and role-based access control.

### Visual Flow

```
User Opens App
     │
     ▼
Enter Credentials (Email + Password)
     │
     ▼
Auth Service Validates Credentials
     │
     ├─── Invalid ──► Show Error Message
     │
     └─── Valid ──► Generate JWT Tokens
                         │
                         ▼
                    Return Tokens to App
                         │
                         ▼
                    Store Tokens Securely
                         │
                         ▼
                    User Accesses Protected Features
                         │
                         ▼
                    Include Token in API Requests
                         │
                         ▼
                    Services Verify Token & Role
                         │
                         ├─── Invalid/Expired ──► Refresh or Re-login
                         │
                         └─── Valid ──► Grant Access
```

### How It Works

1. **User Login**: User enters email and password in the mobile app

2. **Credential Verification**: Auth service checks credentials against database
   - Password is hashed and compared securely
   - Never stored or transmitted in plain text

3. **Token Generation**: If valid, system generates two JWT tokens:
   - **Access Token**: Short-lived (1 hour), used for API requests
   - **Refresh Token**: Long-lived (7 days), used to get new access tokens

4. **Token Storage**: App stores tokens securely on device
   - iOS: Keychain
   - Android: Encrypted SharedPreferences

5. **API Requests**: Every request to protected endpoints includes access token
   - Header: `Authorization: Bearer <access_token>`

6. **Token Verification**: Services verify token on each request:
   - Check signature is valid
   - Check token hasn't expired
   - Extract user ID and role

7. **Role-Based Access**: System checks if user's role allows the action:
   - **ADMIN**: Full access (user management, all documents)
   - **USER**: Upload documents, query, manage own data
   - **VIEWER**: Read-only access (query only, no upload)

8. **Token Refresh**: When access token expires:
   - App automatically uses refresh token to get new access token
   - Seamless for user (no re-login required)

9. **Session Expiry**: After 7 days, refresh token expires:
   - User must log in again
   - Ensures security even if device is lost

## Document Ingestion Process

**The Challenge**: How do we make diverse document types (PDFs, images, tables) searchable and understandable by AI?

**The Solution**: Multi-stage processing pipeline that extracts, chunks, embeds, and indexes content.

### Visual Flow

```
User Uploads Document (PDF/Image/Text)
     │
     ▼
AI Service Receives File
     │
     ▼
Extract Text Content
     │
     ├─── PDF ──► PyPDF2 extracts text from pages
     ├─── Image ──► OCR (pytesseract) recognizes text
     └─── Text ──► Read directly
     │
     ▼
Split into Chunks (512 tokens with 50 token overlap)
     │
     ▼
Generate Embeddings (384-dimensional vectors)
     │
     ▼
Store in PostgreSQL with pgvector
     │
     ▼
Extract Entities & Relationships
     │
     ▼
Build Knowledge Graph in Neo4j
     │
     ▼
Return Success with Document ID
```

### How It Works

1. **Upload**: User selects document in mobile app and taps "Upload"

2. **Transfer**: File is sent securely to AI service via HTTPS

3. **Text Extraction**:
   - **PDFs**: PyPDF2 library extracts text from each page, preserving layout
   - **Images**: Tesseract OCR recognizes text from images (supports 100+ languages)
   - **Text Files**: Read directly without processing

4. **Chunking**: Long documents are split into manageable chunks:
   - Each chunk is ~512 tokens (roughly 2-3 paragraphs)
   - 50-token overlap between chunks ensures context isn't lost
   - Preserves sentence boundaries (doesn't split mid-sentence)

5. **Embedding Generation**: Each chunk is converted to a vector:
   - Uses sentence-transformers model (all-MiniLM-L6-v2)
   - Produces 384-dimensional vector representing semantic meaning
   - Similar content has similar vectors (enables semantic search)

6. **Vector Storage**: Embeddings stored in PostgreSQL:
   - pgvector extension enables efficient similarity search
   - HNSW index for fast approximate nearest neighbor queries
   - Linked to original document and chunk text

7. **Entity Extraction** (GraphRAG):
   - NLP model identifies entities: people, organizations, locations, dates, numbers
   - Example: "Apple Inc. reported $50M revenue" → Entities: [Apple Inc., $50M]

8. **Relationship Extraction** (GraphRAG):
   - Identifies relationships between entities
   - Example: "Apple Inc. reported $50M revenue" → Relationship: (Apple Inc.) -[REPORTED]-> ($50M)

9. **Knowledge Graph Construction**:
   - Entities become nodes in Neo4j graph database
   - Relationships become edges connecting nodes
   - Enables complex reasoning across documents

10. **Confirmation**: User sees "Document processed successfully" with:
    - Number of pages/chunks created
    - Number of entities extracted
    - Processing time

## GraphRAG Query Processing Flow

**The Challenge**: How do we find relevant information when it's spread across multiple documents and requires understanding relationships?

**The Solution**: Graph-based retrieval that traverses relationships between entities for multi-hop reasoning.

### Visual Flow

```
User Asks Question
     │
     ▼
Identify Key Entities in Question
     │
     ▼
Search Knowledge Graph for Matching Entities
     │
     ▼
Traverse Relationships (Multi-Hop)
     │
     ▼
Collect Connected Entities & Documents
     │
     ▼
Retrieve Relevant Text Chunks
     │
     ▼
Rank by Relevance
     │
     ▼
Generate Answer with LLM
     │
     ▼
Return Answer with Sources
```

### How It Works

1. **Question Analysis**: User asks "How did Apple's revenue compare to Microsoft's in Q4?"

2. **Entity Identification**: System identifies key entities:
   - Companies: Apple, Microsoft
   - Time: Q4
   - Metric: Revenue

3. **Graph Search**: Query Neo4j for these entities:
   ```cypher
   MATCH (c:Company)-[r:REPORTED]->(rev:Revenue)
   WHERE c.name IN ['Apple', 'Microsoft']
   AND rev.period = 'Q4'
   RETURN c, r, rev
   ```

4. **Relationship Traversal**: Follow connections:
   - Apple → REPORTED → $50M (Q4)
   - Microsoft → REPORTED → $45M (Q4)
   - Both → COMPETES_WITH → Each other

5. **Context Gathering**: Collect related information:
   - Revenue figures
   - Growth percentages
   - Market share data
   - Historical comparisons

6. **Document Retrieval**: Get original text chunks:
   - Find chunks mentioning these entities
   - Retrieve surrounding context
   - Include page numbers for citation

7. **Ranking**: Score chunks by relevance:
   - Direct mentions score higher
   - Recent data scores higher
   - Multiple entity mentions score higher

8. **Answer Generation**: LLM synthesizes answer:
   - Combines information from multiple sources
   - Provides comparative analysis
   - Cites specific documents and pages

9. **Response**: User sees:
   "Apple reported $50M in Q4 revenue, a 15% increase, while Microsoft reported $45M, a 12% increase. Apple outperformed Microsoft by $5M this quarter."
   
   Sources:
   - Q4 Financial Report (Apple), Page 3
   - Q4 Financial Report (Microsoft), Page 5

## CRAG Self-Correction Mechanism

**The Challenge**: Sometimes the retrieved information isn't relevant or sufficient to answer the question accurately.

**The Solution**: Corrective RAG evaluates retrieval quality and automatically triggers corrective strategies.

### Visual Flow

```
Retrieve Initial Documents
     │
     ▼
Evaluate Retrieval Quality
     │
     ├─── High Confidence ──► Use Retrieved Docs
     │
     └─── Low Confidence ──► Trigger Correction
                                   │
                                   ▼
                              Corrective Strategies:
                              1. Expand Query
                              2. Search Different Index
                              3. Increase Top-K
                              4. Use Graph Traversal
                                   │
                                   ▼
                              Retrieve Again
                                   │
                                   ▼
                              Re-Evaluate Quality
                                   │
                                   ▼
                              Generate Answer
```

### How It Works

1. **Initial Retrieval**: System retrieves top 5 most similar documents

2. **Quality Evaluation**: Evaluator agent scores retrieval:
   - Checks if documents contain query keywords
   - Measures semantic similarity
   - Verifies temporal relevance (recent vs. old data)
   - Assigns confidence score (0-1)

3. **Decision Point**:
   - **High Confidence (>0.8)**: Proceed with retrieved documents
   - **Medium Confidence (0.5-0.8)**: Apply light correction
   - **Low Confidence (<0.5)**: Apply aggressive correction

4. **Corrective Strategies**:

   **Strategy 1: Query Expansion**
   - Add synonyms and related terms
   - Example: "revenue" → "revenue, income, earnings, sales"

   **Strategy 2: Different Retrieval Mode**
   - Switch from vector search to graph traversal
   - Or combine both (hybrid retrieval)

   **Strategy 3: Increase Top-K**
   - Retrieve more documents (top 10 instead of top 5)
   - Cast wider net for relevant information

   **Strategy 4: Temporal Filtering**
   - Focus on recent documents if query is time-sensitive
   - Example: "latest" → filter to last 3 months

5. **Re-Retrieval**: Execute corrective strategy and get new documents

6. **Re-Evaluation**: Score new retrieval:
   - If improved, use new documents
   - If still low, inform user that information may be limited

7. **Answer Generation**: Generate answer with confidence indicator:
   - High confidence: "Based on the documents..."
   - Medium confidence: "The available information suggests..."
   - Low confidence: "I found limited information, but..."

8. **User Feedback**: User sees confidence score and can:
   - Accept answer
   - Rephrase question
   - Upload more documents

## Text-to-SQL Capability

**The Challenge**: Users want to query structured data in databases using natural language, not SQL.

**The Solution**: AI-powered translation from natural language to safe, executable SQL queries.

### Visual Flow

```
User Asks Question in Natural Language
     │
     ▼
Parse Question & Identify Intent
     │
     ▼
Generate SQL Query
     │
     ▼
Validate SQL for Safety
     │
     ├─── Unsafe (DROP, DELETE, etc.) ──► Block & Warn User
     │
     └─── Safe (SELECT) ──► Execute Query
                                 │
                                 ▼
                            Fetch Results
                                 │
                                 ▼
                            Format Results
                                 │
                                 ▼
                            Generate Explanation
                                 │
                                 ▼
                            Return to User
```

### How It Works

1. **Natural Language Question**: User asks "Show me the top 5 customers by revenue in 2026"

2. **Intent Recognition**: System identifies:
   - Action: SELECT (retrieve data)
   - Entity: Customers
   - Metric: Revenue
   - Filter: Year 2026
   - Limit: Top 5

3. **SQL Generation**: LLM generates SQL:
   ```sql
   SELECT customer_name, SUM(revenue) as total_revenue
   FROM sales
   WHERE EXTRACT(YEAR FROM sale_date) = 2026
   GROUP BY customer_name
   ORDER BY total_revenue DESC
   LIMIT 5;
   ```

4. **Safety Validation**: System checks:
   - ✅ Only SELECT allowed (no INSERT, UPDATE, DELETE)
   - ✅ No DROP, TRUNCATE, ALTER commands
   - ✅ No multiple statements (prevents SQL injection)
   - ✅ Query timeout set (30 seconds max)
   - ✅ Result limit (max 1000 rows)

5. **Role-Based Restrictions**:
   - **VIEWER**: Only SELECT queries allowed
   - **USER**: SELECT, INSERT, UPDATE allowed
   - **ADMIN**: All operations allowed (with caution)

6. **Query Execution**: Run SQL against PostgreSQL database

7. **Result Formatting**: Convert raw data to readable format:
   ```
   Top 5 Customers by Revenue (2026):
   1. Acme Corp - $1,250,000
   2. TechStart Inc - $980,000
   3. Global Solutions - $875,000
   4. Innovation Labs - $720,000
   5. Digital Dynamics - $650,000
   ```

8. **Explanation Generation**: LLM creates human-readable summary:
   "The top 5 customers by revenue in 2026 are Acme Corp ($1.25M), TechStart Inc ($980K), Global Solutions ($875K), Innovation Labs ($720K), and Digital Dynamics ($650K). Acme Corp leads with 27% more revenue than the second-place customer."

9. **User Response**: User sees:
   - Formatted results table
   - Human-readable explanation
   - Generated SQL (for transparency)
   - Execution time

## SSE Streaming Response Mechanism

**The Challenge**: Users don't want to wait 10-20 seconds for a complete answer - they want to see progress in real-time.

**The Solution**: Server-Sent Events (SSE) stream tokens as they're generated, providing immediate feedback.

### Visual Flow

```
User Submits Query
     │
     ▼
Establish SSE Connection
     │
     ▼
Send "start" Event
     │
     ▼
Retrieve Documents (send "retrieval" event)
     │
     ▼
Generate Answer Token-by-Token
     │
     ├─── Token 1 ──► Send "token" event ──► Display in UI
     ├─── Token 2 ──► Send "token" event ──► Display in UI
     ├─── Token 3 ──► Send "token" event ──► Display in UI
     └─── ...
     │
     ▼
Send "sources" Event (with citations)
     │
     ▼
Send "end" Event (with metadata)
     │
     ▼
Close Connection
```

### How It Works

1. **Connection Establishment**: Mobile app opens SSE connection:
   ```
   GET /api/ai/stream?query=What+were+the+key+highlights
   Accept: text/event-stream
   Authorization: Bearer <token>
   ```

2. **Start Event**: Server sends confirmation:
   ```
   event: start
   data: {"queryId":"123","status":"started"}
   ```

3. **Retrieval Event**: Server indicates document search:
   ```
   event: retrieval
   data: {"status":"retrieving","documentsFound":5}
   ```
   
   UI shows: "Searching documents..."

4. **Token Streaming**: LLM generates answer word-by-word:
   ```
   event: token
   data: {"token":"The"}
   
   event: token
   data: {"token":" key"}
   
   event: token
   data: {"token":" financial"}
   
   event: token
   data: {"token":" highlights"}
   ```
   
   UI displays: "The key financial highlights" (updates in real-time)

5. **Sources Event**: After answer completes, send citations:
   ```
   event: sources
   data: {"sources":[{"title":"Q4 Report","page":3,"score":0.92}]}
   ```

6. **End Event**: Signal completion:
   ```
   event: end
   data: {"status":"completed","totalTokens":87,"totalTime":2150}
   ```

7. **Connection Management**:
   - Heartbeat every 30 seconds to keep connection alive
   - Automatic reconnection if connection drops
   - Maximum 3 concurrent connections per user
   - 5-minute timeout for inactive connections

8. **User Experience**:
   - Sees answer appear word-by-word (like ChatGPT)
   - Can cancel query mid-stream if needed
   - Progress indicator shows retrieval status
   - Sources appear after answer completes

## System Architecture Overview

Here's how all the pieces fit together:

```
┌─────────────────────────────────────────────────────────────────┐
│                        User Devices                             │
│  ┌──────────────────┐              ┌──────────────────┐        │
│  │  Mobile App      │              │   Web App        │        │
│  │  (React Native)  │              │   (Next.js)      │        │
│  │                  │              │   [Future]       │        │
│  │  - Login/Register│              │                  │        │
│  │  - Upload Docs   │              │                  │        │
│  │  - Query/Stream  │              │                  │        │
│  │  - View History  │              │                  │        │
│  └────────┬─────────┘              └────────┬─────────┘        │
└───────────┼────────────────────────────────┼──────────────────┘
            │         HTTPS/JWT              │
            │                                │
┌───────────┼────────────────────────────────┼──────────────────┐
│           │         Backend Services       │                  │
│  ┌────────▼─────────┐          ┌──────────▼────────┐         │
│  │  Auth Service    │          │   AI Service      │         │
│  │  (Spring Boot)   │          │   (FastAPI)       │         │
│  │                  │          │                   │         │
│  │  - User Mgmt     │          │   - Ingestion    │         │
│  │  - JWT Tokens    │          │   - RAG Query    │         │
│  │  - RBAC          │          │   - GraphRAG     │         │
│  │                  │          │   - CRAG         │         │
│  │                  │          │   - Text-to-SQL  │         │
│  │                  │          │   - SSE Stream   │         │
│  └────────┬─────────┘          └──────────┬────────┘         │
└───────────┼───────────────────────────────┼──────────────────┘
            │         Database Layer        │
┌───────────┼───────────────────────────────┼──────────────────┐
│  ┌────────▼─────────┐  ┌────────────────▼────────┐         │
│  │   PostgreSQL     │  │   PostgreSQL             │         │
│  │   (Auth DB)      │  │   (AI DB + pgvector)     │         │
│  │                  │  │                          │         │
│  │  - Users         │  │  - Documents             │         │
│  │  - Roles         │  │  - Embeddings            │         │
│  │  - Tokens        │  │  - Vector Search         │         │
│  └──────────────────┘  └──────────────────────────┘         │
│                                                              │
│  ┌──────────────────┐          ┌──────────────────┐        │
│  │     Neo4j        │          │      Redis       │        │
│  │  (Knowledge      │          │   (Cache)        │        │
│  │   Graph)         │          │                  │        │
│  │                  │          │  - Session Store │        │
│  │  - Entities      │          │  - Query Cache   │        │
│  │  - Relationships │          │  - Rate Limiting │        │
│  │  - Graph Queries │          │                  │        │
│  └──────────────────┘          └──────────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow Example

Let's trace a complete query from start to finish:

1. **User opens app** → Mobile client loads
2. **User logs in** → Auth service validates → Returns JWT tokens
3. **User uploads PDF** → AI service receives file
4. **AI service processes**:
   - Extracts text (PyPDF2)
   - Chunks text
   - Generates embeddings (sentence-transformers)
   - Stores in PostgreSQL (pgvector)
   - Extracts entities/relationships
   - Builds graph in Neo4j
5. **User asks question** → AI service receives query
6. **AI service retrieves**:
   - Vector search in PostgreSQL
   - Graph traversal in Neo4j
   - Hybrid ranking
7. **CRAG evaluates** → Triggers correction if needed
8. **LLM generates answer** → Streams via SSE
9. **Mobile app displays** → User sees answer word-by-word
10. **User saves to history** → Stored in PostgreSQL

## Related Documentation

- [API Contracts](API_CONTRACTS.md) - Technical API specifications
- [Architecture Decisions](ARCHITECTURE_DECISIONS.md) - Why we chose these technologies
- [PRD and SDLC](PRD_AND_SDLC.md) - Product requirements and phases
- [Codebase Explanation](CODEBASE_EXPLANATION.md) - Implementation details

---

**Document Version:** 1.0.0  
**Last Updated:** Phase 1 - Project Initiation  
**Next Review:** Phase 7 - After full implementation  
**Audience:** Stakeholders, Product Managers, Business Users

