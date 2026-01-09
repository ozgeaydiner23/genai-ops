# GENAI-OPS - AI Operations Assistant

Enterprise-grade AI-powered chatbot system for handling customer complaints, built with React and Spring Boot.

## 🚀 Project Overview

GENAI-OPS is a modern web application that leverages Large Language Models (LLM) and RAG (Retrieval-Augmented Generation) to provide intelligent responses to customer service queries. The system features a clean, professional interface following Vodafone's corporate design guidelines.

## 📋 Documentation

- **[PRD.md](./PRD.md)** - Product Requirements Document
- **[design.md](./design.md)** - UI/UX Design System Specifications
- **[requirements.md](./requirements.md)** - Functional & Non-Functional Requirements
- **[tasks.md](./tasks.md)** - Development Task Breakdown
- **[DOCKER.md](./DOCKER.md)** - Docker Installation & Usage Guide
- **[INSTALLATION.md](./INSTALLATION.md)** - Manual Installation Guide
- **[DEVELOPMENT.md](./DEVELOPMENT.md)** - Development Guide
- **[CONFIGURATION.md](./CONFIGURATION.md)** - Configuration Management Guide
- **[LLM-INTEGRATION.md](./LLM-INTEGRATION.md)** - LLM Service Integration Guide
- **[VODAFONE-LLM-API.md](./VODAFONE-LLM-API.md)** - Vodafone Practicus LLM API Guide
- **[VPARA-LDAP-SETUP.md](./VPARA-LDAP-SETUP.md)** - Vpara Active Directory LDAP Setup
- **[EXTERNAL-DATABASE-SETUP.md](./EXTERNAL-DATABASE-SETUP.md)** - External PostgreSQL Database Setup
- **[GITHUB-WORKFLOW-SETUP.md](./GITHUB-WORKFLOW-SETUP.md)** - GitHub Actions CI/CD Setup
- **[deployment/DEPLOYMENT.md](./deployment/DEPLOYMENT.md)** - OpenShift Deployment Guide

## 🏗️ Architecture

### Frontend
- **Framework:** React 18.x
- **Build Tool:** Vite
- **Styling:** Custom CSS (Vodafone design system)
- **State Management:** React Context API
- **HTTP Client:** Axios

### Backend
- **Framework:** Spring Boot 3.x
- **Language:** Java 17
- **Database:** PostgreSQL
- **Authentication:** Spring Security + LDAP + JWT
- **ORM:** Spring Data JPA

### Infrastructure
- **Platform:** OpenShift/Kubernetes
- **CI/CD:** GitHub Actions
- **Configuration:** ConfigMap & Secrets
- **Load Balancer:** https://genaiops.vpara.local

## 📦 Project Structure

```
genai-ops/
├── frontend/              # React frontend application
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── pages/         # Page components
│   │   ├── context/       # Context providers
│   │   ├── services/      # API services
│   │   ├── styles/        # CSS files
│   │   └── utils/         # Utilities
│   ├── public/            # Static assets
│   └── package.json
│
├── backend/               # Spring Boot backend API
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/      # Java source code
│   │   │   └── resources/ # Configuration files
│   │   └── test/          # Test files
│   └── pom.xml
│
├── deployment/            # Kubernetes/OpenShift manifests
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   └── service.yaml
│
├── .github/
│   └── workflows/         # CI/CD pipelines
│
├── design.md              # Design system specifications
├── PRD.md                 # Product requirements
├── requirements.md        # Detailed requirements
├── tasks.md               # Development tasks
└── README.md              # This file
```

## 🎯 Development Phases

### Phase 1.1 - Core Chatbot Interface ✅
- [x] Project initialization
- [ ] Mock authentication
- [ ] Chat interface
- [ ] LLM integration
- [ ] Feedback UI
- [ ] Basic deployment

### Phase 1.2 - Authentication & Logging
- [ ] LDAP integration
- [ ] PostgreSQL setup
- [ ] Audit logging
- [ ] Feedback persistence
- [ ] Security enhancements
- [ ] Production deployment

