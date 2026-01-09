-- GENAI-OPS Phase 1.1 Minimal Schema
-- This is OPTIONAL for Phase 1.1 as the application doesn't persist data yet
-- Use this if you want to prepare the database structure early

-- Create database (run as postgres superuser)
-- CREATE DATABASE genaiops;

-- Create user (run as postgres superuser)
-- CREATE USER genaiops_user WITH PASSWORD 'your-secure-password';
-- GRANT ALL PRIVILEGES ON DATABASE genaiops TO genaiops_user;

-- Connect to genaiops database
-- \c genaiops

-- Grant schema permissions (PostgreSQL 15+)
GRANT ALL ON SCHEMA public TO genaiops_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO genaiops_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO genaiops_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO genaiops_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO genaiops_user;

-- Phase 1.1: No tables required
-- Backend uses:
-- - Mock authentication (no user table)
-- - In-memory chat (no persistence)
-- - Console logging (no audit table)

-- Verify connection
SELECT version();
SELECT current_database();
SELECT current_user;

-- Test table creation permission
CREATE TABLE IF NOT EXISTS test_connection (
    id SERIAL PRIMARY KEY,
    test_message VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO test_connection (test_message) VALUES ('Connection successful!');
SELECT * FROM test_connection;

-- Clean up test table
DROP TABLE test_connection;

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'Database setup complete for Phase 1.1';
    RAISE NOTICE 'User: %', current_user;
    RAISE NOTICE 'Database: %', current_database();
    RAISE NOTICE 'Phase 1.1 does not require tables - backend will create them automatically in Phase 1.2';
END $$;
