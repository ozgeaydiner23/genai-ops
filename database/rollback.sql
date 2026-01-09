-- GENAI-OPS Database Rollback Script
-- Use this to clean up the database if needed

-- WARNING: This will delete ALL data!
-- Make sure you have a backup before running this script

-- Drop views first (they depend on tables)
DROP VIEW IF EXISTS feedback_stats CASCADE;
DROP VIEW IF EXISTS daily_usage_stats CASCADE;
DROP VIEW IF EXISTS user_activity_summary CASCADE;

-- Drop triggers
DROP TRIGGER IF EXISTS update_feedback_updated_at ON feedback;
DROP TRIGGER IF EXISTS update_chat_sessions_updated_at ON chat_sessions;
DROP TRIGGER IF EXISTS update_users_updated_at ON users;

-- Drop functions
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;

-- Drop tables (in reverse order of dependencies)
DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS feedback CASCADE;
DROP TABLE IF EXISTS chat_messages CASCADE;
DROP TABLE IF EXISTS chat_sessions CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Verify cleanup
SELECT 
    schemaname,
    tablename 
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'Database rollback complete';
    RAISE NOTICE 'All GENAI-OPS tables, views, and functions have been dropped';
END $$;