### Phase 2 - Case Management (Future)
- [ ] Dcase system integration
- [ ] Ticket management
- [ ] Case tracking

### Phase 3 - Agentic AI (Future)
- [ ] Automated solutions
- [ ] Workflow engine
- [ ] Advanced AI features

## 🚦 Getting Started

### Option 1: Docker (Önerilen) 🐳

En kolay ve hızlı yöntem! Sadece Docker Desktop gerekli.

```bash
# Tüm servisleri başlat (PostgreSQL + Backend + Frontend)
docker-compose up --build

# Arka planda çalıştır
docker-compose up -d
```

- Frontend: http://localhost:3000
- Backend: http://localhost:8080
- PostgreSQL: localhost:5432

Detaylı bilgi için: **[DOCKER.md](./DOCKER.md)**

---

### Option 2: Manuel Kurulum

#### Prerequisites

- **Node.js** 18+ and npm
- **Java** 17+
- **Maven** 3.8+
- **PostgreSQL** 14+ (for Phase 1.2)

#### Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

Frontend runs on http://localhost:3000

#### Backend Setup

```bash
cd backend
mvn clean install
mvn spring-boot:run
```

Backend runs on http://localhost:8080

Detaylı bilgi için: **[INSTALLATION.md](./INSTALLATION.md)**

### Environment Configuration

Create `.env` files in frontend and backend directories:

**Frontend `.env`:**
```
VITE_API_URL=http://localhost:8080
```

**Backend environment variables:**
```
LLM_ENDPOINT_URL=http://llm-service/api/chat
LLM_API_TOKEN=your-token
JWT_SECRET=your-secret
```

## 🎨 Design System

The application follows a comprehensive design system based on Vodafone's corporate identity:

- **Primary Color:** Vodafone Red (#E60000)
- **Theme:** Dark mode for chat, light mode for login
- **Typography:** Inter font family
- **Components:** Custom-built following design.md specifications
- **Effects:** Glassmorphism, smooth animations, subtle shadows

See [design.md](./design.md) for complete specifications.

## 🔒 Security

- JWT-based authentication
- LDAP integration for user management
- Group-based authorization
- HTTPS/TLS encryption
- SQL injection prevention
- XSS protection
- CORS configuration

## 📊 Monitoring & Logging

- Structured JSON logging
- Audit trail for all interactions
- Performance metrics
- Error tracking
- User activity monitoring

## 🧪 Testing

### Frontend Tests
```bash
cd frontend
npm test
```

### Backend Tests
```bash
cd backend
mvn test
```

## 🐳 Docker

### Build Images

```bash
# Frontend
cd frontend
docker build -t genai-ops-frontend:latest .

# Backend
cd backend
docker build -t genai-ops-backend:latest .
```

### Run with Docker Compose

```bash
docker-compose up
```

## 🚀 Deployment

### OpenShift Deployment

```bash
# Apply configurations
oc apply -f deployment/configmap.yaml
oc apply -f deployment/secret.yaml
oc apply -f deployment/deployment.yaml
oc apply -f deployment/service.yaml
oc apply -f deployment/route.yaml
```

### CI/CD Pipeline

GitHub Actions automatically builds and deploys on push to `main` branch.

## 📝 API Documentation

API documentation is available at:
- Swagger UI: http://localhost:8080/swagger-ui.html
- OpenAPI Spec: http://localhost:8080/v3/api-docs

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Write/update tests
4. Submit a pull request

## 📄 License

Internal Vodafone Project - Proprietary

## 👥 Team

- **DevOps Team** - Infrastructure & Deployment
- **AI Team** - LLM Integration
- **Development Team** - Application Development

## 📞 Support

For issues and questions, contact the DevOps team.

---

**Version:** 1.0.0  
**Last Updated:** November 20, 2025  
**Status:** Phase 1.1 In Development
