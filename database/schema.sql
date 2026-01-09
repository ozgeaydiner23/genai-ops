-- GENAI-OPS Database Schema
-- PostgreSQL 14+
-- Phase 1.1: Core Chatbot (Mock Auth, No Persistence)
-- Phase 1.2: Audit Logging & Feedback Persistence

-- ============================================
-- Phase 1.1: Initial Setup (Optional)
-- ============================================
-- Note: Phase 1.1 doesn't require database tables
-- Backend uses mock authentication and doesn't persist data
-- This schema is for Phase 1.2 preparation

-- ============================================
-- Phase 1.2: Audit Logging Tables
-- ============================================

-- Users table (for tracking authenticated users)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(255) NOT NULL UNIQUE,
    display_name VARCHAR(255),
    email VARCHAR(255),
    ldap_dn TEXT,
    groups TEXT[], -- Array of LDAP groups
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);

-- Chat sessions table
CREATE TABLE IF NOT EXISTS chat_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    session_name VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP WITH TIME ZONE,
    is_active BOOLEAN DEFAULT true
);

CREATE INDEX idx_chat_sessions_user_id ON chat_sessions(user_id);
CREATE INDEX idx_chat_sessions_created_at ON chat_sessions(created_at DESC);
CREATE INDEX idx_chat_sessions_is_active ON chat_sessions(is_active);

-- Chat messages table
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES chat_sessions(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message_type VARCHAR(50) NOT NULL, -- 'USER' or 'AI'
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    llm_model VARCHAR(100), -- e.g., 'cwyd-llm-general-prod'
    llm_response_time_ms INTEGER, -- Response time in milliseconds
    tokens_used INTEGER, -- If available from LLM
    error_message TEXT -- If LLM call failed
);

CREATE INDEX idx_chat_messages_session_id ON chat_messages(session_id);
CREATE INDEX idx_chat_messages_user_id ON chat_messages(user_id);
CREATE INDEX idx_chat_messages_created_at ON chat_messages(created_at DESC);
CREATE INDEX idx_chat_messages_type ON chat_messages(message_type);

-- Feedback table
CREATE TABLE IF NOT EXISTS feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    message_id UUID NOT NULL REFERENCES chat_messages(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    feedback_type VARCHAR(20) NOT NULL, -- 'LIKE' or 'DISLIKE'
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_feedback_message_id ON feedback(message_id);
CREATE INDEX idx_feedback_user_id ON feedback(user_id);
CREATE INDEX idx_feedback_type ON feedback(feedback_type);
CREATE INDEX idx_feedback_created_at ON feedback(created_at DESC);

-- Audit logs table (comprehensive logging)
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    username VARCHAR(255) NOT NULL,
    action VARCHAR(100) NOT NULL, -- 'LOGIN', 'LOGOUT', 'SEND_MESSAGE', 'GIVE_FEEDBACK', etc.
    resource_type VARCHAR(100), -- 'SESSION', 'MESSAGE', 'FEEDBACK', etc.
    resource_id UUID,
    details JSONB, -- Additional details in JSON format
    ip_address INET,
    user_agent TEXT,
    status VARCHAR(50) DEFAULT 'SUCCESS', -- 'SUCCESS', 'FAILURE', 'ERROR'
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_username ON audit_logs(username);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at DESC);
CREATE INDEX idx_audit_logs_status ON audit_logs(status);
CREATE INDEX idx_audit_logs_details ON audit_logs USING gin(details);

-- ============================================
-- Views for Analytics
-- ============================================

-- User activity summary
CREATE OR REPLACE VIEW user_activity_summary AS
SELECT 
    u.id,
    u.username,
    u.display_name,
    COUNT(DISTINCT cs.id) as total_sessions,
    COUNT(DISTINCT cm.id) as total_messages,
    COUNT(DISTINCT f.id) as total_feedback,
    MAX(u.last_login_at) as last_login,
    MIN(cs.created_at) as first_session,
    MAX(cs.created_at) as last_session
FROM users u
LEFT JOIN chat_sessions cs ON u.id = cs.user_id
LEFT JOIN chat_messages cm ON u.id = cm.user_id
LEFT JOIN feedback f ON u.id = f.user_id
GROUP BY u.id, u.username, u.display_name;

-- Daily usage statistics
CREATE OR REPLACE VIEW daily_usage_stats AS
SELECT 
    DATE(created_at) as date,
    COUNT(DISTINCT user_id) as unique_users,
    COUNT(DISTINCT session_id) as total_sessions,
    COUNT(*) as total_messages,
    AVG(llm_response_time_ms) as avg_response_time_ms
FROM chat_messages
WHERE message_type = 'AI'
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- Feedback statistics
CREATE OR REPLACE VIEW feedback_stats AS
SELECT 
    DATE(f.created_at) as date,
    f.feedback_type,
    COUNT(*) as count,
    COUNT(DISTINCT f.user_id) as unique_users
FROM feedback f
GROUP BY DATE(f.created_at), f.feedback_type
ORDER BY date DESC, feedback_type;

-- ============================================
-- Functions
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chat_sessions_updated_at BEFORE UPDATE ON chat_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_feedback_updated_at BEFORE UPDATE ON feedback
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- Initial Data (Optional)
-- ============================================

-- Insert admin user (if using admin fallback)
INSERT INTO users (username, display_name, email, groups)
VALUES ('admin', 'System Administrator', 'admin@vodafone.com', ARRAY['admin', 'vepas_genaiops_edit'])
ON CONFLICT (username) DO NOTHING;

-- ============================================
-- Grants (Adjust based on your user)
-- ============================================

-- Grant permissions to application user
-- Replace 'genaiops_user' with your actual database user
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO genaiops_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO genaiops_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO genaiops_user;

-- Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO genaiops_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT USAGE, SELECT ON SEQUENCES TO genaiops_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT EXECUTE ON FUNCTIONS TO genaiops_user;

-- ============================================
-- Comments
-- ============================================

COMMENT ON TABLE users IS 'Authenticated users from LDAP';
COMMENT ON TABLE chat_sessions IS 'Chat sessions for organizing conversations';
COMMENT ON TABLE chat_messages IS 'Individual messages in chat sessions';
COMMENT ON TABLE feedback IS 'User feedback (like/dislike) on AI responses';
COMMENT ON TABLE audit_logs IS 'Comprehensive audit trail of all user actions';

COMMENT ON COLUMN chat_messages.message_type IS 'USER for user messages, AI for LLM responses';
COMMENT ON COLUMN chat_messages.llm_response_time_ms IS 'Time taken by LLM to generate response';
COMMENT ON COLUMN feedback.feedback_type IS 'LIKE or DISLIKE';
COMMENT ON COLUMN audit_logs.details IS 'JSON object with additional context-specific details';
