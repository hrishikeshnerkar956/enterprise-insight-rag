#!/bin/bash
# Enterprise Insight RAG v1.0 - PostgreSQL Initialization Script
# Phase 2: DevOps & Infrastructure
# This script initializes the PostgreSQL database with schema and seed data
# It is idempotent and safe to run multiple times

set -e

echo "========================================="
echo "Initializing PostgreSQL database..."
echo "========================================="

# Create pgvector extension and database schema
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Enable pgvector extension for vector similarity search
    CREATE EXTENSION IF NOT EXISTS vector;
    
    -- =========================================================================
    -- Roles Table
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS roles (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50) UNIQUE NOT NULL,
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    
    -- =========================================================================
    -- Users Table
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        email VARCHAR(255) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role_id INTEGER REFERENCES roles(id),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    
    -- =========================================================================
    -- Documents Table
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS documents (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
        title VARCHAR(500) NOT NULL,
        content TEXT,
        file_path VARCHAR(1000),
        file_type VARCHAR(50),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    
    -- =========================================================================
    -- Embeddings Table with Vector Column
    -- =========================================================================
    CREATE TABLE IF NOT EXISTS embeddings (
        id SERIAL PRIMARY KEY,
        document_id INTEGER REFERENCES documents(id) ON DELETE CASCADE,
        chunk_text TEXT NOT NULL,
        embedding vector(1536),  -- OpenAI ada-002 embedding dimension
        chunk_index INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    
    -- =========================================================================
    -- Indexes for Performance
    -- =========================================================================
    
    -- Users table indexes
    CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
    CREATE INDEX IF NOT EXISTS idx_users_role_id ON users(role_id);
    
    -- Documents table indexes
    CREATE INDEX IF NOT EXISTS idx_documents_user_id ON documents(user_id);
    CREATE INDEX IF NOT EXISTS idx_documents_created_at ON documents(created_at);
    
    -- Embeddings table indexes
    CREATE INDEX IF NOT EXISTS idx_embeddings_document_id ON embeddings(document_id);
    
    -- HNSW index for fast vector similarity search
    -- Parameters: m=16 (max connections per layer), ef_construction=64 (search quality)
    CREATE INDEX IF NOT EXISTS idx_embeddings_vector 
    ON embeddings USING hnsw (embedding vector_cosine_ops)
    WITH (m = 16, ef_construction = 64);
    
    -- =========================================================================
    -- Seed Data - Insert Default Roles
    -- =========================================================================
    INSERT INTO roles (name, description) VALUES
        ('ADMIN', 'Full system access including user management and system configuration'),
        ('USER', 'Standard user with document upload, query, and personal data management'),
        ('VIEWER', 'Read-only access to shared documents and queries')
    ON CONFLICT (name) DO NOTHING;
    
EOSQL

echo "========================================="
echo "PostgreSQL initialization complete!"
echo "========================================="
echo "Created tables: roles, users, documents, embeddings"
echo "Created indexes: 6 standard indexes + 1 HNSW vector index"
echo "Inserted seed data: 3 roles (ADMIN, USER, VIEWER)"
echo "========================================="
