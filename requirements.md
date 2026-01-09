# GENAI-OPS Requirements Specification

## Project Overview

GENAI-OPS is an AI-powered operations assistant chatbot system for handling customer complaints. This document outlines the requirements for Phase 1 development.

---

## Phase 1.1 - Core Chatbot Interface (Initial Development)

### Functional Requirements

#### FR-1.1.1: User Authentication (Mock)
- **Priority:** High
- **Description:** Implement basic login functionality with mock authentication
- **Acceptance Criteria:**
  - User can enter username and password
  - System validates credentials against hardcoded values
  - Successful login generates a mock JWT token
  - Token is stored in localStorage
  - User is redirected to chat page after successful login
  - Error messages displayed for invalid credentials

#### FR-1.1.2: Chat Interface
- **Priority:** High
- **Description:** Implement main chatbot interface with message display
- **Acceptance Criteria:**
  - User can type and send messages
  - Messages are displayed in chat bubbles (user on right, AI on left)
  - Chat history is maintained during session
  - Loading indicator shown while waiting for AI response
  - Messages are scrollable
  - Auto-scroll to latest message

#### FR-1.1.3: LLM Integration
- **Priority:** High
- **Description:** Connect backend to LLM service for AI responses
- **Acceptance Criteria:**
  - Backend sends user messages to LLM endpoint
  - LLM responses are received and parsed
  - Responses are returned to frontend
  - Timeout handling (30 seconds)
  - Error handling for LLM failures
  - Request/response logged to console

#### FR-1.1.4: Feedback Mechanism (UI Only)
- **Priority:** Medium
- **Description:** Display feedback buttons for each AI response
- **Acceptance Criteria:**
  - "Like" and "Dislike" buttons shown under each AI message
  - Button state changes on click (visual feedback)
  - Feedback sent to backend
  - Backend logs feedback to console
  - Success notification shown to user

#### FR-1.1.5: Session Management
- **Priority:** Medium
- **Description:** Maintain user session during chat
- **Acceptance Criteria:**
  - Token validated on each API request
  - Session expires after inactivity
  - User redirected to login on session expiry
  - Chat history cleared on logout

### Non-Functional Requirements

#### NFR-1.1.1: Performance
- Login response time < 2 seconds
- Chat message response time < 5 seconds (LLM dependent)
- Frontend load time < 3 seconds
- Smooth UI animations (60fps)

#### NFR-1.1.2: UI/UX
- Follow design.md specifications exactly
- Vodafone brand colors (#E60000 primary)
- Dark theme for chat interface
- Light theme for login page
- Responsive design (desktop focus, 1024px+)
- Accessibility compliant (WCAG 2.1 AA)

#### NFR-1.1.3: Code Quality
- Clean, maintainable code
- Component-based architecture
- Reusable UI components
- CSS variables for theming
- Proper error handling
- Console logging for debugging

---

## Phase 1.2 - Authentication & Logging Integration

### Functional Requirements

#### FR-1.2.1: LDAP Authentication
- **Priority:** High
- **Description:** Replace mock authentication with LDAP integration
- **Acceptance Criteria:**
  - Backend connects to LDAP server
  - User credentials validated against LDAP
  - Group membership checked (vepas_genaiops_edit)
  - Real JWT token generated with user info
  - Token includes user ID, username, groups
  - LDAP connection errors handled gracefully

#### FR-1.2.2: Database Setup
- **Priority:** High
- **Description:** Set up PostgreSQL database for audit logs
- **Acceptance Criteria:**
  - PostgreSQL instance deployed
  - audit_logs table created with proper schema
  - Indexes created for performance
  - Connection pooling configured
  - Database credentials stored in OpenShift Secrets

#### FR-1.2.3: Audit Logging
- **Priority:** High
- **Description:** Log all chat interactions to database
- **Acceptance Criteria:**
  - Each message exchange logged to audit_logs table
  - Logs include: user_id, username, request, response, timestamps
  - Logging is asynchronous (non-blocking)
  - Failed logs don't break user experience
  - Logs queryable for analytics

#### FR-1.2.4: Feedback Persistence
- **Priority:** Medium
- **Description:** Store user feedback in database
- **Acceptance Criteria:**
  - Feedback updates corresponding audit log record
  - Feedback includes: like/dislike, optional comment
  - Feedback timestamp recorded
  - Multiple feedback updates handled correctly

#### FR-1.2.5: Security Enhancements
- **Priority:** High
- **Description:** Implement production-ready security
- **Acceptance Criteria:**
  - JWT tokens properly signed and validated
  - Token expiration enforced (8 hours)
  - HTTPS/TLS encryption enabled
  - SQL injection prevention (JPA/Hibernate)
  - XSS protection on inputs
  - CORS configured properly
  - Secrets encrypted in OpenShift

---

## Success Criteria

### Phase 1.1
- [ ] User can login with mock credentials
- [ ] User can send messages and receive AI responses
- [ ] Chat interface matches design.md specifications
- [ ] Feedback buttons are functional (UI only)
- [ ] No critical bugs or crashes
- [ ] Code is clean and maintainable

### Phase 1.2
- [ ] LDAP authentication working
- [ ] All interactions logged to PostgreSQL
- [ ] Feedback stored in database
- [ ] JWT tokens properly validated
- [ ] System runs stable on OpenShift
- [ ] Security best practices implemented

---

**Document Version:** 1.0  
**Last Updated:** November 20, 2025
