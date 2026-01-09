# GENAI-OPS Development Guide

## 🎉 Phase 1.1 - COMPLETED!

All core features for Phase 1.1 have been implemented and are ready for testing.

---

## ✅ Completed Tasks

### Frontend (React + Vite)
- ✅ Project initialization with Vite
- ✅ Design system (CSS variables, global styles, components)
- ✅ Reusable components (Button, Input, Card, Badge, Avatar, Loading)
- ✅ Login page with form validation
- ✅ Chat interface with sidebar, header, and input
- ✅ Message components (User, AI, typing indicator)
- ✅ Feedback buttons (like/dislike)
- ✅ Context API (Auth & Chat state management)
- ✅ API services (Axios with interceptors)

### Backend (Spring Boot 3)
- ✅ Project setup with Maven
- ✅ CORS configuration
- ✅ Security configuration
- ✅ Mock authentication with JWT
- ✅ Chat API endpoints
- ✅ LLM service integration (with mock fallback)
- ✅ Feedback API endpoint
- ✅ Console logging for audit trail

---

## 🚀 Getting Started

### Prerequisites

**Required:**
- Node.js 18+ and npm
- Java 17+
- Maven 3.8+

**Optional (for Phase 1.2):**
- PostgreSQL 14+
- Docker

### Installation

#### 1. Frontend Setup

```bash
cd frontend
npm install
```

Create `.env` file:
```
VITE_API_URL=http://localhost:8080
```

Start development server:
```bash
npm run dev
```

Frontend will run on: http://localhost:3000

#### 2. Backend Setup

```bash
cd backend
mvn clean install
```

Start Spring Boot application:
```bash
mvn spring-boot:run
```

Backend will run on: http://localhost:8080

---

## 🧪 Testing the Application

### 1. Login

- Navigate to http://localhost:3000
- Enter any username and password (mock auth accepts anything)
- Click "Sign In"
- You'll be redirected to the chat page

### 2. Chat with AI

- Type a message in the input field
- Press Enter or click the send button
- The AI will respond (using mock responses if LLM is not configured)
- Try these example messages:
  - "Help me with a database error"
  - "I have a connection issue"
  - "How can you help me?"

### 3. Provide Feedback

- After receiving an AI response, click "Helpful" or "Not Helpful"
- Feedback is logged to the backend console

### 4. Check Logs

Backend console will show:
```
=== CHAT LOG ===
User: testuser
Message ID: abc-123-def
Request: Help me with a database error
Response: [AI response]
Timestamp: 2025-11-20T...
================
```

---

## 📁 Project Structure

```
genai-ops/
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── common/          # Reusable UI components
│   │   │   ├── layout/          # Layout components
│   │   │   └── chat/            # Chat-specific components
│   │   ├── context/             # React Context providers
│   │   ├── pages/               # Page components
│   │   ├── services/            # API services
│   │   ├── styles/              # CSS files
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── index.html
│   ├── vite.config.js
│   └── package.json
│
├── backend/
│   └── src/main/java/com/vodafone/genaiops/
│       ├── config/              # Configuration classes
│       ├── controller/          # REST controllers
│       ├── dto/                 # Data transfer objects
│       ├── service/             # Business logic
│       ├── util/                # Utility classes
│       └── GenaiOpsApplication.java
│
├── design.md                    # UI/UX specifications
├── PRD.md                       # Product requirements
├── requirements.md              # Detailed requirements
├── tasks.md                     # Development tasks
└── README.md                    # Project overview
```

---

## 🔧 Configuration

### Frontend Environment Variables

Create `frontend/.env`:
```
VITE_API_URL=http://localhost:8080
```

### Backend Configuration

Edit `backend/src/main/resources/application.yml`:

```yaml
# LLM Configuration
llm:
  endpoint-url: http://your-llm-service/api/chat
  api-token: your-api-token
  timeout: 30000

# JWT Configuration
jwt:
  secret: your-secret-key-here
  expiration: 28800000  # 8 hours
```

---

## 🐛 Troubleshooting

### Frontend Issues

**Port 3000 already in use:**
```bash
# Change port in vite.config.js
server: {
  port: 3001
}
```

**CORS errors:**
- Ensure backend is running on port 8080
- Check CORS configuration in `backend/src/main/java/com/vodafone/genaiops/config/CorsConfig.java`

### Backend Issues

**Port 8080 already in use:**
```yaml
# Change in application.yml
server:
  port: 8081
```

**JWT errors:**
- Ensure JWT secret is at least 32 characters
- Check token in browser localStorage

---

## 📊 API Endpoints

### Authentication

**POST** `/api/auth/login`
```json
Request:
{
  "username": "testuser",
  "password": "password"
}

Response:
{
  "token": "eyJhbGc...",
  "user": {
    "id": "uuid",
    "username": "testuser",
    "groups": ["vepas_genaiops_edit"]
  }
}
```

### Chat

**POST** `/api/chat/message`
```json
Headers:
Authorization: Bearer <token>

Request:
{
  "message": "Help me with an error"
}

Response:
{
  "response": "AI response text...",
  "messageId": "uuid",
  "timestamp": "2025-11-20T..."
}
```

**POST** `/api/chat/feedback`
```json
Headers:
Authorization: Bearer <token>

Request:
{
  "messageId": "uuid",
  "feedback": "like",
  "comment": "Very helpful!"
}

Response:
{
  "success": true,
  "message": "Feedback recorded successfully"
}
```

---

## 🎨 Design System

The application follows Vodafone's design guidelines:

- **Primary Color:** #E60000 (Vodafone Red)
- **Dark Theme:** Chat interface
- **Light Theme:** Login page
- **Typography:** Inter font family
- **Components:** Custom-built, no external UI libraries

See `design.md` for complete specifications.

---

## 🔜 Next Steps (Phase 1.2)

- [ ] LDAP authentication integration
- [ ] PostgreSQL database setup
- [ ] Audit logging to database
- [ ] Feedback persistence
- [ ] Security enhancements
- [ ] Production deployment

---

## 📝 Notes

### Mock Authentication
- Phase 1.1 uses mock authentication
- Any username/password combination will work
- JWT tokens are generated but not validated against LDAP

### Mock LLM Responses
- If LLM service is not available, mock responses are used
- Mock responses include code examples and troubleshooting steps
- Configure real LLM endpoint in `application.yml`

### Console Logging
- All chat interactions are logged to console
- Feedback is logged to console
- Database logging will be added in Phase 1.2

---

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

---

## 📞 Support

For issues or questions:
- Check `tasks.md` for development status
- Review `PRD.md` for requirements
- Contact the DevOps team

---

**Version:** 1.0.0 (Phase 1.1)  
**Last Updated:** November 20, 2025  
**Status:** ✅ Ready for Testing
